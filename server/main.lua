if Config.useKeySystem and Config.useEsx then 
  local ESX = nil 
  local Keys = {}

  TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

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

  ESX.RegisterServerCallback("rr_keyfob:hasKey", function(src, cb, vehicle)
    local stringVeh = tostring(vehicle)
    print("here")
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

if Config.useKeySystem and not Config.useEsx then 
  print("ERROR: You need to have esx to make use of the key system, enable useEsx in the config")
end 