#!/bin/pwsh

if ($IsLinux)
{
  # Debian / Ubuntu
  if (Get-Command apt-get -ErrorAction SilentlyContinue)
  {
    wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
    dpkg -i packages-microsoft-prod.deb
    apt-get install -y apt-transport-https
    apt-get update
    # TODO: validate the required packages  here... can we just get away with aspnetcore-runtime-2 ??
    # dotnet-hosting-2.0.9
    apt-get install -y  aspnetcore-runtime-2.1 dotnet-sdk-2.1
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
