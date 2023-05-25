#!/bin/bash

## Exports
export VPN_SERVER_IP=`cat /tmp/vpn-server-ip`
export VPN_USER="stronguser"
export VPN_PASSWORD="superstronguser"

## Enable EPEL repository
sudo dnf config-manager --set-enabled crb
sudo dnf install -y epel-release epel-next-release
sudo dnf install -y strongswan strongswan-sqlite

## Enable IP forwarding
sudo sysctl -w net.ipv4.ip_forward=1
sudo sysctl -w net.ipv6.conf.all.forwarding=1

## Configure firewall
sudo firewall-cmd --permanent --add-service="ipsec"
sudo firewall-cmd --permanent --add-port=4500/udp
sudo firewall-cmd --permanent --add-masquerade
sudo firewall-cmd --reload

## Configure strongSwan
sudo cp /etc/strongswan/ipsec.conf{,.orig}
sudo cp /etc/strongswan/ipsec.secrets{,.orig}
sudo cp /etc/strongswan/strongswan.conf{,.orig}

cat << EOF | sudo tee /etc/strongswan/swanctl/swanctl.conf
connections {

   rw {
      local_addrs  = 192.168.0.1

      local {
         auth = pubkey
         certs = /etc/letsencrypt/live/${VPN_SERVER_IP}/fullchain.pem
         id = ${VPN_SERVER_IP}
      }
      remote {
         auth = psk
         id = roadwarrior
      }
      children {
         net {
            local_ts  = 10.1.0.0/16 

            updown = /usr/local/libexec/ipsec/_updown iptables
            esp_proposals = aes128gcm128-x25519
         }
      }
      version = 2
      proposals = aes128-sha256-x25519
   }
}


secrets {
   ike-1 {
      id-1 = ${VPN_SERVER_IP}
      secret = 0x45a30759df97dc26a15b88ff
   }
   ike-2 {
      id-2 = roadwarrior
      secret = "supersecure"
   }
   ike-3 {
      id-3a =  ${VPN_SERVER_IP}
      id-3b = roadwarrior
      secret = 0sv+NkxY9LLZvwj4qCC2o/gGrWDF2d21jL
   }
   ike-4 {
      secret = 'My "home" is my "castle"!'
   }
   ike-5 {
     id-5 = 192.168.0.1
     secret = "Andi's home"
   }
}
EOF


cat << EOF  | sudo tee /etc/strongswan/ipsec.secrets
: RSA "/etc/letsencrypt/live/${VPN_SERVER_IP}/privkey.pem"
EOF

cat << EOF | sudo tee -a /etc/strongswan/strongswan.conf
EOF

## Configure VPN users
cat << EOF  | sudo tee -a /etc/strongswan/ipsec.d/passwd
${VPN_USER} : EAP "${VPN_PASSWORD}"
EOF

## Configure certificates
sudo mkdir -p /etc/letsencrypt/live/${VPN_SERVER_IP}
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/letsencrypt/live/${VPN_SERVER_IP}/privkey.pem -out /etc/letsencrypt/live/${VPN_SERVER_IP}/fullchain.pem -subj "/C=US/ST=CA/L=San Francisco/O=IT/CN=${VPN_SERVER_IP}"

## Restart strongSwan
sudo systemctl restart strongswan

## Enable strongSwan
sudo systemctl enable strongswan

## Configure SELinux
sudo setsebool -P httpd_can_network_connect 1
sudo setsebool -P openvpn_can_network_connect 1
sudo setsebool -P openvpn_enable_homedirs 1
sudo setsebool -P openvpn_run_unconfined 1
