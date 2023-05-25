# Terraform Network

Terraform Network Setup on Google Cloud using StrongSwan as VPN solution

## Teck Stack
- Google Cloud Platform
  - Compute Instances
  - Virtual Private Cloud
  - Load Balancer
  - Public IP
- Terraform
- StrongSwan

## Conceptual diagrams
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
    A[VPC Network] -- contains --> B[Subnet 10.0.1.0/24]
    B -- hosts --> C[VM Instance: Nginx Server]
    B -- hosts --> D[VPN Gateway]
    F[Cloud NAT] -- allows to access internet --> C
    H[Internet] -- reachable via --> D
    H -- reachable via --> F
    I[Load Balancer] -- directs traffic --> C
    H -- reachable via --> I

```