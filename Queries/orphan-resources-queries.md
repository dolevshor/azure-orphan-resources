# Azure Orphaned Resources - Queries

Here you can find all the orphan resources queries that build this Workbook.

- [Compute](#compute)
  - [App Service Plans](#app-service-plans)
  - [Availability Set](#availability-set)
- [Storage](#storage)
  - [Managed Disks](#managed-disks)
- [Database](#database)
  - [SQL elastic pool](#sql-elastic-pool)
- [Networking](#networking)
  - [Public IPs](#public-ips)
  - [Network Interfaces](#network-interfaces)
  - [Network Security Groups](#network-security-groups)
  - [Route Tables](#route-tables)
  - [Load Balancers](#load-balancers)
  - [Front Door WAF Policy](#front-door-waf-policy)
  - [Traffic Manager Profiles](#traffic-manager-profiles)
  - [Application Gateways](#application-gateways)
  - [Virtual Networks](#virtual-networks)
  - [Subnets](#subnets)
  - [NAT Gateways](#nat-gateways)
  - [IP Groups](#ip-groups)
  - [Private DNS zones](#private-dns-zones)
  - [Private Endpoints](#private-endpoints)
  - [Virtual Network Gateways](#virtual-network-gateways)
- - [DDoS Protection](#ddos-protections)
- [Others](#others)
  - [Resource Groups](#resource-groups)
  - [API Connections](#api-connections)
  - [Certificates](#certificates)

## Compute

#### App Service Plans

[App Service plans](https://learn.microsoft.com/en-us/azure/app-service/overview-hosting-plans) without hosting Apps.

```kql
resources
| where type =~ "microsoft.web/serverfarms"
| where properties.numberOfSites == 0
| extend Details = pack_all()
| project subscriptionId, Resource=id, resourceGroup, location, Sku=sku.name, Tier=sku.tier, tags ,Details
```

#### Availability Set

[Availability Sets](https://learn.microsoft.com/en-us/azure/virtual-machines/availability-set-overview) that not associated to any Virtual Machine (VM) or Virtual Machine Scale Set (VMSS) and not related to Azure Site Recovery.

```kql
Resources
| where type =~ 'Microsoft.Compute/availabilitySets'
| where properties.virtualMachines == "[]"
| where not(name endswith "-asr")
| extend Details = pack_all()
| project subscriptionId, Resource=id, resourceGroup, location, tags, Details
```

> **_Note:_** Azure Site Recovery (aka: ASR) Availability Set are excluded from the orphaned resource query.

> <sub> 1) Enable replication process for VM with Availability Set created additional Availability Set that end with the suffix *"-asr"*.<br/>

## Storage

#### Managed Disks

[Managed Disks](https://learn.microsoft.com/en-us/azure/virtual-machines/managed-disks-overview) with 'Unattached' state and not related to Azure Site Recovery.

```kql
Resources
| where type has "microsoft.compute/disks"
| extend diskState = tostring(properties.diskState)
| where (managedBy == "" and diskState != 'ActiveSAS') or (diskState == 'Unattached' and diskState != 'ActiveSAS')
| where not(name endswith "-ASRReplica" or name startswith "ms-asr-" or name startswith "asrseeddisk-")
| where (tags !contains "kubernetes.io-created-for-pvc") and tags !contains "ASR-ReplicaDisk" and tags !contains "asrseeddisk" and tags !contains "RSVaultBackup"
| extend Details = pack_all()
| project subscriptionId, Resource=id, resourceGroup, location, diskType=sku.name, diskSizeGB=properties.diskSizeGB, timeCreated=properties.timeCreated, tags, Details
```

> **_Note:_** Azure Site Recovery (aka: ASR) managed disks are excluded from the orphaned resource query.

> <sub> 1) Enable replication process created a temporary *'Unattached'* managed disk that begins with the prefix *"ms-asr-"*.<br/>
        2) When the replication start, a new managed disk that begin with the suffix *"-ASRReplica"* created in *'ActiveSAS'* state.<br/>
        3) When replicated on-premises VMware VMs and physicall servers to managed disks in Azure, these logs are used to create recovery points on Azure-managed disks that have prefix of *"asrseeddisk-"*.</sub>

> **_Note:_** AKS Persistent Volume Claim (aka: PVC) managed disks are excluded from the orphaned resource query.

## Database

#### SQL elastic pool

[SQL elastic pool](https://learn.microsoft.com/en-us/azure/azure-sql/database/elastic-pool-overview) without databases.

```kql
resources
| where type =~ 'microsoft.sql/servers/elasticpools'
| project elasticPoolId = tolower(id), Resource = id, resourceGroup, location, subscriptionId, tags, properties, Details = pack_all()
| join kind=leftouter (resources
| where type =~ 'Microsoft.Sql/servers/databases'
| project id, properties
| extend elasticPoolId = tolower(properties.elasticPoolId)) on elasticPoolId
| summarize databaseCount = countif(id != '') by Resource, resourceGroup, location, subscriptionId, tostring(tags), tostring(Details)
| where databaseCount == 0
| project-away databaseCount
```

## Networking

#### Public IPs

[Public IPs](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/public-ip-addresses) that are not attached to any resource (VM, NAT Gateway, Load Balancer, Application Gateway, Public IP Prefix, etc.).

```kql
Resources
| where type == "microsoft.network/publicipaddresses"
| where properties.ipConfiguration == "" and properties.natGateway == "" and properties.publicIPPrefix == ""
| extend Details = pack_all()
| project subscriptionId, Resource=id, resourceGroup, location, Type=tostring(sku.name), AllocationMethod=tostring(properties.publicIPAllocationMethod), tags, Details
```

#### Network Interfaces

[Network Interfaces](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/private-ip-addresses) that are not attached to any resource.

```kql
Resources
| where type has "microsoft.network/networkinterfaces"
| where isnull(properties.privateEndpoint)
| where isnull(properties.privateLinkService)
| where properties.hostedWorkloads == "[]"
| where properties !has 'virtualmachine'
| extend Details = pack_all()
| project subscriptionId, Resource=id, resourceGroup, location, kind, tags, Details
```

> **_Note:_** Azure Netapp Volumes are excluded from the orphaned resource query.

> <sub> When creating a _Volume_ in _Azure Netapp Account_: <br/>
        1) A delegated subnet created in the virtaul network (vNET). <br/>
        2) A Network Interface created in the subnet with the fields: <br/><sub>
&nbsp;&nbsp;&nbsp;&nbsp;- "linkedResourceType": "Microsoft.Netapp/volumes" <br/>
&nbsp;&nbsp;&nbsp;&nbsp;- "hostedWorkloads": ["/subscriptions/<_**SubscriptionId**_>/resourceGroups/<_**RG-Name**_>/providers/Microsoft.NetApp/netAppAccounts/<_**NetAppAccount-Name**_>/capacityPools/<NetAppCapacityPool-Name>/volumes/<_**NetAppVolume-Name**_>" <br/>
&nbsp;&nbsp;&nbsp;&nbsp;- "bareMetalServer": { "id": "/subscriptions/<_**SubscriptionId**_>/resourceGroups/<_**RG-Name**_>/providers/Microsoft.Network/bareMetalServers/<_**baremetalTenant_svm_ID**_>"}</sub></sub>

#### Network Security Groups

[Network Security Group](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/private-ip-addresses) (NSGs)] that are not attached to any network interface or subnet.

```kql
Resources
| where type == "microsoft.network/networksecuritygroups" and isnull(properties.networkInterfaces) and isnull(properties.subnets)
| extend Details = pack_all()
| project subscriptionId, Resource=id, resourceGroup, location, tags, Details
```

#### Route Tables

[Route Tables](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-networks-udr-overview) that not attached to any subnet.

```kql
resources
| where type == "microsoft.network/routetables"
| where isnull(properties.subnets)
| extend Details = pack_all()
| project subscriptionId, Resource=id, resourceGroup, location, tags, Details
```

#### Load Balancers

[Load Balancers](https://learn.microsoft.com/en-us/azure/load-balancer/load-balancer-overview) with empty backend address pools.

```kql
resources
| where type == "microsoft.network/loadbalancers"
| where properties.backendAddressPools == "[]"
| extend Details = pack_all()
| project subscriptionId, Resource=id, resourceGroup, location, Type=tostring(sku.name), tags, Details
```

#### Front Door WAF Policy

[Front Door WAF Policy](https://learn.microsoft.com/en-us/azure/web-application-firewall/afds/afds-overview) without associations. (Frontend Endpoint Links, Security Policy Links)

```kql
resources
| where type == "microsoft.network/frontdoorwebapplicationfirewallpolicies"
| where properties.frontendEndpointLinks== "[]" and properties.securityPolicyLinks == "[]"
| extend Details = pack_all()
| project Resource=id, resourceGroup, location, subscriptionId, Sku=sku.name, tags, Details
```

#### Traffic Manager Profiles

[Traffic Manager](https://learn.microsoft.com/en-us/azure/traffic-manager/traffic-manager-overview) without endpoints.

```kql
resources
| where type == "microsoft.network/trafficmanagerprofiles"
| where properties.endpoints == "[]"
| extend Details = pack_all()
| project subscriptionId, Resource=id, resourceGroup, location, tags, Details
```

#### Application Gateways

[Application Gateways](https://learn.microsoft.com/azure/application-gateway/overview) without backend targets. (in backend pools)

```kql
resources
| where type =~ 'microsoft.network/applicationgateways'
| extend backendPoolsCount = array_length(properties.backendAddressPools),SKUName= tostring(properties.sku.name), SKUTier= tostring(properties.sku.tier),SKUCapacity=properties.sku.capacity,backendPools=properties.backendAddressPools , AppGwId = tostring(id)
| project AppGwId, resourceGroup, location, subscriptionId, tags, name, SKUName, SKUTier, SKUCapacity
| join (
    resources
    | where type =~ 'microsoft.network/applicationgateways'
    | mvexpand backendPools = properties.backendAddressPools
    | extend backendIPCount = array_length(backendPools.properties.backendIPConfigurations)
    | extend backendAddressesCount = array_length(backendPools.properties.backendAddresses)
    | extend backendPoolName  = backendPools.properties.backendAddressPools.name
    | extend AppGwId = tostring(id)
    | summarize backendIPCount = sum(backendIPCount) ,backendAddressesCount=sum(backendAddressesCount) by AppGwId
) on AppGwId
| project-away AppGwId1
| where  (backendIPCount == 0 or isempty(backendIPCount)) and (backendAddressesCount==0 or isempty(backendAddressesCount))
| extend Details = pack_all()
| project subscriptionId, Resource=AppGwId, resourceGroup, location, SKUTier, SKUCapacity, tags, Details
```

#### Virtual Networks

[Virtual Networks](https://learn.microsoft.com/azure/virtual-network/virtual-networks-overview) (VNETs) without subnets.

```kql
resources
| where type == "microsoft.network/virtualnetworks"
| where properties.subnets == "[]"
| extend Details = pack_all()
| project subscriptionId, Resource=id, resourceGroup, location, tags, Details
```

#### Subnets

Subnets without Connected Devices or Delegation. (Empty Subnets)

```kql
resources
| where type =~ "microsoft.network/virtualnetworks"
| extend subnet = properties.subnets
| mv-expand subnet
| extend ipConfigurations = subnet.properties.ipConfigurations
| extend delegations = subnet.properties.delegations
| extend applicationGatewayIPConfigurations = subnet.properties.applicationGatewayIPConfigurations
| where isnull(ipConfigurations) and delegations == "[]" and isnull(applicationGatewayIPConfigurations) 
| extend SubnetName = subnet.name, SubnetId = subnet.id
| extend Details = pack_all()
| project subscriptionId, SubnetName, vNetId=id, SubnetId ,resourceGroup, location, vNetName=name, Details
```

#### NAT Gateways

[NAT Gateways](https://learn.microsoft.com/azure/nat-gateway/nat-overview) that not attached to any subnet.

```kql
resources
| where type == "microsoft.network/natgateways"
| where isnull(properties.subnets)
| extend Details = pack_all()
| project subscriptionId, Resource=id, resourceGroup, location, Sku=tostring(sku.name), Tier=tostring(sku.tier), tags, Details
```

#### IP Groups

[IP Groups](https://learn.microsoft.com/azure/firewall/ip-groups) that not attached to any Azure Firewall.

```kql
resources
| where type == "microsoft.network/ipgroups"
| where properties.firewalls == "[]" and properties.firewallPolicies == "[]"
| extend Details = pack_all()
| project subscriptionId, Resource=id, resourceGroup, location, tags, Details
```

#### Private DNS zones

[Private DNS zones](https://learn.microsoft.com/azure/dns/private-dns-privatednszone) without [Virtual Network Links](https://learn.microsoft.com/en-us/azure/dns/private-dns-virtual-network-links).

```kql
resources
| where type == "microsoft.network/privatednszones"
| where properties.numberOfVirtualNetworkLinks == 0
| extend Details = pack_all()
| project subscriptionId, Resource=id, resourceGroup, location, NumberOfRecordSets=properties.numberOfRecordSets, tags, Details
```

#### Private Endpoints

[Private Endpoints](https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-overview) that are not connected to any resource.

```kql
resources
| where type =~ "microsoft.network/privateendpoints"
| extend connection = iff(array_length(properties.manualPrivateLinkServiceConnections) > 0, properties.manualPrivateLinkServiceConnections[0], properties.privateLinkServiceConnections[0])
| extend subnetId = properties.subnet.id
| extend subnetName = tostring(split(subnetId, "/")[-1])
| extend subnetIdSplit = split(subnetId, "/")
| extend vnetId = strcat_array(array_slice(subnetIdSplit,0,8), "/")
| extend vnetName = tostring(split(vnetId, "/")[-1])
| extend serviceId = tostring(connection.properties.privateLinkServiceId)
| extend serviceIdSplit = split(serviceId, "/")
| extend serviceName = tostring(serviceIdSplit[8])
| extend serviceTypeEnum = iff(isnotnull(serviceIdSplit[6]), tolower(strcat(serviceIdSplit[6], "/", serviceIdSplit[7])), "microsoft.network/privatelinkservices")
| extend stateEnum = tostring(connection.properties.privateLinkServiceConnectionState.status)
| extend groupIds = tostring(connection.properties.groupIds[0])
| where stateEnum == "Disconnected"
| extend Details = pack_all()
| project subscriptionId, Resource=id, resourceGroup, location, serviceName, serviceTypeEnum, groupIds, vnetId, vnetName, subnetId, subnetName, tags, Details
```

#### Virtual Network Gateways

[Virtual Network Gateways](https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpngateways) without Point-to-site configuration or Connections.

```kql
resources
| where type =~ "microsoft.network/virtualnetworkgateways"
| extend Details = pack_all()
| extend SKU = tostring(properties.sku.name)
| extend Tier = tostring(properties.sku.tier)
| extend GatewayType = tostring(properties.gatewayType)
| extend vpnClientConfiguration = properties.vpnClientConfiguration
| extend Resource = id
| join kind=leftouter (
    resources
    | where type =~ "microsoft.network/connections"
    | mv-expand Resource = pack_array(properties.virtualNetworkGateway1.id, properties.virtualNetworkGateway2.id) to typeof(string)
    | project Resource, connectionId = id, ConnectionProperties=properties
    ) on Resource                  
| where isempty(vpnClientConfiguration) and isempty(connectionId)
| project subscriptionId, Resource, resourceGroup, location, GatewayType, SKU, Tier, tags, Details
```

#### DDoS Protections

[DDoS protection](https://learn.microsoft.com/en-us/azure/ddos-protection/ddos-protection-overview) without protected resources. (=without Virtual Networks accosiated)

```kql
resources
| where type == "microsoft.network/ddosprotectionplans"
| where isnull(properties.virtualNetworks)
| extend Details = pack_all()
| project subscriptionId, Resource=id, resourceGroup, location, tags, Details
```

## Others

#### Resource Groups

[Resource Groups](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/overview) without resources (including hidden types resources).

```kql
ResourceContainers
 | where type == "microsoft.resources/subscriptions/resourcegroups"
 | extend rgAndSub = strcat(resourceGroup, "--", subscriptionId)
 | join kind=leftouter (
     Resources
     | extend rgAndSub = strcat(resourceGroup, "--", subscriptionId)
     | summarize count() by rgAndSub
 ) on rgAndSub
 | where isnull(count_)
 | extend Details = pack_all()
 | project subscriptionId, Resource=id, resourceGroup, location, tags ,Details
```

#### API Connections

[API Connections](https://learn.microsoft.com/en-us/entra/external-id/api-connectors-overview) that not related to any Logic App.

```kql
resources
| where type =~ 'Microsoft.Web/connections'
| project subscriptionId, Resource = id , apiName = name, resourceGroup, tags, location
| join kind = leftouter (
    resources
    | where type == 'microsoft.logic/workflows'
    | extend resourceGroup, location, subscriptionId, properties
    | extend var_json = properties["parameters"]["$connections"]["value"]
	| mvexpand var_connection = var_json
    | where notnull(var_connection)
    | extend connectionId = extract("connectionId\":\"(.*?)\"", 1, tostring(var_connection))
    | project connectionId, name
    )
    on $left.Resource == $right.connectionId
| where connectionId == ""
| extend Details = pack_all()
| project subscriptionId, Resource, resourceGroup, location, tags, Details
```

#### Certificates

Expired certificates.

```kql
resources
| where type == 'microsoft.web/certificates'
| extend expiresOn = todatetime(properties.expirationDate)
| where expiresOn <= now()
| extend Details = pack_all()
| project subscriptionId, Resource=id, resourceGroup, location, Details
```
