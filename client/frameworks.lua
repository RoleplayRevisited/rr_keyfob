ESX = nil 
QBCore = nil

if Config.useFramework == "esx" then 
  Citizen.CreateThread(function()
    ESX = exports["es_extended"]:getSharedObject()
  end)
end 

if Config.useFramework == "qbcore" then 
  QBCore = exports.qb-core:GetCoreObject()
end 