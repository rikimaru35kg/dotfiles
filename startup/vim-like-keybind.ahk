#Requires AutoHotkey v2.0

#HotIf WinActive("ahk_exe EXCEL.EXE") || WinActive("ahk_exe chrome.exe") || WinActive("ahk_exe POWERPNT.EXE") || WinActive("ahk_exe explorer.exe") || WinActive("ahk_exe ApplicationFrameHost.exe") || WinActive("ahk_exe OUTLOOK.EXE") || WinActive("ahk_exe ms-teams.exe")
; cursor movement
^h::SendEvent "{Left}"
^j::SendEvent "{Down}"
^k::SendEvent "{Up}"
^l::SendEvent "{Right}"

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

#HotIf WinActive("ahk_exe explorer.exe")
; tab switch
LAlt & l::SendEvent "^{Tab}"
LAlt & h::SendEvent "^+{Tab}"
#HotIf

#HotIf WinActive("ahk_exe POWERPNT.EXE")
; left/right jump
^0::Send "{Home}"
^4::Send "{End}"
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
#HotIf

#HotIf WinActive("ahk_exe EXCEL.EXE") || WinActive("ahk_exe ms-teams.exe")
; goto home/end
g_count := 0
^g::{
    global g_count
    g_count += 1
    if (g_count = 1) {
        SetTimer SendEnd, -300
    }
    else if (g_count = 2) {
        SetTimer SendEnd, 0    ; タイマーキャンセル
        Send "^{Home}"         ; gg
        g_count := 0
    }
}
SendEnd() {
    global g_count

    if (g_count = 1) {
        Send "^{End}"
    }
    g_count := 0
}
#HotIf

#HotIf WinActive("ahk_exe chrome.EXE") || WinActive("ahk_exe POWERPNT.EXE") || WinActive("ahk_exe explorer.exe") || WinActive("ahk_exe ApplicationFrameHost.exe") || WinActive("ahk_exe OUTLOOK.EXE") || WinActive("ahk_exe ms-teams.exe")
; scroll (using SendEvent to prevent crash on RDP session)
^n::SendEvent "{PgDn}"
^p::SendEvent "{PgUp}"
#HotIf

#HotIf WinActive("ahk_exe EXCEL.EXE") || WinActive("ahk_exe explorer.exe")
; edit cell/filename
^i::Send "{F2}"
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
