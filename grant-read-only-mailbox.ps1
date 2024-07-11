#mailbox to grant permissions
$mailboxIdentity = "user@mailbox.com"

#user to grand permission to
$mailboxUser = "user@mailbox.com"

Connect-ExchangeOnline

#get mailbox folder objects
$mailboxIdentityFolders = Get-MailboxFolderStatistics -Identity $mailboxIdentity | select-object Identity;

#empty list for strings
$mailboxIdentityFolderStrings = New-Object System.Collections.Generic.List[System.Object];

#get identity path string and add a :
foreach ($folder in $mailboxIdentityFolders) {
    $folderString = $folder.Identity;
    $folderString = $folderString.Insert($mailboxIdentity.Length,':');
    $mailboxIdentityFolderStrings.Add($folderString);
}

#change first index to email address only (folder is invalid)
$mailboxIdentityFolderStrings[0] = $mailboxIdentity;

#Write-Output $mailboxIdentityFolderStrings;

#add read permission to actual mailbox
Add-MailboxPermission -Identity $mailboxIdentity -User $mailboxUser -AccessRights ReadPermission -InheritanceType All;

#add read permission to mailbox folders
foreach ($folderString in $mailboxIdentityFolderStrings) {
    try {
        #Remove-MailboxFolderPermission -Identity $folderString -User $mailboxUser -Confirm:$false;
        Add-MailboxFolderPermission -Identity $folderString -User $mailboxUser -AccessRights ReadItems;
    }
    catch {
        Write-Output $_;
    }
}

#Remove-MailboxPermission -Identity $mailboxIdentity -User $mailboxUser -AccessRights ReadPermission -Confirm:$false;

Disconnect-ExchangeOnline -Confirm:$false

