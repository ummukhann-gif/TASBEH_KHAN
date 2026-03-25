import React, { useEffect } from 'react';
import { NavigationContainer } from '@react-navigation/native';
import {
  useFonts,
  Literata_400Regular,
  Literata_600SemiBold,
  Literata_700Bold,
  Literata_800ExtraBold
} from '@expo-google-fonts/literata';
import {
  NunitoSans_300Light,
  NunitoSans_400Regular,
  NunitoSans_500Medium,
  NunitoSans_600SemiBold,
  NunitoSans_700Bold,
} from '@expo-google-fonts/nunito-sans';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import { StatusBar } from 'expo-status-bar';

import { AppProvider } from './src/context/AppContext';
import AppNavigator from './src/navigation/AppNavigator';

export default function App() {
  const [fontsLoaded] = useFonts({
    'Literata-Regular': Literata_400Regular,
    'Literata-SemiBold': Literata_600SemiBold,
    'Literata-Bold': Literata_700Bold,
    'Literata-ExtraBold': Literata_800ExtraBold,
    'NunitoSans-Light': NunitoSans_300Light,
    'NunitoSans-Regular': NunitoSans_400Regular,
    'NunitoSans-Medium': NunitoSans_500Medium,
    'NunitoSans-SemiBold': NunitoSans_600SemiBold,
    'NunitoSans-Bold': NunitoSans_700Bold,
  });

  if (!fontsLoaded) {
    return null; // Could show a loading splash screen here
  }

  return (
    <SafeAreaProvider>
      <AppProvider>
        <NavigationContainer>
          <StatusBar style="auto" />
          <AppNavigator />
        </NavigationContainer>
      </AppProvider>
    </SafeAreaProvider>
  );
}