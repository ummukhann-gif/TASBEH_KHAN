import React from 'react';
import { View, Text, StyleSheet, ScrollView, TouchableOpacity } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import MaterialIcons from '@expo/vector-icons/MaterialIcons';
import { useAppContext } from '../context/AppContext';
import { useNavigation } from '@react-navigation/native';

export default function DhikrListScreen() {
  const { dhikrs, setActiveDhikrId } = useAppContext();
  const navigation = useNavigation();

  const handleSelectDhikr = (id) => {
    setActiveDhikrId(id);
    navigation.navigate('Counter');
  };

  return (
    <SafeAreaView style={styles.container} edges={['top']}>
      {/* TopAppBar */}
      <View style={styles.header}>
        <Text style={styles.headerTitle}>Terra Tasbih</Text>
      </View>

      <ScrollView style={styles.mainContent} showsVerticalScrollIndicator={false}>
        <View style={styles.titleContainer}>
          <Text style={styles.pageTitle}>Daily Dhikr</Text>
          <Text style={styles.pageSubtitle}>Select a remembrance to begin your session</Text>
        </View>

        <View style={styles.listContainer}>
          {dhikrs.map((dhikr) => (
            <View key={dhikr.id} style={styles.card}>
              <View style={styles.cardHeader}>
                <Text style={styles.arabicText}>{dhikr.arabic}</Text>
              </View>

              <View style={styles.cardBody}>
                <Text style={styles.dhikrName}>{dhikr.name}</Text>
                <Text style={styles.dhikrMeaning}>{dhikr.meaning}</Text>
              </View>

              <View style={styles.cardFooter}>
                <View style={styles.targetBadge}>
                  <Text style={styles.targetBadgeText}>{dhikr.target}</Text>
                </View>

                <TouchableOpacity
                  style={styles.selectButton}
                  onPress={() => handleSelectDhikr(dhikr.id)}
                >
                  <Text style={styles.selectButtonText}>Select</Text>
                  <MaterialIcons name="arrow-forward" size={16} color="#ffffff" />
                </TouchableOpacity>
              </View>
            </View>
          ))}
        </View>
      </ScrollView>

      {/* Floating Action Button */}
      <TouchableOpacity
        style={styles.fab}
        onPress={() => navigation.navigate('AddDhikr')}
      >
        <MaterialIcons name="add" size={28} color="#221a05" />
      </TouchableOpacity>
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
    paddingHorizontal: 20,
    paddingBottom: 100, // Space for bottom nav
  },
  titleContainer: {
    paddingVertical: 16,
    marginBottom: 8,
  },
  pageTitle: {
    fontFamily: 'Literata-Bold',
    fontSize: 28,
    color: '#2e3230',
    marginBottom: 4,
  },
  pageSubtitle: {
    fontFamily: 'NunitoSans-Regular',
    fontSize: 16,
    color: '#6b6358',
  },
  listContainer: {
    gap: 16,
  },
  card: {
    backgroundColor: '#f0e8db',
    borderRadius: 16,
    padding: 24,
    borderWidth: 1,
    borderColor: 'rgba(74, 124, 89, 0.1)',
    shadowColor: '#2e3230',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.06,
    shadowRadius: 20,
    elevation: 2,
  },
  cardHeader: {
    alignItems: 'flex-end',
    marginBottom: 16,
  },
  arabicText: {
    fontFamily: 'Literata-Regular',
    fontSize: 32,
    color: '#4a7c59',
    lineHeight: 48,
  },
  cardBody: {
    marginBottom: 24,
  },
  dhikrName: {
    fontFamily: 'Literata-SemiBold',
    fontSize: 18,
    color: '#2e3230',
    marginBottom: 4,
  },
  dhikrMeaning: {
    fontFamily: 'NunitoSans-Regular',
    fontSize: 14,
    color: '#6b6358',
    fontStyle: 'italic',
  },
  cardFooter: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  targetBadge: {
    width: 48,
    height: 48,
    borderRadius: 24,
    backgroundColor: '#8ecf9e',
    justifyContent: 'center',
    alignItems: 'center',
    borderWidth: 2,
    borderColor: '#faf6f0',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.1,
    shadowRadius: 2,
    elevation: 1,
  },
  targetBadgeText: {
    fontFamily: 'NunitoSans-Bold',
    fontSize: 16,
    color: '#002110',
  },
  selectButton: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#4a7c59',
    paddingHorizontal: 24,
    paddingVertical: 10,
    borderRadius: 8,
    gap: 8,
  },
  selectButtonText: {
    fontFamily: 'NunitoSans-Bold',
    fontSize: 14,
    color: '#ffffff',
  },
  fab: {
    position: 'absolute',
    bottom: 110, // Above bottom nav
    right: 24,
    width: 56,
    height: 56,
    borderRadius: 16,
    backgroundColor: '#f8e0a8',
    justifyContent: 'center',
    alignItems: 'center',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.3,
    shadowRadius: 10,
    elevation: 6,
  },
});