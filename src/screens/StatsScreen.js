import React from 'react';
import { View, Text, StyleSheet, ScrollView, TouchableOpacity } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import MaterialIcons from '@expo/vector-icons/MaterialIcons';
import { useAppContext } from '../context/AppContext';

export default function StatsScreen() {
  const { dhikrs } = useAppContext();

  // Mock data for weekly chart
  const weeklyData = [
    { day: 'MON', value: 40, label: '840' },
    { day: 'TUE', value: 65, label: '1200' },
    { day: 'WED', value: 45, label: '910' },
    { day: 'THU', value: 95, label: '1840', isHighlighted: true },
    { day: 'FRI', value: 30, label: '620' },
    { day: 'SAT', value: 55, label: '1100' },
    { day: 'SUN', value: 40, label: '880' },
  ];

  const totalDhikr = dhikrs.reduce((acc, curr) => acc + curr.count, 0) + 12842; // Add some mock base

  return (
    <SafeAreaView style={styles.container} edges={['top']}>
      {/* TopAppBar */}
      <View style={styles.header}>
        <Text style={styles.headerTitle}>Terra Tasbih</Text>
      </View>

      <ScrollView style={styles.mainContent} showsVerticalScrollIndicator={false}>
        {/* Hero Stats Section */}
        <View style={styles.heroGrid}>
          <View style={styles.totalCard}>
            <Text style={styles.totalLabel}>TOTAL DHIKR</Text>
            <Text style={styles.totalValue}>{totalDhikr.toLocaleString()}</Text>
            <View style={styles.trendContainer}>
              <MaterialIcons name="trending-up" size={14} color="#4a4e4a" />
              <Text style={styles.trendText}>12% more than last week</Text>
            </View>
          </View>

          <View style={styles.statCardRow}>
            <View style={styles.smallStatCard}>
              <Text style={styles.smallStatLabel}>CURRENT STREAK</Text>
              <View style={styles.smallStatValueContainer}>
                <Text style={styles.smallStatValue}>14</Text>
                <Text style={styles.smallStatUnit}>days</Text>
              </View>
            </View>
            <View style={styles.smallStatCard}>
              <Text style={styles.smallStatLabel}>TIME SPENT</Text>
              <View style={styles.smallStatValueContainer}>
                <Text style={styles.smallStatValue}>8.5</Text>
                <Text style={styles.smallStatUnit}>hrs</Text>
              </View>
            </View>
          </View>
        </View>

        {/* Weekly Progress Chart */}
        <View style={styles.chartSection}>
          <View style={styles.chartHeader}>
            <View>
              <Text style={styles.chartTitle}>Weekly Progress</Text>
              <Text style={styles.chartSubtitle}>Daily dhikr count activity</Text>
            </View>
            <View style={styles.chartBadge}>
              <Text style={styles.chartBadgeText}>LAST 7 DAYS</Text>
            </View>
          </View>

          <View style={styles.chartContainer}>
            {/* Grid lines */}
            <View style={styles.gridLinesContainer} pointerEvents="none">
              <View style={styles.gridLine} />
              <View style={styles.gridLine} />
              <View style={styles.gridLine} />
              <View style={styles.gridLine} />
            </View>

            {/* Bars */}
            <View style={styles.barsContainer}>
              {weeklyData.map((data, index) => (
                <View key={index} style={styles.barWrapper}>
                  <View style={styles.barBackground}>
                    <View
                      style={[
                        styles.barFill,
                        { height: `${data.value}%` },
                        data.isHighlighted ? styles.barHighlighted : styles.barNormal
                      ]}
                    />
                  </View>
                  <Text style={[
                    styles.dayLabel,
                    data.isHighlighted && styles.dayLabelHighlighted
                  ]}>
                    {data.day}
                  </Text>
                </View>
              ))}
            </View>
          </View>
        </View>

        {/* Sessions List */}
        <View style={styles.sessionsSection}>
          <View style={styles.sessionsHeader}>
            <Text style={styles.sessionsTitle}>Past Sessions</Text>
            <TouchableOpacity>
              <Text style={styles.viewAllText}>View All</Text>
            </TouchableOpacity>
          </View>

          {/* Session Cards */}
          <View style={styles.sessionCard}>
            <View style={styles.sessionInfo}>
              <Text style={styles.sessionName}>Subhan Allah</Text>
              <Text style={styles.sessionTime}>Today • 10:24 AM</Text>
            </View>
            <View style={styles.sessionStats}>
              <Text style={styles.sessionCount}>x 100</Text>
              <View style={styles.sessionDuration}>
                <MaterialIcons name="schedule" size={12} color="#4a4e4a" />
                <Text style={styles.sessionDurationText}>2:15 min</Text>
              </View>
              <Text style={styles.sessionStatus}>COMPLETED</Text>
            </View>
          </View>

          <View style={styles.sessionCard}>
            <View style={styles.sessionInfo}>
              <Text style={styles.sessionName}>Alhamdulillah</Text>
              <Text style={styles.sessionTime}>Yesterday • 8:15 PM</Text>
            </View>
            <View style={styles.sessionStats}>
              <Text style={styles.sessionCount}>x 33</Text>
              <View style={styles.sessionDuration}>
                <MaterialIcons name="schedule" size={12} color="#4a4e4a" />
                <Text style={styles.sessionDurationText}>1:10 min</Text>
              </View>
              <Text style={styles.sessionStatus}>COMPLETED</Text>
            </View>
          </View>
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
    paddingHorizontal: 20,
    paddingTop: 16,
    paddingBottom: 100, // Space for bottom nav
  },
  heroGrid: {
    marginBottom: 24,
  },
  totalCard: {
    backgroundColor: 'rgba(120, 168, 134, 0.2)',
    padding: 24,
    borderRadius: 16,
    borderWidth: 1,
    borderColor: 'rgba(74, 124, 89, 0.1)',
    marginBottom: 16,
  },
  totalLabel: {
    fontFamily: 'NunitoSans-Bold',
    fontSize: 14,
    color: '#4a7c59',
    letterSpacing: 1.5,
    marginBottom: 8,
  },
  totalValue: {
    fontFamily: 'Literata-ExtraBold',
    fontSize: 48,
    color: '#4a7c59',
  },
  trendContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    marginTop: 16,
    gap: 8,
  },
  trendText: {
    fontFamily: 'NunitoSans-Regular',
    fontSize: 14,
    color: '#4a4e4a',
  },
  statCardRow: {
    flexDirection: 'row',
    gap: 16,
  },
  smallStatCard: {
    flex: 1,
    backgroundColor: '#f0ece4',
    padding: 20,
    borderRadius: 16,
    borderWidth: 1,
    borderColor: 'rgba(196, 200, 188, 0.3)',
  },
  smallStatLabel: {
    fontFamily: 'NunitoSans-Bold',
    fontSize: 10,
    color: '#705c30',
    letterSpacing: 1.5,
    marginBottom: 4,
  },
  smallStatValueContainer: {
    flexDirection: 'row',
    alignItems: 'baseline',
    gap: 4,
  },
  smallStatValue: {
    fontFamily: 'Literata-Bold',
    fontSize: 28,
    color: '#2e3230',
  },
  smallStatUnit: {
    fontFamily: 'NunitoSans-Regular',
    fontSize: 14,
    color: '#4a4e4a',
  },
  chartSection: {
    backgroundColor: '#f5f1ea',
    padding: 24,
    borderRadius: 16,
    borderWidth: 1,
    borderColor: 'rgba(196, 200, 188, 0.2)',
    marginBottom: 32,
    shadowColor: '#2e3230',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.06,
    shadowRadius: 20,
    elevation: 2,
  },
  chartHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'flex-end',
    marginBottom: 40,
  },
  chartTitle: {
    fontFamily: 'Literata-Bold',
    fontSize: 20,
    color: '#2e3230',
  },
  chartSubtitle: {
    fontFamily: 'NunitoSans-Regular',
    fontSize: 14,
    color: '#4a4e4a',
  },
  chartBadge: {
    backgroundColor: '#e4e0d8',
    paddingHorizontal: 12,
    paddingVertical: 4,
    borderRadius: 16,
  },
  chartBadgeText: {
    fontFamily: 'NunitoSans-Bold',
    fontSize: 10,
    color: '#4a4e4a',
    letterSpacing: 1,
  },
  chartContainer: {
    height: 220,
    position: 'relative',
  },
  gridLinesContainer: {
    position: 'absolute',
    top: 0,
    bottom: 32,
    left: 0,
    right: 0,
    justifyContent: 'space-between',
  },
  gridLine: {
    height: 1,
    backgroundColor: 'rgba(196, 200, 188, 0.3)',
    width: '100%',
  },
  barsContainer: {
    flex: 1,
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'flex-end',
    paddingHorizontal: 8,
  },
  barWrapper: {
    alignItems: 'center',
    width: 32,
    height: '100%',
  },
  barBackground: {
    flex: 1,
    width: '100%',
    justifyContent: 'flex-end',
    marginBottom: 12,
  },
  barFill: {
    width: '100%',
    borderTopLeftRadius: 12,
    borderTopRightRadius: 12,
  },
  barNormal: {
    backgroundColor: 'rgba(74, 124, 89, 0.2)',
  },
  barHighlighted: {
    backgroundColor: '#4a7c59',
  },
  dayLabel: {
    fontFamily: 'NunitoSans-Bold',
    fontSize: 11,
    color: '#4a4e4a',
  },
  dayLabelHighlighted: {
    color: '#4a7c59',
    fontFamily: 'NunitoSans-Bold', // Use black weight ideally
  },
  sessionsSection: {
    marginBottom: 120,
  },
  sessionsHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 16,
  },
  sessionsTitle: {
    fontFamily: 'Literata-Bold',
    fontSize: 20,
    color: '#2e3230',
  },
  viewAllText: {
    fontFamily: 'NunitoSans-Bold',
    fontSize: 14,
    color: '#4a7c59',
  },
  sessionCard: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    backgroundColor: '#faf6f0',
    padding: 16,
    borderRadius: 16,
    borderWidth: 1,
    borderColor: 'rgba(196, 200, 188, 0.3)',
    marginBottom: 12,
  },
  sessionInfo: {
    flex: 1,
  },
  sessionName: {
    fontFamily: 'NunitoSans-Bold',
    fontSize: 16,
    color: '#2e3230',
  },
  sessionTime: {
    fontFamily: 'NunitoSans-Regular',
    fontSize: 14,
    color: '#4a4e4a',
    marginTop: 4,
  },
  sessionStats: {
    alignItems: 'flex-end',
  },
  sessionCount: {
    fontFamily: 'Literata-Bold',
    fontSize: 18,
    color: '#2e3230',
  },
  sessionDuration: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
    marginTop: 2,
  },
  sessionDurationText: {
    fontFamily: 'NunitoSans-Bold',
    fontSize: 10,
    color: '#4a4e4a',
    textTransform: 'uppercase',
  },
  sessionStatus: {
    fontFamily: 'NunitoSans-Bold',
    fontSize: 10,
    color: 'rgba(74, 78, 74, 0.6)',
    marginTop: 4,
  },
});