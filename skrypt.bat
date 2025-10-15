@echo off
chcp 65001 >nul
setlocal

:: === Wymuszenie uprawnień administratora ===
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ?? Uruchamianie jako administrator...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: === Ścieżka do raportu ===
set "REPORT=%USERPROFILE%\Documents\raport.txt"
if exist "%REPORT%" del "%REPORT%"

echo ===== INWENTARYZACJA SYSTEMU WINDOWS ===== > "%REPORT%"
echo Data: %DATE% %TIME% >> "%REPORT%"
echo Komputer: %COMPUTERNAME% >> "%REPORT%"
echo. >> "%REPORT%"

:: === Informacje o systemie ===
echo === INFORMACJE O SYSTEMIE === >> "%REPORT%"
powershell -Command "Get-ComputerInfo | Select-Object CsManufacturer, CsModel, WindowsProductName, WindowsVersion, OsArchitecture, BiosVersion, BiosReleaseDate" >> "%REPORT%"
echo. >> "%REPORT%"

:: === Procesor ===
echo === INFORMACJE O PROCESORZE === >> "%REPORT%"
powershell -Command "Get-CimInstance Win32_Processor | Select-Object Name,Manufacturer,NumberOfCores,NumberOfLogicalProcessors,MaxClockSpeed" >> "%REPORT%"
echo. >> "%REPORT%"

:: === Pamięć RAM ===
echo === PAMIĘĆ RAM === >> "%REPORT%"
powershell -Command "Get-CimInstance Win32_PhysicalMemory | Select-Object Manufacturer,PartNumber,Capacity,Speed" >> "%REPORT%"
echo. >> "%REPORT%"

:: === Dyski ===
echo === DYSKI FIZYCZNE === >> "%REPORT%"
powershell -Command "Get-PhysicalDisk | Select-Object FriendlyName,MediaType,Size,HealthStatus" >> "%REPORT%"
echo. >> "%REPORT%"

:: === TPM / Secure Boot / UEFI ===
echo === ZABEZPIECZENIA I TRYB ROZRUCHU === >> "%REPORT%"
powershell -Command ^
"try { $tpm = Get-WmiObject -Namespace 'Root\CIMv2\Security\MicrosoftTpm' -Class Win32_Tpm; if($tpm){Write-Host 'TPM: Aktywny'}} catch {Write-Host 'TPM: Niedostępny lub wyłączony'}"
powershell -Command ^
"try { if(Confirm-SecureBootUEFI){Write-Host 'Secure Boot: Włączony'} else {Write-Host 'Secure Boot: Wyłączony'} } catch {Write-Host 'Secure Boot: Niedostępny'}" >> "%REPORT%"
powershell -Command ^
"$uefi=(Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control').PEFirmwareType; if($uefi -eq 2){Write-Host 'Tryb UEFI'} else {Write-Host 'Tryb Legacy BIOS'}" >> "%REPORT%"
echo. >> "%REPORT%"

:: === GPU ===
echo === KARTA GRAFICZNA === >> "%REPORT%"
powershell -Command "Get-CimInstance Win32_VideoController | Select-Object Name,DriverVersion,AdapterRAM" >> "%REPORT%"
echo. >> "%REPORT%"

:: === Sieć ===
echo === SIEĆ === >> "%REPORT%"
powershell -Command "Get-NetAdapter | Select-Object Name,InterfaceDescription,Status,MacAddress" >> "%REPORT%"
echo. >> "%REPORT%"

:: === Ocena zgodności z Windows 11 ===
echo === KOMPATYBILNOŚĆ Z WINDOWS 11 === >> "%REPORT%"
powershell -Command ^
"$arch=(Get-ComputerInfo).OsArchitecture; $uefi=(Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control').PEFirmwareType; $tpm=$false; try{$t=Get-WmiObject -Namespace 'Root\CIMv2\Security\MicrosoftTpm' -Class Win32_Tpm; if($t.IsEnabled_InitialValue -and $t.IsActivated_InitialValue){$tpm=$true}}catch{}; $secure=$false; try{$secure=Confirm-SecureBootUEFI}catch{}; if(($arch -match '64') -and ($uefi -eq 2) -and $tpm -and $secure){Write-Host '? ZGODNY Z WINDOWS 11'} else {Write-Host '? NIEZGODNY Z WINDOWS 11'}" >> "%REPORT%"
echo. >> "%REPORT%"

:: === Zakończenie ===
echo Raport zapisany: %REPORT%
start notepad "%REPORT%"
pause
exit /b
