

$ErrorActionPreference = "Stop"
$Host.UI.RawUI.WindowTitle = "Enesehs's Windows Optimizer v1.1"
$Script:Version = "1.1"
$Script:LogDir = "$env:LOCALAPPDATA\EnesehsWindowsOptimizer\Logs"
$Script:LogPath = "$Script:LogDir\Enesehs-Windows-Optimizer_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
$Script:SuccessCount = 0
$Script:ErrorCount = 0
$Script:Results = @()

if (-not (Test-Path -Path $Script:LogDir)) {
    New-Item -ItemType Directory -Path $Script:LogDir -Force | Out-Null
}

$signature = @"
[DllImport("user32.dll")]
public static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int X, int Y, int cx, int cy, uint uFlags);
[DllImport("user32.dll")]
public static extern IntPtr GetConsoleWindow();
[DllImport("user32.dll")]
public static extern int GetSystemMetrics(int nIndex);
"@
Add-Type -MemberDefinition $signature -Name "Win32" -Namespace Win32Functions -PassThru | Out-Null

function Set-ConsoleWindow {
    try {
        $hwnd = [Win32Functions.Win32]::GetConsoleWindow()
        if ($hwnd -ne [IntPtr]::Zero) {
            $screenWidth = [Win32Functions.Win32]::GetSystemMetrics(0)
            $screenHeight = [Win32Functions.Win32]::GetSystemMetrics(1)
            
            $width = 1500
            $height = 1200
            
            $x = [math]::Floor(($screenWidth - $width) / 2)
            $y = [math]::Floor(($screenHeight - $height) / 2)
            
            [Win32Functions.Win32]::SetWindowPos($hwnd, [IntPtr]::new(-1), $x, $y, $width, $height, 0x0040)
        }
        
        $psBuffer = $Host.UI.RawUI.BufferSize
        $psBuffer.Width = 140
        $psBuffer.Height = 3000
        $Host.UI.RawUI.BufferSize = $psBuffer

        $psWindow = $Host.UI.RawUI.WindowSize
        $psWindow.Width = 140
        $Host.UI.RawUI.WindowSize = $psWindow
    }
    catch {}
}

Set-ConsoleWindow

$Host.UI.RawUI.BackgroundColor = "Black"
$Host.UI.RawUI.ForegroundColor = "Gray"
Clear-Host

try {
    Start-Transcript -Path $Script:LogPath -Force | Out-Null
}
catch { }

# Global spinner state
$Script:SpinnerFrames = @('|', '/', '-', '\')

function Write-Spinner {
    param(
        [string]$Message = "Processing...",
        [int]$Duration = 0, # If > 0, spins for this duration. If 0, just prints one frame (manual loop needed)
        [ConsoleColor]$Color = "Cyan"
    )
    
    $origPos = $Host.UI.RawUI.CursorPosition
    
    try {
        $Host.UI.RawUI.CursorSize = 0 
    }
    catch {}

    if ($Duration -gt 0) {
        $endTime = (Get-Date).AddSeconds($Duration)
        while ((Get-Date) -lt $endTime) {
            foreach ($frame in $Script:SpinnerFrames) {
                $Host.UI.RawUI.CursorPosition = $origPos
                Write-Host "[$frame] $Message" -ForegroundColor $Color -NoNewline
                Start-Sleep -Milliseconds 100
            }
        }
    }
    
    # Restore
    $Host.UI.RawUI.CursorPosition = $origPos
    Write-Host "   " -NoNewline # Clear spinner
    $Host.UI.RawUI.CursorPosition = $origPos
    try { $Host.UI.RawUI.CursorSize = 25 } catch {}
}

function Show-SplashScreen {
    # Hide Cursor explicitly for the entire splash screen
    try { $Host.UI.RawUI.CursorSize = 0 } catch {}
    
    Clear-Host
    $windowWidth = $Host.UI.RawUI.WindowSize.Width
    $windowHeight = $Host.UI.RawUI.WindowSize.Height
    $centerY = [math]::Floor($windowHeight / 3)
    
    # Retro Green on Black Style
    $banner = @"
░▒▓████████▓▒░▒▓███████▓▒░░▒▓████████▓▒░░▒▓███████▓▒░▒▓████████▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓███████▓▒░ 
░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░        
░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░        
░▒▓██████▓▒░ ░▒▓█▓▒░░▒▓█▓▒░▒▓██████▓▒░  ░▒▓██████▓▒░░▒▓██████▓▒░ ░▒▓████████▓▒░░▒▓██████▓▒░  
░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░             ░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░ 
░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░             ░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░ 
░▒▓████████▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓████████▓▒░▒▓███████▓▒░░▒▓████████▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓███████▓▒░  
"@
    $lines = $banner -split "`n"
    
    # Position cursor
    try { $Host.UI.RawUI.CursorPosition = @{x = 0; y = $centerY } } catch {}
    
    # Animate Banner (Retro Typewriter)
    foreach ($line in $lines) {
        $pad = [math]::Max(0, [math]::Floor(($windowWidth - $line.Length) / 2))
        Write-Host (" " * $pad) -NoNewline
        
        # Or char by char? User said "more retro". Char by char is retro.
        $charArray = $line.ToCharArray()
        foreach ($char in $charArray) {
            Write-Host $char -NoNewline -ForegroundColor Green
            # Fast type - no sleep
        }
        Write-Host ""
        Start-Sleep -Milliseconds 2 
    }
    Write-Host ""
    Write-Host ""
    
    # Animate Subtitle
    $subtitle = @"


░█░█░▀█▀░█▀█░█▀▄░█▀█░█░█░█▀▀░░░█▀█░█▀█░▀█▀░▀█▀░█▄█░▀█▀░▀▀█░█▀▀░█▀▄
░█▄█░░█░░█░█░█░█░█░█░█▄█░▀▀█░░░█░█░█▀▀░░█░░░█░░█░█░░█░░▄▀░░█▀▀░█▀▄
░▀░▀░▀▀▀░▀░▀░▀▀░░▀▀▀░▀░▀░▀▀▀░░░▀▀▀░▀░░░░▀░░▀▀▀░▀░▀░▀▀▀░▀▀▀░▀▀▀░▀░▀ 
"@
    $subLines = $subtitle -split "`n"
    foreach ($line in $subLines) {
        if (-not [string]::IsNullOrWhiteSpace($line)) {
            $pad = [math]::Max(0, [math]::Floor(($windowWidth - $line.Length) / 2))
            Write-Host (" " * $pad) -NoNewline
            Write-Host $line -ForegroundColor DarkGreen
            Start-Sleep -Milliseconds 20
        }
    }
    
    Write-Host "`n"
    
    Start-Sleep -Seconds 1
    
    # Restore Cursor
    try { $Host.UI.RawUI.CursorSize = 25 } catch {}
}

function Write-Log {
    param(
        [ValidateSet("Info", "Warning", "Error", "Success")]
        [string]$Level = "Info",
        [string]$Message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMsg = "$timestamp [$Level] $Message"
    Write-Host $logMsg -ForegroundColor DarkGray
}

function Write-Centered {
    param(
        [string]$Text,
        [ConsoleColor]$ForegroundColor = "White"
    )
    $pad = [math]::Max(0, [math]::Floor(($Host.UI.RawUI.WindowSize.Width - $Text.Length) / 2))
    Write-Host (" " * $pad) -NoNewline
    Write-Host $Text -ForegroundColor $ForegroundColor
}

function Show-Banner {
    Clear-Host
    Write-Host "`n"
    
    $banner = @"
                ░█▀▀░█▀█░█▀▀░█▀▀░█▀▀░█░█░█▀▀░▀░█▀▀                
                ░█▀▀░█░█░█▀▀░▀▀█░█▀▀░█▀█░▀▀█░░░▀▀█                
                ░▀▀▀░▀░▀░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀▀▀░░░▀▀▀                
░█░█░▀█▀░█▀█░█▀▄░█▀█░█░█░█▀▀░░░█▀█░█▀█░▀█▀░▀█▀░█▄█░▀█▀░▀▀█░█▀▀░█▀▄
░█▄█░░█░░█░█░█░█░█░█░█▄█░▀▀█░░░█░█░█▀▀░░█░░░█░░█░█░░█░░▄▀░░█▀▀░█▀▄
░▀░▀░▀▀▀░▀░▀░▀▀░░▀▀▀░▀░▀░▀▀▀░░░▀▀▀░▀░░░░▀░░▀▀▀░▀░▀░▀▀▀░▀▀▀░▀▀▀░▀░▀ 
"@
    
    $lines = $banner -split "`n"
    foreach ($line in $lines) {
        $pad = [math]::Max(0, [math]::Floor(($Host.UI.RawUI.WindowSize.Width - $line.Length) / 2))
        Write-Host (" " * $pad) -NoNewline
        Write-Host $line -ForegroundColor Green
    }
    
    $footer = "v$Script:Version  |  by Enesehs  |  enesehs.dev"
    $padFooter = [math]::Max(0, [math]::Floor(($Host.UI.RawUI.WindowSize.Width - $footer.Length) / 2))
    
    Write-Host "`n"
    Write-Host (" " * $padFooter) -NoNewline
    Write-Host $footer -ForegroundColor White
    Write-Host "`n"
}

function Confirm-Action {
    param([string]$Message)
    $response = Read-Host "$Message (Y/N)" 
    return $response -eq 'Y' -or $response -eq 'y'
}

function Show-Progress {
    param(
        [string]$Activity,
        [string]$Status,
        [int]$Step,
        [int]$TotalSteps
    )
    $percent = [math]::Round(($Step / $TotalSteps) * 100)
    Write-Progress -Activity $Activity -Status "$Status ($Step/$TotalSteps)" -PercentComplete $percent
}

function Add-Result {
    param(
        [string]$Operation,
        [string]$Status,
        [string]$Duration = "N/A"
    )
    $Script:Results += [PSCustomObject]@{
        Operation = $Operation
        Status    = $Status
        Duration  = $Duration
    }
    if ($Status -eq "Success") { $Script:SuccessCount++ } else { $Script:ErrorCount++ }
}

function Show-Summary {
    Write-Host "`n" -NoNewline
    $summaryHeader = @(
        "╔═══════════════════════════════════════════════════════════╗",
        "║                     OPERATION SUMMARY                     ║",
        "╠═══════════════════════════════════════════════════════════╣"
    )
    
    foreach ($line in $summaryHeader) {
        Write-Centered $line -ForegroundColor Cyan
    }
    
    $Script:Results | ForEach-Object {
        $statusColor = if ($_.Status -eq "Success") { "Green" } else { "Red" }
        $statusIcon = if ($_.Status -eq "Success") { "✓" } else { "✗" }
        
        $contentWidth = $summaryHeader[0].Length
        $pad = [math]::Max(0, [math]::Floor(($Host.UI.RawUI.WindowSize.Width - $contentWidth) / 2))
        Write-Host (" " * $pad) -NoNewline
        
        Write-Host "║  $statusIcon " -NoNewline -ForegroundColor $statusColor
        Write-Host "$($_.Operation.PadRight(40))" -NoNewline
        Write-Host "$($_.Status.PadRight(10))" -NoNewline -ForegroundColor $statusColor
        Write-Host " ║"
    }
    
    $summaryFooter = @(
        "╠═══════════════════════════════════════════════════════════╣",
        "║  Successful: " + "$Script:SuccessCount".PadRight(4) + " |  Failed: " + "$Script:ErrorCount".PadRight(22) + "║",
        "╚═══════════════════════════════════════════════════════════╝"
    )

 foreach ($line in $summaryFooter) {
        if ($line -match "Successful") {
            $pad = [math]::Max(0, [math]::Floor(($Host.UI.RawUI.WindowSize.Width - $line.Length) / 2))
            Write-Host (" " * $pad) -NoNewline
            Write-Host "║  " -NoNewline -ForegroundColor Cyan
            Write-Host "Successful: $Script:SuccessCount" -NoNewline -ForegroundColor Green
            Write-Host "  |  " -NoNewline
            Write-Host "Failed: $Script:ErrorCount" -NoNewline -ForegroundColor Red
            Write-Host "                              ║" -ForegroundColor Cyan
        }
        else {
            Write-Centered $line -ForegroundColor Cyan
        }
        Write-Host ""
    }
    
    Write-Host "`nLog saved to: $Script:LogPath" -ForegroundColor DarkGray
}

function Wait-KeyPress {
    Write-Host "`nPress any key to continue..." -ForegroundColor DarkGray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function Show-MainMenu {
    while ($true) {
        Show-Banner
         $menuLines = @(
            "╔══════════════════════════════════════════════════════════════════════════════════════════════╗",
            "║  [1] Automatic System Optimization                                                           ║",
            "║  [2] Manual System Optimization                                                              ║",
            "║  [3] Clean Unnecessary Files                                                                 ║",
            "║  [4] Windows Tweaks                                                                          ║",
            "║  [5] Tweak Apps                                                                              ║",
            "║  [7] Windows License Activation [BETA]                                                       ║",
            "║  [8] Get PC Performance Scores (WinSAT)                                                      ║",
            "║  [9] About                                                                                   ║",
            "║  [0] Exit                                                                                    ║",
            "╚══════════════════════════════════════════════════════════════════════════════════════════════╝"
        )

        foreach ($line in $menuLines) {
            Write-Centered $line -ForegroundColor White
        }
        Write-Host ""
        
        $choice = Read-Host "Enter selection"
        
       switch ($choice) {
            "1" { Invoke-AutomaticOptimization }
            "2" { Show-ManualOptimizationMenu }
            "3" { Invoke-FileCleanup }
            "4" { Show-TweaksMenu }
            "5" { Show-TweakAppsMenu }
            "7" { Show-LicenseMenu }
            "8" { Get-WinSATStats }
            "9" { Show-About }
            "0" { 
                Stop-Transcript -ErrorAction SilentlyContinue
                exit 
            }
            default { 
                Write-Host "Invalid selection. Please try again!" -ForegroundColor Red
                Start-Sleep -Seconds 2
            }
        }
    }
}

function Invoke-AutomaticOptimization {
    Show-Banner
    Write-Host "Starting Automatic System Optimization..." -ForegroundColor Yellow
    Write-Host "This process may take several minutes.`n" -ForegroundColor DarkGray
    
    $Script:Results = @()
    $Script:SuccessCount = 0
    $Script:ErrorCount = 0
    
    Show-Progress -Activity "System Optimization" -Status "Disk Cleanup" -Step 1 -TotalSteps 8
    Invoke-DiskCleanup -Silent
    
    Show-Progress -Activity "System Optimization" -Status "Disk Repair" -Step 2 -TotalSteps 8
    Invoke-DiskRepair -Silent
    
    Show-Progress -Activity "System Optimization" -Status "System File Repair" -Step 3 -TotalSteps 8
    Invoke-SystemFileRepair -Silent
    
    Show-Progress -Activity "System Optimization" -Status "Windows Update" -Step 4 -TotalSteps 8
    Invoke-WindowsUpdateCheck -Silent
    
    Show-Progress -Activity "System Optimization" -Status "Antivirus Scan" -Step 5 -TotalSteps 8
    Invoke-AntivirusScan -Silent
    
    Show-Progress -Activity "System Optimization" -Status "RAM Optimization" -Step 6 -TotalSteps 8
    Invoke-RAMOptimization -Silent
    
    Show-Progress -Activity "System Optimization" -Status "Temperature Check" -Step 7 -TotalSteps 8
    Get-SystemTemperature -Silent
    
    Show-Progress -Activity "System Optimization" -Status "Disk Health Check" -Step 8 -TotalSteps 8
    Get-DiskHealth -Silent
    
    Write-Progress -Activity "System Optimization" -Completed
    
    Show-Summary
    Wait-KeyPress
}

function Show-ManualOptimizationMenu {
    while ($true) {
        Show-Banner
        $manualMenuLines = @(
            "╔══════════════════════════════════════════════════════════════════════════════════════════════╗",
            "║                              MANUAL SYSTEM OPTIMIZATION                                      ║",
            "╠══════════════════════════════════════════════════════════════════════════════════════════════╣",
            "║  [1] Disk Cleanup                                                                            ║",
            "║  [2] Disk Repair                                                                             ║",
            "║  [3] System File Repair (SFC + DISM)                                                         ║",
            "║  [4] Windows Update Check                                                                    ║",
            "║  [5] Antivirus Scan                                                                          ║",
            "║  [6] RAM Optimization                                                                        ║",
            "║  [7] System Temperature Check                                                                ║",
            "║  [8] Disk Health Check                                                                       ║",
            "║  [9] Return to Main Menu                                                                     ║",
            "╚══════════════════════════════════════════════════════════════════════════════════════════════╝"
        )

        foreach ($line in $manualMenuLines) {
            Write-Centered $line -ForegroundColor White
        }
        Write-Host ""
        
        $choice = Read-Host "Enter selection"
        
        switch ($choice) {
            "1" { Invoke-DiskCleanup }
            "2" { Invoke-DiskRepair }
            "3" { Invoke-SystemFileRepair }
            "4" { Invoke-WindowsUpdateCheck }
            "5" { Invoke-AntivirusScan }
            "6" { Invoke-RAMOptimization }
            "7" { Get-SystemTemperature }
            "8" { Get-DiskHealth }
            "9" { return }
            default { 
                Write-Host "Invalid selection. Please try again!" -ForegroundColor Red
                Start-Sleep -Seconds 2
            }
        }
    }
}

function Invoke-DiskCleanup {
    param([switch]$Silent)
    
    $startTime = Get-Date
    if (-not $Silent) { Show-Banner; Write-Host "Starting Disk Cleanup..." -ForegroundColor Yellow }
    
    try {
        Write-Log -Level Info -Message "Starting Disk Cleanup"
        
        $regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches"
        try {
            $keys = @("Temporary Files", "Recycle Bin", "Previous Installations", "Temporary Setup Files", "Old Chkdsk Files")
            foreach ($key in $keys) {
                $path = "$regPath\$key"
                if (Test-Path $path) {
                    Set-ItemProperty -Path $path -Name "StateFlags0001" -Value 2 -Type DWord -ErrorAction SilentlyContinue
                }
            }
        }
        catch {}

        Start-Process cleanmgr -ArgumentList "/sagerun:1" -Wait -ErrorAction Stop
        
        $duration = (Get-Date) - $startTime
        Add-Result -Operation "Disk Cleanup" -Status "Success" -Duration $duration.ToString("mm\:ss")
        Write-Host "✓ Disk Cleanup completed successfully!" -ForegroundColor Green
        Write-Log -Level Success -Message "Disk Cleanup completed"
    }
    catch {
        Add-Result -Operation "Disk Cleanup" -Status "Failed"
        Write-Host "✗ Disk Cleanup failed: $($_.Exception.Message)" -ForegroundColor Red
        Write-Log -Level Error -Message "Disk Cleanup failed: $($_.Exception.Message)"
    }
    
    if (-not $Silent) { Wait-KeyPress }
}

function Invoke-DiskRepair {
    param([switch]$Silent)
    
    $startTime = Get-Date
    if (-not $Silent) { Show-Banner; Write-Host "Starting Disk Repair..." -ForegroundColor Yellow }
    
    try {
        Write-Log -Level Info -Message "Starting Disk Repair"
        
        $systemDrive = $env:SystemDrive.TrimEnd(':')
        
        try {
            Repair-Volume -DriveLetter $systemDrive -Scan -ErrorAction Stop
            Write-Host "  Volume scan completed" -ForegroundColor DarkGray
        }
        catch {
            Start-Process chkdsk -ArgumentList "/f" -Wait -NoNewWindow
        }
        
        $duration = (Get-Date) - $startTime
        Add-Result -Operation "Disk Repair" -Status "Success" -Duration $duration.ToString("mm\:ss")
        Write-Host "✓ Disk Repair completed successfully!" -ForegroundColor Green
        Write-Log -Level Success -Message "Disk Repair completed"
    }
    catch {
        Add-Result -Operation "Disk Repair" -Status "Failed"
        Write-Host "✗ Disk Repair failed: $($_.Exception.Message)" -ForegroundColor Red
        Write-Log -Level Error -Message "Disk Repair failed: $($_.Exception.Message)"
    }
    
    if (-not $Silent) { Wait-KeyPress }
}

function Invoke-SystemFileRepair {
    param([switch]$Silent)
    
    $startTime = Get-Date
    if (-not $Silent) { Show-Banner; Write-Host "Starting System File Repair (this may take a while)..." -ForegroundColor Yellow }
    
    try {
        Write-Log -Level Info -Message "Starting System File Repair"
        
        Write-Host "`nRunning System File Checker (SFC)..." -ForegroundColor Cyan
        Write-Spinner -Duration 2 -Color Cyan -Message "Starting SFC..."
        Start-Process sfc -ArgumentList "/scannow" -Wait -NoNewWindow
        Write-Host "✓ SFC scan completed!" -ForegroundColor Green
        
       Write-Host "`nRunning DISM (CheckHealth)..." -ForegroundColor Cyan
        Write-Spinner -Duration 2 -Color Cyan -Message "Initializing DISM..."
        Start-Process DISM -ArgumentList "/Online /Cleanup-Image /CheckHealth" -Wait -NoNewWindow
        
        Write-Host "Running DISM (ScanHealth)..." -ForegroundColor Cyan
        Write-Spinner -Duration 2 -Color Cyan -Message "Scanning for corruption..."
        Start-Process DISM -ArgumentList "/Online /Cleanup-Image /ScanHealth" -Wait -NoNewWindow
        
        Write-Host "Running DISM (RestoreHealth)..." -ForegroundColor Cyan
        Write-Spinner -Duration 2 -Color Cyan -Message "Repairing system files..."
        Start-Process DISM -ArgumentList "/Online /Cleanup-Image /RestoreHealth" -Wait -NoNewWindow
        
        Write-Host "✓ DISM repair operations completed!" -ForegroundColor Green
        Start-Process DISM -ArgumentList "/Online /Cleanup-Image /startcomponentcleanup" -Wait -NoNewWindow
        
        $duration = (Get-Date) - $startTime
        Add-Result -Operation "System File Repair" -Status "Success" -Duration $duration.ToString("mm\:ss")
        Write-Host "✓ System File Repair completed successfully!" -ForegroundColor Green
        Write-Log -Level Success -Message "System File Repair completed"
    }
    catch {
        Add-Result -Operation "System File Repair" -Status "Failed"
        Write-Host "✗ System File Repair failed: $($_.Exception.Message)" -ForegroundColor Red
        Write-Log -Level Error -Message "System File Repair failed: $($_.Exception.Message)"
    }
    
    if (-not $Silent) { Wait-KeyPress }
}

function Invoke-WindowsUpdateCheck {
    param([switch]$Silent)
    
    $startTime = Get-Date
    if (-not $Silent) { Show-Banner; Write-Host "Starting Windows Update Check..." -ForegroundColor Yellow }
    
    try {
        Write-Log -Level Info -Message "Starting Windows Update Check"
        
        $usoPath = "$env:SystemRoot\System32\UsoClient.exe"
        if (Test-Path $usoPath) {
            Start-Process UsoClient -ArgumentList "ScanInstallWait" -Wait -ErrorAction SilentlyContinue
            Write-Host "  Windows Update scan initiated (check Settings for progress)" -ForegroundColor DarkGray
        }
        else {
            (New-Object -ComObject Microsoft.Update.AutoUpdate).DetectNow()
            Write-Host "  Update detection initiated" -ForegroundColor DarkGray
        }
        
        $duration = (Get-Date) - $startTime
        Add-Result -Operation "Windows Update Check" -Status "Success" -Duration $duration.ToString("mm\:ss")
        Write-Host "✓ Windows Update Check completed!" -ForegroundColor Green
        Write-Log -Level Success -Message "Windows Update Check completed"
    }
    catch {
        Add-Result -Operation "Windows Update Check" -Status "Failed"
        Write-Host "✗ Windows Update Check failed: $($_.Exception.Message)" -ForegroundColor Red
        Write-Log -Level Error -Message "Windows Update Check failed: $($_.Exception.Message)"
    }
    
    if (-not $Silent) { Wait-KeyPress }
}

function Invoke-AntivirusScan {
    param([switch]$Silent)
    
    $startTime = Get-Date
    if (-not $Silent) { Show-Banner; Write-Host "Starting Antivirus Scan..." -ForegroundColor Yellow }
    
    try {
        Write-Log -Level Info -Message "Starting Antivirus Scan"
        
        $defenderPath = "$env:ProgramFiles\Windows Defender\MpCmdRun.exe"
        if (Test-Path $defenderPath) {
            Start-Process $defenderPath -ArgumentList "-Scan -ScanType 1" -Wait -NoNewWindow
            Write-Host "  Quick scan completed" -ForegroundColor DarkGray
        }
        else {
            Start-MpScan -ScanType QuickScan -ErrorAction Stop
        }
        
        $duration = (Get-Date) - $startTime
        Add-Result -Operation "Antivirus Scan" -Status "Success" -Duration $duration.ToString("mm\:ss")
        Write-Host "✓ Antivirus Scan completed!" -ForegroundColor Green
        Write-Log -Level Success -Message "Antivirus Scan completed"
    }
    catch {
        Add-Result -Operation "Antivirus Scan" -Status "Failed"
        Write-Host "✗ Antivirus Scan failed: $($_.Exception.Message)" -ForegroundColor Red
        Write-Log -Level Error -Message "Antivirus Scan failed: $($_.Exception.Message)"
    }
    
    if (-not $Silent) { Wait-KeyPress }
}

function Invoke-RAMOptimization {
    param([switch]$Silent)
    
    $startTime = Get-Date
    if (-not $Silent) { Show-Banner; Write-Host "Starting RAM Optimization..." -ForegroundColor Yellow }
    
    try {
        Write-Log -Level Info -Message "Starting RAM Optimization"
        
        $os = Get-CimInstance Win32_OperatingSystem
        $freeMemGB = [math]::Round($os.FreePhysicalMemory / 1MB, 2)
        $totalMemGB = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2)
        $usedPercent = [math]::Round((1 - ($os.FreePhysicalMemory / $os.TotalVisibleMemorySize)) * 100, 1)
        
        Write-Host "  Current RAM Usage: $usedPercent% ($freeMemGB GB free of $totalMemGB GB)" -ForegroundColor DarkGray
        
        Write-Host "  Launching Windows Memory Diagnostic..." -ForegroundColor DarkGray
        Write-Host "  Note: System restart may be required for full diagnostic." -ForegroundColor Yellow
        Start-Process mdsched.exe -Wait
        
        $duration = (Get-Date) - $startTime
        Add-Result -Operation "RAM Optimization" -Status "Success" -Duration $duration.ToString("mm\:ss")
        Write-Host "✓ RAM Optimization initiated!" -ForegroundColor Green
        Write-Log -Level Success -Message "RAM Optimization completed"
    }
    catch {
        Add-Result -Operation "RAM Optimization" -Status "Failed"
        Write-Host "✗ RAM Optimization failed: $($_.Exception.Message)" -ForegroundColor Red
        Write-Log -Level Error -Message "RAM Optimization failed: $($_.Exception.Message)"
    }
    
    if (-not $Silent) { Wait-KeyPress }
}

function Get-SystemTemperature {
    param([switch]$Silent)
    
    if (-not $Silent) { Show-Banner; Write-Host "Checking System Temperature..." -ForegroundColor Yellow }
    
    try {
        Write-Log -Level Info -Message "Checking System Temperature"
        
        $temp = Get-CimInstance -Namespace "root/wmi" -ClassName MSAcpi_ThermalZoneTemperature -ErrorAction SilentlyContinue
        
        if ($temp) {
            foreach ($zone in $temp) {
                $celsius = [math]::Round(($zone.CurrentTemperature - 2732) / 10, 1)
                Write-Host "  Thermal Zone: $celsius°C" -ForegroundColor $(if ($celsius -gt 80) { "Red" } elseif ($celsius -gt 60) { "Yellow" } else { "Green" })
            }
            Add-Result -Operation "Temperature Check" -Status "Success"
        }
        else {
            Write-Host "  Temperature sensors not available on this system." -ForegroundColor Yellow
            Add-Result -Operation "Temperature Check" -Status "Success"
        }
        
        Write-Host "✓ Temperature Check completed!" -ForegroundColor Green
        Write-Log -Level Success -Message "Temperature Check completed"
    }
    catch {
        Add-Result -Operation "Temperature Check" -Status "Failed"
        Write-Host "✗ Temperature Check failed: $($_.Exception.Message)" -ForegroundColor Red
        Write-Log -Level Error -Message "Temperature Check failed: $($_.Exception.Message)"
    }
    
    if (-not $Silent) { Wait-KeyPress }
}

function Get-DiskHealth {
    param([switch]$Silent)
    
    if (-not $Silent) { Show-Banner; Write-Host "Checking Disk Health..." -ForegroundColor Yellow }
    
    try {
        Write-Log -Level Info -Message "Checking Disk Health"
        
        $disks = Get-PhysicalDisk
        
        foreach ($disk in $disks) {
            $healthColor = switch ($disk.HealthStatus) {
                "Healthy" { "Green" }
                "Warning" { "Yellow" }
                default { "Red" }
            }
            
            Write-Host "  $($disk.FriendlyName): $($disk.HealthStatus) ($($disk.MediaType), $([math]::Round($disk.Size / 1GB, 0)) GB)" -ForegroundColor $healthColor
            
            try {
                $reliability = $disk | Get-StorageReliabilityCounter -ErrorAction SilentlyContinue
                if ($reliability) {
                    if ($reliability.ReadErrorsTotal -gt 0) {
                        Write-Host "    ⚠ Read Errors: $($reliability.ReadErrorsTotal)" -ForegroundColor Yellow
                    }
                    if ($reliability.Temperature) {
                        Write-Host "    Temperature: $($reliability.Temperature)°C" -ForegroundColor DarkGray
                    }
                }
            }
            catch { }
        }
        
        Add-Result -Operation "Disk Health Check" -Status "Success"
        Write-Host "✓ Disk Health Check completed!" -ForegroundColor Green
        Write-Log -Level Success -Message "Disk Health Check completed"
    }
    catch {
        Add-Result -Operation "Disk Health Check" -Status "Failed"
        Write-Host "✗ Disk Health Check failed: $($_.Exception.Message)" -ForegroundColor Red
        Write-Log -Level Error -Message "Disk Health Check failed: $($_.Exception.Message)"
    }
    
    if (-not $Silent) { Wait-KeyPress }
}

function Invoke-FileCleanup {
    Show-Banner
    Write-Host "Analyzing files to clean..." -ForegroundColor Yellow
    
    # Consolidated cleanup paths
    $PathsToClean = @(
        "$env:TEMP",
        "$env:WINDIR\Temp",
        "$env:WINDIR\Prefetch",
        "$env:LOCALAPPDATA\Temp",
        "$env:LOCALAPPDATA\CrashDumps",
        "$env:WINDIR\SoftwareDistribution\Download",
        "$env:ProgramData\Microsoft\Windows\WER",
        "$env:WINDIR\Logs",
        "$env:ProgramData\Microsoft\Windows\DeliveryOptimization\Cache",
        "$env:SystemDrive\`$WINDOWS.~BT",
        "$env:SystemDrive\`$WINDOWS.~WS",
        "$env:SystemDrive\Windows.old",
        "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache",
        "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache",
        "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Default\Cache",
        "$env:LOCALAPPDATA\Microsoft\Windows\INetCache"
    )

    $DriverPaths = @(
        "$env:SystemDrive\AMD",
        "$env:SystemDrive\NVIDIA",
        "$env:SystemDrive\INTEL",
        "$env:ProgramData\NVIDIA Corporation\Downloader",
        "$env:LOCALAPPDATA\NVIDIA\DXCache",
        "$env:LOCALAPPDATA\NVIDIA\GLCache",
        "$env:LOCALAPPDATA\AMD\DxCache"
    )

    # Fast size estimation using direct enumeration
    $totalSize = 0
    $totalFiles = 0
    $validPaths = [System.Collections.ArrayList]@()
    
    foreach ($path in $PathsToClean) {
        if (Test-Path $path -ErrorAction SilentlyContinue) {
            try {
                $info = Get-ChildItem -Path $path -Recurse -Force -File -ErrorAction SilentlyContinue | 
                Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue
                $totalFiles += $info.Count
                $totalSize += $info.Sum
                [void]$validPaths.Add($path)
            }
            catch {}
        }
    }
    
    $driverFoldersToRemove = [System.Collections.ArrayList]@()
    foreach ($path in $DriverPaths) {
        if (Test-Path $path -ErrorAction SilentlyContinue) {
            try {
                $info = Get-ChildItem -Path $path -Recurse -Force -File -ErrorAction SilentlyContinue | 
                Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue
                $totalFiles += $info.Count
                $totalSize += $info.Sum
                [void]$driverFoldersToRemove.Add($path)
            }
            catch {}
        }
    }
    
    $sizeGB = [math]::Round($totalSize / 1GB, 2)
    $sizeMB = [math]::Round($totalSize / 1MB, 2)
    $displaySize = if ($sizeGB -ge 1) { "$sizeGB GB" } else { "$sizeMB MB" }
    
    Write-Host "`nFiles to clean: $totalFiles" -ForegroundColor Cyan
    Write-Host "Space to recover: $displaySize" -ForegroundColor Cyan
    
    if (Confirm-Action "`nProceed with cleanup?") {
        $frames = @('|', '/', '-', '\')
        $spinIdx = 0
        $deletedCount = 0
        
        Write-Host "Cleaning...  " -NoNewline -ForegroundColor Yellow
        
        # Direct deletion - no pre-storing
        foreach ($path in $validPaths) {
            Get-ChildItem -Path $path -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
                try {
                    Remove-Item -Path $_.FullName -Force -Recurse -ErrorAction SilentlyContinue
                    $deletedCount++
                    if ($deletedCount % 100 -eq 0) {
                        Write-Host "`b$($frames[$spinIdx % 4])" -NoNewline -ForegroundColor White
                        $spinIdx++
                    }
                }
                catch {}
            }
        }
        
        foreach ($path in $driverFoldersToRemove) {
            try {
                Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
                $deletedCount++
            }
            catch {}
        }
        
        # Recreate essential temp folders
        @("$env:TEMP", "$env:WINDIR\Temp", "$env:LOCALAPPDATA\Temp") | ForEach-Object {
            if (-not (Test-Path $_)) {
                New-Item -Path $_ -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
            }
        }
        
        Write-Host "`b " -NoNewline
        Write-Host ""
        Write-Host "✓ Cleaned $deletedCount items!" -ForegroundColor Green
        Write-Host "Reclaimed: $displaySize" -ForegroundColor Cyan
    }
    else {
        Write-Host "Cleanup cancelled." -ForegroundColor Yellow
    }

    # --- PHASE 2: Advanced Extension Scan ---
    Write-Host "`n----------------------------------------" -ForegroundColor DarkGray
    Write-Host "Press any key for Advanced Scan..." -ForegroundColor Cyan
    Wait-KeyPress
    Clear-Host
    Show-Banner
    
    if (Confirm-Action "Scan for unused files (.tmp, .log, .bak, etc)?") {
        $extensions = "*.tmp", "*.log", "*.bak", "*.old", "*.dmp", "*.chk", "*.etl"
        $scanPaths = @("$env:USERPROFILE", "$env:SystemDrive\Users\Public")
        $excludeDirs = @("$env:WINDIR", "$env:ProgramFiles", "${env:ProgramFiles(x86)}")
        
        $foundItems = [System.Collections.ArrayList]@()
        $foundSize = 0
        $frames = @('|', '/', '-', '\')
        $spinIdx = 0
        $scanCount = 0
        
        # Progress messages to keep user engaged
        $progressMsgs = @(
            "Initiating deep scan analysis...",
            "Analyzing file system structure...",
            "Searching for temporary artifacts...",
            "Checking user profile directories...",
            "Identifying log and backup files...",
            "Filtering system-protected paths...",
            "Calculating potential space savings...",
            "Indexing identified remnants...",
            "Processing scan results...",
            "Be patient, deep scans take time...",
            "Still scanning for leftovers...",
            "Nearly there...",
            "Performing final checkup..."
        )
        $msgIdx = 0
        $lastMsgTime = Get-Date
        
        # New spinner format: [|] Scanning...
        $origPos = $Host.UI.RawUI.CursorPosition
        Write-Host "[-] Scanning..." -NoNewline -ForegroundColor White
        
        foreach ($scanPath in $scanPaths) {
            if (Test-Path $scanPath) {
                Get-ChildItem -Path $scanPath -Include $extensions -Recurse -File -Force -ErrorAction SilentlyContinue | 
                Where-Object { 
                    $fullPath = $_.FullName
                    -not ($excludeDirs | Where-Object { $fullPath.StartsWith($_, [StringComparison]::OrdinalIgnoreCase) })
                } | ForEach-Object {
                    $scanCount++
                    $foundSize += $_.Length
                    [void]$foundItems.Add($_)
                    
                    if ($scanCount % 50 -eq 0) {
                        $char = $frames[$spinIdx % 4]
                        $spinIdx++
                        $Host.UI.RawUI.CursorPosition = $origPos
                        
                        # Update progress message every 3 seconds
                        if (((Get-Date) - $lastMsgTime).TotalSeconds -ge 3 -and $msgIdx -lt $progressMsgs.Count) {
                            $currentMsg = $progressMsgs[$msgIdx]
                            $msgIdx++
                            $lastMsgTime = Get-Date
                        }
                        else {
                            $currentMsg = if ($msgIdx -gt 0) { $progressMsgs[[math]::Min($msgIdx - 1, $progressMsgs.Count - 1)] } else { "Scanning..." }
                        }
                        
                        Write-Host "[$char] $currentMsg                    " -NoNewline -ForegroundColor White
                    }
                }
            }
        }
        
        $Host.UI.RawUI.CursorPosition = $origPos
        Write-Host "                                        " -NoNewline
        $Host.UI.RawUI.CursorPosition = $origPos
        Write-Host ""
        
        $foundCount = $foundItems.Count
        $foundSizeGB = [math]::Round($foundSize / 1GB, 2)
        $foundSizeMB = [math]::Round($foundSize / 1MB, 2)
        $displaySize = if ($foundSizeGB -ge 1) { "$foundSizeGB GB" } else { "$foundSizeMB MB" }
        
        if ($foundCount -gt 0) {
            Write-Host "`nFound $foundCount files ($displaySize)." -ForegroundColor Cyan
            
            # Max 10 file preview
            $limit = [math]::Min($foundCount, 10)
            Write-Host "Preview:" -ForegroundColor White
            for ($i = 0; $i -lt $limit; $i++) {
                Write-Host "  $($foundItems[$i].FullName)" -ForegroundColor DarkGray
            }
            if ($foundCount -gt 10) {
                Write-Host "  ...and $($foundCount - 10) more." -ForegroundColor DarkGray
            }
            
            # Size-based confirmation prompt
            if (Confirm-Action "`nClean up $displaySize Space?") {
                Write-Host "[|] Deleting..." -NoNewline -ForegroundColor Yellow
                $delPos = $Host.UI.RawUI.CursorPosition
                $deletedCount = 0
                $spinIdx = 0
                
                foreach ($item in $foundItems) {
                    try {
                        Remove-Item -Path $item.FullName -Force -ErrorAction SilentlyContinue
                        $deletedCount++
                        if ($deletedCount % 20 -eq 0) {
                            $Host.UI.RawUI.CursorPosition = $delPos
                            $Host.UI.RawUI.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($delPos.X - 14, $delPos.Y)
                            Write-Host "[$($frames[$spinIdx % 4])] Deleting..." -NoNewline -ForegroundColor Yellow
                            $spinIdx++
                        }
                    }
                    catch {}
                }
                
                Write-Host ""
                Write-Host "✓ Cleaned $deletedCount files ($displaySize)!" -ForegroundColor Green
            }
            else {
                Write-Host "Cancelled." -ForegroundColor Yellow
            }
        }
        else {
            Write-Host "No unused files found." -ForegroundColor Green
        }
    }
    
    Write-Host "`n✓ Cleanup complete!" -ForegroundColor Green
    Write-Log -Level Success -Message "File cleanup completed. Recovered approximately $displaySize"
    Wait-KeyPress
}


function New-SystemRestorePoint {
    Show-Banner
    Write-Host "Creating System Restore Point..." -ForegroundColor Yellow
    
    try {
        Enable-ComputerRestore -Drive "$env:SystemDrive\" -ErrorAction SilentlyContinue
        Checkpoint-Computer -Description "Enesehs Windows Optimizer - $(Get-Date -Format 'yyyy-MM-dd HH:mm')" -RestorePointType "MODIFY_SETTINGS" -ErrorAction Stop
        
        Write-Host "✓ System Restore Point created successfully!" -ForegroundColor Green
        Write-Log -Level Success -Message "System Restore Point created"
    }
    catch {
        if ($_.Exception.Message -match "1058") {
            Write-Host "✗ System Restore service is disabled." -ForegroundColor Red
            Write-Host "  Enabling service..." -ForegroundColor Yellow
            Set-Service -Name "VSS" -StartupType Manual -ErrorAction SilentlyContinue
            Start-Service -Name "VSS" -ErrorAction SilentlyContinue
            Write-Host "  Please try again." -ForegroundColor Yellow
        }
        else {
            Write-Host "✗ Failed: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    
    Wait-KeyPress
}

function Show-StartupManager {
    Show-Banner
    Write-Host "Startup Programs Manager" -ForegroundColor Yellow
    Write-Host ""
    
    try {
        $startupItems = Get-CimInstance Win32_StartupCommand | Select-Object Name, Command, Location, User
        
        if ($startupItems) {
            Write-Host "Current Startup Programs:" -ForegroundColor Cyan
            Write-Host ""
            $i = 1
            foreach ($item in $startupItems) {
                Write-Host "  [$i] $($item.Name)" -ForegroundColor White
                Write-Host "      Path: $($item.Command)" -ForegroundColor DarkGray
                Write-Host "      Location: $($item.Location)" -ForegroundColor DarkGray
                $i++
            }
            
            Write-Host ""
            Write-Host "To disable startup programs, use:" -ForegroundColor Yellow
            Write-Host "  Task Manager > Startup tab" -ForegroundColor DarkGray
            Write-Host "  or msconfig > Startup tab" -ForegroundColor DarkGray
            
            if (Confirm-Action "`nOpen Task Manager Startup tab?") {
                Start-Process taskmgr -ArgumentList "/0 /startup"
            }
        }
        else {
            Write-Host "  No startup programs found." -ForegroundColor DarkGray
        }
    }
    catch {
        Write-Host "✗ Failed: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Wait-KeyPress
}

function Disable-UnnecessaryServices {
    Show-Banner
    Write-Host "Disabling Unnecessary Services..." -ForegroundColor Yellow
    Write-Host ""
    
    $servicesToDisable = @(
        @{Name = "Fax"; DisplayName = "Fax Service" },
        @{Name = "XblAuthManager"; DisplayName = "Xbox Live Auth Manager" },
        @{Name = "XblGameSave"; DisplayName = "Xbox Live Game Save" },
        @{Name = "XboxGipSvc"; DisplayName = "Xbox Accessory Management" },
        @{Name = "XboxNetApiSvc"; DisplayName = "Xbox Live Networking" },
        @{Name = "RemoteRegistry"; DisplayName = "Remote Registry" },
        @{Name = "WMPNetworkSvc"; DisplayName = "Windows Media Player Network Sharing" },
        @{Name = "diagnosticshub.standardcollector.service"; DisplayName = "Diagnostics Hub" }
    )
    
    if (-not (Confirm-Action "This will disable unnecessary Windows services. Continue?")) {
        Write-Host "Operation cancelled." -ForegroundColor Yellow
        Wait-KeyPress
        return
    }
    
    $disabled = 0
    foreach ($svc in $servicesToDisable) {
        try {
            $service = Get-Service -Name $svc.Name -ErrorAction SilentlyContinue
            if ($service) {
                Stop-Service -Name $svc.Name -Force -ErrorAction SilentlyContinue
                Set-Service -Name $svc.Name -StartupType Disabled -ErrorAction SilentlyContinue
                Write-Host "  ✓ Disabled: $($svc.DisplayName)" -ForegroundColor Green
                $disabled++
            }
        }
        catch {
            Write-Host "  ⚠ Could not disable: $($svc.DisplayName)" -ForegroundColor Yellow
        }
    }
    
    Write-Host ""
    Write-Host "✓ Disabled $disabled services!" -ForegroundColor Green
    Write-Host "  Note: A restart may be required." -ForegroundColor Yellow
    
    Wait-KeyPress
}

function Optimize-VisualEffects {
    Show-Banner
    Write-Host "Optimizing Visual Effects for Performance..." -ForegroundColor Yellow
    
    try {
        $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
        if (-not (Test-Path $regPath)) {
            New-Item -Path $regPath -Force | Out-Null
        }
        Set-ItemProperty -Path $regPath -Name "VisualFXSetting" -Value 2 -Type DWord -Force
        
        $advancedPath = "HKCU:\Control Panel\Desktop"
        Set-ItemProperty -Path $advancedPath -Name "UserPreferencesMask" -Value ([byte[]](0x90, 0x12, 0x03, 0x80, 0x10, 0x00, 0x00, 0x00)) -Type Binary -Force
        Set-ItemProperty -Path $advancedPath -Name "DragFullWindows" -Value "0" -Force
        Set-ItemProperty -Path $advancedPath -Name "MenuShowDelay" -Value "0" -Force
        
        $windowMetrics = "HKCU:\Control Panel\Desktop\WindowMetrics"
        Set-ItemProperty -Path $windowMetrics -Name "MinAnimate" -Value "0" -Force
        
        Write-Host "✓ Visual effects optimized for performance!" -ForegroundColor Green
        Write-Host "  Disabled: Animations, fade effects, shadows" -ForegroundColor DarkGray
        Write-Host "  Note: Log off to apply all changes." -ForegroundColor Yellow
    }
    catch {
        Write-Host "✗ Failed: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Wait-KeyPress
}

function Enable-GamingMode {
    Show-Banner
    Write-Host "Enabling Gaming Optimizations..." -ForegroundColor Yellow
    Write-Host ""
    
    try {
        $regPath = "HKCU:\System\GameConfigStore"
        Set-ItemProperty -Path $regPath -Name "GameDVR_FSEBehaviorMode" -Value 2 -Type DWord -Force -ErrorAction SilentlyContinue
        Set-ItemProperty -Path $regPath -Name "GameDVR_DXGIHonorFSEWindowsCompatible" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
        Write-Host "  ✓ Fullscreen optimizations disabled" -ForegroundColor Green
        
        $mousePath = "HKCU:\Control Panel\Mouse"
        Set-ItemProperty -Path $mousePath -Name "MouseSpeed" -Value "0" -Force
        Set-ItemProperty -Path $mousePath -Name "MouseThreshold1" -Value "0" -Force
        Set-ItemProperty -Path $mousePath -Name "MouseThreshold2" -Value "0" -Force
        Write-Host "  ✓ Mouse acceleration disabled" -ForegroundColor Green
        
        $gameModePath = "HKCU:\Software\Microsoft\GameBar"
        if (-not (Test-Path $gameModePath)) {
            New-Item -Path $gameModePath -Force | Out-Null
        }
        Set-ItemProperty -Path $gameModePath -Name "AllowAutoGameMode" -Value 1 -Type DWord -Force
        Set-ItemProperty -Path $gameModePath -Name "AutoGameModeEnabled" -Value 1 -Type DWord -Force
        Write-Host "  ✓ Windows Game Mode enabled" -ForegroundColor Green
        
        $tcpPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
        Set-ItemProperty -Path $tcpPath -Name "NetworkThrottlingIndex" -Value 0xffffffff -Type DWord -Force -ErrorAction SilentlyContinue
        Set-ItemProperty -Path $tcpPath -Name "SystemResponsiveness" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
        
        $gamesPath = "$tcpPath\Tasks\Games"
        if (-not (Test-Path $gamesPath)) {
            New-Item -Path $gamesPath -Force | Out-Null
        }
        Set-ItemProperty -Path $gamesPath -Name "GPU Priority" -Value 8 -Type DWord -Force
        Set-ItemProperty -Path $gamesPath -Name "Priority" -Value 6 -Type DWord -Force
        Set-ItemProperty -Path $gamesPath -Name "Scheduling Category" -Value "High" -Force
        Write-Host "  ✓ Network throttling disabled (lower ping)" -ForegroundColor Green
        
        Write-Host ""
        Write-Host "✓ Gaming optimizations applied!" -ForegroundColor Green
        Write-Host "  Note: A restart is recommended." -ForegroundColor Yellow
    }
    catch {
        Write-Host "✗ Failed: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Wait-KeyPress
}

function Disable-PrivacyFeatures {
    Show-Banner
    Write-Host "Disabling Privacy-Invasive Features..." -ForegroundColor Yellow
    Write-Host ""
    
    try {
        $activityPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
        if (-not (Test-Path $activityPath)) {
            New-Item -Path $activityPath -Force | Out-Null
        }
        Set-ItemProperty -Path $activityPath -Name "EnableActivityFeed" -Value 0 -Type DWord -Force
        Set-ItemProperty -Path $activityPath -Name "PublishUserActivities" -Value 0 -Type DWord -Force
        Set-ItemProperty -Path $activityPath -Name "UploadUserActivities" -Value 0 -Type DWord -Force
        Write-Host "  ✓ Activity History disabled" -ForegroundColor Green
        
        $adPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo"
        if (-not (Test-Path $adPath)) {
            New-Item -Path $adPath -Force | Out-Null
        }
        Set-ItemProperty -Path $adPath -Name "Enabled" -Value 0 -Type DWord -Force
        Write-Host "  ✓ Advertising ID disabled" -ForegroundColor Green
        
        $locationPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors"
        if (-not (Test-Path $locationPath)) {
            New-Item -Path $locationPath -Force | Out-Null
        }
        Set-ItemProperty -Path $locationPath -Name "DisableLocation" -Value 1 -Type DWord -Force
        Write-Host "  ✓ Location tracking disabled" -ForegroundColor Green
        
        $tailoredPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy"
        if (-not (Test-Path $tailoredPath)) {
            New-Item -Path $tailoredPath -Force | Out-Null
        }
        Set-ItemProperty -Path $tailoredPath -Name "TailoredExperiencesWithDiagnosticDataEnabled" -Value 0 -Type DWord -Force
        Write-Host "  ✓ Tailored experiences disabled" -ForegroundColor Green
        
        $inputPath = "HKCU:\SOFTWARE\Microsoft\Input\TIPC"
        if (-not (Test-Path $inputPath)) {
            New-Item -Path $inputPath -Force | Out-Null
        }
        Set-ItemProperty -Path $inputPath -Name "Enabled" -Value 0 -Type DWord -Force
        Write-Host "  ✓ Typing data collection disabled" -ForegroundColor Green
        
        Write-Host ""
        Write-Host "✓ Privacy features disabled!" -ForegroundColor Green
    }
    catch {
        Write-Host "✗ Failed: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Wait-KeyPress
}

function Remove-Bloatware {
    Show-Banner
    Write-Host "Bloatware Removal" -ForegroundColor Yellow
    Write-Host ""
    
    $bloatwareApps = @(
        @{Name = "Microsoft.3DBuilder"; DisplayName = "3D Builder" },
        @{Name = "Microsoft.BingNews"; DisplayName = "Bing News" },
        @{Name = "Microsoft.BingWeather"; DisplayName = "Bing Weather" },
        @{Name = "Microsoft.GetHelp"; DisplayName = "Get Help" },
        @{Name = "Microsoft.Getstarted"; DisplayName = "Tips" },
        @{Name = "Microsoft.MicrosoftSolitaireCollection"; DisplayName = "Solitaire Collection" },
        @{Name = "Microsoft.People"; DisplayName = "People" },
        @{Name = "Microsoft.SkypeApp"; DisplayName = "Skype" },
        @{Name = "Microsoft.WindowsFeedbackHub"; DisplayName = "Feedback Hub" },
        @{Name = "Microsoft.Xbox.TCUI"; DisplayName = "Xbox TCUI" },
        @{Name = "Microsoft.XboxApp"; DisplayName = "Xbox App" },
        @{Name = "Microsoft.XboxGameOverlay"; DisplayName = "Xbox Game Overlay" },
        @{Name = "Microsoft.XboxSpeechToTextOverlay"; DisplayName = "Xbox Speech" },
        @{Name = "Microsoft.ZuneMusic"; DisplayName = "Groove Music" },
        @{Name = "Microsoft.ZuneVideo"; DisplayName = "Movies & TV" },
        @{Name = "king.com.CandyCrushSaga"; DisplayName = "Candy Crush Saga" },
        @{Name = "king.com.CandyCrushSodaSaga"; DisplayName = "Candy Crush Soda" },
        @{Name = "Clipchamp.Clipchamp"; DisplayName = "Clipchamp" }
    )
    
    Write-Host "The following apps will be removed:" -ForegroundColor Cyan
    foreach ($app in $bloatwareApps) {
        $installed = Get-AppxPackage -Name $app.Name -AllUsers -ErrorAction SilentlyContinue
        if ($installed) {
            Write-Host "  • $($app.DisplayName)" -ForegroundColor White
        }
    }
    
    Write-Host ""
    if (-not (Confirm-Action "Remove these apps?")) {
        Write-Host "Operation cancelled." -ForegroundColor Yellow
        Wait-KeyPress
        return
    }
    
    Write-Host ""
    Write-Spinner -Duration 2 -Color Cyan -Message "Removing selected apps..."
    $removed = 0
    foreach ($app in $bloatwareApps) {
        try {
            $package = Get-AppxPackage -Name $app.Name -AllUsers -ErrorAction SilentlyContinue
            if ($package) {
                $package | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
                Get-AppxProvisionedPackage -Online | Where-Object { $_.PackageName -like "*$($app.Name)*" } | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
                Write-Host "  ✓ Removed: $($app.DisplayName)" -ForegroundColor Green
                $removed++
            }
        }
        catch {
            Write-Host "  ⚠ Could not remove: $($app.DisplayName)" -ForegroundColor Yellow
        }
    }
    
    Write-Host ""
    Write-Host "✓ Removed $removed bloatware apps!" -ForegroundColor Green
    
    Wait-KeyPress
}

function Optimize-Network {
    Show-Banner
    Write-Host "Optimizing Network Settings..." -ForegroundColor Yellow
    Write-Host ""
    
    try {
        $throttlePath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
        Set-ItemProperty -Path $throttlePath -Name "NetworkThrottlingIndex" -Value 0xffffffff -Type DWord -Force
        Write-Host "  ✓ Network throttling disabled" -ForegroundColor Green
        
        Get-NetAdapter | Where-Object { $_.Status -eq "Up" } | ForEach-Object {
            $guid = (Get-NetAdapterAdvancedProperty -Name $_.Name -ErrorAction SilentlyContinue | Select-Object -First 1).InstanceID
            if ($guid) {
                $tcpPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\$guid"
                if (Test-Path $tcpPath) {
                    Set-ItemProperty -Path $tcpPath -Name "TcpAckFrequency" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
                    Set-ItemProperty -Path $tcpPath -Name "TCPNoDelay" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
                }
            }
        }
        Write-Host "  ✓ TCP optimizations applied (lower latency)" -ForegroundColor Green
        
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" -Name "MaxCacheTtl" -Value 86400 -Type DWord -Force -ErrorAction SilentlyContinue
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" -Name "MaxNegativeCacheTtl" -Value 5 -Type DWord -Force -ErrorAction SilentlyContinue
        Write-Host "  ✓ DNS cache optimized" -ForegroundColor Green
        
        Get-NetAdapter | Where-Object { $_.Status -eq "Up" } | ForEach-Object {
            Disable-NetAdapterLso -Name $_.Name -ErrorAction SilentlyContinue
        }
        Write-Host "  ✓ Large Send Offload disabled" -ForegroundColor Green
        
        Write-Host ""
        Write-Host "✓ Network optimization completed!" -ForegroundColor Green
        Write-Host "  Note: A restart is recommended." -ForegroundColor Yellow
    }
    catch {
        Write-Host "✗ Failed: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Wait-KeyPress
}

function Optimize-VirtualMemory {
    Show-Banner
    Write-Host "Optimizing Virtual Memory (Pagefile)..." -ForegroundColor Yellow
    Write-Host ""
    
    try {
        $os = Get-CimInstance Win32_OperatingSystem
        $totalRAM = [math]::Round($os.TotalVisibleMemorySize / 1MB, 0)
        
        Write-Host "  Total RAM: $totalRAM GB" -ForegroundColor Cyan
        
        $recommendedMin = if ($totalRAM -lt 8) { $totalRAM * 1536 } else { $totalRAM * 1024 }
        $recommendedMax = if ($totalRAM -lt 8) { $totalRAM * 3072 } else { $totalRAM * 2048 }
        
        Write-Host "  Recommended Pagefile: $([math]::Round($recommendedMin/1024, 0)) MB - $([math]::Round($recommendedMax/1024, 0)) MB" -ForegroundColor Cyan
        Write-Host ""
        
        if (Confirm-Action "Apply recommended pagefile settings?") {
            $cs = Get-CimInstance Win32_ComputerSystem
            $cs | Set-CimInstance -Property @{AutomaticManagedPagefile = $false }
            
            $pagefile = Get-CimInstance Win32_PageFileSetting -ErrorAction SilentlyContinue
            if ($pagefile) {
                $pagefile | Remove-CimInstance -ErrorAction SilentlyContinue
            }
            
            New-CimInstance -ClassName Win32_PageFileSetting -Property @{
                Name        = "$env:SystemDrive\pagefile.sys"
                InitialSize = [math]::Round($recommendedMin / 1024, 0)
                MaximumSize = [math]::Round($recommendedMax / 1024, 0)
            } -ErrorAction SilentlyContinue
            
            Write-Host "✓ Virtual memory optimized!" -ForegroundColor Green
            Write-Host "  Note: A restart is required to apply changes." -ForegroundColor Yellow
        }
        else {
            Write-Host "Operation cancelled." -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "✗ Failed: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "  Try manually: System Properties > Advanced > Performance > Virtual Memory" -ForegroundColor DarkGray
    }
    
    Wait-KeyPress
}

function Invoke-DiskOptimize {
    Show-Banner
    Write-Host "Disk Optimization" -ForegroundColor Yellow
    Write-Host ""
    
    try {
        $volumes = Get-Volume | Where-Object { $_.DriveLetter -and $_.DriveType -eq "Fixed" }
        
        foreach ($vol in $volumes) {
            $diskNumber = (Get-Partition -DriveLetter $vol.DriveLetter -ErrorAction SilentlyContinue).DiskNumber
            $disk = Get-PhysicalDisk | Where-Object { $_.DeviceId -eq $diskNumber }
            $mediaType = if ($disk) { $disk.MediaType } else { "Unknown" }
            
            Write-Host "  Drive $($vol.DriveLetter): - $mediaType" -ForegroundColor Cyan
            
             if ($mediaType -eq "SSD") {
                Write-Host "    Running TRIM..." -ForegroundColor DarkGray
                Write-Spinner -Duration 2 -Color Cyan -Message "Trimming SSD..."
                Optimize-Volume -DriveLetter $vol.DriveLetter -ReTrim -Verbose:$false
                Write-Host "    ✓ TRIM completed" -ForegroundColor Green
            }
            elseif ($mediaType -eq "HDD") {
                Write-Host "    Running Defragmentation..." -ForegroundColor DarkGray
                Write-Spinner -Duration 2 -Color Cyan -Message "Defragmenting HDD (this may take a while)..."
                Optimize-Volume -DriveLetter $vol.DriveLetter -Defrag -Verbose:$false
                Write-Host "    ✓ Defragmentation completed" -ForegroundColor Green
            }
            else {
                Write-Host "    Running optimization..." -ForegroundColor DarkGray
                Write-Spinner -Duration 2 -Color Cyan -Message "Optimizing..."
                Optimize-Volume -DriveLetter $vol.DriveLetter -Verbose:$false -ErrorAction SilentlyContinue
                Write-Host "    ✓ Optimization completed" -ForegroundColor Green
            }
        }
        
        Write-Host ""
        Write-Host "✓ Disk optimization completed!" -ForegroundColor Green
    }
    catch {
        Write-Host "✗ Failed: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Wait-KeyPress
}


function Install-AdobeBlocker {
    Show-Banner
    Write-Host "Installing Adobe Popup Blocker..." -ForegroundColor Yellow
    Write-Host "  This will block Adobe popup and license verification servers." -ForegroundColor DarkGray
    Write-Host ""
    
    $hostsPath = "$env:SystemRoot\System32\drivers\etc\hosts"
    $listUrl = "https://a.dove.isdumb.one/list.txt"
    $startMarker = "# >>> ENESEHS ADOBE BLOCKER START <<<"
    $endMarker = "# >>> ENESEHS ADOBE BLOCKER END <<<"
    
    try {
        Write-Host "  Downloading blocklist..." -ForegroundColor DarkGray
        $blockList = (Invoke-WebRequest -Uri $listUrl -UseBasicParsing -ErrorAction Stop).Content
        
        if ([string]::IsNullOrWhiteSpace($blockList)) {
            Write-Host "✗ Failed: Blocklist is empty." -ForegroundColor Red
            Wait-KeyPress
            return
        }

          # Read hosts file as lines to handle large files better than -Raw
        $hostsContent = Get-Content -Path $hostsPath -ErrorAction Stop
        
        # Check if already installed
        $isInstalled = $false
        foreach ($line in $hostsContent) {
            if ($line -eq $startMarker) {
                $isInstalled = $true
                break
            }
        }
        
        if ($isInstalled) {
            Write-Host "  Adobe Popup Blocker is already installed. Updating..." -ForegroundColor Yellow
            
            # Remove existing block
            $cleanContent = @()
            $skip = $false
            foreach ($line in $hostsContent) {
                if ($line -eq $startMarker) { $skip = $true }
                if (-not $skip) { $cleanContent += $line }
                if ($line -eq $endMarker) { $skip = $false }
            }
            $hostsContent = $cleanContent
        }
        
        $newBlock = @(
            "",
            $startMarker,
            "# Added by Enesehs Windows Optimizer - $(Get-Date -Format 'yyyy-MM-dd HH:mm')",
            "# Source: $listUrl"
        )
        $newBlock += $blockList -split "`n"
        $newBlock += $endMarker
        $newBlock += ""
        
        $backupPath = "$hostsPath.backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
        Copy-Item -Path $hostsPath -Destination $backupPath -Force
        Write-Host "  Backup created: $backupPath" -ForegroundColor DarkGray
        
        # Write new content
        $finalContent = $hostsContent + $newBlock
        $finalContent | Set-Content -Path $hostsPath -Force -Encoding UTF8
        
        Clear-DnsClientCache
        
        $lineCount = ($blockList -split "`n").Count
        Write-Host ""
        Write-Host "✓ Adobe Popup Blocker installed successfully!" -ForegroundColor Green
        Write-Host "  Blocked $lineCount domains." -ForegroundColor DarkGray
        Write-Log -Level Success -Message "Adobe Popup Blocker installed with $lineCount domains"
    }
    catch {
        Write-Host "✗ Failed: $($_.Exception.Message)" -ForegroundColor Red
        Write-Log -Level Error -Message "Adobe Popup Blocker installation failed: $($_.Exception.Message)"
    }
    
    Wait-KeyPress
}

function Remove-AdobeBlocker {
    Show-Banner
    Write-Host "Removing Adobe Popup Blocker..." -ForegroundColor Yellow
    
    $hostsPath = "$env:SystemRoot\System32\drivers\etc\hosts"
    $startMarker = "# >>> ENESEHS ADOBE BLOCKER START <<<"
    $endMarker = "# >>> ENESEHS ADOBE BLOCKER END <<<"
    
    try {
        $hostsContent = Get-Content -Path $hostsPath -Raw -ErrorAction Stop
        
        if ($hostsContent -notmatch [regex]::Escape($startMarker)) {
            Write-Host "  Adobe Popup Blocker is not installed." -ForegroundColor Yellow
            Wait-KeyPress
            return
        }
        
        $pattern = "(?s)\r?\n?$([regex]::Escape($startMarker)).*?$([regex]::Escape($endMarker))\r?\n?"
        $newContent = $hostsContent -replace $pattern, ""
        
        Set-Content -Path $hostsPath -Value $newContent.TrimEnd() -Force -Encoding UTF8
        
        Clear-DnsClientCache
        
        Write-Host "✓ Adobe Popup Blocker removed successfully!" -ForegroundColor Green
        Write-Log -Level Success -Message "Adobe Popup Blocker removed"
    }
    catch {
        Write-Host "✗ Failed: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Wait-KeyPress
}

function Show-TweaksMenu {
    while ($true) {
        Show-Banner
        $tweakMenuLines = @(
            "╔══════════════════════════════════════════════════════════════════════════════════════════════╗",
            "║                                  WINDOWS TWEAKS                                              ║",
            "╠══════════════════════════════════════════════════════════════════════════════════════════════╣",
            "║  [1] Create System Restore Point                                                             ║",
            "║  [2] Startup Programs Manager                                                                ║",
            "║  [3] Disable Unnecessary Services                                                            ║",
            "║  [4] Optimize Visual Effects                                                                 ║",
            "║  [5] Enable Gaming Mode                                                                      ║",
            "║  [6] Disable Privacy Features                                                                ║",
            "║  [7] Remove Bloatware                                                                        ║",
            "║  [8] Optimize Network                                                                        ║",
            "║  [9] Optimize Virtual Memory                                                                 ║",
            "║  [10] Disk Optimization (TRIM/Defrag)                                                        ║",
            "╠══════════════════════════════════════════════════════════════════════════════════════════════╣",
            "║  [11] Update All Applications (winget)                                                       ║",
            "║  [12] Fix Internet Issues                                                                    ║",
            "║  [13] Install Ad Blocker (AdGuard DNS)                                                       ║",
            "║  [14] Remove Ad Blocker / Clear DNS                                                          ║",
            "║  [15] Fix MSI Installer 2502/2503 Errors                                                     ║",
            "║  [16] Enable Ultimate Performance                                                            ║",
            "║  [17] Clear Event Logs                                                                       ║",
            "║  [18] Disable Telemetry                                                                      ║",
            "║  [19] Disable Cortana                                                                        ║",
            "║  [20] Disable Search Indexing                                                                ║",
            "║  [21] Classic Right-Click Menu (Win11)                                                       ║",
            "║  [22] Disable Game DVR / Game Bar                                                            ║",
            "╠══════════════════════════════════════════════════════════════════════════════════════════════╣",
            "║  [23] Install Adobe Popup Blocker (Hosts)                                                    ║",
            "║  [24] Remove Adobe Popup Blocker                                                             ║",
            "║  [25] Disable Bing/Edge Search in Start Menu                                                 ║",
            "║  [0] Return to Main Menu                                                                     ║",
            "╚══════════════════════════════════════════════════════════════════════════════════════════════╝"
        )
        
       foreach ($line in $tweakMenuLines) {
            Write-Centered $line -ForegroundColor White
        }
        Write-Host ""
        
        $choice = Read-Host "Enter selection"
        
        switch ($choice) {
            "1" { New-SystemRestorePoint }
            "2" { Show-StartupManager }
            "3" { Disable-UnnecessaryServices }
            "4" { Optimize-VisualEffects }
            "5" { Enable-GamingMode }
            "6" { Disable-PrivacyFeatures }
            "7" { Remove-Bloatware }
            "8" { Optimize-Network }
            "9" { Optimize-VirtualMemory }
            "10" { Invoke-DiskOptimize }
            "11" { Update-AllApplications }
            "12" { Repair-InternetConnection }
            "13" { Install-AdBlockerDNS }
            "14" { Clear-DNSSettings }
            "15" { Repair-MSIInstaller }
            "16" { Enable-UltimatePerformance }
            "17" { Clear-AllEventLogs }
            "18" { Disable-Telemetry }
            "19" { Disable-Cortana }
            "20" { Disable-SearchIndexing }
            "21" { Set-ClassicContextMenu }
            "22" { Disable-GameDVR }
            "23" { Install-AdobeBlocker }
            "24" { Remove-AdobeBlocker }
            "25" { Disable-BingSearch }
            "0" { return }
            default { 
                Write-Host "Invalid selection. Please try again!" -ForegroundColor Red
                Start-Sleep -Seconds 2
            }
        }
    }
}



function Install-TweakApp {
    param(
        [string]$AppName,
        [string]$WingetId,
        [string]$Description
    )
    
    Show-Banner
    Write-Host "Installing $AppName..." -ForegroundColor Yellow
    Write-Host "  $Description" -ForegroundColor DarkGray
    Write-Host ""
    
    try {
        $winget = Get-Command winget -ErrorAction SilentlyContinue
        if (-not $winget) {
            Write-Host "✗ winget is not installed." -ForegroundColor Red
            Wait-KeyPress
            return
        }

        Write-Spinner -Duration 2 -Color Cyan -Message "Installing $AppName..."
        Start-Process powershell -ArgumentList "-NoExit -Command `"winget install --id $WingetId --accept-package-agreements --accept-source-agreements`"" -Wait
        Write-Host "✓ $AppName installation completed!" -ForegroundColor Green
    }
    catch {
        Write-Host "✗ Failed: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Wait-KeyPress
}

function Show-TweakAppsMenu {
    while ($true) {
        Show-Banner
        $appMenuLines = @(
            "╔══════════════════════════════════════════════════════════════════════════════════════════════╗",
            "║                                  TWEAK APPS                                                  ║",
            "╠══════════════════════════════════════════════════════════════════════════════════════════════╣",
            "║  [1]  NanaZip              - Modern file archiver (7-Zip alternative)                        ║",
            "║  [2]  Nilesoft Shell       - Context menu customizer                                         ║",
            "║  [3]  EarTrumpet           - Advanced volume control                                         ║",
            "║  [4]  Everything           - Instant file search                                             ║",
            "║  [5]  ExplorerBlurMica     - Blur effect for Explorer                                        ║",
            "║  [6]  PowerToys            - Microsoft power user tools                                      ║",
            "║  [7]  QuickLook            - Spacebar file preview                                           ║",
            "║  [8]  UniGetUI             - Package manager GUI                                             ║",
            "║  [9]  Winutil              - Chris Titus Tech Windows tool                                   ║",
            "║  [10] Windhawk             - System customization tool                                       ║",
            "║  [11] Bulk Crap Uninstaller- Bulk app remover                                                ║",
            "║  [12] Revo Uninstaller     - Advanced uninstaller                                            ║",
            "║  [13] QBittorrent          - Torrent client                                                  ║",
            "║  [14] PlayNite             - Game library manager                                            ║",
            "║  [15] Syncthing            - File synchronization                                            ║",
            "║  [16] Bulk Rename Utility  - Batch file renaming                                             ║",
            "║  [17] AltSnap              - Window snapping tool                                            ║",
            "║  [18] Deskflow             - KVM software (Synergy fork)                                     ║",
            "║  [19] Chrome Remote Desktop- Remote desktop (Web)                                            ║",
            "║  [20] System Informer      - Advanced task manager                                           ║",
            "║  [21] LocalSend            - Local file sharing                                              ║",
            "║  [22] Flow Launcher        - App launcher (Spotlight-like)                                   ║",
            "║  [0]  Return to Main Menu                                                                    ║",
            "╚══════════════════════════════════════════════════════════════════════════════════════════════╝"
        )
        
        foreach ($line in $appMenuLines) {
            Write-Centered $line -ForegroundColor White
        }
        Write-Host ""
        
        $choice = Read-Host "Enter selection"
        
        switch ($choice) {
            "1" { Install-TweakApp -AppName "NanaZip" -WingetId "M2Team.NanaZip" -Description "Modern file archiver, enhanced version of 7-Zip" }
            "2" { Install-TweakApp -AppName "Nilesoft Shell" -WingetId "Nilesoft.Shell" -Description "Fully customize Windows right-click context menu" }
            "3" { Install-TweakApp -AppName "EarTrumpet" -WingetId "File-New-Project.EarTrumpet" -Description "Per-application volume control" }
            "4" { Install-TweakApp -AppName "Everything" -WingetId "voidtools.Everything" -Description "Find files instantly, much faster than Windows Search" }
            "5" { Install-TweakApp -AppName "ExplorerBlurMica" -WingetId "Maplespe.ExplorerBlurMica" -Description "Add blur and mica effect to File Explorer" }
            "6" { Install-TweakApp -AppName "PowerToys" -WingetId "Microsoft.PowerToys" -Description "Microsoft's official power user toolkit" }
            "7" { Install-TweakApp -AppName "QuickLook" -WingetId "QL-Win.QuickLook" -Description "macOS-style spacebar file preview" }
            "8" { Install-TweakApp -AppName "UniGetUI" -WingetId "MartiCliment.UniGetUI" -Description "GUI for Winget, Scoop, and Chocolatey" }
            "9" { 
                Show-Banner
                Write-Host "Installing Winutil (Chris Titus Tech)..." -ForegroundColor Yellow
                Write-Host "  Comprehensive Windows optimization tool" -ForegroundColor DarkGray
                try {
                    Start-Process powershell -ArgumentList "-NoExit -Command `"irm 'https://christitus.com/win' | iex`"" -Wait
                    Write-Host "✓ Winutil launched!" -ForegroundColor Green
                }
                catch {
                    Write-Host "✗ Failed: $($_.Exception.Message)" -ForegroundColor Red
                }
                Wait-KeyPress
            }
            "10" { Install-TweakApp -AppName "Windhawk" -WingetId "RamenSoftware.Windhawk" -Description "Deep Windows customization" }
            "11" { Install-TweakApp -AppName "Bulk Crap Uninstaller" -WingetId "Klocman.BulkCrapUninstaller" -Description "Remove multiple programs at once" }
            "12" { Install-TweakApp -AppName "Revo Uninstaller" -WingetId "RevoUninstaller.RevoUninstaller" -Description "Advanced uninstaller that cleans leftover files" }
            "13" { Install-TweakApp -AppName "QBittorrent" -WingetId "qBittorrent.qBittorrent" -Description "Open source, ad-free torrent client" }
            "14" { Install-TweakApp -AppName "PlayNite" -WingetId "Playnite.Playnite" -Description "Manage all your game libraries in one place" }
            "15" { Install-TweakApp -AppName "Syncthing" -WingetId "Syncthing.Syncthing" -Description "Secure file sync between devices" }
            "16" { Install-TweakApp -AppName "Bulk Rename Utility" -WingetId "TGRMN.BulkRenameUtility" -Description "Automatically rename hundreds of files" }
            "17" { Install-TweakApp -AppName "AltSnap" -WingetId "AltSnap.AltSnap" -Description "Move and resize windows with Alt key" }
            "18" { Install-TweakApp -AppName "Deskflow" -WingetId "deskflow.deskflow" -Description "Control multiple computers with one keyboard and mouse" }
            "19" { 
                Show-Banner
                Write-Host "Chrome Remote Desktop" -ForegroundColor Yellow
                Write-Host "  Google's free remote desktop solution" -ForegroundColor DarkGray
                Write-Host "`nOpening browser..." -ForegroundColor Cyan
                Start-Process "https://remotedesktop.google.com/access"
                Wait-KeyPress
            }
            "20" { Install-TweakApp -AppName "System Informer" -WingetId "SystemInformer.SystemInformer" -Description "Process Hacker successor, advanced task manager" }
            "21" { Install-TweakApp -AppName "LocalSend" -WingetId "LocalSend.LocalSend" -Description "AirDrop-like cross-platform file sharing" }
            "22" { Install-TweakApp -AppName "Flow Launcher" -WingetId "Flow-Launcher.Flow-Launcher" -Description "Quickly search apps, files, and the web" }
            "0" { return }
            default { 
                Write-Host "Invalid selection. Please try again!" -ForegroundColor Red
                Start-Sleep -Seconds 2
            }
        }
    }
}

function Update-AllApplications {
    Show-Banner
    Write-Host "Updating all applications via winget..." -ForegroundColor Yellow
    
    try {
        $winget = Get-Command winget -ErrorAction SilentlyContinue
        
        if ($winget) {
            Write-Spinner -Duration 2 -Color Cyan -Message "Updating all applications..."
            Start-Process powershell -ArgumentList "-NoExit -Command `"winget upgrade --all --accept-package-agreements --accept-source-agreements`"" -Wait
            Write-Host "✓ Application update process completed!" -ForegroundColor Green
        }
        else {
            Write-Host "✗ winget is not installed on this system." -ForegroundColor Red
            Write-Host "  Please install App Installer from Microsoft Store." -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "✗ Update failed: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Wait-KeyPress
}

function Repair-InternetConnection {
    Show-Banner
    Write-Host "Checking internet connection..." -ForegroundColor Yellow
    
    $connected = Test-NetConnection -ComputerName 8.8.8.8 -WarningAction SilentlyContinue
    
    if ($connected.PingSucceeded) {
        Write-Host "✓ Internet connection is active." -ForegroundColor Green
    }
    else {
        Write-Host "Internet connection lost. Initiating fix..." -ForegroundColor Yellow
        
        try {
            Write-Host "  Resetting Winsock..." -ForegroundColor DarkGray
            netsh winsock reset | Out-Null
            
            Write-Host "  Resetting IP stack..." -ForegroundColor DarkGray
            netsh int ip reset | Out-Null
            
            Write-Host "  Releasing IP..." -ForegroundColor DarkGray
            ipconfig /release | Out-Null
            
            Write-Host "  Renewing IP..." -ForegroundColor DarkGray
            ipconfig /renew | Out-Null
            
            Write-Host "  Flushing DNS..." -ForegroundColor DarkGray
            Clear-DnsClientCache
            
            Write-Host "✓ Network reset completed. A restart may be required." -ForegroundColor Green
        }
        catch {
            Write-Host "✗ Network repair failed: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    
    Wait-KeyPress
}

function Install-AdBlockerDNS {
    Show-Banner
    Write-Host "Installing AdGuard DNS (Ad Blocker)..." -ForegroundColor Yellow
    
    try {
        $adapters = Get-NetAdapter | Where-Object { $_.Status -eq "Up" }
        
        foreach ($adapter in $adapters) {
            Write-Host "  Setting DNS for: $($adapter.Name)" -ForegroundColor DarkGray
            Set-DnsClientServerAddress -InterfaceAlias $adapter.Name -ServerAddresses @("94.140.14.14", "94.140.15.15")
        }
        
        Write-Host "✓ AdGuard DNS installed successfully!" -ForegroundColor Green
        Write-Host "  Primary: 94.140.14.14" -ForegroundColor DarkGray
        Write-Host "  Secondary: 94.140.15.15" -ForegroundColor DarkGray
    }
    catch {
        Write-Host "✗ DNS installation failed: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Wait-KeyPress
}

function Clear-DNSSettings {
    Show-Banner
    Write-Host "Clearing DNS settings..." -ForegroundColor Yellow
    
    try {
        Clear-DnsClientCache
        Write-Host "  ✓ DNS cache cleared" -ForegroundColor Green
        
        $adapters = Get-NetAdapter | Where-Object { $_.Status -eq "Up" }
        
        foreach ($adapter in $adapters) {
            Write-Host "  Resetting DNS for: $($adapter.Name)" -ForegroundColor DarkGray
            Set-DnsClientServerAddress -InterfaceAlias $adapter.Name -ResetServerAddresses
        }
        
        Write-Host "✓ DNS settings cleared. Using DHCP for DNS." -ForegroundColor Green
    }
    catch {
        Write-Host "✗ DNS clearing failed: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Wait-KeyPress
}

function Repair-MSIInstaller {
    Show-Banner
    Write-Host "Fixing MSI Installer 2502/2503 Errors..." -ForegroundColor Yellow
    
    try {
        $paths = @("$env:SystemRoot\Temp", "$env:TEMP")
        
        foreach ($path in $paths) {
            Write-Host "  Setting permissions for: $path" -ForegroundColor DarkGray
            
            takeown /f $path /R /A /D Y 2>$null | Out-Null
            
            icacls $path /inheritance:r /grant:r "Users:(OI)(CI)F" /T 2>$null | Out-Null
            icacls $path /grant "Administrators:F" /T 2>$null | Out-Null
            icacls $path /grant "SYSTEM:F" /T 2>$null | Out-Null
        }
        
        Write-Host "✓ MSI Installer permissions fixed!" -ForegroundColor Green
    }
    catch {
        Write-Host "✗ MSI fix failed: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Wait-KeyPress
}

function Enable-UltimatePerformance {
    Show-Banner
    Write-Host "Enabling Ultimate Performance Power Plan..." -ForegroundColor Yellow
    
    try {
        $result = powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 2>&1
        if ($result -match "GUID") {
            Write-Host "✓ Ultimate Performance plan created!" -ForegroundColor Green
        }
        else {
            Write-Host "  Plan may already exist or is not available on this system." -ForegroundColor Yellow
        }
        
        Write-Host "`nAvailable Power Plans:" -ForegroundColor Cyan
        powercfg /list
    }
    catch {
        Write-Host "✗ Failed: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Wait-KeyPress
}

function Clear-AllEventLogs {
    Show-Banner
    Write-Host "Clearing all Windows Event Logs..." -ForegroundColor Yellow
    
    if (-not (Confirm-Action "This will delete all event logs. Continue?")) {
        Write-Host "Operation cancelled." -ForegroundColor Yellow
        Wait-KeyPress
        return
    }
    
    try {
        $logs = wevtutil el
        $total = ($logs | Measure-Object).Count
        $cleared = 0
        
        foreach ($log in $logs) {
            try {
                wevtutil cl "$log" 2>$null
                $cleared++
            }
            catch { }
        }
        
        Write-Host "✓ Cleared $cleared of $total event logs!" -ForegroundColor Green
    }
    catch {
        Write-Host "✗ Failed: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Wait-KeyPress
}

function Disable-Telemetry {
    Show-Banner
    Write-Host "Disabling Windows Telemetry..." -ForegroundColor Yellow
    
    try {
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
        
        Stop-Service -Name "DiagTrack" -Force -ErrorAction SilentlyContinue
        Set-Service -Name "DiagTrack" -StartupType Disabled -ErrorAction SilentlyContinue
        
        Stop-Service -Name "dmwappushservice" -Force -ErrorAction SilentlyContinue
        Set-Service -Name "dmwappushservice" -StartupType Disabled -ErrorAction SilentlyContinue
        
        Write-Host "✓ Telemetry disabled!" -ForegroundColor Green
        Write-Host "  Note: A restart may be required." -ForegroundColor Yellow
    }
    catch {
        Write-Host "✗ Failed: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Wait-KeyPress
}

function Disable-Cortana {
    Show-Banner
    Write-Host "Disabling Cortana..." -ForegroundColor Yellow
    
    try {
        $cortanaPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
        if (-not (Test-Path $cortanaPath)) {
            New-Item -Path $cortanaPath -Force | Out-Null
        }
        Set-ItemProperty -Path $cortanaPath -Name "AllowCortana" -Value 0 -Type DWord -Force
        
        Write-Host "✓ Cortana disabled!" -ForegroundColor Green
        Write-Host "  Note: A restart may be required." -ForegroundColor Yellow
    }
    catch {
        Write-Host "✗ Failed: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Wait-KeyPress
}

function Disable-SearchIndexing {
    Show-Banner
    Write-Host "Disabling Windows Search Indexing..." -ForegroundColor Yellow
    
    try {
        Stop-Service -Name "WSearch" -Force -ErrorAction SilentlyContinue
        Set-Service -Name "WSearch" -StartupType Disabled -ErrorAction SilentlyContinue
        
        Write-Host "✓ Windows Search Indexing disabled!" -ForegroundColor Green
        Write-Host "  Note: Search will be slower without indexing." -ForegroundColor Yellow
    }
    catch {
        Write-Host "✗ Failed: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Wait-KeyPress
}

function Set-ClassicContextMenu {
    Show-Banner
    Write-Host "Restoring Classic Right-Click Context Menu (Windows 11)..." -ForegroundColor Yellow
    
    try {
        $regPath = "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32"
        if (-not (Test-Path $regPath)) {
            New-Item -Path $regPath -Force | Out-Null
        }
        Set-ItemProperty -Path $regPath -Name "(Default)" -Value "" -Force
        
        Write-Host "✓ Classic context menu restored!" -ForegroundColor Green
        Write-Host "  Note: Restart Explorer or log off to apply." -ForegroundColor Yellow
        
        if (Confirm-Action "Restart Explorer now?") {
            Stop-Process -Name explorer -Force
            Start-Process explorer
            Write-Host "  Explorer restarted." -ForegroundColor Green
        }
    }
    catch {
        Write-Host "✗ Failed: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Wait-KeyPress
}

function Disable-BingSearch {
    Show-Banner
    Write-Host "Disabling Bing Search in Start Menu..." -ForegroundColor Yellow
    
    try {
        $regPath = "HKCU:\Software\Policies\Microsoft\Windows\Explorer"
        if (-not (Test-Path $regPath)) {
            New-Item -Path $regPath -Force | Out-Null
        }
        Set-ItemProperty -Path $regPath -Name "DisableSearchBoxSuggestions" -Value 1 -Type DWord -Force
        
        Write-Host "✓ Bing Search disabled!" -ForegroundColor Green
        Write-Host "  Note: Explorer restart required." -ForegroundColor Yellow
        
        if (Confirm-Action "Restart Explorer now?") {
            Stop-Process -Name explorer -Force
            Start-Process explorer
            Write-Host "  Explorer restarted." -ForegroundColor Green
        }
    }
    catch {
        Write-Host "✗ Failed: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Wait-KeyPress
}

function Disable-GameDVR {
    Show-Banner
    Write-Host "Disabling Xbox Game DVR / Game Bar..." -ForegroundColor Yellow
    
    try {
        $gameDvrPath = "HKCU:\System\GameConfigStore"
        Set-ItemProperty -Path $gameDvrPath -Name "GameDVR_Enabled" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
        
        $gameBarPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR"
        if (-not (Test-Path $gameBarPath)) {
            New-Item -Path $gameBarPath -Force | Out-Null
        }
        Set-ItemProperty -Path $gameBarPath -Name "AppCaptureEnabled" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
        
        $policyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR"
        if (-not (Test-Path $policyPath)) {
            New-Item -Path $policyPath -Force | Out-Null
        }
        Set-ItemProperty -Path $policyPath -Name "AllowGameDVR" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
        
        Write-Host "✓ Game DVR / Game Bar disabled!" -ForegroundColor Green
        Write-Host "  Note: A restart may be required." -ForegroundColor Yellow
    }
    catch {
        Write-Host "✗ Failed: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Wait-KeyPress
}

$Script:LicenseKeys = @(
    "2RKNC-9D8RD-RGRPM-4FD7W-6MV79",
    "VK7JG-NPHTM-C97JM-9MPGT-3V66T",
    "TX9XD-98N7V-6WMQ6-BX7FG-H8Q99",
    "W269N-WFGWX-YVC9B-4J6C9-T83GX",
    "MH37W-N47XK-V7XM9-C7227-GCQG9",
    "NW6C2-QMPVW-D7KKK-3GKT6-VCFB2",
    "NPPR9-FWDCX-D2C8J-H872K-2YT43",
    "TGQYN-FXGV9-QT3FM-RQ87G-QYGVD",
    "H86TT-WJF76-G2CRK-GQ73G-2RR8P",
    "TFWFK-72VX7-97TJC-Q8FPX-6VFF8"
)

function Show-LicenseMenu {
    while ($true) {
        Show-Banner
        $licenseMenuLines = @(
            "╔══════════════════════════════════════════════════════════════════════════════════════════════╗",
            "║                                  WINDOWS LICENSE ACTIVATION                                  ║",
            "╠══════════════════════════════════════════════════════════════════════════════════════════════╣",
            "║    The user is solely responsible for any liability arising from the use of this program.    ║",
            "╠══════════════════════════════════════════════════════════════════════════════════════════════╣",
            "║  [1] Activate Windows License (Generic Keys)                                                 ║",
            "║  [2] Activate Windows with KMS [Not Recommended]                                             ║",
            "║  [3] Show License Information                                                                ║",
            "║  [4] Backup and Restore License                                                              ║",
            "║  [5] Remove License                                                                          ║",
            "║  [6] Renew Activation Period                                                                 ║",
            "║  [7] Return to Main Menu                                                                     ║",
            "╚══════════════════════════════════════════════════════════════════════════════════════════════╝"
        )
        
        foreach ($line in $licenseMenuLines) {
            Write-Centered $line -ForegroundColor White
        }
        Write-Host ""
        
        $choice = Read-Host "Enter selection"
        
        switch ($choice) {
            "1" { Install-GenericLicense }
            "2" { Install-KMSLicense }
            "3" { Show-LicenseInfo }
            "4" { Backup-License }
            "5" { Remove-License }
            "6" { Reset-ActivationPeriod }
            "7" { return }
            default { 
                Write-Host "Invalid selection. Please try again!" -ForegroundColor Red
                Start-Sleep -Seconds 2
            }
        }
    }
}

function Install-GenericLicense {
    Show-Banner
    Write-Host "Activating Windows with generic keys..." -ForegroundColor Yellow
    
    try {
        $os = Get-CimInstance Win32_OperatingSystem
        $caption = $os.Caption
        Write-Host "  Detected Edition: $caption" -ForegroundColor Cyan
        
        $keyToUse = ""
        
        if ($caption -match "Pro") { $keyToUse = "VK7JG-NPHTM-C97JM-9MPGT-3V66T" }
        elseif ($caption -match "Home") { $keyToUse = "TX9XD-98N7V-6WMQ6-BX7FG-H8Q99" }
        elseif ($caption -match "Education") { $keyToUse = "NW6C2-QMPVW-D7KKK-3GKT6-VCFB2" }
        elseif ($caption -match "Enterprise") { $keyToUse = "MH37W-N47XK-V7XM9-C7227-GCQG9" }
        
        if ($keyToUse) {
            Write-Host "  Installing key for detected edition..." -ForegroundColor DarkGray
            $result = cscript //nologo "$env:SystemRoot\System32\slmgr.vbs" /ipk $keyToUse 2>&1
            if ($result -match "successfully") {
                Write-Host "✓ License key installed successfully!" -ForegroundColor Green
            }
            else {
                Write-Host "✗ Installation failed: $result" -ForegroundColor Red
            }
        }
        else {
            Write-Host "⚠ No matching generic key found for this edition." -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "✗ Error: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Wait-KeyPress
}

function Install-KMSLicense {
    Show-Banner
    
    if (-not (Confirm-Action "⚠ You are about to activate Windows with KMS. This is not recommended. Continue?")) {
        return
    }
    
    Write-Host "Activating Windows with KMS..." -ForegroundColor Yellow
    
    try {
        cscript //nologo "$env:SystemRoot\System32\slmgr.vbs" /ipk "W269N-WFGWX-YVC9B-4J6C9-T83GX" | Out-Null
        cscript //nologo "$env:SystemRoot\System32\slmgr.vbs" /skms "kms8.msguides.com" | Out-Null
        cscript //nologo "$env:SystemRoot\System32\slmgr.vbs" /ato | Out-Null
        
        Write-Host "✓ KMS Activation completed!" -ForegroundColor Green
    }
    catch {
        Write-Host "✗ KMS Activation failed: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Wait-KeyPress
}

function Show-LicenseInfo {
    Show-Banner
    $header = "License Information:"
    $pad = [math]::Max(0, [math]::Floor(($Host.UI.RawUI.WindowSize.Width - $header.Length) / 2))
    Write-Host (" " * $pad) -NoNewline
    Write-Host $header -ForegroundColor Yellow
    Write-Host ""
    
    cscript //nologo "$env:SystemRoot\System32\slmgr.vbs" /dlv
    
    Wait-KeyPress
}

function Backup-License {
    Show-Banner
    Write-Host "Backing up license information..." -ForegroundColor Yellow
    
    try {
        cscript //nologo "$env:SystemRoot\System32\slmgr.vbs" /rilc
        Write-Host "✓ License backup completed!" -ForegroundColor Green
    }
    catch {
        Write-Host "✗ Backup failed: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Wait-KeyPress
}

function Remove-License {
    Show-Banner
    
    if (-not (Confirm-Action "⚠ You are about to REMOVE the Windows license. Continue?")) {
        return
    }
    
    Write-Host "Removing Windows license..." -ForegroundColor Yellow
    
    try {
        cscript //nologo "$env:SystemRoot\System32\slmgr.vbs" /cpky | Out-Null
        cscript //nologo "$env:SystemRoot\System32\slmgr.vbs" /upk | Out-Null
        
        Write-Host "✓ License removed successfully!" -ForegroundColor Green
    }
    catch {
        Write-Host "✗ License removal failed: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Wait-KeyPress
}

function Reset-ActivationPeriod {
    Show-Banner
    Write-Host "Renewing activation period..." -ForegroundColor Yellow
    
    try {
        cscript //nologo "$env:SystemRoot\System32\slmgr.vbs" /rearm
        Write-Host "✓ Activation period renewed!" -ForegroundColor Green
        Write-Host "  Note: A system restart is required." -ForegroundColor Yellow
    }
    catch {
        Write-Host "✗ Renewal failed: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Wait-KeyPress
}

function Get-WinSATStats {
    Show-Banner
    Write-Host "Checking System Performance Scores (WinSAT)..." -ForegroundColor Yellow
    Write-Host "  Note: These scores are cached. Run 'winsat formal' as admin to update." -ForegroundColor DarkGray
    Write-Host ""
    
    try {
        $winsat = Get-CimInstance Win32_WinSAT -ErrorAction SilentlyContinue
        
        if ($winsat) {
            Write-Host "  Processor Score:      $($winsat.CPUScore)" -ForegroundColor White
            Write-Host "  Memory Score:         $($winsat.MemoryScore)" -ForegroundColor White
            Write-Host "  Graphics Score:       $($winsat.GraphicsScore)" -ForegroundColor White
            Write-Host "  D3D Score:            $($winsat.D3DScore)" -ForegroundColor White
            Write-Host "  Disk Score:           $($winsat.DiskScore)" -ForegroundColor White
            Write-Host "  -----------------------------" -ForegroundColor DarkGray
            Write-Host "  Overall Base Score:   $($winsat.WinSPRLevel)" -ForegroundColor Cyan
        }
        else {
            Write-Host "⚠ WinSAT information not available." -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "✗ Failed to retrieve WinSAT data: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Wait-KeyPress
}

function Show-About {
    Show-Banner
    
    $about = @"
╔══════════════════════════════════════════════════════════════════════════════════════════════╗
║                              ABOUT ENESEHS'S WINDOWS OPTIMIZER                               ║
╠══════════════════════════════════════════════════════════════════════════════════════════════╣
║                                                                                              ║
║  Enesehs's Windows Optimizer is an open-source software developed to optimize Windows        ║
║  operating systems and improve their performance.                                            ║
║                                                                                              ║
║  Features:                                                                                   ║
║    • Clean unnecessary files to free up disk space                                           ║
║    • Repair system files and disk errors                                                     ║
║    • Access hidden Windows features                                                          ║
║    • Manage Windows activation                                                               ║
║    • Monitor system health                                                                   ║
║                                                                                              ║
╠══════════════════════════════════════════════════════════════════════════════════════════════╣
║  License: GPL-3.0                                                                            ║
║  Copyright (C) 2026 Enesehs                                                                  ║
║  Contact: enesehs@protonmail.com                                                             ║
║  GitHub: https://github.com/enesehs                                                          ║
║  Website: https://enesehs.dev                                                                ║
╚══════════════════════════════════════════════════════════════════════════════════════════════╝
"@
    
    $lines = $about -split "`n"
    foreach ($line in $lines) {
        Write-Centered $line -ForegroundColor White
    }
    Wait-KeyPress
}

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Restarting as Administrator..." -ForegroundColor Yellow
    
    # Check if running via irm | iex (no script file path)
    if ([string]::IsNullOrEmpty($PSCommandPath)) {
        # Running via irm | iex - download and run with admin
        $scriptUrl = "https://raw.githubusercontent.com/enesehs/enesehs-windows-optimizer/main/releases/Enesehs-Windows-Optimizer-v1.1.ps1"
        Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"irm '$scriptUrl' | iex`"" -Verb RunAs
    }
    else {
        # Running from file
        $currentPs = (Get-Process -Id $PID).Path
        Start-Process $currentPs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    }
    exit
}

Show-SplashScreen
Show-MainMenu