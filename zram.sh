# Install zram
#yay -S zram-generator
#sudo vim /etc/systemd/zram-generator.conf
#Add
#[zram0]
#zram-size = ram / 2

#sudo systemctl daemon-reload
#sudo systemctl start /dev/zram0
#reboot
#free -h
