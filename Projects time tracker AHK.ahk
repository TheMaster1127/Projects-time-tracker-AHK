;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Name:
; Projects time tracker AHK
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; A lightweight AutoHotkey script to track the time spent on your projects.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#singleinstance force
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;;;;;;;;;;;;;;;;;;;;;

storeElapsedTime := 0

Gui, Color, 121212
Gui -DPIScale
Gui, Font, s15
Gui, Add, Text, cWhite x0 y10 w1000 h30 center, Track your time for a project
Gui, Add, Button, x10 y80 h50 gButton, Select your project
Gui, Add, Text, cWhite x10 w1000 y550 h100 vTextSelectedFolder,
Gui, Font, s13
Gui, Add, Button, x10 y150 w150 h50 vStart gStart, Start/Resume
Gui, Font, s15
Gui, Add, Button, x10 y210 w150 h50 vStop gStop, Stop/Pause
Gui, Add, Button, x10 y270 w150 h50 vReset gReset, Reset
Gui, Add, Text, cWhite x10 y350 w350 h50 vTime,
Gui, Add, Button, x10 y410 w150 h50 vSave gSave, Save
GuiControl, Hide, Start
GuiControl, Hide, Stop
GuiControl, Hide, Save
GuiControl, Hide, Reset

GuiControl, Disable, Stop
GuiControl, Disable, Save
GuiControl, Disable, Start
Gui, Show, w1000 h700
Return

Button:
Loop
{
FileSelectFolder, OutputVar, , 3
if (OutputVar = "")
{
MsgBox, You didn't select a folder.
continue
}
else
{
MsgBox, You selected folder "%OutputVar%".
GuiControl, , TextSelectedFolder, You're selected folder is %OutputVar%
GuiControl, Show, Start
GuiControl, Show, Stop
GuiControl, Show, Reset
GuiControl, Disable, Reset

GuiControl, Disable, Stop
GuiControl, Enable, Start
break
}
}
Return

Save:
isRunning := 1
GuiControl, Disable, Stop
GuiControl, Disable, Save
FileAppend, The duration of that session between %StartTimee% and %EndTime% is %ElapsedTime123%`n, %OutputVar%\Project Time.txt
MsgBox, The duration of that session between %StartTimee% and %EndTime% is %ElapsedTime123%`n, %OutputVar%\Project Time.txt
gosub Reset
Return

Start:
if (isRunning != 1)
{
StartTime := A_TickCount

if (A_Hour >= 13)
{
AHour := A_Hour - 12
ampm := "PM"
}
else
{
AHour := A_Hour
ampm := "AM"
}
StartTimee := AHour . ":" . A_Min . " " . ampm

}
StartTime := A_TickCount - storeElapsedTime
isRunning := 1
GuiControl, Enable, Stop
GuiControl, Disable, Start
GuiControl, Disable, Save
GuiControl, Disable, Reset
SetTimer, Time, 1


Return

Stop:
isRunning := 1
GuiControl, Enable, Start
GuiControl, Enable, Reset
GuiControl, Disable, Stop
GuiControl, Show, Save
GuiControl, Enable, Save
SetTimer, Time, Off
storeElapsedTime := A_TickCount - StartTime
ElapsedTime := A_TickCount - StartTime
if (A_Hour >= 13)
{
AHour := A_Hour - 12
ampm := "PM"
}
else
{
AHour := A_Hour
ampm := "AM"
}
EndTime := AHour . ":" . A_Min . " " . ampm



ms := ElapsedTime

; Calculate the components
hours := Floor(ms / 3600000)
ms := Mod(ms, 3600000)
minutes := Floor(ms / 60000)
ms := Mod(ms, 60000)
seconds := Floor(ms / 1000)
milliseconds := Mod(ms, 1000)

; Display the result
ElapsedTime123 := ""
ElapsedTime123 .= hours " hours " minutes " minutes " seconds " seconds and " milliseconds " ms."
Return


Reset:
isRunning := 0
storeElapsedTime := 0
GuiControl, Enable, Start
GuiControl, Disable, Stop
SetTimer, Time, Off
milliseconds := 0
seconds := 0
minutes := 0
hours := 0
ElapsedTime123 := hours "h " minutes "m " seconds "s " milliseconds "ms"
GuiControl, , Time, Time: %ElapsedTime123%
Return



Time:
ElapsedTime := A_TickCount - StartTime
ms := ElapsedTime

; Calculate the components
hours := Floor(ms / 3600000)
ms := Mod(ms, 3600000)
minutes := Floor(ms / 60000)
ms := Mod(ms, 60000)
seconds := Floor(ms / 1000)
milliseconds := Mod(ms, 1000)

; Display the result
ElapsedTime123 := ""
ElapsedTime123 .= hours "h " minutes "m " seconds "s " milliseconds "ms"

GuiControl, , Time, Time: %ElapsedTime123%
Return

GuiClose:
if (isRunning = 1)
{
gosub Stop
Sleep, 100
gosub Save
Sleep, 100
}
ExitApp
Return
