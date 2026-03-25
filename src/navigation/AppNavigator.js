import React from 'react';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import MaterialIcons from '@expo/vector-icons/MaterialIcons';

// Screens
import CounterScreen from '../screens/CounterScreen';
import DhikrListScreen from '../screens/DhikrListScreen';
import StatsScreen from '../screens/StatsScreen';
import SettingsScreen from '../screens/SettingsScreen';
import AddDhikrScreen from '../screens/AddDhikrScreen';

const Tab = createBottomTabNavigator();
const Stack = createNativeStackNavigator();

function TabNavigator() {
  return (
    <Tab.Navigator
      screenOptions={({ route }) => ({
        headerShown: false,
        tabBarIcon: ({ focused, color, size }) => {
          let iconName;

          if (route.name === 'Counter') {
            iconName = 'fingerprint';
          } else if (route.name === 'Dhikr') {
            iconName = 'format-list-bulleted';
          } else if (route.name === 'Stats') {
            iconName = 'bar-chart';
          } else if (route.name === 'Settings') {
            iconName = 'settings';
          }

          return <MaterialIcons name={iconName} size={28} color={color} />;
        },
        tabBarActiveTintColor: '#4a7c59',
        tabBarInactiveTintColor: 'rgba(112, 92, 48, 0.6)',
        tabBarStyle: {
          backgroundColor: 'rgba(250, 246, 240, 0.95)',
          borderTopColor: 'rgba(74, 124, 89, 0.1)',
          borderTopWidth: 1,
          height: 80,
          paddingBottom: 24,
          paddingTop: 12,
          borderTopLeftRadius: 24,
          borderTopRightRadius: 24,
          position: 'absolute',
          elevation: 0,
          shadowColor: 'rgba(46,50,48,0.06)',
          shadowOffset: { width: 0, height: -4 },
          shadowOpacity: 1,
          shadowRadius: 20,
        },
        tabBarLabelStyle: {
          fontFamily: 'NunitoSans-Medium',
          fontSize: 12,
        },
      })}
    >
      <Tab.Screen name="Counter" component={CounterScreen} />
      <Tab.Screen name="Dhikr" component={DhikrListScreen} />
      <Tab.Screen name="Stats" component={StatsScreen} />
      <Tab.Screen name="Settings" component={SettingsScreen} />
    </Tab.Navigator>
  );
}

export default function AppNavigator() {
  return (
    <Stack.Navigator screenOptions={{ headerShown: false }}>
      <Stack.Screen name="MainTabs" component={TabNavigator} />
      <Stack.Screen
        name="AddDhikr"
        component={AddDhikrScreen}
        options={{ presentation: 'modal' }}
      />
    </Stack.Navigator>
  );
}