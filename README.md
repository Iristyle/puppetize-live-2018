# puppetize-live-2018

Demo setup - Ubuntu 18.04

- Install powershell module with new tasks
- bundle exec bolt task show --boltdir .
- allocate pooler host 1
    $response = (curl -d --url vmpooler.delivery.puppetlabs.net/vm/$os | ConvertFrom-Json)
    $BOLT_HOST = $response.$os.hostname + "." + $response.domain

- allocate pooler host 2
  + $response = (curl -d --url vmpooler.delivery.puppetlabs.net/vm/$os | ConvertFrom-Json)

- Use install_pwsh task to get PowerShell 6.1.0 configured
  + bundle exec bolt task run powershell::install_pwsh --boltdir . --nodes ssh://${BOLT_HOST} --no-host-key-check --verbose --debug
    Instructions derived from 2 MS docs
        https://docs.microsoft.com/en-us/powershell/scripting/setup/installing-powershell-core-on-linux?view=powershell-6
        https://docs.microsoft.com/en-us/powershell/scripting/core-powershell/ssh-remoting-in-powershell-core?view=powershell-6#set-up-on-linux-ubuntu-1404-machine
    Note that enable_ssh_remoting is turned on which turns on password auth and PowerShell subsystem in sshd_config
- Verify that Enter-PSSession works over SSH from a Windows host on PowerShell 6 (using password auth) - SSH only supported in PS6
   $BOLT_HOST=foo.delivery.puppetlabs.net
  `Enter-PSSession $BOLT_HOST -SSHTransport -UserName root -KeyFilePath /Users/Iristyle/.ssh/id_rsa-jenkins`
  Additional docs at https://docs.microsoft.com/en-us/powershell/scripting/core-powershell/ssh-remoting-in-powershell-core?view=powershell-6

- Use enable_winrm task to get OMI server (1.5.0-0 from Jul 23) with PSRP provider (1.4.2-2 from April 20)
  + bundle exec bolt task run powershell::enable_winrm build_omi=true --boltdir . --nodes ssh://${BOLT_HOST} --no-host-key-check --verbose --debug
    Instructions derived from 2 repositories
      https://github.com/Microsoft/omi#sample-installation-instructions
      https://github.com/PowerShell/psl-omi-provider#get-psrp-server
    Note that this installs the OMI server service *and* the PowerShell remoting protocol provider
    It also opens up port 5986 and by default configures NTLM support using a local file
    Kerberos auth can be configured, but requires additional setup and infrastructure
    By default, only basic auth over SSL is configured, but this additionally uses SPNEGO over HTTPS
    Config stored at /etc/opt/omi/conf/omiserver.conf

- Enter-PSSession Demonstrate basic auth is working! (because password is enabled)
  + Enter-PSSession $BOLT_HOST -Authentication Basic -UseSSL -Credential root
  - Negotiate won't work on PS 6.1.0 / OSX as it's not supported! (No New-PSSessionOption on OSX either) (but Windows does!)
    https://docs.microsoft.com/en-us/powershell/scripting/whats-new/known-issues-ps6?view=powershell-6
    + Enter-PSSession p4jz0jwh18iy4u0.delivery.puppetlabs.net -Authentication Negotiate -UseSSL -Credential root

- Add a user with bolt task!
    bundle exec bolt task run powershell::add_ntlm_file_authorized_user username=root password=${BOLT_PASSWORD} --boltdir . --nodes ssh://${BOLT_HOST} --no-host-key-check

- Can't use this from Mac (but it would work on Windows client)
  Enter-PSSession -ComputerName 172.28.54.141 -UseSSL -Credential "\root" -SessionOption $options -Authentication Negotiate
  Note that it is important to use the \
  Recommended to use PWSH6 on Windows because -Credential support will use CLI instead of popping a dialog, allows \ rather than requiring <domain>\

- Now Bolt is capable of running a PowerShell command, over WinRM, to a Linux endpoint like
  bundle exec bolt command run "`$PSVersionTable" --nodes winrm://$BOLT_HOST --ssl --user $BOLT_USER --password $BOLT_PASSWORD --no-ssl-verify

- Troubleshooting the Setup
  * OMI server can be managed with /opt/omi/bin/service_control stop OR start OR restart OR status
  * Use Test-WSMan cmdlet
  * The Ubuntu host has an omicli app to test against itself
    /opt/omi/bin/omicli id --hostname localhost --auth NegoWithCreds -u user -p password --encryption https
  * OMI spits out logs to /var/opt/omi/log/omiserver.log but they're not especially helpful as they're mostly impl details
      Log verbosity level can be set with loglevel = VERBOSE in /etc/opt/omi/conf/omiserver.conf
  * WireShark can be really handy for monitoring SOAP message traces, but need to turn off forward secrecy by setting omiserver.conf setting
    sslciphersuite=AES128-SHA
    to decrypt SSL messages, register the omi server private key in WireShark (key stored in /etc/opt/omi/ssl/omikey.pem)


- Current Demo Caveat Notes
    * Tasks are in a forked repo - noted in Puppetfile - `bolt puppetfile install`
    * Preferable to use PowerShell 6 on client for testing (otherwise may get tty prompts)
    * OMI server is configured with an auto-generated self-signed certificate, so cert errors must be ignored
        * Could provide a real cert for a real hostname signed by a real CA
        * Could install the self-signed cert locally to "trust" the endpoint
    * Running special version of OMI server that enables SPENGO over HTTPS fixes


- Actual cross-platform PowerShell task
  Building .NET core apps on OSX
    brew cask install dotnet dotnet-sdk
    dotnet new razor --name puppetize
    dotnet run --project ./puppetize

- Future Updates
  Release tasks to PowerShell module
  Create a new module for OMI server installation / management
  Make PowerShell input method work over SSH as it does over WinRM
  Allow Bolt to use basic auth over SSL? (winrm gem supports it)
