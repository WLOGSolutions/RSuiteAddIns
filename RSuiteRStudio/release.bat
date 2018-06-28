@echo off

FOR /F "tokens=* USEBACKQ" %%F IN (`git tag`) DO (
    SET gitver=%%F
)

IF "%gitver%" == "" (
    echo ERROR: No GIT tag detected.
    goto error
)

set pkg_index=%~dp0\PKG_INDEX
del "%pkg_index%" 2> nul

echo Building/uploading RSuiteRStudio tag %gitver% onto S3 repository ...
call rsuite proj depsinst -v
if ERRORLEVEL 1 goto error
call rsuite repo addproj -s http://wlog-rsuite.s3.amazonaws.com -b F -v
if ERRORLEVEL 1 goto error
echo Building/uploading RSuiteRStudio tag %gitver% onto S3 repository ... done

:error
set zip=
echo Failed.
exit /B 1
