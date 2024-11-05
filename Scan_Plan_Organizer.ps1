# Get the directory where the script is located
$folderPath = $PSScriptRoot

# Get the name of this script file
$scriptName = [System.IO.Path]::GetFileName($PSCommandPath)

# Verify the current working directory actually exists
if (Test-Path $folderPath) {
    # Define the output file for all file names and extensions
    # This will save the output of this script in the current working directory
    $outputFile = Join-Path -Path $folderPath -ChildPath "file_list.txt"

    # Get all file names in all folders and subfolders, excluding the script file itself
    $files = Get-ChildItem -Path $folderPath -Recurse -File | Where-Object { $_.Name -ne $scriptName }

    # Group files by extension
    $groupedFiles = $files | Group-Object Extension

    # Write the grouped file names to an output text file
    foreach ($group in $groupedFiles) {
        # Write the extension header (e.g., ".txt files")
        Add-Content -Path $outputFile -Value "`r`n$($group.Name) files:"

        # Write each file in this extension group
        $group.Group | ForEach-Object { Add-Content -Path $outputFile -Value $_.Name }
    }

    Write-Host "File list has been saved to $outputFile"
} else {
    Write-Host "The folder path does not exist."
}
