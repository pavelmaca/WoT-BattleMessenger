@ECHO OFF

SET patch_swfs=BattleMessenger.swf

FOR %%i IN (%patch_swfs%) DO CALL :do_file %%~ni

GOTO :EOF

:do_file
SET n=%1
IF NOT EXIST %n%.xml (
  ECHO %n%.swf
  SWFMILL swf2xml orig\%n%.swf orig\%n%.xml
  SWFMILL swf2xml %n%.swf %n%.xml
  DIFF -u -I "<StackDouble value=" orig\%n%.xml %n%.xml > %n%.xml.patch
  DEL orig\%n%.xml %n%.xml
)
GOTO :EOF