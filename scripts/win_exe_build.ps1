<#
    .SYNOPSIS
        This script creates the win .MSI
#>
param (
    # Target architecture: amd64 (default) or 386
    [ValidateSet("amd64", "386")]
    [string]$arch="amd64",
    [string]$exporterName="",
    [string]$exporterURL="",
    [string]$exporterHead="",
    [string]$dependencyManager
)

$env:GOPATH = go env GOPATH
$env:GOOS = "windows"
$env:GOARCH = $arch
$env:GO111MODULE = "auto"

$exporterBinaryName = "$exporterName-exporter.exe"
$exporterRepo =  [string]"$exporterURL" -replace 'https?://(www.)?'

$projectRootPath = pwd


echo "--- Cloning exporter Repo"
Push-Location $env:GOPATH\src
$ErrorActionPreference = "SilentlyContinue"
git clone $exporterURL $exporterRepo
$ErrorActionPreference = "Stop"
Set-Location "$env:GOPATH\src\$exporterRepo"


$ErrorActionPreference = "SilentlyContinue"
git fetch -at
git checkout "$exporterHead"
$ErrorActionPreference = "Stop"

echo "--- Downloading dependencies"
$ErrorActionPreference = "SilentlyContinue"
if ($dependencyManager -eq "modules"){
    go mod download
} elseif ($dependencyManager -eq "dep"){
    dep ensure
}

$ErrorActionPreference = "Stop"


echo "--- Compiling exporter"
go build -v -o $exporterBinaryName
if (-not $?)
{
    echo "Failed building exporter"
    exit -1
}

Pop-Location
New-item -type directory -path .\exporters\$exporterName\target\bin\windows_$arch\ -Force
Copy-Item "$env:GOPATH\src\$exporterRepo\$exporterBinaryName" -Destination ".\exporters\$exporterName\target\bin\windows_$arch\" -Force 
if (-not $?)
{
    echo "Failed building exporter"
    exit -1
}
Copy-Item "$env:GOPATH\src\$exporterRepo\LICENSE" -Destination ".\exporters\$exporterName\target\bin\windows_$arch\$exporterName-LICENSE" -Force 
{
    echo "Failed building exporter"
    exit -1
}