$moduleRoot = Resolve-Path "$PSScriptRoot\.."
$ScriptPath = "$moduleRoot\Public\Invoke-APSalesForceRestMethod.ps1"
. $ScriptPath

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

        [byte[]]$result = '123','13','10','32','32','32','32','34','66','111','100','121','34','58','32','32','34','66','111','100','121','34','13','10','125'

        it 'Works with body as Json object' {
            $TestSplat.Body = (New-Object -TypeName psobject -Property @{'Body' = 'Body'} | ConvertTo-Json)
            $a = Invoke-APSalesForceRestMethod @TestSplat
            $a.body | Should -BeExactly $result
            $a.body.GetType().FullName | should -Be 'System.Byte[]'
        }

        it 'Works with body as object' {
            $TestSplat.Body = New-Object -TypeName psobject -Property @{'Body' = 'Body'}
            $a = Invoke-APSalesForceRestMethod @TestSplat
            $a.body | Should -BeExactly $result
            $a.body.GetType().FullName | should -Be 'System.Byte[]'
        }

        it 'Works with body as Byte Array' {
            $TestSplat.Body = $result
            $a = Invoke-APSalesForceRestMethod @TestSplat
            $a.body | Should -BeExactly $result
            $a.body.GetType().FullName | should -Be 'System.Byte[]'
        }

        Assert-MockCalled -CommandName Invoke-RestMethod -Times 3 -Exactly
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

        it 'Headers should be correct' {
            $a.Headers.Authorization | Should -Be 'Bearer Access'
            $a.Headers.Accept | Should -be 'application/json'
        }
        
        it 'Has the correct URI' {
            $a.URI | Should -Be 'http://Instance/Endpoint'
        }

        Assert-MockCalled -CommandName Invoke-RestMethod -Times 1 -Exactly
    }
}