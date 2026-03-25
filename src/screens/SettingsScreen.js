import React, { useState } from 'react';
import { View, Text, StyleSheet, ScrollView, TouchableOpacity, Switch, TextInput } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import MaterialIcons from '@expo/vector-icons/MaterialIcons';
import { useAppContext } from '../context/AppContext';

export default function SettingsScreen() {
  const {
    hapticEnabled, setHapticEnabled,
    soundEnabled, setSoundEnabled,
    appTheme, setAppTheme,
    appLanguage, setAppLanguage,
    isDarkMode, setIsDarkMode,
    dailyGoal, setDailyGoal
  } = useAppContext();

  const [customGoal, setCustomGoal] = useState('');

  const themes = [
    { name: 'Terra', color: '#4a7c59', id: 'Terra' },
    { name: 'Soft Rose', color: '#e8b7b7', id: 'SoftRose' },
    { name: 'Royal Blue', color: '#2b4c7e', id: 'RoyalBlue' },
    { name: 'Lavender', color: '#9b89b3', id: 'Lavender' },
    { name: 'Midnight', color: '#121212', id: 'Midnight' },
  ];

  return (
    <SafeAreaView style={styles.container} edges={['top']}>
      {/* TopAppBar */}
      <View style={styles.header}>
        <Text style={styles.headerTitle}>Terra Tasbih</Text>
      </View>

      <ScrollView style={styles.mainContent} showsVerticalScrollIndicator={false}>
        <View style={styles.titleContainer}>
          <Text style={styles.pageTitle}>Settings</Text>
          <Text style={styles.pageSubtitle}>Tailor your spiritual practice</Text>
        </View>

        {/* Target Count */}
        <View style={styles.sectionCard}>
          <View style={styles.sectionHeader}>
            <MaterialIcons name="adjust" size={24} color="#4a7c59" />
            <Text style={styles.sectionTitle}>Target Count</Text>
          </View>

          <View style={styles.targetRow}>
            <TouchableOpacity
              style={[styles.targetBtn, dailyGoal === 33 && styles.targetBtnActive]}
              onPress={() => setDailyGoal(33)}
            >
              <Text style={[styles.targetBtnText, dailyGoal === 33 && styles.targetBtnTextActive]}>33</Text>
            </TouchableOpacity>
            <TouchableOpacity
              style={[styles.targetBtn, dailyGoal === 99 && styles.targetBtnActive]}
              onPress={() => setDailyGoal(99)}
            >
              <Text style={[styles.targetBtnText, dailyGoal === 99 && styles.targetBtnTextActive]}>99</Text>
            </TouchableOpacity>
            <TouchableOpacity
              style={[styles.targetBtn, dailyGoal === 0 && styles.targetBtnActive, {flexDirection: 'row', gap: 8}]}
              onPress={() => setDailyGoal(0)}
            >
              <MaterialIcons name="all-inclusive" size={20} color={dailyGoal === 0 ? "#ffffff" : "#4a7c59"} />
              <Text style={[styles.targetBtnText, dailyGoal === 0 && styles.targetBtnTextActive]}>Infinity</Text>
            </TouchableOpacity>
          </View>

          <View style={styles.customInputContainer}>
            <TextInput
              style={styles.customInput}
              placeholder="Enter custom target (e.g. 100)"
              placeholderTextColor="rgba(74, 78, 74, 0.5)"
              keyboardType="numeric"
              value={customGoal}
              onChangeText={setCustomGoal}
              onSubmitEditing={() => {
                if(customGoal) setDailyGoal(parseInt(customGoal, 10));
              }}
            />
            <MaterialIcons name="ads-click" size={24} color="rgba(74, 124, 89, 0.5)" style={styles.inputIcon} />
          </View>
          <Text style={styles.inputHint}>Maximum value: 9,999</Text>
        </View>

        {/* Haptic & Sound */}
        <View style={styles.togglesRow}>
          <View style={styles.toggleCard}>
            <View style={styles.toggleInfo}>
              <View style={[styles.iconBg, { backgroundColor: 'rgba(120, 168, 134, 0.2)' }]}>
                <MaterialIcons name="vibration" size={24} color="#4a7c59" />
              </View>
              <View>
                <Text style={styles.toggleTitle}>Haptic</Text>
                <Text style={styles.toggleSubtitle}>Vibrate on count</Text>
              </View>
            </View>
            <Switch
              value={hapticEnabled}
              onValueChange={setHapticEnabled}
              trackColor={{ false: "#e4e0d8", true: "#4a7c59" }}
              thumbColor="#ffffff"
            />
          </View>

          <View style={styles.toggleCard}>
            <View style={styles.toggleInfo}>
              <View style={[styles.iconBg, { backgroundColor: 'rgba(196, 166, 106, 0.2)' }]}>
                <MaterialIcons name="volume-up" size={24} color="#705c30" />
              </View>
              <View>
                <Text style={styles.toggleTitle}>Sound</Text>
                <Text style={styles.toggleSubtitle}>Audible feedback</Text>
              </View>
            </View>
            <Switch
              value={soundEnabled}
              onValueChange={setSoundEnabled}
              trackColor={{ false: "#e4e0d8", true: "#4a7c59" }}
              thumbColor="#ffffff"
            />
          </View>
        </View>

        {/* Language */}
        <View style={styles.sectionCard}>
          <View style={styles.sectionHeader}>
            <MaterialIcons name="language" size={24} color="#4a7c59" />
            <Text style={styles.sectionTitle}>App Language</Text>
          </View>

          <View style={styles.languageRow}>
            {['English', "O'zbekcha", 'Русский'].map((lang) => (
              <TouchableOpacity
                key={lang}
                style={[styles.langBtn, appLanguage === lang && styles.langBtnActive]}
                onPress={() => setAppLanguage(lang)}
              >
                <Text style={[styles.langBtnText, appLanguage === lang && styles.langBtnTextActive]}>{lang}</Text>
                {appLanguage === lang && <MaterialIcons name="check-circle" size={16} color="#ffffff" />}
              </TouchableOpacity>
            ))}
          </View>
        </View>

        {/* Theme */}
        <View style={styles.sectionCard}>
          <View style={[styles.sectionHeader, { justifyContent: 'space-between' }]}>
            <View style={{ flexDirection: 'row', alignItems: 'center', gap: 12 }}>
              <MaterialIcons name="palette" size={24} color="#4a7c59" />
              <Text style={styles.sectionTitle}>App Theme</Text>
            </View>
            <View style={{ flexDirection: 'row', alignItems: 'center', gap: 8 }}>
              <Text style={styles.darkModeText}>Dark Mode</Text>
              <Switch
                value={isDarkMode}
                onValueChange={setIsDarkMode}
                trackColor={{ false: "#e4e0d8", true: "#4a7c59" }}
                thumbColor="#ffffff"
                style={{ transform: [{ scaleX: .8 }, { scaleY: .8 }] }}
              />
            </View>
          </View>

          <ScrollView horizontal showsHorizontalScrollIndicator={false} style={styles.themeScroll}>
            {themes.map((theme) => (
              <TouchableOpacity
                key={theme.id}
                style={styles.themeOption}
                onPress={() => setAppTheme(theme.id)}
              >
                <View style={[
                  styles.themeCircle,
                  { backgroundColor: theme.color },
                  appTheme === theme.id && styles.themeCircleActive
                ]}>
                  {appTheme === theme.id && <MaterialIcons name="check" size={24} color="#ffffff" />}
                </View>
                <Text style={[
                  styles.themeLabel,
                  appTheme === theme.id && styles.themeLabelActive
                ]}>{theme.name}</Text>
              </TouchableOpacity>
            ))}
          </ScrollView>
        </View>

        {/* Reset */}
        <TouchableOpacity style={styles.resetButton}>
          <MaterialIcons name="restart-alt" size={24} color="#b83230" />
          <Text style={styles.resetButtonText}>Reset All Session Progress</Text>
        </TouchableOpacity>

        <View style={styles.versionInfo}>
          <Text style={styles.versionText}>Terra Tasbih v2.4.0</Text>
          <Text style={styles.versionSubtext}>Crafted for Mindful Presence</Text>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#faf6f0',
  },
  header: {
    height: 56,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#faf6f0',
  },
  headerTitle: {
    fontFamily: 'Literata-Bold',
    fontSize: 18,
    color: '#4a7c59',
  },
  mainContent: {
    flex: 1,
    paddingHorizontal: 24,
  },
  titleContainer: {
    marginVertical: 32,
  },
  pageTitle: {
    fontFamily: 'Literata-Bold',
    fontSize: 28,
    color: '#2e3230',
    marginBottom: 8,
  },
  pageSubtitle: {
    fontFamily: 'NunitoSans-Medium',
    fontSize: 16,
    color: 'rgba(74, 78, 74, 0.8)',
  },
  sectionCard: {
    backgroundColor: '#f5f1ea',
    borderRadius: 12,
    padding: 24,
    marginBottom: 16,
  },
  sectionHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
    marginBottom: 24,
  },
  sectionTitle: {
    fontFamily: 'Literata-SemiBold',
    fontSize: 20,
    color: '#2e3230',
  },
  targetRow: {
    flexDirection: 'row',
    gap: 12,
    marginBottom: 16,
  },
  targetBtn: {
    flex: 1,
    backgroundColor: '#f0ece4',
    paddingVertical: 16,
    borderRadius: 8,
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 1,
    borderColor: 'rgba(196, 200, 188, 0.3)',
  },
  targetBtnActive: {
    backgroundColor: '#4a7c59',
    borderColor: '#4a7c59',
  },
  targetBtnText: {
    fontFamily: 'NunitoSans-Bold',
    fontSize: 16,
    color: '#4a7c59',
  },
  targetBtnTextActive: {
    color: '#ffffff',
  },
  customInputContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#f0ece4',
    borderRadius: 8,
    borderWidth: 2,
    borderColor: 'transparent',
  },
  customInput: {
    flex: 1,
    paddingVertical: 12,
    paddingHorizontal: 16,
    fontFamily: 'NunitoSans-Medium',
    fontSize: 16,
    color: '#2e3230',
  },
  inputIcon: {
    paddingRight: 16,
  },
  inputHint: {
    fontFamily: 'NunitoSans-Medium',
    fontSize: 10,
    color: 'rgba(74, 78, 74, 0.6)',
    marginTop: 8,
    paddingHorizontal: 4,
  },
  togglesRow: {
    gap: 16,
    marginBottom: 16,
  },
  toggleCard: {
    backgroundColor: '#f5f1ea',
    borderRadius: 12,
    padding: 24,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  toggleInfo: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 16,
  },
  iconBg: {
    width: 48,
    height: 48,
    borderRadius: 24,
    alignItems: 'center',
    justifyContent: 'center',
  },
  toggleTitle: {
    fontFamily: 'Literata-SemiBold',
    fontSize: 18,
    color: '#2e3230',
  },
  toggleSubtitle: {
    fontFamily: 'NunitoSans-Regular',
    fontSize: 12,
    color: '#4a4e4a',
  },
  languageRow: {
    gap: 12,
  },
  langBtn: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    backgroundColor: '#f0ece4',
    paddingVertical: 12,
    paddingHorizontal: 16,
    borderRadius: 8,
    borderWidth: 1,
    borderColor: 'rgba(196, 200, 188, 0.3)',
  },
  langBtnActive: {
    backgroundColor: '#4a7c59',
    borderColor: '#4a7c59',
  },
  langBtnText: {
    fontFamily: 'NunitoSans-Medium',
    fontSize: 16,
    color: '#2e3230',
  },
  langBtnTextActive: {
    fontFamily: 'NunitoSans-Bold',
    color: '#ffffff',
  },
  darkModeText: {
    fontFamily: 'NunitoSans-Medium',
    fontSize: 12,
    color: '#4a4e4a',
  },
  themeScroll: {
    paddingTop: 8,
  },
  themeOption: {
    alignItems: 'center',
    marginRight: 16,
    gap: 8,
  },
  themeCircle: {
    width: 64,
    height: 64,
    borderRadius: 16,
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 2,
    borderColor: 'rgba(196, 200, 188, 0.3)',
  },
  themeCircleActive: {
    borderColor: '#4a7c59',
    borderWidth: 4,
  },
  themeLabel: {
    fontFamily: 'NunitoSans-Medium',
    fontSize: 12,
    color: '#4a4e4a',
  },
  themeLabelActive: {
    fontFamily: 'NunitoSans-Bold',
    color: '#4a7c59',
  },
  resetButton: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    padding: 24,
    borderRadius: 12,
    borderWidth: 2,
    borderColor: 'rgba(184, 50, 48, 0.2)',
    borderStyle: 'dashed',
    gap: 8,
    marginTop: 8,
    marginBottom: 48,
  },
  resetButtonText: {
    fontFamily: 'NunitoSans-SemiBold',
    fontSize: 16,
    color: '#b83230',
  },
  versionInfo: {
    alignItems: 'center',
    opacity: 0.4,
    paddingBottom: 120, // Space for bottom nav
  },
  versionText: {
    fontFamily: 'NunitoSans-Medium',
    fontSize: 14,
    color: '#2e3230',
    marginBottom: 4,
  },
  versionSubtext: {
    fontFamily: 'NunitoSans-Regular',
    fontSize: 12,
    color: '#2e3230',
  },
});