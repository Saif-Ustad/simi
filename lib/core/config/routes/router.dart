import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../common/widgets/app_bottom_navigation.dart';
import '../../../presentation/chat/pages/love_chat_screen.dart';
import '../../../presentation/home/pages/home_screen.dart';
import '../../../presentation/memories/pages/memories_screen.dart';
import '../../../presentation/more/pages/more_screen.dart';
import '../../../presentation/onboarding/pages/welcome_screen.dart';
import '../../../presentation/onboarding/pages/story_start_date_screen.dart';
import '../../../presentation/onboarding/pages/partner_names_screen.dart';
import '../../../presentation/onboarding/pages/profile_photos_screen.dart';
import '../../../presentation/onboarding/pages/pin_setup_screen.dart';
import '../../../presentation/onboarding/pages/biometric_screen.dart';
import '../../../presentation/onboarding/pages/setup_complete_screen.dart';
import '../../../presentation/period/pages/period_screen.dart';
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
  static const String period = '/period';
  static const String chat = '/chat';
  static const String more = '/more';
}

final GoRouter router = GoRouter(
  initialLocation: AppRoutes.welcome,

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
      builder: (
          BuildContext context,
          GoRouterState state,
          Widget child,
          ) {
        return Scaffold(
          backgroundColor: AppColors.surface,

          body: child,

          bottomNavigationBar:
          const HomeBottomNavigation(),
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
          path: AppRoutes.memories,
          builder: (context, state) {
            return const MemoriesScreen();
          },
        ),

        GoRoute(
          path: AppRoutes.period,
          builder: (context, state) {
            return const PeriodScreen();
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
  ],
);