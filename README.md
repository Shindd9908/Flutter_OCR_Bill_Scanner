# Flutter OCR Bill Scanner
# Image to Text - Flutter App

<img src="Screenshots/main.png" alt="App Screenshot">

## Description

A Flutter application designed for OCR scanning of bills, converting images to text, and optimized for the Vietnamese language format.

## Overview

The "Image to Text" Flutter app allows users to extract text from images using the device camera. It utilizes the Google ML Kit Text Recognition API to perform Optical Character Recognition (OCR) on the images captured through the camera.

## Features

- Capture images using the device camera
- Extract text from the captured images using OCR
- Display the extracted text in real-time
- Simple and user-friendly interface
- OCR scanning of bills.
- Image-to-text conversion.
- Support for the Vietnamese language format.

## Technologies and Libraries

- Developed using the Flutter framework.
- Integrated OCR for text recognition from images.
- Support for the Vietnamese bill format.

## Dependencies

This app relies on the following Flutter packages:

- [google_mlkit_text_recognition](https://pub.dev/packages/google_mlkit_text_recognition): A Flutter plugin to use the ML Kit Text Recognition API from Google for extracting text from images.
- [permission_handler](https://pub.dev/packages/permission_handler): A Flutter plugin for requesting runtime permissions on both Android and iOS platforms.
- [camera](https://pub.dev/packages/camera): A Flutter plugin to access the device camera and take pictures.
- [number_to_vietnamese_words](https://pub.dev/packages/number_to_vietnamese_words): Convert numbers to words for easy comprehension and readability in the Vietnamese language.

Copywrites: - [Malik Hammad](https://github.com/mrhammaddev)
Formatted: - [Shindd9908](https://github.com/Shindd9908)

## Getting Started

To run this app locally on your machine, follow these steps:

1. Clone this repository:
   ```bash
   git clone git@github.com:Shindd9908/Flutter_OCR_Bill_Scanner.git
   git clone https://github.com/Shindd9908/Flutter_OCR_Bill_Scanner.git
2. Change into the app directory:
   ```bash
   cd image_to_text_flutter_app
3. Get the required dependencies by running:
   ```bash
   flutter pub get
4. Connect a physical device or start an emulator.

5. Run the app:
   ```bash
   flutter run

## Screenshots
<!-- Add some beautiful app screenshots here to showcase the app's functionality -->
<p align="center">
  <img src="Screenshots/1.png" alt="Screenshot 1" width="185">
  <img src="Screenshots/2.png" alt="Screenshot 2" width="185">
</p>

## Permissions
The app requires the following permissions:

Camera: To capture images and perform OCR on them.
Storage: To save the captured images temporarily during the OCR process.

**Note:**

Ensure that the application is used for scanning bills in the Vietnamese format.

## Known Issues
List any known issues or limitations of the app, if any.

  