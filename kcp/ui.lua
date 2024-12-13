KCP.UI = {}

-- @param parent    Frame to append the new texture to
-- @param path     File path of the texture file
-- @param position One of: "TopLeft", "TopRight", "BottomLeft", "BottomRight"
-- @param width
-- @param height
-- @param ox       (optional) Offset x-axis
-- @param oy       (optional) Offset y-axis
-- @param left     (optional) Region of texture: left (Default: 0.0)
-- @param right    (optional) Region of texture: right (Default: 1.0)
-- @param top      (optional) Region of texture: top (Default: 0.0)
-- @param bottom   (optional) Region of texture: bottom (Default: 1.0)
function KCP.UI.append_partial_texture(parent, path, position, width, height, ox, oy, left, right, top, bottom)
  ox = ox or 1.0
  oy = oy or 1.0
  left = left or 0.0
  right = right or 1.0
  top = top or 0.0
  bottom = bottom or 1.0

  local texture = parent:CreateTexture()

  texture:SetTexture(path)
  texture:SetPoint(position, parent, position, ox, oy)
  texture:SetWidth(width)
  texture:SetHeight(height)
  texture:SetTexCoord(left, right, top, bottom)

  return texture
end
