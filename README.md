# Azure Orphaned Resources v2.0

The _'Azure Orphaned Resources Workbook'_ centralize orphaned resources in Azure environments.

The purpose of this workbook is to provide an overview of your orphaned resources, enabling you to enhance eficiency by:
- Saving money
- Prevent misconfiguration
- Simplify operational

![image](https://github.com/dolevshor/azure-orphan-resources/assets/69309933/a9832d0a-ac34-4797-80d9-b639d5e58606)

![image](https://github.com/dolevshor/azure-orphan-resources/assets/69309933/ecb354eb-b63c-439a-a3d1-cf832e194278)

![image](https://github.com/dolevshor/azure-orphan-resources/assets/69309933/996ccac4-c7d9-4511-ab6e-a5d9361c3fb0)


> All the information presented in this Workbook is based on Azure Resource Graph queries.
> <img src="https://user-images.githubusercontent.com/69309933/172938464-38b08c8e-0d4d-493b-aa8f-954189556d7a.png" width="20" height="20">

Types of resources the workbook covers:

- Compute
  - App Service Plans
  - Availability Set
- Storage
  - Disks
- Database
  - SQL Elastic Pools
- Networking
  - Public IPs
  - Network Interfaces
  - Network Security Groups
  - Route Tables
  - Load Balancers
  - Front Door WAF Policy
  - Traffic Manager Profiles
  - Application Gateways
  - Virtual Networks
  - Subnets
  - NAT Gateways
  - IP Groups
  - Private DNS zones
- Others
  - Resource Groups
  - API Connections
  - Certificates

## How to use it?
Importing this Workbook to your Azure environment is quite simple.

Follow this steps to use the Workbook:

- Login to [Azure Portal](https://portal.azure.com/) <img src="https://user-images.githubusercontent.com/69309933/172941966-9e030031-6ccb-4ebf-bd2b-04bb623e5ff7.png" width="20" height="20">
- Go to _'Azure Workbooks'_

<img src="https://user-images.githubusercontent.com/69309933/172806635-14051976-328e-4623-96ab-0dd6a7bc7817.png" width="350">

- Click on _'+ Create'_

<img src="https://user-images.githubusercontent.com/69309933/172807465-cced3466-0669-423b-87b3-8fa70fdbf1d1.png" width="350">

- Click on _'+ New'_

<img src="https://user-images.githubusercontent.com/69309933/172807547-52d790ce-7852-4b4b-a81f-81e8b7fac26e.png" width="350"> 

- Open the Advanced Editor using the _'</>'_ button on the toolbar

<img src="https://user-images.githubusercontent.com/69309933/172807673-dfc63741-0c40-47c0-ab58-d39309b06e69.png" width="700"> 

- Select the _'Gallery Template'_ (step 1)
- Replace the JSON code with this JSON code [orphaned resources JSON](https://raw.githubusercontent.com/dolevshor/azure-orphan-resources/main/Workbook/Azure%20Orphaned%20Resources%20v2.0.workbook) (step 2)
  - We use the _Gallery Templaty type_ (step 1), so we need to use the _'Azure Orphaned Resources v2.0.workbook'_ and not the _'Azure Orphaned Resources v2.0.json'_.
- Click _'Apply'_ (step 3)

<img src="https://user-images.githubusercontent.com/69309933/172807762-17aec6f9-4a81-4d5b-9017-673a0ab6b26e.png" width="700"> 

- Click in the ‘Save’ button on the toolbar

<img src="https://user-images.githubusercontent.com/69309933/172807909-b4527207-343e-4861-af4e-35e1104029d1.png" width="700">  

- Select a name and where to save the Workbook:
  - Title: _'Orphaned Resources'_
  - Subscription: <_Subscription Name_>
  - Resource group: <_Resource Group Name_>
  - Location: <_Region_>
- Click _'Save'_
  
<img src="https://user-images.githubusercontent.com/69309933/172808030-3d7171c9-8b23-4f69-ab8b-7150b1459ea8.png" width="700">  

The Workbook is ready to use!
- Click on _'Workbooks'_
- Click on _'Orphaned Resources'_ Workbook.

<img src="https://user-images.githubusercontent.com/69309933/172808358-ed2fede8-42a4-42bd-9c68-3ac4d645f812.png" width="700">  

Start using the Workbook and review your orphaned resources.<br/>

(Optional) You can filter by specific subscription:

![image](https://github.com/dolevshor/azure-orphan-resources/assets/69309933/f4b11592-d101-4db1-a0d0-f962ad738c0d)





