-- Download rr_notify here: https://github.com/RoleplayRevisited/rr_notify

Config = {}

Config.preventDefaultEngineStart = true -- Stop vehicle engines from starting by default

Config.keepEngineRunning = true -- if a player exits the vehicle should the engine stay running
Config.keepVehicleDoorOpen = true -- if a player exits the vehicle should the door stay open

Config.useFramework = "" -- Needs to be either "qbcore" or "esx" or "" to use no framework. Fill in something to use the frameworks message service
Config.useKeySystem = false -- Enable this if you want to only make it possible to lock/unlock cars if you have the key (need to have useFramework on either esx or qbcore)
Config.messageService = "default" -- Options none, default, rr_notify, esx, qbcore

Config.Locales = {
	["grabbed_keys"] = "You grabbed your key",
	["no_key"] = "You don't have the keys of this vehicle"
}
