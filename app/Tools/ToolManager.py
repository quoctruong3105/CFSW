import os
import sys
from google_auth_oauthlib.flow import InstalledAppFlow

SCOPES = ["https://www.googleapis.com/auth/spreadsheets"]
CURRENT_DIR = 'E:/CFSW/Docs/'  # os.getcwd()
TOKEN_PATH = os.path.join(CURRENT_DIR, "gg_sheet_token.json")
CREDENTIAL_PATH = os.path.join(CURRENT_DIR, "gg_sheet_credentials.json")

def main(state):
    if state:        # App open
        try:
            flow = InstalledAppFlow.from_client_secrets_file(CREDENTIAL_PATH, SCOPES)
            credentials = flow.run_local_server(port=0)
        except FileNotFoundError:
            print(f"File {CREDENTIAL_PATH} not found.")
        with open(TOKEN_PATH, "w") as token:
            token.write(credentials.to_json())
    else:            # App close
        try:
            os.remove(TOKEN_PATH)
            print(f"File {TOKEN_PATH} deleted successfully.")
        except FileNotFoundError:
            print(f"File {TOKEN_PATH} not found.")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python script.py <state>")
        sys.exit(1)
    try:
        state = eval(sys.argv[1].capitalize())
        main(state)
    except NameError:
        print("Invalid value for state. Please use 'True' or 'False'.")
        sys.exit(1)
