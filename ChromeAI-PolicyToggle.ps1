# ChromeAI-PolicyToggle.ps1
# Based on an article on askvg.com
# Adds/removes Chrome Enterprise policy DWORDs under:
#   HKLM:\SOFTWARE\Policies\Google\Chrome
# Menu:
#   Enable Chrome AI   -> removes the policy values (restores default behavior)
#   Disable Chrome AI  -> writes policy values to disable AI features

$ErrorActionPreference = "Stop"

function Assert-Admin {
    $currentIdentity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentIdentity)
    if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host "ERROR: Please run PowerShell as Administrator." -ForegroundColor Red
        exit 1
    }
}

function Ensure-ChromePolicyKey {
    param([string]$KeyPath)
    if (-not (Test-Path $KeyPath)) {
        New-Item -Path $KeyPath -Force | Out-Null
    }
}

function Disable-ChromeAI {
    param([string]$KeyPath)

    Ensure-ChromePolicyKey -KeyPath $KeyPath

    # Value conventions commonly used:
    # - Most *Settings: 2 = disable feature
    # - Some master switches: 1 = disable integration
    $policies = @{
        # “Master” integrations / platform-level toggles
        "AIModeSettings"                      = 1
        "GeminiSettings"                      = 1
        "GeminiActOnWebSettings"              = 1
        "GenAILocalFoundationalModelSettings" = 1

        # GenAI default stance (broad lever)
        "GenAiDefaultSettings"                = 2

        # Feature-specific toggles
        "TabOrganizerSettings"                = 2
        "CreateThemesSettings"                = 2
        "HelpMeWriteSettings"                 = 2
        "DevToolsGenAiSettings"               = 2
        "GenAIVCBackgroundSettings"           = 2
        "GenAIWallpaperSettings"              = 2
        "HistorySearchSettings"               = 2
        "TabCompareSettings"                  = 2
        "HelpMeReadSettings"                  = 2
        "GenAIInlineImageSettings"            = 2
        "GenAIPhotoEditingSettings"           = 2
        "GenAISmartGroupingSettings"          = 2
        "GenAiChromeOsSmartActionsSettings"   = 2
        "AutofillPredictionSettings"          = 2
        "AutomatedPasswordChangeSettings"     = 2
    }

    foreach ($name in $policies.Keys) {
        $value = [int]$policies[$name]
        New-ItemProperty -Path $KeyPath -Name $name -PropertyType DWord -Value $value -Force | Out-Null
    }

    Write-Host ""
    Write-Host "Disabled Chrome AI policies have been re-applied." -ForegroundColor Green
    Write-Host "Open chrome://policy and click 'Reload policies' (or restart Chrome) to verify."
}

function Enable-ChromeAI {
    param([string]$KeyPath)

    $namesToRemove = @(
        "AIModeSettings","GeminiSettings","GeminiActOnWebSettings","GenAILocalFoundationalModelSettings",
        "GenAiDefaultSettings","TabOrganizerSettings","CreateThemesSettings","HelpMeWriteSettings",
        "DevToolsGenAiSettings","GenAIVCBackgroundSettings","GenAIWallpaperSettings","HistorySearchSettings",
        "TabCompareSettings","HelpMeReadSettings","GenAIInlineImageSettings","GenAIPhotoEditingSettings",
        "GenAISmartGroupingSettings","GenAiChromeOsSmartActionsSettings","AutofillPredictionSettings",
        "AutomatedPasswordChangeSettings"
    )

    if (Test-Path $KeyPath) {
        foreach ($n in $namesToRemove) {
            Remove-ItemProperty -Path $KeyPath -Name $n -ErrorAction SilentlyContinue
        }
    }

    Write-Host ""
    Write-Host "Chrome AI policies were disabled (Chrome returns to defaults)." -ForegroundColor Green
    Write-Host "Open chrome://policy and click 'Reload policies' (or restart Chrome) to verify."
}

# ---------------- MAIN MENU ----------------
Assert-Admin

$chromePolicyKey = "HKLM:\SOFTWARE\Policies\Google\Chrome"

while ($true) {
    Clear-Host
    Write-Host "==========================" -ForegroundColor Cyan
    Write-Host "       Chrome AI Menu      " -ForegroundColor Cyan
    Write-Host "==========================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1) Enable Chrome AI"
    Write-Host "2) Disable Chrome AI"
    Write-Host "3) Exit"
    Write-Host ""
    $choice = Read-Host "Select an option (1-3)"

    switch ($choice) {
        "1" {
            Enable-ChromeAI -KeyPath $chromePolicyKey
            Read-Host "`nPress Enter to continue"
        }
        "2" {
            Disable-ChromeAI -KeyPath $chromePolicyKey
            Read-Host "`nPress Enter to continue"
        }
        "3" { break }
        default {
            Write-Host "`nInvalid choice. Please select 1, 2, or 3." -ForegroundColor Yellow
            Start-Sleep -Seconds 1
        }
    }
}
