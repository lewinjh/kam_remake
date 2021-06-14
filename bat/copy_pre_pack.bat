echo called copy_pre_pack.bat

REM Copy rx resorces from original game
xcopy "%KaMOrigDir%\data\gfx\res" ..\SpriteResource\ /y /r /s
xcopy "%KaMOrigDir%\data\gfx\*" ..\data\gfx /y /r 

mkdir ..\data\defines

REM Copy data files from original KaM TPR game
xcopy "%KaMOrigDir%\data\defines\houses.dat" ..\data\defines\houses.dat* /y /r /i
xcopy "%KaMOrigDir%\data\defines\unit.dat" ..\data\defines\unit.dat* /y /r /i
