# Set the folder path containing the files/folders
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

# Get all items (files + folders) in the folder
Get-ChildItem -Path $folderPath | Where-Object {
    # Skip .zip and .rar files
    ($_.Extension -ne ".zip") -and ($_.Extension -ne ".rar")
} | ForEach-Object {
    $item = $_
    $rarName = "$($item.BaseName).rar"
    $rarPath = Join-Path $folderPath $rarName

    # Skip if .rar archive already exists
    if (Test-Path $rarPath) {
        Write-Host "Skipping $($item.Name) - RAR already exists."
    } else {
        # Create password-protected RAR archive
        & "$winrarPath" a -ep1 -p"$password" "$rarPath" "$($item.FullName)" | Out-Null

        # If successful, delete original file or folder
        if (Test-Path $rarPath) {
            if ($item.PSIsContainer) {
                Remove-Item -Recurse -Force "$($item.FullName)"
                Write-Host "✅ Compressed and deleted folder: $($item.Name)"
            } else {
                Remove-Item -Force "$($item.FullName)"
                Write-Host "✅ Compressed and deleted file: $($item.Name)"
            }
        } else {
            Write-Warning "❌ Failed to compress: $($item.Name)"
        }
    }
}
