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
   
   - Get an API key from [Google Cloud Console](https://console.cloud.google.com/)
   - Enable the Maps SDK for Android, iOS, and JavaScript
   
   **For Android:**
   Add to `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <meta-data android:name="com.google.android.geo.API_KEY"
              android:value="YOUR_API_KEY_HERE"/>
   ```
   
   **For Web:**
   Add to `web/index.html`:
   ```html
   <script src="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY_HERE"></script>
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
├── main.dart                 # App entry point
├── themes/
│   └── catppuccin_theme.dart # Catppuccin theme configuration
├── models/                   # Data models
│   ├── user.dart
│   ├── conversation.dart
│   ├── sensor_data.dart
│   └── system_status.dart
├── services/
│   └── database_service.dart # SQLite database operations
├── providers/
│   └── app_state_provider.dart # State management
├── screens/                  # Main application screens
│   ├── dashboard_screen.dart
│   ├── conversation_screen.dart
│   ├── map_screen.dart
│   └── users_screen.dart
└── widgets/                  # Reusable UI components
    ├── status_card.dart
    ├── sensor_data_card.dart
    ├── conversation_card.dart
    ├── user_list_card.dart
    └── statistics_card.dart
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

The Catppuccin theme can be customized in `lib/themes/catppuccin_theme.dart`. The current implementation uses the Mocha (dark) variant, but you can easily switch to Latte (light), Frappé, or Macchiato variants.

### Database

Database operations are centralized in `DatabaseService`. You can extend the models and add new tables by:
1. Creating new model classes
2. Adding table creation in `_createDatabase`
3. Implementing CRUD operations in `DatabaseService`

### Adding New Screens

Follow the existing pattern:
1. Create screen in `lib/screens/`
2. Add necessary widgets in `lib/widgets/`
3. Update navigation in `dashboard_screen.dart`

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

- [Catppuccin](https://github.com/catppuccin/catppuccin) for the beautiful color palette
- Flutter team for the amazing framework
- Google Maps for location services
- SQLite for reliable local storage
