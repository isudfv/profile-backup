#Requires AutoHotkey v2.0
#SingleInstance Force

#Include %A_ScriptDir%/GroupDefine.ahk
#Include %A_ScriptDir%/PathFunctions.ahk
#Include %A_ScriptDir%/WindowFunctions.ahk

IsInvokingMultipleKeys(set?) {
    static is_multi_key := 0
    if IsSet(set)
        is_multi_key := set
    return is_multi_key
}

#Hotif WinActive("ahk_exe explorer.exe")
; Ctrl O T  open terminal
$^o:: {
    IsInvokingMultipleKeys(true)
    if KeyWait("t", "D T.5") {
        Paths := GetExplorerCurrentPath()
        Loop parse, Paths, "`n" {
            target_path := A_LoopField
            if (SubStr(A_LoopField, -1) == "/") {

            }
            else {
                target_path := SubStr(A_LoopField, 1, InStr(A_LoopField, "/", , , -1))
            }

            if !InStr(FileExist(target_path), "D") {
                continue
            }
            RunWait 'wt.exe --window 9 -d "' target_path '"'
            Sleep 550
            Run 'wt.exe --window 9 focus-tab'
        }
    }
    else {
        send "^o"
    }
    IsInvokingMultipleKeys(false)
}
#HotIf

; Ctrl P C  copy pid
$^p:: {
    IsInvokingMultipleKeys(true)
    if KeyWait("c", "D T.5") {
        A_Clipboard := WinGetPID("A")
    }
    else {
        Send "^p"
    }
    IsInvokingMultipleKeys(false)
}
#Hotif WinActive("ahk_group GameGroup") == 0
; Ctrl G W gather windows
$^g:: {
    IsInvokingMultipleKeys(true)
    if KeyWait("w", "D T.5") {
        GatherWindows()
    }
    else {
        Send "^g"
    }
    IsInvokingMultipleKeys(false)
}
; move window
#HotIf

#HotIf IsInvokingMultipleKeys()
^c:: return
^w:: return
^t:: return
#HotIf