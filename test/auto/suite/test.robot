*** Settings ***
Library           Process
Library           SikuliXLibrary

# Suite Setup       Connect To VNC Server
# Suite Teardown    Close Vnc Connection

*** Variables ***
${IMAGE_DIR}        ${CURDIR}/img

*** Test Cases ***
Test Clicking A Button
    [Documentation]    This test case connects to the VNC server, finds the button on the screen, and clicks it.
    imagePath add        ${IMAGE_DIR}
    region exists        button.png
    region click    button   ${50}    ${50}
