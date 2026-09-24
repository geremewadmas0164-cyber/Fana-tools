name: Build Fana Tools APK

on:
  push:
    branches:
      - main
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          channel: stable

      - name: Extract new Fana Tools project
        run: |
          rm -rf fana_project
          mkdir fana_project
          unzip -q Fana_Tools_New_From_Scratch.zip -d fana_project

      - name: Copy project files
        run: |
          cp -a fana_project/. .

      - name: Create Android platform
        run: flutter create --platforms=android .

      - name: Get Flutter packages
        run: flutter pub get

      - name: Build release APK
        run: flutter build apk --release

      - name: Upload APK
        uses: actions/upload-artifact@v4
        with:
          name: fana-tools-apk
          path: build/app/outputs/flutter-apk/app-release.apk
