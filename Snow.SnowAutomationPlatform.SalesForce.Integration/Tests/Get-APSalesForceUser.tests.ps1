$moduleRoot = Resolve-Path "$PSScriptRoot\.."
$ScriptPath = "$moduleRoot\Public\Get-APSalesForceUser.ps1"
. $ScriptPath

Describe 'Get-APSalesForceUser.ps1' {
    Context 'Searching for users' {
        $TestSlpat = @{
            'SearchString' = 'UserName' 
            'Properties' =  'Alias'
            'EndpointVersion' = 1
        }
        
        $a = Get-APSalesForceUser @TestSlpat
        
        it 'Should return a hashtable with user search settings' {
            $a.Method | Should -Be 'Get'
            $a.Endpoint | Should -Be '/services/data/1/search/?q=FIND+{UserName}+IN+name+FIELDS+RETURNING+USER(Alias)'
        }

        it 'Should try to invoke the search if a token is passed' {
            Mock -CommandName Invoke-APSalesForceRestMethod -MockWith {return $true}
            $TestSlpat.Add('AccessToken', (New-Object -TypeName psobject))
            
            Get-APSalesForceUser @TestSlpat | Should -Be $true
        }

        Assert-MockCalled -CommandName Invoke-APSalesForceRestMethod -Times 1 -Exactly
    }
}