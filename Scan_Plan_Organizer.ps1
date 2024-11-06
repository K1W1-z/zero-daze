# Value of the directory where the script is located
$folderPath = $PSScriptRoot

# Value of the name of this script
$scriptName = [System.IO.Path]::GetFileName($PSCommandPath)

# Verify the current directory actually exists
if (Test-Path $folderPath) {
    # Define the output file (this will save the output in the same directory as the script)
    $outputFile = Join-Path -Path $folderPath -ChildPath "file_list.txt"

    # Value of all files in the current folder and its subfolders (this will exclude the name of the script)
    $files = Get-ChildItem -Path $folderPath -Recurse -File | Where-Object { $_.Name -ne $scriptName }

    # Group all files by extension
    $groupedFiles = $files | Group-Object Extension

    # Write the grouped file names and their creation dates to the output file
    foreach ($group in $groupedFiles) {
        # Value of the creation date of the first file in the group (format as "dd MMMM yyyy")
        $firstFile = $group.Group | Sort-Object CreationTime | Select-Object -First 1
        $formattedDate = $firstFile.CreationTime.ToString('dd MMMM yyyy')

        # Output of the extension type with its creation date
        Add-Content -Path $outputFile -Value "`r`n$($group.Name) | Created: $formattedDate"
	Add-Content -Path $outputFile -Value "‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑"

        # Write each file to its extension group
        $group.Group | ForEach-Object { Add-Content -Path $outputFile -Value $_.Name }
	Add-Content -Path $outputFile -Value "‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑"
    }

    Write-Host "File list has been saved to $outputFile"
} else {
    Write-Host "The folder path does not exist."
}
