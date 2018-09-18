# Note: need this to be run first time on a system for logs
#  New-EventLog -LogName Application -Source "OmegaLink"
#Write-EventLog -LogName "Application" -Source "OmegaLink" -EventId 1000 -Message "Started"

# Gets the specified registry value or $null if it is missing
function Get-RegistryValue($path, $name) {
    $key = Get-Item -LiteralPath $path -ErrorAction SilentlyContinue
    if ($key) {
        $key.GetValue($name, $null)
    }
}
#Write-EventLog -LogName "Application" -Source "OmegaLink" -EventId 1000 -Message "Called with '$args'"

$uri = [System.Uri]$args[0]

if ($uri.Scheme -ne "omegalink") {
    $tmp = Read-Host -Prompt "Unknown URI scheme"
    Exit 1
}

# Look for a per-host prefix
#Write-EventLog -LogName "Application" -Source "OmegaLink" -EventId 1000 -Message "Host $($uri.host)"
$prefix = Get-RegistryValue Registry::HKEY_CLASSES_ROOT\omegalink "prefix_$($uri.host)"
if ($prefix -eq $null) {
    # Otherwise, use the default
    $prefix = Get-RegistryValue Registry::HKEY_CLASSES_ROOT\omegalink prefix
}
if ($prefix -eq $null) {
    #$tmp = Read-Host -Prompt "Prefix not set"
    Exit 1
}

$filename = $prefix + $uri.LocalPath -replace "/", "\"
#Write-EventLog -LogName "Application" -Source "OmegaLink" -EventId 1000 -Message "Opening '$filename' prefix '$prefix'"
$explorer = Join-Path $env:windir explorer.exe
Start-Process -FilePath $explorer -ArgumentList "/select, ""$filename"""
