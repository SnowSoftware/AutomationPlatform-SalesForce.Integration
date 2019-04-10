param ( 
    $moduleRoot = "$PSScriptRoot\..\Snow.SnowAutomationPlatform.SalesForce.Integration"
)

$moduleName = Split-Path $moduleRoot -Leaf

Remove-Module $moduleName -Force -ErrorAction SilentlyContinue
Import-Module $moduleRoot -Force -ErrorAction SilentlyContinue

Write-verbose "Testing against module found in: $(Resolve-Path $moduleRoot)"

InModuleScope $moduleName { 
    Describe 'New-APSalesForceUserObject' {
        $TestSplat = @{
                'Username'          = 'Username@username.com'         
                'Firstname'         = 'Firstname'        
                'Lastname'          = 'Lastname'         
                'Email'             = 'Email'            
                'Alias'             = 'Alias'            
                'CommunityNickname' = 'CommunityNickname' 
                'ProfileId'         = 'ProfileId012345'        
                'TimeZoneSidKey'    = 'Africa/Algiers'
                'LocaleSidKey'      = 'ar_AE'
                'EmailEncodingKey'  = 'UTF-8'
                'LanguageLocaleKey' = 'en_US'
        }

        Context 'Creating user objects, No token in parameters' {
            $a = New-APSalesForceUserObject @TestSplat

            $TestCaseBody = $TestSplat.Keys | ForEach-Object -Process {
                @{
                    'Name'  = $_
                    'Value' = $TestSplat.$_
                }
            }

            it 'Should return a hashtable with valid objects, verifying <Name>' -TestCases $TestCaseBody {
                param ($Name, $Value)

                $a.Body.$Name | Should -be $value
            }

            it 'Returned object endpoint should be set' { 
                $a.Endpoint | Should -be '/services/data/v41.0/sobjects/user/'
            }
                
            it 'Returned object Method should be set' { 
                $a.Method | Should -be 'Post'
            }
        }

        Context 'Creating user objects, token included in parameters' {
            it 'Should try to invoke the command if a usertoken is passed' {
                Mock -CommandName Invoke-APSalesForceRestMethod -MockWith {Return $True}
                
                $TestSplat.Add('AccessToken',(New-Object -TypeName psobject -Property @{}))
    
                New-APSalesForceUserObject @TestSplat | Should -Be $true
            }
    
            Assert-MockCalled -CommandName Invoke-APSalesForceRestMethod -Times 1 -Exactly
        }
    }
}