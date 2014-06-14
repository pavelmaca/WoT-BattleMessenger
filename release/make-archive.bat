@ECHO OFF

REM FIX: Post-Build Command are executed from /project dir
CD release/

REM set variables
SET game_varsion=0.9.1
SET mod_version=2.7.1
SET output_file="[%game_varsion%] BattleMessenger - chat filter & antispam %mod_version%.rar"
SET input_files=BattleMessenger.swf BattleMessenger.conf

REM Delete old archive file
IF EXIST %output_file% (
	ECHO Deleting depracated file
	RM %output_file%
)

ECHO Creating new archive
"C:\Program Files\WinRAR\rar.exe" a -ap"res_mods/%game_varsion%/gui/scaleform" %output_file% %input_files%
"C:\Program Files\WinRAR\rar.exe" u %output_file% "../readme.markdown"
"C:\Program Files\WinRAR\rar.exe" c -z"archive-readme.txt" %output_file%

IF EXIST %output_file% (
	ECHO Creating MD5 checksum
	MD5SUM %output_file% > md5sum.txt
)