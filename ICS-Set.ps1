<#
This takes input parameters as a front-end for this: https://github.com/loxia01/PSInternetConnectionSharing.

Some notes.
#>
Param(
[Parameter(Mandatory=$True)]
[String] $Pdanet,
[Parameter(Mandatory=$True)]
[String] $Wan = 'out.png'
)

Set-Ics -PublicConnectionName "$Pdanet" -PrivateConnectionName "$Wan"