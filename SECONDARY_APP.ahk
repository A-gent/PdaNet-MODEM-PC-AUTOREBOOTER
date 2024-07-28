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







IniRead, bTaskName, config.cfg, TASK_CONFIG, TaskName, Z_TEST_ADD_1
GLOBAL TaskName := bTaskName


IniRead, dTaskDelete, config.cfg, SECONDARY_SWITCHES, DeleteTaskCleanup, Z_TEST_ADD_1
GLOBAL TaskDelete := dTaskDelete



IniRead, bPdaConnection, config.cfg, SECONDARY_CONFIG, PdaAdapter, PdaNet Broadband Connection
GLOBAL PdaConnection := bPdaConnection
IniRead, bWanInput, config.cfg, SECONDARY_CONFIG, WanAdapter, Ethernet
GLOBAL WanInput := bWanInput
IniRead, bPowershell_ICS_Script, config.cfg, SECONDARY_CONFIG, ICSPowershellScript, C:\_MANIFEST\MODEM\AUTO_REBOOTER\ICS-Set.ps1
GLOBAL Powershell_ICS_Script := bPowershell_ICS_Script


IniRead, bDebug_RunTest, config.cfg, DEBUG, Debug_RunTestOnly, 0
GLOBAL Debug_RunTest := bDebug_RunTest






    MsgBox, 6, AUTO-MODEM REBOOTER, Please allow the router to fully reboot and let all lights turn blue (except for the WAN port)`n`n Once this occurs press CONTINUE.`n`n`n (CANCEL / Try Again simply exits).
    IfMsgBox, Continue
    {
                If(Debug_RunTest="1")
                {
                    MsgBox,, AUTO-MODEM REBOOTER, RUN TEST DEBUGGER SETTING=1 AND HAS BEEN CALLED--SO WE WILL NOT ATTEMPT TO DO THE ICS CALL AND THIS MESSAGE WILL CALL ONLY!
                    If(TaskDelete="1")
                    {
                        Run, SCHTASKS.exe /Delete /TN "%TaskName%" /f
                    }
                    FileDelete, %A_AppData%\Microsoft\Windows\Start Menu\Programs\Startup\RUN_%TASKNAME%.lnk
                }
                Else
                {
                    ; Run, powershell.exe -windowstyle hidden -ExecutionPolicy Bypass -File C:\_MANIFEST\MODEM\ICS-Set.ps1 -Pdanet "%PdaConnection%" -Wan "%WanInput%"
                    Run, powershell.exe -windowstyle hidden -ExecutionPolicy Bypass -File %Powershell_ICS_Script% -Pdanet "%PdaConnection%" -Wan "%WanInput%"
                    If(TaskDelete="1")
                    {
                        Run, SCHTASKS.exe /Delete /TN "%TaskName%" /f
                    }
                    FileDelete, %A_AppData%\Microsoft\Windows\Start Menu\Programs\Startup\RUN_%TASKNAME%.lnk
                }
                ExitApp
    }
    IfMsgBox, Cancel
    {
            ExitApp
    }
    IfMsgBox, TryAgain
    {
            ExitApp
    }






