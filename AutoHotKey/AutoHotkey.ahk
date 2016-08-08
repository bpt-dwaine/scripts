; Variables definition
; -----------------------------------------------------------------------------
EnvGet, userProfile, USERPROFILE
;Software := userProfile . "\Dropbox\software\"
Programs386 := "c:\Program Files (x86)\"
;"I:\Navision\Assets\IT Assets\Scripts\Autohotkey\DragAndDrop.ahk"
DocTag := "UPGRADE"

#Persistent
;SetTimer, Alert1, 500
;SetTimer, CloseMessageBox, 250
return

;OK to NAV message
CloseMessageBox:
If WinExist("ahk_class #32770") and WinExist("Microsoft Dynamics NAV")
	{
	ControlGetFocus, FocusedClassNN, ahk_class #32770
	ControlGetText, FocusedText, %FocusedClassNN%, ahk_class #32770
	;ControlGetPos, DimX, DimY, DimW, DimH, MDIClient1, ahk_class #32770 ;this would be the button
	;msgbox Text is %FocusedText%
	;IF %FocusedText% = OK 
	;	{
		;msgbox Text is %FocusedText%
		WinGetPos, DimX, DimY, DimW, DimH, A
		SplashTextOn, , , Closing NAV message
		;WinGetPos,,, Width, Height, Closing a NAV OK message
		;WinMove, Closing NAV message,, (A_ScreenWidth/2)-(Width/2), (A_ScreenHeight/2)-(Height/2) - 100
		;WinMove, Closing NAV message,, (DimX/2)-(DimW/2), (DimY/2)-(DimH/2) - 100
		WinMove, Closing NAV message,, DimX, DimY
		Sleep, 250
		SplashTextOff
		WinClose, Microsoft Dynamics NAV Classic
		return
	;	}
	;return
	}
return
	
Alert1:
;IfWinNotExist, ahk_class #32770
If WinExist("ahk_class #32770") and WinExist("Microsoft Dynamics NAV")
	{
	SetTimer, Alert1, off  ; i.e. the timer turns itself off here.
	SplashTextOn, , , There is an OK message.
	Sleep, 3000
	SplashTextOff
	}
else
return


;WinGet, ControlList, ControlList, A
;SetKeyDelay, 1  ; Smallest possible
;IfWinActive, ahk_class #32770 
;	;MsgBox, Message trigger	
;	;ClassNN:	Button1
;	ControlGetFocus, FocusedClassNN, ahk_class #32770
;	ControlGetText, FocusedText, %FocusedClassNN%, ahk_class #32770
;	MsgBox message box says
;	"%FocusedText%"
;	Send {Enter}
;return


;SetTimer, WatchActiveWindow, 200
;return

;WatchActiveWindow:
;WinGet, ControlList, ControlList, A
;ToolTip, %ControlList%
;return

!^+c::
	SetKeyDelay, 1  ; Smallest possible
	Send -- Cost Control ----------------------------------------------
	Send {Enter}
	Send Tag       Description
	Send {Enter}
	Send --------------------------------------------------------------
	Send {Enter}
	return

!^+K::
	SetKeyDelay, 1  ; Smallest possible
	Send -- KwikTag ---------------------------------------------------
	Send {Enter}
	Send No Ver    Dev   Reference       Date       Description
	Send {Enter}
	Send --------------------------------------------------------------DEK_20141002R
	Send {Enter}
	return

!^+1::
	SetKeyDelay, 1  ; Smallest possible
	Send -- Clients First ---------------------------------------------
	Send {Enter}
	Send No. Date     Sign Version     Description 
	Send {Enter}
	Send --------------------------------------------------------------
	Send {Enter}
	return

!^+a::
	SetKeyDelay, 1  ; Smallest possible
	Send -- ArcherPoint -----------------------------------------------
	Send {Enter}
	Send Tag     Sig Date      Description 
	Send {Enter}
	Send --------------------------------------------------------------
	Send {Enter}
	return

!^+b::
	SetKeyDelay, 1  ; Smallest possible
	Send -- Bridgeport Fittings ---------------------------------------
	Send {Enter}
	Send Tag Date      Sig Reference Description
	Send {Enter}
	Send --------------------------------------------------------------
	Send {Enter}
	return

^+[::
	; insert header
	; Ex. B02 06/19/13  DEK SRX00039  Test if posting date is allowed.
		; Set Tag
	InputBox, UserInput, Comment, Next Tag?.,
	if ErrorLevel
	    MsgBox, CANCEL was pressed.
	else
		;StringUpper, DocTag, UserInput 
		DocTag := "BPT" + UserInput
	
	InputBox, UserInput, Comment, Please enter a comment.,
	if ErrorLevel
	    MsgBox, CANCEL was pressed.
	else
		FormatTime, CurrentDate,,MM/dd/yy
		SetKeyDelay, 1  ; Smallest possible
		Send %DocTag% DEK %CurrentDate%: ID000000  %UserInput%
		Send {Enter}
		Send ^{h}
		Send ???
		Send {TAB}
		Send %DocTag%
		Send !{a}
		Send !{y}
		Send {ESC}
		DocTag := "???"
	return
^+]::
	; insert header
	; Ex. B02 06/19/13  DEK FRX00039  Test if posting date is allowed.
		; Set Tag
	InputBox, UserInput, Comment, Next Tag?.,
	if ErrorLevel
	    MsgBox, CANCEL was pressed.
	else
		;StringUpper, DocTag, UserInput 
		DocTag := "BPT" + UserInput
	
	InputBox, UserInput, Comment, Please enter a comment.,
	if ErrorLevel
	    MsgBox, CANCEL was pressed.
	else
		FormatTime, CurrentDate,,MM/dd/yy
		SetKeyDelay, 1  ; Smallest possible
		Send %DocTag% %CurrentDate%  DEK ID000000  %UserInput%
		Send {Enter}
		Send ^{h}
		Send ???
		Send {TAB}
		Send %DocTag%
		Send !{a}
		Send !{y}
		Send {ESC}
		DocTag := "???"
	return    
<^<+b::
	;Send // ???_%A_YYYY%%A_MM%%A_DD% >>
	Send ,BF5.00.000
	return

^!.::
	;Send // ???_%A_YYYY%%A_MM%%A_DD% >>
	;Send // UPGRADE_%A_YYYY%%A_MM%%A_DD% >>
	Send // ??? >>
	return

^!,::
	;Send // ???_%A_YYYY%%A_MM%%A_DD% <<
	;Send // UPGRADE_%A_YYYY%%A_MM%%A_DD% <<
	Send // ??? <<
	return

^!\::
	; General comment
	InputBox, UserInput, Comment, Please enter a comment.,
	InputBox, UserInput, Comment, Please enter a comment.,
	if ErrorLevel
	    MsgBox, CANCEL was pressed.
	else
		; FormatTime, CurrentDate,,MM/dd/yy
		Send //> %UserInput% <//		
	return
^+.::
	;Send // ???_%A_YYYY%%A_MM%%A_DD% >>
	;Send // %DocTag%_%A_YYYY%%A_MM%%A_DD% >>
	Send // %DocTag% >>
	return

^+,::
	;Send // ???_%A_YYYY%%A_MM%%A_DD% <<
	;Send // %DocTag%_%A_YYYY%%A_MM%%A_DD% <<
	Send // %DocTag% <<
	return

^+\::
	; General comment
	InputBox, UserInput, Comment, Please enter a comment.,
	if ErrorLevel
	    MsgBox, CANCEL was pressed.
	else
		; FormatTime, CurrentDate,,MM/dd/yy
		Send //> %UserInput% <//		
	return
^+t::
	; To Do
		Send //> TODO %A_MM%/%A_DD%/%A_YYYY% <//		
	return

^+'::
	; Set Tag
	InputBox, UserInput, Comment, Next Tag?.,
	if ErrorLevel
	    MsgBox, CANCEL was pressed.
	else
		;StringUpper, DocTag, UserInput 
		DocTag := UserInput 
	return

;!^+t::
	;Send DEK_%A_YYYY%%A_MM%%A_DD%R
	;return
	
^.::
	Send //>
	return

^,::
	Send //<
	return
	
^+v::
	;Visible FALSE
		SetTitleMatchMode, 2
		SetTitleMatchMode, Fast
		WinActivate, ahk_class C/SIDE Application
		ControlGetPos, DimX, DimY, DimW, DimH, MDIClient1, ahk_class C/SIDE Application
		;-------------Left-----------------------------
		ControlMove, Properties, DimX+10, DimY+50, DimW*.15, DimH-60, ahk_class C/SIDE Application
		;-------------Middle-----------------------------
		ControlMove, Designer, DimX+300, DimY+50, 850, DimH-60, ahk_class C/SIDE Application
		ControlGetFocus, FocusedClassNN, ahk_class C/SIDE Application
		ControlGetText, FocusedText, %FocusedClassNN%, ahk_class C/SIDE Application
		
		Sleep, 333
		ControlFocus, Properties, ahk_class C/SIDE Application
		Send, {LControl Down}
		ControlSend, Properties, {Home}, ahk_class C/SIDE Application
		Send, {LControl Up}
		ControlSend, Properties, {Home}, ahk_class C/SIDE Application
		ControlSend, Properties, {v}, ahk_class C/SIDE Application
		ControlSend, Properties, {Right}, ahk_class C/SIDE Application
		SetKeyDelay, -1, 10
		ControlSend, Properties, FALSE, ahk_class C/SIDE Application
		ControlSend, Properties, {Tab}, ahk_class C/SIDE Application
		
		ControlFocus, %FocusedText%, ahk_class C/SIDE Application
	return
	
^+e::
	;Editable FALSE
		SetTitleMatchMode, 2
		SetTitleMatchMode, Fast
		WinActivate, ahk_class C/SIDE Application
		ControlGetPos, DimX, DimY, DimW, DimH, MDIClient1, ahk_class C/SIDE Application
		;-------------Left-----------------------------
		ControlMove, Properties, DimX+10, DimY+50, DimW*.15, DimH-60, ahk_class C/SIDE Application
		;-------------Middle-----------------------------
		ControlMove, Designer, DimX+300, DimY+50, 850, DimH-60, ahk_class C/SIDE Application
		ControlGetFocus, FocusedClassNN, ahk_class C/SIDE Application
		ControlGetText, FocusedText, %FocusedClassNN%, ahk_class C/SIDE Application
		
		Sleep, 333
		ControlFocus, Properties, ahk_class C/SIDE Application
		Send, {LControl Down}
		ControlSend, Properties, {Home}, ahk_class C/SIDE Application
		Send, {LControl Up}
		ControlSend, Properties, {Home}, ahk_class C/SIDE Application
		ControlSend, Properties, {e}, ahk_class C/SIDE Application
		ControlSend, Properties, {e}, ahk_class C/SIDE Application
		ControlSend, Properties, {Right}, ahk_class C/SIDE Application
		SetKeyDelay, -1, 10
		ControlSend, Properties, FALSE, ahk_class C/SIDE Application
		ControlSend, Properties, {Tab}, ahk_class C/SIDE Application
		
		ControlFocus, %FocusedText%, ahk_class C/SIDE Application
	return
	
^+1::
	;Standard NAV Field
		SetTitleMatchMode, 2
		SetTitleMatchMode, Fast
		WinActivate, ahk_class C/SIDE Application
		ControlGetPos, DimX, DimY, DimW, DimH, MDIClient1, ahk_class C/SIDE Application
		;-------------Left-----------------------------
		ControlMove, Properties, DimX+10, DimY+50, DimW*.15, DimH-60, ahk_class C/SIDE Application
		;-------------Middle-----------------------------
		ControlMove, Page Designer, DimX+300, DimY+50, 850, DimH-60, ahk_class C/SIDE Application

		Sleep, 333
		ControlFocus, Properties, ahk_class C/SIDE Application
		Send, {LControl Down}
		ControlSend, Properties, {Home}, ahk_class C/SIDE Application
		Send, {LControl Up}
		ControlSend, Properties, {Home}, ahk_class C/SIDE Application
		ControlSend, Properties, {i}, ahk_class C/SIDE Application
		ControlSend, Properties, {Right}, ahk_class C/SIDE Application
		ControlSend, Properties, {s}, ahk_class C/SIDE Application
		ControlSend, Properties, {Tab}, ahk_class C/SIDE Application
		
		ControlFocus, Page Designer, ahk_class C/SIDE Application
	return
	
^+2::
	;Promote NAV Field
		SetTitleMatchMode, 2
		SetTitleMatchMode, Fast
		WinActivate, ahk_class C/SIDE Application
		ControlGetPos, DimX, DimY, DimW, DimH, MDIClient1, ahk_class C/SIDE Application
		;-------------Left-----------------------------
		ControlMove, Properties, DimX+10, DimY+50, DimW*.15, DimH-60, ahk_class C/SIDE Application
		;-------------Middle-----------------------------
		ControlMove, Page Designer, DimX+300, DimY+50, 850, DimH-60, ahk_class C/SIDE Application

		Sleep, 333
		ControlFocus, Properties, ahk_class C/SIDE Application
		Send, {LControl Down}
		ControlSend, Properties, {Home}, ahk_class C/SIDE Application
		Send, {LControl Up}
		ControlSend, Properties, {Home}, ahk_class C/SIDE Application
		ControlSend, Properties, {i}, ahk_class C/SIDE Application
		ControlSend, Properties, {Right}, ahk_class C/SIDE Application
		ControlSend, Properties, {p}, ahk_class C/SIDE Application
		ControlSend, Properties, {Tab}, ahk_class C/SIDE Application
		
		ControlFocus, Page Designer, ahk_class C/SIDE Application
	return
	
^+3::
	;Additional NAV Field
		SetTitleMatchMode, 2
		SetTitleMatchMode, Fast
		WinActivate, ahk_class C/SIDE Application
		ControlGetPos, DimX, DimY, DimW, DimH, MDIClient1, ahk_class C/SIDE Application
		;-------------Left-----------------------------
		ControlMove, Properties, DimX+10, DimY+50, DimW*.15, DimH-60, ahk_class C/SIDE Application
		;-------------Middle-----------------------------
		ControlMove, Page Designer, DimX+300, DimY+50, 850, DimH-60, ahk_class C/SIDE Application

		Sleep, 333
		ControlFocus, Properties, ahk_class C/SIDE Application
		Send, {LControl Down}
		ControlSend, Properties, {Home}, ahk_class C/SIDE Application
		Send, {LControl Up}
		ControlSend, Properties, {Home}, ahk_class C/SIDE Application
		ControlSend, Properties, {i}, ahk_class C/SIDE Application
		ControlSend, Properties, {Right}, ahk_class C/SIDE Application
		ControlSend, Properties, {a}, ahk_class C/SIDE Application
		ControlSend, Properties, {Tab}, ahk_class C/SIDE Application
		
		ControlFocus, Page Designer, ahk_class C/SIDE Application
	return
	
^+4::
	;NAV Action - Promote BIG
		SetTitleMatchMode, 2
		SetTitleMatchMode, Fast
		WinActivate, ahk_class C/SIDE Application
		ControlGetPos, DimX, DimY, DimW, DimH, MDIClient1, ahk_class C/SIDE Application
		;-------------Left-----------------------------
		ControlMove, - Properties, DimX+10, DimY+50, DimW*.15, DimH-60, ahk_class C/SIDE Application
		;-------------Middle-----------------------------
		ControlMove, Page Action Designer, DimX+300, DimY+50, 850, DimH-60, ahk_class C/SIDE Application

		Sleep, 333
		ControlFocus, - Properties, ahk_class C/SIDE Application
		Send, {LControl Down}
		ControlSend, - Properties, {Home}, ahk_class C/SIDE Application
		Send, {LControl Up}
		Sleep, 333
		ControlSend, - Properties, {Home}, ahk_class C/SIDE Application
		ControlSend, - Properties, {p}, ahk_class C/SIDE Application
		ControlSend, - Properties, {Right}, ahk_class C/SIDE Application
		ControlSend, - Properties, {y}, ahk_class C/SIDE Application
		ControlSend, - Properties, {Down}, ahk_class C/SIDE Application
		ControlSend, - Properties, {p}, ahk_class C/SIDE Application
		ControlSend, - Properties, {Down}, ahk_class C/SIDE Application
		ControlSend, - Properties, {y}, ahk_class C/SIDE Application
		ControlSend, - Properties, {Down}, ahk_class C/SIDE Application
		ControlFocus, Action Designer, ahk_class C/SIDE Application
	return
	
^+5::
	;NAV Action - Promote normal
		SetTitleMatchMode, 2
		SetTitleMatchMode, Fast
		WinActivate, ahk_class C/SIDE Application
		ControlGetPos, DimX, DimY, DimW, DimH, MDIClient1, ahk_class C/SIDE Application
		ControlMove, - Properties, DimX+10, DimY+50, DimW*.15, DimH-60, ahk_class C/SIDE Application
		;-------------Middle-----------------------------
		ControlMove, Page Action Designer, DimX+300, DimY+50, 850, DimH-60, ahk_class C/SIDE Application

		Sleep, 333
		ControlFocus, - Properties, ahk_class C/SIDE Application
		Send, {LControl Down}
		ControlSend, - Properties, {Home}, ahk_class C/SIDE Application
		Send, {LControl Up}
		Sleep, 333
		ControlSend, - Properties, {Home}, ahk_class C/SIDE Application
		ControlSend, - Properties, {p}, ahk_class C/SIDE Application
		ControlSend, - Properties, {Right}, ahk_class C/SIDE Application
		ControlSend, - Properties, {y}, ahk_class C/SIDE Application
		ControlSend, - Properties, {Down}, ahk_class C/SIDE Application
		ControlSend, - Properties, {p}, ahk_class C/SIDE Application
		ControlSend, - Properties, {Down}, ahk_class C/SIDE Application
		ControlSend, - Properties, {Delete}, ahk_class C/SIDE Application		
		ControlSend, - Properties, {Down}, ahk_class C/SIDE Application
		ControlFocus, Action Designer, ahk_class C/SIDE Application
	return
	
^[::
	; Begin Region
	InputBox, UserInput, Comment, Please enter a comment.,
	if ErrorLevel
	    MsgBox, CANCEL was pressed.
	else
		; FormatTime, CurrentDate,,MM/dd/yy
		Send ^{$REGION '%UserInput%'}		
	return

^]::
	; End Region
	Send {$ENDREGION}
	return

^+h::
	; General comment
	InputBox, UserInput, Tag, Please enter a Tag to replace ???.,
	if ErrorLevel
		MsgBox, CANCEL was pressed.
	else		
		;Send %UserInput%
		Send ^{h}
		Send ???
		Send {TAB}
		Send %UserInput%
		Send !{a}
		Send !{y}
		Send {ESC}
	return

^+;:: 
	;Add blank version in editor
	SetKeyDelay, 1  ; Smallest possible
	Send, {End}
	Send, {Backspace}
	Send, `,
	Send, b;
	return

^+b::
	;Add BASE tag version in editor 
	Send, {End}
	Send, {Backspace}
	Send, `,
	Send, BF5.00.000;
	return
	
^+-::	
	ClipboardOld := ClipboardAll
	Clipboard := ""
	InsertPoint := 0
	InsertPoint2 := 0
	ClipboardFirst := ""
	Loop
	{
		Send, ^+{Right}
		A_Index2 := A_Index
		Send, ^c
		Sleep, 20
		If (ClipboardFirst = "")
			ClipboardFirst := Clipboard
		If (Clipboard = "" || ClipboardFirst = Clipboard)
			return
		Length := StrLen(Clipboard)
		InsertPoint := RegExMatch(Clipboard,"\.")
		If (InsertPoint = 0)
			continue
		else
			break
	}
	Send, {Left}
	Send, ^{Right %A_Index2%}
	Clipboard := ClipboardOld
	ClipboardOld := ""
return
	
^+q::	
	ClipboardOld := ClipboardAll
	Clipboard := ""
	InsertPoint := 0
	InsertPoint2 := 0
	ClipboardFirst := ""
	Loop
	{
		Send, ^+{Right}
		A_Index2 := A_Index
		Send, ^c
		Sleep, 20
		If (ClipboardFirst = "")
			ClipboardFirst := Clipboard
		If (Clipboard = "" || ClipboardFirst = Clipboard)
			return
		Length := StrLen(Clipboard)
		InsertPoint := RegExMatch(Clipboard,"\.")
		If (InsertPoint = 0)
			continue
		else
			break
	}
	Send, {Left}
	Send, ^{Right %A_Index2%}
	Clipboard := ClipboardOld
	ClipboardOld := ""
return
	
^+/:: 
	Clipboard := ""
	
	SetKeyDelay, 2  ; Smallest possible
	Send {Home}
	;Send, ^{Right}
	Send +{END}
	Send ^x
	ClipWait, 0
	
	IfWinActive, ahk_class #32770 
		Send {Enter}
	
	Send // UPGRADE_%A_YYYY%%A_MM%%A_DD% >>	
	Send {Enter}
	
	;Gosub AddCommentsV2
	Send //
	Send ^v
	Send {Enter}
	
	;Clipboard := OldClipboard
	;Send message('Replace:
	Send ^v
	;Send ');
	;Sleep, 500
	Send {Enter}
	
	Send // UPGRADE_%A_YYYY%%A_MM%%A_DD% <<
	Send {Up}
	Sleep, 500
	Send {Home}
	;Send, ^{Right}
	return	

!^+x:: ; select text press shift-ctrl-alt-x
	SetKeyDelay, 1  ; Smallest possible
	OldClipboard := Clipboard
	Send, ^x
	ClipWait, 0
	IfWinActive, ahk_class #32770 
		Send {Enter}
	Send {Down}
	Sleep, 1000
	Gosub AddComments
	Send ^v
	Clipboard := OldClipboard 
	return
	
!^+f:: ; press shift-ctrl-alt-f to pipe clipboard
	SetKeyDelay, 1  ; Smallest possible
	;Send, ^x
	;ClipWait, 0
	;IfWinActive, ahk_class #32770 
	;	Send {Enter}
	Gosub AddPipe
	;MsgBox Control-C copied the following contents to the clipboard:`n`n%clipboard%
	return

!^+q:: ; press shift-ctrl-alt-f to quote clipboard
	SetKeyDelay, 1  ; Smallest possible
	;Send, ^x
	;ClipWait, 0
	;IfWinActive, ahk_class #32770 
	;	Send {Enter}
	Gosub AddQuote
	;MsgBox Control-C copied the following contents to the clipboard:`n`n%clipboard%
	return

;-----------------------------------------------------------------------------
;--- SUB routines ------------------------------------------------------------
;-----------------------------------------------------------------------------
	AddComments:
		;Clipboard := "/*`n" . Clipboard . "`n*/" ; wrap with comments tag
		Clipboard := "// UPGRADE_20140605 >>" . Clipboard . "`n// UPGRADE_20140605 <<"
		StringReplace, Clipboard, Clipboard, `r`n,  `r`n//, All		
		return
	AddCommentsV2:
		
		;Clipboard := Clipboard
		;StringReplace, Clipboard, Clipboard, `r`n,  `r`n//, All		
		StringReplace, Clipboard, Clipboard, `r`n,  `r`n//, UseErrorLevel
			If ErrorLevel <= 1 ; 
		  	{
			  	;StringReplace, Clipboard, Clipboard, `r`n, `r`n//%A_Space%, All
				StringReplace, Clipboard, Clipboard, `r`n,  `r`n//, All
			  	If InStr(Clipboard, "`r`n") != 1
		  			Clipboard := "//" . Clipboard
			}
		return

		AddPipeX:
		StringReplace, Clipboard, Clipboard, `r`n, |, UseErrorLevel
			;If ErrorLevel <= 10000 ; if 10000 or fewer lines
		  	{
			  	;StringReplace, Clipboard, Clipboard, `r`n,|, All
			  	If InStr(Clipboard, "`r`n") != ErrorLevel
		  			Clipboard := "//" . Clipboard
			}
		return
		AddPipe:
			StringReplace, Clipboard, Clipboard, `r`n,|, UseErrorLevel
			
		return

		AddQuote:
			Delimiter := "','"
			StringReplace, Clipboard, Clipboard, `r`n,%Delimiter%, UseErrorLevel
			
		return

; Meta: Greenshot
; -----------------------------------------------------------------------------

~^+c::
	; Close Greenshot editor after copy
	IfWinActive, Greenshot image editor
	{
		WinActivate
		WinClose
		return 
	}
	IfWinActive, ahk_class SnagIt9Editor
	; Send ^c
	ClipWait, 1 ; Wait for the clipboard to contain text.
	MsgBox Control-C copied the following contents to the clipboard:`n`n%clipboard%
	return

;^+r::
	; Example 1
	;IfWinExist, ahk_class Notepad
	;{
	;	WinActivate  ; Automatically uses the window found above.
	;	WinGetText, MyText
	;	MsgBox, 4,, MyText
	;return
	;	; Initialize string to search.
	;	strTag := B01
	;	
	;	; Initialize counter to keep track of our position in the string.
	;	Position := 0
	;	Loop, Parse, WinText, strTag
	;	
	;	; Calculate the position of the B at the end of this field.
	;		Position += StrLen(A_LoopField) + 1
	;		
	;	Delimiter := SubStr(WinText, Position, 1)
;
;				
;		Send, Field: %A_LoopField%`nDelimiter: %Delimiter% {Enter}
;		return
;		}
	
; Meta: Window control
; -----------------------------------------------------------------------------
^+NumpadEnter::
;WM_NCCALCSIZE ??
;WM_WINDOWPOSCHANGING = WM_WINDOWPOSCHANGING = 0x46
DetectHiddenWindows, on
SetTitleMatchMode, 2
IfWinActive, ahk_exe Microsoft.Dynamics.Nav.Client.exe
	{
		WinGet, active_id, ID, A
		WinMove, ahk_id %active_id%,,,,800,600
		return 
	}
return

^+0::
; Test
WinGet, ActiveControlList, ControlList, A
Loop, Parse, ActiveControlList, `n
{
    MsgBox, 4,, Control #%a_index% is "%A_LoopField%". Continue?
    ;this_id := id%a_index%
	;this_txt := %A_LoopField%
   	
	;WinActivate, ahk_id %this_id%
	;WinMove, ahk_id %this_id%,,,,800,600
	;MsgBox, 4,, The Control window's ID is "%a_index%".Continue?
	    IfMsgBox, No
        	break
}
return

^+NumpadDiv::
;Example: ControlMove, , Pos x(l to r), Pos y (t to b), Size W, Size H, ahk_class C/SIDE Application
SetTitleMatchMode, Fast
IfWinActive, ahk_exe finsql.exe
	{
		WinGet, active_id, ID, A
		ControlGetPos, DimX, DimY, DimW, DimH, MDIClient1, ahk_id %active_id%
		ControlGetFocus, FocusedClassNN, ahk_id %active_id%
		ControlGetText, FocusedText, %FocusedClassNN%, ahk_id %active_id%
		if (FocusedText = "Object Manager")
			return
		ControlMove, %FocusedText%, DimX+10, DimY+50, DimW*.99, DimH-60, ahk_id %active_id%
		return
	}
IfWinActive, ahk_exe Microsoft.Dynamics.Nav.Client.exe
	{
		WinGet, active_id, ID, A
		WinMaximize
		return
	}
return


^+NumpadMult::
;Example: ControlMove, , Pos x(l to r), Pos y (t to b), Size W, Size H, ahk_class C/SIDE Application
SetTitleMatchMode, Fast
IfWinActive, ahk_exe finsql.exe
	{
		WinGet, active_id, ID, A
		ControlGetPos, DimX, DimY, DimW, DimH, MDIClient1, ahk_id %active_id%
		ControlGetFocus, FocusedClassNN, ahk_id %active_id%
		ControlGetText, FocusedText, %FocusedClassNN%, ahk_id %active_id%
		if (FocusedText = "Object Manager")
			return
		;ControlMove, %FocusedText%, DimX+10, DimY+50, DimW*.99, DimH-60, ahk_id %active_id%
		
		;-------------Left-----------------------------
		ControlMove, Properties, DimX+10, DimY+50, DimW*.15, DimH-60, ahk_id %active_id%

		;-------------Middle-----------------------------
		ControlGetFocus, FocusedClassNN, ahk_id %active_id%
		ControlGetText, FocusedText, %FocusedClassNN%, ahk_id %active_id%
		ControlMove, %FocusedText%, DimX+10, DimY+10, DimW*.50, DimH-400, ahk_id %active_id%

		ControlMove, Table Designer, DimX+260, DimY+50, DimW*.85, DimH-60, ahk_id %active_id%
		ControlMove, Form Designer, DimX+260, DimY+50, DimW*.85, DimH-60, ahk_id %active_id%
		ControlMove, Section Designer, DimX+260, DimY+50, DimW*.85, DimH-60, ahk_id %active_id%
		ControlMove, C/AL Globals, DimX+260, DimY+50, DimW*.85, DimH*.33, ahk_id %active_id%
		ControlMove, C/AL Locals, DimX+260, DimY+50, DimW*.85, DimH*.33, ahk_id %active_id%
		ControlMove, C/AL Editor, DimX+260, DimY+50, DimW*.85, DimH-60, ahk_id %active_id%
		;ControlMove, Object Designer, DimX+260, DimY+50, DimW*.85, DimH-60, ahk_id %active_id%
		;ControlMove, Object Manager, DimX+260, DimY+50, DimW*.85, DimH-60, ahk_id %active_id%

		return
	}
IfWinActive, ahk_exe Microsoft.Dynamics.Nav.Client.exe
	{
		WinGet, active_id, ID, A
		WinMove, ahk_id %active_id%,,,,800,600
		return
	}
return

^+NumpadSub::
	SetTitleMatchMode, 2
	SetTitleMatchMode, Fast
	WinActivate, ahk_class C/SIDE Application
	ControlGetPos, DimX, DimY, DimW, DimH, MDIClient1, ahk_class C/SIDE Application

	;ControlMove, _________, DimX+10, DimY+50, DimW-100, DimH-60, 
	;-------------Left-----------------------------
	ControlMove, Properties, DimX+10, DimY+50, DimW*.15, DimH-60, ahk_class C/SIDE Application
	;-------------Middle-----------------------------
	ControlMove, Action Designer, DimX+300, DimY+50, 850, DimH-60, ahk_class C/SIDE Application
	ControlMove, Page Designer, DimX+300, DimY+50, 850, DimH-60, ahk_class C/SIDE Application
	ControlMove, Table Designer, DimX+300, DimY+50, 850, DimH-60, ahk_class C/SIDE Application
	ControlMove, Form Designer, DimX+300, DimY+50, 850, DimH-60, ahk_class C/SIDE Application
	ControlMove, Section Designer, DimX+300, DimY+50, 850, DimH-60, ahk_class C/SIDE Application
	ControlMove, C/AL Globals, DimX+260, DimY+50, DimW*.50, DimH*.33, ahk_class C/SIDE Application
	ControlMove, C/AL Locals, DimX+260, DimY+50, DimW*.50, DimH*.33, ahk_class C/SIDE Application

	;-------------Right-----------------------------
	ControlMove, C/AL Editor, DimX+1150, DimY+50, DimW*.40, DimH-60, ahk_class C/SIDE Application
	;ControlMove, Object Designer, DimX+1100, DimY+50, DimW*.33, DimH-60, ahk_class C/SIDE Application
	;ControlMove, Object Manager, DimX+1100, DimY+50, DimW*.33, DimH-60, ahk_class C/SIDE Application
return

^+NumpadAdd::
	SetTitleMatchMode, 2
	SetTitleMatchMode, Fast
	;SetControlDelay, 2 
	SetKeyDelay, 2
	WinActivate, ahk_class C/SIDE Application
	ControlGetFocus, FocusedClassNN, A
	ControlGetText, FocusedText, %FocusedClassNN%, ahk_class C/SIDE Application
	; Move down one line 
	;SendMessage, 0x115, 1, 0, %FocusedText%, ahk_class C/SIDE Application
	;ControlSend, %FocusedText%, Right, ahk_class C/SIDE Application
	;Ex#1+2 work: Send !{m} and Send !m 
	;Ex#3 does not work: Send {Alt}m
	Send !m
	;Send Right sends Right as text
	;Send {Right} sends Right Arrow
	Send {Right}
return
	
; Unapply
^+u::
	SetTitleMatchMode, 2
	SetTitleMatchMode, Fast
	;SetControlDelay, 2 
	SetKeyDelay, 2
	Sleep, 333
	;Send {Down}
	Send {Alt Down}
	Send {u}
	Send {u}
	Send {Alt Up}
	Sleep, 333
	Send !{u}
	Sleep, 333
	Send {y}
	Sleep, 333
	Send {Enter}
	return
; Reverse one
!^+r::
	;WinActivate, ahk_class C/SIDE Application
	;ControlGetPos, DimX, DimY, DimW, DimH, MDIClient1, ahk_class C/SIDE Application

	;ControlGetFocus, FocusedClassNN, ahk_class C/SIDE Application
	;ControlGetText, FocusedText, %FocusedClassNN%, ahk_class C/SIDE Application

	SetTitleMatchMode, 2
	SetTitleMatchMode, Fast
	;SetControlDelay, 2 
	SetKeyDelay, 2
	Send {Alt Down}
	Send {u}	
	Sleep, 333
	Send {r}
	Send {Alt Up}
	Sleep, 333
	Send {F11}
	Sleep, 333
	Send {Left}
	Sleep, 333
	Send {Enter} ;Respond yes
	Sleep, 333
	Send {Enter} ;Respond ok
	return
	
; Strip object of code
^+`::
	WinActivate, ahk_class C/SIDE Application
	ControlGetPos, DimX, DimY, DimW, DimH, MDIClient1, ahk_class C/SIDE Application

	ControlGetFocus, FocusedClassNN, ahk_class C/SIDE Application
	ControlGetText, FocusedText, %FocusedClassNN%, ahk_class C/SIDE Application

	Loop,1	
	{
	;Select Designer
	SetTitleMatchMode, 2
	SetTitleMatchMode, Fast
	SetKeyDelay, 100
	;design
	Send !{d}
	;global variables
	Send {Alt Down}
	Send {v}	
	Send {b}
	Send {Alt Up}

	;select all
	Send ^{a}
	Send {delete}
	Send {y}

	;tab 2
	Send ^{PgDn}
	Send ^{a}
	Send {delete}
	Send {y}

	;tab 3
	Send ^{PgDn}
	Send ^{a}
	Send {delete}
	Send {y}

	;Escape
	Send {Esc}

	WinWait, ahk_class C/SIDE Application, , 1000
	if ErrorLevel
	{
		MsgBox, WinWait timed out.
		return
	}
	else
		Sleep, 100
	
	;Delete Code
	Send {F9}
	Send ^{a}
	Send {delete}
	Send {y}
	Sleep, 333
	;Escape
	Send {Esc}
	;Escape and save
	Send {Esc}
	Send {y}
	;Send {down}
	}
	return

^+f::
	WinActivate, ahk_class C/SIDE Application
	ControlGetPos, DimX, DimY, DimW, DimH, MDIClient1, ahk_class C/SIDE Application

	ControlGetFocus, FocusedClassNN, ahk_class C/SIDE Application
	ControlGetText, FocusedText, %FocusedClassNN%, ahk_class C/SIDE Application
	if (FocusedText = "Object Designer")
		MsgBox Object Designer is in focus.
	return
	
	; Delete Languages
^+l::
	;InputBox, UserInput, Directory, Please enter a Directory.,
	FileDelete, C:\temp\Lang\*.flm
	WinActivate, ahk_class C/SIDE Application
	ControlGetPos, DimX, DimY, DimW, DimH, MDIClient1, ahk_class C/SIDE Application

	ControlGetFocus, FocusedClassNN, ahk_class C/SIDE Application
	ControlGetText, FocusedText, %FocusedClassNN%, ahk_class C/SIDE Application

	;Select Designer
	SetTitleMatchMode, 2
	SetTitleMatchMode, Fast
	SetKeyDelay, 2

	;ENU
	Send {Alt Down}
	Send {t}
	Send {g}	
	Send {e}
	Send {Alt Up}
	WinWait, ,Language Module Export
	ControlGetText, FocusedText, %FocusedClassNN%, ahk_class C/SIDE Application

	Send C:\temp\Lang\DeleteLanguage_ENU.flm
	Send {Down}
	Send ENU
	Send {Down}
	Send {Space}
	Send {Down}
	Send {Enter}
	Sleep, 333
	;WinWait, ,Object Designer, 120
	While WinExist("ahk_class C/SIDE Glued")
	{
		SplashTextOn, , , Processing.
		Sleep, 300
	}
	SplashTextOff
	If WinExist("ahk_class #32770") 
		Send {y}
	Sleep, 300
	ControlGetText, FocusedText, %FocusedClassNN%, ahk_class C/SIDE Application
	
	;ENC
	Send {Alt Down}
	Send {t}
	Send {g}	
	Send {e}
	Send {Alt Up}
	WinWait, ,Language Module Export
	ControlGetText, FocusedText, %FocusedClassNN%, ahk_class C/SIDE Application

	Send C:\temp\Lang\DeleteLanguage_ENC.flm
	Send {Down}
	Send ENC
	Send {Down}
	Send {Space}
	Send {Down}
	Send {Enter}
	Sleep, 333
	;WinWait, ,Object Designer, 120
	While WinExist("ahk_class C/SIDE Glued")
	{
		SplashTextOn, , , Processing.
		Sleep, 300
	}
	SplashTextOff
	If WinExist("ahk_class #32770") 
		Send {y}
	Sleep, 300
	ControlGetText, FocusedText, %FocusedClassNN%, ahk_class C/SIDE Application

	;FRC
	Send {Alt Down}
	Send {t}
	Send {g}	
	Send {e}
	Send {Alt Up}
	WinWait, ,Language Module Export
	ControlGetText, FocusedText, %FocusedClassNN%, ahk_class C/SIDE Application

	Send C:\temp\Lang\DeleteLanguage_FRC.flm
	Send {Down}
	Send FRC
	Send {Down}
	Send {Space}
	Send {Down}
	Send {Enter}
	Sleep, 333
	;WinWait, ,Object Designer, 120
	While WinExist("ahk_class C/SIDE Glued")
	{
		SplashTextOn, , , Processing.
		Sleep, 300
	}
	SplashTextOff
	If WinExist("ahk_class #32770") 
		Send {y}
	Sleep, 300
	ControlGetText, FocusedText, %FocusedClassNN%, ahk_class C/SIDE Application


	;ESM
	Send {Alt Down}
	Send {t}
	Send {g}	
	Send {e}
	Send {Alt Up}
	WinWait, ,Language Module Export
	ControlGetText, FocusedText, %FocusedClassNN%, ahk_class C/SIDE Application

	Send C:\temp\Lang\DeleteLanguage_ESM.flm
	Send {Down}
	Send ESM
	Send {Down}
	Send {Space}
	Send {Down}
	Send {Enter}
	Sleep, 333
	;WinWait, ,Object Designer, 120
	While WinExist("ahk_class C/SIDE Glued")
	{
		SplashTextOn, , , Processing.
		Sleep, 300
	}
	SplashTextOff
	If WinExist("ahk_class #32770") 
		Send {y}
	Sleep, 300
	ControlGetText, FocusedText, %FocusedClassNN%, ahk_class C/SIDE Application
	return	
	
	; Insert <code></code> or surround selected text with it
; -----------------------------------------------------------------------------
<^<+=::
	ClipboardOld = %Clipboard%
	clipboard = 
	Send, ^c
	ClipboardNew = %Clipboard%
	Sleep, 50
	If (ClipboardNew <> "")
	{
		Send <code></code>{Left 7}
		;Send {Enter}
		SendRaw %ClipboardNew%
		Send {Enter}
	}
	Else 
		Send <code></code>{Left 7}
		;Send {Enter}
		ClipBoard = %ClipboardOld%
		Send {Enter}
	Return
	
	

; Meta: Open AutoHotkey.ahk, Open ahk's help file, Open Window Spy, Auto-reload the running AutoHotkey script when you save it with CTRL+S in an editor
; -----------------------------------------------------------------------------
<^<+a::
	;Run "%Software%\Notepad++\notepad++.exe" %A_ScriptFullPath%
	Run, "%Programs386%\Notepad++\notepad++.exe" %A_ScriptFullPath%, C:\Program Files (x86)\Notepad++
	Return
 
<^<+j::
	Run hh.exe "%A_WorkingDir%\AutoHotkey.chm"
	WinWait, AutoHotkey_L Help
	WinMaximize
	Return
 
<^<+k::Run "C:\Program Files\AutoHotkey\AU3_Spy.exe"
 
~^s::
	SetTitleMatchMode 2
	IfWinActive, AutoHotkey.ahk
	{
		Sleep, 300
		ToolTip, Reloading AutoHotkey script........
		Sleep, 300
		Reload
	}
	Else Send ^s
	return
	

; change "4.2.1" to "4.2.2"
; actually "4.2.1" to "4.2.1.0.0.0.1"
;~^m::
;CurrentVersion := "4.2.1"
;CurrentVersionb := IncrementVersionNumber(CurrentVersion, 5)
;msgbox %CurrentVersion% changed to %CurrentVersionb%
;return

IncrementVersionNumber(whatversionstring, incwhatpart){
    ;stringsplit, vers, whatversionstring, .  ;<---- there is a period there
	stringsplit, vers, whatversionstring,;<---- there is a period there
    if(vers0 < incwhatpart){
        vers0 := incwhatpart
    }
    
    vers%incwhatpart%++
    newversionstring =
    loop, %vers0%{
        thisversion := vers%a_index%
        if(thisversion = ""){
            thisversion := "0"
        }
        newversionstring := newversionstring . thisversion
        if(a_index < vers0){
            newversionstring := newversionstring . "."
        }
    }
    return newversionstring
}


