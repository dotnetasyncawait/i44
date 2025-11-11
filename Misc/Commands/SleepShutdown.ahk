#Include <Misc\CommandRunner>
#Include <Common\Helpers>

class SleepShutdown {
	
	static __New() {
		CommandRunner.AddCommands(
			"sleep",  this.Sleep.Bind(this),
			"shdown", this.Shutdown.Bind(this)
		)
	}
	
	static Sleep(args, _, output) {
		static caller := CreateCaller()
		this.SleepShutdown(args, caller, output)
		return
		
		static CreateCaller() {
			caller := SleepShutdown.Caller("sleep")
			caller.Func := () => (caller.ScheduledAt := "", SuspendPC())
			return caller
		}
	}
	
	static Shutdown(args, _, output) {
		static caller := CreateCaller()
		this.SleepShutdown(args, caller, output)
		return
		
		static CreateCaller() {
			caller := SleepShutdown.Caller("shdown")
			caller.Func := () => (caller.ScheduledAt := "", Shutdown(0x8)) ; EWX_POWEROFF := 0x00000008
			return caller
		}
	}
	
	/**
	 * @param {CommandRunner.ArgsIter} args 
	 * @param {SleepShutdown.Caller} caller 
	 * @param {CommandRunner.Output} output
	 */
	static SleepShutdown(args, caller, output) {
		if not args.Next(&arg) || arg.Value == "-h" {
			output.Write(this.GetUsage(caller.Name))
			return
		}
		
		switch arg.Value {
			case "at":   this.HandleAt(args, caller, output)
			case "in":   this.HandleIn(args, caller, output)
			case "off":  this.HandleOff(caller, output)
			case "show": this.HandleShow(caller, output)
			default: output.WriteUnknownCommand(arg.Value, this.GetUsage(caller.Name))
		}
	}
	
	/**
	 * @param {CommandRunner.ArgsIter} args 
	 * @param {SleepShutdown.Caller} caller 
	 * @param {CommandRunner.Output} output
	 */
	static HandleAt(args, caller, output) {
		if not args.Next(&arg) {
			output.WriteError("Time value is expected. " this.GetUsage(caller.Name))
			return
		}
		
		regExp := "i)^(\d{1,2}):([0-5]\d)(?:\:([0-5]\d))?(pm|am)$"
		
		if not RegExMatch(arg.Value, regExp, &info) {
			output.WriteError(this.GetInvalidFormat(caller.Name))
			return
		}
		
		h := info[1]
		if h < 1 || h > 12 {
			output.WriteError(this.GetInvalidFormat(caller.Name))
			return
		}
		
		h := Mod(h, 12) + (info[4] = "pm" ? 12 : 0) ; convert 'h' from 12 into 24-hour format
		m := info[2]
		s := (t := info[3]) ? t : 0
		
		atTime := Format("{}{}{}{:02}{:02}{:02}", A_Year, A_Mon, A_MDay, h, m, s)
		totalSeconds := DateDiff(atTime, A_Now, "Seconds")
		
		; If the time is in the past, schedule it for tomorrow
		if totalSeconds < 0 {
			atTime := DateAdd(atTime, 1, "Days")
			totalSeconds := 86400 + totalSeconds
		}
		
		SetTimer(caller.Func, -(totalSeconds * 1000))
		caller.ScheduledAt := atTime
		
		output.Write(this.GetScheduledOutput(caller.Name, atTime, totalSeconds))
	}
	
	/**
	 * @param {CommandRunner.ArgsIter} args 
	 * @param {SleepShutdown.Caller} caller 
	 * @param {CommandRunner.Output} output
	 */
	static HandleIn(args, caller, output) {
		if not args.Next(&arg) {
			output.WriteError("Time value is expected. " this.GetUsage(caller.Name))
			return
		}
		
		regExp := "^(?:(\d{1,2})h)?(?:(\d{1,2})m)?(?:(\d{1,2})s)?$"
		
		if not RegExMatch(arg.Value, regExp, &info) {
			output.WriteError(this.GetInvalidFormat(caller.Name))
			return
		}
		
		h := (t := info[1]) ? t : 0
		m := (t := info[2]) ? t : 0
		s := (t := info[3]) ? t : 0
		
		totalSeconds := (h * 3600) + (m * 60) + s
		SetTimer(caller.Func, -(totalSeconds * 1000))
		
		atTime := DateAdd(A_Now, totalSeconds, "Seconds")
		caller.ScheduledAt := atTime
		
		output.Write(this.GetScheduledOutput(caller.Name, atTime, totalSeconds))
	}
	
	/**
	 * @param {SleepShutdown.Caller} caller 
	 * @param {CommandRunner.Output} output
	 */
	static HandleOff(caller, output) {
		if not caller.ScheduledAt {
			output.WriteError(Format("No scheduled {} is found", caller.Name))
			return
		}
		
		atFormatted := this.GetAtFormatted(caller.ScheduledAt)
		
		SetTimer(caller.Func, 0)
		caller.ScheduledAt := ""
		
		output.Write(Format("Scheduled {} at {} is turned off", caller.Name, atFormatted))
	}
	
	/**
	 * @param {SleepShutdown.Caller} caller 
	 * @param {CommandRunner.Output} output
	 */
	static HandleShow(caller, output) {
		if not caller.ScheduledAt {
			output.Write(Format("No scheduled {} is found", caller.Name))
			return
		}
		
		totalSeconds := DateDiff(caller.ScheduledAt, A_Now, "Seconds")
		output.Write(this.GetScheduledOutput(caller.Name, caller.ScheduledAt, totalSeconds))
	}
	
	static GetScheduledOutput(callerName, atTime, totalSeconds)
		=> Format(
			"Scheduled {} at {} (in {:02}:{:02}:{:02})",
			callerName, this.GetAtFormatted(atTime), totalSeconds // 3600, Mod(totalSeconds // 60, 60), Mod(totalSeconds, 60))
	
	static GetAtFormatted(atTime) => FormatTime(atTime, "dd-MMM hh:mm:ss tt")
	
	static GetUsage(callerName) => Format("
		(
			Usage: {1} COMMAND

			Commands:
			 in <in-time>:  Schedules an event in the specified time
			 at <at-time>:  Schedules an event at the specified time
			 show:          Displays the scheduled event
			 off:           Disables the scheduled event

			Time formats:
			 <in-time>:  [[N]Nh][[N]Nm][[N]Ns] (at least one unit required)
			             - N: any number between 0-9
			             - h: hours
			             - m: minutes
			             - s: seconds
			 <at-time>:  [h]h:mm[:ss]{am|pm}
			
			Examples:
			 -> {1} at 1:15pm
			 -> {1} in 1h15m
		)", callerName)
	
	static GetInvalidFormat(callerName) => "Invalid time format. " this.GetUsage(callerName)
	
	class Caller {
		__New(name) {
			this.Name := name
		}
		
		Name := ""
		Func := ""
		ScheduledAt := ""
	}
}