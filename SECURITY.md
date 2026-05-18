# Security Policy

## Supported Versions

This project is a personal homelab documentation. Security updates are applied to the latest version only.

| Version | Supported          |
| ------- | ------------------ |
| Latest  | :white_check_mark: |
| Older   | :x:                |

## Reporting a Vulnerability

If you discover a security vulnerability in this documentation or configuration, please report it by:

1. **DO NOT** open a public issue
2. Send an email to the repository owner through GitHub
3. Or open a private security advisory on GitHub

### What to Include

- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (if any)

### Response Time

- Initial response: Within 48 hours
- Status update: Within 7 days
- Fix timeline: Depends on severity

## Security Best Practices

This homelab follows these security principles:

### Network Segmentation
- **Public Network (192.168.1.0/24)**: Management and non-sensitive services
- **Private Network (10.10.10.0/24)**: Sensitive services isolated from LAN
- **VPN Access**: Tailscale for secure remote access

### Access Control
- No services directly exposed to the internet
- All external access through Tailscale VPN
- Nginx Proxy Manager for internal routing with SSL
- Firewall rules at multiple levels (Proxmox, container, application)

### Authentication
- Strong passwords required
- 2FA enabled on critical services (Vaultwarden, Keycloak)
- SSO implementation with Keycloak for centralized authentication
- Regular password rotation recommended

### Data Protection
- **Encryption at rest**: Sensitive data encrypted
- **Encryption in transit**: SSL/TLS for all web services
- **Backup encryption**: All remote backups encrypted with AES-256
- **3-2-1 Backup rule**: 3 copies, 2 media types, 1 offsite

### Monitoring
- Grafana + Prometheus for system monitoring
- Log aggregation and analysis
- Alerts for suspicious activity
- Regular security audits

## Known Security Considerations

### Tailscale Domain
- The Tailscale domain in this repository uses a placeholder (`tailXXXXXX.ts.net`)
- Replace with your actual Tailscale domain when deploying
- Never commit real Tailscale domains to public repositories

### Credentials
- No credentials are stored in this repository
- Use `.env` files for sensitive configuration (see `.env.example`)
- All `.env` files are gitignored

### SSL Certificates
- Use Let's Encrypt or Tailscale HTTPS for SSL certificates
- Certificates are automatically renewed
- Private keys never committed to repository

## Security Checklist

Before deploying:

- [ ] Change all default passwords
- [ ] Enable 2FA on critical services
- [ ] Configure firewall rules
- [ ] Set up backup encryption
- [ ] Configure monitoring and alerts
- [ ] Review and update `.env` files
- [ ] Verify network segmentation
- [ ] Test disaster recovery procedures

## Updates and Patches

- Monitor security advisories for all used software
- Apply security patches promptly
- Test updates in non-production environment first
- Document all security-related changes

## Compliance

This is a personal homelab and does not require specific compliance certifications. However, it follows industry best practices for:

- Data protection
- Access control
- Incident response
- Disaster recovery

## Contact

For security concerns, contact the repository owner through GitHub.

---

**Last Updated**: 2026-01-18