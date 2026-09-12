# Faurus Exam Browser — Technical Documentation & Architecture

This document details the complete rebranding, file associations, dark flame visual theme, and development/production build toggles for **Faurus Exam Browser** ([faurus.app](https://faurus.app)).

---

## 1. Brand Architecture & Custom Formats

### Identity & Naming
- **Application Name**: Faurus Exam Browser
- **Executable / Bundle Name**: Faurus
- **Bundle Identifier**: `app.faurus.browser`
- **User-Agent String**: `FaurusBrowser/<version> Faurus/<version> ...`
- **Vendor / Organization**: Faurus (© 2026 Faurus. All Rights Reserved.)
- **Website**: `https://faurus.app/`

### File Format & Custom Protocols
- **Configuration Extension**: `.faurus` (MIME type: `application/x-faurus`, UTI: `app.faurus.config`)
  - Exam configurations exported from the settings or your web platform save and open as `<filename>.faurus`.
  - Backwards-compatible reading of legacy `.seb` files is retained internally.
- **URL Schemes**:
  - `faurus://` and `fauruss://`
  - Links clicked by students on `faurus.app` or an LMS automatically route into Faurus Exam Browser.

---

## 2. Visual Theme & Assets

Extracted from the official **faurus.app** visual identity:
- **Background**: Deep Obsidian Charcoal (`#0a0705`, `#100b08`)
- **Accent Gradients**: Flame Amber (`#ffb765` top-left to `#e8501d` bottom-right)
- **Top Accent Borders**: Subtle flame stroke (`rgba(255, 122, 61, 0.35)`)
- **Dock / Taskbar**: Custom-drawn `#0a0705` obsidian background with flame border in `Classes/SEBDock/SEBDockView.m`.
- **Insignia**: Apple-standard Retina squircle icon with the bold geometric Faurus "F" glyph.
- **Assets Generated**:
  - `AppIcon.appiconset`: 10 Retina sizes (16x16 up to 1024x1024).
  - `Resources/Icons/FaurusAppIcon.icns`: Application icon package.
  - `Resources/Icons/FaurusDocumentIcon.icns` & `SEBDocumentIcon.icns`: Document icon displayed by macOS Finder for `.faurus` files.
  - `Resources/Images/AboutFaurus.png` & `AboutFaurus@2x.png`: High-resolution dark glass About panel graphics.

---

## 3. Development Mode vs. Production Exam Mode

The codebase is equipped with compile-time `#if DEBUG` preprocessor directives:

| Lockdown Feature | Debug Build (`DEBUG=1` in Xcode) | Release Build (Production Exam) | Code Locations |
| :--- | :--- | :--- | :--- |
| **App Force-Quits** | **Disabled**: IDE, Terminal, Browser, and Docker remain open. | **Enabled**: Detects and terminates prohibited applications. | `NSRunningApplication+SEB.m`, `ProcessManager.m`, `SEBController.m` |
| **Screenshots & Capture** | **Allowed**: `Cmd+Shift+4` and recording capture the window cleanly (`NSWindowSharingReadOnly`). | **Blocked**: Windows blacked out via `NSWindowSharingNone`. | `SEBOSXBrowserController.m`, `SEBSystemManager.m` |
| **Dock & Menu Bar** | **Visible**: `NSApplicationPresentationDefault`. | **Hidden**: Kiosk mode hides Dock and Menu Bar. | `SEBController.m` |
| **App Switching** | **Enabled**: Normal `Cmd+Tab` app switching. | **Disabled**: Process switching blocked. | `SEBController.m` |
| **Cover Windows** | **Disabled**: No blackout overlay screens. | **Enabled**: Blanks out secondary monitors. | `SEBController.m` |
| **Window Frame** | **Standard 80% Floating Window** (layer 0). | **Full Screen Pinned Kiosk Window**. | `SEBBrowserWindow.m`, `SEBOSXBrowserController.m` |

---

## 4. How to Build

1. **Development & Testing**:
   Open `SafeExamBrowser.xcworkspace` in Xcode, ensure the active scheme is set to **Debug**, and press **`Cmd + R`**.
2. **Production Distribution**:
   In Xcode, select **Product > Archive** (or build with `-configuration Release`). The compiler will strictly ignore all debug branches and output the full kiosk exam browser.
