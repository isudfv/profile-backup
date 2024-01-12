#Requires AutoHotkey v2.0
#SingleInstance Force

MonitorCount := MonitorGetCount()
MonitorPrimary := MonitorGetPrimary()

GetWindowMonitorIndex(X, Y) {
    Loop MonitorCount {
        MonitorGet A_Index, &L, &T, &R, &B
        MonitorGetWorkArea A_Index, &WL, &WT, &WR, &WB

        if (X >= WL && X < WR && Y >= WT && Y < WB) {

            return A_Index
        }
    }
    return 1
}

MoveWindow(direction) {
    CoordMode "Mouse", "Screen"
    MouseGetPos &xpos, &ypos

    WinGetPos &X, &Y, &W, &H, "A"
    target_index := GetWindowMonitorIndex(X + W / 2, Y + H / 10) + 1
    if (target_index > MonitorCount) {
        target_index := 1
    }

    MonitorGet target_index, &L, &T, &R, &B
    ; MonitorGetWorkArea target_index, &WL, &WT, &WR, &WB

    mouse_index := GetWindowMonitorIndex(xpos, ypos)
    MonitorGet mouse_index, &NL, &NT, &NR, &NB
    new_mouse_x := L + (xpos - NL) / (NR - NL) * (R - L)
    new_mouse_y := T + (ypos - NT) / (NB - NT) * (B - T)
    ; MsgBox "" L " " (xpos - NL) / NR " " T " " (ypos - NT) / NB

    Send "#+" direction

    DllCall("SetCursorPos", "int", new_mouse_x, "int", new_mouse_y)
}

GatherWindows() {
    WinGetPos &X, &Y, &W, &H, "A"
    target_index := GetWindowMonitorIndex(X + W / 2, Y + H / 10)
    MonitorGet target_index, &L, &T, &R, &B

    focused_process := WinGetProcessName("A")
    focused_window := WinGetID("A")
    process_windows := WinGetList("ahk_exe" focused_process)

    x := L + 100
    y := T + 100
    for window in process_windows {
        if focused_process == "explorer.exe" && !InStr(WinGetClass(window), "CabinetWClass") { ; only deal with CabinetWClass when process is explorer
            continue
        }
        if (window == focused_window) {
            continue
        }
        WinActivate window
        WinMove x, y, , , window
        x := x + 50
        y := y + 50
    }
    WinActivate focused_window
    WinMove x, y, , , focused_window
}

FocusWindowOnAnotherScreen() {
    CoordMode "Mouse", "Screen"
    MouseGetPos &xpos, &ypos

    mouse_index := GetWindowMonitorIndex(xpos, ypos)
    MonitorGet mouse_index, &NL, &NT, &NR, &NB

    WinGetPos &X, &Y, &W, &H, "A"
    target_index := GetWindowMonitorIndex(X + W / 2, Y + H / 10) + 1
    if (target_index > MonitorCount) {
        target_index := 1
    }

    windows := WinGetList()

    MonitorGet target_index, &L, &T, &R, &B

    new_mouse_x := L + (xpos - NL) / (NR - NL) * (R - L)
    new_mouse_y := T + (ypos - NT) / (NB - NT) * (B - T)
    DllCall("SetCursorPos", "int", new_mouse_x, "int", new_mouse_y)

    for window in windows {
        WinGetPos &XX, &YY, &WW, &HH, window
        x := XX + WW / 2
        y := YY + HH / 10

        if (x >= L && x < R && y >= T && y < B) {
            title := WinGetTitle(window)
            win_class := WinGetClass(window)
            if (win_class == "Shell_TrayWnd") {
                continue
            }
            WinActivate(window)
            break
        }
    }
}