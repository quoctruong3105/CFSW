import os
from google_auth_oauthlib.flow import InstalledAppFlow
from const import *

def clean_old_token():
    try:
        os.remove(TOKEN_PATH)
        print(f"File {TOKEN_PATH} deleted successfully.")
    except FileNotFoundError:
        print(f"File {TOKEN_PATH} not found.")

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
