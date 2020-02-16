Import-Module $PSScriptRoot\..\source\modules\ChocolateyFunctions.psm1 -Force

Describe "Chocolatey Publish functions" {
    $nuspecFileLocation = "$PSScriptRoot\assets\TestChocoPackage\testchocopackage.nuspec"
    $OutDirPath = (New-TemporaryDirectory).fullname
    $source = (New-TemporaryDirectory).fullname
    $packagename = "testchocopackage.1.0.0.nupkg"
    Invoke-ChocoPack -NuSpecFilePath $nuspecFileLocation -OutputFolderPath $OutDirPath -UseBuildinChoco 
    it "Chocopackage should exist" { 
        Test-Path "$OutDirPath\$packagename" 
    }
    it "Choco publish should not throw error to dir" {
        { Publish-Chocopackage -PackagePath "$OutDirPath\$packagename" -Source $source -Force} |
        Should Not throw
    }

    it "Published package should exist" {
        Test-Path "$source\$packagename"
    }

    it "Choco publish to none-existing source should throw" {
      { Publish-Chocopackage -PackagePath "$OutDirPath\$packagename" -Source "\\fakechocosource" } |
        Should throw    
    }
    #TODO add test with http(s) nuget/chocolatey stream/server
}