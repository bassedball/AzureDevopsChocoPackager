Import-Module $PSScriptRoot\..\source\modules\ChocolateyFunctions.psm1 -Force

Describe "Chocolatey Publish functions" {
    $nuspecFileLocation = "$PSScriptRoot\assets\TestChocoPackage\testchocopackage.nuspec"
    $OutDirPath = (New-TemporaryDirectory).fullname
    $source = (New-TemporaryDirectory).fullname
    Invoke-ChocoPack -NuSpecFilePath $nuspecFileLocation -OutputFolderPath $OutDirPath -UseBuildinChoco 
    it "Chocopackage should exist" { 
        Test-Path "$OutDirPath\testchocopackage.1.0.0.nupkg" 
    }
    it "Choco publish should not throw error to dir" {
        { Publish-Chocopackage -PackagePath "$OutDirPath\testchocopackage.1.0.0.nupkg" -Source $source -Force} |
        Should Not throw
    }

    it "Published package should exist" {
        Test-Path "$source\testchocopackage.1.0.0.nupkg"
    }
}