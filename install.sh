#!/usr/bin/env bash

LENOVO_FAN_PROC=/proc/acpi/ibm/fan
SYSTEMD_LIB_DIR=/lib/systemd/system
SERVICE_NAME=lenovo-fan-control
SERVICE_FILE="${SERVICE_NAME}.service"
SERVICE_FILE_FULL="${SYSTEMD_LIB_DIR}/${SERVICE_FILE}"
SERVICE_SCRIPT=$(realpath ./adjust_fan.sh)
CORE_TEMP_SCRIPT=./core_temp.sh

# Must run as root
if [ "$EUID" -eq 0 ]; then
  echo "[+] Running as [$USER]"
else
  echo "[-] Running as [$USER] Please run as root"
  exit 1
fi

# Test that we can read the core temperature
if TEMP=$($CORE_TEMP_SCRIPT); then
  echo "[+] Able to read core temperature [${TEMP}°]"
else
  echo "[-] Unble to read core temperature"
  exit 1
fi

# Test that the script exists where expected
if [ -f "$SERVICE_SCRIPT" ]; then
  echo "[+] Fan control script [$SERVICE_SCRIPT] found"
else
  echo "[-] Fan control script [$SERVICE_SCRIPT] not found"
  exit 1
fi

# The fan control process must exist
if [ -f "$LENOVO_FAN_PROC" ]; then
  echo "[+] Fan control process [$LENOVO_FAN_PROC] found"
else
  echo "[-] The fan control process [$LENOVO_FAN_PROC] does not exist, is this a Lenovo machine?"
  exit 1
fi

# Test that systemd filesystem exists
if [ -d "$SYSTEMD_LIB_DIR" ]; then
  echo "[+] Systemd path [$SYSTEMD_LIB_DIR] found"
else
  echo "Systemd directory [$SYSTEMD_LIB_DIR] not found :("
  exit 1
fi

# Test fan control
if echo "level auto" > "$LENOVO_FAN_PROC"; then
  echo "[+] Fan control test successful"
else
  echo "[+] Unable to control fan"
  exit 1
fi

# Create service file
cat > "$SERVICE_FILE_FULL" <<- EOF
[Unit]
Description=A simple fan control for lenovo

[Install]
WantedBy=multi-user.target

[Service]
Type=simple
Restart=always
RestartSec=1
ExecStart=$SERVICE_SCRIPT
EOF

# Test if the service file exists
if [ -f "$SERVICE_FILE_FULL" ]; then
  echo "[+] Service file [$SERVICE_FILE_FULL] created"
else
  echo "[-] Unable to create service file [$SERVICE_FILE_FULL]"
  exit 1
fi

# Test that the service file looks right
if [ "$(wc -l < $SERVICE_FILE_FULL)" -eq 11 ] && [ "$(grep 'ExecStart' $SERVICE_FILE_FULL -c)" -eq 1 ]; then
  echo "[+] Service file tested"
else
  echo "[-] There is a problem with the service file"
  exit 1
fi

systemctl daemon-reload
systemctl enable "$SERVICE_FILE"
systemctl start "$SERVICE_FILE"
service "$SERVICE_NAME" status
