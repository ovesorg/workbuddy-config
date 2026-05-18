# workbuddy-config/bootstrap.ps1
# Symlink shared configs into $env:USERPROFILE\.workbuddy\
# Run from the workbuddy-config repo root.

$ErrorActionPreference = "Stop"

$WorkbuddyDir = "$env:USERPROFILE\.workbuddy"
$RepoDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "=== WorkBuddy Config Bootstrap ===" -ForegroundColor Cyan
Write-Host "Repo:   $RepoDir"
Write-Host "Target: $WorkbuddyDir"
Write-Host

# Skills
Write-Host "[1/3] Linking skills..." -ForegroundColor Yellow
$SkillsTarget = "$WorkbuddyDir\skills"
if (-not (Test-Path $SkillsTarget)) { New-Item -ItemType Directory -Path $SkillsTarget | Out-Null }

Get-ChildItem "$RepoDir\skills" -Directory | ForEach-Object {
    $Name = $_.Name
    $Dest = "$SkillsTarget\$Name"
    if (Test-Path $Dest) {
        Write-Host "  skip: $Name (already exists)"
    } else {
        New-Item -ItemType Junction -Path $Dest -Value $_.FullName | Out-Null
        Write-Host "  linked: $Name" -ForegroundColor Green
    }
}

# Connectors
Write-Host "[2/3] Linking connectors..." -ForegroundColor Yellow
$ConnectorsTarget = "$WorkbuddyDir\connectors-marketplace\connectors"
if (-not (Test-Path $ConnectorsTarget)) { New-Item -ItemType Directory -Path $ConnectorsTarget | Out-Null }

Get-ChildItem "$RepoDir\connectors" -Directory | ForEach-Object {
    $Name = $_.Name
    $Dest = "$ConnectorsTarget\$Name"
    if (Test-Path $Dest) {
        Write-Host "  skip: $Name (already exists)"
    } else {
        New-Item -ItemType Junction -Path $Dest -Value $_.FullName | Out-Null
        Write-Host "  linked: $Name" -ForegroundColor Green
    }
}

# MCP reference
Write-Host "[3/3] MCP config..." -ForegroundColor Yellow
$McpSource = "$RepoDir\mcp.json"
$McpTarget = "$WorkbuddyDir\.mcp.shared-reference.json"
if (Test-Path $McpSource) {
    Copy-Item $McpSource $McpTarget -Force
    Write-Host "  copied: mcp.json -> $McpTarget" -ForegroundColor Green
    Write-Host "  (copy to $WorkbuddyDir\.mcp.json and edit as needed)" -ForegroundColor DarkGray
}

Write-Host
Write-Host "=== Done ===" -ForegroundColor Cyan
Write-Host "Restart WorkBuddy to pick up new skills and connectors." -ForegroundColor DarkGray
