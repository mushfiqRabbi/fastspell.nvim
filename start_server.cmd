@echo off
cd "%~dp0"
cd jslib
node --experimental-transform-types --no-warnings src/main.ts
    
