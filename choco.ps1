CLS
Write-Host "Starting automatic file installation by chocolatey"
Write-Host "Script needs to run in admin mode"

Import-Module (Join-Path $PSScriptRoot "./functions.psm1") -Force -Verbose:$false

$commands = Get-Commands

Do{
    Get-Menu 
    $counter = 0
    Foreach ($c IN $commands)
    {
        $counter+=1
        Write-Host "`t"$counter - $c.Name
    }
    Write-Host "`n"
    $selectedCommand = Read-Host -Prompt 'Select a task you want to run then press ENTER'

    try { 
        $selectedCommand = [int]$selectedCommand
        if($selectedCommand -lt 1 -or $selectedCommand -gt $commands.length){
            Write-Host -ForegroundColor red "Option selected ($selectedCommand) is invalid"
            Write-Host "`n"
        }
        elseif($selectedCommand -ne $commands.length) {
            Install-Apps($commands[$selectedCommand-1])
        }
    }
    catch {
        Write-Host -ForegroundColor red "Errr occurred"
        Write-Host "`n"
    }
}While ($selectedCommand -ne $commands.length -and !$commands[$selectedCommand-1].Message)