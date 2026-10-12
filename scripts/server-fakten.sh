#!/bin/sh
# Sammelt Fakten über den Firmenserver für die Planung von tosto.
#
# Nur lesend: ändert nichts, braucht kein root, gibt keine Passwörter oder
# Schlüssel aus. Aufruf auf dem Server (als normaler Benutzer):
#
#   sh server-fakten.sh > server-fakten.txt
#
# Die Ausgabe enthält IP-Adressen und Rechnernamen. Sie gehört in den Ordner
# lokal/ von tosto (nicht im Git), nie in eine Datei, die committet wird.

abschnitt() { printf '\n===== %s =====\n' "$1"; }
probier() { "$@" 2>&1 || true; }

abschnitt "System"
probier cat /etc/os-release
probier uname -r
probier hostnamectl
probier uptime

abschnitt "Hardware"
probier nproc
probier free -h
probier df -h / /var /home
probier lscpu | grep -E 'Model name|Virtualization'

abschnitt "Netzwerk"
probier ip -brief address
probier ip route
probier cat /etc/resolv.conf

abschnitt "Belegte Ports (FreeIPA belegt u. a. 80/443)"
probier ss -tln

abschnitt "FreeIPA"
probier grep -E '^(domain|realm|server|host)' /etc/ipa/default.conf
probier ipa --version

abschnitt "Python"
for p in python3 python3.11 python3.12 python3.13; do
  command -v "$p" >/dev/null 2>&1 && printf '%s: %s\n' "$p" "$("$p" --version 2>&1)"
done

abschnitt "Container und Virtualisierung"
probier podman --version
probier systemctl is-active libvirtd
probier virsh --version
probier rpm -q cockpit cockpit-machines

abschnitt "Webserver"
for d in httpd nginx caddy; do printf '%s: %s\n' "$d" "$(systemctl is-active "$d" 2>&1)"; done

abschnitt "Sicherheit"
probier getenforce
probier systemctl is-active firewalld
probier firewall-cmd --list-all

abschnitt "Drucker (USB)"
probier lsusb
probier ls -l /dev/usb/
probier id

abschnitt "Zeit"
probier timedatectl

abschnitt "Updates"
probier dnf check-update --quiet | tail -n 5
