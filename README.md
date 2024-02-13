---
page_type: sample
languages:
- azurecli
- bicep
- powershell
- csharp
products:
- azure
- azure-openai
name: Using Azure OpenAI GPT-4 Vision to extract structured JSON data from PDF documents
description: This sample demonstrates how to use GPT-4 Vision to extract structured JSON data from PDF documents using Azure OpenAI.
azureDeploy: https://raw.githubusercontent.com/Azure-Samples/azure-openai-gpt-4-vision-pdf-extraction-sample/main/infra/main.bicep
---

# Using Azure OpenAI GPT-4 Vision to extract structured JSON data from PDF documents

This sample demonstrates [how to use GPT-4 Vision](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/gpt-with-vision?tabs=rest) to extract structured JSON data from PDF documents, such as invoices, using the [Azure OpenAI Service](https://learn.microsoft.com/en-us/azure/ai-services/openai/overview).

This approach takes advantage of the GPT-4 Vision model's ability to understand the structure of a document and extract the relevant information, without the need to use additional AI services, such as [Azure AI Document Intelligence (formerly known as Form Recognizer)](https://learn.microsoft.com/en-GB/azure/ai-services/document-intelligence/overview?view=doc-intel-3.1.0). This approach provides the following advantages:

- **No requirement to train a custom model**: GPT-4 Vision is a pre-trained model that can be used to extract structured data from PDF documents without the need to train a custom model for your specific document types. This can save time and resources, especially for organizations that need to process a wide variety of document types.
- **Freedom to define a schema**: GPT-4 Vision can extract structured data from documents with, or without, the need to define a schema. When defined, the GPT-4 Vision model can extract data that matches or closely matches the schema, providing a high level of accuracy.
- **Ability to extract data from complex documents**: GPT-4 Vision can extract structured data from complex documents, such as invoices, that contain tables, images, and other non-standard elements.

> [!IMPORTANT]
> GPT-4 Vision accrues charges like other Azure OpenAI models. You pay per-token rate for the prompts and completions. As of 2024-02-13, the GPT-4 Vision model costs $0.01 per 1000 tokens for input and $0.03 per 1000 tokens for output. For more information, see the [Azure OpenAI Service pricing](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/gpt-with-vision#special-pricing-information).

## Components

- [**Azure OpenAI Service**](https://learn.microsoft.com/en-us/azure/ai-services/openai/overview), a managed service for OpenAI GPT models that exposes a REST API.
- [**GPT-4 (vision-preview) model deployment**](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/gpt-with-vision?tabs=rest)
  - **Note**: The GPT-4 Vision model is currently in preview and is not available in all regions. For more information, see the [Azure OpenAI Service documentation](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/models#gpt-4-and-gpt-4-turbo-preview-model-availability).
- [**Azure Bicep**](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview?tabs=bicep), used to create a repeatable infrastructure deployment for the Azure resources.

## Getting Started

> [!NOTE]
> This sample comes prepared with a [Invoice_1.pdf](./Invoice_1.pdf) file that you can use to test the GPT-4 Vision model. You can also use your own PDF files to test the model.

To deploy the infrastructure and test PDF data extraction using GPT-4 Vision, you need to:

### Prerequisites

- Install the latest [**.NET SDK**](https://dotnet.microsoft.com/download).
- Install [**PowerShell Core**](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7.1).
- Install the [**Azure CLI**](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli).
- Install [**Visual Studio Code**](https://code.visualstudio.com/) with the [**Polyglot Notebooks extension**](https://marketplace.visualstudio.com/items?itemName=ms-dotnettools.dotnet-interactive-vscode).

### Run the sample notebook

The [**Sample.ipynb**](./Sample.ipynb) notebook contains all the necessary steps to deploy the infrastructure using Azure Bicep, and make requests to the deployed Azure OpenAI API to test the GPT-4 Vision model with the provided PDF file.

> [!NOTE]
> The sample uses the [**Azure CLI**](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) to deploy the infrastructure from the [**main.bicep**](./infra/main.bicep) file, and PowerShell commands to test the deployed Azure OpenAI API.

The notebook is split into multiple parts including:

1. Login to Azure and set the default subscription.
1. Deploy the Azure resources using Azure Bicep.
1. Create image assets from the provided PDF file.
1. Making requests to the deployed Azure OpenAI API to test the GPT-4 Vision model with the PDF images to return structured JSON data.

Each steps is documented in the notebook with additional information and links to the relevant documentation.

### Clean up resources

After you have finished testing the GPT-4 Vision model, you can clean up the resources using the following steps:

1. Run the `az group delete` command to delete the resource group and all the resources within it.

```bash
az group delete --name <resource-group-name> --yes --no-wait
```

The `<resource-group-name>` is the name of the resource group that can be found as the **AZURE_RESOURCE_GROUP_NAME** environment variable in the [**config.env**](./config.env) file.
