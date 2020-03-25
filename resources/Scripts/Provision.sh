#!/bin/bash

echo 'Provisioning Environment with Dovecot and Test Messages'

# Install and Configure Dovecot

  if which dovecot > /dev/null; then
    echo 'Dovecot is already installed'
  else

    echo 'Updating apt-get repositories'
    apt-get -qq update


    echo 'Installing Dovecot'
    apt-get -qq -y install dovecot-imapd dovecot-pop3d
    touch /etc/dovecot/local.conf
    echo 'mail_location = maildir:/home/%u/Maildir' >> /etc/dovecot/local.conf
    echo 'disable_plaintext_auth = no' >> /etc/dovecot/local.conf
    echo 'mail_max_userip_connections = 10000' >> /etc/dovecot/local.conf
    systemctl restart dovecot
    'Dovecot has been installed'
  fi


# Create "testuser"

  if getent passwd testuser > /dev/null; then
    echo 'testuser already exists'
  else
    echo 'Creating User "testuser" with password "applesauce"'
    useradd testuser -m -s /bin/bash
    echo "testuser:applesauce" | chpasswd
    echo 'User created'
  fi


# Setup Email

  echo 'Refreshing the test mailbox.'

  systemctl stop dovecot
  [ -d "/home/testuser/Maildir" ] && rm -R /home/testuser/Maildir
  cp -Rp /resources/Maildir /home/testuser/
  chown -R testuser:testuser /home/testuser/Maildir
  systemctl start dovecot

  echo 'Test mailbox restored'.


# Done!

echo ''
echo ''
echo 'Dovecot has been provisioned with the test mailbox.'
echo ''
echo ''
