import json
import os
from datetime import datetime

import dropbox
from google.auth.transport.requests import Request
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from googleapiclient.discovery import build
from googleapiclient.http import MediaFileUpload


def backup_ac_to_google(config):
    print("Uploading to Google...")

    creds = None

    if os.path.exists(config["google"]["token_file"]):
        creds = Credentials.from_authorized_user_file(
            config["google"]["token_file"], config["google"]["scopes"]
        )

    if creds and not creds.valid and creds.expired and creds.refresh_token:
        creds.refresh(Request())

    if not creds or not creds.valid:
        flow = InstalledAppFlow.from_client_secrets_file(
            config["google"]["credentials_file"], config["google"]["scopes"]
        )
        creds = flow.run_local_server(port=0)

        with open(config["google"]["token_file"], "w") as file:
            file.write(creds.to_json())

    service = build("drive", "v3", credentials=creds)
    upload = MediaFileUpload(config["ac_file"], mimetype=config["ac_mime_type"])
    body = {
        "parents": [config["google"]["folder_id"]],
        "name": config["backup_filename"],
    }
    results = service.files().create(media_body=upload, body=body).execute()

    print(f"Uploaded to Google successfully: {results}")


def backup_to_dropbox(config):
    print("Uploading to Dropbox...")

    with open(config["dropbox"]["token_file"]) as f:
        token = json.load(f)
        dbx = dropbox.Dropbox(token["access_token"])

    with open(config["ac_file"], "rb") as f:
        results = dbx.files_upload(
            f.read(), f"/{config['dropbox']['folder_name']}/{config['backup_filename']}"
        )

    print(f"Uploaded to Dropbox successfully: {results}")


def main():
    with open("credentials/config.json", "r") as f:
        config = json.load(f)
        config["backup_filename"] = config["backup_filename"].format(
            date=datetime.now().strftime("%Y%m%d")
        )

    backup_ac_to_google(config)
    backup_to_dropbox(config)


if __name__ == "__main__":
    main()
