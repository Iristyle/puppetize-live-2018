# building the app
Push-Location BoltWebinar
# https://docs.microsoft.com/en-us/aspnet/core/host-and-deploy/visual-studio-publish-profiles?view=aspnetcore-2.1&tabs=aspnetcore2x
sudo dotnet publish --configuration Release /p:CopyOutputSymbolsToPublishDirectory=false /p:DeleteExistingFiles=true
cd bin/Release/netcoreapp2.1/publish
Compress-Archive * ../../../../../boltwebinar.zip -Force
Pop-Location
Write-Host "`n`nBuilt application and produced zip archive of publish directory"
Get-ChildItem ./boltwebinar.zip



# standard .NET core scaffolded app
# # building the app
# Push-Location puppetize
# # https://docs.microsoft.com/en-us/aspnet/core/host-and-deploy/visual-studio-publish-profiles?view=aspnetcore-2.1&tabs=aspnetcore2x
# dotnet publish --configuration Release /p:CopyOutputSymbolsToPublishDirectory=false /p:DeleteExistingFiles=true
# cd bin/Release/netcoreapp2.1/publish
# Compress-Archive * ../../../../../app.zip -Force
# Pop-Location
# Write-Host "`n`nBuilt application and produced zip archive of publish directory"
# Get-ChildItem ./app.zip
