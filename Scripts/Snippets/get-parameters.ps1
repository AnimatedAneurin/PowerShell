[CmdletBinding(SupportsShouldProcess)] # CmdletBinding allows the script use built-in PowerShell arguments such as verbose. SupportsShouldProcess allows the script to run in WhatIf mode.
param(
    [ValidateRange(1, 12)]
    [int]$Month, # Integer Parameter that validates user input ensuring that value provided is in range of 1 to 12.

    [Parameter(Mandatory=$true)]
    [ValidateSet("Income", "Expense", "All")]
    [string]$AccountType, # Mandatory String Parameter that validates user input ensuring that value provided is one of three words, great for spell checking.

    [int]$BuildingCode = 1, # Integer Parameter that has a default value of 1 unless specified by user input.

    [switch]$Computers # Switch Parameter that acts as a true or false condition
)

#! If using SupportsShouldProcess and WhatIf, it would be important to know that any destructive code must run inside a .shouldprocess() block. Otherwise, the destructive code may run regardless.

#** An example of how destructive code should be wrapped:

$folder = "C:\DLM"
if ($PSCmdlet.ShouldProcess($folder, "Remove Folder")) {
    Remove-Item -Path $folder -Recurse -Force
}

#** If you want the script to run in WhatIf mode but want specific code inside the script to run normally, then you need to append the -WhatIf:$false parameter to the command, as shown below:

Start-Transcript -Path "C:\DLM\TestLog.log" -WhatIf:$false
Stop-Transcript -ErrorAction SilentlyContinue

#** Please note that not all cmdlets support the -WhatIf parameter so you may need to see if it's available using: Get-Command [cmdlet] -Syntax