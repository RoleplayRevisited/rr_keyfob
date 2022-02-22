ESX = nil 

if Config.useEsx then 
  Citizen.CreateThread(function()
    ESX = exports["es_extended"]:getSharedObject()
  end)
end 