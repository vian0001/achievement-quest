$env:PATH = [System.Environment]::GetEnvironmentVariable("PATH","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH","User")

$coauthor = "Co-authored-by: vian0002 <vian0002@users.noreply.github.com>"

$files = @(
    @{ branch = "pair/update-01"; file = "docs/setup.md";        content = "# Setup Guide`n`nRun ``python main.py`` to start the app."; message = "docs: add setup guide" },
    @{ branch = "pair/update-02"; file = "docs/usage.md";        content = "# Usage Guide`n`nImport utils.py for math helpers."; message = "docs: add usage guide" },
    @{ branch = "pair/update-03"; file = "docs/faq.md";          content = "# FAQ`n`n**Q: How do I run this?**`nA: Run ``python main.py``"; message = "docs: add FAQ page" },
    @{ branch = "pair/update-04"; file = "tests/test_main.py";   content = "def test_greet():`n    from main import greet`n    assert greet('GitHub') == 'Hello, GitHub! Welcome to Achievement Quest 🏆'"; message = "test: add test for greet function" },
    @{ branch = "pair/update-05"; file = "tests/test_utils.py";  content = "def test_add():`n    from utils import add`n    assert add(2, 3) == 5`n`ndef test_divide():`n    from utils import divide`n    assert divide(10, 2) == 5.0"; message = "test: add tests for utils functions" },
    @{ branch = "pair/update-06"; file = "scripts/run.sh";       content = "#!/bin/bash`necho 'Starting Achievement Quest...'`npython main.py"; message = "feat: add run script" },
    @{ branch = "pair/update-07"; file = ".github/ISSUE_TEMPLATE.md"; content = "## Bug Report`n`n**Describe the bug:**`n`n**Steps to reproduce:**`n`n**Expected behavior:**"; message = "chore: add issue template" },
    @{ branch = "pair/update-08"; file = "docs/contributing.md"; content = "# Contributing`n`n1. Fork the repo`n2. Create a branch`n3. Submit a PR`n`nThanks for contributing! 🙌"; message = "docs: add contributing guide" },
    @{ branch = "pair/update-09"; file = "docs/roadmap.md";      content = "# Roadmap`n`n- [x] Initial release`n- [ ] Add more features`n- [ ] Write more tests`n- [ ] Publish to PyPI"; message = "docs: add project roadmap" }
)

$prs = @()

foreach ($item in $files) {
    git checkout main 2>$null
    git checkout -b $item.branch 2>$null

    $dir = Split-Path $item.file
    if ($dir) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }

    Set-Content -Path $item.file -Value $item.content -Encoding UTF8

    git add . 2>$null
    git commit -m "$($item.message)`n`n$coauthor" 2>$null
    git push origin $item.branch 2>$null

    $url = gh pr create --repo vian0001/achievement-quest --title $item.message --body "Paired contribution with vian0002." --base main --head $item.branch 2>&1
    $prNum = $url -replace ".*\/pull\/(\d+).*", '$1'
    $prs += $prNum
    Write-Host "✅ Created PR #$prNum for branch $($item.branch)"
}

Write-Host "`n📋 All PRs created: $($prs -join ', ')"
$prs | Set-Content -Path "pr_numbers.txt"
