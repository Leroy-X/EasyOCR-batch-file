These batch files make it easy to use RapidOCR or PaddleOCR and get the result with just one click.

https://github.com/hiroi-sora/RapidOCR-json
https://github.com/hiroi-sora/PaddleOCR-json
https://github.com/RapidAI/RapidOcrOnnx
https://jqlang.github.io/jq/

Download files from the link above as needed and place them in the following structure.
The json version requires jq to extract text content.

After the screenshot is saved to the clipboard, run the .bat file. For example you can add it to the ShareX action.
The results will be automatically saved to the clipboard and opened using Notepad++ by default.

├─EasyOCR
│  │  PaddleOCR-json.bat
│  │  RapidOCR-json.bat
│  │  RapidOCROnnx.bat
│  │  jq-windows-amd64.exe
│  │  readme.txt
│  │
│  ├─PaddleOCR
│  │  │  PaddleOCR-json.exe
│  │  │  ...
│  │  └─models
│  │      │  ...
│  │
│  │─RapidOCR
│  │  │  RapidOCR-json.exe
│  │  │  ...
│  │  └─models
│  │      │  ...
│  │
│  └─RapidOCROnnx
│      │  RapidOCROnnx.exe
│      │  ...
│      └─models
│          │  ...
 ...