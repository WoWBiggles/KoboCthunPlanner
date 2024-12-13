KCP = LibStub("AceAddon-3.0"):NewAddon("KCP", "AceComm-3.0", "AceSerializer-3.0")
KCP.LIB = {}

KCP.messagePrefix = "KCP"
KCP.frame = {}
KCP.player_name = UnitName("player")

function KCP.info(message)
  DEFAULT_CHAT_FRAME:AddMessage("|cff00d2d6KCP:|r " .. message, 1.0, 1.0, 0)
end

function KCP.alert(message)
  DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000KCP:|r " .. message, 1.0, 1.0, 0)
end

function KCP.submit_event(event, target)
  if(target) then
    KCP.addon_whisper_message(KCP:Serialize(event), target)
  else
    KCP.addon_raid_message(KCP:Serialize(event))
  end
end

function KCP.addon_raid_message(message)
  KCP:SendCommMessage(KCP.messagePrefix, message, "RAID")
end

function KCP.addon_whisper_message(message, target)
  KCP:SendCommMessage(KCP.messagePrefix, message, "WHISPER", target)
end

function KCP.debug(object)
  print(KCP.dump(object))
end

function KCP.dump(object)
  if type(object) == 'table' then
    local s = "{"
    for k, v in pairs(object) do
      if type(k) ~= 'number' then k = '"'..k..'"' end

      s = s .. '['..k..'] = ' .. KCP.dump(v) .. ", "
    end
    return s .. '}'
  else
    return tostring(object)
  end
end

-- @note Lua does not have a String#split method implemented,
--       but WoW does. We just delegate here.
function KCP.split(...)
  strsplit(...)
end

-- @see http://lua-users.org/wiki/CopyTable
function KCP.copy_table(orig)
  local orig_type = type(orig)
  local copy = {}

  if orig_type == 'table' then
    for orig_key, orig_value in pairs(orig) do
      copy[KCP.copy_table(orig_key)] = KCP.copy_table(orig_value)
    end
    setmetatable(copy, KCP.copy_table(getmetatable(orig)))
  else -- number, string, boolean, etc
    copy = orig
  end
  return copy
end
