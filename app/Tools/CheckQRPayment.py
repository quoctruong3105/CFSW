import os
import sys
from google.oauth2.credentials import Credentials
from googleapiclient.discovery import build
from googleapiclient.errors import HttpError
from const import *

def main(row):
    credentials = None
    if os.path.exists(TOKEN_PATH):
        credentials = Credentials.from_authorized_user_file(TOKEN_PATH, SCOPES)
    else:
        print("Token has not exist!")
        exit()
    try:
        service = build("sheets", "v4", credentials=credentials)
        sheets = service.spreadsheets()
        result = sheets.values().get(spreadsheetId=SPREADSHEET_ID, range=f"sheet!A{row}:F{row}").execute()
        values = result.get("values", [])
        if not values:
            return
        cashStr = values[0][2].split('.')
        cashStr.pop(-1)
        dateStr = values[0][3]
        dataStr = ''.join(cashStr) + ',' + dateStr
        print(dataStr, end="")

    except HttpError as error:
        print(error)

if __name__ == "__main__":
    main(sys.argv[1])
