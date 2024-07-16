#SuspendExempt True

<+^0:: {
	if A_IsSuspended {
		Suspend(0)
		I44.EnableAhk(&err)
		if err {
			MsgBox("Error at enabling Ahk: " err.Message)
		}
		Mode.SetDefault()
	} else {
		Suspend(1)
		I44.DisableAhk(&err)
		if err {
			MsgBox("Error at disabling Ahk: " err.Message)
		}
		Mode.SetNone()
	}
}

+!^0:: {
	Reload()
}

#SuspendExempt False


+Enter:: {
	switch {
	case VsCode.IsActive: VsCode.InsertLineBelow()
	case Rider.IsActive:  Rider.StartNewLine()
	default: SendBlindEnter()
	}
}

^Enter:: {
	switch {
	case Explorer.IsActive:
		VsCode.OpenSelected(&err)
		if err {
			MsgBox(err.Message)
		}
	default: SendBlindEnter()
	}
}

+^LButton::DragWindow()

+^s:: {
	switch {
	case Rider.IsActive:    Rider.OpenSettings()
	case VsCode.IsActive:   VsCode.OpenSettings()
	case Obsidian.IsActive: Obsidian.OpenSettings()
	case OperaGX.IsActive:  OperaGX.OpenSettings()
	case WindowsTerminal.IsActive: WindowsTerminal.OpenSettings()
	}
}

^0:: {
	switch {
	case OperaGX.IsActive: OperaGX.SwitchToLastTab()
	case WindowsTerminal.IsActive: WindowsTerminal.SwitchToLastTab()
	default: SendInput("{Blind}0")
	}
}

^1:: {
	switch {
	case Rider.IsActive:    Rider.Explorer()
	case VsCode.IsActive:   VsCode.ShowExplorer()
	case Obsidian.IsActive: Obsidian.ExplorerFocus()
	case WindowsTerminal.IsActive: WindowsTerminal.SwitchToTab0()
	default: SendInput("{Blind}1")
	}
}

^2:: {
	switch {
	case Rider.IsActive:  Rider.Terminal()
	case VsCode.IsActive: VsCode.Terminal()
	case WindowsTerminal.IsActive: WindowsTerminal.SwitchToTab1()
	default: SendInput("{Blind}2")
	}
}

^3:: {
	switch {
	case Rider.IsActive:    Rider.Debug()
	case VsCode.IsActive:   VsCode.Debug()
	case Obsidian.IsActive: Obsidian.ShowOutline()
	case WindowsTerminal.IsActive: WindowsTerminal.SwitchToTab2()
	default: SendInput("{Blind}3")
	}
}

^4:: {
	switch {
	case Rider.IsActive:  Rider.Database()
	case WindowsTerminal.IsActive: WindowsTerminal.SwitchToTab3()
	default: SendInput("{Blind}4")
	}
}

^5:: {
	switch {
	case Rider.IsActive: Rider.UnitTests()
	case WindowsTerminal.IsActive: WindowsTerminal.SwitchToTab4()
	default: SendInput("{Blind}5")
	}
}

^6:: {
	switch {
	case Rider.IsActive:  Rider.Commit()
	case VsCode.IsActive: VsCode.ToggleSourceControl()
	case WindowsTerminal.IsActive: WindowsTerminal.SwitchToTab5()
	default: SendInput("{Blind}6")
	}
}

^7:: {
	switch {
	case Rider.IsActive:   Rider.Structure()
	case OperaGX.IsActive: OperaGX.ToWorkspace1()
	default: SendInput("{Blind}7")
	}
}

^8:: {
	switch {
	case Rider.IsActive:   Rider.ILViewer()
	case OperaGX.IsActive: OperaGX.ToWorkspace2()
	default: SendInput("{Blind}8")
	}
}

^9:: {
	switch {
	case OperaGX.IsActive: OperaGX.ToWorkspace3()
	default: SendInput("{Blind}9")
	}
}

