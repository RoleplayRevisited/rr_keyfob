Config = {
  preventDefaultEngineStart = true, -- Stop vehicle engines from starting by default

  keepEngineRunning = true, -- if a player exits the vehicle should the engine stay running
  keepVehicleDoorOpen = true, -- if the door should stay open if a player leaves the vehicle

  -- Fill in nothing, esx or qbcore
  useFramework = "", -- Needs to be either "qbcore" or "esx" if you want to use their message service or 
  useKeySystem = false, -- Enable this if you want to only make it possible to lock/unlock cars if you have the key (need to have useFramework on either esx or qbcore).
  messageService = "default", -- Options none, default, rr_notify, esx, qbcore
  -- Download rr_notify here: https://github.com/RoleplayRevisited/rr_notify
}

Config.Locales = {
  ["grabbed_keys"] = "You grabbed your key",
  ["no_key"] = "You don't have the keys of this vehicle"
}