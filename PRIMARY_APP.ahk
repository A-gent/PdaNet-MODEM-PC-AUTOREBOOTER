#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, Ignore
#NoTrayIcon

IniRead, bElevate, config.cfg, DEBUG, RunAsAdministrator, 1
GLOBAL ElevateUAC := bElevate

                            If(ElevateUAC="1")
                            {
;                         {[
;;           ELEVATE TO ADMIN UAC PROMPT BELOW
; If the script is not elevated, relaunch as administrator and kill current instance:
 
full_command_line := DllCall("GetCommandLine", "str")
 
if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
{
    try ; leads to having the script re-launching itself as administrator
    {
        if A_IsCompiled
            Run *RunAs "%A_ScriptFullPath%" /restart
        else
            Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
    }
    ExitApp
}
;
;                          ]}
                            }



FormatTime, TimeString, T12, Time
FormatTime, DateString,, ShortDate



;;; DEFINE TASK INFORMATION
IniRead, bTaskName, config.cfg, TASK_CONFIG, TaskName, Z_TEST_ADD_1
GLOBAL TaskName := bTaskName

IniRead, bTaskDir, config.cfg, TASK_CONFIG, TargetDirectory
GLOBAL TargetDir := bTaskDir
IniRead, bTargetName, config.cfg, TASK_CONFIG, TargetName, test_msgbox.exe
GLOBAL TargetName := bTargetName


;;; COMBINE TARGET DIRECTORY AND NAME
GLOBAL Target := TargetDir . "\" . TargetName
;;; USE CURRENT USER
GLOBAL UserName := A_ComputerName . "\" . A_UserName



IniRead, bCreateAdminTask, config.cfg, PRIMARY_SWITCHES, CreateElevatedAdminTask, 1
GLOBAL CreateAdministratorTask := bCreateAdminTask
IniRead, bMessagePrompt, config.cfg, PRIMARY_SWITCHES, MessagePrompt, 1
GLOBAL MessagePrompt := bMessagePrompt

IniRead, bDebug_CreateTaskMSG, config.cfg, DEBUG, Debug_CreateTaskMSG, 1
GLOBAL Debug_CreateTaskMSG := bDebug_CreateTaskMSG
IniRead, bDebug_CreateTaskMSGInfo, config.cfg, DEBUG, Debug_CreateTaskMSGInfo, 1
GLOBAL Debug_CreateTaskMSGInfo := bDebug_CreateTaskMSGInfo


IniRead, bICSPowershellDisablerScript, config.cfg, PRIMARY_CONFIG, ICSPowershellDisablerScript, C:\_MANIFEST\MODEM\AUTO_REBOOTER\ICS-Stop.ps1
GLOBAL ICSPowershellDisablerScript := bICSPowershellDisablerScript


IniRead, bPrimaryMsgBox, config.cfg, MESSAGEBOXES, PrimaryMsgBox, Do you want to execute the Automated Modem Reboot Setup? (Press YES or NO)
GLOBAL PrimaryMsgBox := bPrimaryMsgBox


IniRead, bPrimaryMsgBox, config.cfg, MESSAGEBOXES, PrimaryMsgBox, Do you want to execute the Automated Modem Reboot Setup? (Press YES or NO)
GLOBAL PrimaryMsgBox := bPrimaryMsgBox
IniRead, bPrimaryMsgBox2, config.cfg, MESSAGEBOXES, PrimaryMsgBoxLine2,
GLOBAL PrimaryMsgBox2 := bPrimaryMsgBox2
IniRead, bPrimaryMsgBox3, config.cfg, MESSAGEBOXES, PrimaryMsgBoxLine3,
GLOBAL PrimaryMsgBox3 := bPrimaryMsgBox3


If(MessagePrompt="1")
{
        MsgBox, 4, AUTO-MODEM REBOOTER, %PrimaryMsgBox% `n`n%PrimaryMsgBox2% `n`n`n%PrimaryMsgBox3%
        IfMsgBox, Yes
        {
        Run, powershell.exe -windowstyle hidden -ExecutionPolicy Bypass -File %ICSPowershellDisablerScript%

        Run, schtasks.exe /create /tn "%TaskName%" /tr "%Target%" /sc ONCE /sd 01/01/1901 /st 00:00 /RU "%UserName%" /RL HIGHEST /F
        FileCreateShortcut, schtasks.exe, %A_AppData%\Microsoft\Windows\Start Menu\Programs\Startup\RUN_%TASKNAME%.lnk, C:\Windows\System32, /run /tn "%TaskName%", taskname Description,,,
            Sleep, 3500
            Shutdown, 2  ;;; Just do a simple reboot
            ; Shutdown, 6  ;;; Force a reboot, closing all open applications
            ExitApp
        }
        IfMsgBox, No
        {
            ExitApp
        }
}
Else
{
        Run, powershell.exe -windowstyle hidden -ExecutionPolicy Bypass -File %ICSPowershellDisablerScript%

        Run, schtasks.exe /create /tn "%TaskName%" /tr "%Target%" /sc ONCE /sd 01/01/1901 /st 00:00 /RU "%UserName%" /RL HIGHEST /F
        FileCreateShortcut, schtasks.exe, %A_AppData%\Microsoft\Windows\Start Menu\Programs\Startup\RUN_%TASKNAME%.lnk, C:\Windows\System32, /run /tn "%TaskName%", taskname Description,,,
            Sleep, 3500
            Shutdown, 2  ;;; Just do a simple reboot
            ; Shutdown, 6  ;;; Force a reboot, closing all open applications
            ExitApp
}



















