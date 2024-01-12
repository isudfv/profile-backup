#Requires AutoHotkey v2.0

GetExplorerCurrentPath() {
    Paths := ""
    Class := WinGetClass("A")

    If (Class ~= "Progman|WorkerW") {
        Controls := WinGetControls("A")
        List := ListViewGetContent("Selected Col1", "SysListView321", "A")
        If (!List) {
            Paths .= A_Desktop
        }
        else {
            Loop Parse, List, "`n" {
                Path := A_Desktop "/" A_LoopField
                if InStr(FileExist(Path), "D") {
                    Path .= "/"
                }
                Paths .= Path "`n"
            }
        }
    }
    else If (class ~= "(Cabinet|Explore)WClass") {

        for window in ComObject("Shell.Application").Windows {
            If (window.hwnd == WinGetID("A")) {
                sel := window.Document.SelectedItems
                if (sel.Count == 0) {
                    Paths .= window.Document.Folder.Self.Path "/"
                }
                break
            }
        }
        for item in sel {
            Path := item.path
            if InStr(FileExist(Path), "D") {
                Path .= "/"
            }
            Paths .= Path "`n"
        }
    }

    Paths := StrReplace(Paths, "\", "/")
    Return Paths
}