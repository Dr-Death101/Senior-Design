$jobname = "Server Health Check"
$script =  "-ExecutionPolicy Bypass -file C:\Project6\CompletedScript\Main.ps1"
$action = New-ScheduledTaskAction –Execute "powershell.exe" -Argument  "$script"
$trigger = New-ScheduledTaskTrigger -Daily -At 21:25pm
$Description="Enable run time of task at specified time"
$msg = "Enter the username and password that will run the task"; 
$credential = $Host.UI.PromptForCredential("Task username and password",$msg,"$env:userdomain\$env:username",$env:userdomain)
$username = $credential.UserName
$password = $credential.GetNetworkCredential().Password
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd
Register-ScheduledTask -TaskName $jobname -Action $action -Trigger $trigger -RunLevel Highest -User $username -Password $password -Settings $settings -Description $Description
