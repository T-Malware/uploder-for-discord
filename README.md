Uploader.exe
Overview

Uploader.exe is a Windows batch-based file uploader designed to send selected files to one or more Discord webhooks.
Each user can enter their name once, and the script will automatically store it for future use.
Multiple webhooks can be configured, allowing uploads to different Discord channels.

Features

Send any file from the current directory to a chosen Discord webhook.

Support for multiple saved webhooks.

Local username storage for identification in uploads.

Hidden configuration files to prevent accidental modification.

Automatic webhook file creation if none exists.

Simple text-based user interface.

Requirements

Windows 10 or later.

Internet connection.

curl command available (preinstalled on Windows 10+).

A valid Discord webhook URL.

Usage

Place Uploader.exe (or updispub.cmd if using the batch version) in a folder.

Add the files you want to upload to the same folder.

Run the program.

On first launch:

Enter your username.

Create or add a new Discord webhook.

Choose a file number to upload.

Choose a webhook number to send the file to.

Wait for confirmation of successful upload.

File Storage

.username.txt → Stores your username (hidden file).

.webhooks.txt → Stores webhook names and URLs (hidden file).

These files are automatically created if missing.

Notes

Webhook URLs are not visible during normal use, but stored locally for reuse.

If a webhook stops working, you can delete .webhooks.txt to reset and add new ones.

The script uses only HTTPS requests to communicate with Discord.

Disclaimer

This tool is for educational and administrative use only.
Do not use it to send unauthorized content or spam.
The author is not responsible for misuse or violation of Discord’s Terms of Service.