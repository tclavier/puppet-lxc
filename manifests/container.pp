# the container itself could be configured by puppet
class puppet-lxc::container {
  # we must remove klogd to avoid bug in multy-read kernel messages
	package { ["klogd"]: ensure => purged; }
	package { ["sysvinit-core"]: ensure => installed; }
  file { 
    '/etc/inittab' :
      source => "puppet:///modules/puppet-lxc/etc/inittab",
      owner  => root,
      group  => root,
      mode   => 444;
  }
}

