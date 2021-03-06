# DKIM setup for postfix
class postfix::dkim {
    package { 'opendkim':
        ensure => present,
    }

    $dkimdirectory = [
        '/etc/opendkim',
        '/etc/opendkim/keys',
    ]

    file { $dkimdirectory:
        ensure => directory,
        owner  => 'opendkim',
        group  => 'opendkim',
    }

    file { '/etc/opendkim.conf':
        ensure => present,
        source => 'puppet:///modules/postfix/opendkim.conf',
        notify => Service['opendkim'],
    }

    file { '/etc/default/opendkim':
        ensure => present,
        source => 'puppet:///modules/postfix/opendkim',
    }

    file { '/etc/opendkim/TrustedHosts':
        ensure => present,
        source => 'puppet:///modules/postfix/TrustedHosts',
    }

    file { '/etc/opendkim/KeyTable':
        ensure => present,
        source => 'puppet:///modules/postfix/KeyTable',
    }

    file { '/etc/opendkim/SigningTable':
        ensure => present,
        source => 'puppet:///modules/postfix/SigningTable',
    }

    file { '/etc/opendkim/keys/mail.private':
        ensure => present,
        mode   => '0600',
        owner  => 'opendkim',
        group  => 'opendkim',
        source => 'puppet:///private/postfix/mail.private',
    }

    service { 'opendkim':
        ensure => running,
    }
}
