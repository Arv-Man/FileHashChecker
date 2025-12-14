# FileHashChecker.ps1
# Drag-and-drop file hash calculator with optional checksum verification

if ($args.Count -lt 1) {
    Write-Host "No file provided. Drag a file onto the shortcut."
    Pause
    exit
}

$FilePath = $args[0]

if (!(Test-Path -LiteralPath $FilePath)) {
    Write-Host "File not found:"
    Write-Host $FilePath
    Pause
    exit
}

Write-Host "Calculating hashes for:"
Write-Host $FilePath
Write-Host ""

$algorithms = "MD5","SHA1","SHA256","SHA384","SHA512"
$hashes = @{}

foreach ($algo in $algorithms) {
    $hash = Get-FileHash -LiteralPath $FilePath -Algorithm $algo
    "{0,-8} {1}" -f $algo, $hash.Hash
    $hashes[$algo] = $hash.Hash
}

# Ask the user if they want to verify a checksum
Write-Host ""
$UserChecksum = Read-Host "Paste a checksum to verify (or press Enter to skip)"

if ($UserChecksum) {
    $matchFound = $false
    foreach ($algo in $hashes.Keys) {
        if ($hashes[$algo].ToLower() -eq $UserChecksum.ToLower()) {
            Write-Host "Match found! The checksum matches $algo hash."
            $matchFound = $true
        }
    }
    if (-not $matchFound) {
        Write-Host "No matching hash found."
    }
}

Write-Host ""
Write-Host "Done."
Pause
