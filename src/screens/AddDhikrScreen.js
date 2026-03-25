import React, { useState } from 'react';
import { View, Text, TextInput, TouchableOpacity, StyleSheet, ScrollView } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import MaterialIcons from '@expo/vector-icons/MaterialIcons';
import { useAppContext } from '../context/AppContext';
import { useNavigation } from '@react-navigation/native';

export default function AddDhikrScreen() {
  const { addDhikr } = useAppContext();
  const navigation = useNavigation();

  const [name, setName] = useState('');
  const [arabic, setArabic] = useState('');
  const [target, setTarget] = useState(33);

  const handleSave = () => {
    if (name.trim()) {
      addDhikr({
        name,
        arabic: arabic || '',
        meaning: '', // Could add an input for this later
        target
      });
      navigation.goBack();
    }
  };

  return (
    <SafeAreaView style={styles.container}>
      {/* TopAppBar */}
      <View style={styles.header}>
        <TouchableOpacity onPress={() => navigation.goBack()} style={styles.cancelButton}>
          <Text style={styles.cancelButtonText}>Bekor qilish</Text>
        </TouchableOpacity>
        <Text style={styles.headerTitle}>Tasbeh</Text>
        <View style={styles.headerSpacer} />
      </View>

      <ScrollView style={styles.mainContent} showsVerticalScrollIndicator={false}>
        <View style={styles.titleContainer}>
          <Text style={styles.pageTitle}>Yangi zikr qo'shish</Text>
          <Text style={styles.pageSubtitle}>Yangi zikr ma'lumotlarini kiriting va maqsadni belgilang.</Text>
        </View>

        <View style={styles.inputGroup}>
          <Text style={styles.inputLabel}>Dhikr nomi</Text>
          <TextInput
            style={styles.textInput}
            placeholder="Masalan: SubhanAllah"
            placeholderTextColor="#74796e"
            value={name}
            onChangeText={setName}
          />
        </View>

        <View style={styles.inputGroup}>
          <View style={styles.labelRow}>
            <Text style={styles.inputLabel}>Arabcha matni</Text>
            <Text style={styles.optionalText}>(Ixtiyoriy)</Text>
          </View>
          <TextInput
            style={[styles.textInput, styles.arabicInput]}
            placeholder="سُبْحَانَ ٱللَّٰهِ"
            placeholderTextColor="#74796e"
            value={arabic}
            onChangeText={setArabic}
            textAlign="right"
          />
        </View>

        <View style={styles.inputGroup}>
          <Text style={styles.inputLabel}>Maqsadli soni</Text>
          <View style={styles.targetGrid}>
            <TouchableOpacity
              style={[styles.targetOption, target === 33 && styles.targetOptionSelected]}
              onPress={() => setTarget(33)}
            >
              <Text style={[styles.targetNumber, target === 33 && styles.targetNumberSelected]}>33</Text>
              <Text style={[styles.targetLabel, target === 33 && styles.targetLabelSelected]}>Sunti</Text>
            </TouchableOpacity>
            <TouchableOpacity
              style={[styles.targetOption, target === 99 && styles.targetOptionSelected]}
              onPress={() => setTarget(99)}
            >
              <Text style={[styles.targetNumber, target === 99 && styles.targetNumberSelected]}>99</Text>
              <Text style={[styles.targetLabel, target === 99 && styles.targetLabelSelected]}>Asmo</Text>
            </TouchableOpacity>
            <TouchableOpacity
              style={[styles.targetOption, target !== 33 && target !== 99 && styles.targetOptionSelected]}
            >
              <MaterialIcons
                name="edit"
                size={24}
                color={target !== 33 && target !== 99 ? "#4a7c59" : "#2e3230"}
              />
              <Text style={[styles.targetLabel, target !== 33 && target !== 99 && styles.targetLabelSelected]}>Boshqa</Text>
            </TouchableOpacity>
          </View>
        </View>

        <View style={styles.infoBox}>
          <MaterialIcons name="info" size={24} color="#705c30" style={{ marginTop: 2 }} />
          <Text style={styles.infoText}>
            Har bir zikr o'z tarixiga ega bo'ladi. Siz kunlik progressni va umumiy sanalgan miqdorni "Tarix" bo'limida ko'rishingiz mumkin.
          </Text>
        </View>
      </ScrollView>

      <View style={styles.bottomContainer}>
        <TouchableOpacity style={styles.saveButton} onPress={handleSave}>
          <Text style={styles.saveButtonText}>Saqlash</Text>
          <MaterialIcons name="check-circle" size={24} color="#ffffff" />
        </TouchableOpacity>
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#faf6f0',
  },
  header: {
    height: 64,
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 24,
  },
  cancelButton: {
    paddingVertical: 8,
  },
  cancelButtonText: {
    fontFamily: 'NunitoSans-SemiBold',
    fontSize: 14,
    color: '#4a7c59',
  },
  headerTitle: {
    fontFamily: 'Literata-Bold',
    fontSize: 20,
    color: '#4a7c59',
  },
  headerSpacer: {
    width: 80,
  },
  mainContent: {
    flex: 1,
    paddingHorizontal: 24,
  },
  titleContainer: {
    marginTop: 32,
    marginBottom: 40,
  },
  pageTitle: {
    fontFamily: 'Literata-Bold',
    fontSize: 28,
    color: '#2e3230',
    marginBottom: 8,
  },
  pageSubtitle: {
    fontFamily: 'NunitoSans-Regular',
    fontSize: 16,
    color: '#4a4e4a',
  },
  inputGroup: {
    marginBottom: 32,
  },
  labelRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  inputLabel: {
    fontFamily: 'NunitoSans-Bold',
    fontSize: 14,
    color: '#4a4e4a',
    textTransform: 'uppercase',
    letterSpacing: 1.5,
    marginBottom: 12,
    marginLeft: 4,
  },
  optionalText: {
    fontFamily: 'NunitoSans-Regular',
    fontSize: 10,
    color: 'rgba(74, 78, 74, 0.6)',
    marginBottom: 12,
  },
  textInput: {
    backgroundColor: '#f5f1ea',
    height: 64,
    borderRadius: 12,
    paddingHorizontal: 24,
    fontFamily: 'NunitoSans-Regular',
    fontSize: 18,
    color: '#2e3230',
  },
  arabicInput: {
    fontFamily: 'Literata-Regular',
    fontSize: 24,
    height: 80,
  },
  targetGrid: {
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  targetOption: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: 'rgba(228, 224, 216, 0.5)',
    borderRadius: 12,
    paddingVertical: 16,
    marginHorizontal: 4,
    borderWidth: 2,
    borderColor: 'transparent',
  },
  targetOptionSelected: {
    backgroundColor: 'rgba(120, 168, 134, 0.2)',
    borderColor: '#4a7c59',
  },
  targetNumber: {
    fontFamily: 'Literata-Bold',
    fontSize: 24,
    color: '#2e3230',
  },
  targetNumberSelected: {
    color: '#4a7c59',
  },
  targetLabel: {
    fontFamily: 'NunitoSans-Medium',
    fontSize: 12,
    color: '#2e3230',
    marginTop: 4,
  },
  targetLabelSelected: {
    color: '#4a7c59',
  },
  infoBox: {
    flexDirection: 'row',
    backgroundColor: 'rgba(196, 166, 106, 0.1)',
    padding: 24,
    borderRadius: 12,
    borderWidth: 1,
    borderColor: 'rgba(196, 166, 106, 0.2)',
    marginTop: 8,
    marginBottom: 120,
  },
  infoText: {
    fontFamily: 'NunitoSans-Regular',
    fontSize: 14,
    color: '#554020',
    lineHeight: 22,
    marginLeft: 16,
    flex: 1,
  },
  bottomContainer: {
    position: 'absolute',
    bottom: 0,
    left: 0,
    right: 0,
    paddingHorizontal: 24,
    paddingBottom: 40,
    paddingTop: 40,
    backgroundColor: '#faf6f0',
  },
  saveButton: {
    backgroundColor: '#4a7c59',
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    paddingVertical: 20,
    borderRadius: 12,
    shadowColor: '#4a7c59',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.2,
    shadowRadius: 10,
    elevation: 5,
  },
  saveButtonText: {
    fontFamily: 'Literata-Bold',
    fontSize: 20,
    color: '#ffffff',
    marginRight: 12,
  },
});