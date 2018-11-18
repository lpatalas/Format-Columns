﻿$CurrentDir = (Split-Path $MyInvocation.MyCommand.Definition)
$TestsDir = (Join-Path $CurrentDir 'TestData')

function Clear-Directory($path) {
    Remove-Item (Join-Path $path '*') -Force -Recurse
}

function Create-Directory($path) {
    New-Item $path -ItemType Directory | Out-Null
}

function Create-File($path) {
    New-Item $path -ItemType File | Out-Null
}

function Generate-Files($directoryPath, $count = 3, $prefix = '') {
    1..$count | %{ Create-File (Join-Path $directoryPath "$prefix$_.txt") }
}

function Prepare-TestData {
    if (-not (Test-Path $TestsDir)) {
        Create-Directory $TestsDir
    }

    Clear-Directory $TestsDir
    Create-Directory "$TestsDir\Empty"

    Create-Directory "$TestsDir\Subfolders"
    Generate-Files "$TestsDir\Subfolders"
    foreach ($folderNumber in 1..3) {
        Create-Directory "$TestsDir\Subfolders\$folderNumber"
        Generate-Files "$TestsDir\Subfolders\$folderNumber"
    }

    Create-Directory "$TestsDir\Columns"
    Generate-Files "$TestsDir\Columns" -count 100 -prefix test

    $consoleWidth = $Host.UI.RawUI.BufferSize.Width
    $leftLength = [Math]::Floor(($consoleWidth - 1) / 2)
    $rightLength = $consoleWidth - $leftLength - 1

    Create-Directory "$TestsDir\FitWidth"
    Create-File (Join-Path "$TestsDir\FitWidth" ('a' * $leftLength))
    Create-File (Join-Path "$TestsDir\FitWidth" ('b' * $leftLength))
    Create-File (Join-Path "$TestsDir\FitWidth" ('c' * $rightLength))
    Create-File (Join-Path "$TestsDir\FitWidth" ('d' * $rightLength))
}

function Test($description, $script) {
    Write-Host "--- Testing $description" -ForegroundColor DarkYellow
    $measurements = Measure-Command { $script.Invoke() }
    Write-Host "--- Total time $($measurements.TotalMilliseconds) msec" -ForegroundColor DarkYellow
    Write-Host
}

Prepare-TestData

Test 'empty directory' {
    Get-ChildItem "$TestsDir\Empty" | Format-Columns -Property Name
}

Test 'listing folder contents non-recursively' {
    Get-ChildItem "$TestsDir\Subfolders" | Format-Columns -Property Name
}

Test 'organizing items into multiple columns' {
    Get-ChildItem "$TestsDir\Columns" | Format-Columns -Property Name
}

Test 'listing folder contents non-recursively in reverse order' {
    Get-ChildItem "$TestsDir\Subfolders" | Sort-Object -Descending | Format-Columns -Property Name
}

Test 'listing objects longer than console window width' {
    @{ Name = 'a' * ($Host.UI.RawUI.BufferSize.Width + 10) } `
        | Format-Columns -Property Name
}

Test 'listing folder contents recursively' {
    Get-ChildItem "$TestsDir\Subfolders" -Recurse | Format-Columns -Property Name
}

Test 'listing folder contents recursively grouped by directory' {
    Get-ChildItem "$TestsDir\Subfolders" -Recurse `
        | Format-Columns -Property Name -GroupBy { Convert-Path $_.PSParentPath }
}

Test 'listing folder contents recursively, sorted in descending order and grouped by directory' {
    Get-ChildItem "$TestsDir\Subfolders" -Recurse `
        | Sort-Object Name -Descending `
        | Format-Columns -Property Name -GroupBy { Convert-Path $_.PSParentPath }
}

Test 'displaying items fitting console width exactly' {
    Get-ChildItem "$TestsDir\FitWidth" | Format-Columns -Property Name
}

Test 'custom colors' {
    $colorScript = {
        switch -regex ($_.Name) {
            '1' { [ConsoleColor]::Red }
            '2' { [ConsoleColor]::Blue }
            '3' { [ConsoleColor]::Green }
        }
    }

    Get-ChildItem "$TestsDir\Subfolders" -Recurse `
        | Format-Columns `
            -Property Name `
            -GroupBy { Convert-Path $_.PSParentPath } `
            -ItemColors $colorScript
}