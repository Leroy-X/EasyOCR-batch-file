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

REM 使用 PowerShell 保存剪贴板中的图像为文件，并重命名为 temp.png
powershell -command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.Clipboard]::GetImage().Save('temp.png')}"

REM 必须参数
.\RapidOCROnnx\RapidOcrOnnx.exe --models "./RapidOCROnnx/models" ^
--det ch_PP-OCRv3_det_infer.onnx ^
--cls ch_ppocr_mobile_v2.0_cls_infer.onnx ^
--rec ch_PP-OCRv3_rec_infer.onnx  ^
--keys ppocr_keys_v1.txt ^
--image temp.png ^

REM 可选参数
--numThread 4 ^
--padding 50 ^
--maxSideLen 1024 ^
--boxScoreThresh 0.5 ^
--boxThresh 0.3 ^
--unClipRatio 1.6 ^
--doAngle 1 ^
--mostAngle 1 ^
--GPU -1

REM 搜索关键字
set "searchTerm=FullDetectTime"

REM 清除已存在的输出文件
if exist "result.txt" del "result.txt"

REM 使用 findstr 查找包含搜索项的行号
for /f "delims=:" %%a in ('findstr /n /c:"%searchTerm%" "temp.png-result.txt"') do set "lineNumber=%%a"

REM 删除包含搜索项及之前的行
for /f "skip=%lineNumber% delims=" %%b in ('type "temp.png-result.txt"') do echo %%b >> "result.txt"

REM 删除临时文件
del "temp.png-result.txt"
del "temp.png-result.jpg"
del "temp.png"

REM 将 result.txt 中的内容保存到剪贴板
type result.txt | clip

REM 使用 Notepad++ 打开 result.txt 文件
start notepad++ result.txt

:end