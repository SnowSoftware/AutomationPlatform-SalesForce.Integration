$moduleRoot = Resolve-Path "$PSScriptRoot\..\Snow.SnowAutomationPlatform.SalesForce.Integration"
$ScriptPath = "$moduleRoot\Public\Get-APSalesForceProfile.ps1"
. $ScriptPath

Describe 'Get-APSalesForceProfile.ps1' {
    Context 'Searching for Profiles' {
        $TestSlpat = @{
            'SearchString' = 'ProfileName' 
            'Properties' =  'Id','Name','Description'
            'EndpointVersion' = 1
        }
        
        # To mock a command we need that command available, so we dot source this specific command as well.
        . "$moduleRoot\Public\Invoke-APSalesForceRestMethod.ps1"
        
        it 'Should return a hashtable with user search settings' {
            $a = Get-APSalesForceProfile @TestSlpat
        
            $a.Method | Should -Be 'Get'
            $a.Endpoint | Should -Be '/services/data/1/parameterizedSearch/?q=ProfileName&sobject=Profile&Profile.fields=Id,Name,Description'
        }

        # Add AccessToken to perform invoke
        $TestSlpat.Add('AccessToken', (New-Object -TypeName psobject))

        it 'Should try to invoke the search if a token is passed' {
            Mock -CommandName Invoke-APSalesForceRestMethod -MockWith {return $true}
            
            $Actual = Get-APSalesForceProfile @TestSlpat 
            
            $Actual | Should -Be $true
        }

        it 'Should return hashtable if a token is passed but the query failed' {
            Mock -CommandName Invoke-APSalesForceRestMethod -MockWith {throw}
            
            $Actual = Get-APSalesForceProfile @TestSlpat -ErrorAction SilentlyContinue

            $Actual.Method | Should -Be 'Get'
            $Actual.Endpoint | Should -Be '/services/data/1/parameterizedSearch/?q=ProfileName&sobject=Profile&Profile.fields=Id,Name,Description'
        }

        Assert-MockCalled -CommandName Invoke-APSalesForceRestMethod -Times 2 -Exactly
    }
}