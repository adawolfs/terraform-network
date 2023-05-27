# Terraform Network

Terraform Network Setup on Google Cloud using StrongSwan as VPN solution

## Teck Stack
- Google Cloud Platform
- Terraform
- StrongSwan
- pfSense
- Suricata

## Topology

The proposed topology implements two VPC, an Intranet and a DMZ, the Intranet deploys a domain server and a file server while the DMZ deploys an http server that is public accessible through a Load Balancer

Each network is monitored by IPS/IDS to analyze traffic and apply rules on it

### Conceptual diagrams
``` mermaid
graph TB
  subgraph VPC_Network
    subgraph Nginx_Server
      Nginx[Nginx]
    end
    subgraph VPN_Gateway
      VPN[VPN Gateway]
    end
    subgraph Load_Balancer
      LB[Load Balancer]
    end
  end
  Internet-->|Public IP|VPN
  VPN-->Nginx
  Internet-->|Public IP|LB
  LB-->Nginx
```
``` mermaid
graph TD
    subgraph DMZ_Network
      A[VPC Network DMZ]
      B[Subnet 10.0.1.0/24]
      C[VM Instance: Nginx Server]
      D[VPN Gateway]
    end
    subgraph INFRA_Network
      J[VPC Network Intra]
      K[Subnet 10.0.2.0/24]
      L[Domain Server]
    end
    A -- contains --> B
    J -- contains --> K

    B -- hosts --> C
    B -- hosts --> D
    K -- hosts --> D
    K -- hosts --> L
    F[Cloud NAT] -- allows to access internet --> C
    D -- reachable via --> H[Internet]
    F -- reachable via --> H
    I[Load Balancer] -- directs traffic --> C
    H -- reachable via --> I

```