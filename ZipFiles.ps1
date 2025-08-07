# Set the folder path containing the files
$folderPath = "F:\MOD\Test"

# Set the path to WinRAR executable
$winrarPath = "C:\Program Files (x86)\WinRAR\WinRAR.exe"

# Set the password for the archives
$password = "Password"

# Check if WinRAR exists
if (-not (Test-Path $winrarPath)) {
    Write-Error "WinRAR not found at $winrarPath"
    exit
}

# Get all files (not folders) that are NOT .zip or .rar
Get-ChildItem -Path $folderPath | Where-Object {
    -not $_.PSIsContainer -and
    ($_.Extension -ne ".zip") -and
    ($_.Extension -ne ".rar")
} | ForEach-Object {
    $file = $_
    $rarName = "$($file.BaseName).rar"
    $rarPath = Join-Path $folderPath $rarName

    # Skip if .rar file already exists
    if (Test-Path $rarPath) {
        Write-Host "Skipping $($file.Name) - RAR already exists."
    } else {
        # Create RAR archive with password
        & "$winrarPath" a -ep1 -p"$password" "$rarPath" "$($file.FullName)" | Out-Null

        # If successful, delete original file
        if (Test-Path $rarPath) {
            Remove-Item -Path $file.FullName -Force
            Write-Host "✅ Compressed and deleted: $($file.Name)"
        } else {
            Write-Warning "❌ Failed to create RAR for: $($file.Name)"
        }
    }
}
