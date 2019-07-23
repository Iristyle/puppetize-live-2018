#!/usr/bin/pwsh
[CmdletBinding()]
Param(
  [Parameter(Mandatory = $True)]
  [ValidateScript({
    if( -Not ($_ | Test-Path) ){ throw "File Not Found" }
    $True
  })]
  [System.IO.FileInfo]
  $package_location,

  [Parameter(Mandatory = $False)]
  [Bool]
  $overwrite = $True,
)

function Expand-ApplicationZip($Path, $Force)
{
  $expandArgs = @{
    Path = $package_location
    Force = $overwrite
  }

  # asp.net core 2 has different preferred default dirs for hosts
  if ($IsLinux) {
    $expandArgs.DestinationPath = '/var/aspnetcore'
  }
  else
  {
    $expandArgs.DestinationPath = 'foo'
  }

  Write-Verbose "Expanding $($expandArgs.Path) to $($expandArgs.DestinationPath)"
  Expand-Archive @expandArgs
}

function Stop-Hosting
{
  if ($IsLinux) {
    service supervisor stop
  }
  else {}
}

function Start-Hosting
{
  if ($IsLinux) {
    service supervisor start
  }
  else {}
}

try
{
  Stop-Hosting
  $expandOutput = Expand-ApplicationZip -Path $package_location -Force $overwrite
  Start-Hosting

  # NOTE: ConvertTo-Json requires PS3
  @{
    'output' = $expandOutput
    'status' = 'success'
  } |
    ConvertTo-Json |
    Write-Host
}
catch
{
  @{
    'status' = 'failure';
    '_error' = @{
      'msg'     = "Unable to install application: $($_.Exception.Message)";
      'kind'    = 'powershell_error';
      'details' = @{}
    }
  } |
    ConvertTo-Json |
    Write-Host
}
