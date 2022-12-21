# Azure Orphan Resources
The _'Azure Orphan Resources Workbook'_ centralize orphan resources in Azure environments.

The main purposes of this Workbook are:
* Save money
* Prevent mistakes and misconfiguration
* Simplify operational

![image](https://user-images.githubusercontent.com/69309933/172849159-64580b88-cd71-4053-8768-089e8c3d4564.png)
![image](https://user-images.githubusercontent.com/69309933/172850655-01e28054-45d3-4680-a297-afa1689cca26.png)

All the information presented in this Workbook is based on Azure Resource Graph queries.
<img src="https://user-images.githubusercontent.com/69309933/172938464-38b08c8e-0d4d-493b-aa8f-954189556d7a.png" width="20" height="20">



Type of resources covered:
* Disks
* Network Interfaces
* Public IPs
* Resource Groups
* Network Security Groups (NSGs)
* Availability Set
* Route Tables
* Load Balancers
* App Service Plans
* Front Door WAF Policy
* Traffic Manager Profiles

## How to use it?
Importing this Workbook to your Azure environment is quite simple.

Follow this steps to use the Workbook:
* Login to [Azure Portal](https://portal.azure.com/) <img src="https://user-images.githubusercontent.com/69309933/172941966-9e030031-6ccb-4ebf-bd2b-04bb623e5ff7.png" width="20" height="20">
* Go to _'Azure Workbooks'_

<img src="https://user-images.githubusercontent.com/69309933/172806635-14051976-328e-4623-96ab-0dd6a7bc7817.png" width="350">

* Click on _'+ Create'_

<img src="https://user-images.githubusercontent.com/69309933/172807465-cced3466-0669-423b-87b3-8fa70fdbf1d1.png" width="350">

* Click on _'+ New'_

<img src="https://user-images.githubusercontent.com/69309933/172807547-52d790ce-7852-4b4b-a81f-81e8b7fac26e.png" width="350"> 

* Open the Advanced Editor using the _'</>'_ button on the toolbar

<img src="https://user-images.githubusercontent.com/69309933/172807673-dfc63741-0c40-47c0-ab58-d39309b06e69.png" width="700"> 

* Select the _'Gallery Template'_ (step 1)
* Replace the JSON in the gallery template to the [orphan resources JSON](https://raw.githubusercontent.com/dolevshor/azure-orphan-resources/main/Workbook/Orphan%20Resources.workbook) (step 2)
* Click _'Apply'_ (step 3)

<img src="https://user-images.githubusercontent.com/69309933/172807762-17aec6f9-4a81-4d5b-9017-673a0ab6b26e.png" width="700"> 

* Click in the ‘Save’ button on the toolbar

<img src="https://user-images.githubusercontent.com/69309933/172807909-b4527207-343e-4861-af4e-35e1104029d1.png" width="700">  

* Select a name and where to save the Workbook:
- Title: _'Orphan Resources'_
- Subscription: _Subscription Name_
- Resource group: _Resource Group Name_
- Location: _Region_
* Click _'Save'_
  
<img src="https://user-images.githubusercontent.com/69309933/172808030-3d7171c9-8b23-4f69-ab8b-7150b1459ea8.png" width="700">  
The Workbook is ready to use!
* Click on _'Workbooks'_
* Click on _'Orphan Resources'_ Workbook.

<img src="https://user-images.githubusercontent.com/69309933/172808358-ed2fede8-42a4-42bd-9c68-3ac4d645f812.png" width="700">  

Start using the Workbook and review your orphan resources.<br/>
Filter by specifig subscription is optional.

![image](https://user-images.githubusercontent.com/69309933/172848889-f25c8fce-ce12-4d0a-b426-a0fc64e40e17.png)





