{
  disko.devices.disk = {

    sdb = {
      type = "disk";
      device = "/dev/sdb";
      content.type = "gpt";

      content.partitions = {

        ESP = {
          type = "ef00";
          size = "1G";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };

        ROOT = {
          type = "8300";
          size = "100%";
          content = {
            type = "btrfs";
            extraArgs = [ "-f" ];
            subvolumes = {
              "@/root" = {
                mountpoint = "/";
                mountOptions = [
                  "noatime"
                  "compress=zstd"
                ];
              };
              "@/nix" = {
                mountpoint = "/nix";
                mountOptions = [
                  "noatime"
                  "compress=zstd"
                ];
              };
              "@/home" = {
                mountpoint = "/home";
                mountOptions = [ "compress=zstd" ];
              };
              "@/var" = {
                mountpoint = "/var";
                mountOptions = [ "compress=zstd" ];
              };
              "@/swap" = {
                mountpoint = "/swap";
                mountOptions = [ "noatime" ];
                swap.swapfile.size = "16G";
              };
            };
          };
        };
      };
    };

    sda = {
      type = "disk";
      device = "/dev/sda";
      content.type = "gpt";

      content.partitions.DATA = {
        type = "8300";
        size = "100%";
        content = {
          type = "filesystem";
          format = "ext4";
          mountpoint = "/mnt/storage";
          mountOptions = [
            "defaults"
            "noatime"
          ];
        };
      };
    };

  };
}
