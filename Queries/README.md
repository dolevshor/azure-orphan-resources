# Azure Orphan Resources - Queries

Here you can find all the orphan resources queries that build this Workbook.

#### Disks

```
Resources
| where type has "microsoft.compute/disks"
| extend diskState = tostring(properties.diskState)
| where managedBy == "" or diskState == 'Unattached'
| extend Details = pack_all()
| project id, resourceGroup, diskState, sku.name, properties.diskSizeGB, location, tags, subscriptionId, Details
```

#### Network Interfaces
```
Resources
| where type has "microsoft.network/networkinterfaces"
| where isnull(properties.privateEndpoint)
| where isnull(properties.privateLinkService)
| where properties !has 'virtualmachine'
| extend Details = pack_all()
| project Resource=id, resourceGroup, location, tags, subscriptionId, Details
```

#### Public IPs
```
Resources
| where type == "microsoft.network/publicipaddresses"
| where properties.ipConfiguration == ""
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
