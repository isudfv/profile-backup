#Requires AutoHotkey v2.0
#SingleInstance Force

#Include %A_ScriptDir%/GroupDefine.ahk
#Include %A_ScriptDir%/PathFunctions.ahk
#Include %A_ScriptDir%/WindowFunctions.ahk

CoordMode "Mouse", "Screen"

Capslock:: {
    Send "{Esc down}{Esc up}"
    if WinActive("ahk_group EditorGroup") {
        hwnd := WinExist("A")
        Run A_Desktop '/bin/AIMSwitcher.exe --imm 0 --hwnd ' hwnd
    }
}

+Capslock:: {
    Send "{Shift down}{Esc down}{Esc up}{Shift up}"
    if WinActive("ahk_group EditorGroup") {
        hwnd := WinExist("A")
        Run A_Desktop '/bin/AIMSwitcher.exe --imm 0 --hwnd ' hwnd
    }
}

#Hotif WinActive("ahk_exe msedge.exe") == 0
!+M:: {
    if WinExist("ahk_exe msedge.exe") {
        WinActivate
        WinShow
        WinMaximize

        WinGetPos &X, &Y, &W, &H
        DllCall("SetCursorPos", "int", X + W / 2, "int", Y + H / 2)
    }

    Sleep 10
    Send "!+{M}"
}
#Hotif

#Hotif WinActive("ahk_group EditorGroup") == 0
; 切换 window
!`:: {
    win_id := WinActive("A")
    win_class := WinGetClass("A")
    active_process_name := WinGetProcessName("A")
    ; We have to be extra careful about explorer.exe since that process is responsible for more than file explorer
    if (active_process_name = "explorer.exe")
        win_list := WinGetList("ahk_exe" active_process_name " ahk_class" win_class)
    else
        win_list := WinGetList("ahk_exe" active_process_name)

    ; Calculate index of next window. Since activating a window puts it at the top of the list, we have to take from the bottom.
    next_window_i := win_list.Length
    next_window_id := win_list[next_window_i]

    ; Activate the next window and send it to the top.
    WinMoveTop("ahk_id" next_window_id)
    WinActivate("ahk_id" next_window_id)
}
#HotIf

#Hotif WinActive("ahk_exe explorer.exe")
^+c:: {
    Paths := GetExplorerCurrentPath()
    QuotePaths := ""
    for index, path in StrSplit(Paths, "`n") {
        if (path) {
            QuotePaths .= ', ' '"' path '"'
        }
    }
    A_Clipboard := SubStr(QuotePaths, StrLen(", ") + 1)
}
#Hotif

; block input
toggle := false

AppsKey & F12:: {
    global toggle := !toggle
    BlockInput toggle
}

#Space:: {
    hwnd := WinExist("A")
    Run A_Desktop '/bin/AIMSwitcher.exe --imm switch --hwnd ' hwnd
}

+F10:: {
    Send "{AppsKey}"
}

#+Right:: {
    MoveWindow("{Right}")
}

#+Left:: {
    MoveWindow("{Left}")
}

#Tab:: {
    FocusWindowOnAnotherScreen()
}