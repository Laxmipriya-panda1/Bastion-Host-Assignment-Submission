Security Hardening Notes:

- Fail2Ban: configured via package install; configure /etc/fail2ban/jail.local for sshd if needed.
- Disable root SSH login: edit /etc/ssh/sshd_config -> PermitRootLogin no
- Use key-based auth only: PasswordAuthentication no
- Consider using AWS Session Manager instead of open SSH on bastion.
- Centralized logging: send auth logs to CloudWatch or a logging server.
