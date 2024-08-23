*** Settings ***
Library           SikuliXLibrary

# Suite Setup       Connect To VNC Server
# Suite Teardown    Close Vnc Connection

*** Variables ***
${IMAGE_DIR}        ${CURDIR}/img

*** Test Cases ***
Test Summary
    [Documentation]    Test a pay scenerio
    imagePath add    ${IMAGE_DIR}
    region click    button_nuoc_cam.png=0.8
    Sleep    2
    region click    option_size_L.png=0.8
    Sleep    2
    region click    button_chon_the_ban.png=0.8
    Sleep    2
    region click    card_5.png=0.8
    Sleep    2
    region click    button_yeu_cau_thanh_toan.png=0.6
    Sleep    2
    region click    button_chon_thanh_toan.png=0.8
    Sleep    2
    region click    option_chuyen_khoan.png=0.8
    Sleep    2
    region click    button_tao_qr.png=0.8
    Sleep    2
    region exists   qr_thanh_toan.png=0.8
    Sleep    5
    region screenshot
    region click    button_thoat_thanh_toan.png=0.8
    Sleep    2
    region screenshot
