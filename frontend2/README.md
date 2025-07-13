# Potato Disease Detection - Flutter Frontend

A Flutter application for potato disease classification using AI. This app allows users to upload images of potato plant leaves and get predictions for disease classification.

## Features

- **Image Upload**: Select images from device gallery
- **Real-time Prediction**: Get instant disease classification results
- **Beautiful UI**: Modern, responsive design with gradient backgrounds
- **Loading States**: Visual feedback during processing
- **Error Handling**: User-friendly error messages

## Prerequisites

- Flutter SDK (version 3.0.0 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- Backend API running on `http://localhost:8000`

## Installation

1. **Clone or navigate to the project directory:**
   ```bash
   cd frontend2
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the application:**
   ```bash
   flutter run
   ```

## Usage

1. **Start the Backend API:**
   Make sure your FastAPI backend is running on `http://localhost:8000`

2. **Launch the Flutter App:**
   - The app will open with a clean interface
   - Click "Select Image" to choose a potato leaf image
   - The app will automatically send the image to the backend for prediction
   - Results will be displayed showing the disease class and confidence percentage
   - Use the "Clear" button to reset and upload a new image

## API Integration

The app communicates with the FastAPI backend at `http://localhost:8000/predict` endpoint:

- **Method**: POST
- **Content-Type**: multipart/form-data
- **Parameter**: `file` (image file)
- **Response**: JSON with `class` and `confidence` fields

## Dependencies

- `flutter`: Core Flutter framework
- `http`: For API communication
- `image_picker`: For selecting images from device
- `file_picker`: Alternative file picking functionality
- `path`: File path utilities

## Project Structure

```
frontend2/
├── lib/
│   ├── main.dart              # App entry point
│   └── screens/
│       └── home_screen.dart   # Main UI screen
├── assets/
│   └── images/               # Image assets
├── pubspec.yaml              # Dependencies
└── README.md                 # This file
```

## Features Comparison with React Version

| Feature | React Version | Flutter Version |
|---------|---------------|-----------------|
| Image Upload | Dropzone + File picker | Image picker |
| UI Framework | Material-UI | Flutter Material |
| API Communication | Axios | HTTP package |
| Loading States | CircularProgress | CircularProgressIndicator |
| Error Handling | Try-catch with alerts | SnackBar notifications |
| Responsive Design | Grid system | Flexible widgets |

## Troubleshooting

1. **Backend Connection Issues:**
   - Ensure the FastAPI backend is running on port 8000
   - Check if CORS is properly configured in the backend

2. **Image Upload Issues:**
   - Verify image format is supported (JPEG, PNG)
   - Check file size limits

3. **Build Issues:**
   - Run `flutter clean` and `flutter pub get`
   - Ensure Flutter SDK is up to date

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is part of the Potato Disease Detection system. 