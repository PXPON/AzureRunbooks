"""
This Runbook will create an Azure Function App

"""

import os
from azure.common.credentials import ServicePrincipalCredentials
from azure.mgmt.resource import ResourceManagementClient
from azure.mgmt.storage import StorageManagementClient

# Set the parameters
subscription_id = os.environ.get("AZURE_SUBSCRIPTION_ID")
