#SingleInstance, Force
settitlematchmode 2

outfile=win_info.txt
line= `n=======================`n
return

f1::
  mousegetpos, x,y, this_id, ctl
  WinGetClass, this_class, ahk_id %this_id%
  WinGetTitle, this_title, ahk_id %this_id%
  WinGetText, this_text, ahk_id %this_id%


  fileappend, %line%, %outfile%
  fileappend, this_id %this_id%`n , %outfile%
  fileappend, this_class %this_class%`n , %outfile%
  fileappend, this_title %this_title%`n , %outfile%
  fileappend, this_text >>`n , %outfile%
  fileappend, %this_text%`n , %outfile%
  fileappend, %line%, %outfile%

  return