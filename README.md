# Recursive Folder Scanner

A PowerShell script that recursively scans all folders in the current directory, counts their subfolders, and generates a detailed report.

## Features

- **Recursive Scanning**: Processes all folders and subfolders at every level
- **Smart Filtering**: Automatically excludes hidden folders (starting with `.`) and Python cache folders (`__pycache__`)
- **Progress Tracking**: Real-time progress bar showing current status and completion percentage
- **Detailed Output**: Generates a comprehensive list with full paths and subfolder counts
- **Error Handling**: Gracefully handles permission errors and inaccessible folders

## Output Format

The script generates a file called `folderList.txt` with entries in this format:
```
D:\Projects\MyApp (15 subfolders)
D:\Projects\MyApp\src (3 subfolders)
D:\Projects\MyApp\src\components (0 subfolders)
D:\Projects\MyApp\tests (2 subfolders)
```

## Usage

1. **Open PowerShell** in the directory you want to scan
2. **Copy and paste** the script into PowerShell
3. **Press Enter** to execute
4. **Wait for completion** - the progress bar will show current status
5. **Check the results** in the generated `folderList.txt` file

## Script Code

```powershell
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
```

## What Gets Excluded

The script automatically ignores:

### Hidden/System Folders (starting with dot)
- `.git` - Git version control folders
- `.vscode` - Visual Studio Code settings
- `.idea` - JetBrains IDE settings
- `.npm` - Node.js package manager cache
- `.env` - Environment configuration folders

### Python Cache Folders
- `__pycache__` - Python bytecode cache directories

## Performance Notes

- **Large Directory Trees**: For directories with thousands of folders, the initial discovery phase may take a few minutes
- **Network Drives**: Scanning network-mapped drives will be slower than local drives
- **Permissions**: Folders requiring elevated permissions are skipped automatically
- **Progress Updates**: The progress bar updates in real-time to show current status

## Troubleshooting

### Script Won't Run
- **Execution Policy**: Run `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser` if you get execution policy errors
- **Permissions**: Ensure you have read access to the directories you want to scan

### No Output File
- **Write Permissions**: Verify you have write access to the current directory
- **File in Use**: Close `folderList.txt` if it's open in another program

### Incomplete Results
- **Access Denied**: Some folders may be skipped due to permission restrictions (this is normal)
- **Long Paths**: Windows path length limitations may affect very deep folder structures

## Example Output

For a typical project directory:
```
D:\MyProject\src (12 subfolders)
D:\MyProject\src\components (3 subfolders)
D:\MyProject\src\components\ui (0 subfolders)
D:\MyProject\src\components\forms (0 subfolders)
D:\MyProject\src\components\layout (0 subfolders)
D:\MyProject\src\utils (2 subfolders)
D:\MyProject\src\utils\helpers (0 subfolders)
D:\MyProject\src\utils\constants (0 subfolders)
D:\MyProject\tests (5 subfolders)
D:\MyProject\docs (1 subfolders)
D:\MyProject\docs\images (0 subfolders)
```

## Requirements

- **PowerShell 5.0+** (included with Windows 10/11)
- **Read access** to target directories
- **Write access** to current directory (for output file)

## License

This script is provided as-is for general use. Feel free to modify and distribute as needed.
