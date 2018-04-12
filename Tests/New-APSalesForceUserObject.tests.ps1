$moduleRoot = Resolve-Path "$PSScriptRoot\..\Snow.SnowAutomationPlatform.SalesForce.Integration"
$ScriptPath = "$moduleRoot\Public\New-APSalesForceUserObject.ps1"
. $ScriptPath

Describe 'New-APSalesForceUserObject' {
    Context 'Creating user objects' {
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
        
        it 'Should return a hashtable with valid objects' {
            $a = New-APSalesForceUserObject @TestSplat
            
            $a.Body.Username | Should -be 'Username@username.com'
            $a.Body.Firstname | Should -be 'Firstname'
            $a.Body.Lastname | Should -be 'Lastname'
            $a.Body.Email | Should -be 'Email'
            $a.Body.Alias | Should -be 'Alias'
            $a.Body.CommunityNickname | Should -be 'CommunityNickname'
            $a.Body.ProfileId | Should -be 'ProfileId012345'
            $a.Body.TimeZoneSidKey | Should -be 'Africa/Algiers'
            $a.Body.LocaleSidKey | Should -be 'ar_AE'
            $a.Body.EmailEncodingKey | Should -be 'UTF-8'
            $a.Body.LanguageLocaleKey | Should -be 'en_US'
            $a.Endpoint | Should -be '/services/data/v41.0/sobjects/user/'
            $a.Method | Should -be 'Post'
        }

        it 'Should try to invoke the command if a usertoken is passed' {
            # To mock a command we need that command available, so we dot source this specific command as well.
            . "$moduleRoot\Public\Invoke-APSalesForceRestMethod.ps1"
            Mock -CommandName Invoke-APSalesForceRestMethod -MockWith {Return $True}
            $TestSplat.Add('AccessToken',(New-Object -TypeName psobject -Property @{}))

            New-APSalesForceUserObject @TestSplat | Should -Be $true
        }

        Assert-MockCalled -CommandName Invoke-APSalesForceRestMethod -Times 1 -Exactly
    }
}