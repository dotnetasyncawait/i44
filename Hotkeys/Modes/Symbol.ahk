#HotIf Mode.IsNSymbol

*F14::Mode.SetInsert()

*F13::Mode.DelSymbol()

*F15:: {
	; F15 is sent on returning from SYMB+ to SYMB (QMK)
	return
}

Insert:: {
	switch {
	case Rider.IsActive:  Rider.NewFile()
	case VsCode.IsActive: VsCode.NewFile()
	}
}

<+1:: {
	switch {
	case Rider.IsActive:  Rider.CloneCaretAboveWithVirtualSpace()
	case VsCode.IsActive: VsCode.CopyCursorUp()
	}
}

<+3:: {
	switch {
	case Rider.IsActive:  Rider.CloneCaretBelowWithVirtualSpace()
	case VsCode.IsActive: VsCode.CopyCursorDown()
	}
}

>+2:: { ; @
	switch {
	case OperaGX.IsActive: OperaGX.DefaultPlaybackSpeed()
	case Chrome.IsActive:  Chrome.DefaultPlaybackSpeed()
	}
}

>+[:: { ; {
	switch {
	case Rider.IsActive:   Rider.PrevMethod()
	case VsCode.IsActive:  VsCode.PrevMember()
	case OperaGX.IsActive: OperaGX.DecreasePlaybackSpeed()
	case Chrome.IsActive:  Chrome.DecreasePlaybackSpeed()
	}
}

>+]:: { ; }
	switch {
	case Rider.IsActive:   Rider.NextMethod()
	case VsCode.IsActive:  VsCode.NextMember()
	case OperaGX.IsActive: OperaGX.IncreasePlaybackSpeed()
	case Chrome.IsActive:  Chrome.IncreasePlaybackSpeed()
	}
}

#HotIf


#HotIf Mode.IsISymbol

*F13:: {
	; is sent on SYMB down to NORML (SMB_NRM)
	return
}

*F14::Mode.DelSymbol()

*F15:: {
	; F15 is sent on returning from SYMB+ to SYMB 
	; and/or from NORML to SYMB (QMK)
	return
}

<+>+/::SendEvent("{U+2014}") ; '—' (Em dash, LShift + ?)

<+7::SendEvent("{U+2013}") ; '–' (En dash)

<+8::SendInput("->")

<+9::SendInput("=>")

<+-::SendInput(":=")

<+>+[::SendInput("{Blind}{U+00AB}") ; LShift + { => «

<+>+]::SendInput("{Blind}{U+00BB}") ; LShift + } => »

<+\::SendInput("\n")

#HotIf


#HotIf Mode.IsSSymbol

*F17::Mode.DelSymbol()

#HotIf