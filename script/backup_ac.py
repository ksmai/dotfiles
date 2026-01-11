import json
import os
import webbrowser
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

    with open(config["dropbox"]["credentials_file"]) as f:
        credentials = json.load(f)
        app_key = credentials["app_key"]
        app_secret = credentials["app_secret"]

    dbx = None

    if os.path.exists(config["dropbox"]["token_file"]):
        with open(config["dropbox"]["token_file"], "r") as f:
            token = json.load(f)
            dbx = dropbox.Dropbox(
                oauth2_access_token=token["access_token"],
                oauth2_refresh_token=token["refresh_token"],
                app_key=app_key,
                app_secret=app_secret,
            )

            try:
                dbx.check_and_refresh_access_token()
            except Exception:
                print("Dropbox token expired")
                dbx = None

    if not dbx:
        flow = dropbox.DropboxOAuth2FlowNoRedirect(
            consumer_key=app_key,
            consumer_secret=app_secret,
            locale="en_US",
            token_access_type="offline",
        )
        url = flow.start()
        print(f"Visit this URL and approve the app: {url}")
        webbrowser.open(url)

        result = flow.finish(input("Authorization code: "))

        with open(config["dropbox"]["token_file"], "w") as f:
            json.dump(
                {
                    "access_token": result.access_token,
                    "refresh_token": result.refresh_token,
                },
                f,
            )

        dbx = dropbox.Dropbox(
            oauth2_access_token=result.access_token,
            oauth2_refresh_token=result.refresh_token,
            app_key=app_key,
            app_secret=app_secret,
        )

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
