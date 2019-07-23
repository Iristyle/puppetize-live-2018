plan deploy::upgrade(
  TargetSpec $nodes
) {

  # https://puppet.com/docs/bolt/1.x/writing_plans.html
  # https://puppet.com/docs/bolt/1.x/plan_functions.html
  get_targets($nodes).each |$node| {
    $temp = run_command('[System.IO.Path]::GetTempPath()', $node).first['stdout']
    upload_file('/Users/Iristyle/source/puppetize-live-2018/boltwebinar.zip',
      "$temp/boltwebinar.zip",
      $node,
      "Uploading application to $temp")

    # install app from zip file - handles stopping service / starting service
    run_task('deploy::install_application', $node, '/tmp/boltwebinar.zip')
  }
}

##########################################
# Invoke like
##########################################

# bolt task run deploy::get_temp_path --modulepath . --nodes winrm://${BOLT_HOST} -u root -p $BOLT_PASSWORD --no-ssl-verify --debug --verbose
