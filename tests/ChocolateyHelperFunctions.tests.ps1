Import-Module $PSScriptRoot\..\source\modules\ChocoHelperFunctions.psm1 -Force
Describe "Invoke executable testing " {
    it "Unknown path should throw" {
        $commandname = "xcopy"
        $phonyarguments = "abc def"
        {Invoke-Executeable -executablePath $commandname -arguments $phonyarguments } | Should throw
    }
    it "Lastexitcode powershell should be the same as exitcode exe" {
        #xcoyp exit code 4 : Initialization error occurred. There is not enough memory or disk space, or you entered an invalid drive name or invalid syntax on the command line.
        #https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/xcopy
        $expectedExitcode = 4
        $commandname = "xcopy"
        $phonyarguments = "abc def"
        try {Invoke-Executeable -executablePath $commandname -arguments $phonyarguments } catch{}
        $LASTEXITCODE | Should Be $expectedExitcode
    }

}