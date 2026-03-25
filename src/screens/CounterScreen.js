import React, { useState, useEffect } from 'react';
import { View, Text, TouchableOpacity, ScrollView, StyleSheet, Pressable } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import MaterialIcons from '@expo/vector-icons/MaterialIcons';
import Animated, {
  useSharedValue,
  useAnimatedStyle,
  withSpring,
  withSequence,
  withTiming
} from 'react-native-reanimated';
import { useAppContext } from '../context/AppContext';

export default function CounterScreen() {
  const {
    dhikrs,
    activeDhikrId,
    incrementCount,
    resetCount,
    hapticEnabled,
    soundEnabled,
    dailyGoal
  } = useAppContext();

  const [isExpanded, setIsExpanded] = useState(false);
  const activeDhikr = dhikrs.find(d => d.id === activeDhikrId) || dhikrs[0];

  const scale = useSharedValue(1);

  const animatedStyle = useAnimatedStyle(() => {
    return {
      transform: [{ scale: scale.value }],
    };
  });

  const handlePress = () => {
    // Add haptic and sound logic here based on preferences
    incrementCount();
    scale.value = withSequence(
      withTiming(0.9, { duration: 50 }),
      withSpring(1, { damping: 10, stiffness: 400 })
    );
  };

  const totalCount = dhikrs.reduce((acc, curr) => acc + curr.count, 0);

  return (
    <SafeAreaView style={styles.container} edges={['top']}>
      {/* TopAppBar */}
      <View style={styles.header}>
        <Text style={styles.headerTitle}>Terra Tasbih</Text>
      </View>

      <View style={styles.mainContent}>
        {/* Dhikr Card */}
        <Pressable
          style={[styles.dhikrCard, isExpanded && styles.dhikrCardExpanded]}
          onPress={() => setIsExpanded(!isExpanded)}
        >
          <View style={styles.dhikrCardHeader}>
            <View style={styles.dhikrCardTextContainer}>
              <Text style={styles.dhikrCardLabel}>CURRENT DHIKR</Text>
              <Text style={styles.dhikrCardTitle} numberOfLines={1}>{activeDhikr.name}</Text>
            </View>
            <View style={styles.expandButton}>
              <MaterialIcons
                name={isExpanded ? "expand-less" : "expand-more"}
                size={24}
                color="#ffffff"
              />
            </View>
          </View>

          {isExpanded && (
            <ScrollView style={styles.dhikrCardContent} showsVerticalScrollIndicator={false}>
              <View style={styles.activeDhikrDetails}>
                <Text style={styles.arabicText}>{activeDhikr.arabic}</Text>
                <Text style={styles.meaningText}>{activeDhikr.meaning}</Text>
              </View>
            </ScrollView>
          )}
        </Pressable>

        {/* Counter Section */}
        <View style={styles.counterSection}>
          <View style={styles.counterTextContainer}>
            <Text style={styles.counterNumber}>{activeDhikr.count}</Text>
            <View style={styles.targetBadge}>
              <MaterialIcons name="track-changes" size={14} color="#4a7c59" />
              <Text style={styles.targetBadgeText}>{activeDhikr.count} / {activeDhikr.target}</Text>
              <MaterialIcons name="expand-more" size={14} color="#4a7c59" />
            </View>
          </View>

          <Animated.View style={[animatedStyle]}>
            <TouchableOpacity
              activeOpacity={0.8}
              onPress={handlePress}
              style={[styles.mainButton, isExpanded && styles.mainButtonExpanded]}
            >
              <View style={styles.mainButtonInner}>
                <MaterialIcons name="fingerprint" size={isExpanded ? 36 : 72} color="#ffffff" />
                <Text style={styles.mainButtonText}>TAP</Text>
              </View>
            </TouchableOpacity>
          </Animated.View>

          {/* Secondary Actions */}
          <View style={styles.actionButtons}>
            <TouchableOpacity style={styles.actionButton} onPress={resetCount}>
              <View style={styles.actionIconContainer}>
                <MaterialIcons name="refresh" size={24} color="#6b6358" />
              </View>
              <Text style={styles.actionLabel}>RESET</Text>
            </TouchableOpacity>
            <TouchableOpacity style={styles.actionButton}>
              <View style={styles.actionIconContainer}>
                <MaterialIcons name="volume-up" size={24} color="#6b6358" />
              </View>
              <Text style={styles.actionLabel}>SOUND</Text>
            </TouchableOpacity>
            <TouchableOpacity style={styles.actionButton}>
              <View style={styles.actionIconContainer}>
                <MaterialIcons name="vibration" size={24} color="#6b6358" />
              </View>
              <Text style={styles.actionLabel}>HAPTIC</Text>
            </TouchableOpacity>
          </View>
        </View>

        {/* Weekly Progress Summary */}
        {!isExpanded && (
          <View style={styles.statusPill}>
            <View style={styles.statusIconContainer}>
              <MaterialIcons name="trending-up" size={24} color="#705c30" />
            </View>
            <View style={styles.statusTextContainer}>
              <Text style={styles.statusTitle}>Daily Goal</Text>
              <Text style={styles.statusSubtitle}>{totalCount} / {dailyGoal}</Text>
            </View>
          </View>
        )}
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
    paddingBottom: 100, // Space for bottom nav
  },
  dhikrCard: {
    backgroundColor: '#f5f1ea',
    borderRadius: 12,
    marginTop: 8,
    borderWidth: 1,
    borderColor: 'rgba(74, 124, 89, 0.1)',
    shadowColor: '#2e3230',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.1,
    shadowRadius: 10,
    elevation: 3,
  },
  dhikrCardExpanded: {
    flex: 1,
    maxHeight: '48%',
  },
  dhikrCardHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: 16,
  },
  dhikrCardTextContainer: {
    flex: 1,
  },
  dhikrCardLabel: {
    fontFamily: 'NunitoSans-Bold',
    fontSize: 10,
    color: '#705c30',
    letterSpacing: 1.5,
  },
  dhikrCardTitle: {
    fontFamily: 'Literata-SemiBold',
    fontSize: 16,
    color: '#4a7c59',
    marginTop: 2,
  },
  expandButton: {
    backgroundColor: '#4a7c59',
    padding: 6,
    borderRadius: 20,
    marginLeft: 16,
  },
  dhikrCardContent: {
    paddingHorizontal: 16,
    paddingBottom: 20,
  },
  activeDhikrDetails: {
    backgroundColor: 'rgba(74, 124, 89, 0.05)',
    padding: 16,
    borderRadius: 8,
    borderWidth: 1,
    borderColor: 'rgba(74, 124, 89, 0.1)',
  },
  arabicText: {
    fontFamily: 'Literata-Bold',
    fontSize: 24,
    color: '#4a7c59',
    textAlign: 'right',
    marginBottom: 16,
  },
  meaningText: {
    fontFamily: 'NunitoSans-SemiBold',
    fontSize: 12,
    color: 'rgba(74, 124, 89, 0.8)',
  },
  counterSection: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  counterTextContainer: {
    alignItems: 'center',
    marginBottom: 16,
  },
  counterNumber: {
    fontFamily: 'Literata-Bold',
    fontSize: 72,
    color: '#4a7c59',
  },
  targetBadge: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#eae6de',
    paddingVertical: 4,
    paddingHorizontal: 12,
    borderRadius: 20,
    borderWidth: 1,
    borderColor: 'rgba(196, 200, 188, 0.3)',
    marginTop: 8,
  },
  targetBadgeText: {
    fontFamily: 'NunitoSans-Bold',
    fontSize: 10,
    color: '#4a7c59',
    marginHorizontal: 4,
  },
  mainButton: {
    width: 280,
    height: 280,
    borderRadius: 140, // Needs to be organic shape, using circle for now
    backgroundColor: '#4a7c59',
    justifyContent: 'center',
    alignItems: 'center',
    shadowColor: '#4a7c59',
    shadowOffset: { width: 0, height: 10 },
    shadowOpacity: 0.2,
    shadowRadius: 20,
    elevation: 10,
  },
  mainButtonExpanded: {
    width: '100%',
    height: 84,
    borderRadius: 32,
    marginTop: 16,
  },
  mainButtonInner: {
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 2,
    borderColor: 'rgba(255,255,255,0.2)',
    width: '90%',
    height: '90%',
    borderRadius: 130, // Also needs organic adjustment
  },
  mainButtonText: {
    fontFamily: 'NunitoSans-Bold',
    fontSize: 10,
    color: '#ffffff',
    letterSpacing: 2,
    opacity: 0.8,
    marginTop: 4,
  },
  actionButtons: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    width: '100%',
    marginTop: 32,
    gap: 32,
  },
  actionButton: {
    alignItems: 'center',
  },
  actionIconContainer: {
    width: 48,
    height: 48,
    borderRadius: 24,
    backgroundColor: '#eae6de',
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 4,
  },
  actionLabel: {
    fontFamily: 'NunitoSans-SemiBold',
    fontSize: 10,
    color: 'rgba(107, 99, 88, 0.7)',
  },
  statusPill: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: 'rgba(196, 166, 106, 0.1)',
    padding: 12,
    borderRadius: 16,
    borderWidth: 1,
    borderColor: 'rgba(196, 166, 106, 0.2)',
    marginTop: 'auto',
    marginBottom: 16,
  },
  statusIconContainer: {
    width: 40,
    height: 40,
    borderRadius: 20,
    backgroundColor: 'rgba(112, 92, 48, 0.2)',
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: 12,
  },
  statusTextContainer: {
    flex: 1,
  },
  statusTitle: {
    fontFamily: 'Literata-Bold',
    fontSize: 14,
    color: '#2e3230',
  },
  statusSubtitle: {
    fontFamily: 'NunitoSans-SemiBold',
    fontSize: 10,
    color: '#4a4e4a',
    marginTop: 2,
  },
});