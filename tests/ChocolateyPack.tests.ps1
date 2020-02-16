Import-Module $PSScriptRoot\..\source\modules\ChocolateyFunctions.psm1 -Force


Describe "Chocolatey pack testing" {
    $nuspecFileLocation = "$PSScriptRoot\assets\TestChocoPackage\testchocopackage.nuspec"
    $OutDirPath = (New-TemporaryDirectory).fullname


    Context "Pack testchocopackage" {
        it "Invoke Chocopack should not throw error" {
             { Invoke-ChocoPack -NuSpecFilePath $nuspecFileLocation -OutputFolderPath $OutDirPath -UseBuildinChoco } | 
             Should not Throw
        }
        it "Chocopackage should exist" { 
            Test-Path "$OutDirPath\testchocopackage.1.0.0.nupkg" 
        }
    }
}

