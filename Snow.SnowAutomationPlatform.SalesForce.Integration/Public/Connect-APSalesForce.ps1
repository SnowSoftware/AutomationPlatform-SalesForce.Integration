<#
.Synopsis
   Connect and receive a Access Token to SalesForce.
.DESCRIPTION
   This script will login to SalesForce, and return a Access token you can use to send API requests to SalesForce API.
   In order to use it, you must include 'Authorization: Bearer access_token' as a header in your request.
   For simplicity, you can pass the returned object to Invoke-APSalesForceRestMethod as a variable,
   and it will automatically be parsed to the correct settings.
.EXAMPLE
   Connect-APSalesForce -SalesForceBaseURI 'https://my.salesforceuri.com' -SalesForceUser $CredentialObject -SalesForceClientSecret 'SuperSecret' -SalesForceClientID 'abc123' -SalesForceToken 'reallylongtokenname'
    This command will return a PSCustomObject containing 
    access_token : your access token
    instance_url : base URI to your salesforce connection
    id           : your userID
    token_type   : type of token aquired
    issued_at    : Signature created in no of seconds since Unix Epoch
    signature    : Base64 encoded token validation
.LINK
   https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/intro_understanding_username_password_oauth_flow.htm
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
