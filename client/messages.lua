function createNotification(msg, style)
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
end 

function getMessageStyle(style)
  if style == "error" then 
    return "~r~"
  elseif style == "success" then
    return "~g~"
  elseif style == "info" then 
    return "~b~"
  end 
end 