$chocoEndpointName = Get-VSTSInput -name connectedServiceNameTFS
$chocoEndpoint = GetVstsEndpoint -name $chocoEndpointName
$chocoForce = Get-VstsInput -name chocoforce -require -AsBool
$useBuildInChoco = Get-VstsInput -name UseBuildInChoco -require -AsBool

Trace-VstsEnteringInvocation $MyInvocation

try 
{
    $packagePath = Get-VstsInput -Name ChocolateyPackagePath -Require
    $item = Get-item $packagePath | Select -First 1
    $chocoSource = $chocoEndpoint.url
    $apiKey = $chocoEndpoint.auth.parameters.password
    Publish-ChocoPackage -PackagePath $packagePath -Source $chocoSource -ApiKey $apiKey -Force $chocoForce   
}
catch 
{
    
}
finally
{

}
