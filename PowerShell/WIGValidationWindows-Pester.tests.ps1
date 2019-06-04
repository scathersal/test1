import-Module -Name Pester
Import-Module "$PSScriptRoot\WIGValidationWindows-Module" -DisableNameChecking -force -ErrorAction Stop

inmodulescope WIGValidationWindows-Module   {

    Describe "Get-FreeDiskSpace" {

        it 'Returns Pass' {
            mock Get-WmiObject -MockWith {[PSCustomObject] @{'freespace' = "381770240000"}}
            (Get-FreeDiskSpace -DriveLetter C -MinimumSizeInGB 10).result | Should be "Pass"
        }

        it 'Returns Fail' {
            mock Get-WmiObject -MockWith {[PSCustomObject] @{'freespace' = "240000"}}
            (Get-FreeDiskSpace -DriveLetter C -MinimumSizeInGB 10).result | Should be "Fail"
        }

        it 'Throws an error' {
            mock Get-WmiObject -MockWith {[PSCustomObject] @{'freespace' = "xx"}}
         {Get-FreeDiskSpace -DriveLetter C -MinimumSizeInGB 10} |  Should -Throw
        }

    }

}