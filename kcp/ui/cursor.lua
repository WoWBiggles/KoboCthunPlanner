KCP.UI.Cursor = {
  last = nil,
  current = nil
}

function KCP.UI.Cursor.set(icon)
  KCP.UI.Cursor.last = KCP.UI.Cursor.current
  KCP.UI.Cursor.current = icon

  if(icon) then
    SetCursor("Interface/Cursor/" .. icon)
  else
    SetCursor(nil)
  end
end

function KCP.UI.Cursor.set_last()
  KCP.UI.Cursor.set(KCP.UI.Cursor.last)
end

function KCP.UI.Cursor.set_current()
  KCP.UI.Cursor.set(KCP.UI.Cursor.current)
end
