$port = 8000
$bind = '0.0.0.0'
$python = Get-Command py -ErrorAction SilentlyContinue
$pythonExe = if ($python) { $python.Source } else { 'python' }

function Get-LocalIPv4 {
  try {
    return (Get-NetIPAddress -AddressFamily IPv4 |
      Where-Object {
        $_.IPAddress -notlike '127.*' -and
        $_.IPAddress -notlike '169.254.*' -and
        $_.PrefixOrigin -ne 'WellKnown'
      } |
      Select-Object -First 1 -ExpandProperty IPAddress)
  } catch {
    return $null
  }
}

$localIp = Get-LocalIPv4
Write-Host "Serving on http://localhost:$port"
if ($localIp) {
  Write-Host "Serving on http://${localIp}:$port"
}
Write-Host "Press Ctrl+C to stop."
& $pythonExe -m http.server $port --bind $bind
