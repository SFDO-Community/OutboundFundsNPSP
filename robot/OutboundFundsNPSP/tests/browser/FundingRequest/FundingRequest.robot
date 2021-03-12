*** Settings ***

Resource       robot/OutboundFundsNPSP/resources/OutboundfundsNPSP.robot
Library        cumulusci.robotframework.PageObjects
...            robot/OutboundFundsNPSP/resources/FundingRequestPageObject.py
...            robot/OutboundFundsNPSP/resources/OutboundFundsNPSP.py

Suite Setup     Run keywords
...             Open Test Browser
...             Setup Test Data
Suite Teardown  Capture Screenshot And Delete Records And Close Browser

*** Keywords ***
Setup Test Data
    ${ns} =                              Get Outfundsnpsp Namespace Prefix
    Set suite variable                  ${ns}
    ${fundingprogram} =                 API Create Funding Program
    Store Session Record                outfunds__Funding_Program__c         ${fundingprogram}[Id]
    Set suite variable                  ${fundingprogram}
    ${contact} =                        API Create Contact
    Store Session Record                Contact                              ${contact}[Id]
    Set suite variable                  ${contact}
    ${funding_request} =                API Create Funding Request           ${fundingprogram}[Id]     ${contact}[Id]
    Store Session Record                outfunds__Funding_Request__c         ${funding_request}[Id]
    Set suite variable                  ${funding_request}
    ${awardedfunding_request} =         API Create Funding Request           ${fundingprogram}[Id]     ${contact}[Id]
    ...                                 outfunds__Status__c=Awarded     outfunds__Awarded_Amount__c=100000
    Store Session Record                outfunds__Funding_Request__c         ${awardedfunding_request}[Id]
    Set suite variable                  ${awardedfunding_request}
    ${fr_name} =                        Generate New String
    Set suite variable                  ${fr_name}
    ${req_name} =                       Generate New String
    Set suite variable                  ${req_name}

*** Test Case ***
Create Funding Request Via API
    [Documentation]                             Creates a Funding Request via API.
    ...                                         Verifies that Funding Request is created and
    ...                                         displays under recently viewed Funding Request
    [tags]                                      W-8865884        feature:FundingRequest
    Go To Page                                  Listing          ${ns}Funding_Request__c
    Click Link With Text                        ${funding_request}[Name]
    Wait Until Loading Is Complete
    Current Page Should Be                      Details          Funding_Request__c
    Validate Field Value                        Status  contains    In progress
    Validate Field Value                        Funding Request Name    contains    ${funding_request}[Name]

Create Funding Request via UI
     [Documentation]                            Creates a Funding Request via UI.
     ...                                        Verifies that Funding Request is created.
     [tags]                                     W-8865897       feature:FundingRequest
     Go To Page                                 Listing          ${ns}Funding_Request__c
     Click Object Button                        New
     wait until modal is open
     Populate Field                             Funding Request Name    ${fr_name}
     Populate Lookup Field                      Funding Program     ${fundingprogram}[Name]
     Populate Lookup Field                      Applying Contact    ${contact}[Name]
     Click Save
     wait until modal is closed
     Current Page Should Be                     Details           Funding_Request__c
     Validate Field Value                       Funding Request Name           contains         ${fr_name}
