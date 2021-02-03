#!/bin/bash
cp prometheus-openstack-exporter /usr/local/bin

#https://github.com/prometheus/openstack_exporter:openstack_exporter/releases/download/v0.19.0/openstack_exporter-0.19.0.linux-amd64.tar.gz

# create user
useradd --no-create-home --shell /bin/false openstack_exporter

chown openstack_exporter:openstack_exporter /usr/local/bin/prometheus-openstack-exporter

echo '[Unit]
Description=openstack exporter
Wants=network-online.target
After=network-online.target

[Service]
User=openstack_exporter
Group=openstack_exporter
Type=simple
ExecStart=/usr/local/bin/prometheus-openstack-exporter  /etc/prometheus/prometheus-openstack-exporter.yaml

[Install]
WantedBy=multi-user.target' > /etc/systemd/system/openstack_exporter.service

# enable openstack_exporter:openstack_exporter in systemctl
systemctl daemon-reload
systemctl start openstack_exporter
systemctl enable openstack_exporter



echo "Setup complete.
Add the following lines to /etc/prometheus/prometheus.yml:
  - job_name: 'node_exporter'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9183']
"
