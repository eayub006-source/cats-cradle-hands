$port = 8443
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$certDir = Join-Path $root 'certs'
$certFile = Join-Path $certDir 'localhost-cert.pem'
$keyFile = Join-Path $certDir 'localhost-key.pem'
$python = Get-Command py -ErrorAction SilentlyContinue
$pythonExe = if ($python) { $python.Source } else { 'python' }

if (-not (Test-Path $certDir)) {
  New-Item -ItemType Directory -Path $certDir | Out-Null
}

if (Test-Path $certFile) {
  Remove-Item $certFile -Force
}

if (Test-Path $keyFile) {
  Remove-Item $keyFile -Force
}

$rsa = [System.Security.Cryptography.RSA]::Create(2048)
$subject = [System.Security.Cryptography.X509Certificates.X500DistinguishedName]::new('CN=localhost')
$request = [System.Security.Cryptography.X509Certificates.CertificateRequest]::new(
  $subject,
  $rsa,
  [System.Security.Cryptography.HashAlgorithmName]::SHA256,
  [System.Security.Cryptography.RSASignaturePadding]::Pkcs1
)

$san = [System.Security.Cryptography.X509Certificates.SubjectAlternativeNameBuilder]::new()
$san.AddDnsName('localhost')
$request.CertificateExtensions.Add($san.Build())
$request.CertificateExtensions.Add([System.Security.Cryptography.X509Certificates.X509BasicConstraintsExtension]::new($false, $false, 0, $false))
$request.CertificateExtensions.Add([System.Security.Cryptography.X509Certificates.X509KeyUsageExtension]::new(
    [System.Security.Cryptography.X509Certificates.X509KeyUsageFlags]::DigitalSignature,
    $false
  ))

$cert = $request.CreateSelfSigned((Get-Date).AddMinutes(-5), (Get-Date).AddDays(7))

Set-Content -Path $certFile -Value $cert.ExportCertificatePem() -Encoding ascii
Set-Content -Path $keyFile -Value $rsa.ExportPkcs8PrivateKeyPem() -Encoding ascii

Write-Host "Serving HTTPS on https://localhost:$port"
Write-Host "Press Ctrl+C to stop."
& $pythonExe "$root\serve-https.py" --port $port --cert $certFile --key $keyFile