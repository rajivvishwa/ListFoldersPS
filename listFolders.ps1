# First, collect all folders to get accurate count (excluding dot folders and __pycache__)
Write-Host "Discovering all folders..." -ForegroundColor Yellow
$allFolders = Get-ChildItem -Directory -Recurse -ErrorAction SilentlyContinue | Where-Object {
    !$_.Name.StartsWith('.') -and $_.Name -ne '__pycache__'
}
$totalFolders = $allFolders.Count
$output = @()

Write-Host "Processing $totalFolders folders..." -ForegroundColor Green

for ($i = 0; $i -lt $totalFolders; $i++) {
    $folder = $allFolders[$i]
    $percentComplete = [math]::Round(($i / $totalFolders) * 100, 2)
    
    Write-Progress -Activity "Scanning All Folders Recursively" -Status "[$($i+1)/$totalFolders] $($folder.Name)" -PercentComplete $percentComplete
    
    # Count subfolders, also excluding dot folders and __pycache__
    $subfolderCount = (Get-ChildItem -Path $folder.FullName -Directory -Recurse -ErrorAction SilentlyContinue | 
        Where-Object {!$_.Name.StartsWith('.') -and $_.Name -ne '__pycache__'}).Count
    
    $result = "$($folder.FullName) ($subfolderCount subfolders)"
    $output += $result
}

Write-Progress -Activity "Scanning All Folders Recursively" -Completed
$output | Out-File -FilePath "folderList.txt" -Encoding UTF8
Write-Host "Completed! Output saved to folderList.txt ($totalFolders total folders processed)" -ForegroundColor Green
