param(  [string]$Configuration="Release", 
        [string]$Platform="x64", 
        [string]$BuildDirName="out/build",
        [bool]$CleanBuild=$true,
        [string]$OutputDir="", 
        [string]$OutputName=""
)

# check values
if([string]::IsNullOrEmpty($BuildDirName))
{
    Write-Error -ForegroundColor Red "BuildDirName parameter can not be null or empty"
}

if([string]::IsNullOrEmpty($Configuration) -or [string]::IsNullOrEmpty($Platform) )
{
    Write-Error -ForegroundColor Red "Configuration and Platform parameters can not be null or empty."
}

switch ($Configuration) 
{
    "Release" { break }
    "Debug" { break }
    "MinSizeRel"{ break }
    "RelWithDebInfo" { break }
    Default { Write-Error -ForegroundColor Red "Unsupported build configuration. It should be either Release or Debug or MinSizeRel or RelWithDebInfo"}
}

# Specify current dir
$currentPath = $MyInvocation.MyCommand.Path
$currentDir = Split-Path -parent $currentPath
Push-Location $currentDir
Write-Host "CurrentDir $currentDir" -ForegroundColor Green

# Set up global build directory
$BuildDir = Join-Path -Path $currentDir -ChildPath $BuildDirName
if(Test-Path $BuildDir)
{
    if($CleanBuild)
    {
        Remove-Item $BuildDir -Recurse -Force
    }
}
else
{
    New-Item -Path $currentDir -Name $BuildDirName -ItemType "directory"
}

Write-Host "================================" -ForegroundColor Yellow
Write-Host "       System Info              " -ForegroundColor Yellow
Write-Host "================================" -ForegroundColor Yellow

$IsWin = $false
$IsUnix = $false
$operatingSystem = [System.Environment]::OSVersion.Platform
switch ($operatingSystem)
{
    $operatingSystem::Win32NT { $IsWin = $true }
    $operatingSystem::Win32S {$IsWin = $true }
    $operatingSystem::Win32Windows { $IsWin = $true }
    $operatingSystem::WinCE { $IsWin = $true }
    $operatingSystem::Unix { $IsUnix = $true }
    Default {Write-Error "Can not specify the operating system" -ForegroundColor Red }
}

$systemInfo = [System.Environment]::OSVersion 
Write-Host "System Info: $systemInfo"

Write-Host "================================" -ForegroundColor Yellow
Write-Host "       Build & Install          " -ForegroundColor Yellow
Write-Host "================================" -ForegroundColor Yellow
if ($IsWin) 
{
    #set up build directory
    $localBuildDirName="win-"
    switch ($Platform) 
    {
        "x64" { $localBuildDirName = $localBuildDirName + $Platform }
        "x86" 
        {
            $localBuildDirName = $localBuildDirName + $Platform
            $Platform = "Win32"
            break
        }
        "Win32"
        {
            $localBuildDirName = $localBuildDirName + "x86" 
            break
        }
        Default {Write-Error -ForegroundColor Red "Platform name can only be x64, x86 or Win32"}
    }

    # create or clean build directory
    $localBuildDir = Join-Path -Path $BuildDir -ChildPath $localBuildDirName
    if(Test-Path $localBuildDir)
    {
        if($CleanBuild)
        {
            Remove-Item $localBuildDir -Recurse -Force
        }
    }
    else
    {
        New-Item -Path $BuildDir -Name $localBuildDirName -ItemType "directory"
    }

    # Build/win-<arch>
    $relativeBuildDir = $BuildDirName + "/" + $localBuildDirName
    $isCleanBuild = if($CleanBuild){1} else {0}
    
    .\scripts\win\cmake_win_build.bat "Visual Studio 16 2019" $Platform $Configuration $relativeBuildDir $isCleanBuild
}
else
{
    
}


