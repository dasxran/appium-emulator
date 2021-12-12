*** Settings ***
Documentation  Simple example using AppiumLibrary
Library  AppiumLibrary

*** Variables ***
${APPIUM_SERVER}              http://127.0.0.1:4723/wd/hub
${ANDROID_AUTOMATION_NAME}    UIAutomator2
${ANDROID_PLATFORM_NAME}      Android
${AppPackage}                 com.google.android.dialer

*** Test Cases ***
Place a Phone Call using Dialer
  [Tags]    Dialer
  Open Dialer Application
  Dial Phone Number    555-555-5555
  [Teardown]    Close Application


*** Keywords ***
Open Dialer Application
  Open Application  ${APPIUM_SERVER}  automationName=${ANDROID_AUTOMATION_NAME}
  ...  platformName=${ANDROID_PLATFORM_NAME}
  ...  appPackage=${AppPackage}  appActivity=com.android.dialer.main.impl.MainActivity

Dial Phone Number
  [Arguments]  ${number}
  Wait Until Page Contains Element      id=${AppPackage}:id/fab
  Click Element                         id=${AppPackage}:id/fab
  Wait Until Page Contains Element      id=${AppPackage}:id/digits
  Click Element                         id=${AppPackage}:id/digits
  Input Text                            id=${AppPackage}:id/digits        ${number}
  Click Element                         id=${AppPackage}:id/dialpad_floating_action_button
  Wait Until Page Contains Element      id=${AppPackage}:id/incall_end_call
  Sleep                                 10s
  Capture Page Screenshot
  Click Element                         id=${AppPackage}:id/incall_end_call
  Wait Until Page Contains Element      id=${AppPackage}:id/fab
