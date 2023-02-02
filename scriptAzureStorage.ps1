#V1.0
Import-Module Az

#Connection
$connectionString = "<connectionString>"
$storageAccount = New-AzStorageContext -ConnectionString $connectionString

#Calcolo dimensione totale blob
$blobs = Get-AzStorageBlob -Container <container> -Blob "<blob>" -Context $storageAccount
$containerSize = ($blobs | Measure-Object -Property Length -Sum).Sum  / 1MB
$containerSize = "{0:0.00}" -f $containerSize

#Output Risultato
Write-Output "La dimensione di dbFiles e': $containerSize MB"

#Divisione dei file in base all'anno
$filesByYear = $blobs | Group-Object -Property { $_.BlobProperties.CreatedOn.Year } 

#Calcolo della dimensione per anno
foreach ($group in $filesByYear) {
  $yearlyBlobs = $group.Group
  $yearlySize = ($yearlyBlobs | Measure-Object -Property Length -Sum).Sum  / 1MB
  $yearlySize = "{0:0.00}" -f $yearlySize
  $year = $group.Name

  #Output Risultato
  Write-Output "La dimensione di dbFiles nel $year e': $yearlySize MB"
}