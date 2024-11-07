# Azure Orphaned Resources v3.0

The _'Azure Orphaned Resources Workbook'_ centralize orphaned resources in Azure environments.

The purpose of this workbook is to provide an overview of your orphaned resources, enabling you to enhance eficiency by:
- Saving money
- Prevent misconfiguration
- Simplify operational

![image](https://github.com/user-attachments/assets/76ce2f92-91ff-4afc-b5c0-2246e5567a1f)

![image](https://github.com/user-attachments/assets/2d48f8c7-753f-465b-81d4-0a9c0700a645)

![image](https://github.com/user-attachments/assets/c8fb8aa4-f3ac-4053-9fd2-dc36ea3b082f)


> All the information presented in this Workbook is based on Azure Resource Graph queries.
> <img src="https://user-images.githubusercontent.com/69309933/172938464-38b08c8e-0d4d-493b-aa8f-954189556d7a.png" width="20" height="20">

## Resources covered

> [!Tip]
> 💲 This is a sign that the resource costs money

The workbook includes the following kinds of resources:

- Compute
  - App Service Plans 💲
  - Availability Set
- Storage
  - Managed Disks 💲
- Database
  - SQL Elastic Pools 💲
- Networking
  - Public IPs 💲
  - Network Interfaces
  - Network Security Groups
  - Route Tables
  - Load Balancers 💲
  - Front Door WAF Policy
  - Traffic Manager Profiles
  - Application Gateways 💲
  - Virtual Networks
  - Subnets
  - NAT Gateways 💲
  - IP Groups
  - Private DNS zones 💲
  - Private Endpoints 💲
  - Virtual Network Gateways 💲
  - DDoS Protections 💲
- Others
  - Resource Groups
  - API Connections
  - Certificates

## Resource Deletion

To enable the option to delete resource(s), you need first to enable it on the filter pane.

![image](https://github.com/user-attachments/assets/51b96c7b-f1dc-439a-bd80-017a195afaff)

Enable the deletion option will add the _'⛔ Delete Selected Resource(s)'_ button.

![image](https://github.com/user-attachments/assets/fdb548bb-2787-4535-9197-4670b342a340)

To delete resource(s), select the resource(s) from the table _(1)_ and click the _'⛔ Delete Selected Resource(s)'_ button _(2)_.

![image](https://github.com/user-attachments/assets/2ac4ea63-f13b-43eb-8828-183bf630658a)


- A Context pane will open with the resource(s) details to approve the deletion.

![image](https://github.com/user-attachments/assets/64e7e3bc-86e8-4577-8ad7-9060ae5d4cd6)

> In the _View request details_ you can see the _Delete_ ARM Actions to delete the selected resource(s).

![image](https://github.com/user-attachments/assets/133127ed-a6c6-4f10-b78f-66888c9d18f2)


> [!Important]
> **Recommended steps before deletion** 
> - Review the resource(s) information thoroughly before continuing with the deletion. 
> - Ensure that the resource(s) is not currently in use.

> To delete a resource, you must have _Contributor_ permissions for the Resource Group(s) where the resource(s) are located. 

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

![image](https://github.com/user-attachments/assets/4cadec5a-405a-4717-874c-2435a7a55655) 

- Select a name and where to save the Workbook:
  - Title: _'Azure Orphaned Resources'_
  - Subscription: <_Subscription Name_>
  - Resource group: <_Resource Group Name_>
  - Location: <_Region_>
- Click _'Save'_

![image](https://github.com/user-attachments/assets/d35a45b1-108b-4557-b454-5ffd3ea87cb7)

The Workbook is ready to use!
- Click on _'Workbooks'_
- Click on _'Azure Orphaned Resources'_ Workbook.

![image](https://github.com/user-attachments/assets/788285e8-9fdc-4401-8b59-04cf9a452c47)

Start using the Workbook and review your orphaned resources.<br/>

(Optional) You can filter by:

- Subscription(s)
- Resource Group(s)

![image](https://github.com/user-attachments/assets/61fe85c8-0a23-4636-aff5-ee89bef36dbc)





