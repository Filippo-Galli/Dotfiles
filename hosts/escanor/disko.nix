{ lib, ... }:

{
  disko.devices.disk.nvme0n1 = {
    type = "disk";
    device = lib.mkDefault "/dev/nvme0n1";
    content = {
      type = "gpt";
      partitions = {
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
            type = "luks";
            name = "crypted";
            settings.allowDiscards = true;
            extraFormatArgs = [
              "--type"
              "luks2"
              "--pbkdf"
              "argon2id"
            ];
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
    };
  };
}
