local lastVeh = nil
local isVehOwned = nil

-- Prevent the starting of the engine if you get into the car
Citizen.CreateThread(function()
  while Config.preventDefaultEngineStart do 
    Citizen.Wait(1)
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsTryingToEnter(ped)
    local isEngineOn = GetIsVehicleEngineRunning(vehicle)
    if vehicle then 
      SetVehicleEngineOn(vehicle, isEngineOn, false, true)
    else  
      Citizen.Wait(10)
    end 
  end 
end)

-- Make sure the engine stays on
Citizen.CreateThread(function()
  local engineOn = false
  while Config.keepEngineRunning do 
    Citizen.Wait(1)
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped) then 
      local vehicle = GetVehiclePedIsIn(ped)
      if IsControlJustPressed(2, 75) then 
        if Config.keepVehicleDoorOpen then 
          TaskLeaveVehicle(ped, vehicle, 256)
        end 
        engineOn = GetIsVehicleEngineRunning(vehicle)
      end
      if IsControlJustReleased(2, 75)  then 
        SetVehicleEngineOn(vehicle, engineOn, true, true)
      end 
    else 
      Citizen.Wait(1000)
    end 
  end 
end)

function ownershipCheck()
  local vehicle = GetLastDrivenVehicle()
  local plate = GetVehicleNumberPlateText(vehicle)
  

end

RegisterNUICallback("toggleWindow", function(data, cb)
  local vehicle = GetLastDrivenVehicle()
  local id = data.window
  -- print(data.window)
  
  if IsVehicleWindowIntact(vehicle, id) then 
    RollDownWindow(vehicle, id)
  else 
    print("here")
    RollUpWindow(vehicle, id)
  end 
end)

RegisterNUICallback('trunk', function(data, cb)
  local vehicle = GetLastDrivenVehicle()
  local hasTrunk = GetIsDoorValid(vehicle, 5)
  local door = 5

  if not hasTrunk then 
    door = 4
  end 

  local isTrunkOpen = GetVehicleDoorAngleRatio(vehicle, door)


  if isTrunkOpen == 0 then 
    SetVehicleDoorOpen(vehicle, door, false, false)
  else
    SetVehicleDoorShut(vehicle, door, false)
  end 

end)

RegisterNUICallback('alarm', function(data, cb)
  local vehicle = GetLastDrivenVehicle()
  local isAlarmActive = IsVehicleAlarmActivated(vehicle)
  if isAlarmActive then 
    SetVehicleAlarm(vehicle, false)
  else
    SetVehicleAlarm(vehicle, true)
    StartVehicleAlarm(vehicle)
  end 

end)

RegisterNUICallback('unlock', function(data, cb)
  checkLock("unlock")
end)

RegisterNUICallback('lock', function(data, cb)
  checkLock("lock")
end)

RegisterNUICallback('startstop', function(data, cb)
  local vehicle = GetLastDrivenVehicle()
  local engineRunning = GetIsVehicleEngineRunning(vehicle)

  if engineRunning then 
    SetVehicleEngineOn(vehicle, false, false, true)
  else 
    SetVehicleEngineOn(vehicle, true, true, true)
  end 
end)

function checkLock(lock)
  local vehicle = GetLastDrivenVehicle()
  if vehicle == lastVeh and isVehOwned then
    toggleLockVehicle(lock)
    return
  end
  lastVeh = vehicle
  local plate = GetVehicleNumberPlateText(vehicle)
  local hasKey = false

  if Config.useKeySystem and Config.useFramework == "esx" then 

    ESX.TriggerServerCallback("rr_keyfob:isOwner", function(value)
      hasKey = value

      if not hasKey then
        createNotification(Config.Locales["no_key"], "error")
        return
      end 

      toggleLockVehicle(lock)
    end, plate)
  elseif Config.useKeySystem and Config.useFramework == "qbcore" then
    QBCore.Functions.TriggerCallback("rr_keyfob:isOwner", function(value)
      hasKey = value

      if not hasKey then
        createNotification(Config.Locales["no_key"], "error")
        return
      end 

      toggleLockVehicle(lock)
    end, plate)
  else 
    toggleLockVehicle(lock)
  end 
  isVehOwned = hasKey
end 

function toggleLockVehicle(lock)
  local vehicle = GetLastDrivenVehicle()

  if (lock == "lock") then 
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

-- Handle GUI stuff

local guiEnabled = false

RegisterNUICallback('escape', function(data, cb)
  CloseFob()
  cb('ok')
end)

function CloseFob()
  SetNuiFocus(enable, false)
  guiEnabled = false
end 

function EnableFob()
  SetNuiFocus(true, true)
  guiEnabled = true

  if guiEnabled then 
    SendNUIMessage({
      type = "enableKeyFob",
    })
  end 
end

-- Command and Keybinding stuff
RegisterCommand("carkeyfob", function()
  EnableFob()
end, false)  

RegisterKeyMapping('carkeyfob', 'Open Car Key UI', 'keyboard', 'i')