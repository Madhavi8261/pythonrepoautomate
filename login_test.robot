*** Variables ***
${URL}         http://localhost:5000
${BROWSER}     chrome
@{CHROME_OPTIONS}    --headless=new    --no-sandbox    --disable-dev-shm-usage    --user-data-dir=/tmp/chrome-user-data
${USERNAME}    admin
${PASSWORD}    1234

*** Test Cases ***
Valid Login Should Redirect To Dashboard
    [Documentation]    Open login page, enter correct credentials, and verify dashboard and
    Open Browser    ${URL}    ${BROWSER}    options=${CHROME_OPTIONS}
    Input Text    name=username    ${USERNAME}
    Input Text    name=password    ${PASSWORD}
    Click Button    xpath=//button[@type="submit"]
    Wait Until Page Contains    Welcome to Dashboard
    Close Browser

Invalid Login Should Show Error
    [Documentation]    Enter wrong credentials and verify error message.
    Open Browser    ${URL}    ${BROWSER}    options=${CHROME_OPTIONS}
    Input Text    name=username    wronguser
    Input Text    name=password    wrongpass
    Click Button    xpath=//button[@type="submit"]
    Wait Until Page Contains    Invalid username or password
    Close Browser
