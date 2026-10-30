#Requires AutoHotkey v2.0
#SingleInstance Force

; ==============================================================================
; Keep Teams Active - Lightweight Windows Idle Reset Utility
;
; Purpose:
;   Prevents Microsoft Teams, Slack, Skype, Discord, and Windows lock screen /
;   screensaver from switching your status to "Away" or sleeping when idle,
;   without disrupting normal user interaction, typing, or gaming.
;
; How It Works:
;   1. Monitors Windows system idle duration via `A_TimeIdle`.
;   2. If user has been idle for more than 1000ms (1 second), triggers a relative
;      1-pixel delta move (+1, +1) followed immediately by (-1, -1) via Win32
;      `mouse_event` API (MOUSEEVENTF_MOVE = 0x0001).
;   3. Because the net movement is 0 pixels, the cursor visually remains stationary
;      and does not cause unwanted clicks or multi-monitor drift, while Windows
;      resets the idle counter to 0.
; ==============================================================================

; --- System Tray Configuration ---
; Look for custom tray icon in the 'assets' directory or root folder
iconPath := A_ScriptDir . "\assets\mouse_arrow.ico"
if !FileExist(iconPath) {
    iconPath := A_ScriptDir . "\mouse_arrow.ico"
}

try {
    if FileExist(iconPath) {
        TraySetIcon(iconPath)
    }
}

; Set hover tooltip for system tray icon
A_IconTip := "Keep Teams Active (Running)"

; Ensure coordinate modes are consistent across multi-monitor setups
CoordMode "Mouse", "Screen"

; --- Timer Setup ---
; Check idle state every 1000 milliseconds (1 second)
SetTimer(KeepActive, 1000)

; --- Core Idle Reset Routine ---
KeepActive() {
    ; A_TimeIdle contains milliseconds elapsed since the last physical user input
    if (A_TimeIdle > 1000) {
        ; Send relative movement of dx=1, dy=1
        DllCall("mouse_event", "UInt", 0x0001, "Int", 1, "Int", 1, "UInt", 0, "UPtr", 0)

        ; Immediately compensate with dx=-1, dy=-1 to restore exact cursor coordinate
        DllCall("mouse_event", "UInt", 0x0001, "Int", -1, "Int", -1, "UInt", 0, "UPtr", 0)
    }
}
