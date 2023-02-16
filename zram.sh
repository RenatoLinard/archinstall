# Install zram
yay -S zram-generator

# Edit zram-generator.conf
echo "Manual step required!"
echo "Add to /etc/systemd/zram-generator.conf (new file)" 
echo "[zram0]"
echo "zram-size = ram / 2"
sudo vim /etc/systemd/zram-generator.conf

# Restart daemon
sudo systemctl daemon-reload
sudo systemctl start /dev/zram0

echo "DONE! Reboot now and check with free -h the ZRAM installation."
