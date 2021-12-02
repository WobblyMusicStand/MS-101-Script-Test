Param(
    [Parameter(Mandatory=$True)]
    [string]$TenantName,
    [Parameter(Mandatory=$True)]
    [string]$TenantID,
    [Parameter(Mandatory=$True)]
    [string]$Password
)

Connect-AzureAD
Get-AzureADDirectorySettingTemplate
$TemplateId = (Get-AzureADDirectorySettingTemplate | where { $_.DisplayName -eq "Group.Unified" }).Id
$Template = Get-AzureADDirectorySettingTemplate | where -Property Id -Value $TemplateId -EQ
$Setting = $Template.CreateDirectorySetting()
$setting["EnableMIPLabels"] = "True"

New-AzureADDirectorySetting -DirectorySetting $Setting
Connect-SPOService -Url "https://$TenantID" + "-admin.sharepoint.com" -Credential "Office365Admin@$TenantName"

$Password 


Set-SPOTenant -EnableAIPIntegration $true 
Install-Module ExchangeOnlineManagement.
Connect-IPPSSession -UserPrincipalName "Office365Admin@$TenantName"
Execute-AzureAdLabelSyn