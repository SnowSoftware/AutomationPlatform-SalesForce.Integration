---
external help file: Snow.SnowAutomationPlatform.SalesForce.Integration-help.xml
Module Name: Snow.SnowAutomationPlatform.SalesForce.Integration
online version:
schema: 2.0.0
---

# Get-APSalesForceProfile

## SYNOPSIS
This command searches for a profile in SalesForce.

## SYNTAX

```
Get-APSalesForceProfile [-SearchString] <String> [[-AccessToken] <PSObject>] [[-Properties] <String[]>]
 [[-EndpointVersion] <String>] [<CommonParameters>]
```

## DESCRIPTION
This command will create a hashtable that can be used to search for one or more profiles in SalesForce.

If an AccessToken is passed it will automatically try to invoke the search query,

and return any object found.

If no AccessToken is found, it will return the hashtable containing the search endpoint and the method to use.

## EXAMPLES

### EXAMPLE 1
```
PS> Get-APSalesForceProfile -SearchString '*m*a*'

Name                           Value
----                           -----
Method                         Get
Endpoint                       /services/data/v41.0/parameterizedSearch/?q=*m*a*&sobject=Profile&Profile.field...
```

This command will return a hashtable containing searchquery and method.

### EXAMPLE 2
```
PS> Get-APSalesForceProfile -SearchString 'a*b?c' -EndpointVersion 'v42.0' -Properties Description,Id,name

Name                           Value
----                           -----
Method                         Get
Endpoint                       /services/data/v42.0/parameterizedSearch/?q=a*b?c&sobject=Profile&Profile.fields=Description,Id,name

```

This command will return a searchquery using a differend endpoint version, and custom properties to return

### EXAMPLE 3
```
Get-APSalesForceProfile -SearchString 'ProfileName' -AccessToken $Token
```

This command will perform a search and return any results.

If search fails it will return the hashtable used to invoke the search.## PARAMETERS

## PARAMETERS

### -AccessToken
AccessToken received from Connect-APSalesForce CmdLet

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
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
Position: 3
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
Accepted values: Id, name, Description

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SearchString
Searchstring in SalesForce API. 

Minimum three characters. Accepts wildcard (* or ?) with a minimum of two characters.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None


## OUTPUTS

### System.Collections.Hashtable


## NOTES

## RELATED LINKS
