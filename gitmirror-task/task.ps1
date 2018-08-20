[CmdletBinding()]
param(
    [string] $GitRepoUrl
)

Write-Host "Starting GitMirrorTask"
Trace-VstsEnteringInvocation $MyInvocation

try {
	git --version

	$GitRepoUrl = Get-VstsInput -Name GitRepoUrl -Require 
	Write-VstsTaskVerbose "GitRepoUrl: $GitRepoUrl" 

	Set-Location $Env:BUILD_SOURCESDIRECTORY

	### Prune local tags `git fetch` gets with Git 2.17 (Q2 2018) an handy short-hand for getting rid of stale tags that are locally held.
	git fetch --tags --prune-tags 
    if (!$?) {
		Write-Host "##[warning]git fetch --prune-tags is supported from Git 2.17 (Q2 2018), please update your local Git ($(git --version))"
	}

	### Add fetch URL
	Write-VstsTaskVerbose ">>git remote add --mirror=fetch mirror $GitRepoUrl"
	git remote add --mirror=fetch mirror $GitRepoUrl
    if (!$?) {
		Write-Host "##[warning]Remote 'mirror' already exists, updating new git url: $GitRepoUrl"
		git remote set-url mirror $GitRepoUrl
		git remote set-url --push mirror $GitRepoUrl
	}

	## Push stuff
	# Use a + in front of the refspec to push (e.g git push origin +master to force a push to the master branch)
	# See https://stackoverflow.com/questions/1841341/remove-local-git-tags-that-are-no-longer-on-the-remote-repository
	Write-VstsTaskVerbose ">>git push mirror --progress --prune +refs/remotes/origin/*:refs/heads/* +refs/tags/*:refs/tags/*"
	git push mirror --progress --prune "+refs/remotes/origin/*:refs/heads/*" "+refs/tags/*:refs/tags/*"
	if (!$?) {
		Write-Host "##[error]Cannot push to remote 'mirror'!"
		throw
	}

	## Sync remote tags
	git tag -l | foreach { git push --delete mirror $_ }
	if (!$?) {
		Write-Host "##[error]Cannot sync tags with remote 'mirror'!"
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