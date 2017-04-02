# Configure BitLocker disk encryption on the system volume
do {
    $volume = Get-BitLockerVolume $env:SystemDrive

    Write-BoxstarterMessage "BitLocker status of $env:SystemDrive is $($volume.VolumeStatus)"

    if ($volume.VolumeStatus -eq 'FullyDecrypted') {
        #Uh-oh, the volume is not encrypted!
        Write-BoxstarterMessage "The system drive has not yet been encrypted!"
        Write-BoxstarterMessage "I can't get PowerShell automated configuration of this to work yet, so it must be done manually!"
        Write-BoxstarterMessage "Enable encryption on the system volume and back up the recovery key to a USB key and 1Password."
        Write-BoxstarterMessage "This is serious!  Your next BIOS update or hardware change will lock you out so you MUST have that key!"
        Read-Host "Press ENTER once you have enabled BitLocker"
    }
} while ($volume.VolumeStatus -eq 'FullyDecrypted')