<#
.SYNOPSIS
    Sends E-Mail via PowerShell.
.DESCRIPTION
    Sends E-Mail via PowerShell through O365 SMTP Server (Other Providers untested)
.NOTES
    Name: E-Mail - O365
    Version: 2.0
    Author: Aneurin Weale - DLM
    Date Created: 21/12/2023
    Last Updated: 21/12/2023
    URL: https://github.com/AnimatedAneurin/PowerShell/blob/PowerShell/Scripts/E-Mail/E-Mail%20-%20O365.ps1
#>

# SMTP server settings
$smtpServer = "your_smtp_server" #"smtp.office365.com"
$smtpFrom = "your_email@example.com"
$smtpTo = "ayour_email@example.com"
$messageSubject = "Test Email"
$messageBody = "This is a test email sent via PowerShell."

# Email credentials
$username = "your_email@example.com"
$password = ConvertTo-SecureString "your_email_password" -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($username, $password)

# Creating the email message
$mailmessage = New-Object system.net.mail.mailmessage
$mailmessage.from = ($smtpFrom)
$mailmessage.To.add($smtpTo)
$mailmessage.Subject = $messageSubject
$mailmessage.Body = $messageBody

# SMTP client with STARTTLS
$smtp = New-Object Net.Mail.SmtpClient($smtpServer)
$smtp.EnableSsl = $true  # Enable STARTTLS
$smtp.Credentials = $credential
$smtp.Send($mailmessage)

Write-Host "Email sent successfully."