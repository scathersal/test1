$test = @"
{
  "Windows": [
    {
        "TestName": "CheckFreeDiskSpace",
        "Enabled": true,
        "Params": {
            "MinimumSizeInGB": 10,
            "DriveLetter": "C"
        }
    },
    {
        "TestName": "CheckFreeDiskSpace2",
        "Enabled": true,
        "Params": {
            "MinimumSizeInGB": 10,
            "DriveLetter": "C"
        }
    }
  ]
}
"@



$TestConfigConverted = ConvertFrom-Json -InputObject $test

foreach ($test in $TestConfigConverted.Windows)
{
    #Write-Output "name: $($test.testname)"
    #Write-Output "enabled: $($test.enabled)"

    #create hash table
    $Parameters = New-Object HashTable
    foreach ($property in $test.Params.PSObject.Properties){
        $Parameters.Add($property.Name,$property.Value)
    }

    #call the function
    Write-Output $test.TestName @Parameters

}


# $parameters = @{
#     First = "Hello"
#     Second = "World"
# }