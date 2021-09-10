@echo off
cd %~dp0
cd .\..\impl\Dart
echo Dart impl
if %1==cumo (
cd .\CUMO_Transer
pub publish
) else if %1==doc (
cd .\UMD_Documenter
pub publish
) else if %1==tools (
cd .\UMD_Tools
pub publish
)
cd %~dp0
