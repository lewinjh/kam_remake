echo called build_all.bat

@REM ============================================================
@REM Build everything in the project group
@REM ============================================================

@REM msbuild needs variables set by rsvars
call rsvars.bat

@REM build everything
msbuild ..\KaMProjectGroup.groupproj /p:config=Release /t:Build /clp:ErrorsOnly /fl /flp:LogFile="build_all.log"