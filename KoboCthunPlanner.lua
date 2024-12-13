SLASH_KoboCthunPlanner1 = "/kcp"
SlashCmdList.KoboCthunPlanner = KCP.LIB.SlashCommands.handle

function KCP:OnInitialize()
  self:RegisterComm(KCP.messagePrefix, KCP.OnCommReceived)

  KCP.UI.Dot.init()

  KCP.player = KCP.LIB.Member.create(0)
  KCP.grid = KCP.LIB.Grid.create()
  KCP.frame = KCP.UI.CthunFrame.create()
end

function KCP.OnCommReceived(prefix, message, distribution, sender)
  if(prefix ~= KCP.messagePrefix) then return false end

  local is_event, event = KCP:Deserialize(message)

  if is_event then
    KCP.LIB.Events["ON_" .. event["type"]](event["payload"], prefix, message, distribution, sender)
  end
end
