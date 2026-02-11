*** Settings ***
Library           AppiumLibrary
Test Teardown     Close Application

*** Variables ***
${REMOTE_URL}      http://127.0.0.1:4723
${PLATFORM_NAME}   Android
${DEVICE_NAME}     emulator-5554
${APP_PATH}        ${CURDIR}/Application/mydemoapp.apk

${MENU_BUTTON}    accessibility_id=View menu
${LOGIN_BUTTON}   accessibility_id=Login Menu Item
${USERNAME_FIELD}  id=com.saucelabs.mydemoapp.android:id/nameRL
${PASSWORD_FIELD}  id=com.saucelabs.mydemoapp.android:id/passwordRL
${username}  xpath=//android.widget.RelativeLayout[@resource-id="com.saucelabs.mydemoapp.android:id/nameRL"]
${password}  xpath=//android.widget.RelativeLayout[@resource-id="com.saucelabs.mydemoapp.android:id/passwordRL"]
${submit_button}  accessibility_id=Tap to login with given credentials

*** Test Cases ***
Verify User Can Login Successfully
    [Documentation]    Test the full login flow with valid credentials
    Launch App On Pixel 9
    Login To App       bob@example.com    10203040
    # This checks if we reached the catalog page
    Wait Until Page Contains    Products    15s

*** Keywords ***
Launch App On Pixel 9
    Open Application    ${REMOTE_URL}
    ...                 platformName=${PLATFORM_NAME}
    ...                 deviceName=${DEVICE_NAME}
    ...                 app=${APP_PATH}
    ...                 automationName=UiAutomator2
    ...                 newCommandTimeout=2500
    ...                 appWaitDuration=30000

Login To App
    [Arguments]    ${username}    ${password}
    
    # Strategy: Find by description (content-desc)
    Wait Until Element Is Visible    ${MENU_BUTTON}    10s
    Click Element    ${MENU_BUTTON}
    
    # 2. Select Login from the menu
    Wait Until Element Is Visible    ${LOGIN_BUTTON}    10s
    Click Element    ${LOGIN_BUTTON}

    # 3. Enter Credentials
    Wait Until Element Is Visible    ${USERNAME_FIELD}    10s
    Click Element    ${USERNAME_FIELD}
    Input Text Into Current Element    ${username}
    Click Element    ${PASSWORD_FIELD}
    Input Text Into Current Element    ${password}
    
    # 4. Submit
    Click Element    ${submit_button}