FROM crashvb/supervisord:202002211640
LABEL maintainer "Richard Davis <crashvb@gmail.com>"

# Install packages, download files ...
RUN docker-apt dovecot-core dovecot-imapd python3 python3-pip

# Configure: dovecot
ENV DOVECOT_CONFIG=/etc/dovecot DOVECOT_VGID=5000 DOVECOT_VNAME=vmail DOVECOT_VUID=5000
ADD dovecot-* /usr/local/bin/
RUN install --directory --group=root --mode=0775 --owner=root /usr/local/share/dovecot && \
	install --group=dovecot --mode=640 --owner=dovecot /dev/null ${DOVECOT_CONFIG}/users && \
	sed --expression='/!include auth-system.conf.ext/s/^/#/g' \
		--expression='/#!include auth-passwdfile.conf.ext/s/^#//g' \
		--in-place=.dist ${DOVECOT_CONFIG}/conf.d/10-auth.conf && \
	sed --expression="/#log_path = syslog/clog_path = /dev/stderr" \
		--expression="/#info_log_path =/cinfo_log_path = /dev/stdout" \
		--expression="/#log_timestamp =/clog_timestamp = \"%Y-%m-%d %H:%M:%S \"" \
		--in-place=.dist ${DOVECOT_CONFIG}/conf.d/10-logging.conf && \
	sed --expression="/#mail_gid =/cmail_gid=${DOVECOT_VGID}" \
		--expression="/#mail_uid =/cmail_uid=${DOVECOT_VUID}" \
		--in-place=.dist ${DOVECOT_CONFIG}/conf.d/10-mail.conf && \
	sed --expression="s!${DOVECOT_CONFIG}/private/dovecot.pem!/etc/ssl/certs/dovecot.crt!g" \
		--expression="s!${DOVECOT_CONFIG}/private/dovecot.key!/etc/ssl/private/dovecot.key!g" \
		--expression="/#ssl_ca =/cssl_ca = /etc/ssl/certs/dovecotca.crt" \
		--in-place=.dist ${DOVECOT_CONFIG}/conf.d/10-ssl.conf && \
	sed --expression="/#lda_mailbox_autocreate =/clda_mailbox_autocreate = yes" \
		--expression="/#lda_mailbox_autosubscribe =/clda_mailbox_autosubscribe = yes" \
		--in-place=.dist ${DOVECOT_CONFIG}/conf.d/15-lda.conf && \
	mv ${DOVECOT_CONFIG} /usr/local/share/dovecot/config && \
	groupadd -g ${DOVECOT_VGID} ${DOVECOT_VNAME} && \
	useradd --create-home --gid=${DOVECOT_VGID} --home-dir /home/${DOVECOT_VNAME} --shell=/usr/bin/nologin -d /home/${DOVECOT_VNAME} --uid=${DOVECOT_VUID} ${DOVECOT_VNAME}

# Configure: python
RUN python3 -m pip install --upgrade pip && \
	python3 -m pip install setuptools wheel && \
	python3 -m pip install mailbox

# Configure: supervisor
ADD supervisord.dovecot.conf /etc/supervisor/conf.d/dovecot.conf

# Configure: entrypoint
ADD entrypoint.dovecot /etc/entrypoint.d/dovecot

# Configure: healthcheck
ADD healthcheck.dovecot /etc/healthcheck.d/dovecot

EXPOSE 143/tcp 993/tcp

VOLUME /var/mail ${DOVECOT_CONFIG}
