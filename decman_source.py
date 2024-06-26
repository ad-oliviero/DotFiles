# this file does not work anymore, i just have it here to remember that i have to find a way to sync this settings
decman.files["/etc/vconsole.conf"] = File(content="KEYMAP=it", encoding="utf-8")
decman.files["/etc/systemd/zram-generator.conf"] = File(content="[zram0]\nzram-size = ram\ncompression-algorithm = zstd\n", encoding="utf-8")

