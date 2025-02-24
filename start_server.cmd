@echo off
cd "%~dp0"
cd jslib
node --experimental-transform-types src/main.ts
    
