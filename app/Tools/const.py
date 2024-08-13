import os

SCOPES = ["https://www.googleapis.com/auth/spreadsheets"]
SPREADSHEET_ID = '19Wi-iRfwpqKGMwCvdUsr_UR5fAp7SmPPJJ-9wgDHQVk'
CURRENT_DIR = 'E:/CFSW/app/Docs/' #os.getcwd()
TOKEN_PATH = os.path.join(CURRENT_DIR, "gg_sheet_token.json")
CREDENTIAL_PATH = os.path.join(CURRENT_DIR, "gg_sheet_credentials.json")
