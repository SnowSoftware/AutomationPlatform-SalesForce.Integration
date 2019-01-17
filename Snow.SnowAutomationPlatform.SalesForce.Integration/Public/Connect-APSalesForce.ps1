<#
.EXTERNALHELP Snow.SnowAutomationPlatform.SalesForce.Integration-help.xml
#>
function Connect-APSalesForce
{
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param
    (
        # Base URI to SalesForce domain, for example http://my.salesforce.com
        [Parameter(mandatory=$true)]
        [ValidateScript({
            ([uri]$_).Scheme -eq 'https'
        })]
        [uri]$SalesForceBaseURI,

        # Credential object to use when logging in to SalesForce
        [Parameter(mandatory=$true)]
        [pscredential]$SalesForceUser,

        # SalesForce Client_secret, also refered to as Consumer Secret
        [Parameter(mandatory=$true)]
        [string]$SalesForceClientSecret,
        
        # SalesForce Client_Id, also refered to as Consumer Key or User Key
        [Parameter(mandatory=$true)]
        [string]$SalesForceClientID,
        
        # User token for SalesForce User
        [Parameter(mandatory=$true)]
        [string]$SalesForceToken,
        
        # OAuth GrantType, must be Password for username / password authentication.
        [Parameter(mandatory=$False)]
        [string]$SalesForceGrantType = 'password'
    )

    Begin
    {
        $SalesForceUsername = $SalesForceUser.UserName
        $SalesForceServicePassword = $SalesForceUser.GetNetworkCredential().password
        $SalesForceGrantType = $SalesForceGrantType.ToLower() # The grantype is case sensitive

        # The Password flag in SalesForce Authentincation should be Password and Token combined into one string without spaces.
        $PassToken = "$SalesForceServicePassword$SalesForceToken"

        $authBody = @{
            grant_type    = $SalesForceGrantType
            client_id     = $SalesForceClientID
            client_secret = $SalesForceClientSecret
            username      = $SalesForceUsername
            password      = $PassToken
        }

        $TokenUri = "$SalesForceBaseURI/services/oauth2/token"
    }

    Process
    {
        # Powershell defaults to using TLS1.0 as security protocol, and SalesForce API requires 1.2
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    }

    End
    {
        Try {
            Invoke-RestMethod -Uri $TokenUri -Method POST -Body $authBody
        }
        Catch {
            Throw "Failed to get accesstoken: $_"
        }
    }
}
