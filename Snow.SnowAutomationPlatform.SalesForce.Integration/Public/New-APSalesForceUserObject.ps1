<#
.Synopsis
   Create a SalesForce user object to use when creating new user
.DESCRIPTION
   This CmdLet will create a User hashtable containing user settings, endpoint data and method,
   To be used together with Invoke-APSalesForceRestMethod to create a new user in SalesForce.

   If a SalesForce access token is sent to this CmdLet it will try to add the user using Invoke-APSalesForceRestMethod,
   and if it fails to add it, it will return the hashtable to be used.
   If no SalesForce access token is sent to this CmdLet it will retrun the hashtable directly.
.EXAMPLE
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
   This will return a hashtable containing user settings as stated, default (v41) endpoint,
   and method (Post)
.EXAMPLE
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
   
   Theese commands will create and add the user to the SalesForcePlattform
.EXAMPLE
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
   
   This command will create and try to add the user to the SalesForcePlattform
#>
function New-APSalesForceUserObject
{
    [CmdletBinding()]
    [OutputType([hashtable])]
    Param
    (
        # SalesForce Username in email format.
        [Parameter(Mandatory=$true)]
        [ValidateScript({
            $_ -like "*@*"
        })]
        [string]$Username,
        
        # First name of user.
        [Parameter(Mandatory=$true)]
        [string]$Firstname,
        
        # Last name of user.
        [Parameter(Mandatory=$true)]
        [string]$Lastname,
        
        # User email address.
        [Parameter(Mandatory=$true)]
        [string]$Email,
        
        # User Alias, max 8 characters.
        [Parameter(Mandatory=$true)]
        [ValidateScript({
            $_.Length -le 8
        })]
        [string]$Alias,
        
        # Community nickname, displayed in SalesForce online communities.
        [Parameter(Mandatory=$true)]
        [string]$CommunityNickname,
        
        # User profile ID, 15 characters.
        [Parameter(Mandatory=$true)]
        [ValidateScript({
            $_.Length -eq 15
        })]
        [string]$ProfileId,
        
        # Users timezone.
        [Parameter(Mandatory=$true)]
        [ValidateSet(
            'Africa/Algiers','Africa/Cairo','Africa/Johannesburg','Africa/Nairobi','America/Anchorage','America/Argentina/Buenos_Aires','America/Bogota','America/Caracas','America/Chicago','America/Denver ****America/Denver','America/El_Salvador','America/Halifax','America/Indiana/Indianapolis','America/Lima','America/Los_Angeles','America/Mexico_City','America/New_York','America/Panama','America/Phoenix','America/Puerto_Rico','America/Santiago','America/Sao_Paulo','America/St_Johns','America/Tijuana','Asia/Baghdad','Asia/Bangkok','Asia/Colombo','Asia/Dhaka','Asia/Dubai','Asia/Ho_Chi_Minh','Asia/Hong_Kong','Asia/Jakarta','Asia/Jerusalem','Asia/Kabul','Asia/Kamchatka','Asia/Karachi','Asia/Kathmandu','Asia/Kolkata','Asia/Kuala_Lumpur','Asia/Kuwait','Asia/Manila','Asia/Rangoon','Asia/Riyadh','Asia/Seoul','Asia/Shanghai','Asia/Singapore','Asia/Taipei','Asia/Tashkent','Asia/Tbilisi','Asia/Tehran','Asia/Tokyo','Asia/Yekaterinburg','Atlantic/Bermuda','Atlantic/Cape_Verde','Atlantic/South_Georgia','Australia/Adelaide','Australia/Darwin','Australia/Lord_Howe','Australia/Perth','Australia/Sydney','Europe/Amsterdam','Europe/Athens','Europe/Berlin','Europe/Brussels','Europe/Bucharest','Europe/Dublin','Europe/Helsinki','Europe/Istanbul','Europe/Lisbon','Europe/London','Europe/Minsk','Europe/Moscow','Europe/Paris','Europe/Prague','Europe/Rome','GMT','Pacific/Auckland','Pacific/Chatham','Pacific/Enderbury','Pacific/Fiji','Pacific/Guadalcanal','Pacific/Honolulu','Pacific/Kiritimati','Pacific/Niue','Pacific/Norfolk','Pacific/Pago_Pago','Pacific/Tongatapu'
        )]
        [string]$TimeZoneSidKey,
        
        # Users locale setting.
        [Parameter(Mandatory=$true)]
        [ValidateSet(
            'ar_AE','ar_BH','ar_DZ','ar_EG','ar_IQ','ar_JO','ar_KW','ar_LB','ar_LY','ar_MA','ar_OM','ar_QA','ar_SA','ar_SD','ar_SY','ar_TN','ar_YE','az_AZ','be_BY','bg_BG','bn_BD','bs_BA','ca_ES','ca_ES_EURO','cs_CZ','cy_GB','da_DK','de_AT','de_AT_EURO','de_CH','de_DE','de_DE_EURO','de_LU','de_LU_EURO','dz_BT','el_GR','en_AG','en_AU','en_BB','en_BM','en_BS','en_BW','en_BZ','en_CA','en_CM','en_ER','en_FJ','en_FK','en_GB','en_GH','en_GI','en_GM','en_GY','en_HK','en_ID','en_IE','en_IE_EURO','en_IN','en_JM','en_KE','en_KY','en_LR','en_MG','en_MU','en_MW','en_MY','en_NA','en_NG','en_NZ','en_PG','en_PH','en_PK','en_RW','en_SB','en_SC','en_SG','en_SH','en_SL','en_SX','en_SZ','en_TO','en_TT','en_TZ','en_UG','en_US','en_WS','en_VU','en_ZA','es_AR','es_BO','es_CL','es_CO','es_CR','es_CU','es_DO','es_EC','es_ES','es_ES_EURO','es_GT','es_HN','es_MX','es_NI','es_PA','es_PE','es_PR','es_PY','es_SV','es_US','es_UY','es_VE','et_EE','eu_ES','fa_IR','fi_FI','fi_FI_EURO','fr_BE','fr_CA','fr_CH','fr_FR','fr_FR_EURO','fr_GN','fr_HT','fr_KM','fr_LU','fr_MC','fr_MR','fr_WF','ga_IE','hi_IN','hr_HR','hu_HU','hy_AM','in_ID','is_IS','it_CH','it_IT','iw_IL','ja_JP','ka_GE','kk_KZ','km_KH','ko_KP','ko_KR','ky_KG','lb_LU','lo_LA','lt_LT','lu_CD','lv_LV','mk_MK','ms_BN','ms_MY','mt_MT','my_MM','ne_NP','nl_AW','nl_BE','nl_NL','nl_SR','no_NO','pl_PL','ps_AF','pt_AO','pt_BR','pt_CV','pt_MZ','pt_PT','pt_ST','rm_CH','rn_BI','ro_MD','ro_RO','ru_RU','sh_BA','sh_CS','sh_ME','sk_SK','sl_SI','so_DJ','so_SO','sq_AL','sr_BA','sr_CS','sr_RS','sv_SE','ta_IN','ta_LK','tg_TJ','th_TH','ti_ET','tl_PH','tr_TR','uk_UA','ur_PK','uz_LATN_UZ','vi_VN','yo_BJ','zh_CN','zh_CN_PINYIN','zh_CN_STROKE','zh_HK','zh_HK_STROKE','zh_MO','zh_SG','zh_TW','zh_TW_STROKE'
        )]
        [string]$LocaleSidKey,
        
        # Default encoding for email.
        [Parameter(Mandatory=$true)]
        [ValidateSet(
            'UTF-8','ISO-8859-1','Shift_JIS','ISO-2022-JP','EUC-JP','ks_c_5601-1987','Big5','GB2312'
        )]
        [string]$EmailEncodingKey,
        
        # Language locale setting for user.
        [Parameter(Mandatory=$true)]
        [ValidateSet(
            'en_US','de','es','fr','it','ja','sv','ko','zh_TW','zh_CN','pt_BR','nl_NL','th','fi','ru'
        )]
        [string]$LanguageLocaleKey,

        # AccessToken received from Connect-APSalesForce CmdLet
        [Parameter(Mandatory=$false)]
        [psobject]$AccessToken,

        # Override the default SalesForce API Version (v41.0)
        [Parameter(Mandatory=$false)]
        [string]$EndpointVersion = 'v41.0'
    )

    Begin
    {
        # It is possible to set a lot more different settings for users.
        # For reference, see https://developer.salesforce.com/docs/atlas.en-us.api.meta/api/sforce_api_objects_user.htm

        $Endpoint = "/services/data/$EndpointVersion/sobjects/user/"
        $method = 'Post'
        $Body = @{
            Username=$Username
            LastName=$Lastname
            FirstName=$Firstname
            Email=$Email
            Alias=$Alias
            CommunityNickname=$CommunityNickname
            TimeZoneSidKey=$TimeZoneSidKey
            LocaleSidKey=$LocaleSidKey
            EmailEncodingKey=$EmailEncodingKey
            ProfileId=$ProfileId
            LanguageLocaleKey=$LanguageLocaleKey
        }
    }

    Process
    {
    }
    End
    {
        $ReturnObj = @{
            'Endpoint' = $Endpoint
            'Method'   = $method
            'Body'     = $Body
        }

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
