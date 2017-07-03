This kickstart is used to handle paritioning for CIS and STIG compliance.  Hardening is done via Ansible or Salt-Stack(Hubblestack).

Create sha-512 hash via 
```
"echo 'import crypt,getpass; print crypt.crypt(getpass.getpass(), "$6$16_CHARACTER_SALT_HERE")' | python -"
```

Kickstart script will ask for endpoint's hostname on boot, and specify file to use in /tmp
