#Save-Module -Name VstsTaskSdk -Path ..\gitmirror-task\ps_modules\
Save-Module -Name posh-git -Path .\gitmirror-task\ps_modules\

 Install-Module posh-git -


#Import-Module .\gitmirror-task\ps_modules\VstsTaskSdk
Import-Module .\gitmirror-task\ps_modules\posh-git


Invoke-VstsTaskScript -ScriptBlock ([scriptblock]::Create('. .\gitmirror-task\gitsync.ps1')) -Verbose