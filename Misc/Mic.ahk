#Include <Common\TrayIcon>
#Include <Misc\CommandRunner>
#Include <Misc\XAudio2>
#Include <Misc\Audio>

class Mic {
	static _gMic := "media\greenMic.ico"
	static _rMic := "media\redMic.ico"
	
	static _playSound := true
	static _soundOn   := "media\Windows Hardware Insert.wav"
	static _soundOff  := "media\Windows Hardware Fail.wav"
	
	static __New() {
		/**
		 * @type {Audio.Device}
		 */
		this._mic := m := Audio.FindDevice("Microphone (FIFINE K670 Microphone)", DeviceType.Capture)
		if not m {
			throw Error("Mic not found")
		}
		
		this._tray := TrayIcon(42)
			.Add(this._gMic, m.DeviceName)
			.Add(this._rMic, m.DeviceName " (muted)")
			.OnLeftClick((*) => this.ToggleMute())
			.OnRightClick((*) => this._OpenRecordingDevices())
		
		this._tray.Display(m.GetMute())
		CommandRunner.AddCommands("mic", this._CommandHandler.Bind(this))
	}
	
	static ToggleMute() {
		this._tray.Display(mute := this._mic.ToggleMute())
		
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
		
		switch command := arg.Value {
		case "setv":
			if not args.Next(&arg) {
				output.WriteError("volume is expected: mic setv <volume>")
			} else if not IsInteger(volume := arg.Value) {
				output.WriteError("volume must be an integer in the range 0-100.")
			} else {
				this._mic.SetVolume(volume)
				output.Write("New volume: " this._mic.GetVolume())
			}
		case "getv":  output.Write("Volume: " this._mic.GetVolume())
		case "sound": output.Write("Mic sound is toggled " ((this._playSound ^= 1) ? "on." : "off."))
		default:      output.WriteUnknownCommand(command, "TODO: usage")
		}
	}
}