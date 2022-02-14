$BonoboArchivePath='C:\6_5_0.zip'
$SitesPath='C:\Sites'

#Create the Sites folder
New-Item -Path $SitesPath -ItemType Directory

#Install roles and features
Install-WindowsFeature Web-Server,Web-Http-Redirect,Web-Basic-Auth,Web-Windows-Auth,Web-Net-Ext45,Web-Asp-Net45,Web-ISAPI-Ext,Web-ISAPI-Filter,Web-Includes,Web-AppInit -IncludeManagementTools

#Remove default web site
Remove-Website -Name 'Default Web Site'

#Create an application pool
New-WebAppPool -Name 'BonoboGitAP'

#Extract the site to C:\Sites; command expects that the zip is in the correct directory
Expand-Archive C:\6_5_0.zip -DestinationPath C:\Sites

#Create Web Site
New-Website -Name 'BonoboGit' -ApplicationPool 'BonoboGitAP' -PhysicalPath 'C:\Sites\Bonobo.Git.Server' -Port 80 -IPAddress *

#Modify folder permissions
$a=Get-Acl C:\Sites\Bonobo.Git.Server
$a.SetAccessRuleProtection($true,$true)
$aces=$a.Access | where-object {$_.identityreference -eq 'BUILTIN\Users'}
foreach($ace in $aces)
{
	$a.RemoveAccessRuleSpecific($ace)
}
$ar=New-Object System.Security.AccessControl.FileSystemAccessRule('IIS AppPool\BonoboGitAP','Modify',"ContainerInherit,ObjectInherit", "None", "Allow")
$a.AddAccessRule($ar)
Set-Acl -Path 'C:\Sites\Bonobo.Git.Server\' -AclObject $a

#Copy config file
Copy-Item 'C:\Web.config' 'C:\Sites\Bonobo.Git.Server\Web.config' -Force

#Restart the site
Stop-Website BonoboGit
Start-Website BonoboGit