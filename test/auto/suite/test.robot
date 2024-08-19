*** Settings ***
Library           Process

# Suite Setup       Connect To VNC Server
# Suite Teardown    Close Vnc Connection

*** Variables ***
${SCREEN_IMAGE}   ${CURDIR}/widget_template/

*** Test Cases ***
Test Clicking A Button
    [Documentation]    This test case connects to the VNC server, finds the button on the screen, and clicks it.    
    # Region Find    ${CURDIR}/drink_1_button.png=0.6
    # Region Click    ${CURDIR}/drink_1_button.png=0.5
    Click Button by Process       138        282
    Click Button by Process       1352       243
    Click Button by Process       807        626
    Click Button by Process       985        190
    Capture Screenshot by Process    /test/result/screenshots/screenshot.png

*** Keywords ***
Click Button by Process
    [Documentation]    Click a button at a specific position.
    [Arguments]    ${x}    ${y}
    Run Process    xdotool    mousemove ${x} ${y} click 1

Capture Screenshot by Process
    [Documentation]    Capture a screenshot using scrot.
    [Arguments]    ${file_path}
    Run Process    scrot    ${file_path}
