<#
    .SYNOPSIS
    This script runs the WIGs validation tests

    .Example
    WIGValidationWindowsControl

    .DESCRIPTION
    Runs the checks

    Managed by:  AMS

    Versions:
    1.0 - Original
 #>

#  param
#  (
#      [Parameter(Mandatory = $True,
#      HelpMessage='Please Specify SSM Parameter path. For example /SASSetArchiveSite/Prod/ or /SASSetArchiveSite/Dev/' )]
#      [string]$ParmStorePath

#  )


 # ------------------ Setup ----------------------------------------------------------------------------

 Import-Module "$PSScriptRoot\WIGValidationWindows-Module" -DisableNameChecking -force -ErrorAction Stop


 # ------------------ Main ------------------------------------------------------------------------------


 # Get the data from the YAML file. This file must be located in the current directory
 Try
 {
    Write-Output "Reading configuration file...`n`r"

    $ConfigFilePath = "$PSSCriptRoot\WIGValidationWindows-Config.json"
    $TestConfigRaw = Get-Content -Raw -Path $ConfigFilePath
    $TestConfigConverted = ConvertFrom-Json -InputObject $TestConfigRaw

 }
 catch
 {
     $errorMessage = $error[0].ToString()
     $fullmessage = "Error - Attempting to read the config file found at $($ConfigFilePath).  Error:$errorMessage"
     Write-Output $fullmessage
     exit
 }


# Loop Through each Standard test
foreach ($Test in $TestConfigConverted.Windows)
{
    try {
        if ($Test.Enabled)
        {
            # Create hash table of the Params
            $Parameters = New-Object HashTable
            foreach ($property in $test.Params.PSObject.Properties){
                $Parameters.Add($property.Name,$property.Value)
            }

            # Call the function with the Params from the JSON
            $result = & $test.TestName @Parameters

            write-output $result.Description
        }
    }
    catch {
        $error[0]
    }
}
