#NoEnv  
SendMode Input
SetWorkingDir %A_ScriptDir% 
#SingleInstance force
#InstallKeybdHook
Title=MyWindowSpy
RefreshRate=600
Menu, Tray, Icon,c:\windows\system32\SHELL32.dll,176, 1
IniRead, HotKey, %A_ScriptDir%\mywindowspy.ini ,Main, HotKey,%A_Space%
if (Hotkey="")
   {
   Gosub ChooseNewHotKey
   }
else
   {
   Hotkey, %HotKey%, ChosenHotKey
   }
SplashTextOn , 300, 30, Widows Spy, Press %HotKey% with mouse over Gui
MouseButtons=LButton,MButton,RButton,XButton1,XButton2,WheelDown,WheelUp,WheelLeft,WheelRight
Loop  
   {
   B_index:=A_index
   GetKeyState, Name, %A_Index%JoyName
   if (Name <> null) 
      { 
      GetKeyState, Buttons, %B_index%JoyButtons
      Loop %Buttons%
         {
         ThisJoy=%B_Index%Joy%A_index%,
         JoyButtons .= ThisJoy
         }
      GetKeyState, Axis,%B_index%JoyInfo
      AxisNo :=StrLen(Axis)
      JoyButtons.=B_Index . "JoyX," . B_index . "JoyY,"
      Loop %AxisNo%
         {
         JoyType:=SubStr(Axis, A_index ,1)
         if (Joytype="P")
            {
            JoyType=Pov
            }
         if (JoyType<>"D") and (JoyType<>"C")
            {
            ThisJoy=%B_Index%Joy%JoyType%,
            JoyButtons .= ThisJoy
            }
         }
      }
   Else
      {
      break
      }
   }
sleep 2000
splashtextOff
return
findparm:
SelectThis=Select * from Win32_Process
for process in ComObjGet("winmgmts:").ExecQuery(SelectThis)
   {
   Pid:=% process.ProcessId
   Cmd%Pid%:=% process.CommandLine
   Name%Pid%:=% process.Name
   ProcessTime :=( (process.KernelModeTime) + (process.UserModeTime)) / 10000000
   sngProcessTime%Pid%:=ProcessTime
   state%Pid%:=process.ExecutionState
   ExecutablePath%Pid%:=process.ExecutablePath
   PageFaults%Pid%:=process.PageFaults
   PageFileUsage%Pid%:=process.PageFileUsage
   PeakWorkingSetSize%Pid%:=process.PeakWorkingSetSize
   QuotaNonPagedPoolUsage%Pid%:=process.QuotaNonPagedPoolUsage
   QuotaPagedPoolUsage%Pid%:=process.QuotaPagedPoolUsage
   ThreadCount%Pid%:=process.ThreadCount
   WorkingSetSize%Pid%:=process.WorkingSetSize
   Priority%Pid%:=process.Priority
   }
return
ChosenHotKey:
SetTimer, TipIt, %RefreshRate%
gosub findparm
poson=1
gui ,destroy
Gui,Color,0xF6FFFF,0xFFFFE6
Menu,FileMenu, Add,Sleep,Sleep
Menu,FileMenu, Add,Exit,Exit
Menu,RateMenu,Add,100,ChooseRate
Menu,RateMenu,Add,200,ChooseRate
Menu,RateMenu,Add,300,ChooseRate
Menu,RateMenu,Add,400,ChooseRate
Menu,RateMenu,Add,500,ChooseRate
Menu,RateMenu,Add,600,ChooseRate
Menu,RateMenu,Check,600
Menu,RateMenu,Add,700,ChooseRate
Menu,RateMenu,Add,800,ChooseRate
Menu,RateMenu,Add,900,ChooseRate
Menu,OptionsMenu, Add,HotKey,ChooseNewHotKey
Menu,OptionsMenu,Add,&Refresh Rate,:RateMenu
Menu,HelpMenu, Add,Help,Help
Menu,HelpMenu, Add,About,About
Menu,MyMenuBar,Add,&File,:FileMenu
Menu,MyMenuBar,Add,&Options,:OptionsMenu
Menu,MyMenuBar,Add,&Help,:HelpMenu
Gui,Menu,MyMenuBar
Gui, Add, StatusBar,,
SB_SetParts(400,100)
DetectHiddenText, On
Gui, Add, Text,x0 y5,Key:=
PriorKeyString:="|" . A_PriorKey . "|| Name:=" . GetKeyName(A_PriorKey) . "| Key Value:=" . GetKeyVK(A_PriorKey) . " | Scan Code:=" . GetKeySC(A_PriorKey) . "|" 
Gui, Add, DropDownList,x+2 y0 w65 cNavy vPriorKeyString, %PriorKeyString%
Gui, Add, Text,x+2 y5,Mouse:=
Gui, Add, Text,x+2 y5 w65 cNavy vPriorMouse, 
Gui, Add, DropDownList,x+2 y0 w100 cNavy vXYinfo, Mouse Window||Mouse Client|Mouse Screen|Caret Window|Caret Client|Caret Screen|
Gui, Add, Text,x+2 y5,X:=
Gui, Add, Text,x+2 y5 w30 cNavy vwx,
Gui, Add, Text,x+2 y5,Y:=
Gui, Add, Text,x+2 y5 w30 cNavy vwy,
Gui, Add, Text,x+2 y5 w10 vdemocol,▇
Gui, Add, Text,x+2 y5 w60 cNavy vpixcol,
SetTimer, MouseState, 100
Gui, Add, Text,x+2 y5,Joystick:=
Gui, Add, Text,x+2 y5 w80 cNavy vPriorJoy,
SetTimer, JoyState, 100
Gui, Add, Text,x+2 y5,Cursor:=
Gui, Add, Text,x+2 y5 w50 cNavy vCursor,
MouseGetPos, , , id_m, control
Gui, Add, Text,x+2 y5,Over:=
Gui, Add, DropDownList,x+2 y0 w65 cNavy vMouseOver,ID||Ctrl_Hwnd|ClassNN|
Gui,Add,Text,x+2 y5 vOverResult w90 cNavy,
Gui, Add, Text,x432 y0 w10 cRed,▇
Gui, Add, Text,x+1 y0 w10 c0x00FF00,▇
Gui, Add, Text,x+1 y0 w10 cBlue,▇
gosub monitor
Gui, Add, Button,x+2 y25 gMsgMonitor,Msg Monitor
Gui, Add, Button,x+2 y25 gSleep,Sleep
Gui, Add, TreeView , w600 h100 x0 y50 vtree cNavy 
WinGet,P1_id#, List,ahk_id %id_m%
Loop, %P1_id#%
   {
   P1_id :=P1_id#%A_Index%
   WinGetTitle, P1_Title, ahk_id %P1_id%
   WinActivate, ahk_id %P1_id%
   C1:=a_index
   WinGetClass, P1_Class, ahk_id %P1_id%
   ;P1 := TV_Add("Control Hwnd Parent Seq: " A_index " Hwnd " P1_id " Title: " P1_Title " Class: " P1_Class, ,"Bold")
   P1 := TV_Add("Control Hwnd Parent Seq: " A_index " Hwnd " P1_id " Title: " P1_Title " Class: " P1_Class,0,"Bold")    
   WinGet ControlList,ControlList , ahk_id %P1_id%
   if (ErrorLevel=0)
      {
      P1C%C1% := TV_Add("Control List: for Hwnd" P1_id,P1) 
      Loop, parse, ControlList, `n, `r
         {
         StringReplace, Thistext, A_LoopField, `n`r, , All
         TV_Add(Thistext, P1C%C1%) 
         }
      }
   else
      {
      TV_Add("No Controls in This Control",P1) 
      }
   WinGet, P1_Pid,Pid, ahk_id %P1_id%
   P1C%C1% := TV_Add( "Process Details for Process (Pid): " P1_Pid,P1 )
   Thiscmd:=Cmd%P1_Pid%
   TV_Add("Process Command line: " Thiscmd ,P1C%C1%  ) 
   ThisName:=name%P1_Pid%
   TV_Add("Process Name: " ThisName,P1C%C1%) 
   ThisTime:=sngProcess%P1_Pid%
   TV_Add("Process Time: " ThisTime,P1C%C1%) 
   ThisState:=state%P1_Pid%
   TV_Add("Process State: " ThisState,P1C%C1%) 
   ThisExecutablePath:=ExecutablePath%P1_Pid%
   TV_Add("Process ExecutablePath: " ThisExecutablePath,P1C%C1%) 
   ThisPageFaults:=PageFaults%P1_Pid%
   TV_Add("Process Page Faults: " ThisPageFaults,P1C%C1%) 
   ThisPageFileUsage:=PageFileUsage%P1_Pid%
   TV_Add("Process Page File Usage: " ThisPageFileUsage,P1C%C1%) 
   ThisPeakWorkingSetSize:=PeakWorkingSetSize%P1_Pid%
   TV_Add("Process Peak Working Set Size: " ThisPeakWorkingSetSize,P1C%C1%) 
   ThisQuotaNonPagedPoolUsage:=QuotaNonPagedPoolUsage%P1_Pid%
   TV_Add("Process Quota Non Paged Pool Usage: " ThisQuotaNonPagedPoolUsage,P1C%C1%) 
   ThisQuotaPagedPoolUsage:=QuotaPagedPoolUsage%P1_Pid%
   TV_Add("Process Quota Paged Pool Usage: " ThisQuotaPagedPoolUsage,P1C%C1%) 
   ThisThreadCount:=ThreadCount%P1_Pid%
   TV_Add("Process Thread Count: " ThisThreadCount,P1C%C1%) 
   ThisWorkingSetSize:=WorkingSetSize%P1_Pid%
   TV_Add("Process Working Set Size: " ThisWorkingSetSize,P1C%C1%) 
   ThisPriority:=Priority%P1_Pid%
   TV_Add("Process Priority: " ThisPriority,P1C%C1%) 
   P1C%C1% := TV_Add("Position and Style", P1) 
   WinGet ExStyle,ExStyle , ahk_id %P1_id%
   TV_Add("ExStyle " ExStyle, P1C%C1%) 
   WinGet Style,Style , ahk_id %P1_id%
   TV_Add("Style " Style, P1C%C1%) 
   WinGet TransColor,TransColor , ahk_id %P1_id%
   TV_Add("TransColour " TransColor, P1C%C1%) 
;   WinGet Region,Region , ahk_id %P1_id%
;   TV_Add("Region " Region, P1C%C1%) 
   WinGet Transparent,Transparent , ahk_id %P1_id%
   TV_Add("Transparent " Transparent, P1C%C1%) 
   WinGet MinMax,MinMax , ahk_id %P1_id%
   TV_Add("MinMax " MinMax, P1C%C1%) 
   WinGetPos , X_ms, Y_ms, W_ms, H_ms, ahk_id %P1_id%
   TV_Add("Position X: " X_ms " Y:" Y_ms " W: " W_ms " H: " H_ms, P1C%C1%) 
   ControlGetText, Thistext, ,ahk_id %P1_id%
   if (ErrorLevel=0)
      {
      StringLen,ThisLen, Thistext
      P1C%C1% := TV_Add("This Controls Visable Text (Length= " ThisLen ")" , P1) 
      Loop, parse, Thistext, `n, `r
         {
         StringReplace, Thistext_sub, A_LoopField, `n`r, , All
         TV_Add(Thistext_sub , P1C%C1%) 
         }
      }
   StatusBarGetText, sbtext, 1, ahk_id %P1_id%
   if (ErrorLevel=0)
      {
      P1C%C1% := TV_Add("Status Bar " , P1) 
      loop
         {
         StatusBarGetText, sbtext, A_index, ahk_id %P1_id%
         if (errorlevel=0)
            {
            TV_Add("(" A_index "): " sbtext , P1C%C1%) 
            }
         } until (errorlevel=1)
      }
   else
      {
      TV_Add("No Status Bar " , P1) 
      }
   WinGet,hwnd_msub, ControlListHwnd,ahk_id %P1_id%
   Loop, parse, hwnd_msub, `n, `r
      {
      StringReplace, P1Seq_id, A_LoopField, `n`r, , All
      WinGetTitle, ThisTitle, ahk_id %P1Seq_id%
      WinGetClass, ThisClass, ahk_id %P1Seq_id%
      P1C%C1% := TV_Add("Control Hwnd Child Seq: " A_index " Hwnd " P1Seq_id " Title: " ThisTitle " Class: " ThisClass, P1, "Bold") 
      WinGet ControlList,ControlList , ahk_id %P1Seq_id%
      if (ErrorLevel=0)
         {
         P1C%C1%C%C2% := TV_Add("Control List: for Hwnd" P1_id,P1C%C1%) 
         Loop, parse, ControlList, `n, `r
            {
            StringReplace, Thistext, A_LoopField, `n`r, , All
            TV_Add(Thistext, P1C%C1%C%C2%) 
            }
         }
      else
         {
         TV_Add("No Controls in This Control",P1C%C1%) 
         }
      WinGet, ThisPid,Pid, ahk_id %P1Seq_id%
      if (P1_Pid<>ThisPid)
         {
         P1C%C1%C%C2% := TV_Add("Process Details for Process (Pid): " ThisPid, P1C%C1%) 
         Thiscmd:=Cmd%ThisPid%
         TV_Add("Process Command line: " Thiscmd ,P1C%C1%C%C2%) 
         ThisName:=name%ThisPid%
         TV_Add("Process Name: " ThisName,P1C%C1%C%C2%) 
         ThisTime:=sngProcess%ThisPid%
         TV_Add("Process Time: " ThisTime,P1C%C1%C%C2%) 
         ThisState:=state%ThisPid%
         TV_Add("Process State: " ThisState,P1C%C1%C%C2%) 
         ThisExecutablePath:=ExecutablePath%ThisPid%
         TV_Add("Process ExecutablePath: " ThisExecutablePath,P1C%C1%C%C2%) 
         ThisPageFaults:=PageFaults%ThisPid%
         TV_Add("Process Page Faults: " ThisPageFaults,P1C%C1%C%C2%) 
         ThisPageFileUsage:=PageFileUsage%ThisPid%
         TV_Add("Process Page File Usage: " ThisPageFileUsage,P1C%C1%C%C2%) 
         ThisPeakWorkingSetSize:=PeakWorkingSetSize%ThisPid%
         TV_Add("Process Peak Working Set Size: " ThisPeakWorkingSetSize,P1C%C1%C%C2%) 
         ThisQuotaNonPagedPoolUsage:=QuotaNonPagedPoolUsage%ThisPid%
         TV_Add("Process Quota Non Paged Pool Usage: " ThisQuotaNonPagedPoolUsage,P1C%C1%C%C2%) 
         ThisQuotaPagedPoolUsage:=QuotaPagedPoolUsage%ThisPid%
         TV_Add("Process Quota Paged Pool Usage: " ThisQuotaPagedPoolUsage,P1C%C1%C%C2%) 
         ThisThreadCount:=ThreadCount%ThisPid%
         TV_Add("Process Thread Count: " ThisThreadCount,P1C%C1%C%C2%) 
         ThisWorkingSetSize:=WorkingSetSize%ThisPid%
         TV_Add("Process Working Set Size: " ThisWorkingSetSize,P1C%C1%C%C2%) 
         ThisPriority:=Priority%ThisPid%
         TV_Add("Process Priority: " ThisPriority,P1C%C1%C%C2%) 
         }
      else
         {
         TV_Add("Same Process as Parent: ", P1C%C1%) 
         }
      P1C%C1%C%C2% := TV_Add("Position and Style", P1C%C1%) 
      WinGet ExStyle,ExStyle , ahk_id %P1Seq_id%
      TV_Add("ExStyle " ExStyle, P1C%C1%C%C2%) 
      WinGet Style,Style , ahk_id %P1Seq_id%
      TV_Add("Style " Style, P1C%C1%C%C2%) 
      WinGet TransColor,TransColor , ahk_id %P1Seq_id%
      TV_Add("TransColour " TransColor, P1C%C1%C%C2%) 
;      WinGet Region,Region , ahk_id %P1Seq_id%
;      TV_Add("Region " Region, P1C%C1%C%C2%) 
      WinGet Transparent,Transparent , ahk_id %P1Seq_id%
      TV_Add("Transparent " Transparent, P1C%C1%C%C2%) 
      WinGet MinMax,MinMax , ahk_id %P1Seq_id%
      TV_Add("MinMax " MinMax, P1C%C1%C%C2%) 
      WinGetPos , X_ms, Y_ms, W_ms, H_ms, ahk_id %P1Seq_id%
      TV_Add("Position X: " X_ms " Y:" Y_ms " W: " W_ms " H: " H_ms, P1C%C1%C%C2%) 
      ControlGetText, Thistext, ,ahk_id %P1Seq_id%
      if (ErrorLevel=0)
         {
         StringLen,ThisLen, Thistext
         P1C%C1%C%C2% := TV_Add("This Controls Visable Text (Length= " ThisLen ") for hwnd " P1Seq_id  , P1C%C1%) 
         Loop, parse, Thistext, `n, `r
            {
            StringReplace, Thistext_sub, A_LoopField, `n`r, , All
            TV_Add(Thistext_sub , P1C%C1%C%C2%) 
            }
         }
      StatusBarGetText, sbtext, 1, ahk_id %P1Seq_id%
      if (ErrorLevel=0)
         {
         P1C%C1%C%C2% := TV_Add("Status Bar " , P1C%C1%) 
         loop
            {
            StatusBarGetText, sbtext, A_index, ahk_id %P1Seq_id%
            if (errorlevel=0)
               {
               TV_Add("(" A_index "): " sbtext , P1C%C1%C%C2%) 
               }
            } until (errorlevel=1)
         }
      else
         {
         TV_Add("No Status Bar " , P1C%C1%) 
         }
      WinGet,hwnd_msub_sub, ControlListHwnd,ahk_id %P1Seq_id%
      Loop, parse, hwnd_msub_sub, `n, `r
         {
         StringReplace, P1Seq_idsub, A_LoopField, `n`r, , All
         WinGetTitle, ThisTitlesub, ahk_id %P1Seq_idsub%
         WinGetClass, ThisTitlesubClass, ahk_id %P1Seq_idsub%
         TV_Add("Control Hwnd Childs Children Seq: " A_index " Hwnd " P1Seq_idsub " Title: " ThisTitlesub " Class:" ThisTitlesubClass , P1C%C1%,"bold") 
         }
      }
   }
ItemID:=TV_GetNext()
TV_Modify(ItemID, "Expand")
Gui +Resize 
gui ,show,NA,%Title%
Gui ,+AlwaysOnTop -LastFound
return
monitor:
MonitorString=
SysGet, MonitorCount, MonitorCount
SysGet, MonitorPrimary, MonitorPrimary
Loop, %MonitorCount%
   {
    SysGet, MonitorName, MonitorName, %A_Index%
    SysGet, Monitor, Monitor, %A_Index%
    SysGet, MonitorWorkArea, MonitorWorkArea, %A_Index%
   LineText=No: %A_Index% Name: %MonitorName% Left: %MonitorLeft% (%MonitorWorkAreaLeft% work) Top: %MonitorTop% (%MonitorWorkAreaTop% work) Right: %MonitorRight% (%MonitorWorkAreaRight% work) Bottom: %MonitorBottom% (%MonitorWorkAreaBottom% work)|
   MonitorString.=LineText
   if (MonitorPrimary=A_index)
      {
      MonitorString.="|"
      }
   }
Gui,Add,Text,x0 y30,Monitors:-Main(%MonitorPrimary%)W=%A_ScreenWidth% &&  H=%A_ScreenHeight% 
Gui, Add, DropDownList,X172 y25 w560 cNavy vDropx,%MonitorString%
Return
TipIt:
CoordMode, Mouse, Screen
MouseGetPos, sx, sy
CoordMode, Mouse, Window
MouseGetPos, wx, wy
PixelGetColor, pixcol,%wx%, %wy% ,RGB
CoordMode, Mouse, Client
MouseGetPos, cx, cy
CoordMode, Caret, Screen
scx:=A_CaretX
scy:=A_CaretY
CoordMode, Caret, Window
wcx:=A_CaretX
wcy:=A_CaretY
CoordMode, Caret, Client
ccx:=A_CaretX
ccy:=A_CaretY

PriorKeyString:="|" . A_PriorKey . "|| Name:=" . GetKeyName(A_PriorKey) . "| Key Value:=" . GetKeyVK(A_PriorKey) . " | Scan Code:=" . GetKeySC(A_PriorKey) . "|" 
GuiControl, , PriorKeyString,%PriorKeyString%
Gui, Font,  c%pixcol%
GuiControl,Font , democol
Gui, Font,  cBlack
GuiControl, , pixcol,%pixcol%
GuiControlGet,XYinfo
if (XYinfo="Mouse Window")
   {
   GuiControl, , wx,%wx%
   GuiControl, , wy,%wy%
   }
if (XYinfo="Mouse Client")
   {
   GuiControl, , wx,%cx%
   GuiControl, , wy,%cy%
   }
if (XYinfo="Mouse Screen")
   {
   GuiControl, , wx,%sx%
   GuiControl, , wy,%sy%
   }
if (XYinfo="Caret Window")
   {
   GuiControl, , wx,%wcx%
   GuiControl, , wy,%wcy%
   }
if (XYinfo="Caret Client")
   {
   GuiControl, , wx,%ccx%
   GuiControl, , wy,%ccy%
   }
if (XYinfo="Caret Screen")
   {
   GuiControl, , wx,%scx%
   GuiControl, , wy,%scy%
   }
GuiControl, , cursor,%A_Cursor%
GuiControlGet,MouseOver
if (MouseOver="ID")
   {
   MouseGetPos, , ,OverResult
   GuiControl, , OverResult,%OverResult%
   tooltip %resultover%
   }
if (MouseOver="ClassNN")
   {
   MouseGetPos, , , ,OverResult
   GuiControl, , OverResult,%OverResult%
   tooltip %resultover%
   }
if (MouseOver="Ctrl_Hwnd")
   {
   MouseGetPos, , , ,OverResult,2
   GuiControl, , OverResult,%OverResult%
   tooltip %resultover%
   }
return
GuiSize:
TreeHeight:=A_GuiHeight - 70
GuiControl, Move, tree, w%A_GuiWidth% h%TreeHeight%
return
MouseState:
Loop, parse, MouseButtons, `,
   {
   if GetKeyState(A_LoopField)
      {
      GuiControl ,,PriorMouse,%A_LoopField%
      }
   } 
Return
JoyState:
Loop, parse, JoyButtons, `,
   {
   JoyState:=GetKeyState(A_LoopField)
   OldState:=JoyState%A_LoopField%
   if (JoyState<>OldState )
      {
      GuiControl ,,PriorJoy,%A_LoopField%=%JoyState%
      JoyState%A_LoopField%:=JoyState
      }
   } 
Return
Sleep:
reload
Return
Exit:
GuiClose:
ExitApp
Return
MsgMonitor:
Gosub GetMsgRef
Gui, 2:Add, ComboBox, vMsgChoice w200 , %MsgRef%
Gui,2:Add,Button,gMsgChosen x+2 yp+0,Start
Gui,2:Show
Gui ,2: +AlwaysOnTop
Return
GetMsgRef:
MsgRef=
(
WM_NULL = 0x00|
WM_CREATE = 0x01|
WM_DESTROY = 0x02|
WM_MOVE = 0x03|
WM_SIZE = 0x05|
WM_ACTIVATE = 0x06|
WM_SETFOCUS = 0x07|
WM_KILLFOCUS = 0x08|
WM_ENABLE = 0x0A|
WM_SETREDRAW = 0x0B|
WM_SETTEXT = 0x0C|
WM_GETTEXT = 0x0D|
WM_GETTEXTLenGTH = 0x0E|
WM_PAINT = 0x0F|
WM_CLOSE = 0x10|
WM_QUERYENDSESSION = 0x11|
WM_QUIT = 0x12|
WM_QUERYOPEN = 0x13|
WM_ERASEBKGND = 0x14|
WM_SYSCOLORCHANGE = 0x15|
WM_ENDSESSION = 0x16|
WM_SYSTEMERROR = 0x17|
WM_SHOWWINDOW = 0x18|
WM_CTLCOLOR = 0x19|
WM_WININICHANGE = 0x1A|
WM_SETTINGCHANGE = 0x1A|
WM_DEVMODECHANGE = 0x1B|
WM_ACTIVATEAPP = 0x1C|
WM_FONTCHANGE = 0x1D|
WM_TIMECHANGE = 0x1E|
WM_CANCELMODE = 0x1F|
WM_SETCURSOR = 0x20|
WM_MOUSEACTIVATE = 0x21|
WM_CACTIVATE = 0x22|
WM_QUEUESYNC = 0x23|
WM_GETMINMAXINFO = 0x24|
WM_PAINTICON = 0x26|
WM_ICONERASEBKGND = 0x27|
WM_NEXTDLGCTL = 0x28|
WM_SPOOLERSTATUS = 0x2A|
WM_DRAWITEM = 0x2B|
WM_MEASUREITEM = 0x2C|
WM_DELETEITEM = 0x2D|
WM_VKEYTOITEM = 0x2E|
WM_CHARTOITEM = 0x2F|
WM_SETFONT = 0x30|
WM_GETFONT = 0x31|
WM_SETHOTKEY = 0x32|
WM_GETHOTKEY = 0x33|
WM_QUERYDRAGICON = 0x37|
WM_COMPAREITEM = 0x39|
WM_COMPACTING = 0x41|
WM_WINDOWPOSCHANGING = 0x46|
WM_WINDOWPOSCHANGED = 0x47|
WM_POWER = 0x48|
WM_COPYDATA = 0x4A|
WM_CANCELJOURNAL = 0x4B|
WM_NOTIFY = 0x4E|
WM_INPUTLANGCHANGEREQUEST = 0x50|
WM_INPUTLANGCHANGE = 0x51|
WM_TCARD = 0x52|
WM_HELP = 0x53|
WM_USERCHANGED = 0x54|
WM_NOTIFYFORMAT = 0x55|
WM_CONTEXTMENU = 0x7B|
WM_STYLECHANGING = 0x7C|
WM_STYLECHANGED = 0x7D|
WM_DISPLAYCHANGE = 0x7E|
WM_GETICON = 0x7F|
WM_SETICON = 0x80|
WM_NCCREATE = 0x81|
WM_NCDESTROY = 0x82|
WM_NCCALCSIZE = 0x83|
WM_NCHITTEST = 0x84|
WM_NCPAINT = 0x85|
WM_NCACTIVATE = 0x86|
WM_GETDLGCODE = 0x87|
WM_NCMOUSEMOVE = 0xA0|
WM_NCLBUTTONDOWN = 0xA1|
WM_NCLBUTTONUP = 0xA2|
WM_NCLBUTTONDBLCLK = 0xA3|
WM_NCRBUTTONDOWN = 0xA4|
WM_NCRBUTTONUP = 0xA5|
WM_NCRBUTTONDBLCLK = 0xA6|
WM_NCMBUTTONDOWN = 0xA7|
WM_NCMBUTTONUP = 0xA8|
WM_NCMBUTTONDBLCLK = 0xA9|
WM_KEYFIRST = 0x100|
WM_KEYDOWN = 0x100|
WM_KEYUP = 0x101|
WM_CHAR = 0x102|
WM_DEADCHAR = 0x103|
WM_SYSKEYDOWN = 0x104|
WM_SYSKEYUP = 0x105|
WM_SYSCHAR = 0x106|
WM_SYSDEADCHAR = 0x107|
WM_KEYLAST = 0x108|
WM_IME_STARTCOMPOSITION = 0x10D|
WM_IME_ENDCOMPOSITION = 0x10E|
WM_IME_COMPOSITION = 0x10F|
WM_IME_KEYLAST = 0x10F|
WM_INITDIALOG = 0x110|
WM_COMMAND = 0x111|
WM_SYSCOMMAND = 0x112|
WM_TIMER = 0x113|
WM_HSCROLL = 0x114|
WM_VSCROLL = 0x115|
WM_INITMENU = 0x116|
WM_INITMENUPOPUP = 0x117|
WM_MENUSELECT = 0x11F|
WM_MENUCHAR = 0x120|
WM_ENTERIDLE = 0x121|
WM_CTLCOLORMSGBOX = 0x132|
WM_CTLCOLOREDIT = 0x133|
WM_CTLCOLORLISTBOX = 0x134|
WM_CTLCOLORBTN = 0x135|
WM_CTLCOLORDLG = 0x136|
WM_CTLCOLORSCROLLBAR = 0x137|
WM_CTLCOLORSTATIC = 0x138|
WM_MOUSEFIRST = 0x200|
WM_MOUSEMOVE = 0x200|
WM_LBUTTONDOWN = 0x201|
WM_LBUTTONUP = 0x202|
WM_LBUTTONDBLCLK = 0x203|
WM_RBUTTONDOWN = 0x204|
WM_RBUTTONUP = 0x205|
WM_RBUTTONDBLCLK = 0x206|
WM_MBUTTONDOWN = 0x207|
WM_MBUTTONUP = 0x208|
WM_MBUTTONDBLCLK = 0x209|
WM_MOUSEWHEEL = 0x20A|
WM_MOUSEHWHEEL = 0x20E|
WM_PARENTNOTIFY = 0x210|
WM_ENTERMENULOOP = 0x211|
WM_EXITMENULOOP = 0x212|
WM_NEXTMENU = 0x213|
WM_SIZING = 0x214|
WM_CAPTURECHANGED = 0x215|
WM_MOVING = 0x216|
WM_POWERBROADCAST = 0x218|
WM_DEVICECHANGE = 0x219|
WM_MDICREATE = 0x220|
WM_MDIDESTROY = 0x221|
WM_MDIACTIVATE = 0x222|
WM_MDIRESTORE = 0x223|
WM_MDINEXT = 0x224|
WM_MDIMAXIMIZE = 0x225|
WM_MDITILE = 0x226|
WM_MDICASCADE = 0x227|
WM_MDIICONARRANGE = 0x228|
WM_MDIGETACTIVE = 0x229|
WM_MDISETMENU = 0x230|
WM_ENTERSIZEMOVE = 0x231|
WM_EXITSIZEMOVE = 0x232|
WM_DROPFILES = 0x233|
WM_MDIREFRESHMENU = 0x234|
WM_IME_SETCONTEXT = 0x281|
WM_IME_NOTIFY = 0x282|
WM_IME_CONTROL = 0x283|
WM_IME_COMPOSITIONFULL = 0x284|
WM_IME_SELECT = 0x285|
WM_IME_CHAR = 0x286|
WM_IME_KEYDOWN = 0x290|
WM_IME_KEYUP = 0x291|
WM_MOUSEHOVER = 0x2A1|
WM_NCMOUSELEAVE = 0x2A2|
WM_MOUSELEAVE = 0x2A3|
WM_CUT = 0x300|
WM_COPY = 0x301|
WM_PASTE = 0x302|
WM_CLEAR = 0x303|
WM_UNDO = 0x304|
WM_RENDERFORMAT = 0x305|
WM_RENDERALLFORMATS = 0x306|
WM_DESTROYCLIPBOARD = 0x307|
WM_DRAWCLIPBOARD = 0x308|
WM_PAINTCLIPBOARD = 0x309|
WM_VSCROLLCLIPBOARD = 0x30A|
WM_SIZECLIPBOARD = 0x30B|
WM_ASKCBFORMATNAME = 0x30C|
WM_CHANGECBCHAIN = 0x30D|
WM_HSCROLLCLIPBOARD = 0x30E|
WM_QUERYNEWPALETTE = 0x30F|
WM_PALETTEISCHANGING = 0x310|
WM_PALETTECHANGED = 0x311|
WM_HOTKEY = 0x312|
WM_PRINT = 0x317|
WM_PRINTCLIENT = 0x318|
WM_HANDHELDFIRST = 0x358|
WM_HANDHELDLAST = 0x35F|
WM_PENWINFIRST = 0x380|
WM_PENWINLAST = 0x38F|
WM_COALESCE_FIRST = 0x390|
WM_COALESCE_LAST = 0x39F|
WM_DDE_FIRST = 0x3E0|
WM_DDE_INITIATE = 0x3E0|
WM_DDE_TERMINATE = 0x3E1|
WM_DDE_ADVISE = 0x3E2|
WM_DDE_UNADVISE = 0x3E3|
WM_DDE_ACK = 0x3E4|
WM_DDE_DATA = 0x3E5|
WM_DDE_REQUEST = 0x3E6|
WM_DDE_POKE = 0x3E7|
WM_DDE_EXECUTE = 0x3E8|
WM_DDE_LAST = 0x3E8|
WM_USER = 0x400|
WM_APP = 0x800|
)
Return
MsgChosen:
Gui 2:Submit
Gui 2:Destroy
StringSplit, MsgChoice#, MsgChoice, =
if (MsgChoice#2="")
   {
   MsgChoice#2:=MsgChoice#1
   }
OnMessage(MsgChoice#2, "MsgMonitor")
Return
ChooseNewHotKey:
try
   {
   Hotkey, %HotKey%, Off
   }
Gui 3:Add,Edit,x10 y10 w200 vHotKey,%Hotkey%
Gui 3:Add,Button,x10 y30 gRecord,Record
Gui 3:Add,Button,X+3 y30 gSaveNewHotKey,Save
Gui 3:Show
Gui ,3: +AlwaysOnTop
Return
3GuiClose:
if (HotKey="")
   {
   Gosub ChooseNewHotKey
   }
Return
SaveNewHotKey:
Gui 3:Submit
Gui 3:Destroy
if (HotKey="")
   {
   Gosub ChooseNewHotKey
   }
else
   {
   Try
      {
      Hotkey, %HotKey%, ChosenHotKey
      IniWrite, %HotKey%, %A_ScriptDir%\mywindowspy.ini, Main,HotKey
      Reload
      } catch e {
   SoundBeep 
    Gosub ChooseNewHotKey
   Return
      }
   }
Return
ChooseRate:
Menu,RateMenu,UnCheck,100
Menu,RateMenu,UnCheck,200
Menu,RateMenu,UnCheck,300
Menu,RateMenu,UnCheck,400
Menu,RateMenu,UnCheck,500
Menu,RateMenu,UnCheck,600
Menu,RateMenu,UnCheck,700
Menu,RateMenu,UnCheck,800
Menu,RateMenu,UnCheck,900
Menu,RateMenu,Check,%A_ThisMenuItem%
SetTimer, TipIt, %A_ThisMenuItem%
return
Help:
Gui, 4:+owner1
Gui +Disabled
Gui, 4:Add, Text,X30 y30,Press Hotkey to Display/Refresh details for Gui/Window under mouse.
Gui, 4:Add, Text,x30 y60,Click Sleep to leave program resident in memory, re-active using hotkey.
Gui, 4:Add, Text,x30 y90,Current selected hotkey is stored in mywindowspy.ini
Gui, 4:Add, Text,x30 y120,*Note Refresh rate lower than 500 may cause problems with double click etc
Gui, 4:Add, Text,x30 y150,THERE IS NO WARRANTY FOR THIS PROGRAM 
Gui, 4:Add, Button, x30  y180 Default, OK
Gui, 4:Show,,Help 
return
About:
Gui, 4:+owner1
Gui +Disabled
Gui, 4:Add, Text,x30 y10, %A_ScriptName% Version 1.0.1 by N.Price(LARK2355)
Gui, 4:Add, Text,x30 y30,Located  %A_ScriptFullPath%
Gui, 4:Add, Text,x30 y60,Autohotkey version %A_AhkVersion%
Gui, 4:Add, Text,x30 y80,Located  %A_AhkPath%
Gui, 4:Add, Button, x90  y110 Default, OK
Gui, 4:Show,,About Version
return
4ButtonOK:
4GuiClose:
4GuiEscape:
Gui, 1:-Disabled
Gui 4:Destroy
Return
Record:
Gui 3:Submit,NoHide
PriorMouse=
B_PriorKey:=A_PriorKey
B_PriorMouse:=PriorMouse
Loop
   {
   Gui,3:Flash 
   ToolTip hit any key apart from %B_Priorkey% 
   if (A_PriorKey<>B_PriorKey)
      {
      if (HotKey<>"")
         {
         HotKey.=" & "
         }
      HotKey .=A_PriorKey
      GuiControl, 3:, HotKey,%HotKey%
      ToolTip
      break
      }
   if (PriorMouse<>B_PriorMouse)
      {
      if (HotKey<>"")
         {
         HotKey.=" & "
         }
      HotKey .=PriorMouse
      GuiControl, 3:, HotKey,%HotKey%
      break
      }
   Sleep 100
   }
Return
MsgMonitor(wParam, lParam, msg,MsgAhk_ID)
   {
   FormatTime, TimeString,, hh:mm:ss
   WinGet, MsgProcess, ProcessName, Ahk_Id %MsgAhk_ID%
   SB_SetText("Message:-"  msg  " From ID:=" MsgAhk_ID "/" MsgProcess  " WParam:=" wparam " IParam:= "  IParam ,1)
   SB_SetText(TimeString ,2)
   }
   