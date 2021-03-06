---
external help file: Snow.SnowAutomationPlatform.SalesForce.Integration-help.xml
Module Name: Snow.SnowAutomationPlatform.SalesForce.Integration
online version: https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/intro_understanding_username_password_oauth_flow.htm
schema: 2.0.0
---

# Connect-APSalesForce

## SYNOPSIS
Connect and receive a Access Token to SalesForce. 

## SYNTAX

```
Connect-APSalesForce [-SalesForceBaseURI] <Uri> [-SalesForceUser] <PSCredential>
 [-SalesForceClientSecret] <String> [-SalesForceClientID] <String> [-SalesForceToken] <String>
 [[-SalesForceGrantType] <String>] [<CommonParameters>]
```

## DESCRIPTION
This script will login to SalesForce, and return a Access token you can use to send API requests to SalesForce API. 

In order to use it, you must include 'Authorization: Bearer access_token' as a header in your request. 

For simplicity, you can pass the returned object to Invoke-APSalesForceRestMethod as a variable, 

and it will automatically be parsed to the correct settings. 

## EXAMPLES

### EXAMPLE 1
```
Connect-APSalesForce -SalesForceBaseURI 'https://my.salesforceuri.com' -SalesForceUser $CredentialObject -SalesForceClientSecret 'SuperSecret' -SalesForceClientID 'abc123' -SalesForceToken 'reallylongtokenname'
```

This command will return a PSCustomObject containing  

  access_token : your access token  
  instance_url : base URI to your salesforce connection  
  id           : your userID  
  token_type   : type of token aquired  
  issued_at    : Signature created in no of seconds since Unix Epoch  
  signature    : Base64 encoded token validation  

## PARAMETERS

### -SalesForceBaseURI
Base URI to SalesForce domain, for example http://my.salesforce.com 


```yaml
Type: Uri
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SalesForceUser
Credential object to use when logging in to SalesForce 


```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SalesForceClientSecret
SalesForce Client_secret, also refered to as Consumer Secret 


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

### -SalesForceClientID
SalesForce Client_Id, also refered to as Consumer Key or User Key 


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

### -SalesForceToken
User token for SalesForce User 


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

### -SalesForceGrantType
OAuth GrantType, must be Password for username / password authentication. 


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: Password
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS

[https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/intro_understanding_username_password_oauth_flow.htm](https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/intro_understanding_username_password_oauth_flow.htm)
