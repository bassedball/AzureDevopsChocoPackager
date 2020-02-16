function New-TemporaryDirectory {
    $parent = [System.IO.Path]::GetTempPath()
    $name = [System.IO.Path]::GetRandomFileName()
    New-Item -ItemType Directory -Path (Join-Path $parent $name)
  }
<#
.Synopsis
   Run chocolatey executable and throws error on failure
.DESCRIPTION
   Run chocolatey executable and throws error on failure
.EXAMPLE
   Invoke-executable "notepad" ".\readme.md"
.EXAMPLE
   Invoke-executable -executablePath "notepad" -arguments ".\readme.md"
#>
function Invoke-Executeable
{
    [CmdletBinding()]
    Param
    (
        # chocolatey arguments."
        [Parameter(Position=0)]
        [string]$executablePath,
        # chocolatey arguments."
        [Parameter(Position=1)]
        [string]$arguments,
        [Parameter(Position=2)]
        [int[]]$validExitcodes = @(0)

    )

    #  Example of valid exit codes$(
    #             0,    #most widely used success exit code
    #             1605, #(MSI uninstall) - the product is not found, could have already been uninstalled
    #             1614, #(MSI uninstall) - the product is uninstalled
    #             1641, #(MSI) - restart initiated
    #             3010  #(MSI, InnoSetup can be passed to provide this) - restart required
    #         )
    Write-Verbose -Message "command: 'choco $arguments'" 
    
    $pinfo = New-Object System.Diagnostics.ProcessStartInfo
    $pinfo.FileName = $executablePath
    $pinfo.RedirectStandardError = $true
    $pinfo.RedirectStandardOutput = $true
    $pinfo.UseShellExecute = $false
    $pinfo.Arguments = "$arguments"

    $p = New-Object System.Diagnostics.Process
    $p.StartInfo = $pinfo
    $p.Start() | Out-Null

    $output = $p.StandardOutput.ReadToEnd()
    $p.WaitForExit()
    $exitcode = $p.ExitCode
    $p.Dispose()

    #Set $LASTEXITCODE variable.
    powershell.exe   -NoLogo -NoProfile -Noninteractive "exit $exitcode"

    if($exitcode -in $validExitCodes )
    {
        $outputdata = $output.Split("`n")
        $outputdata
    }
    else
    { 
        #when error, throw output as error, contains errormessage
        throw "Error:  command failed with exit code $exitcode.`n$output" 
    }       
}
