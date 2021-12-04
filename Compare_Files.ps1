$Path1 = Read-Host 'Please insert the path No.1:'
$Path2 = Read-Host 'Please insert the path No.2:'
$Files_in_Path1 = Get-ChildItem -Recurse -path $Path1
$Files_in_Path2 = Get-ChildItem -Recurse -path $Path2
Compare-Object -ReferenceObject $Files_in_Path1 -DifferenceObject $Files_in_Path2
