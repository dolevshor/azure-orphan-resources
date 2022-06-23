@description('The friendly name for the workbook that is used in the Gallery or Saved List.  This name must be unique within a resource group.')
param workbookDisplayName string = 'Orphan Resources'

@description('The gallery that the workbook will been shown under. Supported values include workbook, tsg, etc. Usually, this is \'workbook\'')
param workbookType string = 'workbook'

@description('The id of resource instance to which the workbook will be associated')
param workbookSourceId string = 'Azure Monitor'

@description('The unique guid for this workbook instance')
param workbookId string = newGuid()

@description('The location in which this workbook instance will be deployed')
param location string = resourceGroup().location

@description('Define if this workbook instance should be locked or not.')
param isLocked bool = false

var workbookContent = union(loadJsonContent('Orphan Resources.workbook'), { isLocked: isLocked })

resource workbook 'Microsoft.Insights/workbooks@2022-04-01' = {
  name: workbookId
  location: location
  kind: 'shared'
  properties: {
    displayName: workbookDisplayName
    serializedData: string(workbookContent)
    version: '1.0'
    sourceId: workbookSourceId
    category: workbookType
  }
}

output workbookId string = workbook.id
