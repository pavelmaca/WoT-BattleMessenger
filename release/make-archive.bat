@ECHO OFF

REM FIX: Post-Build Command are executed from /project dir
CD release/

REM set variables
SET game_varsion=0.8.6
SET mod_version=2.1
SET output_file="[%game_varsion%] BattleMessenger - chat filter & antispam %mod_version%.rar"
SET input_files=BattleMessenger.swf BattleMessenger.conf

REM Delete old archive file
IF EXIST %output_file% (
	ECHO Deleting depracated file
	RM %output_file%
)

ECHO Creating new archive
"C:\Program Files\WinRAR\App\WinRAR-x64\rar.exe" a -ap"res_mods/%game_varsion%/gui/flash" %output_file% %input_files%

IF EXIST %output_file% (
	ECHO Creating MD5 checksum
	MD5SUM %output_file% > md5sum.txt
)