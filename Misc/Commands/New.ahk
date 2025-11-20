#Include <Misc\CommandRunner>
#Include <Apps\VsCode>
#Include <Apps\Explorer>

class New {
	static __New() {
		CommandRunner.AddCommands("new", This.Handle.Bind(This))
	}
	
	/**
	 * @param {CommandRunner.ArgsIter} args
	 * @param {CommandRunner.Output} output
	 */
	static Handle(args, hwnd, output) {
		if args.IsEmpty {
			output.Write(this._Usage)
			return
		}
		
		fileName := ""
		open := false
		
		while args.Next(&arg) {
			if !arg.IsOption {
				fileName := arg.Value
				continue
			}
			
			switch arg.Value {
				case "-o":
					open := true
					continue
				
				case "-h":
					output.Write(this._Usage)
					return
				
				default:
					output.WriteUnknownCommand(arg.Value, this._Usage)
					return
			}
		}
		
		if not fileName {
			output.WriteError("file name not provided.")
			return
		}
		
		if WinGetProcessName(hwnd) != Explorer.ProcessName {
			output.WriteError("not in Explorer.")
			return
		}
		
		if not Paths.TryGet(&path, hwnd) {
			output.WriteError("path not found.")
			return
		}
		
		fileFullName := Format("{}\{}", path, StrReplace(fileName, "/", "\"))
		
		try {
			if SubStr(fileFullName, -1) == "\" {
				DirCreate(fileFullName)
			} else {
				SplitPath(fileFullName, , &dir)
				DirCreate(dir)
				FileAppend("", fileFullName)
			}
		} catch Error as err {
			output.WriteError(err.Message)
			return
		}
		
		if open {
			VsCode.Open(fileFullName)
		}
	}
	
	static _Usage := "
		(
			Usage: new [OPTIONS] FILENAME
			
			Options:
			 -o:  Open file/folder in editor
			 -h:  Print usage
		)"
}