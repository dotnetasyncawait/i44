#Include <Misc\CommandRunner>

class FKeys {
	
	static __New() {
		CommandRunner.AddCommands("fkeys", this.Handle.Bind(this))
	}
	
	/**
	 * @param {CommandRunner.ArgsIter} args
	 */
	static Handle(args, _, &output) {
		if not args.Next(&arg) || arg.Value == "-h" {
			output := this._Usage
			return
		}
		
		switch arg.Value {
			case "on":
				SetFilterKeys(true)
				output := this._GetOutputValues()
			
			case "off":
				SetFilterKeys(false)
				output := this._GetOutputValues()
			
			case "st":
				output := this._GetOutputValues()
				
			case "set":
				this._HandleSet(args, &output)
			
			default: 
				output := Format("Invalid command '{}'. {}", arg.Value, this._Usage)
		}
	}
	
		
	static _HandleSet(args, &output) {
		if not args.Next(&arg) || arg.Value == "-h" {
			output := this._UsageSet
			return
		}
		
		state := waitMs := delayMs := repeatMs := bounceMs := unset
		
		loop {
			switch option := arg.Value {
				case "-s":
					if not args.Next(&next) {
						output := Format("[{}] Value is missing.", option)
						return
					}
					switch next.Value {
						case "on":  state := true
						case "off": state := false
						default:
							output := Format("[{}] Invalid value '{}'.", option, next.Value)
							return
					}
				
				case "-w":
					if not this._TryGetValue(args, option, &output, &value) {
						return
					}
					waitMs := value
				
				case "-d":
					if not this._TryGetValue(args, option, &output, &value) {
						return
					}
					delayMs := value
					
				case "-r":
					if not this._TryGetValue(args, option, &output, &value) {
						return
					}
					repeatMs := value
				
				case "-b":
					if not this._TryGetValue(args, option, &output, &value) {
						return
					}
					bounceMs := value
				
				default:
					output := Format("Invalid setting '{}'. {}", option, this._UsageSet)
					return
			}
		} until not args.Next(&arg)
		
		SetFilterKeys(state?, waitMs?, delayMs?, repeatMs?, bounceMs?)
		output := this._GetOutputValues()
	}
	
	static _TryGetValue(args, option, &output, &value) {
		if not args.Next(&next) {
			output := Format("[{}] Value is missing.", option)
			return false
		}
		
		if not IsInteger(next.Value) {
			output := Format("[{}] Value must be Integer.", option)
			return false
		}
		
		value := Integer(next.Value)
		return true
	}
	
	static _GetOutputValues() {
		onBitMask := 0x01 | 0x02 ; FKF_FILTERKEYSON | FKF_AVAILABLE
			
		fKeys := GetFilterKeys()
		state := fKeys.Flags & onBitMask == onBitMask
			
		return Format("
		(
			State:  {}
			Wait:   {}ms
			Delay:  {}ms
			Repeat: {}ms
			Bounce: {}ms
		)", state, fKeys.WaitMSec, fKeys.DelayMSec, fKeys.RepeatMSec, fKeys.BounceMSec)
	}
	
	static _Usage := "
		(
			Usage: fkeys [OPTIONS] COMMAND
			
			Commands:
			on:          Enable FilterKeys
			off:         Disable FilterKeys
			st:          Show FilterKeys values
			set <args>:  Set FilterKeys values
			
			Global options:
			-h:  Get usage
		)"
	
	static _UsageSet := "
		(
			Usage: fkeys set (SETTING VALUE)...
			
			Settings:
			-s string:  Turn on/off FilterKeys. Values: on, off.
			-w u32:     Set WaitMs
			-d u32:     Set DelayMs
			-r u32:     Set RepeatMs
			-b u32:     Set BounceMs
			
			Example: fkeys set -d 200 -r 16
		)"
}
