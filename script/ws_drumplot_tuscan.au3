#include <Date.au3>
$flag = 0
while $flag = 0
   ;sleep(60000)
 	if WinExists("WINSTON DRUM PLOT TUSCAN NETWORK") then
	else
	  Run("C:\Users\giacomo\Documents\MATLAB\toolseis\ws_drumplot\compiled\ws_drumplot\src\ws_drumplot.exe tuscan", "", @SW_MINIMIZE)
	  sleep (180000)
	endif
	$file =  FileGetTime("C:\Users\giacomo\Documents\MATLAB\toolseis\ws_drumplot\log\tuscan.log")
	If Not @error Then
		$t_file= $file[0] & "/" & $file[1] & "/" & $file[2] & " " & $file[3] & ":" & $file[4]
		$iDateCalc = _DateDiff( 's',$t_file,_NowCalc())
		If $iDateCalc > 300 Then
			WinKill("WINSTON DRUM PLOT TUSCAN NETWORK", "")
			sleep(60000)
		EndIf
	 EndIf
	  sleep(30000)
wend



