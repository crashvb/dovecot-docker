# dovecot-docker

[![version)](https://img.shields.io/docker/v/crashvb/dovecot/latest)](https://hub.docker.com/repository/docker/crashvb/dovecot)
[![image size](https://img.shields.io/docker/image-size/crashvb/dovecot/latest)](https://hub.docker.com/repository/docker/crashvb/dovecot)
[![linting](https://img.shields.io/badge/linting-hadolint-yellow)](https://github.com/hadolint/hadolint)
[![license](https://img.shields.io/github/license/crashvb/dovecot-docker.svg)](https://github.com/crashvb/dovecot-docker/blob/master/LICENSE.md)

## Overview

This docker image contains [Dovecot](https://www.dovecot.org/).

## Entrypoint Scripts

### dovecot

The embedded entrypoint script is located at `/etc/entrypoint.d/dovecot` and performs the following actions:

1. The PKI certificates are generated or imported.
2. A new dovecot configuration is generated using the following environment variables:

 | Variable | Default Value | Description |
 | -------- | ------------- | ----------- |
 | DOVECOT\_AUTH\_PORT | | If defined, the `auth` service will be exposed over inet. |
 | DOVECOT\_POSTMASTER\_ADDRESS | | Address of the post master. |
 | DOVECOT\_USE\_MAILDIR | | If defined, maildir will be used over mbox. |
 | DOVECOT\_VGID | 5000 | Group ID of the virtual mail user. |
 | DOVECOT\_VMAIL | /var/mail | Virtual mail root. |
 | DOVECOT\_VNAME | vmail | Name of the virtual mail user. |
 | DOVECOT\_VUID | 5000 | User ID of the virtual mail user. |

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
├─ run/
│  └─ secrets/
│     ├─ dovecot.crt
│     ├─ dovecot.key
│     └─ dovecotca.crt
├─ usr/
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

