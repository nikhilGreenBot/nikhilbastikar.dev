# Sky Color Finder - Flutter App

A beautiful and high-performance Flutter app that shows sky colors based on zip codes and allows users to set them as wallpapers. Inspired by [sky.dlazaro.ca](https://sky.dlazaro.ca).

## 🌟 Features

- 🎨 **Beautiful Flutter UI** with smooth animations and gradients
- 📍 **Zip code input** to find sky colors for specific locations
- 🌅 **Time-based colors** that change based on time of day
- 📱 **Wallpaper setting** - save sky colors as device wallpapers
- ⚡ **High performance** - native compilation for better speed
- 📱 **Cross-platform** - works on iOS and Android
- 🎯 **Simple and intuitive** user interface

## 🚀 Performance Benefits

Compared to React Native, this Flutter version offers:
- **Faster startup time** - Native compilation
- **Smaller app size** - No JavaScript runtime
- **Better animations** - 60fps smooth transitions
- **Native performance** - Direct platform access
- **Better memory management** - Garbage collection optimized

## 📱 Screenshots

The app features:
- A welcoming input screen with a cloud icon and gradient background
- A zip code input field with cartoon-style design
- A results screen showing the sky color with options to set as wallpaper
- Beautiful animations and transitions
- Native image generation for wallpapers

## 🛠️ Installation

### Prerequisites

- Flutter SDK (3.4.4 or higher)
- Dart SDK
- Android Studio (for Android development)
- Xcode (for iOS development, Mac only)
- IntelliJ IDEA or VS Code (recommended)

### Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/nikhilGreenBot/sky-color-finder-flutter.git
   cd sky-color-finder-flutter
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

## 🎮 How to Use

1. **Enter Zip Code**: Type in any 5-digit zip code
2. **Find Sky Color**: Tap "Find Sky Color" to see the sky color for that location
3. **Set as Wallpaper**: Tap "Set as Wallpaper" to save the color to your photos
4. **Try Another**: Use "Try Another Zip" to explore different locations

## 🏗️ Technical Details

### Dependencies

- **Flutter**: Core framework
- **image_gallery_saver**: Save wallpapers to photo library
- **permission_handler**: Handle storage permissions
- **path_provider**: Access device file system
- **flutter_svg**: SVG support (for future enhancements)

### Color Algorithm

The app uses a sophisticated color algorithm that:
- Maps zip codes to consistent sky colors
- Adjusts colors based on time of day:
  - **Night (10 PM - 6 AM)**: Dark blue (#0B1426)
  - **Dawn (6 AM - 8 AM)**: Warm orange/red (#FF6B6B)
  - **Morning (8 AM - 12 PM)**: Light sky blue (#87CEEB)
  - **Noon (12 PM - 4 PM)**: Bright blue (#4A90E2)
  - **Afternoon (4 PM - 6 PM)**: Steel blue (#4682B4)
  - **Dusk (6 PM - 8 PM)**: Warm orange/red (#FF6B6B)
  - **Evening (8 PM - 10 PM)**: Deep blue (#191970)

### Permissions

The app requests:
- **Storage Access**: To save wallpapers to photo library

## 📁 Project Structure

```
sky_color_finder_flutter/
├── lib/
│   ├── main.dart              # Main app entry point
│   └── utils/
│       └── color_generator.dart # Sky color generation logic
├── android/                    # Android-specific code
├── ios/                       # iOS-specific code
├── pubspec.yaml               # Dependencies and configuration
└── README.md                  # This file
```

## 🚀 Publishing to App Stores

### For Google Play Store:

1. **Build release APK:**
   ```bash
   flutter build apk --release
   ```

2. **Build App Bundle (recommended):**
   ```bash
   flutter build appbundle --release
   ```

3. **Upload to Google Play Console**

### For Apple App Store:

1. **Build iOS app:**
   ```bash
   flutter build ios --release
   ```

2. **Archive in Xcode:**
   - Open `ios/Runner.xcworkspace` in Xcode
   - Select "Any iOS Device" as target
   - Product → Archive
   - Upload to App Store Connect

## 🔧 Customization

You can easily customize:
- **Colors**: Modify the color arrays in `lib/utils/color_generator.dart`
- **UI**: Update the widget tree in `lib/main.dart`
- **Animations**: Add more Flutter animations
- **API Integration**: Replace the mock color generation with real weather APIs

## 🎯 Future Enhancements

- 🌤️ **Real weather API integration** for accurate sky colors
- 📍 **GPS location detection** for automatic zip code detection
- 🌈 **More color variations** based on weather conditions
- 🎨 **Custom color themes** and user preferences
- 📊 **Color history** to save favorite sky colors
- 🌍 **International support** for postal codes worldwide
- 🔔 **Push notifications** for daily sky color updates

## 🐛 Troubleshooting

### Common Issues

1. **Permission Denied**: Make sure to grant storage permissions
2. **Build Errors**: Run `flutter clean` and `flutter pub get`
3. **iOS Build Issues**: Make sure Xcode is up to date
4. **Android Build Issues**: Check Android SDK installation

### Getting Help

- Check the [Flutter documentation](https://docs.flutter.dev/)
- Visit [Dart docs](https://dart.dev/)
- Open an issue on this repository

## 📄 License

This project is open source and available under the MIT License.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---

**Enjoy finding beautiful sky colors with Flutter! 🌤️**

*Built with ❤️ using Flutter*
