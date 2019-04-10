param ( 
    $moduleRoot = "$PSScriptRoot\..\Snow.SnowAutomationPlatform.SalesForce.Integration"
)

$moduleName = Split-Path $moduleRoot -Leaf

Remove-Module $moduleName -Force -ErrorAction SilentlyContinue
Import-Module $moduleRoot -Force -ErrorAction SilentlyContinue

Write-verbose "Testing against module found in: $(Resolve-Path $moduleRoot)"

InModuleScope $moduleName { 
    Describe 'Connect-APSalesForce' {
        Context 'Successfull connection' {
    
            Mock -CommandName Invoke-RestMethod -MockWith {
                New-Object -TypeName PSCustomObject -Property @{
                    'access_token' = 'access_token'
                    'instance_url' = 'instance_url'
                    'id'           = 'id'
                    'token_type'   = 'token_type'
                    'issued_at'    = 'issued_at'
                    'signature'    = 'signature'
                }   
            } 
    
            $UserName = "Domain\User"
            $Password = 'SecretPassword' | ConvertTo-SecureString -AsPlainText -Force
            $CredentialObject = New-Object System.Management.Automation.PSCredential -ArgumentList $UserName, $Password 
            
            $splat = @{
                'SalesForceBaseURI' = 'https://www.random.uri' 
                'SalesForceUser' = $CredentialObject
                'SalesForceClientSecret' = 'abcd1234' 
                'SalesForceClientID' = '1' 
                'SalesForceToken' = 'token'
            }
            
            $return = Connect-APSalesForce @splat 
    
            it 'Should return proper login PSCustomObject' {
                $return.GetType().Name | Should -be 'PSCustomObject'
            }
            it 'Should contain 6 properties' {
                ($return | Get-Member -MemberType NoteProperty).count | Should -BeExactly 6
            }
    
            Assert-MockCalled -CommandName Invoke-RestMethod -Times 1 -Exactly 
        }
    
        Context 'Failed connection' {
            $UserName = "Domain\User"
            $Password = 'SecretPassword' | ConvertTo-SecureString -AsPlainText -Force
            $CredentialObject = New-Object System.Management.Automation.PSCredential -ArgumentList $UserName, $Password 
    
            $splat = @{
                'SalesForceBaseURI' = 'https://www.random.uri' 
                'SalesForceUser' = $CredentialObject
                'SalesForceClientSecret' = 'abcd1234' 
                'SalesForceClientID' = '1' 
                'SalesForceToken' = 'token'
            }
    
            it 'Should throw if scheme is not https' {
                # Change the uri to HTTP before test
                $splat.SalesForceBaseURI = 'http://www.random.uri' 
                {Connect-APSalesForce @splat} | Should -Throw
                # Change it back
                $splat.SalesForceBaseURI = 'https://www.random.uri' 
            }
    
            it 'Should throw if URI is not reachable' {
                Mock -CommandName Invoke-RestMethod -MockWith { Throw }
                {Connect-APSalesForce @splat} | Should -Throw
                Assert-MockCalled -CommandName Invoke-RestMethod -Times 1 -Exactly -Scope it
            }
        }
    }
}