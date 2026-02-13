*** Settings ***
Documentation     Focus: Login, Add to Cart, and View Cart.
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
${LOGIN_SUBMIT}     id=com.saucelabs.mydemoapp.android:id/loginBtn

${PRODUCT_TITLE}    xpath=(//android.widget.ImageView[@content-desc="Product Image"])[1]
${ADD_TO_CART}      accessibility_id=Tap to add product to cart

# Use the ID for the text verification, and accessibility_id for the click
${CART_TEXT_ID}     id=com.saucelabs.mydemoapp.android:id/cartTV
${CART_BUTTON}      accessibility_id=Displays number of items in your cart

*** Test Cases ***
Verify User Can Add Product To Cart and View It
    [Documentation]    Logs in, adds item, and navigates to the Cart screen.
    Open Sauce Labs App
    Login to Application      bob@example.com    10203040
    Add Product To Cart
    View Shopping Cart

*** Keywords ***
Open Sauce Labs App
    Open Application    ${REMOTE_URL}    platformName=${PLATFORM_NAME}    deviceName=${DEVICE_NAME}    app=${APP_PATH}    automationName=UiAutomator2

Login to Application
    [Arguments]    ${user}    ${pass}
    Wait Until Element Is Visible    ${MENU_BUTTON}    10s
    Click Element    ${MENU_BUTTON}
    Wait Until Element Is Visible    ${LOGIN_MENU_ITEM}    10s
    Click Element    ${LOGIN_MENU_ITEM}
    Wait Until Page Contains Element    ${USERNAME_FIELD}    15s
    Input Text       ${USERNAME_FIELD}    ${user}
    Input Text       ${PASSWORD_FIELD}    ${pass}
    Click Element    ${LOGIN_SUBMIT}

Add Product To Cart
    Wait Until Element Is Visible    ${PRODUCT_TITLE}    15s
    Click Element    ${PRODUCT_TITLE}
    Wait Until Element Is Visible    ${ADD_TO_CART}    10s
    Click Element    ${ADD_TO_CART}
    
    # Verify the text '1' appears on the badge
    Wait Until Keyword Succeeds    7s    1s    Element Text Should Be    ${CART_TEXT_ID}    1

View Shopping Cart
    [Documentation]    The final step to view the cart contents.
    Click Element    ${CART_BUTTON}
    # Verify we are on the 'My Cart' page by checking for the screen title
    Wait Until Page Contains    My Cart    10s
    # Optional: Verify the item is in the list
    Page Should Contain Text    Sauce Labs Backpack