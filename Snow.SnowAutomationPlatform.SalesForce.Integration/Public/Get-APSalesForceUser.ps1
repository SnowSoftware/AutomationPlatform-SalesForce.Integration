<#
.EXTERNALHELP Snow.SnowAutomationPlatform.SalesForce.Integration-help.xml
#>
function Get-APSalesForceUser
{
    [CmdletBinding()]
    [OutputType([hashtable])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true)]
        [String]$SearchString,

        # AccessToken received from Connect-APSalesForce CmdLet
        [Parameter(Mandatory=$false)]
        [psobject]$AccessToken,

        # Properties to include in result
        [Parameter(Mandatory=$false)]
        [ValidateSet(
            'Id','Username','LastName','FirstName','Name','CompanyName','Division','Department','Title','Street','City','State','PostalCode','Country','Address','Email','Phone','MobilePhone','Alias','CommunityNickname','IsActive','ProfileId','UserType','EmployeeNumber','LastLoginDate','LastPasswordChangeDate','CreatedDate'
        )]
        [string[]]$Properties = @('Id','Phone','FirstName','LastName'),
        
        # Override the default SalesForce API Version (v41.0)
        [Parameter(Mandatory=$false)]
        [string]$EndpointVersion = 'v41.0'


    )

    Begin
    {
        $JointProperties = $Properties -join ','
        $ReturnObj = @{
            'Endpoint' = "/services/data/$EndpointVersion/search/?q=FIND+{$SearchString}+IN+name+FIELDS+RETURNING+USER($JointProperties)"
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
