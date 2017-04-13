Save-Module -Name VstsTaskSdk -Path .\ps_modules\
Save-Module -Name posh-git -Path .\ps_modules\

Install-Module posh-git -Verbose -Scope CurrentUser

Import-Module .\ps_modules\VstsTaskSdk
Import-Module .\ps_modules\posh-git

Invoke-VstsTaskScript -ScriptBlock ([scriptblock]::Create('. .\gitmirror-task\task.ps1')) -Verbose