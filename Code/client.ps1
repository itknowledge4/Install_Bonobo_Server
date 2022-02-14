#Install git
Start-Process -FilePath 'C:\Git-2.31.1-64-bit.exe' -ArgumentList '/VERYSILENT /LOADINF="C:\git.inf"' -Wait

#Create a repos folder
New-Item -Path C:\Repos -ItemType Directory

#Modify folder permissions
$a=Get-Acl C:\Repos
$ar=New-Object System.Security.AccessControl.FileSystemAccessRule('testcorp\user100','Modify',"ContainerInherit,ObjectInherit", "None", "Allow")
$a.AddAccessRule($ar)
$ar=New-Object System.Security.AccessControl.FileSystemAccessRule('testcorp\user101','Modify',"ContainerInherit,ObjectInherit", "None", "Allow")
$a.AddAccessRule($ar)
Set-Acl -Path 'C:\Repos' -AclObject $a

###Test
#Open 2 powershell windows each with user100 and user101
cd c:\Repos
git clone http://git01/test1.git
#Edit user info
git config --global --edit

cd c:\Repos
git clone http://git01/test2.git
#Edit user info
git config --global --edit


