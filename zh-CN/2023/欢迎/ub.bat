@echo off
setlocal enabledelayedexpansion

REM =========================
REM **配置：旧/新 URL 前缀**
REM =========================
set "OLD=https://gitee.com/SHthemW/Blog-Images/raw/master/"
set "NEW=https://raw.githubusercontent.com/SHW2002/Blog.Images/master/"

echo.
echo === Replacing in all .md under: "%cd%" ===
echo OLD: %OLD%
echo NEW: %NEW%
echo Backup: *.bak
echo.

REM 遍历当前目录及子目录所有 .md
for /r %%F in (*.md) do (
  echo Processing: "%%F"

  powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$p='%%F';" ^
    "$old='%OLD%'; $new='%NEW%';" ^
    "$text=Get-Content -LiteralPath $p -Raw -Encoding UTF8;" ^
    "if($text -notmatch [regex]::Escape($old)){ exit 0 }" ^
    "Copy-Item -LiteralPath $p -Destination ($p + '.bak') -Force;" ^
    "$text = $text -replace [regex]::Escape($old), $new;" ^
    "Set-Content -LiteralPath $p -Value $text -Encoding UTF8;"

  if errorlevel 1 (
    echo   [FAIL] %%F
  ) else (
    echo   [OK]
  )
)

echo.
echo === Done. ===
endlocal
