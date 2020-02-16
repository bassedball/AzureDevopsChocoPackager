Import-Module $PSScriptRoot\..\source\modules\ChocolateyFunctions.psm1 -Force
Describe "Chocolatey instance testing" {
    InModuleScope ChocolateyFunctions {
        Context "Local Choco Command not found." {
            Mock Get-Command  { throw [System.Management.Automation.CommandNotFoundException] "Command not found."} -ParameterFilter { $Name -eq "choco" }
                    
            It "local chocolaty should return null" {
                Get-LocalChocolateyInstall | Should Be $null
                
            }
            It "Get-command Should be called once" {
                Assert-MockCalled Get-Command 1
            }           
        }

        Context "Local Choco Command Found" {
            Mock Get-Command  { 
                return [PSCustomObject]@{
                    Name = 'choco.exe'
                    Version = '0.10.0.0' 
                    }
            } -ParameterFilter { $Name -eq "choco" }
            
                
            It "local chocolaty should return choco.exe as name" {
               ( Get-LocalChocolateyInstall ).Name | Should Be "choco.exe"              
            }

            It "local chocolaty should return choco.exe as name" {
                ( Get-LocalChocolateyInstall ).Version | Should Be '0.10.0.0'             
            }

            It "Get-command Should be called once" {
                Assert-MockCalled Get-Command 1
            }
        }

        Context "Get build in choco exe" {
            It "Build in choco exe should exist" {
                {Get-BuildInChocolateyExecutable} | Should Not Throw 
            }
            It "build in Choco name should be choco.exe" {
                (Get-BuildInChocolateyExecutable).Name | Should Be "choco.exe" 
            }
            It "build in Choco version should be `"0.10.15.0`""  {
                (Get-BuildInChocolateyExecutable).Name | Should Be "choco.exe" 
            }
        }

        Context "Get Chocolatey Instance Where there is local" {
            Mock Get-Command  { 
                return [PSCustomObject]@{
                    Name = 'choco.exe'
                    Version = '0.10.0.0' 
                    }
            } -ParameterFilter { $Name -eq "choco" }
            
                
            It "local chocolaty should return choco.exe as name" {
               ( Get-ChocolateyInstance ).Name | Should Be "choco.exe"              
            }

            It "local chocolaty should return choco.exe as name" {
                ( Get-ChocolateyInstance ).Version | Should Be '0.10.0.0'             
            }

            It "Get-command Should be called once" {
                Assert-MockCalled Get-Command 1
            }
        }

        Context "Get Chocolatey Instance Forced Buildin" {
            Mock Get-Command  { 
                return [PSCustomObject]@{
                    Name = 'choco.exe'
                    Version = '0.10.0.0' 
                    }
            } -ParameterFilter { $Name -eq "choco" }
            
                
            It "local chocolaty should return choco.exe as name" {
               ( Get-ChocolateyInstance -ForceUseBuildInVersion).Name | Should Be "choco.exe"              
            }

            It "local chocolaty should return choco.exe as name" {
                ( Get-ChocolateyInstance -ForceUseBuildInVersion).Version | Should Be '0.10.15.0'             
            }

            It "Get-command Should be called once" {
                Assert-MockCalled Get-Command 0
            }
        }

        Context "Get Chocolatey Instance use Buildin as fallback" {
            Mock Get-Command  { 
                return $null
            } -ParameterFilter { $Name -eq "choco" }
            
                
            It "Fallback chocolaty should return choco.exe as name" {
               ( Get-ChocolateyInstance ).Name | Should Be "choco.exe"              
            }

            It "Fallback chocolaty should return choco.exe as name" {
                ( Get-ChocolateyInstance ).Version | Should Be '0.10.15.0'             
            }

            It "Get-command Should be called twice" {
                Assert-MockCalled Get-Command 2
            }
        }
    }
}
