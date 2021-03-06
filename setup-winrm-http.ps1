# install self-signed cert
cd $ENV:TEMP

$base64cert = @'
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
wzMwUw11nvbgawQIcDDc7fpRl0wCAggA
'@

[IO.File]::WriteAllBytes("${ENV:TEMP}\cert.pfx", [Convert]::FromBase64String($base64cert))

($cert = Import-PfxCertificate -FilePath "${ENV:TEMP}\cert.pfx" -CertStoreLocation cert:\\LocalMachine\\My -Password (ConvertTo-SecureString -String bolt -Force -AsPlainText)) | Format-List

New-WSManInstance -ResourceURI winrm/config/Listener -SelectorSet @{Address='*';Transport='HTTPS'} -ValueSet @{Hostname='localhost';CertificateThumbprint=$cert.Thumbprint} | Format-List

# install choco
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# install pwsh 6
choco install -y pwsh
