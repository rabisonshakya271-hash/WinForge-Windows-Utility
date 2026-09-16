#Requires -Version 5.1
<#
.SYNOPSIS
    Ascend - Windows Optimization Suite
.DESCRIPTION
    Sidebar-navigation WPF app with four sections:
      1) Software      - install common apps via winget
      2) Optimize      - debloat apps, telemetry, services, performance tweaks
      3) System Repair - SFC, DISM, Windows Update reset, network reset, disk check
      4) Customize      - Windows 10/11 UI/UX tweaks
    Every action is opt-in. A System Restore point can be created before applying
    the Optimize section's changes.
.NOTES
    Run as Administrator. Supports Windows 10 and Windows 11 (auto-detected).
#>

$AppName    = "WinForge"
$AppTagline = "Windows Optimization Suite"
$AppTitle   = "$AppName — $AppTagline"

# Base64-encoded .ico (embedded so the app is a single self-contained file)
$IconBase64 = "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"

# ---------------------------------------------------------------------------
# 0. Self-elevate to Administrator AND force STA (required by WPF)
# ---------------------------------------------------------------------------
$IsAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
$IsSTA = [System.Threading.Thread]::CurrentThread.GetApartmentState() -eq 'STA'

if (-not $IsAdmin -or -not $IsSTA) {
    # Always relaunch through Windows PowerShell (powershell.exe) in STA mode,
    # even if this script was started via PowerShell 7 (pwsh.exe), which
    # defaults to MTA and will crash any WPF window.
    Start-Process powershell.exe "-NoProfile -STA -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

# ---------------------------------------------------------------------------
# 1. OS detection
# ---------------------------------------------------------------------------
$OSInfo = Get-CimInstance -ClassName Win32_OperatingSystem
$OSCaption = $OSInfo.Caption
$OSBuild = [int]$OSInfo.BuildNumber
$IsWin11 = $OSBuild -ge 22000
$OSLabel = if ($IsWin11) { "Windows 11 (build $OSBuild)" } else { "Windows 10 (build $OSBuild)" }

# ---------------------------------------------------------------------------
# 2. Data tables
# ---------------------------------------------------------------------------

$BloatApps = @(
    "Microsoft.3DBuilder","Microsoft.BingNews","Microsoft.BingWeather","Microsoft.BingFinance",
    "Microsoft.BingSports","Microsoft.GetHelp","Microsoft.Getstarted","Microsoft.Messaging",
    "Microsoft.Microsoft3DViewer","Microsoft.MicrosoftOfficeHub","Microsoft.MicrosoftSolitaireCollection",
    "Microsoft.MixedReality.Portal","Microsoft.NetworkSpeedTest","Microsoft.News",
    "Microsoft.Office.OneNote","Microsoft.People","Microsoft.Print3D","Microsoft.SkypeApp",
    "Microsoft.Wallet","Microsoft.WindowsAlarms","Microsoft.WindowsCamera","microsoft.windowscommunicationsapps",
    "Microsoft.WindowsFeedbackHub","Microsoft.WindowsMaps","Microsoft.WindowsSoundRecorder",
    "Microsoft.Xbox.TCUI","Microsoft.XboxApp","Microsoft.XboxGameOverlay","Microsoft.XboxGamingOverlay",
    "Microsoft.XboxIdentityProvider","Microsoft.XboxSpeechToTextOverlay","Microsoft.ZuneMusic",
    "Microsoft.ZuneVideo","Microsoft.YourPhone","Microsoft.PowerAutomateDesktop",
    "Microsoft.Todos","Microsoft.GamingApp","MicrosoftTeams","Clipchamp.Clipchamp",
    "Microsoft.549981C3F5F10" # Cortana
)

$ServicesToDisable = @(
    @{Name="DiagTrack";        Label="Connected User Experiences & Telemetry"},
    @{Name="dmwappushservice"; Label="WAP Push Message Routing (telemetry)"},
    @{Name="MapsBroker";       Label="Downloaded Maps Manager"},
    @{Name="RetailDemo";       Label="Retail Demo Service"},
    @{Name="WSearch";          Label="Windows Search Indexing"},
    @{Name="XblAuthManager";   Label="Xbox Live Auth Manager"},
    @{Name="XblGameSave";      Label="Xbox Live Game Save"},
    @{Name="XboxNetApiSvc";    Label="Xbox Live Networking Service"},
    @{Name="WerSvc";           Label="Windows Error Reporting"},
    @{Name="Fax";              Label="Fax Service"},
    @{Name="PrintNotify";      Label="Printer Notifications"}
)

# Common software available to install via winget (id = winget package id)
$SoftwareCatalog = @(
    @{Id="Google.Chrome";              Label="Google Chrome";        Desc="Web browser"},
    @{Id="Mozilla.Firefox";            Label="Mozilla Firefox";      Desc="Web browser"},
    @{Id="VideoLAN.VLC";               Label="VLC Media Player";     Desc="Universal media player"},
    @{Id="7zip.7zip";                  Label="7-Zip";                Desc="File archiver"},
    @{Id="Notepad++.Notepad++";        Label="Notepad++";            Desc="Lightweight text/code editor"},
    @{Id="Microsoft.PowerToys";        Label="Microsoft PowerToys";  Desc="Productivity utilities from Microsoft"},
    @{Id="Discord.Discord";            Label="Discord";              Desc="Chat & voice for communities"},
    @{Id="Valve.Steam";                Label="Steam";                Desc="Gaming platform"},
    @{Id="Malwarebytes.Malwarebytes";  Label="Malwarebytes";         Desc="Anti-malware scanner"},
    @{Id="Adobe.Acrobat.Reader.64-bit";Label="Adobe Acrobat Reader"; Desc="PDF viewer"},
    @{Id="Oracle.SQLDeveloper";        Label="Oracle SQL Developer"; Desc="Free IDE for Oracle database development (installed to your data drive, not C:)"; Location="\SQLDeveloper"},
    @{Id="OpenJS.NodeJS.LTS";          Label="Node.js (LTS)";        Desc="JavaScript runtime for server-side development"},
    @{Id="MongoDB.Compass.Full";       Label="MongoDB Compass";      Desc="GUI for exploring and managing MongoDB databases"},
    @{Id="Docker.DockerDesktop";       Label="Docker Desktop";       Desc="Container platform for building and running apps"},
    @{Id="Microsoft.VisualStudioCode"; Label="Visual Studio Code";   Desc="Lightweight code editor"},
    @{Id="Microsoft.DotNet.SDK.8";     Label=".NET 8.0 SDK";         Desc="Microsoft .NET 8.0 development runtime & SDK"},
    @{Id="Python.Python.3.12";         Label="Python 3.12.7";        Desc="Python programming language runtime"},
    @{Id="Microsoft.VisualStudio.2022.Community"; Label="Visual Studio 2022"; Desc="Full IDE for app, game, and cloud development"},
    @{Id="Brave.Brave";                Label="Brave Browser";        Desc="Privacy-focused web browser"},
    @{Id="RARLab.WinRAR";              Label="WinRAR";               Desc="File archiver and compressor"},
    @{Id="OBSProject.OBSStudio";       Label="OBS Studio";           Desc="Free screen recording & live streaming software"},
    @{Id="Ventoy.Ventoy";              Label="Ventoy";                Desc="Create bootable USB drives from multiple ISOs"},
    @{Id="Rufus.Rufus";                Label="Rufus";                 Desc="Create bootable USB drives from a single ISO"},
    @{Id="Nlitesoft.NTLite";           Label="NTLite";                Desc="Edit and debloat Windows images, integrate updates/drivers, automate setup (free tier available; some features need a paid license)"},
    @{Id="PostgreSQL.PostgreSQL";      Label="PostgreSQL";            Desc="Open-source relational database"},
    @{Id="EclipseFoundation.EclipseIDE"; Label="Eclipse IDE";         Desc="IDE for Java and other language development"},
    @{Id="Oracle.JavaRuntimeEnvironment"; Label="Java Runtime Environment"; Desc="Runtime needed to run Java applications"},
    @{Id="Office.LTSC.ProPlus2021";    Label="Microsoft Office LTSC 2021"; Desc="Office LTSC Professional Plus 2021 (perpetual, non-subscription). Deployed via the official Office Deployment Tool — requires your own valid volume license key to activate"; Handler="OfficeLTSC2021"},
    @{Id="Tonec.InternetDownloadManager"; Label="Internet Download Manager"; Desc="Download manager (shareware — requires a paid license after trial)"},
    @{Id="Trimble.SketchUp";           Label="SketchUp";              Desc="3D modeling software (trial/subscription license required)"},
    @{Id="BlenderFoundation.Blender";  Label="Blender";                Desc="Free, open-source 3D creation suite"},
    @{Id="Autodesk.Maya";              Label="Autodesk Maya";         Desc="3D animation & VFX software (subscription license required)"},
    @{Id="Anaconda.Anaconda3";         Label="Anaconda (incl. Anaconda PowerShell Prompt)"; Desc="Python/R data science distribution with the Anaconda PowerShell Prompt shortcut"},
    @{Id="Microsoft.Edge";             Label="Microsoft Edge";        Desc="Microsoft's Chromium-based web browser"},
    @{Id="9N7JSXC1SJK6";               Label="Blip Transfer";         Desc="Cross-device file transfer with no size limits (Microsoft Store app)"},
    @{Id="9WZDNCRFJBMP";               Label="Microsoft Store";       Desc="Reinstalls the Microsoft Store app itself if it was removed"},
    @{Id="9MSSGKG348SP";               Label="Widgets";                Desc="Windows Web Experience Pack — powers the taskbar Widgets panel"},
    @{Id="9WZDNCRFHVFW";               Label="Weather";                Desc="MSN Weather app"},
    @{Id="Microsoft.365Copilot";       Label="Microsoft 365 Copilot"; Desc="Microsoft's AI assistant app"},
    @{Id="Microsoft.OneDrive";         Label="Microsoft OneDrive";    Desc="Cloud file storage and sync from Microsoft"},
    @{Id="9WZDNCRFHWD2";               Label="Microsoft Solitaire Collection"; Desc="Classic Solitaire card games (Microsoft Store app)"}
)

# ---------------------------------------------------------------------------
# 3. Logging helper (shared across all sections)
# ---------------------------------------------------------------------------

function Write-Log {
    param($msg, $color = "#B5E8B0")
    $run = New-Object System.Windows.Documents.Run("[$(Get-Date -Format 'HH:mm:ss')] $msg`n")
    $run.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString($color)
    $script:LogParagraph.Inlines.Add($run)
    $script:LogViewer.ScrollToEnd()
}

# ---------------------------------------------------------------------------
# 4. SOFTWARE section functions
# ---------------------------------------------------------------------------

function Test-Winget {
    $null = Get-Command winget -ErrorAction SilentlyContinue
    return $?
}

function Get-DataDrive {
    # Picks the largest non-system fixed drive (D:, E:, ...) to use as the
    # "data drive" for packages that should not land on C:. Falls back to the
    # system drive if the machine only has one partition.
    try {
        $sysDrive = $env:SystemDrive.TrimEnd('\')
        $candidate = Get-CimInstance -ClassName Win32_LogicalDisk -ErrorAction Stop |
            Where-Object { $_.DriveType -eq 3 -and $_.DeviceID -ne $sysDrive -and $_.FreeSpace -gt 1GB } |
            Sort-Object -Property FreeSpace -Descending |
            Select-Object -First 1
        if ($candidate) { return $candidate.DeviceID }
    } catch {}
    return $env:SystemDrive.TrimEnd('\')
}

function Find-OdtSetup {
    # Locates the Office Deployment Tool's setup.exe. winget's
    # Microsoft.OfficeDeploymentTool package extracts it, but the exact folder
    # varies by version, so check the usual spots then fall back to a search.
    $candidates = @(
        "${env:ProgramFiles}\OfficeDeploymentTool\setup.exe",
        "${env:ProgramFiles(x86)}\OfficeDeploymentTool\setup.exe",
        "${env:ProgramFiles}\Microsoft Office Deployment Tool\setup.exe"
    )
    foreach ($c in $candidates) { if (Test-Path $c) { return $c } }

    foreach ($base in @("${env:ProgramFiles}", "${env:ProgramFiles(x86)}")) {
        if (Test-Path $base) {
            $found = Get-ChildItem -Path $base -Filter "setup.exe" -Recurse -ErrorAction SilentlyContinue |
                Where-Object { $_.DirectoryName -match "Office.*Deployment" } |
                Select-Object -First 1
            if ($found) { return $found.FullName }
        }
    }
    return $null
}

function Install-OfficeLTSC2021 {
    # Office LTSC 2021 is volume-licensed and has no winget package of its own.
    # Microsoft's supported path is the Office Deployment Tool driven by a
    # configuration.xml pinned to the PerpetualVL2021 channel.
    if (-not (Test-Winget)) {
        Write-Log "winget (App Installer) was not found. Install 'App Installer' from the Microsoft Store, then retry." "#FF7A7A"
        return
    }

    Write-Log "=== Installing Microsoft Office LTSC 2021 ===" "#82C9FF"
    Write-Log "Fetching the Office Deployment Tool..." "#B5BAC1"
    try {
        $p = Start-Process -FilePath "winget" -ArgumentList "install -e --id Microsoft.OfficeDeploymentTool --source winget --silent --accept-source-agreements --accept-package-agreements" -Wait -PassThru -NoNewWindow
        if ($p.ExitCode -ne 0) {
            Write-Log "winget returned code $($p.ExitCode) for the Office Deployment Tool (it may already be installed)." "#FFB86B"
        }
    } catch {
        Write-Log "Failed to launch winget: $($_.Exception.Message)" "#FF7A7A"
        return
    }

    $setup = Find-OdtSetup
    if (-not $setup) {
        Write-Log "The Office Deployment Tool's setup.exe wasn't found after install. Install the Office Deployment Tool manually from Microsoft, then retry." "#FF7A7A"
        return
    }
    Write-Log "Office Deployment Tool found at: $setup"

    $odtDir = Split-Path -Parent $setup
    $configPath = Join-Path $odtDir "WinForge-OfficeLTSC2021.xml"
    $config = @'
<Configuration>
  <Add OfficeClientEdition="64" Channel="PerpetualVL2021">
    <Product ID="ProPlus2021Volume">
      <Language ID="MatchOS" />
ețeaua
    </Product>
  </Add>
  <Display Level="None" AcceptEULA="TRUE" />
  <Property Name="AUTOACTIVATE" Value="0" />
  <RemoveMSI />
</Configuration>
'@
    try {
        Set-Content -Path $configPath -Value $config -Encoding UTF8 -Force
        Write-Log "Wrote deployment config: $configPath"
    } catch {
        Write-Log "Could not write the Office configuration file: $($_.Exception.Message)" "#FF7A7A"
        return
    }

    Write-Log "Downloading and installing Office LTSC 2021. This is a large download and can take a while..." "#B5BAC1"
    try {
        $p2 = Start-Process -FilePath $setup -ArgumentList "/configure `"$configPath`"" -Wait -PassThru -WorkingDirectory $odtDir -NoNewWindow
        if ($p2.ExitCode -eq 0) {
            Write-Log "Office LTSC 2021 installed." "#7CFC9C"
            Write-Log "Activation is not automatic: enter your own volume license key via Office, or with slmgr/ospp as your organization requires." "#FFB86B"
        } else {
            Write-Log "Office Deployment Tool returned code $($p2.ExitCode). Check %TEMP% for the Office setup logs." "#FFB86B"
        }
    } catch {
        Write-Log "Office LTSC 2021 install failed: $($_.Exception.Message)" "#FF7A7A"
    }
}

function Install-SelectedSoftware {
    param([string[]]$PackageIds)
    if (-not (Test-Winget)) {
        Write-Log "winget (App Installer) was not found. Install 'App Installer' from the Microsoft Store, then retry." "#FF7A7A"
        return
    }
    Write-Log "=== Installing selected software ===" "#82C9FF"
    foreach ($id in $PackageIds) {
        try {
            # Catalog entries may declare a Location (e.g. Oracle SQL Developer),
            # meaning "don't put this on C:". Resolve it against the data drive.
            $locArg = ""
            $entry = $SoftwareCatalog | Where-Object { $_.Id -eq $id } | Select-Object -First 1
            if ($entry -and $entry.Location) {
                $targetPath = (Get-DataDrive) + $entry.Location
                if (-not (Test-Path $targetPath)) {
                    New-Item -Path $targetPath -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
                }
                $locArg = " --location `"$targetPath`""
                Write-Log "$id will be installed to: $targetPath" "#82C9FF"
            }

            Write-Log "Installing $id ..."
            $p = Start-Process -FilePath "winget" -ArgumentList "install -e --id $id --source winget --silent --accept-source-agreements --accept-package-agreements$locArg" -Wait -PassThru -NoNewWindow
            if ($p.ExitCode -eq 0) { Write-Log "Installed: $id" "#7CFC9C" }
            else {
                # Some catalog entries are Microsoft Store product codes, which don't
                # live in the winget source. Retry once against the msstore source.
                $p2 = Start-Process -FilePath "winget" -ArgumentList "install -e --id $id --source msstore --silent --accept-source-agreements --accept-package-agreements" -Wait -PassThru -NoNewWindow
                if ($p2.ExitCode -eq 0) { Write-Log "Installed: $id" "#7CFC9C" }
                else { Write-Log "winget returned code $($p.ExitCode) for $id (may already be installed)" "#FFB86B" }
            }
        } catch {
            Write-Log "Failed to install $id : $($_.Exception.Message)" "#FF7A7A"
        }
    }
}

function Uninstall-SelectedSoftware {
    param([string[]]$PackageIds)
    if (-not (Test-Winget)) {
        Write-Log "winget (App Installer) was not found. Install 'App Installer' from the Microsoft Store, then retry." "#FF7A7A"
        return
    }
    Write-Log "=== Uninstalling selected software ===" "#82C9FF"
    foreach ($id in $PackageIds) {
        try {
            Write-Log "Uninstalling $id ..."
            $p = Start-Process -FilePath "winget" -ArgumentList "uninstall -e --id $id --source winget --silent --accept-source-agreements" -Wait -PassThru -NoNewWindow
            if ($p.ExitCode -eq 0) { Write-Log "Uninstalled: $id" "#7CFC9C" }
            else {
                # Mirror the install fallback: retry Store-sourced package IDs via msstore.
                $p2 = Start-Process -FilePath "winget" -ArgumentList "uninstall -e --id $id --source msstore --silent --accept-source-agreements" -Wait -PassThru -NoNewWindow
                if ($p2.ExitCode -eq 0) { Write-Log "Uninstalled: $id" "#7CFC9C" }
                else { Write-Log "winget returned code $($p.ExitCode) for $id (may not be installed)" "#FFB86B" }
            }
        } catch {
            Write-Log "Failed to uninstall $id : $($_.Exception.Message)" "#FF7A7A"
        }
    }
}

# ---------------------------------------------------------------------------
# 5. OPTIMIZE section functions
# ---------------------------------------------------------------------------

function New-RestorePoint {
    try {
        Write-Log "Enabling System Restore on C:..."
        Enable-ComputerRestore -Drive "C:\" -ErrorAction SilentlyContinue
        Write-Log "Creating restore point '$AppName'..."
        Checkpoint-Computer -Description $AppName -RestorePointType "MODIFY_SETTINGS" -ErrorAction Stop
        Write-Log "Restore point created successfully." "#7CFC9C"
    } catch {
        Write-Log "WARNING: Could not create restore point: $($_.Exception.Message)" "#FFB86B"
    }
}

function Remove-Bloatware {
    Write-Log "=== Removing bloatware apps ===" "#82C9FF"
    foreach ($app in $BloatApps) {
        try {
            Get-AppxPackage -Name $app -AllUsers -ErrorAction SilentlyContinue | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
            Get-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue | Where-Object DisplayName -eq $app | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
            Write-Log "Removed (if present): $app"
        } catch {
            Write-Log "Skipped $app : $($_.Exception.Message)" "#FFB86B"
        }
    }
}

function Disable-Telemetry {
    Write-Log "=== Disabling telemetry & data collection ===" "#82C9FF"
    $paths = @(
        @{Path="HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"; Name="AllowTelemetry"; Value=0},
        @{Path="HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo"; Name="Enabled"; Value=0},
        @{Path="HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo"; Name="Enabled"; Value=0},
        @{Path="HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"; Name="DisableWindowsConsumerFeatures"; Value=1},
        @{Path="HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"; Name="SubscribedContent-338388Enabled"; Value=0}
    )
    foreach ($p in $paths) {
        try {
            if (-not (Test-Path $p.Path)) { New-Item -Path $p.Path -Force | Out-Null }
            New-ItemProperty -Path $p.Path -Name $p.Name -Value $p.Value -PropertyType DWord -Force | Out-Null
            Write-Log "Set $($p.Name) = $($p.Value)"
        } catch {
            Write-Log "Failed on $($p.Path): $($_.Exception.Message)" "#FFB86B"
        }
    }
}

function Disable-SelectedServices {
    param([string[]]$ServiceNames)
    Write-Log "=== Disabling selected services ===" "#82C9FF"
    foreach ($svc in $ServiceNames) {
        try {
            Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
            Set-Service -Name $svc -StartupType Disabled -ErrorAction Stop
            Write-Log "Disabled service: $svc"
        } catch {
            Write-Log "Could not disable $svc : $($_.Exception.Message)" "#FFB86B"
        }
    }
}

function Optimize-VisualEffects {
    Write-Log "=== Setting visual effects to Best Performance ===" "#82C9FF"
    try {
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -Value ([byte[]](0x90,0x12,0x03,0x80,0x10,0x00,0x00,0x00)) -Force
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\DWM" -Name "EnableAeroPeek" -Value 0 -ErrorAction SilentlyContinue
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name "MinAnimate" -Value 0 -Force
        Write-Log "Visual effects tuned for performance."
    } catch {
        Write-Log "Failed to set visual effects: $($_.Exception.Message)" "#FFB86B"
    }
}

function Set-HighPerformancePower {
    Write-Log "=== Applying High Performance power plan ===" "#82C9FF"
    try {
        powercfg -setactive SCHEME_MIN
        Write-Log "High performance power plan activated."
    } catch {
        Write-Log "Failed to set power plan: $($_.Exception.Message)" "#FFB86B"
    }
}

function Disable-StartupBloat {
    Write-Log "=== Disabling common startup bloat entries ===" "#82C9FF"
    $runKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
    $bloatNames = @("OneDrive", "Spotify", "Skype", "Teams", "CCleaner Smart Cleaning")
    foreach ($name in $bloatNames) {
        try {
            if (Get-ItemProperty -Path $runKey -Name $name -ErrorAction SilentlyContinue) {
                Remove-ItemProperty -Path $runKey -Name $name -ErrorAction Stop
                Write-Log "Removed startup entry: $name"
            }
        } catch {
            Write-Log "Could not remove startup entry $name : $($_.Exception.Message)" "#FFB86B"
        }
    }
}

function Clear-TempFiles {
    Write-Log "=== Cleaning temp files & cache ===" "#82C9FF"
    $paths = @($env:TEMP, "C:\Windows\Temp", "C:\Windows\Prefetch")
    foreach ($p in $paths) {
        try {
            Get-ChildItem -Path $p -Recurse -Force -ErrorAction SilentlyContinue |
                Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
            Write-Log "Cleaned: $p"
        } catch {
            Write-Log "Partial clean of $p (some files in use, that's normal)."
        }
    }
    try {
        Start-Process -FilePath cleanmgr.exe -ArgumentList "/sagerun:1" -WindowStyle Hidden -ErrorAction SilentlyContinue
    } catch {}
}

function Disable-CortanaWebSearch {
    Write-Log "=== Disabling Cortana & web search in Start menu ===" "#82C9FF"
    try {
        $path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
        if (-not (Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
        New-ItemProperty -Path $path -Name "AllowCortana" -Value 0 -PropertyType DWord -Force | Out-Null
        New-ItemProperty -Path $path -Name "ConnectedSearchUseWeb" -Value 0 -PropertyType DWord -Force | Out-Null
        Write-Log "Cortana and web search disabled."
    } catch {
        Write-Log "Failed: $($_.Exception.Message)" "#FFB86B"
    }
}

function Optimize-Network {
    Write-Log "=== Applying network latency tweaks ===" "#82C9FF"
    try {
        netsh int tcp set global autotuninglevel=normal | Out-Null
        netsh int tcp set global rss=enabled | Out-Null
        Write-Log "TCP auto-tuning and RSS optimized."
    } catch {
        Write-Log "Failed network tweak: $($_.Exception.Message)" "#FFB86B"
    }
}

# ---------------------------------------------------------------------------
# 6. SYSTEM REPAIR section functions (all built on documented Windows tools)
# ---------------------------------------------------------------------------

function Invoke-SFCScan {
    Write-Log "=== Running System File Checker (sfc /scannow) ===" "#82C9FF"
    Write-Log "This can take several minutes. Please wait..."
    try {
        $out = & sfc.exe /scannow 2>&1 | Out-String
        Write-Log ($out.Trim())
        Write-Log "SFC scan complete." "#7CFC9C"
    } catch {
        Write-Log "SFC scan failed: $($_.Exception.Message)" "#FF7A7A"
    }
}

function Invoke-DISMRestoreHealth {
    Write-Log "=== Running DISM RestoreHealth (repairs the component store) ===" "#82C9FF"
    Write-Log "This can take 10-20 minutes depending on your connection..."
    try {
        $out = & DISM.exe /Online /Cleanup-Image /RestoreHealth 2>&1 | Out-String
        Write-Log ($out.Trim())
        Write-Log "DISM RestoreHealth complete." "#7CFC9C"
    } catch {
        Write-Log "DISM failed: $($_.Exception.Message)" "#FF7A7A"
    }
}

function Invoke-ComponentCleanup {
    Write-Log "=== Cleaning up WinSxS component store ===" "#82C9FF"
    try {
        $out = & DISM.exe /Online /Cleanup-Image /StartComponentCleanup 2>&1 | Out-String
        Write-Log ($out.Trim())
        Write-Log "Component store cleanup complete." "#7CFC9C"
    } catch {
        Write-Log "Cleanup failed: $($_.Exception.Message)" "#FF7A7A"
    }
}

function Reset-WindowsUpdateComponents {
    Write-Log "=== Resetting Windows Update components ===" "#82C9FF"
    try {
        Write-Log "Stopping update services..."
        $services = @("wuauserv","cryptSvc","bits","msiserver")
        foreach ($s in $services) { Stop-Service -Name $s -Force -ErrorAction SilentlyContinue }

        Write-Log "Renaming SoftwareDistribution and catroot2 folders..."
        $sd = "$env:windir\SoftwareDistribution"
        $cr = "$env:windir\System32\catroot2"
        if (Test-Path $sd) { Rename-Item -Path $sd -NewName "SoftwareDistribution.bak" -Force -ErrorAction SilentlyContinue }
        if (Test-Path $cr) { Rename-Item -Path $cr -NewName "catroot2.bak" -Force -ErrorAction SilentlyContinue }

        Write-Log "Restarting update services..."
        foreach ($s in $services) { Start-Service -Name $s -ErrorAction SilentlyContinue }

        Write-Log "Windows Update components reset. Try Windows Update again." "#7CFC9C"
    } catch {
        Write-Log "Windows Update reset failed: $($_.Exception.Message)" "#FF7A7A"
    }
}

function Reset-NetworkStack {
    Write-Log "=== Resetting network stack ===" "#82C9FF"
    try {
        & netsh winsock reset | Out-Null
        Write-Log "Winsock reset."
        & netsh int ip reset | Out-Null
        Write-Log "TCP/IP stack reset."
        & ipconfig /flushdns | Out-Null
        Write-Log "DNS cache flushed."
        & ipconfig /release | Out-Null
        & ipconfig /renew | Out-Null
        Write-Log "Network stack reset complete. A restart is required for winsock/TCP-IP reset to fully apply." "#7CFC9C"
    } catch {
        Write-Log "Network reset failed: $($_.Exception.Message)" "#FF7A7A"
    }
}

function Invoke-CheckDiskScan {
    Write-Log "=== Scheduling CHKDSK on next restart ===" "#82C9FF"
    try {
        $out = & cmd.exe /c "echo Y| chkdsk C: /f /r" 2>&1 | Out-String
        Write-Log ($out.Trim())
        Write-Log "CHKDSK scheduled. It will run automatically on your next restart." "#7CFC9C"
    } catch {
        Write-Log "Could not schedule CHKDSK: $($_.Exception.Message)" "#FF7A7A"
    }
}

function Repair-WindowsSearchIndex {
    Write-Log "=== Rebuilding Windows Search index ===" "#82C9FF"
    try {
        Stop-Service WSearch -Force -ErrorAction SilentlyContinue
        $indexPath = "$env:ProgramData\Microsoft\Search\Data"
        if (Test-Path $indexPath) {
            Remove-Item -Path $indexPath -Recurse -Force -ErrorAction SilentlyContinue
            Write-Log "Old search index cleared."
        }
        Start-Service WSearch -ErrorAction SilentlyContinue
        Write-Log "Search index rebuild triggered (this happens gradually in the background)." "#7CFC9C"
    } catch {
        Write-Log "Search index repair failed: $($_.Exception.Message)" "#FF7A7A"
    }
}

function Invoke-FullRepairSequence {
    Write-Log "===== RUNNING FULL REPAIR SEQUENCE =====" "#4FD1C5"
    Invoke-SFCScan
    Invoke-DISMRestoreHealth
    Invoke-ComponentCleanup
    Reset-NetworkStack
    Write-Log "===== FULL REPAIR SEQUENCE COMPLETE. Restart recommended. =====" "#4FD1C5"
}

# ---------------------------------------------------------------------------
# 6b. Async runner - runs repair work in a background job so the WPF UI
#     thread never blocks (this is the fix for System Repair freezing/
#     appearing to hang during long-running operations like SFC/DISM).
# ---------------------------------------------------------------------------
function Start-BackgroundRepairTask {
    param(
        [string]$Label,
        [scriptblock]$Work,
        [System.Windows.Controls.Button[]]$ButtonsToDisable = @()
    )

    Write-Log "=== $Label (running in background) ===" "#82C9FF"
    $ctrl["StatusText"].Text = "$Label running..."
    foreach ($b in $ButtonsToDisable) { $b.IsEnabled = $false }

    $job = Start-Job -ScriptBlock $Work

    $timer = New-Object System.Windows.Threading.DispatcherTimer
    $timer.Interval = [TimeSpan]::FromMilliseconds(800)
    $timer.Add_Tick({
        $lines = Receive-Job -Job $job -ErrorAction SilentlyContinue
        foreach ($line in $lines) {
            if ($line -and "$line".Trim().Length -gt 0) { Write-Log "$line" }
        }
        if ($job.State -in @('Completed','Failed','Stopped')) {
            $timer.Stop()
            $final = Receive-Job -Job $job -ErrorAction SilentlyContinue
            foreach ($line in $final) {
                if ($line -and "$line".Trim().Length -gt 0) { Write-Log "$line" }
            }
            Remove-Job -Job $job -Force -ErrorAction SilentlyContinue
            $color = if ($job.State -eq 'Failed') { "#FF7A7A" } else { "#7CFC9C" }
            Write-Log "=== $Label complete. ===" $color
            $ctrl["StatusText"].Text = "$Label finished."
            foreach ($b in $ButtonsToDisable) { $b.IsEnabled = $true }
        }
    }.GetNewClosure())
    $timer.Start()
}

# ---------------------------------------------------------------------------
# 7. CUSTOMIZE section functions (Windows 10 / 11 aware)
# ---------------------------------------------------------------------------

function Set-TaskbarAlignLeft {
    if (-not $IsWin11) { Write-Log "Taskbar alignment tweak only applies to Windows 11. Skipped." "#FFB86B"; return }
    try {
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAl" -Value 0 -Force
        Write-Log "Taskbar icons aligned to the left (Windows 11)." "#7CFC9C"
    } catch { Write-Log "Failed: $($_.Exception.Message)" "#FF7A7A" }
}

function Disable-Widgets {
    if (-not $IsWin11) { Write-Log "Widgets tweak only applies to Windows 11. Skipped." "#FFB86B"; return }
    try {
        $path = "HKLM:\SOFTWARE\Policies\Microsoft\Dsh"
        if (-not (Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
        New-ItemProperty -Path $path -Name "AllowNewsAndInterests" -Value 0 -PropertyType DWord -Force | Out-Null
        Write-Log "Widgets disabled (Windows 11)." "#7CFC9C"
    } catch { Write-Log "Failed: $($_.Exception.Message)" "#FF7A7A" }
}

function Disable-ChatIcon {
    if (-not $IsWin11) { Write-Log "Chat icon tweak only applies to Windows 11. Skipped." "#FFB86B"; return }
    try {
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarMn" -Value 0 -Force
        Write-Log "Taskbar Chat icon disabled (Windows 11)." "#7CFC9C"
    } catch { Write-Log "Failed: $($_.Exception.Message)" "#FF7A7A" }
}

function Enable-ClassicContextMenu {
    if (-not $IsWin11) { Write-Log "Classic context menu tweak only applies to Windows 11. Skipped." "#FFB86B"; return }
    try {
        $key = "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32"
        if (-not (Test-Path $key)) { New-Item -Path $key -Force | Out-Null }
        Set-ItemProperty -Path $key -Name "(Default)" -Value "" -Force
        Write-Log "Classic (Windows 10-style) right-click context menu enabled. Restart Explorer to see it." "#7CFC9C"
    } catch { Write-Log "Failed: $($_.Exception.Message)" "#FF7A7A" }
}

function Set-DarkMode {
    try {
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0 -Force
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 0 -Force
        Write-Log "Dark mode enabled for apps and system." "#7CFC9C"
    } catch { Write-Log "Failed: $($_.Exception.Message)" "#FF7A7A" }
}

function Show-FileExtensions {
    try {
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0 -Force
        Write-Log "File extensions are now shown in File Explorer." "#7CFC9C"
    } catch { Write-Log "Failed: $($_.Exception.Message)" "#FF7A7A" }
}

function Show-HiddenFiles {
    try {
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Value 1 -Force
        Write-Log "Hidden files are now shown in File Explorer." "#7CFC9C"
    } catch { Write-Log "Failed: $($_.Exception.Message)" "#FF7A7A" }
}

function Disable-LockScreenTips {
    try {
        $path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
        Set-ItemProperty -Path $path -Name "RotatingLockScreenOverlayEnabled" -Value 0 -Force -ErrorAction SilentlyContinue
        Set-ItemProperty -Path $path -Name "SubscribedContent-338387Enabled" -Value 0 -Force -ErrorAction SilentlyContinue
        Write-Log "Lock screen tips and suggestions disabled." "#7CFC9C"
    } catch { Write-Log "Failed: $($_.Exception.Message)" "#FF7A7A" }
}

function Restart-Explorer {
    Write-Log "Restarting Explorer to apply visual changes..." "#82C9FF"
    Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 1
    Start-Process explorer.exe
    Write-Log "Explorer restarted." "#7CFC9C"
}

# ---------------------------------------------------------------------------
# 7a. ADVANCED TWEAKS section functions
#     Every tweak here uses documented, Microsoft-supported settings only.
#     None of them touch Windows Update services, Windows Defender, UAC,
#     driver signing, or boot configuration data, and each one is a simple
#     value flip that can be reverted the same way it was applied.
# ---------------------------------------------------------------------------

function Enable-LongPaths {
    try {
        $path = "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem"
        Set-ItemProperty -Path $path -Name "LongPathsEnabled" -Value 1 -Force
        Write-Log "NTFS long path support enabled." "#7CFC9C"
    } catch { Write-Log "Failed: $($_.Exception.Message)" "#FF7A7A" }
}

function Enable-VerboseStatusMessages {
    try {
        $path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
        if (-not (Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
        New-ItemProperty -Path $path -Name "VerboseStatus" -Value 1 -PropertyType DWord -Force | Out-Null
        Write-Log "Verbose boot/shutdown status messages enabled." "#7CFC9C"
    } catch { Write-Log "Failed: $($_.Exception.Message)" "#FF7A7A" }
}

function Disable-FastStartup {
    try {
        $path = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power"
        Set-ItemProperty -Path $path -Name "HiberbootEnabled" -Value 0 -Force
        Write-Log "Fast Startup disabled (hibernation itself is unaffected)." "#7CFC9C"
    } catch { Write-Log "Failed: $($_.Exception.Message)" "#FF7A7A" }
}

function Enable-StorageSense {
    try {
        $path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy"
        if (-not (Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
        New-ItemProperty -Path $path -Name "01" -Value 1 -PropertyType DWord -Force | Out-Null
        Write-Log "Storage Sense (automatic disk cleanup) enabled." "#7CFC9C"
    } catch { Write-Log "Failed: $($_.Exception.Message)" "#FF7A7A" }
}

function Set-ClockSeconds {
    try {
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSecondsInSystemClock" -Value 1 -Force
        Write-Log "Seconds enabled in the taskbar clock." "#7CFC9C"
    } catch { Write-Log "Failed: $($_.Exception.Message)" "#FF7A7A" }
}

function Set-FastMenuResponse {
    try {
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Value "0" -Force
        Write-Log "Menu and tooltip response speed increased." "#7CFC9C"
    } catch { Write-Log "Failed: $($_.Exception.Message)" "#FF7A7A" }
}

function Set-ExplorerOpenToThisPC {
    try {
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Value 1 -Force
        Write-Log "File Explorer set to open to 'This PC'." "#7CFC9C"
    } catch { Write-Log "Failed: $($_.Exception.Message)" "#FF7A7A" }
}

function Increase-IconCacheSize {
    try {
        $path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer"
        if (-not (Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
        New-ItemProperty -Path $path -Name "Max Cached Icons" -Value "8192" -PropertyType String -Force | Out-Null
        Write-Log "Icon cache size increased." "#7CFC9C"
    } catch { Write-Log "Failed: $($_.Exception.Message)" "#FF7A7A" }
}

function Enable-TaskbarEndTask {
    if (-not $IsWin11) { Write-Log "'End Task' taskbar tweak only applies to Windows 11. Skipped." "#FFB86B"; return }
    try {
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarEndTask" -Value 1 -Force
        Write-Log "'End Task' restored to taskbar right-click menu (Windows 11)." "#7CFC9C"
    } catch { Write-Log "Failed: $($_.Exception.Message)" "#FF7A7A" }
}

function Enable-ClipboardHistory {
    try {
        $path = "HKCU:\Software\Microsoft\Clipboard"
        if (-not (Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
        New-ItemProperty -Path $path -Name "EnableClipboardHistory" -Value 1 -PropertyType DWord -Force | Out-Null
        Write-Log "Clipboard history (Win+V) enabled." "#7CFC9C"
    } catch { Write-Log "Failed: $($_.Exception.Message)" "#FF7A7A" }
}

function Disable-BackgroundApps {
    try {
        $path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications"
        if (-not (Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
        New-ItemProperty -Path $path -Name "GlobalUserDisabled" -Value 1 -PropertyType DWord -Force | Out-Null
        Write-Log "Background apps disabled." "#7CFC9C"
    } catch { Write-Log "Failed: $($_.Exception.Message)" "#FF7A7A" }
}

# ---------------------------------------------------------------------------
# 7b. CUSTOM WINDOWS ISO section (offline image servicing via DISM)
# ---------------------------------------------------------------------------

function Find-Oscdimg {
    param([string]$ManualPath)

    if ($ManualPath -and (Test-Path $ManualPath)) { return $ManualPath }

    $candidates = @(
        "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg\oscdimg.exe",
        "${env:ProgramFiles}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg\oscdimg.exe"
    )
    foreach ($c in $candidates) { if (Test-Path $c) { return $c } }

    # Fall back to the ADK's own registry-recorded install root, in case it
    # was installed to a non-default drive/location.
    $regPaths = @(
        "HKLM:\SOFTWARE\Microsoft\Windows Kits\Installed Roots",
        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows Kits\Installed Roots"
    )
    foreach ($rp in $regPaths) {
        try {
            $root = (Get-ItemProperty -Path $rp -Name "KitsRoot10" -ErrorAction SilentlyContinue).KitsRoot10
            if ($root) {
                $guess = Join-Path $root "Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg\oscdimg.exe"
                if (Test-Path $guess) { return $guess }
            }
        } catch {}
    }

    # Last resort: recursive search under any "Windows Kits\10" folder found
    # on fixed drives (covers ADK installs in unusual locations).
    foreach ($base in @("${env:ProgramFiles}\Windows Kits\10", "${env:ProgramFiles(x86)}\Windows Kits\10")) {
        if (Test-Path $base) {
            $found = Get-ChildItem -Path $base -Filter "oscdimg.exe" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
            if ($found) { return $found.FullName }
        }
    }

    return $null
}

function Install-OscdimgTool {
    # Downloads/installs just the Windows ADK "Deployment Tools" feature
    # (which contains oscdimg.exe) via winget, so the user doesn't have to
    # go find and run the full ADK installer by hand.
    $existing = Find-Oscdimg
    if ($existing) {
        Write-Log "oscdimg.exe is already available at: $existing" "#7CFC9C"
        return $existing
    }

    if (-not (Test-Winget)) {
        Write-Log "winget (App Installer) was not found, so oscdimg.exe can't be fetched automatically. Install 'App Installer' from the Microsoft Store, or install the Windows ADK Deployment Tools manually, then Browse to oscdimg.exe." "#FF7A7A"
        return $null
    }

    Write-Log "=== Downloading Windows ADK Deployment Tools (contains oscdimg.exe) via winget ===" "#82C9FF"
    Write-Log "Only the Deployment Tools feature is requested, not the full ADK. This can take a few minutes depending on your connection." "#B5BAC1"
    try {
        $p = Start-Process -FilePath "winget" -ArgumentList 'install -e --id Microsoft.WindowsADK --source winget --silent --accept-source-agreements --accept-package-agreements --override "/quiet /features OptionId.DeploymentTools /norestart"' -Wait -PassThru -NoNewWindow
        if ($p.ExitCode -ne 0) {
            Write-Log "winget returned code $($p.ExitCode) installing the Windows ADK Deployment Tools (it may already be installed, or may need to be installed manually)." "#FFB86B"
        }
    } catch {
        Write-Log "Failed to launch winget: $($_.Exception.Message)" "#FF7A7A"
        return $null
    }

    $found = Find-Oscdimg
    if ($found) {
        Write-Log "oscdimg.exe installed and found at: $found" "#7CFC9C"
    } else {
        Write-Log "The Deployment Tools install finished but oscdimg.exe still wasn't found. Browse to it manually if you know where it is, or try installing the Windows ADK Deployment Tools yourself." "#FFB86B"
    }
    return $found
}

function New-UnattendedAnswerFile {
    param([string]$DestinationRoot)
    $xml = @'
<?xml version="1.0" encoding="utf-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend">
  <settings pass="oobeSystem">
    <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State">
      <OOBE>
        <HideEULAPage>true</HideEULAPage>
        <HideOEMRegistrationScreen>true</HideOEMRegistrationScreen>
        <HideOnlineAccountScreens>true</HideOnlineAccountScreens>
        <HideWirelessSetupInOOBE>true</HideWirelessSetupInOOBE>
        <ProtectYourPC>3</ProtectYourPC>
      </OOBE>
    </component>
  </settings>
</unattend>
'@
    $path = Join-Path $DestinationRoot "autounattend.xml"
    Set-Content -Path $path -Value $xml -Encoding UTF8 -Force
    return $path
}

function New-CustomWindowsISO {
    param(
        [string]$SourceIsoPath,
        [string]$OutputIsoPath,
        [bool]$RemoveBloatware,
        [bool]$DisableTelemetryInImage,
        [bool]$SkipOOBE,
        [string]$OscdimgPath
    )

    if (-not (Test-Path $SourceIsoPath)) {
        Write-Log "Source ISO not found: $SourceIsoPath" "#FF7A7A"
        return
    }

    $work = Join-Path $env:TEMP ("WinForgeISO_" + (Get-Random))
    $extract = Join-Path $work "extracted"
    $mountDir = Join-Path $work "mount"
    New-Item -Path $extract -ItemType Directory -Force | Out-Null
    New-Item -Path $mountDir -ItemType Directory -Force | Out-Null

    try {
        Write-Log "Mounting source ISO..." "#82C9FF"
        $img = Mount-DiskImage -ImagePath $SourceIsoPath -PassThru
        Start-Sleep -Seconds 2
        $driveLetter = ($img | Get-Volume).DriveLetter
        if (-not $driveLetter) { throw "Could not determine mounted drive letter." }
        $sourceRoot = "${driveLetter}:\"

        Write-Log "Copying ISO contents to working folder (this can take a few minutes)..."
        & robocopy $sourceRoot $extract /MIR /NFL /NDL /NJH /NJS | Out-Null

        Dismount-DiskImage -ImagePath $SourceIsoPath | Out-Null
        Write-Log "Source ISO unmounted."

        $wimPath = Join-Path $extract "sources\install.wim"
        $esdPath = Join-Path $extract "sources\install.esd"
        $imagePath = if (Test-Path $wimPath) { $wimPath } elseif (Test-Path $esdPath) { $esdPath } else { $null }

        if (-not $imagePath) {
            Write-Log "Could not find install.wim or install.esd in the ISO. Aborting image edits." "#FF7A7A"
        } else {
            # Files copied off a mounted ISO inherit the Read-only attribute, which
            # causes DISM to refuse to mount the image for read/write servicing.
            & attrib.exe -R $imagePath | Out-Null

            Write-Log "Mounting Windows image (index 1) for offline servicing..."
            Mount-WindowsImage -ImagePath $imagePath -Index 1 -Path $mountDir -ErrorAction Stop | Out-Null

            if ($RemoveBloatware) {
                Write-Log "Removing bloatware apps from the offline image..." "#82C9FF"
                foreach ($app in $BloatApps) {
                    try {
                        Get-AppxProvisionedPackage -Path $mountDir -ErrorAction SilentlyContinue |
                            Where-Object DisplayName -eq $app |
                            Remove-AppxProvisionedPackage -Path $mountDir -ErrorAction SilentlyContinue | Out-Null
                    } catch {}
                }
                Write-Log "Bloatware removal pass complete."
            }

            if ($DisableTelemetryInImage) {
                Write-Log "Disabling telemetry in the offline image..." "#82C9FF"
                try {
                    $hive = "HKLM\WinForgeOfflineSoftware"
                    $softwareHive = Join-Path $mountDir "Windows\System32\config\SOFTWARE"

                    # Right after Mount-WindowsImage returns, DISM's background
                    # process (TiWorker.exe) can briefly hold a lock on the offline
                    # hive files, so give reg.exe load a few attempts before giving up.
                    $hiveLoaded = $false
                    for ($attempt = 1; $attempt -le 5 -and -not $hiveLoaded; $attempt++) {
                        & reg.exe load $hive $softwareHive 2>&1 | Out-Null
                        if ($LASTEXITCODE -eq 0) {
                            $hiveLoaded = $true
                        } else {
                            Start-Sleep -Seconds 2
                        }
                    }

                    if (-not $hiveLoaded) {
                        Write-Log "Offline registry hive was still in use by DISM after several retries; skipping telemetry edit." "#FFB86B"
                    } else {
                        $policyPath = "HKLM:\WinForgeOfflineSoftware\Policies\Microsoft\Windows\DataCollection"
                        if (-not (Test-Path $policyPath)) { New-Item -Path $policyPath -Force | Out-Null }
                        New-ItemProperty -Path $policyPath -Name "AllowTelemetry" -Value 0 -PropertyType DWord -Force | Out-Null

                        # Release any lingering .NET registry handles before unloading,
                        # otherwise reg.exe unload can itself fail with "Access is denied".
                        [System.GC]::Collect()
                        [System.GC]::WaitForPendingFinalizers()
                        & reg.exe unload $hive | Out-Null
                        Write-Log "Telemetry policy applied to offline image."
                    }
                } catch {
                    Write-Log "Could not edit offline registry hive: $($_.Exception.Message)" "#FFB86B"
                }
            }

            Write-Log "Committing changes and unmounting image..."
            Dismount-WindowsImage -Path $mountDir -Save -ErrorAction Stop | Out-Null
            Write-Log "Offline image servicing complete." "#7CFC9C"
        }

        if ($SkipOOBE) {
            Write-Log "Writing unattended answer file (skips OOBE prompts)..."
            New-UnattendedAnswerFile -DestinationRoot $extract | Out-Null
        }

        $oscdimg = Find-Oscdimg -ManualPath $OscdimgPath
        if (-not $oscdimg) {
            Write-Log "oscdimg.exe not found (part of the Windows ADK Deployment Tools)." "#FFB86B"
            Write-Log "Your customized files are ready at: $extract" "#FFB86B"
            Write-Log "Install the Windows ADK, or use a tool like Rufus, to build a bootable ISO from that folder." "#FFB86B"
        } else {
            Write-Log "Building final ISO with oscdimg..." "#82C9FF"
            $bootData = "2#p0,e,b$extract\boot\etfsboot.com#pEF,e,b$extract\efi\microsoft\boot\efisys.bin"
            & $oscdimg -m -o -u2 -udfver102 -bootdata:$bootData $extract $OutputIsoPath | Out-Null
            if (Test-Path $OutputIsoPath) {
                Write-Log "Custom ISO created: $OutputIsoPath" "#7CFC9C"
            } else {
                Write-Log "oscdimg did not produce an output file. Check the working folder: $extract" "#FF7A7A"
            }
        }
    } catch {
        Write-Log "Custom ISO build failed: $($_.Exception.Message)" "#FF7A7A"
    }
}

# ---------------------------------------------------------------------------
# 8. XAML - Modern dark sidebar UI (4 sections + log)
# ---------------------------------------------------------------------------

[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="$AppTitle" Height="760" Width="1040"
        WindowStartupLocation="CenterScreen" ResizeMode="CanResize"
        Background="#0F1115" FontFamily="Segoe UI">
    <Window.Resources>
        <Style x:Key="NavButton" TargetType="RadioButton">
            <Setter Property="Foreground" Value="#9AA3AD"/>
            <Setter Property="FontSize" Value="14"/>
            <Setter Property="Padding" Value="18,12"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="RadioButton">
                        <Border x:Name="bd" Background="Transparent" CornerRadius="8" Margin="10,3">
                            <ContentPresenter HorizontalAlignment="Left" VerticalAlignment="Center" Margin="{TemplateBinding Padding}"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsChecked" Value="True">
                                <Setter TargetName="bd" Property="Background" Value="#1E2530"/>
                                <Setter Property="Foreground" Value="#4FD1C5"/>
                            </Trigger>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="bd" Property="Background" Value="#171C24"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <Style x:Key="ToggleSwitch" TargetType="CheckBox">
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="CheckBox">
                        <Grid>
                            <Border x:Name="track" Width="42" Height="22" CornerRadius="11" Background="#2A313C" HorizontalAlignment="Left"/>
                            <Ellipse x:Name="knob" Width="16" Height="16" Fill="White" HorizontalAlignment="Left" Margin="3,0,0,0"/>
                        </Grid>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsChecked" Value="True">
                                <Setter TargetName="track" Property="Background" Value="#4FD1C5"/>
                                <Setter TargetName="knob" Property="Margin" Value="23,0,0,0"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <Style x:Key="OptionRow" TargetType="Border">
            <Setter Property="Background" Value="#161A21"/>
            <Setter Property="CornerRadius" Value="10"/>
            <Setter Property="Padding" Value="16,12"/>
            <Setter Property="Margin" Value="0,0,0,8"/>
        </Style>

        <Style x:Key="OptionTitle" TargetType="TextBlock">
            <Setter Property="Foreground" Value="#E7EAEE"/>
            <Setter Property="FontSize" Value="14"/>
            <Setter Property="FontWeight" Value="SemiBold"/>
        </Style>

        <Style x:Key="OptionDesc" TargetType="TextBlock">
            <Setter Property="Foreground" Value="#8A93A0"/>
            <Setter Property="FontSize" Value="12"/>
            <Setter Property="TextWrapping" Value="Wrap"/>
        </Style>

        <Style x:Key="SectionHeader" TargetType="TextBlock">
            <Setter Property="Foreground" Value="#4FD1C5"/>
            <Setter Property="FontSize" Value="13"/>
            <Setter Property="FontWeight" Value="Bold"/>
            <Setter Property="Margin" Value="2,14,0,8"/>
        </Style>

        <Style x:Key="ActionButton" TargetType="Button">
            <Setter Property="Background" Value="#4FD1C5"/>
            <Setter Property="Foreground" Value="#0F1115"/>
            <Setter Property="FontWeight" Value="Bold"/>
            <Setter Property="FontSize" Value="14"/>
            <Setter Property="Padding" Value="20,10"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}" CornerRadius="8">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter Property="Background" Value="#6EE0D6"/>
                            </Trigger>
                            <Trigger Property="IsEnabled" Value="False">
                                <Setter Property="Background" Value="#333A44"/>
                                <Setter Property="Foreground" Value="#777"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <Style x:Key="SecondaryButton" TargetType="Button">
            <Setter Property="Background" Value="#1E2530"/>
            <Setter Property="Foreground" Value="#C7CDD6"/>
            <Setter Property="FontSize" Value="13"/>
            <Setter Property="Padding" Value="16,9"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Margin" Value="0,0,0,8"/>
            <Setter Property="HorizontalAlignment" Value="Left"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}" CornerRadius="8" Padding="{TemplateBinding Padding}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter Property="Background" Value="#272F3B"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <Style x:Key="RepairButton" TargetType="Button" BasedOn="{StaticResource SecondaryButton}">
            <Setter Property="HorizontalAlignment" Value="Stretch"/>
            <Setter Property="HorizontalContentAlignment" Value="Left"/>
        </Style>
    </Window.Resources>

    <Grid>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="230"/>
            <ColumnDefinition Width="*"/>
        </Grid.ColumnDefinitions>

        <!-- SIDEBAR -->
        <Border Grid.Column="0" Background="#12151B">
            <DockPanel LastChildFill="False">
                <StackPanel DockPanel.Dock="Top" Margin="18,22,18,20">
                    <Border Width="44" Height="44" CornerRadius="12" Background="#171C24" HorizontalAlignment="Left" Margin="0,0,0,10">
                        <Image x:Name="LogoImage" Width="28" Height="28" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                    </Border>
                    <TextBlock Text="$AppName" Foreground="White" FontSize="21" FontWeight="Bold"/>
                    <TextBlock Text="$AppTagline" Foreground="#4FD1C5" FontSize="11" FontWeight="SemiBold" Margin="0,1,0,0"/>
                    <TextBlock x:Name="OSLabelText" Text="Windows" Foreground="#6B7280" FontSize="11" Margin="0,8,0,0" TextWrapping="Wrap"/>
                </StackPanel>

                <StackPanel DockPanel.Dock="Top">
                    <RadioButton x:Name="NavSoftware"  Content="📦  Software Install" Style="{StaticResource NavButton}" GroupName="nav" IsChecked="True"/>
                    <RadioButton x:Name="NavOptimize"  Content="⚡  Optimize"          Style="{StaticResource NavButton}" GroupName="nav"/>
                    <RadioButton x:Name="NavRepair"    Content="🛠  System Repair"     Style="{StaticResource NavButton}" GroupName="nav"/>
                    <RadioButton x:Name="NavCustomize" Content="🎨  Customize"         Style="{StaticResource NavButton}" GroupName="nav"/>
                    <RadioButton x:Name="NavAdvanced"  Content="🧪  Advanced Tweaks"   Style="{StaticResource NavButton}" GroupName="nav"/>
                    <RadioButton x:Name="NavIso"       Content="💿  Custom ISO"        Style="{StaticResource NavButton}" GroupName="nav"/>
                    <RadioButton x:Name="NavLog"       Content="📜  Activity Log"      Style="{StaticResource NavButton}" GroupName="nav"/>
                </StackPanel>

                <StackPanel DockPanel.Dock="Bottom" Margin="18,0,18,20">
                    <TextBlock Text="Running as Administrator" Foreground="#4A5261" FontSize="10" HorizontalAlignment="Center"/>
                </StackPanel>
            </DockPanel>
        </Border>

        <!-- MAIN CONTENT -->
        <Grid Grid.Column="1" Margin="28,24,28,20">
            <Grid.RowDefinitions>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="*"/>
                <RowDefinition Height="Auto"/>
            </Grid.RowDefinitions>

            <StackPanel Grid.Row="0" Margin="0,0,0,18">
                <TextBlock x:Name="PageTitle" Text="Software Install" Foreground="White" FontSize="22" FontWeight="Bold"/>
                <TextBlock x:Name="PageSubtitle" Text="Install common apps in one pass." Foreground="#8A93A0" FontSize="12" Margin="0,2,0,0"/>
            </StackPanel>

            <Grid Grid.Row="1">

                <!-- PAGE: SOFTWARE -->
                <ScrollViewer x:Name="PageSoftware" VerticalScrollBarVisibility="Auto" Visibility="Visible">
                    <StackPanel x:Name="SoftwarePanel">
                        <!-- rows injected at runtime -->
                    </StackPanel>
                </ScrollViewer>

                <!-- PAGE: OPTIMIZE -->
                <ScrollViewer x:Name="PageOptimize" VerticalScrollBarVisibility="Auto" Visibility="Collapsed">
                    <StackPanel>
                        <TextBlock Text="GENERAL" Style="{StaticResource SectionHeader}"/>
                        <Border Style="{StaticResource OptionRow}">
                            <Grid><Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                <StackPanel Grid.Column="0">
                                    <TextBlock Text="Create System Restore point first" Style="{StaticResource OptionTitle}"/>
                                    <TextBlock Text="Strongly recommended — lets you roll back every change in one step." Style="{StaticResource OptionDesc}"/>
                                </StackPanel>
                                <CheckBox x:Name="ChkRestore" Grid.Column="1" Style="{StaticResource ToggleSwitch}" IsChecked="True" VerticalAlignment="Center"/>
                            </Grid>
                        </Border>

                        <TextBlock Text="DEBLOAT" Style="{StaticResource SectionHeader}"/>
                        <Border Style="{StaticResource OptionRow}">
                            <Grid><Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                <StackPanel Grid.Column="0">
                                    <TextBlock Text="Remove pre-installed bloatware" Style="{StaticResource OptionTitle}"/>
                                    <TextBlock Text="Xbox apps, 3D Viewer, Skype, Solitaire, Mixed Reality Portal, Teams (consumer), etc." Style="{StaticResource OptionDesc}"/>
                                </StackPanel>
                                <CheckBox x:Name="ChkBloatware" Grid.Column="1" Style="{StaticResource ToggleSwitch}" IsChecked="True" VerticalAlignment="Center"/>
                            </Grid>
                        </Border>
                        <Border Style="{StaticResource OptionRow}">
                            <Grid><Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                <StackPanel Grid.Column="0">
                                    <TextBlock Text="Remove startup bloat" Style="{StaticResource OptionTitle}"/>
                                    <TextBlock Text="Stops OneDrive, Spotify, Skype, Teams, etc. auto-launching at sign-in." Style="{StaticResource OptionDesc}"/>
                                </StackPanel>
                                <CheckBox x:Name="ChkStartup" Grid.Column="1" Style="{StaticResource ToggleSwitch}" IsChecked="True" VerticalAlignment="Center"/>
                            </Grid>
                        </Border>

                        <TextBlock Text="PRIVACY" Style="{StaticResource SectionHeader}"/>
                        <Border Style="{StaticResource OptionRow}">
                            <Grid><Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                <StackPanel Grid.Column="0">
                                    <TextBlock Text="Disable telemetry &amp; data collection" Style="{StaticResource OptionTitle}"/>
                                    <TextBlock Text="Turns off diagnostic data, advertising ID, and consumer feature suggestions." Style="{StaticResource OptionDesc}"/>
                                </StackPanel>
                                <CheckBox x:Name="ChkTelemetry" Grid.Column="1" Style="{StaticResource ToggleSwitch}" IsChecked="True" VerticalAlignment="Center"/>
                            </Grid>
                        </Border>
                        <Border Style="{StaticResource OptionRow}">
                            <Grid><Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                <StackPanel Grid.Column="0">
                                    <TextBlock Text="Disable Cortana &amp; web search" Style="{StaticResource OptionTitle}"/>
                                    <TextBlock Text="Removes Bing web results and Cortana integration from Start menu search." Style="{StaticResource OptionDesc}"/>
                                </StackPanel>
                                <CheckBox x:Name="ChkCortana" Grid.Column="1" Style="{StaticResource ToggleSwitch}" IsChecked="True" VerticalAlignment="Center"/>
                            </Grid>
                        </Border>

                        <TextBlock Text="SERVICES" Style="{StaticResource SectionHeader}"/>
                        <Border Style="{StaticResource OptionRow}">
                            <Grid><Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                <StackPanel Grid.Column="0">
                                    <TextBlock Text="Disable background services" Style="{StaticResource OptionTitle}"/>
                                    <TextBlock Text="Master switch — the services below only apply if this is on." Style="{StaticResource OptionDesc}"/>
                                </StackPanel>
                                <CheckBox x:Name="ChkServicesMaster" Grid.Column="1" Style="{StaticResource ToggleSwitch}" IsChecked="True" VerticalAlignment="Center"/>
                            </Grid>
                        </Border>
                        <StackPanel x:Name="ServicesPanel"/>

                        <TextBlock Text="PERFORMANCE" Style="{StaticResource SectionHeader}"/>
                        <Border Style="{StaticResource OptionRow}">
                            <Grid><Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                <StackPanel Grid.Column="0">
                                    <TextBlock Text="Best Performance visual effects" Style="{StaticResource OptionTitle}"/>
                                    <TextBlock Text="Turns off animations and transparency for a snappier feel." Style="{StaticResource OptionDesc}"/>
                                </StackPanel>
                                <CheckBox x:Name="ChkVisuals" Grid.Column="1" Style="{StaticResource ToggleSwitch}" IsChecked="True" VerticalAlignment="Center"/>
                            </Grid>
                        </Border>
                        <Border Style="{StaticResource OptionRow}">
                            <Grid><Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                <StackPanel Grid.Column="0">
                                    <TextBlock Text="High Performance power plan" Style="{StaticResource OptionTitle}"/>
                                    <TextBlock Text="Switches the active Windows power scheme to High Performance." Style="{StaticResource OptionDesc}"/>
                                </StackPanel>
                                <CheckBox x:Name="ChkPower" Grid.Column="1" Style="{StaticResource ToggleSwitch}" IsChecked="True" VerticalAlignment="Center"/>
                            </Grid>
                        </Border>
                        <Border Style="{StaticResource OptionRow}">
                            <Grid><Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                <StackPanel Grid.Column="0">
                                    <TextBlock Text="Clean temp files &amp; cache" Style="{StaticResource OptionTitle}"/>
                                    <TextBlock Text="Clears %TEMP%, Windows\Temp, and Prefetch to free up space." Style="{StaticResource OptionDesc}"/>
                                </StackPanel>
                                <CheckBox x:Name="ChkTemp" Grid.Column="1" Style="{StaticResource ToggleSwitch}" IsChecked="True" VerticalAlignment="Center"/>
                            </Grid>
                        </Border>
                        <Border Style="{StaticResource OptionRow}">
                            <Grid><Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                <StackPanel Grid.Column="0">
                                    <TextBlock Text="Network latency tweaks" Style="{StaticResource OptionTitle}"/>
                                    <TextBlock Text="Tunes TCP auto-tuning and RSS for smoother networking." Style="{StaticResource OptionDesc}"/>
                                </StackPanel>
                                <CheckBox x:Name="ChkNetwork" Grid.Column="1" Style="{StaticResource ToggleSwitch}" IsChecked="True" VerticalAlignment="Center"/>
                            </Grid>
                        </Border>

                        <Button x:Name="BtnApplyOptimize" Content="Apply Selected Optimizations" Style="{StaticResource ActionButton}" Margin="0,16,0,0" HorizontalAlignment="Left" Padding="24,12"/>
                    </StackPanel>
                </ScrollViewer>

                <!-- PAGE: SYSTEM REPAIR -->
                <ScrollViewer x:Name="PageRepair" VerticalScrollBarVisibility="Auto" Visibility="Collapsed">
                    <StackPanel>
                        <Border Style="{StaticResource OptionRow}" Background="#17202B">
                            <StackPanel>
                                <TextBlock Text="Full Repair Sequence" Style="{StaticResource OptionTitle}" FontSize="15"/>
                                <TextBlock Text="Runs SFC, DISM RestoreHealth, component cleanup, and a network reset back-to-back. Can take 20-30 minutes." Style="{StaticResource OptionDesc}" Margin="0,4,0,10"/>
                                <Button x:Name="BtnFullRepair" Content="Run Full Repair Sequence" Style="{StaticResource ActionButton}" HorizontalAlignment="Left" Padding="20,10"/>
                            </StackPanel>
                        </Border>

                        <TextBlock Text="INDIVIDUAL REPAIRS" Style="{StaticResource SectionHeader}"/>
                        <Button x:Name="BtnSFC" Style="{StaticResource RepairButton}">
                            <StackPanel Orientation="Vertical" HorizontalAlignment="Left">
                                <TextBlock Text="Run SFC Scan (sfc /scannow)" FontWeight="SemiBold"/>
                                <TextBlock Text="Checks and repairs corrupted system files." FontSize="11" Foreground="#8A93A0"/>
                            </StackPanel>
                        </Button>
                        <Button x:Name="BtnDISM" Style="{StaticResource RepairButton}">
                            <StackPanel Orientation="Vertical" HorizontalAlignment="Left">
                                <TextBlock Text="Run DISM RestoreHealth" FontWeight="SemiBold"/>
                                <TextBlock Text="Repairs the Windows component store (fixes many SFC failures)." FontSize="11" Foreground="#8A93A0"/>
                            </StackPanel>
                        </Button>
                        <Button x:Name="BtnComponentCleanup" Style="{StaticResource RepairButton}">
                            <StackPanel Orientation="Vertical" HorizontalAlignment="Left">
                                <TextBlock Text="Clean Up Component Store" FontWeight="SemiBold"/>
                                <TextBlock Text="Removes superseded update files to free disk space." FontSize="11" Foreground="#8A93A0"/>
                            </StackPanel>
                        </Button>
                        <Button x:Name="BtnResetWU" Style="{StaticResource RepairButton}">
                            <StackPanel Orientation="Vertical" HorizontalAlignment="Left">
                                <TextBlock Text="Reset Windows Update Components" FontWeight="SemiBold"/>
                                <TextBlock Text="Fixes stuck or failing Windows Update by resetting its cache and services." FontSize="11" Foreground="#8A93A0"/>
                            </StackPanel>
                        </Button>
                        <Button x:Name="BtnResetNetwork" Style="{StaticResource RepairButton}">
                            <StackPanel Orientation="Vertical" HorizontalAlignment="Left">
                                <TextBlock Text="Reset Network Stack" FontWeight="SemiBold"/>
                                <TextBlock Text="Resets Winsock, TCP/IP, and flushes DNS. Fixes many connectivity issues." FontSize="11" Foreground="#8A93A0"/>
                            </StackPanel>
                        </Button>
                        <Button x:Name="BtnCheckDisk" Style="{StaticResource RepairButton}">
                            <StackPanel Orientation="Vertical" HorizontalAlignment="Left">
                                <TextBlock Text="Schedule CHKDSK" FontWeight="SemiBold"/>
                                <TextBlock Text="Scans the system drive for errors and bad sectors on next restart." FontSize="11" Foreground="#8A93A0"/>
                            </StackPanel>
                        </Button>
                        <Button x:Name="BtnRebuildSearch" Style="{StaticResource RepairButton}">
                            <StackPanel Orientation="Vertical" HorizontalAlignment="Left">
                                <TextBlock Text="Rebuild Search Index" FontWeight="SemiBold"/>
                                <TextBlock Text="Clears and rebuilds the Windows Search index if search results are broken." FontSize="11" Foreground="#8A93A0"/>
                            </StackPanel>
                        </Button>
                    </StackPanel>
                </ScrollViewer>

                <!-- PAGE: CUSTOMIZE -->
                <ScrollViewer x:Name="PageCustomize" VerticalScrollBarVisibility="Auto" Visibility="Collapsed">
                    <StackPanel>
                        <TextBlock Text="APPEARANCE" Style="{StaticResource SectionHeader}"/>
                        <Border Style="{StaticResource OptionRow}">
                            <Grid><Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                <StackPanel Grid.Column="0">
                                    <TextBlock Text="Enable Dark Mode" Style="{StaticResource OptionTitle}"/>
                                    <TextBlock Text="Applies dark theme to apps and system UI." Style="{StaticResource OptionDesc}"/>
                                </StackPanel>
                                <CheckBox x:Name="ChkDarkMode" Grid.Column="1" Style="{StaticResource ToggleSwitch}" VerticalAlignment="Center"/>
                            </Grid>
                        </Border>
                        <Border Style="{StaticResource OptionRow}">
                            <Grid><Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                <StackPanel Grid.Column="0">
                                    <TextBlock Text="Align taskbar icons left (Windows 11)" Style="{StaticResource OptionTitle}"/>
                                    <TextBlock Text="Classic-style left alignment instead of centered icons." Style="{StaticResource OptionDesc}"/>
                                </StackPanel>
                                <CheckBox x:Name="ChkTaskbarLeft" Grid.Column="1" Style="{StaticResource ToggleSwitch}" VerticalAlignment="Center"/>
                            </Grid>
                        </Border>
                        <Border Style="{StaticResource OptionRow}">
                            <Grid><Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                <StackPanel Grid.Column="0">
                                    <TextBlock Text="Classic right-click context menu (Windows 11)" Style="{StaticResource OptionTitle}"/>
                                    <TextBlock Text="Restores the full Windows 10-style context menu instead of the trimmed one." Style="{StaticResource OptionDesc}"/>
                                </StackPanel>
                                <CheckBox x:Name="ChkClassicMenu" Grid.Column="1" Style="{StaticResource ToggleSwitch}" VerticalAlignment="Center"/>
                            </Grid>
                        </Border>
                        <Border Style="{StaticResource OptionRow}">
                            <Grid><Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                <StackPanel Grid.Column="0">
                                    <TextBlock Text="Disable Widgets (Windows 11)" Style="{StaticResource OptionTitle}"/>
                                    <TextBlock Text="Removes the Widgets icon and panel from the taskbar." Style="{StaticResource OptionDesc}"/>
                                </StackPanel>
                                <CheckBox x:Name="ChkWidgets" Grid.Column="1" Style="{StaticResource ToggleSwitch}" VerticalAlignment="Center"/>
                            </Grid>
                        </Border>
                        <Border Style="{StaticResource OptionRow}">
                            <Grid><Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                <StackPanel Grid.Column="0">
                                    <TextBlock Text="Disable Chat/Teams icon (Windows 11)" Style="{StaticResource OptionTitle}"/>
                                    <TextBlock Text="Removes the Chat icon from the taskbar." Style="{StaticResource OptionDesc}"/>
                                </StackPanel>
                                <CheckBox x:Name="ChkChatIcon" Grid.Column="1" Style="{StaticResource ToggleSwitch}" VerticalAlignment="Center"/>
                            </Grid>
                        </Border>

                        <TextBlock Text="FILE EXPLORER" Style="{StaticResource SectionHeader}"/>
                        <Border Style="{StaticResource OptionRow}">
                            <Grid><Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                <StackPanel Grid.Column="0">
                                    <TextBlock Text="Show file extensions" Style="{StaticResource OptionTitle}"/>
                                    <TextBlock Text="Displays file extensions (.txt, .exe, etc.) in File Explorer." Style="{StaticResource OptionDesc}"/>
                                </StackPanel>
                                <CheckBox x:Name="ChkFileExt" Grid.Column="1" Style="{StaticResource ToggleSwitch}" VerticalAlignment="Center"/>
                            </Grid>
                        </Border>
                        <Border Style="{StaticResource OptionRow}">
                            <Grid><Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                <StackPanel Grid.Column="0">
                                    <TextBlock Text="Show hidden files" Style="{StaticResource OptionTitle}"/>
                                    <TextBlock Text="Reveals hidden files and folders in File Explorer." Style="{StaticResource OptionDesc}"/>
                                </StackPanel>
                                <CheckBox x:Name="ChkHiddenFiles" Grid.Column="1" Style="{StaticResource ToggleSwitch}" VerticalAlignment="Center"/>
                            </Grid>
                        </Border>

                        <TextBlock Text="LOCK SCREEN" Style="{StaticResource SectionHeader}"/>
                        <Border Style="{StaticResource OptionRow}">
                            <Grid><Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                <StackPanel Grid.Column="0">
                                    <TextBlock Text="Disable lock screen tips &amp; suggestions" Style="{StaticResource OptionTitle}"/>
                                    <TextBlock Text="Removes promotional overlays from the lock screen." Style="{StaticResource OptionDesc}"/>
                                </StackPanel>
                                <CheckBox x:Name="ChkLockScreen" Grid.Column="1" Style="{StaticResource ToggleSwitch}" VerticalAlignment="Center"/>
                            </Grid>
                        </Border>

                        <Button x:Name="BtnApplyCustomize" Content="Apply Selected Customizations" Style="{StaticResource ActionButton}" Margin="0,16,0,0" HorizontalAlignment="Left" Padding="24,12"/>
                    </StackPanel>
                </ScrollViewer>

                <!-- PAGE: ADVANCED TWEAKS -->
                <ScrollViewer x:Name="PageAdvanced" VerticalScrollBarVisibility="Auto" Visibility="Collapsed">
                    <StackPanel>
                        <Border Style="{StaticResource OptionRow}" Background="#17202B">
                            <StackPanel>
                                <TextBlock Text="Safe for Windows 10 &amp; 11" Style="{StaticResource OptionTitle}" FontSize="15"/>
                                <TextBlock Text="Every tweak below uses documented, Microsoft-supported settings only. None of them touch Windows Update, Windows Defender, UAC, or boot configuration, and every change here can be switched back off the same way it was switched on. Windows 11-only tweaks are automatically skipped on Windows 10." Style="{StaticResource OptionDesc}" Margin="0,4,0,0"/>
                            </StackPanel>
                        </Border>

                        <TextBlock Text="SYSTEM" Style="{StaticResource SectionHeader}"/>
                        <Border Style="{StaticResource OptionRow}">
                            <Grid><Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                <StackPanel Grid.Column="0">
                                    <TextBlock Text="Enable NTFS long path support" Style="{StaticResource OptionTitle}"/>
                                    <TextBlock Text="Lets apps use file paths longer than 260 characters. Official Windows 10/11 feature, off by default." Style="{StaticResource OptionDesc}"/>
                                </StackPanel>
                                <CheckBox x:Name="ChkLongPaths" Grid.Column="1" Style="{StaticResource ToggleSwitch}" VerticalAlignment="Center"/>
                            </Grid>
                        </Border>
                        <Border Style="{StaticResource OptionRow}">
                            <Grid><Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                <StackPanel Grid.Column="0">
                                    <TextBlock Text="Show detailed boot/shutdown status messages" Style="{StaticResource OptionTitle}"/>
                                    <TextBlock Text="Shows what Windows is doing during sign-in, sign-out, and shutdown. Useful for diagnosing slow starts; purely informational." Style="{StaticResource OptionDesc}"/>
                                </StackPanel>
                                <CheckBox x:Name="ChkVerboseStatus" Grid.Column="1" Style="{StaticResource ToggleSwitch}" VerticalAlignment="Center"/>
                            </Grid>
                        </Border>
                        <Border Style="{StaticResource OptionRow}">
                            <Grid><Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                <StackPanel Grid.Column="0">
                                    <TextBlock Text="Disable Fast Startup" Style="{StaticResource OptionTitle}"/>
                                    <TextBlock Text="Turns off hybrid boot only (hibernation itself is untouched). Often fixes driver and dual-boot issues; fully reversible." Style="{StaticResource OptionDesc}"/>
                                </StackPanel>
                                <CheckBox x:Name="ChkFastStartup" Grid.Column="1" Style="{StaticResource ToggleSwitch}" VerticalAlignment="Center"/>
                            </Grid>
                        </Border>
                        <Border Style="{StaticResource OptionRow}">
                            <Grid><Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                <StackPanel Grid.Column="0">
                                    <TextBlock Text="Enable Storage Sense" Style="{StaticResource OptionTitle}"/>
                                    <TextBlock Text="Turns on Windows' built-in automatic disk cleanup for temp files and the recycle bin." Style="{StaticResource OptionDesc}"/>
                                </StackPanel>
                                <CheckBox x:Name="ChkStorageSense" Grid.Column="1" Style="{StaticResource ToggleSwitch}" VerticalAlignment="Center"/>
                            </Grid>
                        </Border>

                        <TextBlock Text="EXPLORER &amp; TASKBAR" Style="{StaticResource SectionHeader}"/>
                        <Border Style="{StaticResource OptionRow}">
                            <Grid><Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                <StackPanel Grid.Column="0">
                                    <TextBlock Text="Show seconds in the taskbar clock" Style="{StaticResource OptionTitle}"/>
                                    <TextBlock Text="Adds a seconds display to the system tray clock." Style="{StaticResource OptionDesc}"/>
                                </StackPanel>
                                <CheckBox x:Name="ChkClockSeconds" Grid.Column="1" Style="{StaticResource ToggleSwitch}" VerticalAlignment="Center"/>
                            </Grid>
                        </Border>
                        <Border Style="{StaticResource OptionRow}">
                            <Grid><Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                <StackPanel Grid.Column="0">
                                    <TextBlock Text="Speed up menu &amp; tooltip response" Style="{StaticResource OptionTitle}"/>
                                    <TextBlock Text="Reduces the delay before menus, tooltips, and Start submenus pop open." Style="{StaticResource OptionDesc}"/>
                                </StackPanel>
                                <CheckBox x:Name="ChkMenuDelay" Grid.Column="1" Style="{StaticResource ToggleSwitch}" VerticalAlignment="Center"/>
                            </Grid>
                        </Border>
                        <Border Style="{StaticResource OptionRow}">
                            <Grid><Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                <StackPanel Grid.Column="0">
                                    <TextBlock Text="Open File Explorer to 'This PC'" Style="{StaticResource OptionTitle}"/>
                                    <TextBlock Text="Explorer opens to This PC instead of Quick Access by default." Style="{StaticResource OptionDesc}"/>
                                </StackPanel>
                                <CheckBox x:Name="ChkExplorerThisPC" Grid.Column="1" Style="{StaticResource ToggleSwitch}" VerticalAlignment="Center"/>
                            </Grid>
                        </Border>
                        <Border Style="{StaticResource OptionRow}">
                            <Grid><Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                <StackPanel Grid.Column="0">
                                    <TextBlock Text="Increase icon cache size" Style="{StaticResource OptionTitle}"/>
                                    <TextBlock Text="Raises the cache limit so icons stop needing to be redrawn, which helps on folders with lots of files." Style="{StaticResource OptionDesc}"/>
                                </StackPanel>
                                <CheckBox x:Name="ChkIconCache" Grid.Column="1" Style="{StaticResource ToggleSwitch}" VerticalAlignment="Center"/>
                            </Grid>
                        </Border>
                        <Border Style="{StaticResource OptionRow}">
                            <Grid><Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                <StackPanel Grid.Column="0">
                                    <TextBlock Text="Restore 'End Task' in taskbar right-click (Windows 11)" Style="{StaticResource OptionTitle}"/>
                                    <TextBlock Text="Adds End Task back to the right-click menu when you click an app on the taskbar." Style="{StaticResource OptionDesc}"/>
                                </StackPanel>
                                <CheckBox x:Name="ChkTaskbarEndTask" Grid.Column="1" Style="{StaticResource ToggleSwitch}" VerticalAlignment="Center"/>
                            </Grid>
                        </Border>

                        <TextBlock Text="PRODUCTIVITY" Style="{StaticResource SectionHeader}"/>
                        <Border Style="{StaticResource OptionRow}">
                            <Grid><Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                <StackPanel Grid.Column="0">
                                    <TextBlock Text="Enable Clipboard History" Style="{StaticResource OptionTitle}"/>
                                    <TextBlock Text="Turns on Windows key + V clipboard history, a built-in Windows feature." Style="{StaticResource OptionDesc}"/>
                                </StackPanel>
                                <CheckBox x:Name="ChkClipboardHistory" Grid.Column="1" Style="{StaticResource ToggleSwitch}" VerticalAlignment="Center"/>
                            </Grid>
                        </Border>
                        <Border Style="{StaticResource OptionRow}">
                            <Grid><Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                <StackPanel Grid.Column="0">
                                    <TextBlock Text="Disable background apps" Style="{StaticResource OptionTitle}"/>
                                    <TextBlock Text="Stops Store apps from running, sending notifications, and staying updated in the background. Same switch as Settings &gt; Privacy &gt; Background apps; desktop apps and Windows Update are unaffected." Style="{StaticResource OptionDesc}"/>
                                </StackPanel>
                                <CheckBox x:Name="ChkBackgroundApps" Grid.Column="1" Style="{StaticResource ToggleSwitch}" VerticalAlignment="Center"/>
                            </Grid>
                        </Border>

                        <Button x:Name="BtnApplyAdvanced" Content="Apply Selected Advanced Tweaks" Style="{StaticResource ActionButton}" Margin="0,16,0,0" HorizontalAlignment="Left" Padding="24,12"/>
                    </StackPanel>
                </ScrollViewer>

                <!-- PAGE: CUSTOM ISO -->
                <ScrollViewer x:Name="PageIso" VerticalScrollBarVisibility="Auto" Visibility="Collapsed">
                    <StackPanel>
                        <Border Style="{StaticResource OptionRow}" Background="#17202B">
                            <StackPanel>
                                <TextBlock Text="Build a de-bloated, unattended Windows ISO" Style="{StaticResource OptionTitle}" FontSize="15"/>
                                <TextBlock Text="Uses DISM offline servicing on a copy of your source ISO. Requires the Windows ADK (oscdimg.exe) to produce a final bootable ISO — if it's not installed, you'll still get a fully edited folder you can turn into media with the ADK or a tool like Rufus." Style="{StaticResource OptionDesc}" Margin="0,4,0,0"/>
                            </StackPanel>
                        </Border>

                        <TextBlock Text="SOURCE &amp; OUTPUT" Style="{StaticResource SectionHeader}"/>
                        <Border Style="{StaticResource OptionRow}">
                            <StackPanel>
                                <TextBlock Text="Source Windows ISO (10 or 11)" Style="{StaticResource OptionTitle}"/>
                                <Grid Margin="0,8,0,0">
                                    <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                    <TextBox x:Name="TxtSourceIso" Grid.Column="0" Background="#0F1115" Foreground="#E7EAEE" BorderBrush="#2A313C" BorderThickness="1" Padding="8" IsReadOnly="True"/>
                                    <Button x:Name="BtnBrowseSourceIso" Grid.Column="1" Content="Browse..." Style="{StaticResource SecondaryButton}" Margin="8,0,0,0"/>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border Style="{StaticResource OptionRow}">
                            <StackPanel>
                                <TextBlock Text="Output ISO path" Style="{StaticResource OptionTitle}"/>
                                <Grid Margin="0,8,0,0">
                                    <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                    <TextBox x:Name="TxtOutputIso" Grid.Column="0" Background="#0F1115" Foreground="#E7EAEE" BorderBrush="#2A313C" BorderThickness="1" Padding="8" IsReadOnly="True"/>
                                    <Button x:Name="BtnBrowseOutputIso" Grid.Column="1" Content="Choose..." Style="{StaticResource SecondaryButton}" Margin="8,0,0,0"/>
                                </Grid>
                            </StackPanel>
                        </Border>

                        <TextBlock Text="IMAGE EDITS" Style="{StaticResource SectionHeader}"/>
                        <Border Style="{StaticResource OptionRow}">
                            <Grid><Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                <StackPanel Grid.Column="0">
                                    <TextBlock Text="Remove bloatware apps from the image" Style="{StaticResource OptionTitle}"/>
                                    <TextBlock Text="Strips the same Xbox/Skype/etc. apps as the Optimize section, offline, before install." Style="{StaticResource OptionDesc}"/>
                                </StackPanel>
                                <CheckBox x:Name="ChkIsoBloatware" Grid.Column="1" Style="{StaticResource ToggleSwitch}" IsChecked="True" VerticalAlignment="Center"/>
                            </Grid>
                        </Border>
                        <Border Style="{StaticResource OptionRow}">
                            <Grid><Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                <StackPanel Grid.Column="0">
                                    <TextBlock Text="Disable telemetry in the image" Style="{StaticResource OptionTitle}"/>
                                    <TextBlock Text="Sets the AllowTelemetry policy to 0 directly in the offline registry hive." Style="{StaticResource OptionDesc}"/>
                                </StackPanel>
                                <CheckBox x:Name="ChkIsoTelemetry" Grid.Column="1" Style="{StaticResource ToggleSwitch}" IsChecked="True" VerticalAlignment="Center"/>
                            </Grid>
                        </Border>
                        <Border Style="{StaticResource OptionRow}">
                            <Grid><Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                <StackPanel Grid.Column="0">
                                    <TextBlock Text="Skip OOBE prompts (unattended)" Style="{StaticResource OptionTitle}"/>
                                    <TextBlock Text="Adds an autounattend.xml that hides the EULA, online account, and privacy screens during setup." Style="{StaticResource OptionDesc}"/>
                                </StackPanel>
                                <CheckBox x:Name="ChkIsoOOBE" Grid.Column="1" Style="{StaticResource ToggleSwitch}" IsChecked="True" VerticalAlignment="Center"/>
                            </Grid>
                        </Border>

                        <TextBlock Text="ISO BUILDER (ADK)" Style="{StaticResource SectionHeader}"/>
                        <Border Style="{StaticResource OptionRow}">
                            <StackPanel>
                                <TextBlock Text="oscdimg.exe location" Style="{StaticResource OptionTitle}"/>
                                <TextBlock Text="Auto-detected from your Windows ADK install. If it's blank, browse to it manually — it's normally under 'Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg\oscdimg.exe'." Style="{StaticResource OptionDesc}"/>
                                <Grid Margin="0,8,0,0">
                                    <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                    <TextBox x:Name="TxtOscdimgPath" Grid.Column="0" Background="#0F1115" Foreground="#E7EAEE" BorderBrush="#2A313C" BorderThickness="1" Padding="8" IsReadOnly="True"/>
                                    <Button x:Name="BtnBrowseOscdimg" Grid.Column="1" Content="Browse..." Style="{StaticResource SecondaryButton}" Margin="8,0,0,0"/>
                                </Grid>
                                <Grid Margin="0,8,0,0">
                                    <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                                    <TextBlock Grid.Column="0" Text="Don't have it? WinForge can fetch the ADK Deployment Tools (contains oscdimg.exe) for you via winget." Style="{StaticResource OptionDesc}" VerticalAlignment="Center" TextWrapping="Wrap"/>
                                    <Button x:Name="BtnDownloadOscdimg" Grid.Column="1" Content="Download oscdimg.exe" Style="{StaticResource SecondaryButton}" Margin="8,0,0,0"/>
                                </Grid>
                            </StackPanel>
                        </Border>

                        <Button x:Name="BtnBuildIso" Content="Build Custom ISO" Style="{StaticResource ActionButton}" Margin="0,16,0,0" HorizontalAlignment="Left" Padding="24,12"/>
                    </StackPanel>
                </ScrollViewer>

                <!-- PAGE: LOG -->
                <Border x:Name="PageLog" Background="#0B0D11" CornerRadius="10" Visibility="Collapsed">
                    <RichTextBox x:Name="LogBox" Background="Transparent" Foreground="#B5E8B0" BorderThickness="0"
                                 FontFamily="Consolas" FontSize="12" IsReadOnly="True" VerticalScrollBarVisibility="Auto" Padding="14"/>
                </Border>
            </Grid>

            <!-- Bottom bar -->
            <Grid Grid.Row="2" Margin="0,18,0,0">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="Auto"/>
                    <ColumnDefinition Width="Auto"/>
                    <ColumnDefinition Width="Auto"/>
                </Grid.ColumnDefinitions>
                <TextBlock x:Name="StatusText" Grid.Column="0" Text="Ready." Foreground="#6B7280" VerticalAlignment="Center" FontSize="12"/>
                <Button x:Name="BtnViewLog" Grid.Column="1" Content="View Log" Style="{StaticResource SecondaryButton}" Margin="0,0,10,0"/>
                <Button x:Name="BtnUninstallSoftware" Grid.Column="2" Content="Uninstall Selected Software" Style="{StaticResource SecondaryButton}" Margin="0,0,10,0"/>
                <Button x:Name="BtnInstallSoftware" Grid.Column="3" Content="Install Selected Software" Style="{StaticResource ActionButton}"/>
            </Grid>
        </Grid>
    </Grid>
</Window>
"@

# ---------------------------------------------------------------------------
# 9. Load the window and wire up controls
# ---------------------------------------------------------------------------

$reader = New-Object System.Xml.XmlNodeReader $xaml
$Window = [Windows.Markup.XamlReader]::Load($reader)

$names = @(
    "NavSoftware","NavOptimize","NavRepair","NavCustomize","NavAdvanced","NavIso","NavLog",
    "PageSoftware","PageOptimize","PageRepair","PageCustomize","PageAdvanced","PageIso","PageLog",
    "PageTitle","PageSubtitle","OSLabelText","LogoImage",
    "SoftwarePanel","BtnInstallSoftware","BtnUninstallSoftware",
    "ChkRestore","ChkBloatware","ChkStartup","ChkTelemetry","ChkCortana",
    "ChkServicesMaster","ServicesPanel","ChkVisuals","ChkPower","ChkTemp","ChkNetwork","BtnApplyOptimize",
    "BtnFullRepair","BtnSFC","BtnDISM","BtnComponentCleanup","BtnResetWU","BtnResetNetwork","BtnCheckDisk","BtnRebuildSearch",
    "ChkDarkMode","ChkTaskbarLeft","ChkClassicMenu","ChkWidgets","ChkChatIcon","ChkFileExt","ChkHiddenFiles","ChkLockScreen","BtnApplyCustomize",
    "ChkLongPaths","ChkVerboseStatus","ChkFastStartup","ChkStorageSense","ChkClockSeconds","ChkMenuDelay","ChkExplorerThisPC","ChkIconCache","ChkTaskbarEndTask","ChkClipboardHistory","ChkBackgroundApps","BtnApplyAdvanced",
    "TxtSourceIso","BtnBrowseSourceIso","TxtOutputIso","BtnBrowseOutputIso","ChkIsoBloatware","ChkIsoTelemetry","ChkIsoOOBE","TxtOscdimgPath","BtnBrowseOscdimg","BtnDownloadOscdimg","BtnBuildIso",
    "LogBox","BtnViewLog","StatusText"
)
$ctrl = @{}
foreach ($n in $names) { $ctrl[$n] = $Window.FindName($n) }

$ctrl["OSLabelText"].Text = "Detected: $OSLabel"

# Try to auto-fill the oscdimg.exe path so Custom ISO builds work out of the box
try {
    $autoOscdimg = Find-Oscdimg
    if ($autoOscdimg) { $ctrl["TxtOscdimgPath"].Text = $autoOscdimg }
} catch {}

# --- Load embedded icon (used for window/taskbar icon + sidebar logo) ---
try {
    $iconBytes = [Convert]::FromBase64String($IconBase64)
    $iconStream = New-Object System.IO.MemoryStream(,$iconBytes)
    $iconDecoder = New-Object System.Windows.Media.Imaging.IconBitmapDecoder(
        $iconStream,
        [System.Windows.Media.Imaging.BitmapCreateOptions]::PreservePixelFormat,
        [System.Windows.Media.Imaging.BitmapCacheOption]::OnLoad
    )
    $bestFrame = $iconDecoder.Frames | Sort-Object -Property { $_.PixelWidth } -Descending | Select-Object -First 1
    $Window.Icon = $bestFrame
    $ctrl["LogoImage"].Source = $bestFrame
} catch {
    # Non-fatal: app still runs fine without a custom icon
}

$script:LogViewer = $ctrl["LogBox"]
$script:LogParagraph = New-Object System.Windows.Documents.Paragraph
$ctrl["LogBox"].Document = New-Object System.Windows.Documents.FlowDocument($script:LogParagraph)

# --- Build software rows dynamically ---
$swCheckboxes = @{}
foreach ($sw in $SoftwareCatalog) {
    $border = New-Object System.Windows.Controls.Border
    $border.Style = $Window.FindResource("OptionRow")
    $grid = New-Object System.Windows.Controls.Grid
    $col1 = New-Object System.Windows.Controls.ColumnDefinition; $col1.Width = "*"
    $col2 = New-Object System.Windows.Controls.ColumnDefinition; $col2.Width = "Auto"
    $grid.ColumnDefinitions.Add($col1); $grid.ColumnDefinitions.Add($col2)

    $stack = New-Object System.Windows.Controls.StackPanel
    $title = New-Object System.Windows.Controls.TextBlock
    $title.Text = $sw.Label; $title.Style = $Window.FindResource("OptionTitle")
    $desc = New-Object System.Windows.Controls.TextBlock
    $desc.Text = $sw.Desc; $desc.Style = $Window.FindResource("OptionDesc")
    $stack.Children.Add($title) | Out-Null
    $stack.Children.Add($desc) | Out-Null
    [System.Windows.Controls.Grid]::SetColumn($stack, 0)

    $chk = New-Object System.Windows.Controls.CheckBox
    $chk.Style = $Window.FindResource("ToggleSwitch")
    $chk.VerticalAlignment = "Center"
    [System.Windows.Controls.Grid]::SetColumn($chk, 1)

    $grid.Children.Add($stack) | Out-Null
    $grid.Children.Add($chk) | Out-Null
    $border.Child = $grid
    $ctrl["SoftwarePanel"].Children.Add($border) | Out-Null
    $swCheckboxes[$sw.Id] = $chk
}

# --- Build service rows dynamically ---
$svcCheckboxes = @{}
foreach ($svc in $ServicesToDisable) {
    $border = New-Object System.Windows.Controls.Border
    $border.Style = $Window.FindResource("OptionRow")
    $grid = New-Object System.Windows.Controls.Grid
    $col1 = New-Object System.Windows.Controls.ColumnDefinition; $col1.Width = "*"
    $col2 = New-Object System.Windows.Controls.ColumnDefinition; $col2.Width = "Auto"
    $grid.ColumnDefinitions.Add($col1); $grid.ColumnDefinitions.Add($col2)

    $title = New-Object System.Windows.Controls.TextBlock
    $title.Text = $svc.Label; $title.Style = $Window.FindResource("OptionTitle")
    [System.Windows.Controls.Grid]::SetColumn($title, 0)

    $chk = New-Object System.Windows.Controls.CheckBox
    $chk.Style = $Window.FindResource("ToggleSwitch")
    $chk.IsChecked = $true
    $chk.VerticalAlignment = "Center"
    [System.Windows.Controls.Grid]::SetColumn($chk, 1)

    $grid.Children.Add($title) | Out-Null
    $grid.Children.Add($chk) | Out-Null
    $border.Child = $grid
    $ctrl["ServicesPanel"].Children.Add($border) | Out-Null
    $svcCheckboxes[$svc.Name] = $chk
}

# --- Sidebar navigation ---
$pages = @{
    "NavSoftware"  = @{Page=$ctrl["PageSoftware"];  Title="Software Install"; Sub="Install common apps via winget in one pass."}
    "NavOptimize"  = @{Page=$ctrl["PageOptimize"];  Title="Optimize";         Sub="Debloat, privacy, services, and performance tweaks."}
    "NavRepair"    = @{Page=$ctrl["PageRepair"];    Title="System Repair";    Sub="Fix corrupted files, broken updates, and network issues."}
    "NavCustomize" = @{Page=$ctrl["PageCustomize"]; Title="Customize";        Sub="Windows 10 & 11 UI/UX tweaks."}
    "NavAdvanced"  = @{Page=$ctrl["PageAdvanced"];  Title="Advanced Tweaks";  Sub="Deeper, still-safe tweaks that won't break Windows Update or system functionality."}
    "NavIso"       = @{Page=$ctrl["PageIso"];       Title="Custom ISO";       Sub="Build a de-bloated, unattended Windows install image."}
    "NavLog"       = @{Page=$ctrl["PageLog"];       Title="Activity Log";     Sub="Everything the app has done this session."}
}
function Show-Page($navName) {
    foreach ($k in $pages.Keys) { $pages[$k].Page.Visibility = "Collapsed" }
    $pages[$navName].Page.Visibility = "Visible"
    $ctrl["PageTitle"].Text = $pages[$navName].Title
    $ctrl["PageSubtitle"].Text = $pages[$navName].Sub
}
foreach ($navName in $pages.Keys) {
    $ctrl[$navName].Add_Checked({ Show-Page $this.Name }.GetNewClosure())
}
$ctrl["BtnViewLog"].Add_Click({ $ctrl["NavLog"].IsChecked = $true })

# --- Install Software ---
$ctrl["BtnInstallSoftware"].Add_Click({
    $ctrl["NavLog"].IsChecked = $true
    $selected = $swCheckboxes.Keys | Where-Object { $swCheckboxes[$_].IsChecked }
    if (-not $selected -or $selected.Count -eq 0) {
        Write-Log "No software selected. Check some apps on the Software page first." "#FFB86B"
        return
    }
    $ctrl["StatusText"].Text = "Installing software..."
    Install-SelectedSoftware -PackageIds $selected
    $ctrl["StatusText"].Text = "Software installation finished."
})
$ctrl["BtnUninstallSoftware"].Add_Click({
    $ctrl["NavLog"].IsChecked = $true
    $selected = $swCheckboxes.Keys | Where-Object { $swCheckboxes[$_].IsChecked }
    if (-not $selected -or $selected.Count -eq 0) {
        Write-Log "No software selected. Check some apps on the Software page first." "#FFB86B"
        return
    }
    $ctrl["StatusText"].Text = "Uninstalling software..."
    Uninstall-SelectedSoftware -PackageIds $selected
    $ctrl["StatusText"].Text = "Software uninstallation finished."
})

# --- Apply Optimize ---
$ctrl["BtnApplyOptimize"].Add_Click({
    $ctrl["NavLog"].IsChecked = $true
    $ctrl["StatusText"].Text = "Applying optimizations..."
    Write-Log "Starting Optimize pass..." "#4FD1C5"

    if ($ctrl["ChkRestore"].IsChecked)   { New-RestorePoint }
    if ($ctrl["ChkBloatware"].IsChecked) { Remove-Bloatware }
    if ($ctrl["ChkTelemetry"].IsChecked) { Disable-Telemetry }
    if ($ctrl["ChkServicesMaster"].IsChecked) {
        $selected = $svcCheckboxes.Keys | Where-Object { $svcCheckboxes[$_].IsChecked }
        Disable-SelectedServices -ServiceNames $selected
    }
    if ($ctrl["ChkVisuals"].IsChecked)  { Optimize-VisualEffects }
    if ($ctrl["ChkPower"].IsChecked)    { Set-HighPerformancePower }
    if ($ctrl["ChkStartup"].IsChecked)  { Disable-StartupBloat }
    if ($ctrl["ChkTemp"].IsChecked)     { Clear-TempFiles }
    if ($ctrl["ChkCortana"].IsChecked)  { Disable-CortanaWebSearch }
    if ($ctrl["ChkNetwork"].IsChecked)  { Optimize-Network }

    Write-Log "=== Optimize pass complete. Restart recommended. ===" "#4FD1C5"
    $ctrl["StatusText"].Text = "Optimizations applied."
    [System.Windows.MessageBox]::Show("Optimizations applied. Please restart your PC.", $AppName, "OK", "Information") | Out-Null
})

# --- System Repair buttons (individual + full sequence) ---
$ctrl["BtnFullRepair"].Add_Click({
    $ctrl["NavLog"].IsChecked = $true
    Start-BackgroundRepairTask -Label "Full Repair Sequence" -ButtonsToDisable @($ctrl["BtnFullRepair"]) -Work {
        & sfc.exe /scannow 2>&1
        & DISM.exe /Online /Cleanup-Image /RestoreHealth 2>&1
        & DISM.exe /Online /Cleanup-Image /StartComponentCleanup 2>&1
        netsh winsock reset 2>&1
        netsh int ip reset 2>&1
        ipconfig /flushdns 2>&1
        "Full repair sequence finished. Restart recommended."
    }
})
$ctrl["BtnSFC"].Add_Click({
    $ctrl["NavLog"].IsChecked = $true
    Start-BackgroundRepairTask -Label "SFC Scan" -ButtonsToDisable @($ctrl["BtnSFC"]) -Work {
        & sfc.exe /scannow 2>&1
    }
})
$ctrl["BtnDISM"].Add_Click({
    $ctrl["NavLog"].IsChecked = $true
    Start-BackgroundRepairTask -Label "DISM RestoreHealth" -ButtonsToDisable @($ctrl["BtnDISM"]) -Work {
        & DISM.exe /Online /Cleanup-Image /RestoreHealth 2>&1
    }
})
$ctrl["BtnComponentCleanup"].Add_Click({
    $ctrl["NavLog"].IsChecked = $true
    Start-BackgroundRepairTask -Label "Component Store Cleanup" -ButtonsToDisable @($ctrl["BtnComponentCleanup"]) -Work {
        & DISM.exe /Online /Cleanup-Image /StartComponentCleanup 2>&1
    }
})
$ctrl["BtnResetWU"].Add_Click({
    $ctrl["NavLog"].IsChecked = $true
    Start-BackgroundRepairTask -Label "Windows Update Reset" -ButtonsToDisable @($ctrl["BtnResetWU"]) -Work {
        $services = @("wuauserv","cryptSvc","bits","msiserver")
        foreach ($s in $services) { Stop-Service -Name $s -Force -ErrorAction SilentlyContinue }
        $sd = "$env:windir\SoftwareDistribution"
        $cr = "$env:windir\System32\catroot2"
        if (Test-Path $sd) { Rename-Item -Path $sd -NewName "SoftwareDistribution.bak" -Force -ErrorAction SilentlyContinue; "Renamed SoftwareDistribution folder." }
        if (Test-Path $cr) { Rename-Item -Path $cr -NewName "catroot2.bak" -Force -ErrorAction SilentlyContinue; "Renamed catroot2 folder." }
        foreach ($s in $services) { Start-Service -Name $s -ErrorAction SilentlyContinue }
        "Windows Update components reset. Try Windows Update again."
    }
})
$ctrl["BtnResetNetwork"].Add_Click({
    $ctrl["NavLog"].IsChecked = $true
    Start-BackgroundRepairTask -Label "Network Stack Reset" -ButtonsToDisable @($ctrl["BtnResetNetwork"]) -Work {
        netsh winsock reset 2>&1
        netsh int ip reset 2>&1
        ipconfig /flushdns 2>&1
        ipconfig /release 2>&1
        ipconfig /renew 2>&1
        "Network stack reset complete. A restart is required for winsock/TCP-IP reset to fully apply."
    }
})
$ctrl["BtnCheckDisk"].Add_Click({
    $ctrl["NavLog"].IsChecked = $true
    Start-BackgroundRepairTask -Label "CHKDSK Scheduling" -ButtonsToDisable @($ctrl["BtnCheckDisk"]) -Work {
        cmd.exe /c "echo Y| chkdsk C: /f /r" 2>&1
        "CHKDSK scheduled. It will run automatically on your next restart."
    }
})
$ctrl["BtnRebuildSearch"].Add_Click({
    $ctrl["NavLog"].IsChecked = $true
    Start-BackgroundRepairTask -Label "Search Index Rebuild" -ButtonsToDisable @($ctrl["BtnRebuildSearch"]) -Work {
        Stop-Service WSearch -Force -ErrorAction SilentlyContinue
        $indexPath = "$env:ProgramData\Microsoft\Search\Data"
        if (Test-Path $indexPath) {
            Remove-Item -Path $indexPath -Recurse -Force -ErrorAction SilentlyContinue
            "Old search index cleared."
        }
        Start-Service WSearch -ErrorAction SilentlyContinue
        "Search index rebuild triggered (this happens gradually in the background)."
    }
})

# --- Apply Customize ---
$ctrl["BtnApplyCustomize"].Add_Click({
    $ctrl["NavLog"].IsChecked = $true
    Write-Log "Starting Customize pass..." "#4FD1C5"
    $needsExplorerRestart = $false

    if ($ctrl["ChkDarkMode"].IsChecked)     { Set-DarkMode; $needsExplorerRestart = $true }
    if ($ctrl["ChkTaskbarLeft"].IsChecked)  { Set-TaskbarAlignLeft; $needsExplorerRestart = $true }
    if ($ctrl["ChkClassicMenu"].IsChecked)  { Enable-ClassicContextMenu; $needsExplorerRestart = $true }
    if ($ctrl["ChkWidgets"].IsChecked)      { Disable-Widgets; $needsExplorerRestart = $true }
    if ($ctrl["ChkChatIcon"].IsChecked)     { Disable-ChatIcon; $needsExplorerRestart = $true }
    if ($ctrl["ChkFileExt"].IsChecked)      { Show-FileExtensions; $needsExplorerRestart = $true }
    if ($ctrl["ChkHiddenFiles"].IsChecked)  { Show-HiddenFiles; $needsExplorerRestart = $true }
    if ($ctrl["ChkLockScreen"].IsChecked)   { Disable-LockScreenTips }

    if ($needsExplorerRestart) { Restart-Explorer }

    Write-Log "=== Customize pass complete. ===" "#4FD1C5"
    $ctrl["StatusText"].Text = "Customizations applied."
})

# --- Apply Advanced Tweaks ---
$ctrl["BtnApplyAdvanced"].Add_Click({
    $ctrl["NavLog"].IsChecked = $true
    Write-Log "Starting Advanced Tweaks pass..." "#4FD1C5"
    $needsExplorerRestart = $false

    if ($ctrl["ChkLongPaths"].IsChecked)        { Enable-LongPaths }
    if ($ctrl["ChkVerboseStatus"].IsChecked)    { Enable-VerboseStatusMessages }
    if ($ctrl["ChkFastStartup"].IsChecked)      { Disable-FastStartup }
    if ($ctrl["ChkStorageSense"].IsChecked)     { Enable-StorageSense }
    if ($ctrl["ChkClockSeconds"].IsChecked)     { Set-ClockSeconds; $needsExplorerRestart = $true }
    if ($ctrl["ChkMenuDelay"].IsChecked)        { Set-FastMenuResponse }
    if ($ctrl["ChkExplorerThisPC"].IsChecked)   { Set-ExplorerOpenToThisPC; $needsExplorerRestart = $true }
    if ($ctrl["ChkIconCache"].IsChecked)        { Increase-IconCacheSize; $needsExplorerRestart = $true }
    if ($ctrl["ChkTaskbarEndTask"].IsChecked)   { Enable-TaskbarEndTask; $needsExplorerRestart = $true }
    if ($ctrl["ChkClipboardHistory"].IsChecked) { Enable-ClipboardHistory }
    if ($ctrl["ChkBackgroundApps"].IsChecked)   { Disable-BackgroundApps }

    if ($needsExplorerRestart) { Restart-Explorer }

    Write-Log "=== Advanced Tweaks pass complete. Windows Update and system functionality are unaffected. ===" "#4FD1C5"
    $ctrl["StatusText"].Text = "Advanced tweaks applied."
})

# --- Custom ISO: browse & build ---
$ctrl["BtnBrowseSourceIso"].Add_Click({
    $dlg = New-Object Microsoft.Win32.OpenFileDialog
    $dlg.Filter = "ISO images (*.iso)|*.iso"
    $dlg.Title = "Select source Windows ISO"
    if ($dlg.ShowDialog()) { $ctrl["TxtSourceIso"].Text = $dlg.FileName }
})
$ctrl["BtnBrowseOutputIso"].Add_Click({
    $dlg = New-Object Microsoft.Win32.SaveFileDialog
    $dlg.Filter = "ISO images (*.iso)|*.iso"
    $dlg.Title = "Choose output ISO path"
    $dlg.FileName = "Custom.iso"
    if ($dlg.ShowDialog()) { $ctrl["TxtOutputIso"].Text = $dlg.FileName }
})
$ctrl["BtnBrowseOscdimg"].Add_Click({
    $dlg = New-Object Microsoft.Win32.OpenFileDialog
    $dlg.Filter = "oscdimg.exe|oscdimg.exe|Executable (*.exe)|*.exe"
    $dlg.Title = "Locate oscdimg.exe (from the Windows ADK Deployment Tools)"
    if ($dlg.ShowDialog()) { $ctrl["TxtOscdimgPath"].Text = $dlg.FileName }
})
$ctrl["BtnDownloadOscdimg"].Add_Click({
    $ctrl["NavLog"].IsChecked = $true
    $existing = Find-Oscdimg
    if ($existing) {
        Write-Log "oscdimg.exe is already available at: $existing" "#7CFC9C"
        $ctrl["TxtOscdimgPath"].Text = $existing
        return
    }
    if (-not (Test-Winget)) {
        Write-Log "winget (App Installer) was not found, so oscdimg.exe can't be fetched automatically. Install 'App Installer' from the Microsoft Store, or install the Windows ADK Deployment Tools manually, then Browse to oscdimg.exe." "#FF7A7A"
        return
    }

    Write-Log "=== Downloading Windows ADK Deployment Tools (contains oscdimg.exe) via winget ===" "#82C9FF"
    Write-Log "Only the Deployment Tools feature is requested, not the full ADK. This can take a few minutes depending on your connection." "#B5BAC1"
    $ctrl["StatusText"].Text = "Downloading Windows ADK Deployment Tools..."
    $ctrl["BtnDownloadOscdimg"].IsEnabled = $false

    $job = Start-Job -ScriptBlock {
        winget install -e --id Microsoft.WindowsADK --source winget --silent --accept-source-agreements --accept-package-agreements --override "/quiet /features OptionId.DeploymentTools /norestart" 2>&1
    }

    $timer = New-Object System.Windows.Threading.DispatcherTimer
    $timer.Interval = [TimeSpan]::FromMilliseconds(800)
    $timer.Add_Tick({
        $lines = Receive-Job -Job $job -ErrorAction SilentlyContinue
        foreach ($line in $lines) {
            if ($line -and "$line".Trim().Length -gt 0) { Write-Log "$line" }
        }
        if ($job.State -in @('Completed','Failed','Stopped')) {
            $timer.Stop()
            $final = Receive-Job -Job $job -ErrorAction SilentlyContinue
            foreach ($line in $final) {
                if ($line -and "$line".Trim().Length -gt 0) { Write-Log "$line" }
            }
            Remove-Job -Job $job -Force -ErrorAction SilentlyContinue

            # Now that the install has actually finished, look for oscdimg.exe.
            $found = Find-Oscdimg
            if ($found) {
                $ctrl["TxtOscdimgPath"].Text = $found
                Write-Log "oscdimg.exe installed and found at: $found" "#7CFC9C"
            } else {
                Write-Log "The Deployment Tools install finished but oscdimg.exe still wasn't found. Browse to it manually if you know where it is, or try installing the Windows ADK Deployment Tools yourself." "#FFB86B"
            }
            $ctrl["StatusText"].Text = "ADK download finished."
            $ctrl["BtnDownloadOscdimg"].IsEnabled = $true
        }
    }.GetNewClosure())
    $timer.Start()
})
$ctrl["BtnBuildIso"].Add_Click({
    $ctrl["NavLog"].IsChecked = $true
    if ([string]::IsNullOrWhiteSpace($ctrl["TxtSourceIso"].Text) -or [string]::IsNullOrWhiteSpace($ctrl["TxtOutputIso"].Text)) {
        Write-Log "Pick both a source ISO and an output path before building." "#FFB86B"
        return
    }
    if ([string]::IsNullOrWhiteSpace($ctrl["TxtOscdimgPath"].Text)) {
        Write-Log "oscdimg.exe wasn't found automatically. Click Browse next to 'oscdimg.exe location' and point to it (install the Windows ADK Deployment Tools if you don't have it), then try again." "#FFB86B"
        return
    }
    $ctrl["StatusText"].Text = "Building custom ISO... this can take several minutes."
    $ctrl["BtnBuildIso"].IsEnabled = $false
    Write-Log "=== Starting Custom ISO build ===" "#4FD1C5"
    New-CustomWindowsISO -SourceIsoPath $ctrl["TxtSourceIso"].Text -OutputIsoPath $ctrl["TxtOutputIso"].Text `
        -RemoveBloatware $ctrl["ChkIsoBloatware"].IsChecked -DisableTelemetryInImage $ctrl["ChkIsoTelemetry"].IsChecked -SkipOOBE $ctrl["ChkIsoOOBE"].IsChecked `
        -OscdimgPath $ctrl["TxtOscdimgPath"].Text
    Write-Log "=== Custom ISO build finished. ===" "#4FD1C5"
    $ctrl["StatusText"].Text = "Custom ISO build finished."
    $ctrl["BtnBuildIso"].IsEnabled = $true
})

Show-Page "NavSoftware"
[void]$Window.ShowDialog()
