<#
.Synopsis
   Calls the SalesForce API with added parsing of access token
.DESCRIPTION
   This finction makes a call to the SalesForce API using Invoke-WebRequest.
   It automatically parses the passed on Access Token to use correct URI,
   and Token headers. 
   It also tries to make sure you always send and receive objects as Json.
.EXAMPLE
   Invoke-APSalesForceRestMethod -Endpoint '/services/data/v40.0/sobjects/user/' -AccessToken $SalesForceToken -Method Get
    This command will call the User endpoint using the URI and access tokens from $SalesForceToken.
    If any result is given it will be sent back to the pipeline.
.EXAMPLE
   Invoke-APSalesForceRestMethod -Endpoint '/services/data/v40.0/sobjects/user/' -AccessToken $SalesForceToken -Method Post -Body $PSCustomObject
    This command will post the pscustomobject to the user endpoint using the URI and access tokens from $SalesForceToken.
    It will automatically convert the PSCustomObject to json format before sending it.
.EXAMPLE
   Invoke-APSalesForceRestMethod -Endpoint '/services/data/v40.0/sobjects/user/' -AccessToken $SalesForceToken -Method Post -Body $PSCustomObject -BaseURI 'https://my.other.salesforce.com'
    This command will post the pscustomobject to the user endpoint using access tokens from $SalesForceToken.
    It will use the base SalesForce URI 'https://my.other.salesforce.com'.
    It will automatically convert the PSCustomObject to json format before sending it.
.EXAMPLE
   Invoke-APSalesForceRestMethod -Endpoint '/services/data/v40.0/sobjects/user/' -AccessToken $SalesForceToken -Method Post -Body {"JsonKey":"Value","OtherJsonKey":{"JsonArray":10}}
    This command will post the already json formated body to the user endpoint using the URI and access tokens from $SalesForceToken.
#>
function Invoke-APSalesForceRestMethod
{
    [CmdletBinding()]
    Param
    (
        # Path to endpoint in SalesForce API, for example '/services/data/v40.0/sobjects/user/'
        [Parameter(Mandatory=$true)]
        [string]$Endpoint,

        # AccessToken received from Connect-APSalesForce CmdLet
        [Parameter(Mandatory=$true)]
        [psobject]$AccessToken,

        # Request method
        [Parameter(Mandatory=$true)]
        [ValidateSet('Get','Put','Post','Patch')]
        [string]$Method,
        
        # Base URI to your SalesForce domain. Only needed if it is different from AccessToken instance_url
        [Parameter(Mandatory=$false)]
        [uri]$BaseURI,

        # Body to send if method is put or post
        [Parameter(Mandatory=$false)]
        $Body
    )

    Begin
    {
        # If no BaseURI is set, we use the one included in the token
        If (-not $BaseURI) {
            [uri]$BaseURI = $AccessToken.instance_url
        }

        # Construct request Uri
        [string]$InvokeUri = "$($BaseUri.AbsoluteUri)$($Endpoint.TrimStart('/'))"

        if ($body) { 
            # If body is not already sent as byte stream, check if it is json, and convert if not
            if (-not ($body -is [byte[]])) { 
                try {
                    # Is body already a json?
                    $null = ConvertFrom-Json -InputObject $body
                }
                catch {
                    # body is not a json so we need to convert it.
                    $Body = $Body | ConvertTo-Json
                }

                # In the end, always convert to bytestream
                $Body = [System.Text.Encoding]::UTF8.GetBytes($body)
            }

        }

        # Construct request headers object
        $Headers = @{
            'Authorization' = "Bearer $($AccessToken.access_token)"
            'Accept'        = 'application/json'
        }

        # Splat to use with Invoke-WebRequest
        $splat = @{
            'URI'     = $InvokeUri
            'Headers' = $Headers
            'Method'  = $Method
        }

        # If we are sending data, add contenttype and body to send
        If ($Method -in 'Put','Post','Patch') {
            $splat.Add('ContentType','application/json')
            $splat.Add('Body',$Body)
        }

    }
    Process
    {
        
    }
    End
    {
        try {
            # Powershell defaults to using TLS1.0 as security protocol, and SalesForce API requires 1.2
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

            Write-Verbose "invoking SalesForce API call."
            Invoke-RestMethod @splat
        }
        catch {
            Throw "Failed to invoke SalesForce API call: $_"
        }
    }
}
