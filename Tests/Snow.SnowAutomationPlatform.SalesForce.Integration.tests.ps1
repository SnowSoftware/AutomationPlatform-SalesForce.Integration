param ( 
    $moduleRoot = "$PSScriptRoot\..\Snow.SnowAutomationPlatform.SalesForce.Integration"
)

$moduleName = Split-Path $moduleRoot -Leaf

Remove-Module $moduleName -Force -ErrorAction SilentlyContinue

Write-verbose "Testing against module found in: $(Resolve-Path $moduleRoot)"

Describe "General project validation: $moduleName" {
    $scripts = Get-ChildItem $moduleRoot -Include *.ps1, *.psm1, *.psd1 -Recurse

    # TestCases are splatted to the script so we need hashtables
    $testCase = $scripts | Foreach-Object {@{file = $_}}         
    
    It "Script <file> should be valid powershell" -TestCases $testCase {
        param($file)

        $contents = Get-Content -Path $file.fullname -ErrorAction Stop
        $errors = $null
        $null = [System.Management.Automation.PSParser]::Tokenize($contents, [ref]$errors)
        $errors.Count | Should Be 0
    }

    It "Module '$moduleName' can import cleanly" {
        {Import-Module (Join-Path $moduleRoot "$moduleName.psm1") -force } | Should Not Throw
    }
}

Describe 'General Module validation' {
    Remove-Module $moduleName -Force -ErrorAction SilentlyContinue
    Import-Module $moduleRoot

    it 'Module manifest should be valid' {
        Test-ModuleManifest -Path "$(Join-Path $moduleRoot $moduleName).psd1" | Should -Not -BeNullOrEmpty
    }

    context 'Validation of exported commands' {
        $ExportedCommands = Get-Command -Module $ModuleName | Select-Object -ExpandProperty Name
        Foreach ($CommandName in $ExportedCommands) { 
            $HelpContents = Get-Help $CommandName
            
            It "All exported commands should have help Synopsis, command under test: [$CommandName]" {
                $HelpContents.Synopsis | Should -Not -BeNullOrEmpty   
            }
            It "All exported commands should have help description, command under test: [$CommandName]" {
                $HelpContents.description | Should -Not -BeNullOrEmpty   
            }
        }
    }
    
}

