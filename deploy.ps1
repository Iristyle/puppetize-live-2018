#!/bin/pwsh

if ($IsLinux)
{
  # Debian / Ubuntu
  if (Get-Command apt-get -ErrorAction SilentlyContinue)
  {
    apt-get install -y dotnet-hosting-2.0.8 aspnetcore-runtime-2.1 dotnet-sdk-2.1
  }
  # other package manager checks here
}
# ignore MacOS and assume Windows
elseif
{
  # install Chocolatey
  if (-not (Get-Command choco -ErrorAction SilentlyContinue))
  {
    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
  }

  # ensure IIS installed / enabled
  # Get-WindowsOptionalFeature -Online | ? { $_.FeatureName -like 'IIS-*' } | Select FeatureName | Enable-WindowsOptionalFeature -Online

  # just want to be able to self-host with dotnet, not IIS
  choco install -y dotnetcore-runtime dotnetcore-sdk
  # IIS requires this package
  # dotnetcore-windowshosting
}
