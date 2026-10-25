[CmdletBinding()]
param(
    [ValidateSet('x64')]
    [string] $Target = 'x64',
    [ValidateSet('Debug', 'RelWithDebInfo', 'Release', 'MinSizeRel')]
    [string] $Configuration = 'RelWithDebInfo'
)

$ErrorActionPreference = 'Stop'

if ( $DebugPreference -eq 'Continue' ) {
    $VerbosePreference = 'Continue'
    $InformationPreference = 'Continue'
}

if ( $env:CI -eq $null ) {
    throw "Package-Windows.ps1 requires CI environment"
}

if ( ! ( [System.Environment]::Is64BitOperatingSystem ) ) {
    throw "Packaging script requires a 64-bit system to build and run."
}

if ( $PSVersionTable.PSVersion -lt '7.2.0' ) {
    Write-Warning 'The packaging script requires PowerShell Core 7. Install or upgrade your PowerShell version: https://aka.ms/pscore6'
    exit 2
}

function Package {
    trap {
        Write-Error $_
        exit 2
    }

    $ScriptHome = $PSScriptRoot
    $ProjectRoot = (Resolve-Path -Path "$PSScriptRoot/../..").Path
    $BuildSpecFile = "${ProjectRoot}/buildspec.json"

    $UtilityFunctions = Get-ChildItem -Path $PSScriptRoot/utils.pwsh/*.ps1 -Recurse

    foreach( $Utility in $UtilityFunctions ) {
        Write-Debug "Loading $($Utility.FullName)"
        . $Utility.FullName
    }

    $BuildSpec = Get-Content -Path ${BuildSpecFile} -Raw | ConvertFrom-Json
    $ProductName = $BuildSpec.name
    $ProductVersion = $BuildSpec.version

    $PortableZipName = "FloodTuber-Portable-v${ProductVersion}.zip"
    $PortableZipPath = "${ProjectRoot}/release/${PortableZipName}"

    Remove-Item -ErrorAction 'SilentlyContinue' -Path "${ProjectRoot}/release/*.zip", "${ProjectRoot}/release/*.exe"

    Log-Group "Creating portable archive ${PortableZipName}..."
    $CompressArgs = @{
        Path = "${ProjectRoot}/release/${Configuration}/${ProductName}"
        CompressionLevel = 'Optimal'
        DestinationPath = $PortableZipPath
        Verbose = ($Env:CI -ne $null)
    }
    Compress-Archive -Force @CompressArgs
    Log-Group

    Log-Group "Building Inno Setup Installer FloodTuber-Installer-${ProductVersion}.exe..."
    $ISCC = "C:\Program Files (x86)\Inno Setup 6\ISCC.exe"
    if ( -not (Test-Path $ISCC) ) {
        Write-Host "Installing Inno Setup via Chocolatey..."
        choco install innosetup -y --no-progress
    }

    $IssPath = "${ProjectRoot}/docs/release/installer_script.iss"
    $IssContent = Get-Content -Path $IssPath -Raw -Encoding UTF8
    # Write with UTF-8 BOM so Inno Setup renders Turkish characters properly
    [System.IO.File]::WriteAllText($IssPath, $IssContent, [System.Text.Encoding]::UTF8)

    $StageDir = "${ProjectRoot}/release/${Configuration}/${ProductName}"
    & $ISCC "/O${ProjectRoot}/release" "/DMyAppVersion=${ProductVersion}" "/DRepoRoot=${ProjectRoot}" "/DSourceStageDir=${StageDir}" $IssPath
    if ( $LASTEXITCODE -ne 0 ) {
        throw "Inno Setup compilation failed with exit code $LASTEXITCODE"
    }
    Log-Group
}

Package
