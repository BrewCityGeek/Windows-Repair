# Windows System File Repair Utility

A PowerShell script that automates the process of repairing Windows system files by running DISM and SFC commands with proper error checking and user feedback.

## Overview

This script performs a comprehensive Windows system file repair process using built-in Windows utilities:
- **DISM (Deployment Image Servicing and Management)** - Repairs the Windows component store
- **SFC (System File Checker)** - Scans and repairs system files

## Features

- ✅ **Administrator Privilege Check** - Ensures script runs with proper permissions
- ✅ **Sequential Repair Process** - Runs repairs in the correct order for maximum effectiveness
- ✅ **Error Handling** - Stops execution if any step fails to prevent further issues
- ✅ **User-Friendly Interface** - Clear progress indicators and colored output
- ✅ **Safe Execution** - Validates each step before proceeding to the next
- ✅ **Executable Distribution** - Can be compiled to a standalone .exe file
- ✅ **No Dependencies** - Executable version requires no PowerShell knowledge

## System Requirements

- **Operating System**: Windows 10, Windows 11, or Windows Server
- **Permissions**: Administrator privileges required
- **PowerShell**: Windows PowerShell 5.1 or PowerShell 7+
- **Time**: Allow 15-30 minutes or more for completion

## Repair Process

The script performs these steps in sequence:

1. **DISM CheckHealth** - Quick scan of the component store health
2. **DISM ScanHealth** - Thorough scan for component store corruption
3. **DISM RestoreHealth** - Repairs any detected corruption in the Windows image
4. **SFC Scan** - Scans and repairs system files using the restored Windows image

## Files

- `Windows-Repair.ps1` - Main repair script
- `Build-Executable.ps1` - Converts the PowerShell script to a standalone .exe
- `SystemRepairTool.exe` - Compiled executable (created by build script)
- `icon.ico` - Optional icon file for the executable
- `README.md` - This file (overview and quick start)
- `USAGE.md` - Detailed usage instructions
- `BUILD.md` - Comprehensive build guide

## Quick Start

### Option 1: Using the Executable (Recommended)
1. Download or build `SystemRepairTool.exe`
2. Double-click `SystemRepairTool.exe` to run
3. Follow the on-screen prompts
4. Restart your computer when prompted

### Option 2: Using PowerShell Script
1. Download the script to your computer
2. Right-click `Windows-Repair.ps1`
3. Select "Run with PowerShell" or "Run as Administrator"
4. Follow the on-screen prompts
5. Restart your computer when prompted

### Option 3: Build Your Own Executable
1. Run `Build-Executable.ps1` to create the .exe file
2. Use the generated `SystemRepairTool.exe`

## Safety

This script only uses official Microsoft utilities and makes no direct modifications to system files. All repairs are performed by Windows' built-in repair tools.

## When to Use

Run this script when experiencing:
- Windows Update failures
- System file corruption errors
- Blue screen errors (BSOD)
- Windows features not working properly
- General system instability

## Author

Created by: Gemini

## License

This script is provided as-is for educational and repair purposes. Use at your own risk.