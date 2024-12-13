KCP.LIB.CheckAddon = {}
KCP.LIB.CheckAddon.current_roster = nil

KCP.LIB.CheckAddon.Roster = {}
KCP.LIB.CheckAddon.Roster.__index = KCP.LIB.CheckAddon.Roster

local private = {}

function KCP.LIB.CheckAddon.run()
  KCP.LIB.CheckAddon.current_roster = KCP.LIB.CheckAddon.Roster.create()

  KCP.submit_event({ type = "VERSION_CHECK" })

  KCP.info("checking if everyone has the addon installed")
  C_Timer.After(3, private.handle_result)
end

function KCP.LIB.CheckAddon.installed(name, version)
  if KCP.LIB.CheckAddon.current_roster == nil then return false end

  KCP.LIB.CheckAddon.current_roster:handle_installed(name, version)
end

function KCP.LIB.CheckAddon.Roster.create()
  local self = {}

  setmetatable(self, KCP.LIB.CheckAddon.Roster)

  self.missing = {}
  self.installed = {}

  for i = 1, 40 do
    local name, _ = GetRaidRosterInfo(i)

    if name then table.insert(self.missing, name) end
  end

  return self
end

function KCP.LIB.CheckAddon.Roster:handle_installed(name, version)
  for i, existing_name in pairs(self.missing) do
    if existing_name == name then
      table.remove(self.missing, i)

      self.installed[version] = self.installed[version] or {}
      table.insert(self.installed[version], name)
    end
  end
end

function private.handle_result()
  local roster = KCP.LIB.CheckAddon.current_roster

  if table.getn(roster.missing) > 0 then
    KCP.alert("Missing: " ..  table.concat(roster.missing, ", "))
  end

  for version, installed in pairs(roster.installed) do
    KCP.info("Installed (" .. version .. "): " ..  table.concat(installed, ", "))
  end

  if table.getn(roster.missing) <= 0 then
    KCP.info("All players have KCP installed!")
  end
end
