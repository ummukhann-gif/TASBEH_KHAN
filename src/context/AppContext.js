import React, { createContext, useState, useEffect, useContext } from 'react';
import AsyncStorage from '@react-native-async-storage/async-storage';

const AppContext = createContext();

export const useAppContext = () => {
  return useContext(AppContext);
};

export const AppProvider = ({ children }) => {
  const [dhikrs, setDhikrs] = useState([
    { id: '1', name: 'Subhanallah', arabic: 'سُبْحَانَ اللهِ', target: 33, meaning: 'Glory be to Allah', count: 0 },
    { id: '2', name: 'Alhamdulillah', arabic: 'الْحَمْدُ لِلَّهِ', target: 33, meaning: 'Praise be to Allah', count: 0 },
    { id: '3', name: 'Allahu Akbar', arabic: 'اللهُ أَكْبَرُ', target: 34, meaning: 'Allah is the Greatest', count: 0 },
  ]);
  const [activeDhikrId, setActiveDhikrId] = useState('1');
  const [dailyGoal, setDailyGoal] = useState(100);

  // Settings
  const [hapticEnabled, setHapticEnabled] = useState(true);
  const [soundEnabled, setSoundEnabled] = useState(false);
  const [appTheme, setAppTheme] = useState('Terra'); // 'Terra', 'Soft Rose', etc.
  const [appLanguage, setAppLanguage] = useState('English');
  const [isDarkMode, setIsDarkMode] = useState(false);

  useEffect(() => {
    loadData();
  }, []);

  useEffect(() => {
    saveData();
  }, [dhikrs, activeDhikrId, dailyGoal, hapticEnabled, soundEnabled, appTheme, appLanguage, isDarkMode]);

  const loadData = async () => {
    try {
      const storedData = await AsyncStorage.getItem('@tasbih_data');
      if (storedData) {
        const parsed = JSON.parse(storedData);
        if (parsed.dhikrs) setDhikrs(parsed.dhikrs);
        if (parsed.activeDhikrId) setActiveDhikrId(parsed.activeDhikrId);
        if (parsed.dailyGoal) setDailyGoal(parsed.dailyGoal);
        if (parsed.settings) {
          setHapticEnabled(parsed.settings.hapticEnabled ?? true);
          setSoundEnabled(parsed.settings.soundEnabled ?? false);
          setAppTheme(parsed.settings.appTheme ?? 'Terra');
          setAppLanguage(parsed.settings.appLanguage ?? 'English');
          setIsDarkMode(parsed.settings.isDarkMode ?? false);
        }
      }
    } catch (e) {
      console.error('Failed to load data', e);
    }
  };

  const saveData = async () => {
    try {
      const data = {
        dhikrs,
        activeDhikrId,
        dailyGoal,
        settings: {
          hapticEnabled,
          soundEnabled,
          appTheme,
          appLanguage,
          isDarkMode
        }
      };
      await AsyncStorage.setItem('@tasbih_data', JSON.stringify(data));
    } catch (e) {
      console.error('Failed to save data', e);
    }
  };

  const incrementCount = () => {
    setDhikrs(prev => prev.map(d =>
      d.id === activeDhikrId ? { ...d, count: d.count + 1 } : d
    ));
  };

  const resetCount = () => {
    setDhikrs(prev => prev.map(d =>
      d.id === activeDhikrId ? { ...d, count: 0 } : d
    ));
  };

  const addDhikr = (newDhikr) => {
    const dhikr = {
      ...newDhikr,
      id: Date.now().toString(),
      count: 0,
    };
    setDhikrs(prev => [...prev, dhikr]);
  };

  const updateTarget = (id, newTarget) => {
    setDhikrs(prev => prev.map(d =>
      d.id === id ? { ...d, target: newTarget } : d
    ));
  }

  const value = {
    dhikrs,
    activeDhikrId,
    setActiveDhikrId,
    dailyGoal,
    setDailyGoal,
    hapticEnabled,
    setHapticEnabled,
    soundEnabled,
    setSoundEnabled,
    appTheme,
    setAppTheme,
    appLanguage,
    setAppLanguage,
    isDarkMode,
    setIsDarkMode,
    incrementCount,
    resetCount,
    addDhikr,
    updateTarget
  };

  return (
    <AppContext.Provider value={value}>
      {children}
    </AppContext.Provider>
  );
};