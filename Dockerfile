# Base on Fedora 22. While I like to base stuff on CentOS, Fedora has
# more up to date packages, and CentOS doesn't have some packages like
# LuaJIT. At this time the Fedora base image is also a little bit
# smaller than CentOS.

FROM fedora:22

RUN dnf -y install \
    cronie \
    findutils \
    logrotate \
    python-pip \
    python-simplejson \
    supervisor \
    suricata \
    tar

# Install my own rule download tool, rulecat and seed the image with
# some rules.
RUN pip install https://github.com/jasonish/py-idstools/archive/master.zip && \
    idstools-rulecat --rules-dir /etc/suricata/rules

# Cleanup - should probably be merged with above to reduce layer size.
RUN dnf -y clean all && \
    find /var/log -type f -exec rm -f {} \;

# Open up the permissions on /var/log/suricata so linked containers can
# see it.
RUN chmod 755 /var/log/suricata

COPY /etc /etc
COPY /entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]