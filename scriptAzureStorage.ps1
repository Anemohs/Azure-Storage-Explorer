#V1.1
Import-Module Az

#Connectio
$connectionString = Read-Host "Insert the Connection String"
$storageAccount = New-AzStorageContext -ConnectionString $connectionString

$start = Get-Date

#Total size of Blobs
$blobs = Get-AzStorageBlob -Container "<container>" -Blob "<blob>" -Context $storageAccount
$containerSize = ($blobs | Measure-Object -Property Length -Sum).Sum  / 1MB
$containerSize = "{0:0.00}" -f $containerSize

#Output Results
Write-Output "Size of dbFiles: $containerSize MB"

#Division file by years
$filesByYear = $blobs | Group-Object -Property { $_.BlobProperties.CreatedOn.Year } 

#Dimention of file by years
foreach ($group in $filesByYear) {
  $yearlyBlobs = $group.Group
  $yearlySize = ($yearlyBlobs | Measure-Object -Property Length -Sum).Sum  / 1MB
  $yearlySize = "{0:0.00}" -f $yearlySize
  $year = $group.Name

  #Output results
  Write-Output "Size of dbFiles in $($year): $yearlySize MB"

}

$end = Get-Date
$time = $end - $start
Write-Output "Total time elapsed: $($time.TotalSeconds) seconds"
