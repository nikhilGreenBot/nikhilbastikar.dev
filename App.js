import React, { useState, useEffect } from 'react';
import {
  StyleSheet,
  Text,
  View,
  TextInput,
  TouchableOpacity,
  Alert,
  Dimensions,
  StatusBar,
  SafeAreaView,
} from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import * as Location from 'expo-location';
import * as MediaLibrary from 'expo-media-library';
import * as FileSystem from 'expo-file-system';
import { Ionicons } from '@expo/vector-icons';

const { width, height } = Dimensions.get('window');

export default function App() {
  const [zipCode, setZipCode] = useState('');
  const [skyColor, setSkyColor] = useState('#87CEEB');
  const [isLoading, setIsLoading] = useState(false);
  const [showInput, setShowInput] = useState(true);

  // Request permissions on app start
  useEffect(() => {
    requestPermissions();
  }, []);

  const requestPermissions = async () => {
    const { status } = await MediaLibrary.requestPermissionsAsync();
    if (status !== 'granted') {
      Alert.alert('Permission needed', 'Please grant media library permission to save wallpapers.');
    }
  };

  const getSkyColor = async (zip) => {
    setIsLoading(true);
    try {
      // Simulate API call to get sky color based on zip code
      // In a real app, you'd call a weather API or sky color API
      const colors = [
        '#87CEEB', // Sky blue
        '#4682B4', // Steel blue
        '#1E90FF', // Dodger blue
        '#00BFFF', // Deep sky blue
        '#87CEFA', // Light sky blue
        '#B0E0E6', // Powder blue
        '#ADD8E6', // Light blue
        '#F0F8FF', // Alice blue
        '#E0F6FF', // Very light blue
        '#B8E6B8', // Light green-blue
      ];
      
      // Use zip code to generate a consistent color
      const colorIndex = parseInt(zip) % colors.length;
      const selectedColor = colors[colorIndex];
      
      // Add some variation based on time of day
      const hour = new Date().getHours();
      let finalColor = selectedColor;
      
      if (hour < 6 || hour > 20) {
        // Night time - darker blue
        finalColor = '#191970';
      } else if (hour < 10) {
        // Morning - lighter blue
        finalColor = '#87CEEB';
      } else if (hour > 16) {
        // Evening - warmer blue
        finalColor = '#4682B4';
      }
      
      setSkyColor(finalColor);
      setShowInput(false);
    } catch (error) {
      Alert.alert('Error', 'Failed to get sky color. Please try again.');
    } finally {
      setIsLoading(false);
    }
  };

  const handleZipCodeSubmit = () => {
    if (zipCode.trim().length === 0) {
      Alert.alert('Error', 'Please enter a zip code');
      return;
    }
    getSkyColor(zipCode);
  };

  const setAsWallpaper = async () => {
    try {
      // Create a simple image with the sky color
      const svgContent = `
        <svg width="${width}" height="${height}" xmlns="http://www.w3.org/2000/svg">
          <rect width="100%" height="100%" fill="${skyColor}"/>
          <text x="50%" y="50%" text-anchor="middle" dy=".3em" font-family="Arial" font-size="24" fill="white">
            Sky Color: ${skyColor}
          </text>
        </svg>
      `;

      const fileUri = `${FileSystem.documentDirectory}sky_wallpaper.svg`;
      await FileSystem.writeAsStringAsync(fileUri, svgContent);

      // Save to media library
      const asset = await MediaLibrary.createAssetAsync(fileUri);
      await MediaLibrary.createAlbumAsync('Sky Colors', asset, false);

      Alert.alert('Success', 'Sky color saved to your photos! You can now set it as wallpaper from your device settings.');
    } catch (error) {
      Alert.alert('Error', 'Failed to save wallpaper. Please try again.');
    }
  };

  const resetApp = () => {
    setZipCode('');
    setSkyColor('#87CEEB');
    setShowInput(true);
  };

  return (
    <SafeAreaView style={styles.container}>
      <StatusBar barStyle="light-content" />
      
      {showInput ? (
        <LinearGradient
          colors={['#4A90E2', '#7B68EE']}
          style={styles.container}
        >
          <View style={styles.content}>
            <View style={styles.cloudContainer}>
              <Ionicons name="cloud" size={80} color="white" style={styles.cloudIcon} />
            </View>
            
            <Text style={styles.title}>Sky Color Finder</Text>
            <Text style={styles.subtitle}>Enter your zip code to see the sky color</Text>
            
            <View style={styles.inputContainer}>
              <TextInput
                style={styles.input}
                placeholder="Enter Zip Code"
                placeholderTextColor="#999"
                value={zipCode}
                onChangeText={setZipCode}
                keyboardType="numeric"
                maxLength={5}
              />
              <TouchableOpacity
                style={styles.button}
                onPress={handleZipCodeSubmit}
                disabled={isLoading}
              >
                <Text style={styles.buttonText}>
                  {isLoading ? 'Loading...' : 'Find Sky Color'}
                </Text>
              </TouchableOpacity>
            </View>
          </View>
        </LinearGradient>
      ) : (
        <View style={[styles.container, { backgroundColor: skyColor }]}>
          <View style={styles.resultContainer}>
            <View style={styles.colorDisplay}>
              <Text style={styles.colorText}>Your Sky Color</Text>
              <Text style={styles.colorCode}>{skyColor}</Text>
            </View>
            
            <View style={styles.buttonContainer}>
              <TouchableOpacity style={styles.wallpaperButton} onPress={setAsWallpaper}>
                <Ionicons name="image" size={24} color="white" />
                <Text style={styles.wallpaperButtonText}>Set as Wallpaper</Text>
              </TouchableOpacity>
              
              <TouchableOpacity style={styles.resetButton} onPress={resetApp}>
                <Ionicons name="refresh" size={24} color="white" />
                <Text style={styles.resetButtonText}>Try Another Zip</Text>
              </TouchableOpacity>
            </View>
          </View>
        </View>
      )}
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  content: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    paddingHorizontal: 20,
  },
  cloudContainer: {
    marginBottom: 30,
  },
  cloudIcon: {
    opacity: 0.8,
  },
  title: {
    fontSize: 32,
    fontWeight: 'bold',
    color: 'white',
    textAlign: 'center',
    marginBottom: 10,
    textShadowColor: 'rgba(0, 0, 0, 0.3)',
    textShadowOffset: { width: 2, height: 2 },
    textShadowRadius: 4,
  },
  subtitle: {
    fontSize: 16,
    color: 'white',
    textAlign: 'center',
    marginBottom: 40,
    opacity: 0.9,
  },
  inputContainer: {
    width: '100%',
    maxWidth: 300,
  },
  input: {
    backgroundColor: 'white',
    borderRadius: 25,
    paddingHorizontal: 20,
    paddingVertical: 15,
    fontSize: 18,
    marginBottom: 20,
    textAlign: 'center',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.3,
    shadowRadius: 8,
    elevation: 8,
  },
  button: {
    backgroundColor: '#FF6B6B',
    borderRadius: 25,
    paddingVertical: 15,
    alignItems: 'center',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.3,
    shadowRadius: 8,
    elevation: 8,
  },
  buttonText: {
    color: 'white',
    fontSize: 18,
    fontWeight: 'bold',
  },
  resultContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    paddingHorizontal: 20,
  },
  colorDisplay: {
    backgroundColor: 'rgba(255, 255, 255, 0.2)',
    borderRadius: 20,
    padding: 30,
    alignItems: 'center',
    marginBottom: 40,
    backdropFilter: 'blur(10px)',
  },
  colorText: {
    fontSize: 24,
    fontWeight: 'bold',
    color: 'white',
    marginBottom: 10,
    textShadowColor: 'rgba(0, 0, 0, 0.5)',
    textShadowOffset: { width: 1, height: 1 },
    textShadowRadius: 2,
  },
  colorCode: {
    fontSize: 20,
    color: 'white',
    fontWeight: '600',
    textShadowColor: 'rgba(0, 0, 0, 0.5)',
    textShadowOffset: { width: 1, height: 1 },
    textShadowRadius: 2,
  },
  buttonContainer: {
    width: '100%',
    maxWidth: 300,
  },
  wallpaperButton: {
    backgroundColor: '#4CAF50',
    borderRadius: 25,
    paddingVertical: 15,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    marginBottom: 15,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.3,
    shadowRadius: 8,
    elevation: 8,
  },
  wallpaperButtonText: {
    color: 'white',
    fontSize: 18,
    fontWeight: 'bold',
    marginLeft: 10,
  },
  resetButton: {
    backgroundColor: '#FF9800',
    borderRadius: 25,
    paddingVertical: 15,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.3,
    shadowRadius: 8,
    elevation: 8,
  },
  resetButtonText: {
    color: 'white',
    fontSize: 18,
    fontWeight: 'bold',
    marginLeft: 10,
  },
});
