param ( 
    $moduleRoot = "$PSScriptRoot\..\Snow.SnowAutomationPlatform.SalesForce.Integration"
)

$moduleName = Split-Path $moduleRoot -Leaf

Remove-Module $moduleName -Force -ErrorAction SilentlyContinue
Import-Module $moduleRoot -Force -ErrorAction SilentlyContinue

Write-verbose "Testing against module found in: $(Resolve-Path $moduleRoot)"

InModuleScope $moduleName { 
    Describe 'Get-APSalesForceUser.ps1' {
        $TestSlpat = @{
            'SearchString' = 'UserName' 
            'Properties' =  'Alias'
            'EndpointVersion' = 1
        }
        
        Context 'Searching for users, no token in query' {
            $a = Get-APSalesForceUser @TestSlpat

            it 'returned object method should be "GET"' {
                $a.Method | Should -Be 'Get'
            }
            
            it 'returned object endpoint should be correctly constructed' {
                $a.Endpoint | Should -Be '/services/data/1/search/?q=FIND+{UserName}+IN+name+FIELDS+RETURNING+USER(Alias)'
            }
        }

        Context 'Searching for Profiles, added token in query' {
            # Add AccessToken to perform invoke
            $TestSlpat.Add('AccessToken', (New-Object -TypeName psobject))
            
            it 'Should try to invoke the search if a token is passed' {
                Mock -CommandName Invoke-APSalesForceRestMethod -MockWith {return $true}
                
                $Actual = Get-APSalesForceUser @TestSlpat 
                
                $Actual | Should -Be $true
            }
            
            it 'Should return hashtable if a token is passed but the query failed,returned object method should be "GET"' {
                Mock -CommandName Invoke-APSalesForceRestMethod -MockWith {throw}
                
                $Actual = Get-APSalesForceUser @TestSlpat -ErrorAction SilentlyContinue
    
                $Actual.Method | Should -Be 'Get'
            }
            
            it 'Should return hashtable if a token is passed but the query failed, returned object endpoint should be correctly constructed' {
                Mock -CommandName Invoke-APSalesForceRestMethod -MockWith {throw}
                
                $Actual = Get-APSalesForceUser @TestSlpat -ErrorAction SilentlyContinue
    
                $Actual.Endpoint | Should -Be '/services/data/1/search/?q=FIND+{UserName}+IN+name+FIELDS+RETURNING+USER(Alias)'
            }

            Assert-MockCalled -CommandName Invoke-APSalesForceRestMethod -Times 3 -Exactly
        }
    }
}