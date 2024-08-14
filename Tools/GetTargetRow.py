from const import *
from google.oauth2.credentials import Credentials
from googleapiclient.discovery import build

def get_cell_value(sheets, sheet_name, cell):
    cell_value = (sheets.values().get(
        spreadsheetId=SPREADSHEET_ID,
        range=f"{sheet_name}!{cell}"
    ).execute().get("values")[0][0])
    return cell_value

def main():
    credentials = None
    if os.path.exists(TOKEN_PATH):
        credentials = Credentials.from_authorized_user_file(TOKEN_PATH, SCOPES)
    else:
        print("Token has not exist!")
        exit()
    service = build("sheets", "v4", credentials=credentials)
    sheets = service.spreadsheets()
    cell_value = (sheets.values().get(spreadsheetId=SPREADSHEET_ID, 
                                      range=f"sheet!G1").execute().get("values")[0][0])
    print(int(cell_value) + 1, end="")

if __name__ == "__main__":
    main()
