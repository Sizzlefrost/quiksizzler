:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::Quiksizzler v5
::Written by Sizzlefrost, 2019
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@echo off
setlocal EnableDelayedExpansion
set %%Bd=0
set M=0
title=Quiksizzler v5
color 1B
break>"version.tmp"
break>"modinfo.tmp"
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::   I  N  I  T  I  A  L  I  Z  A  T  I  O  N   ::
::::::::::::::::::::::::::::::::::::::::::::::::::
::check that modinfo is not empty
for /f "usebackq tokens=1 delims= " %%a in (`findstr /b version "modinfo.txt"`) do (
if %%a EQU version goto:version else goto:fixmodinfo
)

::if modinfo was empty, it's filled with placeholder data (NOTE: version ticks up to 1.0.0.1)
:fixmodinfo
echo No version information was found within modinfo.txt. Recreating and filling new modinfo.txt with placeholder data...
::this explains some game crashes
echo WARNING: you may need to change the mod icon - it's possible the file QS puts as default doesn't actually exist!
echo name = autofilled mod name>modinfo.txt
echo author = autofilled author name>>modinfo.txt
echo icon = gui/icons/icon.png>>modinfo.txt
echo version = 1.0.0.0>>modinfo.txt
goto versionAdvance

::ask user which number of the version they'd like to increment
:version
for /f "usebackq tokens=1,3,4,5,6 delims=. " %%a in (`findstr "version" modinfo.txt`) do echo Found existing mod build: %%b.%%c.%%d.%%e
:versionAdvance
for /f "usebackq tokens=1,3,4,5,6 delims=. " %%a in (`findstr "version" modinfo.txt`) do echo %%a = %%b.%%c.%%d.%%e>version.tmp
echo [Format: Revision.Version.Feature.Build]
echo Type B to make a new build.
echo Type F to make a new feature.
echo Type V to make a new version.
echo Type R to make a new revision.
echo Type A to abort the building process.
choice /c:BFVRA /n /m "Select [B], [F], [V], [R] or [A]."
IF %ERRORLEVEL% EQU 1 goto executeBuild
IF %ERRORLEVEL% EQU 2 goto executeFeature
IF %ERRORLEVEL% EQU 3 goto executeVersion
IF %ERRORLEVEL% EQU 4 goto executeRevision
IF %ERRORLEVEL% EQU 5 goto abort
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::   M  O  D  I  N  F  O   ::
:::::::::::::::::::::::::::::
::make a build
:executeBuild
::next line stores the final digit of the version in the Bd variable - it's about to be deleted in the file
for /f "usebackq tokens=6 delims=. " %%a in (`findstr /b version "modinfo.txt"`) do set /a Bd =%%a+1
::next 3 lines do the following:
::1) look at version line, copy it to version.tmp except last digit (this WILL overwrite)
::2) copy the lines of modinfo.txt that are NOT version to modinfo.tmp (this WILL overwrite also)
::3) move modinfo.tmp on top of modinfo.txt (this WILL overwrite as well, and will suppress the confirmation popup)
::ENGLISH: this deletes the version line from modinfo.txt and partially puts it into a temporary file version.tmp, the other part is stored in a variable or is zero
for /f "usebackq tokens=1,3,4,5 delims=. " %%a in (`findstr /b version "modinfo.txt"`) do echo %%a = %%b.%%c.%%d.>version.tmp
findstr /v version modinfo.txt>modinfo.tmp
move /y modinfo.tmp modinfo.txt
::next line goes into the version file and takes its contents (partial version number) and adds the other part from variable, and puts result back into modinfo.txt as final version.
::for non-build variations, Bd will store feature/version/revision numbers and everything below them will be reset to form X.0.0.1 for rev, X.X.0.1 for ver, etc.
::The reason this is so overcomplicated is that any appending write effects always insert a newline at the start, so you have to write the whole version number at once,
::both the changed and unchanged parts, which is why the script jumped through all those hoops.
for /f "delims=" %%l in (version.tmp) do echo %%l!Bd!>>modinfo.txt
title Quiksizzler v5 - MODINFO OK
goto:scripts

::make a feature
:executeFeature
::feature stores the penultimate digit instead!
for /f "usebackq tokens=5 delims=. " %%a in (`findstr /b version "modinfo.txt"`) do set /a Bd =%%a+1
::this part is nearly unchanged: one less digit in version, but modinfo.txt and .tmp behave exactly the same
for /f "usebackq tokens=1,3,4 delims=. " %%a in (`findstr /b version "modinfo.txt"`) do echo %%a = %%b.%%c.>version.tmp
findstr /v version modinfo.txt>modinfo.tmp
move /y modinfo.tmp modinfo.txt
::this part is similar too, but we're keeping in mind we have only rev.ver. in version.tmp and only feat. in variable
::so we reset the build to 1
for /f "delims=" %%l in (version.tmp) do echo %%l!Bd!.1>>modinfo.txt
title Quiksizzler v5 - MODINFO OK
goto:scripts

::make a version
:executeVersion
::version stores the second, version, digit
for /f "usebackq tokens=4 delims=. " %%a in (`findstr /b version "modinfo.txt"`) do set /a Bd =%%a+1
::again, one less digit in version, only revision number remains there
for /f "usebackq tokens=1,3 delims=. " %%a in (`findstr /b version "modinfo.txt"`) do echo %%a = %%b.>version.tmp
findstr /v version modinfo.txt>modinfo.tmp
move /y modinfo.tmp modinfo.txt
::and we account for lack of value in feature slot by resetting it to zero, along with resetting build to 1 like above
for /f "delims=" %%l in (version.tmp) do echo %%l!Bd!.0.1>>modinfo.txt
title Quiksizzler v5 - MODINFO OK
goto:scripts

::make a revision
:executeRevision
::can you guess what's happening here?
for /f "usebackq tokens=3 delims=. " %%a in (`findstr /b version "modinfo.txt"`) do set /a Bd =%%a+1
::still required; version not only stores the number, but also the string "version = ". Somewhat redundant, though - it could be hardcoded.
for /f "usebackq tokens=1 delims=. " %%a i (`findstr /b version "modinfo.txt"`) do echo %%a = >version.tmp
findstr /v version modinfo.txt>modinfo.tmp
move /y modinfo.tmp modinfo.txt
for /f "delims=" %%l in (version.tmp) do echo %%l!Bd!.0.0.1>>modinfo.txt
title Quiksizzler v5 - MODINFO OK
goto:scripts
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::   S  C  R  I  P  T  S  .  Z  I  P   ::
:::::::::::::::::::::::::::::::::::::::::
:scripts
::check that scripts folder exists, update scripts.zip from it if it does
if exist "scripts" (
if exist scripts.zip del /q scripts.zip
powershell.exe -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('scripts', 'scripts.zip'); }"
) else ( 
echo "ERROR: Scripts folder not found. Proceeding without building scripts.zip..."
pause 
exit /b 0
)
title Quiksizzler v5 - SCRIPTS OK

choice /n /m "Would you like to update the .kwad files? [Y/N]"
::Before we move anywhere, let's save our current location so we can always recall to it
set M="%cd%"
IF %ERRORLEVEL% EQU 1 goto:kwadFind
IF %ERRORLEVEL% EQU 2 goto:end
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::   K  W  A  D     B  U  I  L  D  E  R   ::
::::::::::::::::::::::::::::::::::::::::::::
:kwadFind
::I have no idea where you would keep the KWAD builder. Neither does the script.
::So we'll have it search 3 places: 
::...steamapps\common\InvisibleInc
::...steamapps\common\Invisible Inc Mod Uploader
::and the desktop, because of course
cd..\..\..
cd "InvisibleInc"
dir /s /a:d "KWAD builder" >nul && (goto:kwadCall) || (set /a Bd+=1)
cd "Invisible Inc Mod Uploader"
dir /s /a:d "KWAD builder" >nul && (goto:kwadCall) || (set /a Bd+=1)
cd "%USERPROFILE%\Desktop"
dir /s /a:d "KWAD builder" >nul && (goto:kwadCall) || (set /a Bd+=1)
pause
if "%%Bd" EQU 3 (
	echo "ERROR: KWAD Builder not found. Proceeding without building .kwad files..."
	goto:end
)
::if you're here, something's gone terribly wrong
goto:abort

:kwadCall
::if we're here, we know KWAD builder folder exists in one of the three spots, but we're not sure where
::this next thing find the builder again and CHDIRs to it
for /f "usebackq delims=" %%a in (`dir /s /a:d /b "KWAD builder"`) do cd %%~dpa\KWAD builder
::now we run the builder
title Quiksizzler v5 - KWADBUILDER FOUND OK
call build.bat
::builder flooded the prompt with its own shenanigans, so we
cls
::...CLear Screen
echo KWAD BUILDER RUN COMPLETE
::now it should have output files into a subfolder called \out
cd "out"
::so we grab every .kwad we see and we put it back where the script is at (the mod directory)
for /f "usebackq delims=" %%a in (`dir /b /a:-d "*.kwad"`) do (move /y "%%a" !M!\%%~nxa)
::and we report success
title Quiksizzler v5 - KWADS OK
cd %M%
goto:end
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::   E  X  I  T  S   ::
:::::::::::::::::::::::
:end
::clean up temp version file - modinfo.tmp should already be gone since we moved it over the old one
if exist version.tmp del /q version.tmp
endlocal
for /f "usebackq tokens=3,4,5,6 delims=. " %%b in (`findstr /b version "modinfo.txt"`) do echo Build successful: written new version %%b.%%c.%%d.%%e
choice /n /m "Would you like to start Invisible, Inc.? [Y/N]"
IF %ERRORLEVEL% EQU 1 goto:launchGame
exit /b 0

:launchGame
::we're assuming you're making the mod inside the mod folder (duh, that's where I told you to place this file)
::that's steamapps\common\InvisibleInc\mods\<modname>
::so we're going two levels up to InvisibleInc, where the executable is located
cd..\..
start "Invisible Mod Test" "invisibleinc.exe"
exit /b 0

:abort
endlocal
::clean up temp files - in case of abort, it's possible modinfo.tmp won't overwrite modinfo.txt yet, so we're deleting it to be certain
if exist version.tmp del /q version.tmp
if exist modinfo.tmp del /q modinfo.tmp
echo Aborting...
exit /b 0