# Get the directory where the script is located (this is the base folder where the scan is performed)
$folderPath = $PSScriptRoot

# Get the name of the script file
$scriptName = [System.IO.Path]::GetFileName($PSCommandPath)

# Check if the folder exists
if (Test-Path $folderPath) {
    # Define the output file for the names, extensions, and creation dates (this will save the output in the same directory as the script)
    $outputFile = Join-Path -Path $folderPath -ChildPath "categorized_file_list.txt"

    # Function to output section data
    function Output-Section ($sectionName, $files) {
        # Write the section header even if no files are found
        if ($files.Count -gt 0) {
            Add-Content -Path $outputFile -Value "`r`n$sectionName"
	    Add-Content -Path $outputFile -Value "‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑"
        } else {
            Add-Content -Path $outputFile -Value "`r`n$sectionName"
	    Add-Content -Path $outputFile -Value "‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑"
	    Add-Content -Path $outputFile -Value "No files found!!!"
	    Add-Content -Path $outputFile -Value "‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑"
        }

        # If files are found, list them with their creation dates
        if ($files.Count -gt 0) {
            $files | ForEach-Object {
                $createdDate = $_.CreationTime.ToString('dd MMMM yyyy')
                Add-Content -Path $outputFile -Value "$($_.Name) | Created: $createdDate | .\$($_.Directory.Name)"
		Add-Content -Path $outputFile -Value "‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑"
                
            }
        }
    }

    # Collect all files in the folder and subfolders, excluding the script file
    $files = Get-ChildItem -Path $folderPath -Recurse -File | Where-Object { $_.Name -ne $scriptName }

    # Diagrams: Files with .png, .jpg, or .jpeg extensions
    $diagrams = $files | Where-Object { $_.Extension -match '\.(png|jpe?g)$' }
    Output-Section "Topology Diagram(s)" $diagrams

    # Hardware & Software: Files with "HW" or "SW" in the name and .xlsx extension based on folder name
    $hardwareSoftwareFiles = $files | Where-Object { ($_.Extension -eq ".xlsx") -and ($_.Name -match "HW|(?i)Hardware|SW|(?i)Software") }

    # Separate files based on folder name containing "Hardware" or "Software"
    $hardware = $hardwareSoftwareFiles | Where-Object { $_.DirectoryName -match "(?i)Hardware" }
    Output-Section "Hardware List" $hardware

    $software = $hardwareSoftwareFiles | Where-Object { $_.DirectoryName -match "(?i)Software" }
    Output-Section "Software List" $software

    # Access: Files with "Access" in the name
    $access = $files | Where-Object { $_.Name -match "(?i)Access|(?i)Access.*Control|(?i)Access.*Management" }
    Output-Section "Access Control Plan or Policy" $access

    # Audit: Files with "Audit" in the name
    $audit = $files | Where-Object { $_.Name -match "(?i)Audit|(?i)Accountability" }
    Output-Section "Audit and Accountability Control Plan or Policy" $audit

    # Configuration: Files with "Configuration" in the name
    $configuration = $files | Where-Object { $_.Name -match "(?i)Configuration|(?i)Configuration.*Management" }
    Output-Section "Configuration Management Plan or Policy" $configuration

    # Incident: Files with "Incident" in the name
    $incident = $files | Where-Object { $_.Name -match "(?i)Incident|(?i)Incident.*Response" }
    Output-Section "Incident Response Plan or Policy" $incident

    # Applicability: Files with "Scan" in the name
    $applicability = $files | Where-Object { $_.Name -match "(?i)Scan.*Plan" }
    Output-Section "STIG Applicability List" $applicability

    # PPSM: Files with "PPSM" in the name
    $ppsm = $files | Where-Object { $_.Name -match "(?i)PPSM" }
    Output-Section "PPSM" $ppsm

    Write-Host "Categorized file list has been saved to $outputFile"
} else {
    Write-Host "The folder path does not exist."
}
