# 호숫가 모닥불: 직접 호스팅용 폴더(docs\)를 만든다 (GitHub Pages는 저장소의 /docs 폴더를 그대로 올린다).
# lakeside-campfire.html 을 완전한 HTML 문서로 감싸고 assets\ 를 함께 복사한다.
# 사용법:  powershell -ExecutionPolicy Bypass -File .\build-site.ps1
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$site = Join-Path $root "docs"
New-Item -ItemType Directory -Force $site | Out-Null
New-Item -ItemType Directory -Force (Join-Path $site "assets") | Out-Null

$body = [IO.File]::ReadAllText((Join-Path $root "lakeside-campfire.html"))
$head = @'
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover">
<style>
:root{color-scheme:light;padding-top:env(safe-area-inset-top,0px);padding-bottom:env(safe-area-inset-bottom,0px)}
body{margin:0;font:14px system-ui,-apple-system,"Segoe UI",sans-serif}
img{max-width:100%}
[hidden]{display:none!important}
</style>
</head>
<body>
'@
$html = $head + $body + "`n</body>`n</html>`n"
[IO.File]::WriteAllText((Join-Path $site "index.html"), $html, (New-Object Text.UTF8Encoding $false))
Copy-Item (Join-Path $root "assets\*") (Join-Path $site "assets") -Force
[IO.File]::WriteAllText((Join-Path $site ".nojekyll"), "")
$kb = [math]::Round(((Get-ChildItem $site -Recurse -File | Measure-Object Length -Sum).Sum) / 1KB)
Write-Output "docs\ 폴더를 만들었습니다 ($kb KB). 이 폴더를 통째로 정적 호스팅에 올리면 됩니다."
