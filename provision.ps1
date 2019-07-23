$os = 'ubuntu-1804-x86_64'
$response = (curl -d --url vmpooler.delivery.puppetlabs.net/vm/$os | ConvertFrom-Json)
$BOLT_HOST = $response.$os.hostname + "." + $response.domain
ping -c 3 $BOLT_HOST
rm -rf ./modules/powershell
bolt puppetfile install --boltdir .
bolt task run powershell::install_pwsh --boltdir . --nodes ssh://${BOLT_HOST} --no-host-key-check
bolt task run powershell::enable_winrm build_omi=true --boltdir . --nodes ssh://${BOLT_HOST} --no-host-key-check

$BOLT_PASSWORD = 'Qu@lity!'
bolt task run powershell::add_ntlm_file_authorized_user username=root password=${BOLT_PASSWORD} --boltdir . --nodes ssh://${BOLT_HOST} --no-host-key-check


# Demo
# Install / configure .NET core app on Ubuntu + Windows with Bolt
# Run Pester Tests to demonstrate port 80 live!
