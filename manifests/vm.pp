# defined container from host 
define puppet-lxc::vm ( $memory='256M', $ip, $mac, $passwd, $distrib) {
  file {
    "/var/lib/lxc/${name}/preseed.cfg" :
      owner   => "root",
      group   => "root",
      mode    => 0644,
      content => template("puppet-lxc/preseed.cfg.erb");
    "/var/lib/lxc/${name}/rootfs/etc/network/interfaces" :
      owner     => "root",
      group     => "root",
      mode      => 0644,
      require   => Exec ["create ${name} container"],
      subscribe => Exec ["create ${name} container"],
      content   => template("puppet-lxc/interface.erb");
    "/var/lib/lxc/${name}/config":
      owner     => "root",
      group     => "root",
      mode      => 0444,
      require   => Exec ["create ${name} container"],
      content   => template("puppet-lxc/config.erb");
    "/etc/lxc/auto/${name}" :
      ensure  => link,
      require => File["/var/lib/lxc/${name}/config"],
      target  => "/var/lib/lxc/${name}/config";
  }

  exec {
    "create ${name} container": 
      command     => "/usr/share/lxc/templates/lxc-debian --preseed-file=/var/lib/lxc/${name}/preseed.cfg -p /var/lib/lxc/${name} -n ${name}",
      require     => [File ["/var/lib/lxc/${name}/preseed.cfg"],Lvm::Volume["$name"]],
      refreshonly => false,
      creates     => "/var/lib/lxc/${name}/config";
  }

}

