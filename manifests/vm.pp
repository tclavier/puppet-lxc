# defined container from host 
define puppet-lxc::vm ( $ip, $mac, $passwd, $distrib ) {
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
  }

  exec {
    "create ${name} container": 
      command     => "/usr/bin/lxc-create -n ${name} -t debian -- --preseed-file=/var/lib/lxc/${name}/preseed.cfg > /tmp/lxc-${name}.log 2>&1",
      require     => File ["/var/lib/lxc/${name}/preseed.cfg"],
      refreshonly => false,
      creates     => "/var/lib/lxc/${name}/config"
  }


}

