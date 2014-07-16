; Variables definition
; -----------------------------------------------------------------------------
EnvGet, userProfile, USERPROFILE
;Software := userProfile . "\Dropbox\software\"
Programs386 := "c:\Program Files (x86)\"
;"I:\Navision\Assets\IT Assets\Scripts\Autohotkey\DragAndDrop.ahk"
DocTag := "???"

#Persistent
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
	Send --------------------------------------------------------------
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
		DocTag := "B" + UserInput
	
	InputBox, UserInput, Comment, Please enter a comment.,
	if ErrorLevel
	    MsgBox, CANCEL was pressed.
	else
		FormatTime, CurrentDate,,MM/dd/yy
		SetKeyDelay, 1  ; Smallest possible
		Send %DocTag% %CurrentDate%  DEK SRX00000  %UserInput%
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
		DocTag := "B" + UserInput
	
	InputBox, UserInput, Comment, Please enter a comment.,
	if ErrorLevel
	    MsgBox, CANCEL was pressed.
	else
		FormatTime, CurrentDate,,MM/dd/yy
		SetKeyDelay, 1  ; Smallest possible
		Send %DocTag% %CurrentDate%  DEK FRX00000  %UserInput%
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

^+.::
	;Send // ???_%A_YYYY%%A_MM%%A_DD% >>
	Send // %DocTag%_%A_YYYY%%A_MM%%A_DD% >>
	return

^+,::
	;Send // ???_%A_YYYY%%A_MM%%A_DD% <<
	Send // %DocTag%_%A_YYYY%%A_MM%%A_DD% <<
	return

^+\::
	; General comment
	InputBox, UserInput, Comment, Please enter a comment.,
	if ErrorLevel
	    MsgBox, CANCEL was pressed.
	else
		; FormatTime, CurrentDate,,MM/dd/yy
		SendInput //> %UserInput% <//		
	return
^+t::
	; To Do
		SendInput //> TODO <//		
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

!^+t::
	Send DEK_%A_YYYY%%A_MM%%A_DD%R
	return
	
^.::
	Send //>
	return

^,::
	Send //<
	return
	
^[::
	; Begin Region
	InputBox, UserInput, Comment, Please enter a comment.,
	if ErrorLevel
	    MsgBox, CANCEL was pressed.
	else
		; FormatTime, CurrentDate,,MM/dd/yy
		SendInput ^{$REGION '%UserInput%'}		
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
		;SendInput %UserInput%
		Send ^{h}
		Send ???
		Send {TAB}
		Send %UserInput%
		Send !{a}
		Send !{y}
		Send {ESC}
	return

^+/:: 
	;edit this line
	SetKeyDelay, 1  ; Smallest possible
	;Send //
	Send, {Home}
	Send, +{END}
	Send, ^c
	ClipWait, 0
	Send {Enter}
	IfWinActive, ahk_class #32770 
		Send {Enter}
	Gosub AddComments
	Send ^v
	;MsgBox Control-C copied the following contents to the clipboard:`n`n%clipboard%
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
	;MsgBox Control-C copied the following contents to the clipboard:`n`n%clipboard%
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

;-----------------------------------------------------------------------------
;--- SUB routines ------------------------------------------------------------
;-----------------------------------------------------------------------------
	AddComments:
		;Clipboard := "/*`n" . Clipboard . "`n*/" ; wrap with comments tag
		Clipboard := "// ???_20140605 >>" . Clipboard . "`n// ???_20140605 <<"
		StringReplace, Clipboard, Clipboard, `r`n,  `r`n//, All		
		;StringReplace, Clipboard, Clipboard, `r`n, `r`n, UseErrorLevel
		;	If ErrorLevel <= 10000 ; if 10000 or fewer lines
		;  	{
		;	  	;StringReplace, Clipboard, Clipboard, `r`n, `r`n//%A_Space%, All
		;		StringReplace, Clipboard, Clipboard, `r`n,  `r`n//, All
		;	  	If InStr(Clipboard, "`r`n") != 1
		;  			Clipboard := "//-" . Clipboard
		;	}
		return
	AddCommentsV2:
		; Initialize counter to keep track of our position in the string.
		Position := 0
		Loop, Parse, Clipboard, `n, `r 
		; Calculate the position of the B at the end of this field.
		Position += StrLen(A_LoopField) + 1
		;Delimiter := SubStr(Clipboard, Position, 1)
		Delimiter := Position
		if (A_Index = 1) { 
		Send, Index: %A_Index% Field: %A_LoopField%`nDelimiter: %Delimiter%
		} ELSE {
		Send, Index: %A_Index% Field: %A_LoopField%`nDelimiter: %Delimiter%
		}
		Send {Enter}
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

; Meta: Greenshot
; -----------------------------------------------------------------------------

~^+c::
	; Close Greenshot editor after copy
	IfWinActive, ahk_class WindowsForms10.Window.8.app.0.34a3b57_r11_ad1
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
SetTitleMatchMode, Fast
WinActivate, ahk_class C/SIDE Application
;ControlGetPos, DimX, DimY, DimW, DimH, MDIClient1, ahk_class C/SIDE Application
ControlGetFocus, FocusedClassNN, ahk_class C/SIDE Application
ControlGetText, FocusedText, %FocusedClassNN%, ahk_class C/SIDE Application
;PostMessage, 0x01, 0x00210000, 0x00000000, %FocusedText%, ahk_class C/SIDE Application
PostMessage, 0x01, 0x00210000, 0x00000000, MDIClient1, ahk_class C/SIDE Application
;%FocusedClassNN%
MsgBox Sending message to "%FocusedText%"
;SendMessage, 0x115, 1, 0, %FocusedText%, ahk_class C/SIDE Application
;SendMessage, 0x115, 1, 0, Object Designer, ahk_class C/SIDE Application
;PostMessage, 0x46, Object Designer, HWND_TOP, 133, 19, 1501, 867 C/SIDE SubForm1, ahk_class C/SIDE Application
;PostMessage, 0x01,0x0014e9e8,0x00e50000,0x0000ff01,

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
; Make BIG
;Example: ControlMove, , Pos x(l to r), Pos y (t to b), Size W, Size H, ahk_class C/SIDE Application
SetTitleMatchMode, 2
SetTitleMatchMode, Fast
WinActivate, ahk_class C/SIDE Application
ControlGetPos, DimX, DimY, DimW, DimH, MDIClient1, ahk_class C/SIDE Application

ControlGetFocus, FocusedClassNN, ahk_class C/SIDE Application
ControlGetText, FocusedText, %FocusedClassNN%, ahk_class C/SIDE Application
if (FocusedText = "Object Manager")
	return
ControlMove, %FocusedText%, DimX+10, DimY+50, DimW*.99, DimH-60, ahk_class C/SIDE Application
return


^+NumpadMult::
SetTitleMatchMode, 2
SetTitleMatchMode, Fast
WinActivate, ahk_class C/SIDE Application
ControlGetPos, DimX, DimY, DimW, DimH, MDIClient1, ahk_class C/SIDE Application
;ControlMove, _________, DimX+10, DimY+50, DimW-100, DimH-60, 

;-------------Left-----------------------------
ControlMove, Properties, DimX+10, DimY+50, DimW*.15, DimH-60, ahk_class C/SIDE Application

;-------------Middle-----------------------------
ControlGetFocus, FocusedClassNN, ahk_class C/SIDE Application
ControlGetText, FocusedText, %FocusedClassNN%, ahk_class C/SIDE Application
ControlMove, %FocusedText%, DimX+10, DimY+10, DimW*.50, DimH-400, ahk_class C/SIDE Application

ControlMove, Table Designer, DimX+260, DimY+50, DimW*.85, DimH-60, ahk_class C/SIDE Application
ControlMove, Form Designer, DimX+260, DimY+50, DimW*.85, DimH-60, ahk_class C/SIDE Application
ControlMove, Section Designer, DimX+260, DimY+50, DimW*.85, DimH-60, ahk_class C/SIDE Application
ControlMove, C/AL Globals, DimX+260, DimY+50, DimW*.85, DimH*.33, ahk_class C/SIDE Application
ControlMove, C/AL Locals, DimX+260, DimY+50, DimW*.85, DimH*.33, ahk_class C/SIDE Application
ControlMove, C/AL Editor, DimX+260, DimY+50, DimW*.85, DimH-60, ahk_class C/SIDE Application
;ControlMove, Object Designer, DimX+260, DimY+50, DimW*.85, DimH-60, ahk_class C/SIDE Application
;ControlMove, Object Manager, DimX+260, DimY+50, DimW*.85, DimH-60, ahk_class C/SIDE Application

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
ControlMove, Table Designer, DimX+260, DimY+50, 400, DimH-60, ahk_class C/SIDE Application
ControlMove, Form Designer, DimX+260, DimY+50, DimW*.50, DimH-60, ahk_class C/SIDE Application
ControlMove, Section Designer, DimX+260, DimY+50, 850, DimH-60, ahk_class C/SIDE Application
ControlMove, C/AL Globals, DimX+260, DimY+50, DimW*.50, DimH*.33, ahk_class C/SIDE Application
ControlMove, C/AL Locals, DimX+260, DimY+50, DimW*.50, DimH*.33, ahk_class C/SIDE Application

;-------------Right-----------------------------
ControlMove, C/AL Editor, DimX+1100, DimY+50, DimW*.33, DimH-60, ahk_class C/SIDE Application
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

^+5::
;WM_NCCALCSIZE ??
;WM_WINDOWPOSCHANGING = WM_WINDOWPOSCHANGING = 0x46
DetectHiddenWindows, on
SetTitleMatchMode, 2
SetTitleMatchMode, Fast
WinActivate, ahk_class C/SIDE Application
ControlGetFocus, FocusedClassNN, A
ControlGetText, FocusedText, %FocusedClassNN%, ahk_class C/SIDE Application
MsgBox Posting message to "%FocusedClassNN%"
; Move down one line 
;SendMessage, 0x115, 1, 0, %FocusedText%, ahk_class C/SIDE Application
;SendMessage, 0x115, 1, 0, Object Designer, ahk_class C/SIDE Application
PostMessage, 0x46, %FocusedClassNN%, HWND_TOP, 133, 19, 1501, 867 C/SIDE SubForm1, ahk_class C/SIDE Application
return

^+6::
;WM_NCCALCSIZE ??
;WM_WINDOWPOSCHANGING = WM_WINDOWPOSCHANGING = 0x46
DetectHiddenWindows, on
SetTitleMatchMode, 2
SetTitleMatchMode, Fast
WinActivate, ahk_class C/SIDE Application
ControlGetFocus, FocusedClassNN, A
ControlGetText, FocusedText, %FocusedClassNN%, ahk_class C/SIDE Application
MsgBox Sending message to "%FocusedText%"
SendMessage, 0x115, 1, 0, %FocusedText%, ahk_class C/SIDE Application
return

^+7::
;WM_NCCALCSIZE ??
;WM_WINDOWPOSCHANGING = WM_WINDOWPOSCHANGING = 0x46
DetectHiddenWindows, on
SetTitleMatchMode, 2
SetTitleMatchMode, Fast
WinActivate, ahk_class C/SIDE Application
ControlGetPos, DimX, DimY, DimW, DimH, MDIClient1, ahk_class C/SIDE Application

;ControlMove, _________, DimX+10, DimY+50, DimW-100, DimH-60, 
;-------------Left-----------------------------
ControlMove, Properties, DimX+10, DimY+50, DimW*.15, DimH-60, ahk_class C/SIDE Application
;-------------Middle-----------------------------
ControlMove, Table Designer, DimX+260, DimY+50, 400, DimH-60, ahk_class C/SIDE Application
ControlMove, Form Designer, DimX+260, DimY+50, DimW*.50, DimH-60, ahk_class C/SIDE Application
ControlMove, Section Designer, DimX+260, DimY+50, 850, DimH-60, ahk_class C/SIDE Application
;-------------Right-----------------------------
ControlMove, C/AL Editor, DimX+1100, DimY+50, DimW*.33, DimH-60, ahk_class C/SIDE Application
;ControlMove, Object Designer, DimX+1100, DimY+50, DimW*.33, DimH-60, ahk_class C/SIDE Application
;ControlMove, Object Manager, DimX+1100, DimY+50, DimW*.33, DimH-60, ahk_class C/SIDE Application
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
	
; Reverse
^+`::
	WinActivate, ahk_class C/SIDE Application
	ControlGetPos, DimX, DimY, DimW, DimH, MDIClient1, ahk_class C/SIDE Application

	ControlGetFocus, FocusedClassNN, ahk_class C/SIDE Application
	ControlGetText, FocusedText, %FocusedClassNN%, ahk_class C/SIDE Application

	Loop,28	
	{
	;Unapply
	SetTitleMatchMode, 2
	SetTitleMatchMode, Fast
	;SetControlDelay, 2 
	SetKeyDelay, 2
	Sleep, 333y
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
	WinWait, ahk_class C/SIDE Application, , 1000
	if ErrorLevel
	{
		MsgBox, WinWait timed out.
		return
	}
	else
		Sleep, 100
	
	;Reverse
	Send {Alt Down}
	Send {u}	
	Sleep, 333
	Send {r}
	Send {Alt Up}
	Sleep, 333
	Send {F11}
	WinWait, ahk_class C/SIDE Application, , 1000
	if ErrorLevel
	{
		MsgBox, WinWait timed out.
		return
	}
	else
		Sleep, 100
	Send {Left}
	Sleep, 333
	Send {Enter} ;Respond yes
	Sleep, 333
	Send {Enter} ;Respond ok
	Sleep, 333
	Send {Down}
	Sleep, 333
	}
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
 
;<^<+j::
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
	Else SendInput ^s
	return
	

; change "4.2.1" to "4.2.2"
; actually "4.2.1" to "4.2.1.0.0.0.1"
~^m::
	CurrentVersion := "4.2.1"
CurrentVersionb := IncrementVersionNumber(CurrentVersion, 5)
msgbox %CurrentVersion% changed to %CurrentVersionb%
return
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
