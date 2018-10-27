. "$PSScriptRoot\includes.ps1"

clear

LintMoon
BuildLua

cd src
cd ..

$source = "src"

$shipping = "shipping"
$cleanSource = "$shipping/src"
$loveFile = "$shipping/game.love"

Remove-Item $shipping -Recurse -ErrorAction Ignore

New-Item $cleanSource -ItemType "Directory"

Copy-Item -Recurse -Exclude @('*.moon', '*.tmx', '*.aseprite') "$source/*" $cleanSource

Compress-Archive "$cleanSource/*" "$shipping/bin.zip"
Rename-Item "$shipping/bin.zip" "game.love"

Invoke-Item "$shipping"