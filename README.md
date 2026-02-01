# Chrome-AI-Policy-Toggle-Windows-

which is the same mechanism used by corporate IT environments and managed devices.

---

## What this script does

The script allows you to:

- Disable Chrome AI features such as:
  - Tab Organizer
  - Help Me Write / Help Me Read
  - Gemini integration
  - AI wallpapers and backgrounds
  - AI image and photo tools
  - Autofill AI predictions
  - AI mode and local models

- Re-enable all features by removing the policies.
- Check current status.
- Use either:
  - Interactive menu
  - Or silent CLI mode for automation.

All changes are **fully reversible**.

---

## Why use this instead of Chrome settings?

Chrome’s UI toggles:

- Reset on updates  
- Are profile-based  
- Can be overridden by experiments or rollouts  

This script uses **Chrome Enterprise Policy**, which means:

- Works for all users on the machine
- Survives Chrome updates
- Cannot be overridden from the UI
- Is the same method used by real IT departments

---

## Requirements

- Windows 10 / 11
- PowerShell 5+ or PowerShell Core
- Must be run **as Administrator**

---

## Usage

### Interactive menu

```powershell
.\ChromeAI-PolicyToggle.ps1

