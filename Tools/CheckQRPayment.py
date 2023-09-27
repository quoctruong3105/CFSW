import os
from google.auth.transport.requests import Request
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from googleapiclient.discovery import build
from googleapiclient.errors import HttpError

SCOPES = ["https://www.googleapis.com/auth/spreadsheets"]
SPREADSHEET_ID = '19Wi-iRfwpqKGMwCvdUsr_UR5fAp7SmPPJJ-9wgDHQVk'
CURRENT_DIR = os.getcwd()
TOKEN_PATH = os.path.join(CURRENT_DIR, "TransactionToken.json")
CREDENTIAL_PATH = os.path.join(CURRENT_DIR, "TransactionCredential.json")

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
    try:
        service = build("sheets", "v4", credentials=credentials)
        sheets = service.spreadsheets()

        for row in range(2, 21):
            num1 = int(sheets.values().get(spreadsheetId=SPREADSHEET_ID, range=f"sheet!A{row}").execute().get("values")[0][0])
            num2 = int(sheets.values().get(spreadsheetId=SPREADSHEET_ID, range=f"sheet!B{row}").execute().get("values")[0][0])
            res = num1 + num2
            sheets.values().update(spreadsheetId=SPREADSHEET_ID, range=f"sheet!C{row}",
                                   valueInputOption="USER_ENTERED", body={"values": [[f"{res}"]]}).execute()
            sheets.values().update(spreadsheetId=SPREADSHEET_ID, range=f"sheet!D{row}",
                                   valueInputOption="USER_ENTERED", body={"values": [["Done"]]}).execute()

        print("success")

    except HttpError as error:
        print(error)

if __name__ == "__main__":
    main()
