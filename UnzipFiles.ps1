# Set the folder path containing the .rar files
$folderPath = "F:\MOD\Test"

# Set the path to WinRAR executable
$winrarPath = "C:\Program Files (x86)\WinRAR\WinRAR.exe"

# Set the password used during compression
$password = "Password"

# Check if WinRAR exists
if (-not (Test-Path $winrarPath)) {
    Write-Error "WinRAR not found at $winrarPath"
    exit
}

# Get all .rar files in the folder
Get-ChildItem -Path $folderPath | Where-Object {
    -not $_.PSIsContainer -and ($_.Extension -eq ".rar")
} | ForEach-Object {
    $rarFile = $_
    $extractPath = $folderPath  # Extract to same folder (can be changed)

    # Extract the archive with password
    & "$winrarPath" x -ep1 -p"$password" "$($rarFile.FullName)" "$extractPath\" | Out-Null

    # Check if extraction was successful
    if ($LASTEXITCODE -eq 0) {
        # Optionally delete the original RAR file
        Remove-Item -Path $rarFile.FullName -Force
        Write-Host "✅ Extracted and deleted: $($rarFile.Name)"
    } else {
        Write-Warning "❌ Failed to extract: $($rarFile.Name)"
    }
}
