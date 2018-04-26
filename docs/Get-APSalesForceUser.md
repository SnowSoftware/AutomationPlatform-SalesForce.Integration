---
external help file: Snow.SnowAutomationPlatform.SalesForce.Integration-help.xml
Module Name: Snow.SnowAutomationPlatform.SalesForce.Integration
online version: https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/intro_understanding_username_password_oauth_flow.htm
schema: 2.0.0
---

# Get-APSalesForceUser

## SYNOPSIS
This command searches for a user in SalesForce.

## SYNTAX

```
Get-APSalesForceUser [-SearchString] <String> [[-AccessToken] <PSObject>] [[-Properties] <String[]>]
 [[-EndpointVersion] <String>] [<CommonParameters>]
```

## DESCRIPTION
This command will create a hashtable that can be used to search for a user in SalesForce.

If an AccessToken is passed it will automatically try to invoke the search query,

and return any object found.

If no AccessToken is found, it will return th ehashtable containing the search endpoint and the method to use.

## EXAMPLES

### EXAMPLE 1
```
PS> Get-APSalesForceUser -SearchString 'username' 

Name                           Value
----                           -----
Method                         Get 
Endpoint                       /services/data/v41.0/search/?q=FIND+{username}+IN+name+FIELDS+RETURNING+USER(Id,Phon...
```

This command will return a hashtable containing searchquery and method.

### EXAMPLE 2
```
PS> Get-APSalesForceUser -SearchString 'username'  -EndpointVersion 'v42.0' -Properties Id,CompanyName,Division | ft -AutoSize

Name     Value
----     -----
Method   Get
Endpoint /services/data/v42.0/search/?q=FIND+{username}+IN+name+FIELDS+RETURNING+USER(Id,CompanyName,Division)
```

This command will return a searchquery using a differend endpoint version, and custom properties to return

### EXAMPLE 3
```
Get-APSalesForceUser -SearchString 'username'  -AccessToken $Token
```

This command will perform a search and return any results.

If search fails it will return the hashtable used to invoke the search.

## PARAMETERS

### -SearchString
Searchstring in SalesForce API. 

Minimum three characters. Accepts wildcard (* or ?) with a minimum of two characters.

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

### -AccessToken
AccessToken received from Connect-APSalesForce CmdLet

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Properties
Properties to include in result

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: @('Id','Phone','FirstName','LastName')
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
Position: 4
Default value: V41.0
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
