#Script written by Alex Martini
#Get replicaiton Health
$ReplicationHealth = (Get-VMReplication)

#Build email function
function EmailAlert {
    
            $To = 
            $from = 
            $companyname = 
            $EmailSubject = "Hyper-V Replication Error for $companyname"
            $smtp = 
            $Message="
                Replication has failed for $companyname
                $replicainfo
                "
    
            $MailMessage = @{
                    To = $To
                    From = $from
                    Subject = $EmailSubject
                    Body = $Message
                    priority = "High"
                    Smtpserver = $smtp
                    ErrorAction = "SilentlyContinue" 
                }
                
            Send-MailMessage @MailMessage
}

#Send email if health = Critical or Warning

if ($ReplicationHealth.health -eq "Critical" -or $ReplicationHealth.Health -eq "warning") {

    $replicainfo = Get-VMReplication | select vmname,replicationhealth,state|fl |out-string
    EmailAlert
    
} else {
    $null
}