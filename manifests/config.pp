# == Class: icingaweb2::config
#
# This class manages general configuration files of Icinga Web 2.
#
# === Parameters
#
# This class does not provide any parameters.
#
# === Examples
#
# This class is private and should not be called by others than this module.
#
class icingaweb2::config {

  $conf_dir         = $::icingaweb2::params::conf_dir
  $conf_user        = $::icingaweb2::params::conf_user
  $conf_group       = $::icingaweb2::params::conf_group

  $logging          = $::icingaweb2::logging
  $logging_file     = $::icingaweb2::logging_file
  $logging_level    = $::icingaweb2::logging_level
  $preferences_type = 'ini'
  $show_stacktraces = $::icingaweb2::show_stacktraces
  $module_path      = $::icingaweb2::module_path
  # TODO: $config_backend can be 'db', however in this case it requires a valid $config_resource
  $config_backend   = 'ini'
  $theme            = $::icingaweb2::theme
  $theme_disabled   = $::icingaweb2::theme_disabled

  File {
    mode  => '0660',
    owner => $conf_user,
    group => $conf_group
  }

  $config_ini = {
    logging => {
      'log'   => $logging,
      'file'  => $logging_file,
      'level' => $logging_level,
    },
    preferences => {
      'type' => $preferences_type,
    },
    global => {
      'show_stacktraces' => $show_stacktraces,
      'module_path'      => $module_path,
      'config_backend'   => $config_backend,
    },
    themes => {
      'default' => $theme,
      'disabled' => $theme_disabled,
    }
  }

  icingaweb2::inisection {'config.ini':
    target   => "${conf_dir}/config.ini",
    settings => $config_ini,
  }

  file {
    "${conf_dir}/authentication.ini":
      ensure => file;

    "${conf_dir}/roles.ini":
      ensure => file;

    "${conf_dir}/groups.ini":
      ensure => file,
  }

}
