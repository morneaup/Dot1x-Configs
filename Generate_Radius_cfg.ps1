# Define configuration file paths
$ConfigFiles = @{
    "1" = ".\IOS-XE\IOS-XE-IBNS2_0-Template.cfg"
    "2" = ".\IOS\IOS-IBNS2_0-Template.cfg"
    "3" = ".\NX-OS\NX-OS-MAB-Only-Template.cfg"
}

# Define output file paths corresponding to each config type
$OutputFiles = @{
    "1" = "IOS-XE-IBNS2_0.cfg"
    "2" = "IOS-IBNS2_0.cfg"
    "3" = "NX-OS-MAB-Only.cfg"
}

# Display menu
Write-Host "Select a configuration option:`n"
Write-Host "1) IOS-XE"
Write-Host "2) IOS"
Write-Host "3) NX-OS"

# Read user selection
$selection = Read-Host "`nEnter the number of your choice"

# Validate and assign configuration path
if ($ConfigFiles.ContainsKey($selection)) {
    $ConfigFile = $ConfigFiles[$selection]
    $outputFile = $OutputFiles[$selection]
    Write-Host "`nYou selected: $ConfigFile"
    Write-Host "Output will be saved to: $outputFile"
} else {
    Write-Host "`nInvalid selection. Please run the script again and choose 1, 2, or 3." -ForegroundColor Red
    exit 1
}

# Example use of the selected config path
# (You can replace this with your own logic to load/apply the config)
Write-Host "`nUsing configuration file at path: $ConfigPath"

# Ensure the input file exists
if (-not (Test-Path $configFile)) {
    Write-Host "Input configuration file not found: $configFile" -ForegroundColor Red
    exit
}

# Read the configuration file content
$configContent = Get-Content -Path $configFile -Raw

# Define a regex pattern to find Jinja2 variables (e.g., {{ variable-name }})
$variablePattern = "{{\s*([\w-]+)\s*}}"

# Extract all unique variable names (case-insensitively)
$matches = [regex]::Matches($configContent, $variablePattern)
$uniqueVariables = ($matches | ForEach-Object { $_.Groups[1].Value.ToUpper() }) | Sort-Object -Unique

# Initialize a hashtable to store variable values
$variables = @{}

# Prompt the user to provide values for each variable
foreach ($variable in $uniqueVariables) {
    $value = Read-Host "Enter value for '$variable'"
    $variables[$variable] = $value
}

# Replace the variables in the configuration content (case-insensitive)
foreach ($variable in $variables.Keys) {
    # Construct the Jinja2 placeholder (case-insensitively)
    $placeholderPattern = "{{\s*$variable\s*}}"
    $configContent = [regex]::Replace($configContent, $placeholderPattern, $variables[$variable], 'IgnoreCase')
}

# Save the final configuration to the output file
Set-Content -Path $outputFile -Value $configContent

Write-Host "Final configuration has been generated and saved to: $outputFile" -ForegroundColor Green