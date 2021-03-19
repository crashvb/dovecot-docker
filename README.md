# dovecot-docker

## Overview

This docker image contains [Dovecot](https://www.dovecot.org/).

## Entrypoint Scripts

### dovecot

The embedded entrypoint script is located at `/etc/entrypoint.d/dovecot` and performs the following actions:

1. The PKI certificates are generated or imported.
2. A new dovecot configuration is generated using the following environment variables:

 | Variable | Default Value | Description |
 | -------- | ------------- | ----------- |
 | DOVECOT_CERT_DAYS | 30 | Validity period of any generated PKI certificates. |
 | DOVECOT_KEY_SIZE | 4096 | Key size of any generated PKI keys. |
 | DOVECOT_POSTMASTER_ADDRESS | | Address of the post master. |
 | DOVECOT_USE_MAILDIR | | If defined, maildir will be used over mbox. |
 | DOVECOT_VGID | 5000 | Group ID of the virtual mail user. |
 | DOVECOT_VMAIL | /var/mail | Virtual mail root. |
 | DOVECOT_VNAME | vmail | Name of the virtual mail user. |
 | DOVECOT_VUID | 5000 | User ID of the virtual mail user. |

## Healthcheck Scripts

### dovecot

The embedded healthcheck script is located at `/etc/healthcheck.d/dovecot` and performs the following actions:

1. Verifies that all dovecot services are operational.

## Standard Configuration

### Container Layout

```
/
├─ etc/
│  ├─ dovecot/
│  ├─ entrypoint.d/
│  │  └─ dovecot
│  └─ healthcheck.d/
│     └─ dovecot
└─ usr/
│  └─ local/
│     └─ bin/
│        └─ dovecot-test-imap
└─ var/
   └─ mail/
```

### Exposed Ports

* `993/tcp` - IMAP secure port.

### Volumes

* `/etc/dovecot` - dovecot configuration directory.
* `/var/mail` - default mail directory.

## Development

[Source Control](https://github.com/crashvb/dovecot-docker)

