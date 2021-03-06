---
external help file: Snow.SnowAutomationPlatform.SalesForce.Integration-help.xml
Module Name: Snow.SnowAutomationPlatform.SalesForce.Integration
online version: https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/intro_understanding_username_password_oauth_flow.htm
schema: 2.0.0
---

# New-APSalesForceUserObject

## SYNOPSIS
Create a SalesForce user object to use when creating new user 

## SYNTAX

```
New-APSalesForceUserObject [-Username] <String> [-Firstname] <String> [-Lastname] <String> [-Email] <String>
 [-Alias] <String> [-CommunityNickname] <String> [-ProfileId] <String> [-TimeZoneSidKey] <String>
 [-LocaleSidKey] <String> [-EmailEncodingKey] <String> [-LanguageLocaleKey] <String>
 [[-AccessToken] <PSObject>] [[-EndpointVersion] <String>] [<CommonParameters>]
```

## DESCRIPTION
This CmdLet will create a User hashtable containing user settings, endpoint data and method, 

To be used together with Invoke-APSalesForceRestMethod to create a new user in SalesForce. 


If a SalesForce access token is sent to this CmdLet it will try to add the user using Invoke-APSalesForceRestMethod, 

and if it fails to add it, it will return the hashtable to be used. 

If no SalesForce access token is sent to this CmdLet it will retrun the hashtable directly. 

## EXAMPLES

### EXAMPLE 1
```
$splat = @{
    'Username' = 'Username@nomail.com'
    'Firstname' = 'first'
    'Lastname' = 'last'
    'Email' = 'first.last@snowsoftware.com'
    'Alias' = 'alias'
    'CommunityNickname' = 'nick' 
    'ProfileId' = '000000000000000'
    'TimeZoneSidKey' = 'America/Phoenix'
    'LocaleSidKey' = 'ar_KW'
    'EmailEncodingKey' = 'GB2312'
    'LanguageLocaleKey' = 'fi'
}
New-APSalesForceUserObject @splat
```

This will return a hashtable containing user settings as stated, default (v41) endpoint, 

and method (Post) 

### EXAMPLE 2
```
$ConnectionSplat = @{
    'SalesForceBaseURI', 'https://my.salesforce.com'
    'SalesForceUser', $SalesForceAdminUserCredentials
    'SalesForceClientSecret', $SalesForceSecret 
    'SalesForceClientID', $SalesForceUserKey 
    'SalesForceToken', $SalesForceToken 
    'SalesForceGrantType', $SalesForceGrantType
}
$UserSplat = @{
    'Username' = 'Username@nomail.com'
    'Firstname' = 'first'
    'Lastname' = 'last'
    'Email' = 'first.last@snowsoftware.com'
    'Alias' = 'alias'
    'CommunityNickname' = 'nick' 
    'ProfileId' = '000000000000000'
    'TimeZoneSidKey' = 'America/Phoenix'
    'LocaleSidKey' = 'ar_KW'
    'EmailEncodingKey' = 'GB2312'
    'LanguageLocaleKey' = 'fi'
}

$SFToken = Connect-APSalesForce @ConnectionSplat
$UserObj = New-APSalesForceUserObject @Userplat
Invoke-APSalesForceRestMethod @UserObj -AccessToken $SFToken
```

Theese commands will create and add the user to the SalesForcePlattform 

### EXAMPLE 3
```
$ConnectionSplat = @{
    'SalesForceBaseURI', 'https://my.salesforce.com'
    'SalesForceUser', $SalesForceAdminUserCredentials
    'SalesForceClientSecret', $SalesForceSecret 
    'SalesForceClientID', $SalesForceUserKey 
    'SalesForceToken', $SalesForceToken 
    'SalesForceGrantType', $SalesForceGrantType
}
$SFToken = Connect-APSalesForce @ConnectionSplat

$UserSplat = @{
    'Username' = 'Username@nomail.com'
    'Firstname' = 'first'
    'Lastname' = 'last'
    'Email' = 'first.last@snowsoftware.com'
    'Alias' = 'alias'
    'CommunityNickname' = 'nick' 
    'ProfileId' = '000000000000000'
    'TimeZoneSidKey' = 'America/Phoenix'
    'LocaleSidKey' = 'ar_KW'
    'EmailEncodingKey' = 'GB2312'
    'LanguageLocaleKey' = 'fi'
    'AccessToken' = $SFToken
}
New-APSalesForceUserObject @Userplat
```

This command will create and try to add the user to the SalesForcePlattform 

## PARAMETERS

### -Username
SalesForce Username in email format. 


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Firstname
First name of user. 


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Lastname
Last name of user. 


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Email
User email address. 


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Alias
User Alias, max 8 characters. 


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CommunityNickname
Community nickname, displayed in SalesForce online communities. 


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProfileId
User profile ID, 15 characters. 


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TimeZoneSidKey
Users timezone. 


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LocaleSidKey
Users locale setting. 


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmailEncodingKey
Default encoding for email. 


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LanguageLocaleKey
Language locale setting for user. 


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 11
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AccessToken
AccessToken received from Connect-APSalesForce CmdLet 


```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndpointVersion
Override the default SalesForce API Version (v41.0) 


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: V41.0
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Collections.Hashtable

## NOTES

## RELATED LINKS
