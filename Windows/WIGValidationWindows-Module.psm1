
function Get-FreeDiskSpace {
    <#
    .SYNOPSIS
    Checks Free Diskspace against passed minimum value
    .DESCRIPTION
    Checks Free Diskspace against passed minimum value. Returns an object with result and friendly description
    .PARAMETER DriverLetter
    Drive letter to check for freespace.
    .PARAMETER MinimumSizeInGB
    If the free space in GB is less than this value, then the result is Fail
    .EXAMPLE
    Get-FreeDiskSpace -DriverLetter C -MinimumSizeInGB 10

    Description
    -----------
    Checks Free Diskspace against passed minimum value. Returns an object with result and friendly description
    #>

    [CmdletBinding()]

    Param
    (
        [Parameter(Mandatory=$true,
        HelpMessage = 'Drive Letter to Verify, for example: C')]
        [string] $DriveLetter,

        [Parameter(Mandatory = $True,
        HelpMessage = 'Minimum amount of recommended Free Disk Space on Boot partition')]
        [int]$MinimumSizeInGB
    )

    Write-debug "Info - Attempting to ger free disk space"

    $FreeSpaceInGBLong = [long]((Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='$($DriveLetter):'").freespace)/1GB
    $FreeSpaceInGB = [math]::Round($FreeSpaceInGBLong,2)

    Write-debug "Info - Free space for drive $($Driveletter): $($FreeSpaceInGB)"

    if($FreeSpaceInGB -ge $MinimumSizeInGB){
        $TestResult= "Pass"
    }else{
        $TestResult = "Fail"
    }

    $TestDescription =  "Test: Verify this system has at least $MinimumSizeInGB Gigabytes free on drive letter $DriveLetter.  Result: $TestResult"
    $ResultObject = [PSCustomObject] @{'result'=$TestResult;'Description'=$TestDescription}

    return $ResultObject


}


# -------------------------------------------------------------------------------------

