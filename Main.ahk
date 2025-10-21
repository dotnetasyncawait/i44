#Requires AutoHotkey v2.0
#Hotstring EndChars `t`s
#SingleInstance
#UseHook

SplitPath(A_AhkPath, &__name, &__dir)
__uia := "AutoHotkey64_UIA.exe"

if (__name !== __uia) {
	Run(Format('"{}\{}" "{}"', __dir, __uia, A_ScriptFullPath))
	ExitApp()
}

InstallKeybdHook(true, true)

CoordMode("ToolTip", "Screen")
CoordMode("Mouse", "Screen")

SetKeyDelay(-1, -1)
ProcessSetPriority("Normal")
A_HotkeyInterval := 0


#Include <System\Paths>
#Include <Common\Helpers>
#Include <Misc\CommandRunner>
#Include <Misc\Mode>
#Include <Apps\All>
#Include <Keyboards\I44>

#Include Hotkeys\Global.ahk
#Include Hotkeys\Modes\Normal.ahk
#Include Hotkeys\Modes\Insert.ahk
#Include Hotkeys\Modes\Symbol.ahk
#Include Hotkeys\Modes\Mouse.ahk
#Include Hotkeys\Modes\Select.ahk

#Include Misc\Hotstrings.ahk
#Include Misc\Commands.ahk


Mode.Show()

I44.EnableAhk(&err)
ThrowIfError(err)

OnExit(_DisableAhk)
OnMessage(0x0218, _On_WM_POWERBROADCAST)


_DisableAhk(exitReason, _) {
	if exitReason == "Reload" || exitReason == "Single" {
		return
	}
	
	I44.DisableAhk(&_)
}

_On_WM_POWERBROADCAST(wParam, lParam, msg, hwnd) {
	if wParam != 0x12 ; PBT_APMRESUMEAUTOMATIC
		return
	
	device := I44.NewDevice()
	device.Open(&err)
	ThrowIfError(err)
	
	try {
		device.Write([], &err)
		ThrowIfError(err)
		
		I44.Default(&err, device)
		ThrowIfError(err)
		
	} finally device.Close()
}