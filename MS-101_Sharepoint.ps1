Param(
    [Parameter(Mandatory=$True)]
    [string]$TenantName,
    [Parameter(Mandatory=$True)]
    [string]$TenantID,
    [Parameter(Mandatory=$True)]
    [string]$Password
)

Connect-AzureAD

#Create and deploy a setting template and set the EnableMIPLabels property to true.
#Get-AzureADDirectorySettingTemplate
$TemplateId = (Get-AzureADDirectorySettingTemplate | where { $_.DisplayName -eq "Group.Unified" }).Id
$Template = Get-AzureADDirectorySettingTemplate | where -Property Id -Value $TemplateId -EQ
$Setting = $Template.CreateDirectorySetting()
$Setting["EnableMIPLabels"] = "True"

#if a setting already exists (from a previous lab) then ensure that is has "EnableMIPLabels" set to True.
try {
    New-AzureADDirectorySetting -DirectorySetting $Setting
} catch {
    $setting = Get-AzureADDirectorySetting
    $setting["EnableMIPLabels"] = "True"
    Set-AzureADDirectorySetting -Id $setting.id -DirectorySetting $setting
}

Connect-SPOService -Url "https://$TenantID" + "-admin.sharepoint.com" -Credential "Office365Admin@$TenantName"

Set-SPOTenant -EnableAIPIntegration $true 
Connect-IPPSSession -UserPrincipalName "Office365Admin@$TenantName"
Execute-AzureAdLabelSyn
