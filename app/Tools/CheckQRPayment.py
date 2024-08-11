import os
from google.auth.transport.requests import Request
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from googleapiclient.discovery import build
from googleapiclient.errors import HttpError

SCOPES = ["https://www.googleapis.com/auth/spreadsheets"]
SPREADSHEET_ID = '19Wi-iRfwpqKGMwCvdUsr_UR5fAp7SmPPJJ-9wgDHQVk'
CURRENT_DIR = 'E:/CFSW/Docs/' #os.getcwd()
TOKEN_PATH = os.path.join(CURRENT_DIR, "gg_sheet_token.json")
CREDENTIAL_PATH = os.path.join(CURRENT_DIR, "gg_sheet_credentials.json")

def main():
    credentials = None
    if os.path.exists(TOKEN_PATH):
        credentials = Credentials.from_authorized_user_file(TOKEN_PATH, SCOPES)
    if not credentials or not credentials.valid:
        if credentials and credentials.expired and credentials.refresh_token:
            credentials.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file(CREDENTIAL_PATH, SCOPES)
            credentials = flow.run_local_server(port=0)
        with open(TOKEN_PATH, "w") as token:
            token.write(credentials.to_json())
    if credentials is None:
        exit()
    try:
        service = build("sheets", "v4", credentials=credentials)
        sheets = service.spreadsheets()
        result = sheets.values().get(spreadsheetId=SPREADSHEET_ID, range="sheet!A10:F10").execute()
        values = result.get("values", [])
        cashStr = values[0][2].split('.')
        cashStr.pop(-1)
        dateStr = values[0][3]
        dataStr = ''.join(cashStr) + ',' + dateStr
        print(dataStr, end="")

    except HttpError as error:
        print(error)

if __name__ == "__main__":
    main()
