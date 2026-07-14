[CmdletBinding()]
param(
    [switch]$SkipBuild
)

$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$issFile = Join-Path $PSScriptRoot 'TrafficMonitorStatsDots.iss'
$outputDir = Join-Path $repoRoot 'dist'

function Get-NextStatsDotsVersion {
    & git -C $repoRoot fetch origin --tags --quiet
    if ($LASTEXITCODE -ne 0) {
        throw "Unable to fetch release tags from origin (exit code $LASTEXITCODE)."
    }

    $tags = @(git -C $repoRoot tag -l 'v*-stats-dots')
    $versions = foreach ($tag in $tags) {
        if ($tag -match '^v(?<major>\d+)\.(?<minor>\d+)(?:\.(?<patch>\d+))?-stats-dots$') {
            [PSCustomObject]@{
                Major = [int]$Matches.major
                Minor = [int]$Matches.minor
                Patch = if ($Matches.patch) { [int]$Matches.patch } else { 0 }
            }
        }
    }

    if ($versions.Count -eq 0) {
        return '1.86.1'
    }

    $latest = $versions | Sort-Object Major, Minor, Patch -Descending | Select-Object -First 1
    return '{0}.{1}.{2}' -f $latest.Major, $latest.Minor, ($latest.Patch + 1)
}

function Find-Executable([string[]]$Candidates, [string]$Name) {
    foreach ($candidate in $Candidates) {
        if (Test-Path -LiteralPath $candidate) {
            return (Resolve-Path -LiteralPath $candidate).Path
        }
    }
    throw "$Name was not found."
}

$version = Get-NextStatsDotsVersion

if (-not $SkipBuild) {
    $msbuild = Find-Executable @(
        'D:\VSBuildTools2022\MSBuild\Current\Bin\MSBuild.exe',
        "$env:ProgramFiles\Microsoft Visual Studio\2022\BuildTools\MSBuild\Current\Bin\MSBuild.exe"
    ) 'MSBuild'
    & $msbuild (Join-Path $repoRoot 'TrafficMonitor_Lite.sln') /m /p:Configuration='Release (lite)' /p:Platform=x64 /p:PlatformToolset=v143 /verbosity:minimal
    if ($LASTEXITCODE -ne 0) {
        throw "MSBuild failed with exit code $LASTEXITCODE."
    }
}

$iscc = Find-Executable @(
    "$env:LOCALAPPDATA\Programs\Inno Setup 6\ISCC.exe",
    "${env:ProgramFiles(x86)}\Inno Setup 6\ISCC.exe"
) 'Inno Setup Compiler'

& $iscc "/DAppVersion=$version" $issFile
if ($LASTEXITCODE -ne 0) {
    throw "Inno Setup compilation failed with exit code $LASTEXITCODE."
}

$installer = Join-Path $outputDir "TrafficMonitor_${version}_StatsDots_x64_Setup.exe"
if (-not (Test-Path -LiteralPath $installer)) {
    throw "Expected installer was not created: $installer"
}

[PSCustomObject]@{
    Version = $version
    Tag = "v$version-stats-dots"
    Installer = $installer
    Sha256 = (Get-FileHash -LiteralPath $installer -Algorithm SHA256).Hash
}
