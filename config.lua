Config = {
  preventDefaultEngineStart = true, -- Stop vehicle engines from starting by default

  keepEngineRunning = true, -- if a player exits the vehicle should the engine stay running
  keepVehicleDoorOpen = true, -- if the door should stay open if a player leaves the vehicle

  useEsx = true, -- Needs to be on true if you use esx as a message service
  useKeySystem = true, -- Enable this if you want to only make it possible to lock/unlock cars if you have the key (need to have useEsx on true).
  messageService = "default", -- Options none, default, rr_notify, esx
  -- Download rr_notify here: https://github.com/RoleplayRevisited/rr_notify
}

Config.Locales = {
  ["grabbed_keys"] = "You grabbed your key",
  ["no_key"] = "You don't have the keys of this vehicle"
}