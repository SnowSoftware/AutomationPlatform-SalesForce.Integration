param ( 
    $moduleRoot = "$PSScriptRoot\..\Snow.SnowAutomationPlatform.SalesForce.Integration"
)

$moduleName = Split-Path $moduleRoot -Leaf

Remove-Module $moduleName -Force -ErrorAction SilentlyContinue
Import-Module $moduleRoot -Force -ErrorAction SilentlyContinue

Write-verbose "Testing against module found in: $(Resolve-Path $moduleRoot)"

InModuleScope $moduleName { 
    describe 'Invoke-APSalesForceRestMethod' {
        Context 'Testing various types of body to make sure we support all' {
            # This mock will make Invoke-APSalesForceRestMethod return the splat that would have been used in the invoke, instead of doing the actual invoke.
            Mock -CommandName Invoke-RestMethod -MockWith {return $splat}
            
            # Create a base splat to use.
            $TestSplat = @{
                'Endpoint' = 'Endpoint' 
                'AccessToken' = [psobject]$('AccessToken')
                'Method' = 'Post'
                'Body' = $null
            }
    
            [byte[]]$result = '123','34','66','111','100','121','34','58','34','66','111','100','121','34','125'
            
            $TestCaseBody = @(
                @{
                    Name = 'Json' 
                    Body = (New-Object -TypeName psobject -Property @{'Body' = 'Body'} | ConvertTo-Json -Compress)
                } 
                @{
                    Name = 'object' 
                    Body =  New-Object -TypeName psobject -Property @{'Body' = 'Body'}
                }
                @{
                    Name = 'ByteArray' 
                    Body = $result
                }
            )

            it 'Works with body as <Name> object' -TestCases $TestCaseBody {
                Param ($Name, $Body)

                $TestSplat.Body = $Body
                $a = Invoke-APSalesForceRestMethod @TestSplat
                $a.body | Should -BeExactly $result
            }

            it 'Body from <Name> object should be returned as Byte[] object' -TestCases $TestCaseBody {
                Param ($Name, $Body)

                $TestSplat.Body = $Body
                $a = Invoke-APSalesForceRestMethod @TestSplat
                $a.body.GetType().FullName | should -Be 'System.Byte[]'
            }
    
            Assert-MockCalled -CommandName Invoke-RestMethod -Times ($TestCaseBody.Count * 2) -Exactly
        }
    
        Context 'Testing other constructed token objects' {
            # This mock will make Invoke-APSalesForceRestMethod return the splat that would have been used in the invoke, instead of doing the actual invoke.
            Mock -CommandName Invoke-RestMethod -MockWith {return $splat}
            
            # Create a base splat to use.
            $TestSplat = @{
                'Endpoint' = 'Endpoint' 
                'AccessToken' = New-Object -TypeName psobject -Property @{
                    'instance_url' = 'http://Instance'
                    'access_token' = 'Access'
                }
                'Method' = 'Get'
            }
    
            $a = Invoke-APSalesForceRestMethod @TestSplat
    
            it 'Headers should be correct, Authorization part' {
                $a.Headers.Authorization | Should -Be 'Bearer Access'
            }

            it 'Headers should be correct, Accept part' {
                $a.Headers.Accept | Should -be 'application/json'
            }
            
            it 'Has the correct URI' {
                $a.URI | Should -Be 'http://Instance/Endpoint'
            }
    
            Assert-MockCalled -CommandName Invoke-RestMethod -Times 1 -Exactly
        }
    }
}