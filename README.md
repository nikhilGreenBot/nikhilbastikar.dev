# Sky Color Finder Mobile App

A beautiful mobile app that shows sky colors based on zip codes and allows users to set them as wallpapers. Inspired by sky.dlazaro.ca.

## Features

- 🎨 **Cartoon-style UI** with beautiful gradients and animations
- 📍 **Zip code input** to find sky colors for specific locations
- 🌅 **Time-based colors** that change based on time of day
- 📱 **Wallpaper setting** - save sky colors as device wallpapers
- 📱 **Cross-platform** - works on iOS and Android
- 🎯 **Simple and intuitive** user interface

## Screenshots

The app features:
- A welcoming input screen with a cloud icon and gradient background
- A zip code input field with cartoon-style design
- A results screen showing the sky color with options to set as wallpaper
- Beautiful animations and transitions

## Installation

### Prerequisites

- Node.js (v14 or higher)
- npm or yarn
- Expo CLI
- iOS Simulator (for iOS) or Android Studio (for Android)

### Setup

1. **Install Expo CLI globally:**
   ```bash
   npm install -g @expo/cli
   ```

2. **Install dependencies:**
   ```bash
   npm install
   ```

3. **Start the development server:**
   ```bash
   npm start
   ```

4. **Run on device/simulator:**
   - Press `i` for iOS simulator
   - Press `a` for Android emulator
   - Scan QR code with Expo Go app on your phone

## How to Use

1. **Enter Zip Code**: Type in any 5-digit zip code
2. **Find Sky Color**: Tap "Find Sky Color" to see the sky color for that location
3. **Set as Wallpaper**: Tap "Set as Wallpaper" to save the color to your photos
4. **Try Another**: Use "Try Another Zip" to explore different locations

## Technical Details

### Dependencies

- **React Native**: Core framework
- **Expo**: Development platform
- **expo-linear-gradient**: Beautiful gradient backgrounds
- **expo-media-library**: Save wallpapers to photo library
- **expo-location**: Location services (for future enhancements)
- **@expo/vector-icons**: Beautiful icons

### Color Algorithm

The app uses a sophisticated color algorithm that:
- Maps zip codes to consistent sky colors
- Adjusts colors based on time of day:
  - **Night (6 PM - 6 AM)**: Dark blue (#191970)
  - **Morning (6 AM - 10 AM)**: Light sky blue (#87CEEB)
  - **Day (10 AM - 4 PM)**: Various sky blues
  - **Evening (4 PM - 8 PM)**: Warmer blue (#4682B4)

### Permissions

The app requests:
- **Photo Library Access**: To save wallpapers
- **Location Access**: For future location-based features

## Development

### Project Structure

```
sky-color-app/
├── App.js              # Main app component
├── app.json            # Expo configuration
├── package.json        # Dependencies
├── assets/             # Images and icons
└── README.md           # This file
```

### Customization

You can easily customize:
- **Colors**: Modify the color arrays in `App.js`
- **UI**: Update styles in the StyleSheet
- **Animations**: Add more React Native animations
- **API Integration**: Replace the mock color generation with real weather APIs

## Future Enhancements

- 🌤️ **Real weather API integration** for accurate sky colors
- 📍 **GPS location detection** for automatic zip code detection
- 🌈 **More color variations** based on weather conditions
- 🎨 **Custom color themes** and user preferences
- 📊 **Color history** to save favorite sky colors
- 🌍 **International support** for postal codes worldwide

## Troubleshooting

### Common Issues

1. **Permission Denied**: Make sure to grant photo library permissions
2. **App Won't Start**: Try `expo start --clear` to clear cache
3. **Build Errors**: Ensure all dependencies are installed with `npm install`

### Getting Help

- Check the [Expo documentation](https://docs.expo.dev/)
- Visit [React Native docs](https://reactnative.dev/)
- Open an issue on this repository

## License

This project is open source and available under the MIT License.

---

**Enjoy finding beautiful sky colors! 🌤️**