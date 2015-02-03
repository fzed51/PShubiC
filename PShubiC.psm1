# HubiC.psm1
# Création : 03.02.2015
# Auteur : Fabien "fzed51" Sanchez
# Description :
# -------------
# Module de gestion du composant Hubic@OVH
# Changements :
# -------------
# v0.1 (03.02.2015) :
# Création du module et mise en route du développemment


function Invoke-Hubic {
    
<#
> hubic help

hubiC - Keep your files synchronized - version 2.1.0.141
Copyright © 2012-2015 OVH. All rights reserved.
Environment:
        OS: Microsoft Windows NT 6.1.7601 Service Pack 1
        .net framework: 4.0.30319.34209

Usage: `hubiC <command> [<args>]' where command is:

help    Show general help, or detailed help for a command.
pause   Pauses application and interrupts any running action.
resume  Resume operations.
run     Run main application (default action).
speed   Change upload/download speed.
update  Update an existing backup.

help <command>...
  Show general help, or detailed help for a command.
  command: Display help for a specific command.

pause
  Pauses application and interrupts any running action.

resume
  Resume operations.

run [--showsync] [--debug=VALUE] [--culture=VALUE]
  Run main application (default action).
  --showsync: opens synchronized dir after connection. (default: False)
  --debug: debug level (higher numbers gives more verbose log). (default: 0)
  --culture: force different language.

speed [--upload=VALUE] [--download=VALUE]
  Change upload/download speed.
  --upload: upload speed (in bytes per second, 0=unlimited).
  --download: download speed (in bytes per second, 0=unlimited).

update <name>
  Update an existing backup.
  name: name of backup to update.

#>

    [CmdletBinding(DefaultParameterSetName='paramSet_run')]

    Param (
        [Parameter(
            Mandatory=$true,
            ParameterSetName='paramSet_pause')]
        [switch]$Pause,
        [Parameter(
            Mandatory=$true,
            ParameterSetName='paramSet_resume')]
        [switch]$Resume,
        [Parameter(
            Mandatory=$true,
            ParameterSetName='paramSet_run')]
        [switch]$Run,
        [Parameter(
            Mandatory=$false,
            ParameterSetName='paramSet_run')]
        [switch]$showsync,
        [Parameter(
            Mandatory=$false,
            ParameterSetName='paramSet_run')]
        [int]$Log = -1 ,
        [Parameter(
            Mandatory=$false,
            ParameterSetName='paramSet_run')]
        [string]$Culture,
        [Parameter(
            Mandatory=$true,
            ParameterSetName='paramSet_speed')]
        [switch]$Speed,
        [Parameter(
            Mandatory=$false,
            ParameterSetName='paramSet_speed')]
        [int]$Upload = -1,
        [Parameter(
            Mandatory=$false,
            ParameterSetName='paramSet_speed')]
        [int]$Download = -1,
        [Parameter(
            Mandatory=$true,
            ParameterSetName='paramSet_update')]
        [switch]$Update,
        [Parameter(
            Mandatory=$true,
            ParameterSetName='paramSet_update')]
        [string]$Name



    )

    Begin
    {

        # Resolution du chemin program file [(x86)]
        $Hubic = $(Resolve-Path -Path "$env:ProgramFiles*\OVH\Hubic\hubiC.exe").Path

    }
    Process{
    Switch($PsCmdlet.ParameterSetName){
    "paramSet_pause"{
        & $Hubic pause
    }
    "paramSet_resume"{
        & $Hubic resume
    }
    "paramSet_run"{
        $listeArg = @()
        if ( $showsync ) {
            $listeArg += '--showsync'
        }
        if ( $Log -ge 0 ) {
            $listeArg += "--debug $Log"
        }
        if ( $Culture -ne '' ) {
            $listeArg += "--culture $Culture"
        }
        & $Hubic run @listeArg
    }
    "paramSet_speed"{
            
        if ( $Download -ge 0 ) {
            $listeArg += "--download $Download"
        }
        if ( $Upload -ne '' ) {
            $listeArg += "--upload $Upload"
        }
        & $Hubic speed @listeArg

    }
    "paramSet_update"{

        & $Hubic update $Name
        
    }
    }
    }
    End
    {
    }
}

function Start-HubiC {
    Invoke-Hubic -Resume
}
function Stop-HubiC {
    Invoke-Hubic -Pause
}

New-Alias hbc -Value Invoke-Hubic
New-Alias hcp -Value Stop-HubiC
New-Alias hcr -Value Start-HubiC

Export-ModuleMember -Function * -Alias *
