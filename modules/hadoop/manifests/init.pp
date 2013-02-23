class hadoop {
  $hadoop_home = "/opt/hadoop"
  $hadoop_version = "1.1.1"
  $hadoop_path = "${hadoop_home}-${hadoop_version}"
  $hadoop_mirror = "http://apache.mirrors.timporter.net/hadoop/common/hadoop-${hadoop_version}/hadoop-${hadoop_version}.tar.gz"
  
  exec { "download_hadoop":
    command => "wget -O /tmp/hadoop.tar.gz ${hadoop_mirror}",
    path => $path,
    unless => "ls /opt | grep hadoop-${hadoop_version}",
    require => Package["openjdk-6-jdk"]
  }

  exec { "unpack_hadoop" :
    command => "tar -zxf /tmp/hadoop.tar.gz -C /opt",
    path => $path,
    creates => "${hadoop_path}",
    require => Exec["download_hadoop"]
  }

  file { "${hadoop_path}/conf/slaves":
    source => "puppet:///modules/hadoop/slaves",
    mode => 644,
    owner => root,
    group => root,
    require => Exec["unpack_hadoop"]
  }
   
  file { "${hadoop_path}/conf/masters":
    source => "puppet:///modules/hadoop/masters",
    mode => 644,
    owner => root,
    group => root,
    require => Exec["unpack_hadoop"]
  }

  file { "${hadoop_path}/conf/core-site.xml":
    source => "puppet:///modules/hadoop/core-site.xml",
    mode => 644,
    owner => root,
    group => root,
    require => Exec["unpack_hadoop"]
  }
   
  file {
    "${hadoop_path}/conf/mapred-site.xml":
    source => "puppet:///modules/hadoop/mapred-site.xml",
    mode => 644,
    owner => root,
    group => root,
    require => Exec["unpack_hadoop"]
  }

  file { "hdfs-site":
    path => "${hadoop_path}/conf/hdfs-site.xml",
    mode => 644,
    owner => root,
    group => root,
    content => template("hadoop/hdfs-site.xml.erb"),
    require => Exec["unpack_hadoop"]
  }
   
  file { "${hadoop_path}/conf/hadoop-env.sh":
    source => "puppet:///modules/hadoop/hadoop-env.sh",
    mode => 644,
    owner => root,
    group => root,
    require => Exec["unpack_hadoop"]
  }

  file { "export_hadoop":
    path => "/etc/profile.d/hadoop.sh",
    mode => 644,
    owner => root,
    group => root,
    content => template("hadoop/export_hadoop.erb"),
    require => Exec["unpack_hadoop"]
  }

  file { "${hadoop_path}/name":
    ensure => directory,
    mode => 644,
    owner => root,
    group => root,
    require => Exec["unpack_hadoop"]
  }

  file { "${hadoop_path}/data":
    ensure => directory,
    mode => 644,
    owner => root,
    group => root,
    require => Exec["unpack_hadoop"]
  }
}