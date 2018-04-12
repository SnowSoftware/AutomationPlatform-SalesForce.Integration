<#
  This is one example of how to use the Snow.SnowAutomationPlatform.SalesForce.Integration module
  to automatically create a new user.
  Some of the Parameters needed are for getting the authorization token,
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

    $Username,
    $Firstname,
    $Lastname,
    $Email,
    $Alias,
    $ComunityNickname,
    $ProfileId,
    $TimeZoneSidKey,
    $LocaleSidKey,
    $EmailEncodingKey,
    $LanguageLocaleKey
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


#region Create User
# Theese are only some of the field you can set when creating a new user.
# For a detailed user object, you can use the Rest explorer at salesforce:
# https://workbench.developerforce.com/restExplorer.php
# and browse the user endpoint
# services/data/v40.0/sobjects/User/<UserID>
# If you would like to add more settings you could create this splat,
# and use the command 
# $Body.add('Property','value')
# to add more properties.
# Remember that if you need more settings, you must also update the corresponding value in the SalesForce integration Module.
$UserSplat = @{
       'Username'          = $Username
       'Firstname'         = $Firstname
       'Lastname'          = $Lastname
       'Email'             = $Email
       'Alias'             = $Alias
       'ComunityNickname'  = $ComunityNickname
       'ProfileId'         = $ProfileId
       'TimeZoneSidKey'    = $TimeZoneSidKey
       'LocaleSidKey'      = $LocaleSidKey
       'EmailEncodingKey'  = $EmailEncodingKey
       'LanguageLocaleKey' = $LanguageLocaleKey
}

# If we pass our SalesForce token inside the Hasthtable to splat,
# The New-APSalesForceUserObject will automatically try to invoke the API request to create the user.
$UserSplat.Add('AccessToken',$SFToken)

# Using the $UserSplat we created will now create the new SalesForce user,
# And if it fails it will instead return the hashtable sent to Invoke-APSalesForceRestMethod.
# The New-APSalesForceUserObject CmdLet already includes API endpoint and method to use in the request.
New-APSalesForceUserObject @UserSplat
#endregion