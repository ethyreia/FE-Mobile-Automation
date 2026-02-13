*** Settings ***
Library           AppiumLibrary
Test Teardown     Close Application

*** Variables ***
${REMOTE_URL}      http://127.0.0.1:4723
${PLATFORM_NAME}   Android
${DEVICE_NAME}     emulator-5554
${APP_PATH}        ${CURDIR}/Application/mydemoapp.apk

# Locators
${MENU_BUTTON}      accessibility_id=View menu
${LOGIN_MENU_ITEM}  accessibility_id=Login Menu Item
${USERNAME_FIELD}   id=com.saucelabs.mydemoapp.android:id/nameET
${PASSWORD_FIELD}   id=com.saucelabs.mydemoapp.android:id/passwordET
${LOGIN_SUBMIT}     accessibility_id=Tap to login with given credentials
${LOGOUT_SIDEBAR}   accessibility_id=Logout Menu Item
${CONFIRM_LOGOUT}   id=android:id/button1

*** Test Cases ***
Verify User Can Login Then Logout
    [Documentation]    Full end-to-end flow: Login -> Logout
    Open Sauce Labs App
    Login to Application     bob@example.com    10203040
    Logout From Application

*** Keywords ***
Open Sauce Labs App
    Open Application    ${REMOTE_URL}    platformName=${PLATFORM_NAME}    
    ...    deviceName=${DEVICE_NAME}    app=${APP_PATH}    automationName=UiAutomator2

Login to Application
    [Arguments]    ${user}    ${pass}
    Wait Until Element Is Visible    ${MENU_BUTTON}    10s
    Click Element    ${MENU_BUTTON}
    Wait Until Element Is Visible    ${LOGIN_MENU_ITEM}    5s
    Click Element    ${LOGIN_MENU_ITEM}
    Input Text       ${USERNAME_FIELD}    ${user}
    Input Text       ${PASSWORD_FIELD}    ${pass}
    Click Element    ${LOGIN_SUBMIT}

Logout From Application
    # 1. Wait a moment for the screen to stabilize after login
    Sleep    2s
    
    # 2. Force Appium to re-locate the menu button on the NEW screen
    Wait Until Element Is Visible    ${MENU_BUTTON}    10s
    Click Element    ${MENU_BUTTON}
    
    # 3. Select Logout
    Wait Until Element Is Visible    ${LOGOUT_SIDEBAR}    5s
    Click Element    ${LOGOUT_SIDEBAR}
    
    # 4. Handle the Android System Dialog
    Wait Until Element Is Visible    ${CONFIRM_LOGOUT}    5s
    Click Element    ${CONFIRM_LOGOUT}