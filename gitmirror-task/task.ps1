[CmdletBinding()]
param(
    [string] $GitRepoUrl
)

Write-Host "Starting GitMirrorTask"
Trace-VstsEnteringInvocation $MyInvocation

try {
	$GitRepoUrl = Get-VstsInput -Name GitRepoUrl -Require 
	Write-VstsTaskVerbose "GitRepoUrl: $GitRepoUrl" 

	Set-Location $Env:BUILD_SOURCESDIRECTORY

	### Add fetch URL
	Write-VstsTaskVerbose ">>git remote add --mirror=fetch mirror $GitRepoUrl"
	git remote add --mirror=fetch mirror $GitRepoUrl

	## Push stuff
	Write-VstsTaskVerbose ">>it push mirror --progress --prune +refs/remotes/origin/*:refs/heads/* +refs/tags/*:refs/tags/*"
	git push mirror --progress --prune +refs/remotes/origin/*:refs/heads/* +refs/tags/*:refs/tags/*
	if (!$?) {
		throw
	}
} catch {
	# Catching reliability issues and logging them here.
	Write-Host "##vso[task.logissue type=error;code=" $_.Exception.Message ";TaskName=gitmirror]"
	throw
} finally {
    Trace-VstsLeavingInvocation $MyInvocation
}

Write-Host "Ending GitMirrorTask"