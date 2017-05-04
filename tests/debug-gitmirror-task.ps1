#--------------------------------------------------------------------
# Dot source support scripts
#--------------------------------------------------------------------
$ScriptPath = $MyInvocation.MyCommand.Path
$ScriptDir  = Split-Path -Parent $ScriptPath

# Save-Module -Name VstsTaskSdk -Path $ScriptDir\..\gitmirror-task\ps_modules\

Save-Module -Name posh-git -Path $ScriptDir\..\ps_modules\

# Install-Module posh-git -Verbose -Scope CurrentUser

# Import-Module $ScriptDir\..\gitmirror-task\ps_modules\VstsTaskSdk
Import-Module $ScriptDir\..\ps_modules\posh-git

Invoke-VstsTaskScript -ScriptBlock ([scriptblock]::Create('$ScriptDir\..\gitmirror-task\task.ps1')) -Verbose