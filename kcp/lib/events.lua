KCP.LIB.Events = {}

-- Generic event handler delegates to correct handler
-- @todo Replace w/ AceEvent
function KCP.LIB.Events.handle(...)
  local _, event_type = ...

  if(not event_type) then return false end

  KCP.LIB.Events["ON_" .. event_type]()
end

function KCP.LIB.Events.ON_GROUP_JOINED()
  KCP.submit_event({ type = "REQUEST_SHARE" })
end

function KCP.LIB.Events.ON_GROUP_ROSTER_UPDATE()
  KCP.grid:refresh()
end

function KCP.LIB.Events.ON_REQUEST_SHARE()
  if(KCP.player:is_leader()) then
    KCP.UI.Dot.share_positions()
  end
end

function KCP.LIB.Events.ON_SHARE()
  KCP.frame:show()
end

function KCP.LIB.Events.ON_SHARE_POSITIONS(payload)
  KCP.UI.Dot.set_positions(payload)
end

function KCP.LIB.Events.ON_VERSION_CHECK(_, _, _, _, target)
  KCP.submit_event({
    type = "VERSION_RESPONSE",
    payload = {
      name = KCP.player_name,
      version = KCP.Version.to_string()
    }
  }, target)
end

function KCP.LIB.Events.ON_VERSION_RESPONSE(payload)
  KCP.LIB.CheckAddon.installed(payload["name"], payload["version"])
end

