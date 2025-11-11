#Include <Misc\CommandRunner>

#Include Commands\FKeys.ahk
#Include Commands\New.ahk
#Include Commands\SleepShutdown.ahk

class Commands {
	
	static __New() {
		CommandRunner.AddCommands(
			"calc",  this._Calc,
			"tt",    this._Tt.Bind(this),
			"ts",    this._Ts.Bind(this),
			"tb",    this._Tb.Bind(this),
			"rat",   this._Rat.Bind(this),
			"bs",    this._Bs.Bind(this),
			"rp",    this._Rp.Bind(this),
			"inlh",  this._Inlh.Bind(this),
			"hid",   this._Hid.Bind(this),
			"hex",   this._Hex.Bind(this),
			"dec",   this._Dec.Bind(this),
			"bin",   this._Bin.Bind(this),
		)
	}
	
	
	static _Calc(*) => Run("calc")
	
	static _Tt(_, hwnd, output) {
		switch app := WinGetProcessName(hwnd) {
		case Rider.ProcessName:
			WinActivate(hwnd)
			Rider.ToTabs()
		case VsCode.ProcessName:
			WinActivate(hwnd)
			VsCode.ToTabs()
		default: 
			this._NotSupportedCommand(app, output, Rider.ProcessName, VsCode.ProcessName)
		}
	}
	
	static _Ts(_, hwnd, output) {
		switch app := WinGetProcessName(hwnd) {
		case VsCode.ProcessName:
			WinActivate(hwnd)
			VsCode.ToSpaces()
		default:
			this._NotSupportedCommand(app, output, VsCode.ProcessName)
		}
	}
	
	static _Tb(_, hwnd, output) {
		switch app := WinGetProcessName(hwnd) {
		case Rider.ProcessName:
			WinActivate(hwnd)
			Rider.ToggleToolbar()
		default:
			this._NotSupportedCommand(app, output, Rider.ProcessName)
		}
	}
	
	static _Rat(_, hwnd, output) {
		switch app := WinGetProcessName(hwnd) {
		case OperaGX.ProcessName:
			WinActivate(hwnd)
			OperaGX.ReloadAllTabs()
		default:
			this._NotSupportedCommand(app, output, OperaGX.ProcessName)
		}
	}
	
	static _Bs(_, hwnd, output) {
		switch app := WinGetProcessName(hwnd) {
		case Rider.ProcessName:
			WinActivate(hwnd)
			Rider.BuildSolution()
		default: 
			this._NotSupportedCommand(app, output, Rider.ProcessName)
		}
	}

	static _Rp(_, hwnd, output) {
		switch app := WinGetProcessName(hwnd) {
		case Rider.ProcessName:
			WinActivate(hwnd)
			Rider.NugetRestore()
		default: 
			this._NotSupportedCommand(app, output, Rider.ProcessName)
		}
	}
	
	static _Inlh(_, hwnd, output) {
		switch app := WinGetProcessName(hwnd) {
		case Rider.ProcessName:
			WinActivate(hwnd)
			Rider.ToggleInlayHints()
		default: 
			this._NotSupportedCommand(app, output, Rider.ProcessName)
		}
	}
	
	/**
	  * @param {CommandRunner.Output} output 
	 */
	static _Hid(args, _, output) {
		if not args.Next(&arg) || arg.Value == "-h" {
			output.Write(GetUsage())
			return
		}
		
		switch arg.Value {
			case "ping":
				output.Write(I44.Ping(&ms, &us) ? Format("{} ms ({} us)", ms, us) : "Keyboard not responsive.")
			default:
				output.WriteUnknownCommand(arg.Value, GetUsage())
		}
		
		return
		
		GetUsage() => "
		(
			Usage: hid [OPTIONS] COMMAND
			
			Commands:
			 ping:  Ping the keyboard
			
			Options:
			 -h:  Print usage
		)"
	}
	
	/**
	 * Binary to Hex and Decimal.
	 * @param {CommandRunner.Output} output
	 */
	static _Bin(args, _, output) {
		if args.IsEmpty {
			output.WriteError("empty input.")
			return
		}
		
		while args.Next(&arg) {
			value := arg.Value
			
			if not TryBinaryToInteger(value, &num) {
				output.WriteError(Format("value '{}' is not a valid binary number.", value))
				return
			}
			
			output.Write(Format("- {} -> 0x{:X} -> {}", value, num, num))
		}
		
		return
		
		TryBinaryToInteger(value, &num) {
			res := 0
			
			j := 0
			i := StrLen(value) + 1
			
			while --i > 0 {
				switch SubStr(value, i, 1) {
					case "0": ; break
					case "1": res += 1 << j
					case "_": continue
					default:  return false
				}
				j++
			}
			
			num := res
			return true
		}
	}

	/**
	 * Decimal to Hex and Binary.
	 * @param {CommandRunner.Output} output
	 */
	static _Dec(args, _, output) {
		if args.IsEmpty {
			output.WriteError("empty input.")
			return
		}
		
		while args.Next(&arg) {
			value := arg.Value
			
			if not IsInteger(value) {
				output.WriteError(Format("value '{}' is not a valid decimal number.", value))
				return
			}
			
			num := Integer(value)
			output.Write(Format("- {} -> 0x{:X} -> {}", num, num, IntegerToBinary(num)))
		}
	}
	
	/**
	 * Hex to Decimal and Binary.
	 * @param {CommandRunner.Output} output
	 */
	static _Hex(args, _, output) {
		if args.IsEmpty {
			output.WriteError("empty input.")
			return
		}
		
		while args.Next(&arg) {
			value := arg.Value
			
			if not IsXDigit(value) {
				output.WriteError(Format("value '{}' is not a valid hexadecimal number.", value))
				return
			}
			
			if SubStr(value, 1, 2) != "0x" {
				value := "0x" value
			}
			
			num := Integer(value)
			output.Write(Format("- {} -> {} -> {}", value, num, IntegerToBinary(num)))
		}
	}
	
	; --- helpers ---
	
	/**
	 * @param {CommandRunner.Output} output 
	 */
	static _NotSupportedCommand(app, output, supportedList*) {
		output.Write(Format("App '{}' does not support this command.`nApps supporting:", app))
		for app in supportedList {
			output.Write("- " app)
		}
	}
}