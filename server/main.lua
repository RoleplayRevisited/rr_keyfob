if Config.useKeySystem then
  local ESX = nil
  local QBCore = nil
  local Keys = {}

  if Config.useFramework == "esx" then
    ESX = exports["es_extended"]:getSharedObject()

    ESX.RegisterServerCallback("rr_keyfob:isOwner", function(src, cb, veh, plate)
      if (Keys[src] and Keys[src][tostring(veh)]) then cb(Keys[src][tostring(veh)]) return end
      exports.oxmysql:query("SELECT `owner` FROM `owned_vehicles` WHERE plate = @plate", {
        ['@plate'] = plate
      }, function(result)
        cb(result and result[1] and result[1]["owner"] and ESX.GetPlayerFromId(src).getIdentifier() == result[1]["owner"])
      end)
    end)
  end

  if Config.useFramework == "qbcore" then
    QBCore = exports['qb-core']:GetCoreObject()

    QBCore.Functions.CreateCallback("rr_keyfob:isOwner", function(src, cb, veh, plate)
      if (Keys[src] and Keys[src][tostring(veh)]) then cb(Keys[src][tostring(veh)]) return end
      exports.oxmysql:query("SELECT `license` FROM `player_vehicles` WHERE plate = @plate", {
        ['@plate'] = plate
      }, function(result)
        cb(result and result[1] and result[1]["license"] and QBCore.Functions.GetIdentifier(src, "license") == result[1]["license"])
      end)
    end)
  end

  RegisterNetEvent("rr_keyfob:giveKey", function(vehicle, src)
    local stringVeh = tostring(vehicle)
    local playerSrc = source ~= '' and source or src

    if not Keys[playerSrc] then
      Keys[playerSrc] = {}
    end

    Keys[playerSrc][stringVeh] = true
  end)

  RegisterNetEvent("rr_keyfob:removeKey", function(vehicle, src)
    local stringVeh = tostring(vehicle)
    local playerSrc = source ~= '' and source or src

    if Keys[playerSrc] and Keys[playerSrc][stringVeh] then
      Keys[playerSrc][stringVeh] = false
    end
  end)
end

if Config.useKeySystem and (not Config.useFramework or Config.useFramework == "") then 
  print("ERROR: You need to use esx or qbcore to make use of the key system, enable it in the config")
end
