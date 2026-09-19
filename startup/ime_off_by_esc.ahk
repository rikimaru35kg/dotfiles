#Requires AutoHotkey v2.0
; ──────────────────────────────────────────────
; IMEを明示的にON/OFFする関数
;   isOn := 0  → IME OFF（英数）
;   isOn := 1  → IME ON（ひらがな）
; WinTitle := "A"  → アクティブウィンドウが対象
; ──────────────────────────────────────────────
IME_SET(isOn := 0, WinTitle := "A") {
    hwnd := WinGetID(WinTitle)
    if !hwnd
        return

    ; ImmGetDefaultIMEWnd で IMEウィンドウのハンドルを取得
    ctl := DllCall("imm32\ImmGetDefaultIMEWnd", "Ptr", hwnd, "Ptr")
    if !ctl
        return

    WM_IME_CONTROL     := 0x283
    IMC_SETOPENSTATUS  := 0x006

    ; SendMessage( IMEウィンドウ, WM_IME_CONTROL, IMC_SETOPENSTATUS, isOn )
    ; isOn = 0 → IME OFF,  isOn = 1 → IME ON
    DllCall("SendMessage", "Ptr", ctl
                           , "UInt", WM_IME_CONTROL
                           , "Ptr",  IMC_SETOPENSTATUS
                           , "Ptr",  isOn)
}

; ──────────────────────────────────────────────
; Escキーで「IMEをオフ」にしてから、Esc本来の動作を行う
; ──────────────────────────────────────────────
Esc:: {
    IME_SET(0)             ; 0でIMEをOFFにする
    Hotkey("Esc", "Off")   ; 一時的にホットキーを無効化（再帰ループ防止）
    Send("{Esc}")          ; Esc本来の動作を送信
    Hotkey("Esc", "On")    ; ホットキーを再度有効化
}
