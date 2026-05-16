[CmdletBinding()] # CmdletBinding allows the script use built-in PowerShell arguments such as verbose.
param(
    [ValidateRange(1, 12)]
    [int]$Month, # Integer Parameter that validates user input ensuring that value provided is in range of 1 to 12.

    [Parameter(Mandatory=$true)]
    [ValidateSet("Income", "Expense", "All")]
    [string]$AccountType, # Mandatory String Parameter that validates user input ensuring that value provided is one of three words, great for spell checking.

    [int]$BuildingCode = 1, # Integer Parameter that has a default value of 1 unless specified by user input.

    [switch]$Computers # Switch Parameter that acts as a true or false condition
)