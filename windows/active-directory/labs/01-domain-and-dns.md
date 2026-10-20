# Lab 01: AD DS and DNS

**Status: not executed.** Prerequisites: both Windows hosts created, renamed and accessible
through RDP; DC01 Administrator password saved. On EC2, the primary private IP is fixed
on the network interface; leave the Windows IP/gateway on DHCP. Do not set an arbitrary
static gateway or replace AWS networking configuration.

1. Connect to DC01 with the SSM RDP tunnel. Open Windows PowerShell as Administrator.
2. Run `C:\Lab\02-create-domain.ps1`. Enter a separate DSRM recovery password and confirm.
   The server reboots. A DNS-delegation warning for the test domain can be expected; read
   other prerequisite warnings and do not bypass them.
3. Reconnect after startup as `GUOTLAB\Administrator` using the saved DC01 password.
4. Configure DC01's DNS client and external forwarder:

```powershell
$nic = @(Get-NetAdapter | Where-Object Status -eq 'Up')
if ($nic.Count -ne 1) { throw 'Select the correct lab NIC manually.' }
Set-DnsClientServerAddress -InterfaceIndex $nic[0].ifIndex -ServerAddresses '10.77.10.10'
Set-DnsServerForwarder -IPAddress '10.77.0.2'
Get-ADDomain
Get-Service NTDS,DNS,Netlogon
Resolve-DnsName -Type SRV '_ldap._tcp.dc._msdcs.ad.guotlab.test'
Resolve-DnsName docs.aws.amazon.com
dcdiag /test:dns /v
```

`10.77.0.2` is the VPC resolver for this template's `10.77.0.0/16` network. Do not configure
it as MGMT01's alternate DNS: domain members must query AD DNS for domain records.

Pass evidence: correct DNSRoot, running services, an SRV record pointing to DC01,
external name resolution, and explanation of any dcdiag failures. Save actual output,
not the example expected values. Record provisioning start/end times if measuring duration.
Cleanup: keep the domain for subsequent exercises; stop hosts when the session ends.

Check questions: Why do AD clients use domain DNS? What does an SRV record locate?
How is the DSRM password different from the domain Administrator password?

[Microsoft Install-ADDSForest reference](https://learn.microsoft.com/en-us/powershell/module/addsdeployment/install-addsforest)
