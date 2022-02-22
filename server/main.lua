if Config.useKeySystem then 
  local ESX = nil 
  local QBCore = nil 
  local Keys = {}

  if Config.useFramework == "esx" then 
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

    ESX.RegisterServerCallback("rr_keyfob:hasKey", function(src, cb, vehicle)
      local stringVeh = tostring(vehicle)
      if not Keys[src] then 
        cb(false)
        return
      end 

      if not Keys[src][stringVeh] then 
        cb(false)
        return
      end 

      print(Keys[src][stringVeh])

      cb(Keys[src][stringVeh])
    end)
  end 

  if Config.useFramework == "qbcore" then 
    QBCore = exports['qb-core']:GetCoreObject()

    QBCore.Functions.CreateCallback("rr_keyfob:hasKey", function(src, cb, vehicle)
      local stringVeh = tostring(vehicle)
      if not Keys[src] then 
        cb(false)
        return
      end 

      if not Keys[src][stringVeh] then 
        cb(false)
        return
      end 

      print(Keys[src][stringVeh])

      cb(Keys[src][stringVeh])
    end)
  end 

  RegisterNetEvent("rr_keyfob:giveKey")
  AddEventHandler("rr_keyfob:giveKey", function(vehicle, src)
    local stringVeh = tostring(vehicle)
    print("here")
    local playerSrc = nil 

    if source then 
      playerSrc = source
    elseif src then 
      playerSrc = src
    end 

    if not Keys[playerSrc] then 
      Keys[playerSrc] = {}
    end 

    Keys[playerSrc][stringVeh] = true
  end)

  RegisterNetEvent("rr_keyfob:removeKey")
  AddEventHandler("rr_keyfob:removeKey", function(vehicle, src)
    local stringVeh = tostring(vehicle)
    local playerSrc = nil 

    if source then 
      playerSrc = source
    elseif src then 
      playerSrc = src
    end 

    if Keys[playerSrc] and Keys[playerSrc][stringVeh] then 
      Keys[playerSrc][stringVeh] = false
    end 
  end)
end 

if Config.useKeySystem and (not Config.useFramework or Config.useFramework == "") then 
  print("ERROR: You need to use esx or qbcore to make use of the key system, enable it in the config")
end 