# Media Files App

Welcome to the documentation for the Media Files App. This document will guide you through the setup, usage, and customization of the app. The Media Files App is designed to fetch and display media files from a Dropbox folder.
1. Introduction

The Media Files App is a Swift-based iOS application that allows users to fetch and display media files from a specified Dropbox folder. It provides a user-friendly interface for viewing media file details and images.

2. Getting Started 

Prerequisites
Xcode installed on your Mac.
A Dropbox account.
An active internet connection.

Installation
1. Clone the repository from 
2. Open the project in Xcode.
3. Replace <YOUR_APP_KEY> with your Dropbox app key in the AppDelegate class.
4. Replace <YOUR_FOLDER> with the path to the Dropbox folder containing your media files in the MediaNetworkManager class.

3. Configuration

In order to configure the app to work with your Dropbox account and media files, follow these steps:

Open the AppDelegate class.
Replace <YOUR_APP_KEY> with your Dropbox app key.
Choose the appropriate Dropbox scope by uncommenting either .fullDropboxScoped or .fullDropboxScopedForTeamTesting based on your requirements.

4. Usage 

MediaMainViewController <a name="mediamainviewcontroller"></a>
The MediaMainViewController class is responsible for displaying the list of media files fetched from Dropbox. It also handles user authentication.

Authentication

If the user is not authenticated, the app will request authentication using the Dropbox SDK. If the user is already authenticated, the media files will be fetched and displayed automatically.

MediaDetailViewController <a name="mediadetailviewcontroller"></a>
The MediaDetailViewController class displays detailed information about a selected media file. It shows the media file's name, path, last modification date, and an image preview if available.


5. Conclusion

Congratulations! You've successfully set up the Media Files App, an iOS application that fetches and displays media files from a Dropbox folder. This documentation has provided an overview of the app's functionality, how to configure it, and how to customize it to your needs.
