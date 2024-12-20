# Define the input and output file paths
$configFile = "IOS-XE-IBNS2_0-Template.cfg" # Input file with Jinja2 variables
$outputFile = "IOS-XE-IBNS2_0-Final.cfg" # Final configuration file

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
$uniqueVariables = ($matches | ForEach-Object { $_.Groups[1].Value.ToLower() }) | Sort-Object -Unique

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