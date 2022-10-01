local lastVeh = nil
local isVehOwned = nil
local ESX = nil
local QBCore = nil

if Config.useFramework == "esx" then
	CreateThread(function()
		ESX = exports["es_extended"]:getSharedObject()
	end)
end

if Config.useFramework == "qbcore" then
	QBCore = exports['qb-core']:GetCoreObject()
end

-- Functions

local function getMessageStyle(style)
	return style == "error" and "~r~" or style == "success" and "~g~" or style == "info" and "~b~" or ""
end

local function createNotification(msg, style)
	if not Config.messageService or Config.messageService == "none" or Config.messageService == "" or Config.messageService == nil then
		return
	end

	if Config.messageService == "rr_notify" then
		exports.rr_notify:notify({
			msg = msg,
			style = style,
			title = style,
			progress = false
		})
		return
	end

	if Config.messageService == "esx" then
		local msgStyle = getMessageStyle(style)
		ESX.ShowNotification(msgStyle .. msg .. msgStyle)
		return
	end

	if Config.messageService == "default" then
		local msgStyle = getMessageStyle(style)
		SetNotificationTextEntry('STRING')
		AddTextComponentString(msgStyle .. msg .. msgStyle)
		DrawNotification(0,1)
		return
	end

	if Config.messageService == "qbcore" then
		QBCore.Functions.Notify(msg, style == "info" and "primary" or style)
	end
end

local function toggleLockVehicle(lock)
	local vehicle = GetLastDrivenVehicle()

	if lock == "lock" then
		SetVehicleDoorsLocked(vehicle, 2)
	else
		SetVehicleDoorsLocked(vehicle, 1)
	end

	SendNUIMessage({
		type = "playSound",
		volume = 0.4,
		file = lock
	})

	SetVehicleLights(vehicle, 2)
	Wait (200)
	SetVehicleLights(vehicle, 0)
	Wait (200)
	SetVehicleLights(vehicle, 2)
	Wait (400)
	SetVehicleLights(vehicle, 0)
end

local function checkLock(lock)
	local vehicle = GetLastDrivenVehicle()
	if vehicle == lastVeh and isVehOwned then
		toggleLockVehicle(lock)
		return
	end
	lastVeh = vehicle
	local hasKey = false
	local plate = GetVehicleNumberPlateText(vehicle)

  	if Config.useKeySystem and Config.useFramework == "esx" then
		ESX.TriggerServerCallback("rr_keyfob:isOwner", function(value)
			hasKey = value

			if not hasKey then
				createNotification(Config.Locales["no_key"], "error")
				return
			end

			toggleLockVehicle(lock)
		end, vehicle, plate)
  	elseif Config.useKeySystem and Config.useFramework == "qbcore" then
		QBCore.Functions.TriggerCallback("rr_keyfob:isOwner", function(value)
			hasKey = value

			if not hasKey then
				createNotification(Config.Locales["no_key"], "error")
				return
			end

			toggleLockVehicle(lock)
		end, vehicle, plate)
	else
		toggleLockVehicle(lock)
	end
	isVehOwned = hasKey
end

-- Prevent the starting of the engine if you get into the car
CreateThread(function()
	while Config.preventDefaultEngineStart do
		local sleep = 100
		local ped = PlayerPedId()
		local vehicle = GetVehiclePedIsTryingToEnter(ped)
		local isEngineOn = GetIsVehicleEngineRunning(vehicle)
		if vehicle then
			sleep = 10
			SetVehicleEngineOn(vehicle, isEngineOn, false, true)
		end
		Wait(sleep)
	end
end)

-- Make sure the engine stays on
CreateThread(function()
	local engineOn = false
	while Config.keepEngineRunning do
		local sleep = 1000
		local ped = PlayerPedId()
		if IsPedInAnyVehicle(ped, true) then
			sleep = 0
			local vehicle = GetVehiclePedIsIn(ped, false)
			if IsControlJustPressed(2, 75) then
				if Config.keepVehicleDoorOpen then
					TaskLeaveVehicle(ped, vehicle, 256)
				end
				engineOn = GetIsVehicleEngineRunning(vehicle)
				sleep = 100
			end
			if IsControlJustReleased(2, 75)  then
				SetVehicleEngineOn(vehicle, engineOn, true, true)
				sleep = 100
			end
		end
		Wait(sleep)
	end
end)

RegisterNUICallback("toggleWindow", function(data, cb)
	local vehicle = GetLastDrivenVehicle()
	local id = data.window

	if IsVehicleWindowIntact(vehicle, id) then
		RollDownWindow(vehicle, id)
	else
		RollUpWindow(vehicle, id)
	end

	cb("ok")
end)

RegisterNUICallback('trunk', function(_, cb)
	local vehicle = GetLastDrivenVehicle()
	local hasTrunk = GetIsDoorValid(vehicle, 5)
	local door = hasTrunk and 5 or 4
	local isTrunkOpen = GetVehicleDoorAngleRatio(vehicle, door)

	if isTrunkOpen == 0 then
		SetVehicleDoorOpen(vehicle, door, false, false)
	else
		SetVehicleDoorShut(vehicle, door, false)
	end

	cb("ok")
end)

RegisterNUICallback('alarm', function(_, cb)
	local vehicle = GetLastDrivenVehicle()
	local isAlarmActive = IsVehicleAlarmActivated(vehicle)
	if isAlarmActive then
		SetVehicleAlarm(vehicle, false)
	else
		SetVehicleAlarm(vehicle, true)
		StartVehicleAlarm(vehicle)
	end

	cb("ok")
end)

RegisterNUICallback('unlock', function(_, cb)
	checkLock("unlock")
	cb("ok")
end)

RegisterNUICallback('lock', function(_, cb)
	checkLock("lock")
	cb("ok")
end)

RegisterNUICallback('startstop', function(_, cb)
	local vehicle = GetLastDrivenVehicle()
	local engineRunning = GetIsVehicleEngineRunning(vehicle)

	if engineRunning then
		SetVehicleEngineOn(vehicle, false, false, true)
	else
		SetVehicleEngineOn(vehicle, true, true, true)
	end

	cb("ok")
end)

-- Handle GUI stuff

RegisterNUICallback('escape', function(_, cb)
  	SetNuiFocus(false, false)
  	cb('ok')
end)

-- Command and Keybinding stuff
RegisterCommand("carkeyfob", function()
	SetNuiFocus(true, true)
	SendNUIMessage({
		type = "enableKeyFob",
	})
end, false)

RegisterKeyMapping('carkeyfob', 'Open Car Key UI', 'keyboard', 'i')
