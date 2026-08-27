$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Zapustite ot imeni administratora!" -ForegroundColor Red
    exit 1
}

Write-Host "[1/3] Vklyuchayu rezhim razrabotchika..." -ForegroundColor Cyan
$reg = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock'
if (-not (Test-Path $reg)) { New-Item -Path $reg -Force | Out-Null }
Set-ItemProperty -Path $reg -Name AllowDevelopmentWithoutDevLicense -Value 1

Write-Host "[2/3] Ustanavlivayu sertifikat..." -ForegroundColor Cyan
Import-Certificate -FilePath "$root\psyho.cer" -CertStoreLocation Cert:\LocalMachine\TrustedPeople | Out-Null

if (Get-AppxPackage Microsoft.Minecraft115 -ErrorAction SilentlyContinue) {
    Write-Host "      udalyayu staruyu versiyu Minecraft..." -ForegroundColor DarkGray
    Get-AppxPackage Microsoft.Minecraft115 | Remove-AppxPackage -ErrorAction SilentlyContinue
}

Write-Host "[3/3] Ustanavlivayu Minecraft s klientom (do minuty)..." -ForegroundColor Cyan
Add-AppxPackage -Path "$root\PsyhoClient115.appx"

Write-Host ""
Write-Host "GOTOVO! Ishchi Minecraft v menyu Pusk." -ForegroundColor Green
Write-Host "V igre: Insert - menyu klienta, F8 - interfeys, End - vygruzka."
