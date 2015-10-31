package info.jdavid.packer.lfs

import com.squareup.okhttp.OkHttpClient
import com.squareup.okhttp.Request
import groovy.json.JsonOutput

import java.lang.management.ManagementFactory

int vmCores = Math.max(1, Runtime.getRuntime().availableProcessors() - 3)
long osMemory = ManagementFactory.getOperatingSystemMXBean().getTotalPhysicalMemorySize() as Long
int vmRam = Math.min(6144, Math.max(2048, osMemory.intdiv(1024*1024) - 4096));

File rootDir = { ->
  Closure recurse
  recurse = { File d ->
    if (d.listFiles().find { it.name == 'settings.gradle' }) return d
    recurse(d.parentFile)
  }
  File dir = recurse(new File('.').canonicalFile)
  if (dir) return dir
  throw new RuntimeException('Failed to find download directory.')
}.call()

File downloadDir = rootDir.with {
  new File(it, 'tmp').with {
    mkdir()
    it
  }
}

def latestIso = { ->
  String baseUrl = 'http://cdimage.debian.org/debian-cd/current/amd64/iso-cd'
    //'http://releases.ubuntu.com/vivid'
  def req = new Request.Builder().with {
    url("$baseUrl/SHA512SUMS")
//    url("$baseUrl/SHA256SUMS")
    build()
  }
  def out = new OkHttpClient().newCall(req).execute()
  if (!out.isSuccessful()) {
    throw new RuntimeException('Failed to get latest iso url.')
  }
  def source = out.body().source()
  while (true) {
    String line = source.readUtf8LineStrict()
    def m = line =~ /^([a-f0-9]+)\s+debian-([0-9.]+)-amd64-netinst\.iso$/
//    def m = line =~ /^([a-f0-9]+)\s+\*ubuntu-([0-9.]+)-server-amd64\.iso$/
    if (m && m[0]) {
      def groups = m[0] as List
      String name = "debian-${groups[2]}-amd64-netinst.iso"
//      String name = "ubuntu-${groups[2]}-server-amd64.iso"
      File local = new File(downloadDir, name)
      String sha = groups[1]
      String url
      if (local.exists()) {
        url = local.toURI().toASCIIString()
      }
      else {
        url = "$baseUrl/$name"
        downloadDir.deleteDir()
        downloadDir.mkdir()
      }
      return [ url: url, sha: sha ]
    }
  }
}.call()


def json = [
  variables: [
    username: 'lfs',
    password: 'lfs'
  ],
  builders: [
    [
      name: 'lfs',
      vm_name: 'lfs',
      type: 'virtualbox-iso',
      guest_os_type: 'Linux_64',
      iso_urls: [
        latestIso.url
      ],
      iso_checksum: latestIso.sha,
      iso_checksum_type: 'sha512',
//      iso_checksum_type: 'sha256',
      disk_size: '12288',
      hard_drive_interface: 'sata',
      guest_additions_mode: 'disable',
//      headless: true,
      ssh_username: '{{user `username`}}',
      ssh_password: '{{user `password`}}',
      ssh_wait_timeout: '6000s',
      http_directory: './src/main/resources',
      boot_command: [
        '<esc><wait>',
        'auto ',
        'preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg ',
        '<enter>'/*,
        '<wait>',
        '/etc/init.d/sshd start',
        '<enter>',
        '<wait>'*/
      ],
//      boot_command: [
//        '<esc><esc><enter><wait>',
//        '/install/vmlinuz noapic ',
//        'preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg ',
//        'debian-installer=en_US auto locale=en_US kbd-chooser/method=us ',
//        'hostname=lfs ',
//        'fb=false debconf/frontend=noninteractive ',
//        "keyboard-configuration/modelcode=SKIP keyboard-configuration/layout=USA ",
//        'console-setup/ask_detect=false ',
//        'initrd=/install/initrd.gz -- <enter>'
//      ],
      boot_wait: '5s',
      shutdown_command: 'sudo -S /sbin/shutdown -hP now',
      shutdown_timeout: '300s',
      vboxmanage: [
        ['modifyvm', '{{.Name}}', '--memory', vmRam],
        ['modifyvm', '{{.Name}}', '--cpus', vmCores]
      ]
    ]
  ],
  provisioners: [
    [
      type: 'shell',
      scripts: [
        'src/main/resources/setup.sh',
        'src/main/resources/binutils1.sh',
        'src/main/resources/gcc1.sh',
        'src/main/resources/linux_api_headers.sh',
        'src/main/resources/glibc.sh',
        'src/main/resources/libstd.sh',
        'src/main/resources/binutils2.sh',
        'src/main/resources/gcc2.sh',
        'src/main/resources/ncurses.sh',
        'src/main/resources/bash.sh',
        'src/main/resources/bzip2.sh',
        'src/main/resources/coreutils.sh',
        'src/main/resources/diffutils.sh',
        'src/main/resources/file.sh',
        'src/main/resources/findutils.sh',
        'src/main/resources/gawk.sh',
        'src/main/resources/gettext.sh',
        'src/main/resources/grep.sh',
        'src/main/resources/gzip.sh',
        'src/main/resources/m4.sh',
        'src/main/resources/make.sh',
        'src/main/resources/patch.sh',
        'src/main/resources/perl.sh',
        'src/main/resources/sed.sh',
        'src/main/resources/tar.sh',
        'src/main/resources/texinfo.sh',
        'src/main/resources/util_linux.sh',
        'src/main/resources/xz.sh',
        'src/main/resources/strip.sh',
        'src/main/resources/rootssh.sh',
      ]
    ]
  ]
]

def json2 = [
  builders: [
    [
      name: 'lfs2',
      vm_name: 'lfs2',
      type: 'virtualbox-ovf',
      source_path: 'output-lfs/lfs.ovf',
      guest_additions_mode: 'disable',
      ssh_username: 'root',
      ssh_password: 'packer',
      boot_wait: '5s',
      shutdown_command: 'sudo /sbin/shutdown -hP now'
    ]
  ],
  provisioners: [
    [
      type: 'shell',
      scripts: [
        'src/main/resources/mounts.sh',
      ]
    ],
    [
      type: 'shell',
      remote_path: '/scripts/script.sh',
      execute_command: 'chroot /mnt/lfs /tools/bin/env -i HOME=/root ' +
                       'PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin /tools/bin/bash ' +
                       '\'{{ .Path }}\'',
      scripts: [
        'src/main/resources/filesystem.sh',
        'src/main/resources/system.sh',
      ]
    ]
  ]
]

def json3 = [
  builders: [
    [
      name: 'lfs3',
      vm_name: 'lfs3',
      type: 'virtualbox-ovf',
      source_path: 'output-lfs2/lfs2.ovf',
      guest_additions_mode: 'disable',
      ssh_username: 'root',
      ssh_password: 'packer',
      boot_wait: '500s',
      shutdown_command: 'sudo /sbin/shutdown -hP now'
    ]
  ],
  provisioners: [

  ]
]

new File(rootDir, 'lfs.json').write(JsonOutput.prettyPrint(JsonOutput.toJson(json)))
new File(rootDir, 'lfs2.json').write(JsonOutput.prettyPrint(JsonOutput.toJson(json2)))
new File(rootDir, 'lfs3.json').write(JsonOutput.prettyPrint(JsonOutput.toJson(json3)))
