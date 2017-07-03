install


# Accept EULA
eula --agreed

services --enabled=NetworkManager,sshd

network --onboot yes --device eth0 --bootproto dhcp --noipv6

#platform=x86, AMD64, or Intel EM64T
# System authorization information
authconfig  --useshadow  --passalgo=sha512
# System bootloader configuration
bootloader --location=mbr
# Partition clearing information
clearpart --all --initlabel
# Use text mode install
text
# Firewall configuration
firewall --enabled --ssh
# Run the Setup Agent on first boot
firstboot --disable
# System keyboard
keyboard us
# System language
lang en_US
# Use network installation
url --url=$tree
# If any cobbler repo definitions were referenced in the kickstart profile, include them here.
$yum_repo_stanza
# Network information
$SNIPPET('network_config')
# Reboot after installation
reboot

#Root password
rootpw --iscrypted EnterHashHere
# SELinux configuration
selinux --enforcing
# Do not configure the X Window System
skipx
# System timezone
timezone  America/New_York
# Install OS instead of upgrade
install
# Clear the Master Boot Record
zerombr
# Allow anaconda to partition the system as needed

# Create primary system partitions (required for installs)
part /boot --fstype=xfs --size=512
part pv.01 --grow --size=1

# Create a Logical Volume Management (LVM) group (optional)
volgroup VolGroup --pesize=4096 pv.01

# Create particular logical volumes (optional)
logvol / --fstype=xfs --name=LogVol06 --vgname=VolGroup --size=12288 --grow
# CCE-26557-9: Ensure /home Located On Separate Partition
logvol /home --fstype=xfs --name=LogVol02 --vgname=VolGroup --size=1024 --fsoptions="nodev"
# CCE-26435-8: Ensure /tmp Located On Separate Partition
logvol /tmp --fstype=xfs --name=LogVol01 --vgname=VolGroup --size=1024 --fsoptions="nodev,noexec,nosuid"
# CCE-26639-5: Ensure /var Located On Separate Partition
logvol /var --fstype=xfs --name=LogVol03 --vgname=VolGroup --size=2048 --fsoptions="nodev"
# CCE-26215-4: Ensure /var/log Located On Separate Partition
logvol /var/log --fstype=xfs --name=LogVol04 --vgname=VolGroup --size=1024 --fsoptions="nodev"
# CCE-26436-6: Ensure /var/log/audit Located On Separate Partition
logvol /var/log/audit --fstype=xfs --name=LogVol05 --vgname=VolGroup --size=512 --fsoptions="nodev"
logvol swap --name=lv_swap --vgname=VolGroup --size=2016

%include /tmp/network.txt

%pre
$SNIPPET('log_ks_pre')
$SNIPPET('kickstart_start')
$SNIPPET('pre_install_network_config')
# Enable installation monitoring
$SNIPPET('pre_anamon')
#!/bin/sh
exec < /dev/tty3 > /dev/tty3 2>&1
chvt 3
hn=""

while [ "$hn" == "" ]; do
 clear
 echo
 read -p "Hostname: " hn
done
clear
chvt 1
echo "network --device eth0 --bootproto static --noipv6 --hostname ${hn}" > /tmp/network.txt
%end

%packages
@core
%end

%post --nochroot
%end

%post
%end
