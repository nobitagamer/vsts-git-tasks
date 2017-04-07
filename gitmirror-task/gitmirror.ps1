[CmdletBinding()]
param(
    [string] $GitRepoUrl
)

$GitRepoUrl = Get-VstsInput -Name GitRepoUrl -Require 
Write-VstsTaskVerbose "GitRepoUrl: $GitRepoUrl" 

Set-Location $Env:BUILD_SOURCESDIRECTORY

### Add fetch URL
Write-VstsTaskVerbose ">>git remote add --mirror=fetch mirror $GitRepoUrl"
git remote add --mirror=fetch mirror $GitRepoUrl

## Push stuff
Write-VstsTaskVerbose ">>it push mirror --progress --prune +refs/remotes/origin/*:refs/heads/* +refs/tags/*:refs/tags/*"
git push mirror --progress --prune +refs/remotes/origin/*:refs/heads/* +refs/tags/*:refs/tags/*

#git pull --all
#git pull mirror $env:Build_SourceBranchName --tags
#git remote prune mirror 
#git push mirror --all
#git push mirror --tags
