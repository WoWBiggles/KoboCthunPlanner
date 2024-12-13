KCP.LIB.SlashCommands = {}

local private = {}

function KCP.LIB.SlashCommands.handle(cmd)
  if (cmd == "help") then
    private.help()
  elseif (cmd == "show" or cmd == "" or cmd == nil) then
    private.show()
  elseif (cmd == "hide") then
    private.hide()
  elseif (cmd == "reset") then
    private.reset()
  elseif (cmd == "refresh") then
    private.refresh()
  elseif (cmd == "share") then
    private.share()
  elseif (cmd == "marks") then
    private.marks()
  elseif (cmd == "check") then
    private.check()
  elseif (cmd == "version") then
    private.version()
  else
    KCP.alert("Command not found, use /kcp help")
  end
end

-- /kcp help
function private.help()
  local function add_help_message(cmd, message)
    DEFAULT_CHAT_FRAME:AddMessage("   /kcp |cff00d2d6" .. cmd .. " |r-- " .. message, 1.0, 1.0, 0)
  end

  KCP.info("Commands:")
  add_help_message("help", "Show this help menu")
  add_help_message("show", "Show the planner")
  add_help_message("hide", "Hide the planner")
  add_help_message("reset", "Reset position and scale of the planner")
  add_help_message("refresh", "Refresh positions (e.g.: Someone died / went offline)")

  if(IsInGroup() and (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player"))) then
    add_help_message("marks", "Set RaidTargetMarkers for Melees")
    add_help_message("check", "Check if all raiders have the addon installed")
  end

  if(IsInGroup() and UnitIsGroupLeader("player")) then
    add_help_message("share", "Displays the planner to your raid")
  end

  add_help_message("version", "Show current version")
end

-- /kcp version
function private.version()
  KCP.info(KCP.Version.to_string())
end

-- /kcp show
function private.show()
  KCP.frame:show()
end

-- /kcp hide
function private.hide()
  KCP.frame:hide()
end

-- /kcp reset
function private.reset()
  KCP.frame:reset()
end

-- /kcp refresh
function private.refresh()
  KCP.grid:refresh()
end

-- /kcp share
function private.share()
  if IsInGroup() then
    if UnitIsGroupLeader("player") then
      KCP.frame:show()

      KCP.submit_event({ type = "SHARE" })
      KCP.UI.Dot.share_positions()
    else
      KCP.alert("Only the group leader can share.")
    end
  else
    KCP.alert("You need to be in a raid to use this command.")
  end
end

-- /kcp marks
function private.marks()
  KCP.grid:set_marks()
end

-- /kcp check
function private.check()
  if IsInGroup() and (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")) then
    KCP.LIB.CheckAddon.run()
  else
    KCP.alert("This is only available to group leaders.")
  end
end
