@echo off

REM 设置 OCR 引擎类型 (0 for RapidOCR, 1 for PaddleOCR)
set "OCREng=0"

REM 设置 jq 路径，相对引擎的上级目录
set "jq=..\jq-windows-amd64.exe"

REM 设置 OCR 可执行文件的路径和参数
if "%OCREng%"=="0" (
    set "OCRDir=.\RapidOCR"
    set "OCRPath=.\RapidOCR-json.exe"
    set "OCRParameter=--image_path"
) else (
    set "OCRDir=.\PaddleOCR"
    set "OCRPath=.\PaddleOCR-json.exe"
    set "OCRParameter=-image_path"
)

REM 使用 PowerShell 检查剪贴板是否包含图像
powershell -command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.Clipboard]::ContainsImage()}" | findstr "True" > nul
if %errorlevel% neq 0 (
    echo No image found in the clipboard.
    timeout /t 1 > nul
    goto :end
)

REM 跳转到批处理所在目录
cd /d "%~dp0"

REM 设置工作目录
cd %OCRDir%

REM 运行 OCR，将剪贴板文件作为参数，去掉无效 json 内容，调用 jq 提取 text 字段的值并输出到 result.txt 文件
"%OCRPath%" %OCRParameter%="clipboard" | findstr "{" | %jq% -r ".data[].text" > ..\result.txt

REM 回到当前目录
cd ..\

REM 将 result.txt 中的内容保存到剪贴板
type result.txt | clip

REM 使用 Notepad++ 打开 result.txt 文件
start notepad++ result.txt

:end
