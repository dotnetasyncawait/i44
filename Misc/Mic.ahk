#Include <Common\TrayIcon>
#Include <Misc\XAudio2>

class Mic {
	static _mic := "Microphone (FIFINE K670 Microphone)"
	
	static _gMic := "media\greenMic.ico"
	static _rMic := "media\redMic.ico"
	
	static _playSound := true
	static _soundOn   := "media\Windows Hardware Insert.wav"
	static _soundOff  := "media\Windows Hardware Fail.wav"
	
	static _tray := TrayIcon(42)
		.Add(this._gMic, this._mic)
		.Add(this._rMic, this._mic " (muted)")
		.OnDoubleClick((*) => this.ToggleMute())
		.OnRightClick((*) => this._OpenRecordingDevices())
	
	static __New() {
		this._tray.Display(SoundGetMute(, this._mic))
		CommandRunner.AddCommands("mic", this._CommandHandler.Bind(this))
	}
	
	static ToggleMute() {
		mute := !SoundGetMute(, this._mic)
		
		SoundSetMute(mute, , this._mic)
		this._tray.Display(mute)
		
		if this._playSound {
			XAudio2.PlaySound(mute ? this._soundOff : this._soundOn, 0.5)
		}
	}
	
	static _OpenRecordingDevices() {
		; https://learn.microsoft.com/en-us/windows/win32/coreaudio/device-state-xxx-constants
		Run("control mmsys.cpl,,1")
	}
	
	/**
	 * @param {CommandRunner.ArgsIter} args
	 * @param {CommandRunner.Output} output
	 */
	static _CommandHandler(args, _, output) {
		if not args.Next(&arg) {
			Run(Format('"{}{}" "{}"', A_ProgramFiles, "\Adobe\Adobe Audition CC\Adobe Audition CC.exe", "D:\Files\123.sesx"))
			return
		}
		
		switch value := arg.Value {
		case "setv":
			if not args.Next(&arg) {
				output.WriteError("value is expected.")
			} else if not IsNumber(arg.Value) {
				output.WriteError("value must be Integer or Float.")
			} else {
				SoundSetVolume(arg.Value, , this._mic)
				output.Write("New volume: " SoundGetVolume(, this._mic))
			}
		case "getv":  output.Write("Volume: " SoundGetVolume(, this._mic))
		case "sound": output.Write("Mic sound is toggled " ((this._playSound ^= 1) ? "on." : "off."))
		default:      output.WriteUnknownCommand(value, "TODO: usage")
		}
	}
}