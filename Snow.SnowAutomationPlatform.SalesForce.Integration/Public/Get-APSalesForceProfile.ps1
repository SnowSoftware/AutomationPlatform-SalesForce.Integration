<#
.EXTERNALHELP Snow.SnowAutomationPlatform.SalesForce.Integration-help.xml
#>
function Get-APSalesForceProfile
{
    [CmdletBinding()]
    [OutputType([hashtable])]
    Param
    (
        # Search string, minimum three characters. Accepts wildcard (* or ?) with a minimum of two characters.
        [Parameter(Mandatory=$true)]
        [ValidateScript({
            ($_.length -gt 2) -and
            (($_ -replace '\*','' -replace '\?','').length -gt 1)
        })]
        [String]$SearchString,

        # AccessToken received from Connect-APSalesForce CmdLet
        [Parameter(Mandatory=$false)]
        [psobject]$AccessToken,

        # Properties to include in result
        [Parameter(Mandatory=$false)]
        [ValidateSet(
            'Id','name','Description'
        )]
        [string[]]$Properties = @('Id','name'),
        
        # Override the default SalesForce API Version (v41.0)
        [Parameter(Mandatory=$false)]
        [string]$EndpointVersion = 'v41.0'
    )

    Begin
    {
        $JointProperties = $Properties -join ','
        $ReturnObj = @{
            'Endpoint' = "/services/data/$EndpointVersion/parameterizedSearch/?q=$SearchString&sobject=Profile&Profile.fields=$JointProperties"
            'Method' = 'Get'
        }
    }
    Process
    {
    }
    End
    {
        # If an accesstoken is sent, try to invoke the call and get the user right away.
        # Otherwise, return the search object.
        if ($AccessToken) {
            try {
                Invoke-APSalesForceRestMethod @ReturnObj -AccessToken $AccessToken
            }
            catch {
                Write-Error 'Failed to invoke searchquery'
                $ReturnObj
            }
        }
        else { 
            $ReturnObj
        }
    }
}
