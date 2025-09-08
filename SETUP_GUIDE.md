# Flutter Setup Guide for AI Voice Assistant UI

## Overview
This guide documents how to install Flutter and run the AI Voice Assistant UI application.

## Method 1: Using Docker (Recommended)

### Prerequisites
- Docker installed on your system
- Git for cloning the repository

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/Embedded-Systems-GCEK/AI-Voice-Assistant-UI.git
   cd AI-Voice-Assistant-UI
   ```

2. **Pull Flutter Docker image**
   ```bash
   docker pull instrumentisto/flutter
   ```

3. **Install dependencies**
   ```bash
   docker run --rm -v "$(pwd)":/app -w /app instrumentisto/flutter flutter pub get
   ```

4. **Enable platform support**
   ```bash
   # Enable web support
   docker run --rm -v "$(pwd)":/app -w /app instrumentisto/flutter flutter config --enable-web
   
   # Enable Linux desktop support (if needed)
   docker run --rm -v "$(pwd)":/app -w /app instrumentisto/flutter flutter config --enable-linux-desktop
   ```

5. **Build for web**
   ```bash
   docker run --rm -v "$(pwd)":/app -w /app instrumentisto/flutter flutter build web
   ```

6. **Serve the web app**
   ```bash
   cd build/web
   python3 -m http.server 8080
   ```

7. **Access the app**
   Open http://localhost:8080 in your browser

### Docker Environment Details
- Flutter version: 3.35.3
- Dart version: 3.9.2
- Supported platforms: Android, Web, Linux Desktop

## Method 2: Native Installation (Alternative)

### Prerequisites
- Ubuntu 24.04 LTS or similar Linux distribution
- Git
- Internet connectivity

### Installation Steps

1. **Install Flutter via snap**
   ```bash
   sudo snap install flutter --classic
   ```

2. **Add Flutter to PATH**
   ```bash
   export PATH="$PATH:/snap/flutter/current/bin"
   ```

3. **Verify installation**
   ```bash
   flutter doctor
   ```

4. **Install project dependencies**
   ```bash
   flutter pub get
   ```

5. **Run the app**
   ```bash
   # For web
   flutter run -d chrome
   
   # For Linux desktop
   flutter run -d linux
   ```

## Project Requirements

### Environment
- Flutter: >=3.10.0
- Dart: >=3.0.0 <4.0.0

### Key Dependencies
- **UI & Theming**: Material Design, Cupertino Icons, Google Fonts
- **State Management**: Provider
- **Database**: SQLite with FFI support for desktop
- **Maps**: Google Maps Flutter (requires API key)
- **Location Services**: Geolocator, Geocoding
- **Charts**: FL Chart for data visualization
- **Platform Services**: Battery Plus, Device Info Plus

## Configuration

### Google Maps Integration (Optional)
To enable map features, configure your Google Maps API key:

**For Web:**
Add to `web/index.html`:
```html
<script src="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY_HERE"></script>
```

**For Android:**
Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<meta-data android:name="com.google.android.geo.API_KEY"
           android:value="YOUR_API_KEY_HERE"/>
```

## Platform Support

### ✅ Tested Platforms
- **Web**: Successfully builds and runs
- **Linux Desktop**: Platform support added
- **Android**: Supported (requires Android SDK)

### 🔧 Features by Platform
- **Web**: Core UI, basic functionality (limited by browser sandbox)
- **Desktop**: Full features including native file access, SQLite
- **Mobile**: Complete feature set with device sensors

## Build Results

### Web Build
- Successfully compiled to JavaScript
- Static files generated in `build/web/`
- Ready for deployment to any web server
- Progressive Web App (PWA) ready

### Known Limitations

1. **CDN Dependencies**: Some external resources (Google Fonts, CanvasKit) may be blocked in restricted environments
2. **Platform Features**: Some device-specific features (battery status, sensors) are limited on web
3. **Database**: Web version uses IndexedDB instead of SQLite

## Troubleshooting

### Common Issues

1. **Flutter SDK Download Issues**
   - Use Docker method if direct installation fails
   - Check network connectivity and firewall settings

2. **Missing Platform Support**
   - Run `flutter config --enable-web` for web support
   - Run `flutter config --enable-linux-desktop` for Linux support

3. **Build Failures**
   - Run `flutter clean && flutter pub get`
   - Check Flutter doctor output: `flutter doctor -v`

4. **Web App Loading Issues**
   - Disable content blockers
   - Check browser console for errors
   - Ensure all static files are served correctly

## Development Tips

1. **Hot Reload**: Use `flutter run` for development with hot reload
2. **Debugging**: Use Flutter DevTools for debugging web applications
3. **Performance**: Consider using `flutter build web --release` for production builds
4. **Testing**: Run tests with `flutter test`

## Deployment

### Web Deployment
1. Build the web app: `flutter build web --release`
2. Copy `build/web/` contents to your web server
3. Configure server to serve static files and handle routing

### Desktop Deployment
1. Build for Linux: `flutter build linux --release`
2. Find executable in `build/linux/x64/release/bundle/`
3. Package with required dependencies

## Success Confirmation

✅ **Verified Working**:
- Flutter project structure is valid
- Dependencies resolve correctly
- Web build completes successfully
- Application serves and loads in browser
- Basic UI framework is functional

The AI Voice Assistant UI is now ready for development and deployment!