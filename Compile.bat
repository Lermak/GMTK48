mkdir Release
powershell.exe -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('Game', 'Engine/Game.zip') }"
cd Engine
copy /b love.exe+Game.zip WiredUp.exe
move WiredUp.exe "../Release"
for /R . %%f in (*.dll) do copy %%f "../Release"
del Game.zip
cd ../
xcopy /s DeployFiles Release

magick convert "%~dp0Game/Data/Images/Icon.png" -background none -interpolate Nearest -filter point -define icon:auto-resize="256,128,96,64,48,32,16"  -flatten -colors 256 "%~dp0Game/Data/Images/Icon.ico"
cd Release
"%~dp0IconMaker/ResourceHacker.exe" -addoverwrite "WiredUp.exe", "WiredUp.exe", "%~dp0Game/Data/Images/Icon.ico", ICONGROUP, 1, 1
ie4uinit.exe -ClearIconCache
cd ../