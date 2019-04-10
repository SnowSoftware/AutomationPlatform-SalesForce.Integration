#Requires -Modules @{ModuleName='InvokeBuild';ModuleVersion='3.2.1'}
#Requires -Modules @{ModuleName='PowerShellGet';ModuleVersion='1.0.0'}
#Requires -Modules @{ModuleName='Pester';ModuleVersion='4.1.1'}
#Requires -Modules @{ModuleName='platyPS';ModuleVersion='0.9.0'}

# Code, helpermodule, and yml file copied and adapted from Simon W�hlin
# https://github.com/SimonWahlin

Set-Location ..
$BuildRoot = '.'
$Script:ModuleName = 'Snow.SnowAutomationPlatform.SalesForce.Integration'
$Script:IsAppveyor = $env:APPVEYOR -ne $null

Get-Module -Name $ModuleName,'Snow.SnowAutomationPlatform.SalesForce.Integration.BUILDHELPERS' | Remove-Module -Force
Import-Module "$BuildRoot\build\Snow.SnowAutomationPlatform.SalesForce.Integration.BUILDHELPERS.psm1"

task Clean {
    Remove-Item -Path ".\Bin" -Recurse -Force -ErrorAction SilentlyContinue
}

task TestCode {
    Write-Build Yellow "`n`n`nTesting dev code before build"
    $TestResult = Invoke-Pester -Script "$BuildRoot\Tests\" -PassThru
    if($TestResult.FailedCount -gt 0) {
        throw 'Tests failed'
    }
}

task CopyFiles {
    $null = New-Item -Path "$BuildRoot\bin\$ModuleName" -ItemType Directory
    Copy-Item -Path "$BuildRoot\$ModuleName\*.psd1" -Destination "$BuildRoot\bin\$ModuleName"
    Get-ChildItem -Path "$BuildRoot\license*" | Copy-Item -Destination "$BuildRoot\bin\$ModuleName"
}

task CompilePSM {
    $PrivatePath = "$BuildRoot\$ModuleName\Private\*.ps1"
    $PublicPath  = "$BuildRoot\$ModuleName\Public\*.ps1"
    Merge-ModuleFiles -Path $PrivatePath,$PublicPath -OutputPath "$BuildRoot\bin\$ModuleName\$ModuleName.psm1"

    $PublicScriptBlock = Get-ScriptBlockFromFile -Path $PublicPath
    $PublicFunctions = Get-FunctionFromScriptblock -ScriptBlock $PublicScriptBlock
    $PublicAlias = Get-AliasFromScriptblock -ScriptBlock $PublicScriptBlock
    
    $PublicFunctionParam = ''
    $PublicAliasParam = ''
    
    $UpdateManifestParam = @{}
    if(-Not [String]::IsNullOrEmpty($PublicFunctions)) {
        $PublicFunctionParam = "-Function '{0}'" -f ($PublicFunctions -join "','")
        $UpdateManifestParam['FunctionsToExport'] = $PublicFunctions
    }
    if($PublicAlias) {
        $PublicAliasParam = "-Alias '{0}'" -f ($PublicAlias -join "','")
        $UpdateManifestParam['AliasesToExport'] = $PublicAlias
    }

    if ($IsAppveyor) { 
        $UpdateManifestParam['ModuleVersion'] = $env:APPVEYOR_BUILD_VERSION
    }

    $ExportStrings = 'Export-ModuleMember',$PublicFunctionParam,$PublicAliasParam | Where-Object {-Not [string]::IsNullOrWhiteSpace($_)}
    $ExportStrings -join ' ' | Out-File -FilePath  "$BuildRoot\bin\$ModuleName\$ModuleName.psm1" -Append -Encoding UTF8

    if ($UpdateManifestParam.Count -gt 0) {
        Update-ModuleManifest -Path "$BuildRoot\bin\$ModuleName\$ModuleName.psd1" @UpdateManifestParam
    }
}

task MakeHelp -if (Test-Path -Path "$BuildRoot\docs") {
    New-ExternalHelp -Path ".\docs" -OutputPath "$BuildRoot\bin\$ModuleName\en-US"
}

task TestBuiltCode {
    Write-Build Yellow "`n`n`nTesting compiled code after build"
    $BuildModuleRoot = "$BuildRoot\bin\$ModuleName"
    $TestResult = Invoke-Pester -Script @{
        'Path' = "$BuildRoot\Tests\" 
        'Parameters' = @{
            'moduleRoot' = $BuildModuleRoot 
        }
    } -PassThru -CodeCoverage "$BuildModuleRoot\$ModuleName.psm1"
    

    if($TestResult.FailedCount -gt 0) {
        throw 'Tests failed'
    }
}

task . Clean, TestCode, Build

task Build CopyFiles, CompilePSM, MakeHelp, TestBuiltCode