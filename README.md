# Delphi SMTP With OAuth2

# Requirements for FPCUnit test project
* Lazarus IDE
* Add required package for FPCUnit to the project
* 64 Bit OpenSSL DLLs from Indy
* Indy Sockets

----

1. Register Your App in Azure AD
Go to Azure Portal > Azure Active Directory > App registrations

Create a new registration

2. API Permissions
Navigate to API permissions > Add a permission

Choose:

APIs my organization uses

Search for and select Office 365 Exchange Online

Choose Application permissions

✅ Select SMTP.Send

Click Add permissions

Click "Grant admin consent" for your tenant

3. Allow SMTP AUTH for the Mailbox (Optional, if disabled globally)
Some tenants have SMTP AUTH disabled by default. You may need to enable it:

Use PowerShell (Exchange Online Management Shell):

powershell
Copy
Edit
Set-CASMailbox -Identity user@example.com -SmtpClientAuthenticationDisabled $false
💡 Important Notes
SMTP with OAuth2 is only supported for Exchange Online, not on-premises Exchange.

The app will use client credentials (client ID + secret or certificate) to get a token and then use that token in the SMTP AUTH process.

🎯 For Sending Email via SMTP with OAuth2, You Need:
Azure AD app registration

SMTP.Send application permission

Admin consent granted

OAuth2 token requested with:

Resource: https://outlook.office365.com/

Scope: https://outlook.office365.com/.default

Use the token in the SMTP AUTH login process (XOAUTH2 mechanism)
