*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}         http://localhost:5000
${BROWSER}     chrome
@{CHROME_OPTIONS}    --headless    --no-sandbox    --disable-dev-shm-usage    --remote-allow-origins=*

${USERNAME}    admin
${PASSWORD}    1234

*** Keywords ***
Open Chrome With Options
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    FOR    ${arg}    IN    @{CHROME_OPTIONS}
        Call Method    ${options}    add_argument    ${arg}
    END
    Open Browser    ${URL}    ${BROWSER}    options=${options}

*** Test Cases ***
Valid Login Should Redirect To Dashboard
    [Documentation]    Open login page, enter correct credentials, and verify dashboardy
    Open Chrome With Options
    Input Text    name=username    ${USERNAME}
    Input Text    name=password    ${PASSWORD}
    Click Button    xpath=//button[@type="submit"]
    Wait Until Page Contains    Welcome to Dashboard
    Close Browser

Invalid Login Should Show Error
    [Documentation]    Enter wrong credentials and verify error message.
    Open Chrome With Options
    Input Text    name=username    wronguser
    Input Text    name=password    wrongpass
    Click Button    xpath=//button[@type="submit"]
    Wait Until Page Contains    Invalid username or password
    Close Browser
