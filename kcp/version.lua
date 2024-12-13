KCP.Version = {}

KCP.Version.MAJOR = 0
KCP.Version.MINOR = 3
  KCP.Version.PATCH = 3
KCP.Version.PRE_RELEASE = nil

function KCP.Version.to_string()
  local version = (
    KCP.Version.MAJOR .. "." ..
    KCP.Version.MINOR .. "." ..
    KCP.Version.PATCH
  )

  if(KCP.Version.PRE_RELEASE) then
    version = version .. "." .. KCP.Version.PRE_RELEASE
  end

  return version
end
