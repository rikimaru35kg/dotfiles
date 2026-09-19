#Requires AutoHotkey v2.0

#HotIf WinActive("ahk_exe EXCEL.EXE") || WinActive("ahk_exe chrome.exe") || WinActive("ahk_exe POWERPNT.EXE") || WinActive("ahk_exe ApplicationFrameHost.exe")
; cursor movement
^h::Send "{Left}"
^j::Send "{Down}"
^k::Send "{Up}"
^l::Send "{Right}"

; search
^/::
{
    SendEvent "{Ctrl Down}f{Ctrl Up}"
}
#HotIf

#HotIf WinActive("ahk_exe EXCEL.EXE") || WinActive("ahk_exe chrome.exe")
; sheet/tab change
LAlt & h::Send "^{PgUp}"
LAlt & l::Send "^{PgDn}"
#HotIf

#HotIf WinActive("ahk_exe EXCEL.EXE") || WinActive("ahk_exe POWERPNT.EXE")
; undo/redo
^u::Send "^z"
^+u::Send "^y"
#HotIf

#HotIf WinActive("ahk_exe EXCEL.EXE")
; scroll
^f::Send "{PgDn}"
^b::Send "{PgUp}"
; left/right jump
^0::Send "^{Left}"
^4::Send "^{Right}"
; up/down jump
^p::Send "^{Up}"
^n::Send "^{Down}"
; edit cell
^i::Send "{F2}"
; goto home/end
g_count := 0
^g::{
    global g_count

    g_count += 1

    if (g_count = 2) {
        Send "^{Home}"    ; gg
        g_count := 0
        return
    }
    SetTimer ResetG, -300
}
ResetG() {
    global g_count
    g_count := 0
}
^+g::Send "^{End}"
#HotIf

#HotIf WinActive("ahk_exe chrome.EXE") || WinActive("ahk_exe POWERPNT.EXE") || WinActive("ahk_exe ApplicationFrameHost.exe")
; scroll
^n::Send "{PgDn}"
^p::Send "{PgUp}"
#HotIf

; Check active window's exe file
F12::
{
    hwnd := WinExist("A")
    MsgBox(
        "Title: " WinGetTitle(hwnd) "`n`n"
      . "Class: " WinGetClass(hwnd) "`n`n"
      . "Exe: " WinGetProcessName(hwnd)
    )
}
