@echo.
@echo Running CMake
@echo.
@echo off

SET GENERATOR=%1
SET PLATFORM=%2
SET CONFIGURATION=%3
SET BUILDDIR=%4
SET CLEANBUILD=%5
REM SET BUILDDIR=win-%2
REM if %PLATFORM%==Win32 (SET BUILDDIR=win-x86)


@echo Variables:
@echo Generator: %GENERATOR%
@echo Platform: %PLATFORM%
@echo Configuration: %CONFIGURATION%
@echo BuildDir: %BUILDDIR%
if %CLEANBUILD%==1 (
    @echo CleanBuild: true
) else (
    @echo CleanBuild: false
)
@echo.

@echo Generate
@echo.
if %CLEANBUILD%==1 (cmake -G %GENERATOR% -A %PLATFORM% -B %BUILDDIR% -DCMAKE_BUILD_TYPE=%CONFIGURATION%)
@echo.

@echo Build
@echo.
cmake --build %BUILDDIR% --config %CONFIGURATION% --verbose
@echo.

@REM @echo Install
@REM @echo.
@REM cmake --install %BUILDDIR% --config %CONFIGURATION% --verbose