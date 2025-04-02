@echo off
setlocal

:: Ustal nazw� pliku raportu
set REPORT=raport.txt

:: Wyczy�� poprzedni raport
if exist %REPORT% del %REPORT%

:: Dodaj nag��wek raportu
echo ===== Inwentaryzacja systemu Windows ===== >> %REPORT%
echo Data i godzina: %DATE% %TIME% >> %REPORT%
echo. >> %REPORT%

:: Informacje o systemie
echo === Informacje o systemie === >> %REPORT%
systeminfo >> %REPORT%
echo. >> %REPORT%

:: Lista proces�w
echo === Lista uruchomionych proces�w === >> %REPORT%
tasklist >> %REPORT%
echo. >> %REPORT%

:: Lista zainstalowanych program�w
echo === Lista zainstalowanych program�w === >> %REPORT%
wmic product get name,version >> %REPORT%
echo. >> %REPORT%

:: Informacje o sieci
echo === Konfiguracja sieci === >> %REPORT%
ipconfig /all >> %REPORT%
echo. >> %REPORT%

:: Pod��czone dyski
echo === Lista dysk�w === >> %REPORT%
wmic logicaldisk get deviceid, volumename, filesystem, size, freespace >> %REPORT%
echo. >> %REPORT%

:: Informacje o u�ytkownikach
echo === Lista u�ytkownik�w === >> %REPORT%
wmic useraccount get name,sid >> %REPORT%
echo. >> %REPORT%

:: Informacje o sprz�cie
echo === Informacje o sprz�cie === >> %REPORT%
wmic cpu get name >> %REPORT%
wmic memorychip get capacity >> %REPORT%
wmic bios get serialnumber >> %REPORT%
echo. >> %REPORT%

:: Zako�czenie
echo Inwentaryzacja zako�czona. Wyniki zapisano do %REPORT%.
pause
