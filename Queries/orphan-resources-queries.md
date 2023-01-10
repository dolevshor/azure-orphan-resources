# Azure Orphan Resources - Queries

Here you can find all the orphan resources queries that build this Workbook.

#### Disks

```
Resources
| where type has "microsoft.compute/disks"
| extend diskState = tostring(properties.diskState)
| where managedBy == ""
| where not(name endswith "-ASRReplica" or name startswith "ms-asr-")
| extend Details = pack_all()
| project id, resourceGroup, diskState, sku.name, properties.diskSizeGB, location, tags, subscriptionId, Details
```

> **_Note:_** Azure Site Recovery (aka: ASR) managed disks are excluded from the orphaned resource query.

> <sub> 1) Enable replication process created a temporary *'Unattached'* managed disk that begins with the prefix *"ms-asr-"*.<br/>
        2) When the replication start, a new managed disk that begin with the suffix *"-ASRReplica"* created in *'ActiveSAS'* state.</sub>

#### Network Interfaces
```
Resources
| where type has "microsoft.network/networkinterfaces"
| where isnull(properties.privateEndpoint)
| where isnull(properties.privateLinkService)
| where properties.hostedWorkloads == "[]"
| where properties !has 'virtualmachine'
| extend Details = pack_all()
| project Resource=id, resourceGroup, location, tags, subscriptionId, Details
```

> **_Note:_** Azure Netapp Volumes are excluded from the orphaned resource query.

> <sub> When creating a _Volume_ in _Azure Netapp Account_: <br/>
        1) A delegated subnet created in the virtaul network (vNET). <br/>
        2) A Network Interface created in the subnet with the fields: <br/><sub>
&nbsp;&nbsp;&nbsp;&nbsp;- "linkedResourceType": "Microsoft.Netapp/volumes" <br/>
&nbsp;&nbsp;&nbsp;&nbsp;- "hostedWorkloads": ["/subscriptions/<_**SubscriptionId**_>/resourceGroups/<_**RG-Name**_>/providers/Microsoft.NetApp/netAppAccounts/<_**NetAppAccount-Name**_>/capacityPools/<NetAppCapacityPool-Name>/volumes/<_**NetAppVolume-Name**_>" <br/>
&nbsp;&nbsp;&nbsp;&nbsp;- "bareMetalServer": { "id": "/subscriptions/<_**SubscriptionId**_>/resourceGroups/<_**RG-Name**_>/providers/Microsoft.Network/bareMetalServers/<_**baremetalTenant_svm_ID**_>"}</sub></sub>


#### Public IPs
```
Resources
| where type == "microsoft.network/publicipaddresses"
| where properties.ipConfiguration == "" and properties.natGateway == ""
| extend Details = pack_all()
| project Resource=id, resourceGroup, location, subscriptionId, sku.name, tags ,Details
```

#### Resource Groups
```
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
 | project subscriptionId, Resource=id, location, tags ,Details
```

#### Network Security Groups (NSGs)
```
Resources
| where type == "microsoft.network/networksecuritygroups" and isnull(properties.networkInterfaces) and isnull(properties.subnets)
| extend Details = pack_all()
| project subscriptionId, Resource=id, resourceGroup, location, tags, Details
```

#### Availability Set
```
Resources
| where type =~ 'Microsoft.Compute/availabilitySets'
| where properties.virtualMachines == "[]"
| extend Details = pack_all()
| project subscriptionId, Resource=id, resourceGroup, location, tags, Details
```

#### Route Tables
```
resources
| where type == "microsoft.network/routetables"
| where isnull(properties.subnets)
| extend Details = pack_all()
| project subscriptionId, Resource=id, resourceGroup, location, tags, Details
```

#### Load Balancers
```
resources
| where type == "microsoft.network/loadbalancers"
| where properties.backendAddressPools == "[]"
| extend Details = pack_all()
| project subscriptionId, Resource=id, resourceGroup, location, tags, Details
```

#### App Service Plans
```
resources
| where type =~ "microsoft.web/serverfarms"
| where properties.numberOfSites == 0
| extend Details = pack_all()
| project Resource=id, resourceGroup, location, subscriptionId, Sku=sku.name, Tier=sku.tier, tags ,Details
```
        
#### Front Door WAF Policy
```
resources
| where type == "microsoft.network/frontdoorwebapplicationfirewallpolicies"
| where properties.frontendEndpointLinks== "[]" and properties.securityPolicyLinks == "[]"
| extend Details = pack_all()
| project Resource=id, resourceGroup, location, subscriptionId, Sku=sku.name, tags, Details
```
        
#### Application Gateway WAF Policy        
```        
resources
| where type == "microsoft.network/applicationgatewaywebapplicationfirewallpolicies"
| where properties.applicationGateways == ""
| extend Details = pack_all()
| project Resource=id, resourceGroup, location, subscriptionId,tags, Details
```
        
#### Traffic Manager Profiles
```
resources
| where type == "microsoft.network/trafficmanagerprofiles"
| where properties.endpoints == "[]"
| extend Details = pack_all()
| project Resource=id, resourceGroup, location, subscriptionId, tags, Details
```
        
#### Snapshots
```
resources
| where type == 'microsoft.compute/snapshots'
| extend TimeCreated = properties.timeCreated
| where TimeCreated < ago(30d)
| extend Details = pack_all()
| project Resource=id, resourceGroup, location, TimeCreated ,subscriptionId, tags, Details
```
                              
#### VM
```
resources
| where type == 'microsoft.compute/virtualmachines'
| extend vmstatus = properties.extended.instanceView.powerState.displayStatus
| where vmstatus != 'VM running'
| summarize count(type)
```
                              
#### Alerts
```
resources
| where type contains 'microsoft.insights/scheduledqueryrules' or type contains 'microsoft.insights/activitylogalerts' or type contains 'microsoft.insights/metricalerts'
| extend alertstatus = properties.enabled
| where alertstatus == 'false'
| summarize count(name)
```
                              
#### LB
```
resources
| where type == "microsoft.network/loadbalancers"
| where properties.loadBalancingRules == "[]"
| extend Details = pack_all()
| project Resource=id, resourceGroup, location, subscriptionId, tags, Details
```
                              
#### Certificate Expiration(Defined 30 days as an example)
```
resources
| where type == 'microsoft.web/certificates'
| extend expiry = todatetime(properties.expirationDate)
| where expiry between (now().. ago(-30d))
| project CertName=properties.subjectName, expiry
```
                              
#### Virtual Networks without Subnet
```
resources
| where type == "microsoft.network/virtualnetworks"
| where properties.subnets == "[]"
| extend Details = pack_all()
| project Resource=id, resourceGroup, location, subscriptionId, tags, Details
```
                              
#### Unassociated network security groups
```
Resources
| where type =~ 'microsoft.network/networksecuritygroups' and isnull(properties.networkInterfaces) and isnull(properties.subnets)
| project name, resourceGroup
| project Resource=id, resourceGroup, location, subscriptionId, tags, Details
```
