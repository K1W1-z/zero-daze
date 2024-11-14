# Value of the directory where the script is located
$folderPath = $PSScriptRoot

# Value of the name of this script
$scriptName = [System.IO.Path]::GetFileName($PSCommandPath)

# Verify the current directory actually exists
if (Test-Path $folderPath) {
    # Define the output file (this will save the output in the same directory as the script)
    $outputFile = Join-Path -Path $folderPath -ChildPath "file_list.txt"

    # Get all files in the current folder and its subfolders, excluding the script itself
    $files = Get-ChildItem -Path $folderPath -Recurse -File | Where-Object { 
        $_.Name -ne $scriptName -and ($_.Extension -eq ".nessus" -or $_.Extension -eq ".ckl" -or $_.Extension -eq ".xml")
    }

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
        Add-Content -Path $outputFile -Value "‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑"
    }

    # Nessus file scanner output header
    Add-Content -Path $outputFile -Value "Found Nessus File Scan Times"
    Add-Content -Path $outputFile -Value "‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑"    

    # Value of all .nessus files in the current and sub directory
    $nessusFiles = Get-ChildItem -Path $folderPath -Recurse -Filter "*.nessus" -File

    # Parse through each .nessus file
    foreach ($file in $nessusFiles) {
        # Parsing lines containing "HOST_END" but exclude "HOST_END_TIMESTAMP"
        $matchingLines = Get-Content $file.FullName | Where-Object { $_ -match "HOST_END" -and $_ -notmatch "HOST_END_TIMESTAMP" }        

	# If there are matching lines, extract content between >< and write them to the output file
        foreach ($line in $matchingLines) {
            # Use regular expression to capture content between the tags < > (ignoring the tag names)
            if ($line -match '"HOST_END">(.*?)</tag>') {
                $hostEndContent = $matches[1]
                "$($file.Name) | '$hostEndContent'" | Add-Content -Path $outputFile
            }
        }
    }

    Write-Host "File list results have been saved to $outputFile"
} else {
    Write-Host "The folder path does not exist."
}
