task default -depends Test, Linting

FormatTaskName "********* {0} *********"

task Linting {
    $Lintingesults = Invoke-ScriptAnalyzer -Path $PSScriptRoot\..\PowerShell\WIGValidationWindows-Module.psm1 -Severity 'Error' -Recurse
    if ($Lintingesults)
    {
        $Lintingesults | Write-Output
        Write-Error -Message 'PSScriptAnalyzer found error(s).Stopping build.'
        throw
    }
}


task Test -depends Linting {
    $testResults = Invoke-Pester -Script $PSScriptRoot\..\PowerShell\WIGValidationWindows-Pester.tests.ps1 -PassThru
    if ($testResults.FailedCount -gt 0)
    {
        $testResults | Format-List
        Write-Error -Message 'Pester test failed. Stopping build.'
        throw
    }
}