####
# @vsingur My  Powershell profile file creator. 
#  Add tune commands to profile
#  This commands preserve history betwen sessions and make it accessible via arrow Up and Down
#  Also script add ability to exit by pressing Ctrl+D
#


$commands = @"
    `$HistoryFilePath` = Join-Path ([Environment]::GetFolderPath('UserProfile')) .ps_history
      Register-EngineEvent PowerShell.Exiting -Action { Get-History | Export-Clixml `$HistoryFilePath` } | out-null
      if (Test-path `$HistoryFilePath`) { Import-Clixml `$HistoryFilePath` | Add-History }
      Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
      Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
      Set-PSReadlineKeyHandler -Key Ctrl+d -Function DeleteCharOrExit
"@

if (!(test-path $profile) ) {
    new-item -path $profile -itemtype file -force

    Add-Content  $profile  $commands
    invoke-Command -ScriptBlock $executioncontext.invokecommand.NewScriptBlock($commands)

}
else {
    invoke-Command -ScriptBlock $executioncontext.invokecommand.NewScriptBlock($commands)
}

