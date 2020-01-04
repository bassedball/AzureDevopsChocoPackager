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

function Invoke-ChocoPack {
    param(
        [string]$NuSpecFilePath,
        [string]$OutputFolderPath,
        [switch]$UseBuildinChoco
    )

    $chocoExe = Get-ChocolateyInstance -ForceUseBuildInVersion:$UseBuildinChoco

    $chocoPath = $chocoExe.Source
    try
    {
        & $chocoPath "pack" "$NuSpecFilePath" "--outputdirectory" $OutputFolderPath
    }
    Catch
    {
        Write-Error $_.Exception.Message
    }
}

