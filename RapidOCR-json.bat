@echo off
REM 设置字符集编码为 UTF-8
chcp 65001 > nul

REM 跳转到批处理所在目录
cd /d "%~dp0"

REM 使用 PowerShell 检查剪贴板是否包含图像
powershell -command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.Clipboard]::ContainsImage()}" | findstr "True" > nul
if %errorlevel% neq 0 (
    echo No image found in the clipboard.
    timeout /t 1 > nul
    goto :end
)

REM 设置工作目录
cd ".\RapidOCR-json"

REM 运行 OCR，将剪贴板文件作为参数，去掉无效 json 内容，调用 jq 提取 text 字段的值并输出到 result.txt 文件
RapidOCR-json.exe --image_path="clipboard" | findstr "{" | powershell -Command "$jsonObject = $input | ConvertFrom-Json; $jsonObject.data.text -replace '\r\n', '' | Out-File -FilePath '..\result.txt' -Encoding utf8"

REM 回到当前目录
cd ..\

REM 将 result.txt 中的内容保存到剪贴板
type result.txt | clip

REM 使用 Notepad++ 打开 result.txt 文件
start notepad++ result.txt

:end
