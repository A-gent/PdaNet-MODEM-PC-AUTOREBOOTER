# PdaNet-MODEM-PC-AUTOREBOOTER
Programmatically reboot the PC to allow for easy PdaNet connection to router WAN port.


## SETUP

0.) Install [this powershell module](https://github.com/loxia01/PSInternetConnectionSharing), using the installation instructions on its page to do so.
<br>
<br>
1.) unzip the release to a folder of your own creation (in a place where no spaces will exist in the directory tree) then configure the "START_SECONDARY.bat" batch file's directory to point to your current SECONDARY_APP.exe file, set the "TargetDirectory" in the config file, "ICSPowershellDisablerScript" directory to the ICS-Stop.ps1 file, and "ICSPowershellScript" directory to the ICS-Set.ps1 file all available within the config.cfg file.
<br>
<br>
2.) Then, unblock all of these files by right clicking each and checking "Unblock" and then apply and okay on each file. (This can be skipped if you don't use this security feature already)
<br>
<br>
3.) Open a powershell window with admin rights and execute this to enable powershell script execution on your machine:
```
set-executionpolicy remotesigned
```
Press Y and then enter to confirm the change.
<br>
<br>
4.) Once all configured and unblocked, I prefer to create a Windows Task Scheduler task that runs with admin privileges to suppress the need to confirm a UAC prompt, and I point this task to the "PRIMARY_ARM.exe" file and give the task a name, and then I create a shortcut file on the Modem PC's desktop and paste the following: 
```
C:\windows\system32\schtasks.exe /run /tn "TheNameOfYourTaskGoesHere"
```
<br>
<br>
5.) Whenever your net is slowing down or doing anything funny, and are ready to reboot your PdaNet Modem PC, just double click the shortcut made in step 4. and follow the on-screen message box instructions which will guide you through the process and ensure everything occurs in the right order.





