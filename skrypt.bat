@echo off
setlocal

:: Ustal nazwê pliku raportu
set REPORT=raport.txt

:: Wyczyœæ poprzedni raport
if exist %REPORT% del %REPORT%

:: Dodaj nag³ówek raportu
echo ===== Inwentaryzacja systemu Windows ===== >> %REPORT%
echo Data i godzina: %DATE% %TIME% >> %REPORT%
echo. >> %REPORT%

:: Informacje o systemie
echo === Informacje o systemie === >> %REPORT%
systeminfo >> %REPORT%
echo. >> %REPORT%

:: Lista procesów
echo === Lista uruchomionych procesów === >> %REPORT%
tasklist >> %REPORT%
echo. >> %REPORT%

:: Lista zainstalowanych programów
echo === Lista zainstalowanych programów === >> %REPORT%
wmic product get name,version >> %REPORT%
echo. >> %REPORT%

:: Informacje o sieci
echo === Konfiguracja sieci === >> %REPORT%
ipconfig /all >> %REPORT%
echo. >> %REPORT%

:: Pod³¹czone dyski
echo === Lista dysków === >> %REPORT%
wmic logicaldisk get deviceid, volumename, filesystem, size, freespace >> %REPORT%
echo. >> %REPORT%

:: Informacje o u¿ytkownikach
echo === Lista u¿ytkowników === >> %REPORT%
wmic useraccount get name,sid >> %REPORT%
echo. >> %REPORT%

:: Informacje o sprzêcie
echo === Informacje o sprzêcie === >> %REPORT%
wmic cpu get name >> %REPORT%
wmic memorychip get capacity >> %REPORT%
wmic bios get serialnumber >> %REPORT%
echo. >> %REPORT%

:: Zakoñczenie
echo Inwentaryzacja zakoñczona. Wyniki zapisano do %REPORT%.
pause
