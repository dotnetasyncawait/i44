; O  - remove the ending character
; b0 - don't delete the typed text
; *  - trigger immediately
; ?  - search everywhere (trigger even if the start is not separated from the previous text)


; --- dotnet ---

:X?::dw::ClipSend("dotnet watch --no-hot-reload")

:X?::dusi::ClipSend("dotnet user-secrets init")

:?O::duss::dotnet user-secrets set "" ""{left 4}

:X?::dr::ClipSend("dotnet run")

:X?::dbr::ClipSend("dotnet build -c Release")

; --- ---

; --- C# ---

:?O::wl::Console.WriteLine();{left 2}

:X?::rk::ClipSend("Console.ReadKey();")

:X?::dw::ClipSend("dotnet watch --no-hot-reload")

:X?::nie::ClipSend("throw new NotImplementedException();")

; --- ---


; --- Rust ---

:?O::pl::println{!}("");{left 3}

:X?::cr::ClipSend("cargo run")

:X?::cch::ClipSend("cargo check")

; --- ---


; --- git/github ---

:X?::grsh::ClipSend("git reset --soft HEAD~")

:X?::grs::ClipSend("git reset --soft ")

:X?::grhh::ClipSend("git reset --hard HEAD~")

:X?::grh::ClipSend("git reset --hard ")

:X?::-rs::ClipSend("--recurse-submodules")

:X?::ghr::ClipSend("https://github.com/dotnetasyncawait?tab=repositories")

:?O::gcm::git cm `"`"{left}

:X?::ghqmki44::ClipSend("https://github.com/schmidt-x/qmk_firmware/tree/schmidt-x/keyboards/ergohaven/imperial44")

:X?::ghahk::ClipSend("https://github.com/AutoHotkey/AutoHotkey")

; --- ---


; --- Youtube ---

:X?::yt::ClipSend("https://www.youtube.com/")

:X?::ytwl::ClipSend("https://www.youtube.com/playlist?list=WL")

:X?::ythis::ClipSend("https://www.youtube.com/feed/history")

:X?::ytpl::ClipSend("https://www.youtube.com/playlist?list=PLKRJNM-FYYn5cVrzOf7PKa4IPZSC8_v9y")

:X?::ytsub::ClipSend("https://www.youtube.com/feed/subscriptions")

; --- ---


; --- Qmk ---

:X?::qmkd::ClipSend("https://docs.qmk.fm/#/")

:X?::cpi44::ClipSend("qmk compile -kb ergohaven/imperial44 -km schmidt-x")

:X?::cpk02::ClipSend("qmk compile -kb ergohaven/k02 -km schmidt-x")

:X?::qmkmods::ClipSend("https://github.com/qmk/qmk_firmware/blob/master/quantum/modifiers.h")

:X?::qmkkc::ClipSend("https://github.com/qmk/qmk_firmware/blob/master/quantum/keycodes.h")

:X?::qmkqkc::ClipSend("https://github.com/qmk/qmk_firmware/blob/master/quantum/quantum_keycodes.h")

; --- ---


; --- Docker ---

:X?::dockd::ClipSend("https://docs.docker.com/reference/cli/docker/")

; --- ---


; --- Twitch ---

:X?::twch::ClipSend("https://www.twitch.tv/directory/category/just-chatting")

:X?::twtr::ClipSend("https://www.twitch.tv/directory/category/escape-from-tarkov")

; --- --- 


; --- misc ---

:?O::dll::DllCall(""){Left 2}

:X?::gxsh::ClipSend("opera://settings/keyboardShortcuts")

:?::cg:: {
	switch {
	case Obsidian.IsActive: SendInput("<font color=gray></font>{left}^{left}{left 2}")
	}
}

:X?::maps::ClipSend("https://www.google.com/maps/")

:X?::gm::ClipSend("https://mail.google.com/mail/u/0/#all")

:?O::aaa::// Arrange{Enter 3}// Act{Enter 3}// Assert{Enter}{Up 6}

:?::bl:: {
	switch {
	case Obsidian.IsActive: Obsidian.PasteBoldLink()
	}
}

:X?::gt::ClipSend(FormatTime(, "hh:mm:ss tt")) ; get time

:X?::gd::ClipSend(FormatTime(, "dd-MMM-yy")) ; get date

:X?::gdt::ClipSend(FormatTime(, "dd-MMM-yy hh:mm:ss tt")) ; get date-time

:?::sb:: {
	switch {
	case Obsidian.IsActive: Obsidian.PasteSpoilerBlock()
	}
}

:?::@:: {
	Sleep(100)
	
	_menu := Menu()
	_menu.Add("aboba228bibov@outlook.com", Sender)
	_menu.Add("schmidtsigma@gmail.com", Sender)
	_menu.Add("ukrainenko95@gmail.com", Sender)

	_menu.Show()
	
	Sender(item, *) {
		ClipSend(item)
	}
}

:X?::tz::ClipSend("https://www.timeanddate.com/time/zone/")

:X?::urb::ClipSend("https://www.urbandictionary.com/")

:X?::ahkd::ClipSend("https://www.autohotkey.com/docs/v2/")

:X?:``ahk::SendInput("``````ahk+{`n 2}``````{Up}")

:X?:``cs:: {
	switch WinGetProcessName("A") {
		case Obsidian.ProcessName: SendInput("``````cs`n")
		default: SendInput("``````cs+{`n 2}``````{Up}")
	}
}

:X?::kt::ClipSend("https://key-test.com/")

:CX?::guid::ClipSend(NewGuidStr(), false)
:CX?::Guid::ClipSend(NewGuidStr(true), false)

:O?::mb::MsgBox(){Left}

:X?::idk::ClipSend("¯\_(ツ)_/¯")