<#
.SYNOPSIS
    Sends E-Mail via PowerShell.
.DESCRIPTION
    Sends E-Mail via PowerShell through O365 SMTP Server (Other Providers untested)
.NOTES
    Name: E-Mail - O365
    Version: 1.0
    Author: Aneurin Weale - DLM
    Date Created: 21/12/2023
    Last Updated: 21/12/2023
    URL: 
#>

# SMTP server settings
$smtpServer = "your_smtp_server" #"smtp.office365.com"
$smtpFrom = "your_email@example.com"
$smtpTo = "recipient@example.com"
$messageSubject = "Test Email"
$messageBody = "This is a test email sent via PowerShell."

# Email credentials
$username = "your_email@example.com"
$password = "your_email_password"

# Creating the email message
$mailmessage = New-Object system.net.mail.mailmessage
$mailmessage.from = ($smtpFrom)
$mailmessage.To.add($smtpTo)
$mailmessage.Subject = $messageSubject
$mailmessage.Body = $messageBody

# SMTP client with STARTTLS
$smtp = New-Object Net.Mail.SmtpClient($smtpServer)
$smtp.EnableSsl = $true  # Enable STARTTLS
$smtp.Credentials = New-Object System.Net.NetworkCredential($username, $password)
$smtp.Send($mailmessage)

Write-Host "Email sent successfully."
