<#
.SYNOPSIS
    A short one-line action-based description, e.g. 'Tests if a function is valid'
.DESCRIPTION
    A longer description of the function, its purpose, common use cases, etc.
.PARAMETER <Parameter-Name>
    The description of a parameter. Add a .PARAMETER keyword for each parameter in the function or script syntax.
    Type the parameter name on the same line as the .PARAMETER keyword. Type the parameter description on the lines following the .PARAMETER keyword.
.EXAMPLE
    PS> Test-MyTestFunction.ps1 -Verbose
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
.INPUTS
    The .NET types of objects that can be piped to the function or script.
    You can also include a description of the input objects. Repeat this keyword for each input type.
.OUTPUTS
    The .NET type of the objects that the cmdlet returns.
    You can also include a description of the returned objects. Repeat this keyword for each output type.
.NOTES
    Additional information about the function or script.
    Typically for the script I provide the following: Name of Script, Version, Author, Contributor (Optional), Date Created, Date Updated, and URL to Script Reposititory.
    As for functions, typically I provide information or caveats e.g. 'This function is not supported in Linux'
.LINK
    The name of a related topic. Repeat this keyword for each related topic. This content appears in the Related Links section of the Help topic.
    The .LINK keyword content can also include a Uniform Resource Identifier (URI) to an online version of the same help topic.
    The online version opens when you use the Online parameter of Get-Help. The URI must begin with http or https.
#>