@echo off
cd "%~dp0"\..\..\jslib
call npm install
call npm run build

