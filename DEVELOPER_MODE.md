# Safe Exam Browser / Faurus — Developer Mode & Lockdown Overrides

This document details all security, kiosk, and anti-cheat mechanisms that have been conditionally modified with `#if DEBUG` preprocessor macros.

---

## Quick Reference: Debug (Dev) vs. Release (Production Exam)

| Lockdown Feature | Debug Build (`DEBUG=1`) | Release Build (Production Exam) | Source File & Function Reference |
| :--- | :--- | :--- | :--- |
| **App Force-Quits** | **Disabled** (IDE, Terminal, Browser, Docker remain running) | **Enabled** (Terminates all unauthorized processes) | [`NSRunningApplication+SEB.m`](Classes/Categories/NSRunningApplication+SEB.m): `killProcessWithPID:error:`, `killApplicationWithBundleIdentifier:`, `kill`<br>[`ProcessManager.m`](Classes/ProcessMonitoring/ProcessManager.m): `updateMonitoredProcesses`<br>[`SEBController.m`](Classes/SEBController.m): `terminateApplications:...` |
| **Screenshots & Capture** | **Allowed** (`Cmd+Shift+3/4/5` and screen capture work without blackout) | **Blocked** (Windows blacked out via `NSWindowSharingNone`, shortcuts blocked) | [`SEBOSXBrowserController.m`](Classes/BrowserComponents/SEBOSXBrowserController.m): `setSharingType:`<br>[`SEBSystemManager.m`](Classes/SystemManager/SEBSystemManager.m): `preventScreenCapture` |
| **Dock & Menu Bar** | **Visible** (`NSApplicationPresentationDefault`) | **Hidden** (`NSApplicationPresentationHideDock` + `HideMenuBar`) | [`SEBController.m`](Classes/SEBController.m): `startKioskModeThirdPartyAppsAllowed:overrideShowMenuBar:` |
| **App Switching (`Cmd+Tab`)** | **Enabled** (Free switching between apps) | **Disabled** (`NSApplicationPresentationDisableProcessSwitching`) | [`SEBController.m`](Classes/SEBController.m): `startKioskModeThirdPartyAppsAllowed:overrideShowMenuBar:` |
| **Blackout Cover Windows** | **Disabled** (No overlay blackout windows across monitors) | **Enabled** (Blanks out external/secondary screens) | [`SEBController.m`](Classes/SEBController.m): `coverScreens` |
| **Window Frame & Sizing** | **Centered 80% Floating Window** | **Full Screen Kiosk Takeover** | [`SEBBrowserWindow.m`](Classes/BrowserComponents/SEBBrowserWindow.m): `setCalculatedFrameOnScreen:...` |
| **Window Level (Z-Order)** | **Normal Level** (`NSNormalWindowLevel` = 0) | **Elevated** (`NSMainMenuWindowLevel + 3` or higher) | [`SEBOSXBrowserController.m`](Classes/BrowserComponents/SEBOSXBrowserController.m): `setLevelForBrowserWindow:elevateLevels:` |

---

## Detailed Breakdown of Changes

### 1. Process Termination & App Killing
- **Problem in Dev**: SEB scans running processes on startup and immediately kills unauthorized applications (Cursor, VS Code, Chrome, Terminal, Docker, Spotify, etc.).
- **Code Modifications**:
  - `Classes/Categories/NSRunningApplication+SEB.m`:
    - `+ (BOOL)killProcessWithPID:(pid_t)processPID error:(NSError* _Nullable *)error`: Under `#if DEBUG`, logs a warning and returns `YES` without calling `kill(processPID, 9)`.
    - `+ (BOOL)killApplicationWithBundleIdentifier:(NSString *)bundleID`: Under `#if DEBUG`, returns `YES` immediately.
    - `- (BOOL)kill`: Under `#if DEBUG`, returns `YES` immediately.
  - `Classes/ProcessMonitoring/ProcessManager.m`:
    - `- (void)updateMonitoredProcesses`: Under `#if DEBUG`, the loop populating `self.prohibitedApplications` and `self.prohibitedBSDProcesses` is bypassed, keeping prohibited lists empty.
  - `Classes/SEBController.m`:
    - `- (void)terminateApplications:...`: Under `#if DEBUG`, logs suppression and directly calls `conditionallyContinueAfterTerminatingAppsWithCallback:` to proceed without closing any app.

### 2. Screenshots & Screen Recording
- **Problem in Dev**: SEB sets `NSWindowSharingNone` on its windows (which instructs the macOS WindowServer to black out window contents in any screenshot or screen share) and runs legacy screenshot shortcut redirection.
- **Code Modifications**:
  - `Classes/BrowserComponents/SEBOSXBrowserController.m`:
    - In `openBrowserWindowWithURL:` and `- (void)webViewShow:`: Under `#if DEBUG`, window sharing is set to `NSWindowSharingReadOnly`, allowing macOS screenshot shortcuts (`Cmd + Shift + 4`, `Cmd + Shift + 5`) and screen recordings to capture window contents.
  - `Classes/SystemManager/SEBSystemManager.m`:
    - `- (void)preventScreenCapture`: Under `#if DEBUG`, returns immediately without redirecting screenshots or intercepting shortcuts.

### 3. Kiosk Mode, Dock, Menu Bar, and App Switching
- **Problem in Dev**: Kiosk mode hides the Dock and Menu Bar and traps focus inside SEB by disabling `Cmd+Tab` and force-quit shortcuts.
- **Code Modifications**:
  - `Classes/SEBController.m`:
    - `- (void)startKioskModeThirdPartyAppsAllowed:overrideShowMenuBar:`: Under `#if DEBUG`, `presentationOptions` is assigned `NSApplicationPresentationDefault`, and `elevateWindowLevels` is forced to `NO`.
    - `- (void)coverScreens`: Under `#if DEBUG`, returns immediately without generating fullscreen blackout cap windows across displays.

### 4. Window Display & Layering
- **Problem in Dev**: The window covers the entire display and sits on an elevated window level, preventing side-by-side editing or clicking back to the IDE.
- **Code Modifications**:
  - `Classes/BrowserComponents/SEBBrowserWindow.m`:
    - `- (void)setCalculatedFrameOnScreen:...`: Under `#if DEBUG`, defaults to a centered window occupying 80% screen width and height.
  - `Classes/BrowserComponents/SEBOSXBrowserController.m`:
    - `- (void)setLevelForBrowserWindow:elevateLevels:`: Under `#if DEBUG`, forces `elevateLevels = NO`, ensuring the window sits at `NSNormalWindowLevel` (layer 0) alongside standard macOS apps.

---

## How to Toggle Between Modes

Xcode automatically defines `DEBUG=1` when running the **Debug** configuration.

1. **Development & Testing (All developer conveniences enabled)**:
   - Run via Xcode with scheme set to **Debug** (`Cmd + R`).
   - Or build via command line:
     ```bash
     xcodebuild -scheme "Safe Exam Browser" -configuration Debug
     ```

2. **Production Exam (Full strict lockdown)**:
   - In Xcode: **Product > Archive** or set scheme Run configuration to **Release**.
   - Or build via command line:
     ```bash
     xcodebuild -scheme "Safe Exam Browser" -configuration Release
     ```
   - In Release mode, all `#if DEBUG` code blocks are completely ignored by the compiler, maintaining 100% of the original Safe Exam Browser exam security specifications.
