import os
from google_auth_oauthlib.flow import InstalledAppFlow

SCOPES = ["https://www.googleapis.com/auth/spreadsheets"]
SPREADSHEET_ID = '19Wi-iRfwpqKGMwCvdUsr_UR5fAp7SmPPJJ-9wgDHQVk'
TOKEN_PATH = os.path.join(f'{os.curdir}/token', "gg_sheet_token.json")
CREDENTIAL_PATH = os.path.join(f'{os.curdir}/creds', "gg_sheet_credentials.json")

def clean_old_token():
    os.remove(TOKEN_PATH)
    print(f"File {TOKEN_PATH} deleted successfully.")

def main():
    if os.path.exists(TOKEN_PATH):
        clean_old_token()
    try:
        flow = InstalledAppFlow.from_client_secrets_file(CREDENTIAL_PATH, SCOPES)
        credentials = flow.run_local_server(port=0)
    except FileNotFoundError:
        print(f"File {CREDENTIAL_PATH} not found.")
    with open(TOKEN_PATH, "w") as token:
        token.write(credentials.to_json())

if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print(f"{e}")
