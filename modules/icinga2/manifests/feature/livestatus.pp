# == Class: icinga2::feature::livestatus
#
# This module configures the Icinga 2 feature livestatus.
#
# === Parameters
#
# [*ensure*]
#   Set to present enables the feature livestatus, absent disables it. Defaults to present.
#
# [*socket_type*]
#   Specifies the socket type. Can be either 'tcp' or 'unix'. Icinga defaults to 'unix'.
#
# [*bind_host*]
#   IP address to listen for connections. Only valid when socket_type is 'tcp'.
#   Icinga defaults to '127.0.0.1'.
#
# [*bind_port*]
#   Port to listen for connections. Only valid when socket_type is 'tcp'. Icinga defaults to 6558.
#
# [*socket_path*]
#   Specifies the path to the UNIX socket file. Only valid when socket_type is 'unix'.
#   Default depends on platform:
#   '/var/run/icinga2/cmd/livestatus' on Linux
#   'C:/ProgramData/icinga2/var/run/icinga2/cmd/livestatus' on Windows.
#
# [*compat_log_path*]
#   Required for historical table queries. Requires CompatLogger feature to be enabled.
#   Default depends platform:
#   'var/icinga2/log/icinga2/compat' on Linux
#   'C:/ProgramData/icinga2/var/log/icinga2/compat' on Windows.
#
#
class icinga2::feature::livestatus(
  Enum['absent', 'present']           $ensure          = present,
  Optional[Enum['tcp', 'unix']]       $socket_type     = undef,
  Optional[String]                    $bind_host       = undef,
  Optional[Integer[1,65535]]          $bind_port       = undef,
  Optional[Stdlib::Absolutepath]      $socket_path     = undef,
  Optional[Stdlib::Absolutepath]      $compat_log_path = undef,
) {

  if ! defined(Class['::icinga2']) {
    fail('You must include the icinga2 base class before using any icinga2 feature class!')
  }

  $conf_dir = $::icinga2::globals::conf_dir
  $_notify  = $ensure ? {
    'present' => Class['::icinga2::service'],
    default   => undef,
  }

  # compose attributes
  $attrs = {
    socket_type     => $socket_type,
    bind_host       => $bind_host,
    bind_port       => $bind_port,
    socket_path     => $socket_path,
    compat_log_path => $compat_log_path,
  }

  # create object
  icinga2::object { 'icinga2::object::LivestatusListener::livestatus':
    object_name => 'livestatus',
    object_type => 'LivestatusListener',
    attrs       => delete_undef_values($attrs),
    attrs_list  => keys($attrs),
    target      => "${conf_dir}/features-available/livestatus.conf",
    order       => 10,
    notify      => $_notify,
  }

  # import library 'livestatus'
  concat::fragment { 'icinga2::feature::livestatus':
    target  => "${conf_dir}/features-available/livestatus.conf",
    content => "library \"livestatus\"\n\n",
    order   => '05',
  }

  # manage feature
  icinga2::feature { 'livestatus':
    ensure => $ensure,
  }
}
