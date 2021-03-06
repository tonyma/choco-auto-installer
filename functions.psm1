function Get-Menu {
    Write-Host "-----------------------------------------------"
    Write-Host "`tPRESS number to run your tasks."
    Write-Host "-----------------------------------------------"
}

function Get-Commands{
    $commands=@()
    $commands+= New-Object -TypeName PSObject -Property @{
                        Name = "Install Chocolatey"
                        Command = "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
                        Message = "You need to restart the PowerShell"}

    $commands+= New-Object -TypeName PSObject -Property @{
                        Name = "Upgrade Chocolatey"
                        Command = "choco upgrade chocolatey -y"
                        Message = "You need to restart the PowerShell"}

    $commands+= New-Object -TypeName PSObject -Property @{
                        Name = "Upgrade all apps"
                        Command = "choco upgrade all -y"}

    Get-ChildItem $PSScriptRoot -Filter *.txt | 
        Foreach-Object {
                $commands+= New-Object -TypeName PSObject -Property @{
                                Name = "Install " + $_.Basename
                                Content = Get-Content $_.FullName}
            }

    $commands+= New-Object -TypeName PSObject -Property @{
                        Name = "Exit"
                        Command = ""}
    return $commands
}

function Install-Apps([PSObject]$command){
    if ($command.Command) {
        Invoke-Expression $command.Command
        if ($command.Message) {
            Write-Host -ForegroundColor red $command.Message
        }
    }elseif ($command.Content) {
        $apps = $command.Content.split(" ")
        foreach ($app in $apps) {
            Write-Host -ForegroundColor green "Installing " $app
            $c = "choco upgrade " + $app + " -y"
            Write-Host "Command running: " $c
            Invoke-Expression $c
        }
    }

}