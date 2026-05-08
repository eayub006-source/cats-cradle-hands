$port = 8000
$python = Get-Command py -ErrorAction SilentlyContinue

if ($python) {
  Write-Host "Serving on http://0.0.0.0:$port"
  & py -3 -m http.server $port --bind 0.0.0.0
} else {
  Write-Host "Serving on http://0.0.0.0:$port"
  & python -m http.server $port --bind 0.0.0.0
}
