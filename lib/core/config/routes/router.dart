import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simi/presentation/period/pages/period_setup_screen.dart';
import '../../../common/widgets/app_bottom_navigation.dart';
import '../../../presentation/chat/pages/love_chat_screen.dart';
import '../../../presentation/home/pages/home_screen.dart';
import '../../../presentation/memories/pages/memories_screen.dart';
import '../../../presentation/memories/pages/memory_detail_screen.dart';
import '../../../presentation/more/pages/more_screen.dart';
import '../../../presentation/onboarding/pages/welcome_screen.dart';
import '../../../presentation/onboarding/pages/story_start_date_screen.dart';
import '../../../presentation/onboarding/pages/partner_names_screen.dart';
import '../../../presentation/onboarding/pages/profile_photos_screen.dart';
import '../../../presentation/onboarding/pages/pin_setup_screen.dart';
import '../../../presentation/onboarding/pages/biometric_screen.dart';
import '../../../presentation/onboarding/pages/setup_complete_screen.dart';
import '../../../presentation/period/pages/Period_length_screen.dart';
import '../../../presentation/period/pages/Symptom_Detail_Screen.dart';
import '../../../presentation/period/pages/add_period_record_screen.dart';
import '../../../presentation/period/pages/add_symptoms_screen.dart';
import '../../../presentation/period/pages/cycle_start_date_screen.dart';
import '../../../presentation/period/pages/edit_period_record_screen.dart';
import '../../../presentation/period/pages/period_cycle_length_screen.dart';
import '../../../presentation/period/pages/period_history_screen.dart';
import '../../../presentation/period/pages/period_home_screen.dart';
import '../../../presentation/period/pages/period_saved_success_screen.dart';
import '../../../presentation/period/pages/period_settings_screen.dart';
import '../../../presentation/period/pages/period_setup_complete_screen.dart';
import '../../../presentation/period/pages/symptom_history_screen.dart';
import '../../../presentation/period/pages/symptoms_saved_screen.dart';
import '../../../presentation/period/pages/today_feeling_screen.dart';
import '../theme/app_colors.dart';

class AppRoutes {
  static const String welcome = '/';
  static const String storyStartDate = '/story-start-date';
  static const String partnerNames = '/partner-names';
  static const String profilePhotos = '/profile-photos';
  static const String pinSetup = '/pin-setup';
  static const String biometric = '/biometric';
  static const String setupComplete = '/setup-complete';

  // Main app
  static const String home = '/home';

  static const String memories = '/memories';
  static const String memoryDetail = '/memories/detail';

  static const String period = '/period';
  static const String periodSetup = '/period/setup';
  static const String periodCycleStartDate = '/period/cycle-start-date';
  static const String periodCycleLength = '/period/cycle-length';
  static const String periodLength = '/period/period-length';
  static const String periodSetupComplete = '/period/setup-complete';
  static const String periodAddRecord = '/period/add-record';
  static const String periodSavedSuccess = '/period/saved-success';
  static const String periodSettings = '/period/settings';
  static const String periodEditRecord = '/period/edit-record';
  static const String addSymptoms = '/period/symptoms/add';
  static const String symptomsSaved = '/period/symptoms/saved';
  static const String symptomDetail = '/period/symptoms/detail';
  static const String periodHistory = '/period/history';
  static const String symptomHistory = '/period/symptoms/history';
  static const String todayFeeling = '/period/today-feeling';

  static const String chat = '/chat';
  static const String more = '/more';
}

final GoRouter router = GoRouter(
  initialLocation: AppRoutes.home,

  routes: [
    // --------------------------------------------------
    // WELCOME
    // --------------------------------------------------
    GoRoute(
      path: AppRoutes.welcome,
      builder: (context, state) {
        return WelcomeScreen(
          onGetStarted: () {
            context.push(AppRoutes.storyStartDate);
          },
        );
      },
    ),

    // --------------------------------------------------
    // STORY START DATE
    // --------------------------------------------------
    GoRoute(
      path: AppRoutes.storyStartDate,
      builder: (context, state) {
        return StoryStartDateScreen(
          onBack: () {
            context.pop();
          },

          onContinue: (date) {
            debugPrint('Selected date: $date');

            context.push(AppRoutes.partnerNames);
          },

          onNotSure: () {
            debugPrint('Not sure yet');

            context.push(AppRoutes.partnerNames);
          },
        );
      },
    ),

    // --------------------------------------------------
    // PARTNER NAMES
    // --------------------------------------------------
    GoRoute(
      path: AppRoutes.partnerNames,
      builder: (context, state) {
        return PartnerNamesScreen(
          onBack: () {
            context.pop();
          },

          onContinue: () {
            context.push(AppRoutes.profilePhotos);
          },
        );
      },
    ),

    // --------------------------------------------------
    // PROFILE PHOTOS
    // --------------------------------------------------
    GoRoute(
      path: AppRoutes.profilePhotos,
      builder: (context, state) {
        return ProfilePhotosScreen(
          onBack: () {
            context.pop();
          },

          onContinue: (userPhoto, partnerPhoto) {
            debugPrint('User photo: $userPhoto');
            debugPrint('Partner photo: $partnerPhoto');

            context.push(AppRoutes.pinSetup);
          },

          onSkip: () {
            debugPrint('Photos skipped');

            context.push(AppRoutes.pinSetup);
          },
        );
      },
    ),

    // --------------------------------------------------
    // PIN SETUP
    // --------------------------------------------------
    GoRoute(
      path: AppRoutes.pinSetup,
      builder: (context, state) {
        return PinSetupScreen(
          onBack: () {
            context.pop();
          },

          onComplete: () {
            debugPrint('PIN setup completed');
          },

          onSet: () {
            context.push(AppRoutes.biometric);
          },
        );
      },
    ),

    // --------------------------------------------------
    // BIOMETRIC
    // --------------------------------------------------
    GoRoute(
      path: AppRoutes.biometric,
      builder: (context, state) {
        return BiometricScreen(
          onBack: () {
            context.pop();
          },

          onSetBiometric: () {
            debugPrint('Biometric setup requested');

            context.push(AppRoutes.setupComplete);
          },

          onSkip: () {
            debugPrint('Biometric skipped');

            context.push(AppRoutes.setupComplete);
          },
        );
      },
    ),

    // --------------------------------------------------
    // SETUP COMPLETE
    // --------------------------------------------------
    GoRoute(
      path: AppRoutes.setupComplete,
      builder: (context, state) {
        return SetupCompleteScreen(
          onEnterHome: () {
            context.go(AppRoutes.home);
          },
        );
      },
    ),

    // -------------------------
    // MAIN APP
    // -------------------------
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return Scaffold(
          backgroundColor: AppColors.surface,

          body: child,

          bottomNavigationBar: const HomeBottomNavigation(),
        );
      },

      routes: [
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) {
            return const HomeScreen();
          },
        ),

        GoRoute(
          path: AppRoutes.period,
          builder: (context, state) {
            return PeriodHomeScreen(
              lastPeriodDate: DateTime(2026, 8, 26),
              onEditPeriod: () {
                context.push(
                  AppRoutes.periodEditRecord,
                  extra: DateTime(2026, 8, 26),
                );
              },
              onAddPeriod: () {
                context.push(AppRoutes.periodAddRecord);
              },
              onAddSymptoms: () {
                context.push(AppRoutes.addSymptoms);
              },

              onOpenHistory: () {
                context.push(AppRoutes.periodHistory);
              },
            );
          },
        ),

        GoRoute(
          path: AppRoutes.chat,
          builder: (context, state) {
            return const LoveChatScreen();
          },
        ),

        GoRoute(
          path: AppRoutes.more,
          builder: (context, state) {
            return const MoreScreen();
          },
        ),
      ],
    ),

    GoRoute(
      path: AppRoutes.periodSetup,
      builder: (context, state) {
        return const PeriodSetupScreen();
      },
    ),

    GoRoute(
      path: AppRoutes.periodCycleStartDate,
      builder: (context, state) {
        return const PeriodCycleStartDateScreen();
      },
    ),

    GoRoute(
      path: AppRoutes.periodCycleLength,
      builder: (context, state) {
        return const PeriodCycleLengthScreen();
      },
    ),

    GoRoute(
      path: AppRoutes.periodLength,
      builder: (context, state) {
        return const PeriodLengthScreen();
      },
    ),

    GoRoute(
      path: AppRoutes.periodSetupComplete,
      builder: (context, state) {
        return PeriodSetupCompleteScreen(
          lastPeriodDate: DateTime(2023, 10, 12),
        );
      },
    ),

    GoRoute(
      path: AppRoutes.periodAddRecord,
      builder: (context, state) {
        return AddPeriodRecordScreen();
      },
    ),

    GoRoute(
      path: AppRoutes.periodSavedSuccess,
      builder: (context, state) {
        final startDate = state.extra as DateTime;

        return PeriodSavedSuccessScreen(startDate: startDate);
      },
    ),

    GoRoute(
      path: AppRoutes.periodSettings,
      builder: (context, state) {
        return PeriodSettingsScreen();
      },
    ),

    GoRoute(
      path: AppRoutes.periodEditRecord,
      builder: (context, state) {
        return EditPeriodRecordScreen(
          initialStartDate: state.extra as DateTime?,
        );
      },
    ),

    GoRoute(
      path: AppRoutes.addSymptoms,
      builder: (context, state) {
        return const AddSymptomsScreen();
      },
    ),

    GoRoute(
      path: AppRoutes.symptomsSaved,
      builder: (context, state) {
        return const SymptomsSavedScreen();
      },
    ),

    GoRoute(
      path: AppRoutes.symptomDetail,
      builder: (context, state) {
        return const SymptomDetailScreen();
      },
    ),

    GoRoute(
      path: AppRoutes.periodHistory,
      builder: (context, state) {
        return const PeriodHistoryScreen();
      },
    ),

    GoRoute(
      path: AppRoutes.symptomHistory,
      builder: (context, state) {
        return const SymptomHistoryScreen();
      },
    ),

    GoRoute(
      path: AppRoutes.todayFeeling,
      builder: (context, state) {
        final initialMood = state.extra as String?;

        return TodayFeelingScreen(initialMood: initialMood);
      },
    ),

    // GoRoute(
    //   path: AppRoutes.memories,
    //   builder: (context, state) {
    //     return const MemoriesScreen();
    //   },
    // ),

    GoRoute(
      path: AppRoutes.memories,
      builder: (context, state) {
        return MemoriesScreen(
          memories: [
            MemoryItem(
              title: 'Our First Trip',
              description: 'Our first adventure together.',
              date: DateTime(2025, 8, 12),
              folder: 'Travel',
              location: 'Goa',

              coverImage: const AssetImage(
                'assets/images/memories/goa_cover.png',
              ),
              images: const [
                AssetImage('assets/images/memories/goa_cover.png'),
                AssetImage('assets/images/memories/goa_2.png'),
                AssetImage('assets/images/memories/goa_3.png'),
              ],

              tags: const ['Travel', 'Special'],
            ),
            MemoryItem(
              title: 'The Proposal',
              description:
                  'The moment everything changed. A memory we will carry with us forever.',
              date: DateTime(2024, 12, 24),
              folder: 'Our Story',
              location: 'Mumbai',
              tags: const ['Special', 'Love'],
            ),

            MemoryItem(
              title: 'Our First Trip',
              description:
                  'We got lost, laughed too much, ate amazing food and somehow made the perfect day.',
              date: DateTime(2024, 8, 12),
              folder: 'Travel',
              location: 'Paris',
              tags: const ['Travel', 'Firsts'],
            ),

            MemoryItem(
              title: 'The Day We Met',
              description:
                  'A simple coffee turned into the beginning of something beautiful.',
              date: DateTime(2024, 3, 15),
              folder: 'Our Story',
              location: 'Café',
              tags: const ['Firsts'],
            ),

            MemoryItem(
              title: 'Birthday Together',
              description:
                  'Cake, candles, silly pictures and a night we did not want to end.',
              date: DateTime(2023, 11, 8),
              folder: 'Celebrations',
              location: 'Home',
              tags: const ['Birthday', 'Love'],
            ),
          ],

          // ADD THIS
          onMemoryTap: (memory) {
            context.push(AppRoutes.memoryDetail, extra: memory);
          },
        );
      },
    ),

    GoRoute(
      path: AppRoutes.memoryDetail,
      builder: (context, state) {
        final memory = state.extra as MemoryItem;

        return MemoryDetailScreen(memory: memory);
      },
    ),
  ],
);
