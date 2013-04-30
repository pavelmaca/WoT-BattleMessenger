@ECHO OFF

REM FIX: Post-Build Command are executed from /project dir
CD swf

SET copy_files=
SET patch_swfs=BattleMessenger.swf
SET patch_xmls=

REM Patch XMLs
FOR %%i IN (%patch_xmls%) DO CALL :do_patch_xml %%~ni

REM Copy files without patching
FOR %%i IN (%copy_files%) DO CALL :do_copy_file %%i

REM Patch SWFs
FOR %%i IN (%patch_swfs%) DO CALL :do_patch_swf %%~ni

GOTO :EOF

:do_copy_file
ECHO copying file %1
ECHO /Y orig\%1 %1 > nul
GOTO :EOF

:do_patch_swf
SET n=%1
SWFMILL swf2xml orig\%n%.swf orig\%n%.xml
COPY /Y orig\%n%.xml %n%.xml > nul
SET ok=failed
PATCH < %n%.xml.patch && SET ok=ok
ECHO patch result: %ok% (%n%.swf)
IF EXIST %n%.xml.orig DEL %n%.xml.orig
IF "%ok%" == "ok" (
  SWFMILL xml2swf %n%.xml %n%.swf
  DEL %n%.xml orig\%n%.xml
)
GOTO :EOF

:do_patch_xml
SET n=%1
COPY /Y orig\%n%.xml %n%.xml > nul
SET ok=failed
PATCH < %n%.xml.patch && SET ok=ok
ECHO patch result: %ok% (%n%.xml)
IF EXIST %n%.xml.orig DEL %n%.xml.orig
GOTO :EOF
