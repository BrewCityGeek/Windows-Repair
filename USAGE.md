# Usage Guide - Windows System File Repair Utility

## Prerequisites

Before running the script, ensure you meet these requirements:

### System Requirements
- Windows 10, Windows 11, or Windows Server
- At least 2GB free disk space
- Stable internet connection (for DISM RestoreHealth)
- Administrator privileges

### Important Notes
⚠️ **Close all programs** before running the script  
⚠️ **Do not interrupt** the repair process once started  
⚠️ **Ensure stable power** supply (use UPS if available)  

## Running the Tool

### Method 1: Executable (Easiest)
If you have the `SystemRepairTool.exe` file:
1. Double-click `SystemRepairTool.exe`
2. Click "Yes" when prompted for Administrator privileges
3. Follow the on-screen prompts

### Method 2: PowerShell Script (Advanced)
1. Press `Windows + X` and select "Windows PowerShell (Admin)" or "Terminal (Admin)"
2. Navigate to the script directory:
   ```powershell
   cd "c:\scripts\System Repair Scripts"
   ```
3. Run the script:
   ```powershell
   .\Windows-Repair.ps1
   ```

### Method 3: File Explorer
1. Navigate to the script location in File Explorer
2. Right-click on `Windows-Repair.ps1`
3. Select **"Run with PowerShell"**
4. If prompted, choose **"Run as Administrator"**

### Method 4: Run Dialog
1. Press `Windows + R` to open Run dialog
2. Type: `powershell -ExecutionPolicy Bypass -File "c:\scripts\System Repair Scripts\Windows-Repair.ps1"`
3. Press Enter

## Building the Executable

If you want to create your own executable version:

### Prerequisites for Building
- PowerShell 5.1 or PowerShell 7+
- Internet connection (to download ps2exe module)
- Administrator privileges

### Build Process
1. Open PowerShell as Administrator
2. Navigate to the script directory:
   ```powershell
   cd "c:\scripts\System Repair Scripts"
   ```
3. Run the build script:
   ```powershell
   .\Build-Executable.ps1
   ```

### What the Build Script Does
- Automatically installs the `ps2exe` module if not present
- Converts `Windows-Repair.ps1` to `SystemRepairTool.exe`
- Configures the executable with:
  - 64-bit architecture
  - Administrator privileges requirement
  - Console window enabled
  - Optional icon support (if `icon.ico` exists)

### Build Output
After successful build, you'll see:
```
Build successful!
Executable created: c:\scripts\System Repair Scripts\SystemRepairTool.exe
File size: X.XX MB

Executable Details:
  Name: SystemRepairTool.exe
  Created: [timestamp]
  Path: [full path]
```

### Distributing the Executable
- The `.exe` file is standalone and can be copied to other computers
- No PowerShell knowledge required for end users
- Maintains all functionality of the original script
- Automatically requests Administrator privileges when run

## What to Expect

### Execution Timeline
| Step | Process | Typical Duration |
|------|---------|------------------|
| 1 | DISM CheckHealth | 1-3 minutes |
| 2 | DISM ScanHealth | 5-15 minutes |
| 3 | DISM RestoreHealth | 10-30 minutes |
| 4 | SFC Scan | 5-20 minutes |

### Screen Output
The script provides color-coded feedback:
- 🔵 **Cyan**: Headers and completion messages
- 🟢 **Green**: Step progress and success
- 🟡 **Yellow**: Warnings and recommendations
- 🔴 **Red**: Errors (if any occur)

### Sample Output
```
=================================================
     Windows System File Repair Utility
=================================================

This script will now run DISM and SFC to find and fix system file corruption.
The process can take 15-30 minutes or more. Please do not close this window.

--- Step 1 of 4: Scanning component store with DISM /CheckHealth ---
[DISM output...]
CheckHealth complete.

--- Step 2 of 4: Scanning component store with DISM /ScanHealth ---
[DISM output...]
ScanHealth complete.

--- Step 3 of 4: Repairing Windows image with DISM /RestoreHealth ---
[DISM output...]
RestoreHealth complete.

--- Step 4 of 4: Scanning system files with SFC /scannow ---
[SFC output...]
SFC scan complete.

=================================================
All repair tasks have finished successfully.
It is highly recommended you restart your computer now.
=================================================
```

## Troubleshooting

### Common Issues

#### "Execution Policy" Error
If you see an execution policy error:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

#### "Access Denied" Error
- Ensure you're running as Administrator
- Close antivirus temporarily if it blocks the script
- Try running from an elevated PowerShell prompt

#### Script Stops at DISM RestoreHealth
- Check internet connection
- Disable VPN temporarily
- Ensure Windows Update service is running

#### SFC Reports "Could not perform the requested operation"
- Run `chkdsk C: /f` first and restart
- Boot from Windows installation media and run SFC from there

#### Build Script Issues

##### ps2exe Module Installation Fails
```powershell
# Try manual installation
Install-Module -Name ps2exe -Force -AllowClobber -Scope CurrentUser
```

##### "Cannot find path" Error During Build
- Ensure `Windows-Repair.ps1` exists in the same directory as `Build-Executable.ps1`
- Check file paths for special characters or spaces

##### Antivirus Blocks Executable Creation
- Temporarily disable real-time protection
- Add the script directory to antivirus exclusions
- The built executable may be flagged as false positive initially

##### Build Succeeds But Executable Won't Run
- Check if executable requires different architecture (x86 vs x64)
- Verify administrator privileges are available
- Check Windows Defender SmartScreen settings

### Exit Codes
- **0**: Success
- **Non-zero**: Error occurred at that step

## Post-Repair Steps

### After Successful Completion
1. **Restart your computer** (highly recommended)
2. **Run Windows Update** to install any pending updates
3. **Test system functionality** that was previously problematic
4. **Run the script again** if issues persist (safe to repeat)

### Verification
To verify repairs were successful:
```powershell
# Check DISM health
DISM /Online /Cleanup-Image /CheckHealth

# Check SFC status
sfc /verifyonly
```

## Advanced Usage

### Running Specific Steps Only
If you need to run individual commands manually:

```powershell
# Step 1: Check component store health
DISM /Online /Cleanup-Image /CheckHealth

# Step 2: Scan for corruption
DISM /Online /Cleanup-Image /ScanHealth

# Step 3: Repair Windows image
DISM /Online /Cleanup-Image /RestoreHealth

# Step 4: Scan system files
sfc /scannow
```

### Logging Output
To save output to a log file:
```powershell
.\Windows-Repair.ps1 *>&1 | Tee-Object -FilePath "repair-log.txt"
```

## When to Seek Additional Help

Contact IT support if:
- Script fails repeatedly at the same step
- System still exhibits problems after successful completion
- Hardware-related error messages appear
- System becomes unstable after running the script

## Safety Information

This script is safe because:
- Uses only Microsoft-provided utilities
- Makes no direct system file modifications
- Includes comprehensive error checking
- Can be safely interrupted if needed
- Is reversible (system restore point recommended before running)