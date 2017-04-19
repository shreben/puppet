# PuppetDB installation
class exittask::pdb inherits exittask::params {

  package { 'java-1.8.0-openjdk':
    ensure => installed,
  }

  package {'puppetdb-termini':
    ensure => installed,
  }

  package { 'puppetdb':
    ensure  => installed,
    require => Package['java-1.8.0-openjdk','puppetdb-termini'],
  }

  # file { '/etc/puppetlabs/puppet/puppet.conf':
  #   ensure  => file,
  #   mode    => '0755',
  #   owner   => 'root',
  #   group   => 'root',
  #   content => template('exittask/db_puppet.erb'),
  # }

  file { '/etc/puppetlabs/puppet/routes.yaml':
    ensure => file,
    source => 'puppet:///modules/exittask/routes.yaml',
    notify => Service['puppetserver'],
  }

  file { '/etc/puppetlabs/puppet/puppetdb.conf':
    ensure  => file,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    content => template('exittask/puppetdb.erb'),
    notify  => Service[puppetserver, puppetdb],
    require    => Package[puppetdb],
  }

  file { '/etc/puppetlabs/puppetdb/conf.d/database.ini':
    ensure  => file,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    content => template('exittask/database.erb'),
    notify  => Service[puppetserver, puppetdb],
  }

  file { '/etc/puppetlabs/puppetdb/conf.d/jetty.ini':
    ensure  => file,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    content => template('exittask/jetty.erb'),
    notify  => Service[puppetserver, puppetdb],
  }

  # exec { '/opt/puppetlabs/bin/puppetdb ssl-setup':
  #     path    => ['/opt/puppetlabs/bin'],
  #     require => File['/etc/puppetlabs/puppetdb/conf.d/jetty.ini'],
  #     onlyif  => [ '[ ! -d /etc/puppetlabs/puppetdb/ssl ]' ],
  # }

  service { 'puppetdb':
    ensure     => running,
    name       => 'puppetdb',
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package[puppetdb],
  }
}