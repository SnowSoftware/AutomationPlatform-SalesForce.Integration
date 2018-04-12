<#
  This is one example of how to use the Snow.SnowAutomationPlatform.SalesForce.Integration module
  to automatically disable a user.
  The Parameters needed are mainly for getting the authorization token,
  and should be set as settings or service accounts in Snow Automation Platform.
#>
Param
(
    [uri]$SalesForceBaseURI,
    [pscredential]$SalesForceUser,
    [string]$Secret,
    [String]$UserKey, 
    [String]$token,
    [String]$GrantType,

    $SearchUser
)

#region Get SalesForce authorization token
# For usage examples and explanations of the Connect-APSalesForce CmdLet, use the command
# Get-Help Connect-APSalesForce -Full
# In an interactive powershell session
$TokenSplat = @{
    'SalesForceBaseURI'      = $SalesForceBaseURI
    'SalesForceUser'         = $SalesForceUser 
    'SalesForceClientSecret' = $Secret 
    'SalesForceClientID'     = $UserKey 
    'SalesForceToken'        = $token 
    'SalesForceGrantType'    = $GrantType
}

$sftoken = Connect-APSalesForce @TokenSplat
#endregion

#region Search for user
$SearchUserSplat = @{
    'SearchString' = $SearchUser
    'AccessToken'  = $sftoken
}

$user = Get-APSalesForceUser @SearchUserSplat
# The Search api always returns an array, even if there is only one result.
# So we must always check that we only get one result back from the query
if ($user.searchRecords.Count -ne 1){
    Throw "No user, or more than one user found. please be more specific"
}
#endregion

#region Set user as disabled

# When updating a user object, you only have to send the property you want to change.
# In order to make a user inactive, create a json with IsActive = $false
# For a detailed user object, you can use the Rest explorer at salesforce:
# https://workbench.developerforce.com/restExplorer.php
# and browse the user endpoint
# services/data/v40.0/sobjects/User/<UserID>
$json = New-Object -TypeName psobject -Property @{
    'IsActive'=$false
} | ConvertTo-Json 

# We have to send the object change to the users specific endpoint.
# This endpoint is always included in the search response.
$Endpoint = $user.searchRecords[0].attributes.url

$InvokeSplat = @{
    'Endpoint'    = $Endpoint 
    'AccessToken' = $sftoken 
    'Method'      = 'Patch'
    'Body'        = $json
}

# Invoke-APSalesForceRestMethod is a function to automatically wrap the token, endpoint, and other data
# to be able to call Invoke-RestMethod the way SalesForce API requires.
# Using the $json body we created we can set the user as disabled.
Invoke-APSalesForceRestMethod @InvokeSplat

#endregion