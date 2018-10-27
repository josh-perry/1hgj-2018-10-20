function LintMoon {
    moonc -l src

    if ($? -eq $False) {
        Write-Host "Linter errors!"
        exit
    }
}

function BuildLua {
    moonc src

    if ($? -eq $False) {
        Write-Host "Build failed!"
        exit
    }
}

function BuildAseprite {
    if (!(Test-Path img)) {
        New-Item -ItemType Directory -Force -Path img
    }

    cd img

    $asepriteFiles = Get-ChildItem -Path . -Filter *.aseprite

    $asepriteFiles | ForEach-Object {
        $noExt = [System.IO.Path]::GetFileNameWithoutExtension($_)

        Write-Host $("Exporting $_ to '$noExt.png' & '$noExt.json'")
        aseprite -b $_ --data $("$noExt.json") --format json-array --sheet $("$noExt.png")
    }

    cd ..
}

function RunGame {
    love . --console
}