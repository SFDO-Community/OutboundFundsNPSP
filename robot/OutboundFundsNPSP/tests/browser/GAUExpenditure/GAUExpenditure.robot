*** Settings ***
Resource       robot/OutboundFundsNPSP/resources/OutboundfundsNPSP.robot
Library        cumulusci.robotframework.PageObjects
...            robot/OutboundFundsNPSP/resources/FundingRequestPageObject.py

Suite Setup     Run keywords
...             Open Test Browser
...             Setup Test Data
Suite Teardown  Capture Screenshot And Delete Records And Close Browser

*** Keywords ***
Setup Test Data
    ${fundingprogram} =                 API Create Funding Program
    Store Session Record                outfunds__Funding_Program__c         ${fundingprogram}[Id]
    Set suite variable                  ${fundingprogram}
    ${contact} =                        API Create Contact
    Store Session Record                Contact                              ${contact}[Id]
    Set suite variable                  ${contact}
    ${funding_request} =                API Create Funding Request           ${fundingprogram}[Id]     ${contact}[Id]
    Store Session Record                outfunds__Funding_Request__c         ${funding_request}[Id]
    Set suite variable                  ${funding_request}
    ${disbursement}                     API Create Disbursement on a Funding Request  ${funding_request}[Id]
    Set Suite Variable                  ${disbursement}
    &{gau}=                             API Create GAU
    Set Suite Variable                  &{gau}
    &{gau_exp}=                         API Create GAU Expenditure          ${gau}[Id]          ${disbursement}[Id]
    Set Suite Variable                  &{gau_exp}

*** Test Case ***
Verify GAU Expenditure created is added on Disbursement

    Go To Page                                  Listing          outfunds__Funding_Request__c
    Click Link With Text                        ${funding_request}[Name]
    Click Tab                                   Disbursements
    Click Related List Link with Text           ${disbursement}[Name]
    Click Tab                                   GAU Expenditures
    Click Related List Link with Text           ${gau_exp}[Name]
    Validate Field Value                        General Accounting Unit    contains    ${gau}[Name]
    Validate Field Value                        Amount    contains    $10,000.00