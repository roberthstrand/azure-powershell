<#
Copyright (c) Microsoft Corporation. All rights reserved.
Licensed under the MIT License. See License.txt in the project root for license information.

Code generated by Microsoft (R) PSSwagger
Changes may cause incorrect behavior and will be lost if the code is regenerated.
#>

<#
.SYNOPSIS
    Create a new compute quota used to limit compute resources.

.DESCRIPTION
    Create a new compute quota.

.PARAMETER Name
    Name of the quota.

.PARAMETER AvailabilitySetCount
    Number  of availability sets allowed.

.PARAMETER CoresCount
    Number  of cores allowed.

.PARAMETER VmScaleSetCount
    Number  of scale sets allowed.

.PARAMETER VirtualMachineCount
    Number  of virtual machines allowed.

.PARAMETER StandardManagedDiskAndSnapshotSize
    Size for standard managed disks and snapshots allowed.

.PARAMETER PremiumManagedDiskAndSnapshotSize
    Size for standard managed disks and snapshots allowed.

.PARAMETER Location
    Location of the resource.

.EXAMPLE

    PS C:\> New-AzsComputeQuota -Name testQuota5 -AvailabilitySetCount 1000 -CoresCount 1000 -VmScaleSetCount 1000 -VirtualMachineCount 1000 -StandardManagedDiskAndSnapshotSize 1024 -PremiumManagedDiskAndSnapshotSize 1024

    Create a new compute quota.

#>
function New-AzsComputeQuota {
    [OutputType([ComputeQuotaObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Name,

        [Parameter(Mandatory = $false)]
        [int32]
        $AvailabilitySetCount = 10,

        [Alias("CoresLimit")]
        [Parameter(Mandatory = $false)]
        [int32]
        $CoresCount = 100,

        [Parameter(Mandatory = $false)]
        [int32]
        $VmScaleSetCount = 100,

        [Parameter(Mandatory = $false)]
        [int32]
        $VirtualMachineCount = 100,

        [Parameter(Mandatory = $false)]
        [int32]
        $StandardManagedDiskAndSnapshotSize = 2048,

        [Parameter(Mandatory = $false)]
        [int32]
        $PremiumManagedDiskAndSnapshotSize = 2048,

        [Parameter(Mandatory = $false)]
        [System.String]
        $Location
    )

    Begin {
        Initialize-PSSwaggerDependencies -Azure
        $tracerObject = $null
        if (('continue' -eq $DebugPreference) -or ('inquire' -eq $DebugPreference)) {
            $oldDebugPreference = $global:DebugPreference
            $global:DebugPreference = "continue"
            $tracerObject = New-PSSwaggerClientTracing
            Register-PSSwaggerClientTracing -TracerObject $tracerObject
        }
    }

    Process {
        # Breaking changes message
        if ($PSBoundParameters.ContainsKey('CoresCount')) {
            if ( $MyInvocation.Line -match "\s-CoresLimit\s") {
                Write-Warning -Message "The parameter alias CoresLimit will be deprecated in future release. Please use the parameter CoresCount instead"
            }
        }

        if ($PSCmdlet.ShouldProcess("$Name", "Create a new compute quota.")) {

            # Default location if missing
            if ([System.String]::IsNullOrEmpty($Location)) {
                $Location = (Get-AzureRmLocation).Location
            }

            if ($null -ne (Get-AzsComputeQuota -Name $Name -Location $Location -ErrorAction SilentlyContinue)) {
                Write-Error "A compute quota with name $Name at location $location already exists"
                return
            }

            $utilityCmdParams = @{}
            $flattenedParameters = @('AvailabilitySetCount', 'CoresCount', 'VmScaleSetCount', 'VirtualMachineCount', 'StandardManagedDiskAndSnapshotSize', 'PremiumManagedDiskAndSnapshotSize' )
            $flattenedParameters | ForEach-Object {
                $Key = $_
                $Value = Get-Variable -Name "$Key" -ValueOnly
                if ($Key -eq 'StandardManagedDiskAndSnapshotSize') {
                    $utilityCmdParams.MaxAllocationStandardManagedDisksAndSnapshots = $Value
                } elseif ($Key -eq 'PremiumManagedDiskAndSnapshotSize') {
                    $utilityCmdParams.MaxAllocationPremiumManagedDisksAndSnapshots = $Value
                } elseif ($Key -eq 'CoresCount') {
                    $utilityCmdParams.CoresLimit = $Value
                } else {
                    $utilityCmdParams[$_] = $Value
                }
            }

            $NewQuota = New-QuotaObject @utilityCmdParams

            $NewServiceClient_params = @{
                FullClientTypeName = 'Microsoft.AzureStack.Management.Compute.Admin.ComputeAdminClient'
            }
            $GlobalParameterHashtable = @{}
            $GlobalParameterHashtable['SubscriptionId'] = $null
            if ($PSBoundParameters.ContainsKey('SubscriptionId')) {
                $GlobalParameterHashtable['SubscriptionId'] = $PSBoundParameters['SubscriptionId']
            }
            $NewServiceClient_params['GlobalParameterHashtable'] = $GlobalParameterHashtable
            $ComputeAdminClient = New-ServiceClient @NewServiceClient_params

            Write-Verbose -Message 'Performing operation create on $ComputeAdminClient.'
            $TaskResult = $ComputeAdminClient.Quotas.CreateOrUpdateWithHttpMessagesAsync($Location, $Name, $NewQuota)

            if ($TaskResult) {
                $GetTaskResult_params = @{
                    TaskResult = $TaskResult
                }
                ConvertTo-ComputeQuota -Quota (Get-TaskResult @GetTaskResult_params)
            }
        }
    }

    End {
        if ($tracerObject) {
            $global:DebugPreference = $oldDebugPreference
            Unregister-PSSwaggerClientTracing -TracerObject $tracerObject
        }
    }
}

