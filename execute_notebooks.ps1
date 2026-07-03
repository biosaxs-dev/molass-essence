<#
.SYNOPSIS
Execute Jupyter notebooks with smart change detection.

.DESCRIPTION
Executes notebooks in the repository. Default: only changed notebooks since last commit.

.PARAMETER All
Execute all notebooks in the repository.

.PARAMETER Path
Execute specific notebook(s). Accepts wildcard patterns.

.PARAMETER Chapter
Execute all notebooks in a specific chapter (e.g., 20, 30).

.EXAMPLE
.\execute_notebooks.ps1
# Execute only changed notebooks

.EXAMPLE
.\execute_notebooks.ps1 -All
# Execute all notebooks

.EXAMPLE
.\execute_notebooks.ps1 -Path "chapters\20\gaussian.ipynb"
# Execute specific notebook

.EXAMPLE
.\execute_notebooks.ps1 -Chapter 20
# Execute all notebooks in chapter 20
#>

[CmdletBinding(DefaultParameterSetName='Changed')]
param(
    [Parameter(ParameterSetName='All')]
    [switch]$All,
    
    [Parameter(ParameterSetName='Path')]
    [string[]]$Path,
    
    [Parameter(ParameterSetName='Chapter')]
    [string]$Chapter
)

$ErrorActionPreference = 'Stop'

# Check if jupyter nbconvert is available
try {
    $null = jupyter nbconvert --version
} catch {
    Write-Error "jupyter nbconvert not found. Install with: pip install jupyter nbconvert"
    exit 1
}

# Get list of notebooks to execute
$notebooks = @()

switch ($PSCmdlet.ParameterSetName) {
    'All' {
        Write-Host "Executing all notebooks..." -ForegroundColor Cyan
        $notebooks = Get-ChildItem -Path "chapters" -Recurse -Filter "*.ipynb" | Select-Object -ExpandProperty FullName
    }
    
    'Path' {
        Write-Host "Executing specific notebook(s)..." -ForegroundColor Cyan
        foreach ($p in $Path) {
            if (Test-Path $p) {
                $notebooks += (Resolve-Path $p).Path
            } else {
                Write-Warning "Path not found: $p"
            }
        }
    }
    
    'Chapter' {
        Write-Host "Executing notebooks in chapter $Chapter..." -ForegroundColor Cyan
        $chapterPath = "chapters\$Chapter"
        if (Test-Path $chapterPath) {
            $notebooks = Get-ChildItem -Path $chapterPath -Filter "*.ipynb" | Select-Object -ExpandProperty FullName
        } else {
            Write-Error "Chapter path not found: $chapterPath"
            exit 1
        }
    }
    
    'Changed' {
        Write-Host "Detecting changed notebooks..." -ForegroundColor Cyan
        
        # Get changed notebooks from git
        $gitDiff = git diff --name-only HEAD
        $gitStatus = git status --porcelain
        
        $changedFiles = @()
        $changedFiles += $gitDiff -split "`n" | Where-Object { $_ -match '\.ipynb$' }
        $changedFiles += ($gitStatus -split "`n" | ForEach-Object { 
            if ($_ -match '^\s*[AM]\s+(.+\.ipynb)$') { $matches[1] }
        })
        
        $changedFiles = $changedFiles | Select-Object -Unique | Where-Object { $_ }
        
        if ($changedFiles.Count -eq 0) {
            Write-Host "No changed notebooks detected." -ForegroundColor Green
            Write-Host "Use -All to execute all notebooks." -ForegroundColor Yellow
            exit 0
        }
        
        foreach ($file in $changedFiles) {
            $fullPath = Join-Path $PWD $file
            if (Test-Path $fullPath) {
                $notebooks += $fullPath
            }
        }
    }
}

if ($notebooks.Count -eq 0) {
    Write-Host "No notebooks to execute." -ForegroundColor Yellow
    exit 0
}

# Execute notebooks
Write-Host ""
Write-Host "Executing $($notebooks.Count) notebook(s):" -ForegroundColor Cyan
Write-Host ""
$notebooks | ForEach-Object { Write-Host "  - $($_ | Split-Path -Leaf)" }
Write-Host ""

$success = @()
$failed = @()

foreach ($notebook in $notebooks) {
    $name = Split-Path $notebook -Leaf
    Write-Host "Executing: $name" -ForegroundColor White -NoNewline
    
    # Capture stderr but don't treat it as an exception
    $ErrorActionPreference = 'Continue'
    $output = jupyter nbconvert --to notebook --execute --inplace $notebook 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host " [OK]" -ForegroundColor Green
        $success += $name
    } else {
        Write-Host " [FAILED]" -ForegroundColor Red
        Write-Host "Output: $output" -ForegroundColor Yellow
        $failed += $name
    }
}

# Summary
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Summary:" -ForegroundColor Cyan
Write-Host "  Success: $($success.Count)" -ForegroundColor Green
Write-Host "  Failed:  $($failed.Count)" -ForegroundColor $(if ($failed.Count -gt 0) { 'Red' } else { 'Green' })

if ($failed.Count -gt 0) {
    Write-Host ""
    Write-Host "Failed notebooks:" -ForegroundColor Red
    $failed | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
    exit 1
}

Write-Host ""
Write-Host "All notebooks executed successfully." -ForegroundColor Green
exit 0
