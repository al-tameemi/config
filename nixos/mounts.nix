{ config, pkgs, ...}:

{
  systemd.tmpfiles.rules = [
    "d /drives 0755 mohammed users"
  ];

  fileSystems."/drives/NVME0" = {
    device = "/dev/disk/by-uuid/9b715a97-d159-4cf3-8ff3-ca7b61c978ee";
    fsType = "ext4";
  };

  fileSystems."/drives/NVME1" = {
    device = "/dev/disk/by-uuid/055b2d4e-fd5b-48e4-9f27-c8ce1a4c6df2";
    fsType = "ext4";
  };

  fileSystems."/drives/NVME2" = {
    device = "/dev/disk/by-uuid/e35b836f-f728-4184-b4c0-067f46fbd524";
    fsType = "ext4";
  };

  fileSystems."/drives/SSD0" = {
    device = "/dev/disk/by-uuid/1bcabe72-221c-4be6-b735-2c6755ca0182";
    fsType = "ext4";
  };

  fileSystems."/archive" = {
    device = "/dev/disk/by-uuid/c4e8ba53-68e6-4aaa-97fe-e36a8f15ed25";
    fsType = "btrfs";
  };

  fileSystems."/home/mohammed/Documents" = {
    device = "/drives/NVME0/Home/Documents";
    options = ["bind"];
  };

  fileSystems."/home/mohammed/.cache" = {
    device = "/drives/NVME0/Home/.cache";
    options = ["bind"];
  };

  fileSystems."/home/mohammed/Downloads" = {
    device = "/drives/NVME0/Home/Downloads";
    options = ["bind"];
  };

  fileSystems."/home/mohammed/Music" = {
    device = "/drives/NVME0/Home/Music";
    options = ["bind"];
  };

  
  fileSystems."/home/mohammed/Pictures" = {
    device = "/drives/NVME0/Home/Pictures";
    options = ["bind"];
  };
  
  fileSystems."/home/mohammed/Projects" = {
    device = "/drives/NVME0/Home/Projects";
    options = ["bind"];
  };
  
  fileSystems."/home/mohammed/Videos" = {
    device = "/drives/NVME0/Home/Videos";
    options = ["bind"];
  };
}
