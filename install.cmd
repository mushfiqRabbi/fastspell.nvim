@echo off
cd "%~dp0"
cd jslib
call npm install
call npm run build

