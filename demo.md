Cross-platform PowerShell task demo ideas

- NGinx on Ubuntu
- Bolt task to deploy the app, written in PowerShell

- NGinx on Windows
- Bolt task to deploy the app, written in PowerShell

- Restarting the service?

    #
    # configure Daemon
    #
    # host has configured Azure agent to be part of docker-users group
    # docker-users group has access to the named pipe for sending commands to daemon
    # $Env:DOCKER_HOST="tcp://0.0.0.0:2375"


Some info on using Windows as a client
http://www.hurryupandwait.io/blog/fixing-winrm-firewall-exception-rule-not-working-when-internet-connection-type-is-set-to-public

.NET Core 2.0

sudo apt-get install -y apt-transport-https
sudo apt-get update
sudo apt-get install -y dotnet-hosting-2.0.8
sudo apt-get install -y aspnetcore-runtime-2.1
sudo apt-get install -y dotnet-sdk-2.1


[172.28.54.141]: PS /home/iristyle> dotnet --info

Host (useful for support):
  Version: 2.1.4
  Commit:  85255dde3e

.NET Core SDKs installed:
  No SDKs were found.

.NET Core runtimes installed:
  Microsoft.AspNetCore.All 2.1.4 [/usr/share/dotnet/shared/Microsoft.AspNetCore.All]
  Microsoft.AspNetCore.App 2.1.4 [/usr/share/dotnet/shared/Microsoft.AspNetCore.App]
  Microsoft.NETCore.App 2.0.7 [/usr/share/dotnet/shared/Microsoft.NETCore.App]
  Microsoft.NETCore.App 2.1.4 [/usr/share/dotnet/shared/Microsoft.NETCore.App]

To install additional .NET Core runtimes or SDKs:
  https://aka.ms/dotnet-download
