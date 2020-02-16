Import-Module $PSScriptRoot\ChocoHelperFunctions.psm1 -Force

<#
.Synopsis
   Wrapper for getting local chocolatey installed version 
.DESCRIPTION
   Wrapper for getting local chocolatey installed version 

#>
function Get-LocalChocolateyInstall
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([System.Management.Automation.ApplicationInfo])]
    Param
    (    )
    Write-Verbose "Getting locally installed chocolatey instance."
    try
    {      
        $localchoco = Get-Command -Name choco -ErrorAction Stop;
        Write-Output $localchoco
    }
    Catch [System.Management.Automation.CommandNotFoundException]
    {
        Write-Verbose "Local instance of $($_.TargetObject) not found!" -Verbose
        Write-Output $null
    }
    Catch
    {
        Throw $Error
    } 
}

function Get-BuildInChocolateyExecutable
{
    Return Get-command -Name "$PSScriptroot\..\..\assets\choco.exe" 
}

function Get-ChocolateyInstance
{
    param(
        [switch]$ForceUseBuildInVersion
    )
    
    $chocoExe = $null;
    if( -not $ForceUseBuildInVersion){
        $chocoExe = Get-LocalChocolateyInstall
    }
    if($ForceUseBuildInVersion -or ($null -eq $chocoExe))
    {
        $chocoExe = Get-BuildInChocolateyExecutable
    }
    return $chocoExe

}
function Invoke-Chocolatey 
{
    param(
    [Parameter(Position=0)]
    [string]$arguments,
    [Parameter(Position=1)]
    [int[]]$validExitcodes = @(0),
    [switch]$ForceUseBuildInVersion
    )
    $chocoExe = Get-ChocolateyInstance -ForceUseBuildInVersion:$ForceUseBuildInVersion

    Invoke-Executeable -executablePath $chocoExe -arguments $arguments

}

function Invoke-ChocoPack {
    param(
        [string]$NuSpecFilePath,
        [string]$OutputFolderPath,
        [switch]$UseBuildinChoco
    )

    try
    {
        Invoke-Chocolatey -arguments "pack $NuSpecFilePath  --outputdirectory  `"$OutputFolderPath`"" -ForceUseBuildInVersion:$UseBuildinChoco
    }
    Catch
    {
        Write-Error $_.Exception.Message
    }
}

function Publish-ChocoPackage {
    [CmdletBinding()]
    param (
        $PackagePath,
        $Source,
        $ApiKey,
        [switch]$Force,
        [switch]$UseBuildinChoco
        
    )
    
    $argumentString = "push $PackagePath --source $Source"
    if($ApiKey){$argumentString += " --api-key $ApiKey"}
    if($Force){$argumentString += " --force"}
    Invoke-Chocolatey -arguments $argumentString -ForceUseBuildInVersion:$UseBuildinChoco
}