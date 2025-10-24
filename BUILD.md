# Build Guide - Windows System File Repair Tool

This guide explains how to build the Windows System File Repair Tool from source and create a standalone executable.

## Overview

The build process converts the PowerShell script (`Windows-Repair.ps1`) into a standalone Windows executable (`SystemRepairTool.exe`) using the ps2exe PowerShell module.

## Prerequisites

### System Requirements
- Windows 10, Windows 11, or Windows Server
- PowerShell 5.1 or PowerShell 7+
- Administrator privileges
- Internet connection (for downloading dependencies)
- At least 100MB free disk space

### Dependencies
The build script automatically handles dependencies:
- **ps2exe module** - Converts PowerShell scripts to executables
- **.NET Framework** - Required by ps2exe (usually pre-installed)

## Build Process

### Quick Build
```powershell
# Open PowerShell as Administrator
# Navigate to the project directory
cd "c:\scripts\System Repair Scripts"

# Run the build script
.\Build-Executable.ps1
```

### Manual Build Steps
If you prefer to build manually:

```powershell
# 1. Install ps2exe module
Install-Module -Name ps2exe -Scope CurrentUser -Force

# 2. Import the module
Import-Module ps2exe

# 3. Convert script to executable
Invoke-ps2exe -InputFile "Windows-Repair.ps1" -OutputFile "SystemRepairTool.exe" -RequireAdmin -x64 -Verbose
```

## Build Configuration

The build script uses these settings:

| Parameter | Value | Description |
|-----------|--------|-------------|
| `InputFile` | Windows-Repair.ps1 | Source PowerShell script |
| `OutputFile` | SystemRepairTool.exe | Target executable name |
| `NoConsole` | false | Shows console window |
| `NoOutput` | false | Enables output messages |
| `NoError` | true | GUI error messages |
| `RequireAdmin` | true | Requires administrator privileges |
| `x64` | true | 64-bit executable |
| `IconFile` | icon.ico | Custom icon (optional) |

## Customization

### Adding a Custom Icon
1. Place your icon file as `icon.ico` in the script directory
2. The build script will automatically detect and use it
3. Icon should be in .ico format with multiple sizes (16x16, 32x32, 48x48, 256x256)

### Modifying Build Parameters
Edit `Build-Executable.ps1` and adjust the `$params` hashtable:

```powershell
$params = @{
    InputFile = $scriptPath
    OutputFile = $exePath
    NoConsole = $false      # Set to $true to hide console
    RequireAdmin = $true    # Set to $false for non-admin execution
    x64 = $true            # Set to $false for 32-bit
    # Add other parameters as needed
}
```

### Build Output Locations
You can customize output paths by modifying these variables in the build script:

```powershell
$scriptPath = Join-Path -Path $PSScriptRoot -ChildPath "Windows-Repair.ps1"
$exePath = Join-Path -Path $PSScriptRoot -ChildPath "SystemRepairTool.exe"
$iconPath = Join-Path -Path $PSScriptRoot -ChildPath "icon.ico"
```

## Build Output

### Successful Build
```
Installing ps2exe module...
Building executable...
Source: C:\scripts\System Repair Scripts\Windows-Repair.ps1
Output: C:\scripts\System Repair Scripts\SystemRepairTool.exe
Using icon: C:\scripts\System Repair Scripts\icon.ico

Build successful!
Executable created: C:\scripts\System Repair Scripts\SystemRepairTool.exe
File size: 8.42 MB

Executable Details:
  Name: SystemRepairTool.exe
  Created: 10/24/2025 2:30:15 PM
  Path: C:\scripts\System Repair Scripts\SystemRepairTool.exe
```

### File Size Expectations
- **Typical size**: 8-12 MB
- **Includes**: PowerShell runtime, .NET dependencies, and script code
- **Standalone**: No external dependencies required

## Troubleshooting

### Common Build Issues

#### Module Installation Fails
```powershell
# Error: Unable to install ps2exe
# Solution: Use different installation method
Install-Module -Name ps2exe -Force -AllowClobber -Scope CurrentUser -Repository PSGallery
```

#### Execution Policy Restrictions
```powershell
# Error: Execution policy prevents script execution
# Solution: Set execution policy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

#### Antivirus Interference
- **Symptoms**: Build fails, files disappear, or "Access Denied" errors
- **Solutions**: 
  - Temporarily disable real-time protection
  - Add project directory to exclusions
  - Use Windows Defender exclusions for the build directory

#### Build Succeeds But Executable is Large
- **Normal**: ps2exe creates self-contained executables (8-12 MB is normal)
- **Optimization**: Not much can be done as it includes PowerShell runtime

#### Icon Not Applied
- **Check**: Ensure `icon.ico` exists in the script directory
- **Format**: Icon must be in .ico format
- **Sizes**: Include multiple icon sizes for best results

### Testing the Build

#### Basic Functionality Test
```powershell
# Test if executable was created
Test-Path "SystemRepairTool.exe"

# Check file properties
Get-Item "SystemRepairTool.exe" | Select-Object Name, Length, CreationTime

# Test execution (will require admin privileges)
.\SystemRepairTool.exe
```

#### Advanced Testing
1. **Copy to different computer** - Verify it runs without PowerShell installed
2. **Test on different Windows versions** - Ensure compatibility
3. **Run without admin** - Should prompt for elevation
4. **Antivirus scan** - Check for false positives

## Distribution

### Preparing for Distribution
1. **Test thoroughly** on clean systems
2. **Document requirements** (Windows version, etc.)
3. **Consider code signing** for enterprise distribution
4. **Create installation package** if needed

### Deployment Options
- **Direct copy** - Simply copy the .exe file
- **ZIP archive** - Include documentation files
- **Installer package** - Use tools like NSIS or WiX
- **Group Policy** - Deploy via Active Directory

### Security Considerations
- **Code signing** - Prevents "Unknown Publisher" warnings
- **Hash verification** - Provide SHA256 checksums
- **Source availability** - Keep source code accessible for security audits

## Advanced Build Options

### Building for Different Architectures
```powershell
# 32-bit build
Invoke-ps2exe -InputFile "Windows-Repair.ps1" -OutputFile "SystemRepairTool-x86.exe" -x86

# 64-bit build (default)
Invoke-ps2exe -InputFile "Windows-Repair.ps1" -OutputFile "SystemRepairTool-x64.exe" -x64
```

### Debugging Build Issues
```powershell
# Enable verbose output
Invoke-ps2exe -InputFile "Windows-Repair.ps1" -OutputFile "SystemRepairTool.exe" -Verbose -Debug
```

### Automated Build Scripts
For CI/CD environments, create automated build scripts:

```powershell
# automated-build.ps1
param(
    [string]$Version = "1.0.0",
    [string]$OutputDir = ".\dist"
)

# Create output directory
New-Item -ItemType Directory -Path $OutputDir -Force

# Build executable
$outputPath = Join-Path $OutputDir "SystemRepairTool-v$Version.exe"
Invoke-ps2exe -InputFile "Windows-Repair.ps1" -OutputFile $outputPath -RequireAdmin -x64

# Create checksum
$hash = Get-FileHash $outputPath -Algorithm SHA256
$hash.Hash | Out-File "$outputPath.sha256"
```

## Support

For build-related issues:
1. Check this guide's troubleshooting section
2. Verify all prerequisites are met
3. Test with a clean PowerShell session
4. Check ps2exe documentation for advanced options