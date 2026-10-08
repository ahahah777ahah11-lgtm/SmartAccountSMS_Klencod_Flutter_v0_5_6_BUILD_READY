@echo off
setlocal
set GRADLE_VERSION=8.14.3
set GRADLE_HOME_DIR=%USERPROFILE%\.gradle\smartaccount-gradle-%GRADLE_VERSION%
set GRADLE_BIN=%GRADLE_HOME_DIR%\gradle-%GRADLE_VERSION%\bin\gradle.bat
if not exist "%GRADLE_BIN%" (
  if not exist "%GRADLE_HOME_DIR%" mkdir "%GRADLE_HOME_DIR%"
  powershell -NoProfile -ExecutionPolicy Bypass -Command "$ProgressPreference='SilentlyContinue'; Invoke-WebRequest 'https://services.gradle.org/distributions/gradle-%GRADLE_VERSION%-bin.zip' -OutFile '%GRADLE_HOME_DIR%\gradle.zip'; Expand-Archive -Force '%GRADLE_HOME_DIR%\gradle.zip' '%GRADLE_HOME_DIR%'; Remove-Item '%GRADLE_HOME_DIR%\gradle.zip'"
  if errorlevel 1 exit /b 1
)
call "%GRADLE_BIN%" %*
