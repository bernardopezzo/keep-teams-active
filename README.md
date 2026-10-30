# Keep Teams Active (AutoHotkey v2)

![AutoHotkey](https://img.shields.io/badge/Language-AutoHotkey%20v2.0-blue?logo=autohotkey)
![Platform](https://img.shields.io/badge/Platform-Windows%2010%20%2F%2011-0078D6?logo=windows)

A non-intrusive background utility written in **AutoHotkey v2** that prevents Microsoft Teams, Slack, Skype, and Windows lock screens from marking you as **"Away"** or entering sleep mode while you are reading, thinking, or reviewing documents.

---

## ⚡ Key Features

- **Non-Disruptive Micro-Jitter**: Unlike clumsy tools that drag your mouse halfway across the screen or press keys that interfere with typing, this utility sends a **1-pixel relative delta movement** and immediately returns it (`+1px` $\to$ `-1px`). The net visual movement is **zero**.
- **Multi-Monitor Safe**: Uses relative Win32 `mouse_event` API calls, avoiding absolute coordinate boundary issues and monitor-jumping glitches.
- **Smart Idle Detection**: Only activates when you have been completely inactive for more than 1 second (`A_TimeIdle > 1000ms`). As long as you are actively using your computer, the script does nothing.
- **Ultra-Lightweight**: Uses $< 5 \text{ MB}$ of RAM and essentially 0% CPU.
- **Standalone Binary Included**: Ready-to-use precompiled `.exe` included in `bin/`—no need to install AutoHotkey if you just want to run it.
- **System Tray Integration**: Features a custom mouse pointer icon in the Windows notification area with status tooltips and standard exit controls.

---

## 🚀 How to Run

### Option 1: Standalone Executable (No Installation Required)
Simply navigate to [`bin/keep_teams_active.exe`] and double-click to run. You will see the custom mouse pointer icon appear in your Windows System Tray (near the clock).

### Option 2: Run via AutoHotkey v2
1. Install [AutoHotkey v2.0+](https://www.autohotkey.com/).
2. Double-click [`keep_teams_active.ahk`].

---

## 🔄 Run Automatically on Windows Startup

If you want the tool to start automatically every time you log into your PC:

1. Press `Win + R` to open the Run dialog.
2. Type `shell:startup` and press **Enter**. This opens your Windows Startup folder.
3. Right-click [`bin/keep_teams_active.exe`] and select **Show more options > Create shortcut**.
4. Move the created shortcut into the Startup folder.

---

## 🛠️ How It Works (Technical Details)

Windows tracks idle time using the Win32 input subsystem (`GetLastInputInfo`). When no mouse or keyboard events occur for a period configured by your corporate policy or application settings, Microsoft Teams changes your status to "Away".

This script uses the Win32 `mouse_event` function:
```ahk
DllCall("mouse_event", "UInt", 0x0001, "Int", 1, "Int", 1, "UInt", 0, "UPtr", 0)
DllCall("mouse_event", "UInt", 0x0001, "Int", -1, "Int", -1, "UInt", 0, "UPtr", 0)
```
- `0x0001` corresponds to `MOUSEEVENTF_MOVE` with relative coordinates.
- Moving `+1, +1` followed instantly by `-1, -1` generates a valid OS-level input event that resets the idle counter to 0 while leaving the cursor visually stationary.

---

## 📁 Repository Structure

```
keep-teams-active/
├── keep_teams_active.ahk       # Main AutoHotkey v2 source script
├── bin/
│   └── keep_teams_active.exe   # Standalone compiled Windows executable
├── assets/
│   ├── mouse_arrow.ico         # Primary custom system tray icon
│   └── aero_arrow.ico          # Alternate Windows Aero pointer icon
├── .gitignore                  # Standard repository exclusions
└── README.md                   # Full documentation and usage guide
```

---

## 🔨 Compiling from Source

To recompile the `.ahk` script into an executable:
1. Ensure AutoHotkey v2 is installed with **Ahk2Exe**.
2. Right-click [`keep_teams_active.ahk`] and select **Compile GUI** (or use `Ahk2Exe.exe`).
3. Set Custom Icon to `assets/mouse_arrow.ico`.
4. Click **Convert**.