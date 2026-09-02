// import 'package:flutter/material.dart';
//
// import 'core/config/theme/app_theme.dart';
// import 'presentation/onboarding/pages/welcome_screen.dart';
//
// void main() {
//   runApp(const SimiApp());
// }
//
// class SimiApp extends StatelessWidget {
//   const SimiApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Simi ❤️',
//       theme: AppTheme.light,
//       home: const WelcomeScreen( onGetStarted: _onGetStarted,),
//     );
//   }
//
//   static void _onGetStarted() {
//     // TODO: Navigate to the next onboarding screen.
//     //
//     // We will add the navigation when you give me
//     // the screenshot/code for the second screen.
//   }
// }
import 'package:flutter/material.dart';

import 'core/config/theme/app_theme.dart';
import 'presentation/onboarding/pages/welcome_screen.dart';
import 'presentation/onboarding/pages/story_start_date_screen.dart';
import 'presentation/onboarding/pages/partner_names_screen.dart';
import 'presentation/onboarding/pages/profile_photos_screen.dart';
import 'presentation/onboarding/pages/pin_setup_screen.dart';
import 'presentation/onboarding/pages/biometric_screen.dart';
import 'presentation/onboarding/pages/setup_complete_screen.dart';

void main() {
  runApp(const SimiApp());
}

class SimiApp extends StatelessWidget {
  const SimiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SIMI ❤️',
      theme: AppTheme.light,
      home: const WelcomeScreenWrapper(),
    );
  }
}

class WelcomeScreenWrapper extends StatelessWidget {
  const WelcomeScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return WelcomeScreen(
      onGetStarted: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StoryStartDateScreen(
              // -----------------------------------------
              // STORY PAGE → BACK
              // -----------------------------------------
              onBack: () {
                Navigator.pop(context);
              },

              // -----------------------------------------
              // STORY PAGE → CONTINUE
              // -----------------------------------------
              onContinue: (date) {
                debugPrint('Selected date: $date');

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PartnerNamesScreen(
                      // Partner page → Back
                      onBack: () {
                        Navigator.pop(context);
                      },

                      // Partner page → Continue
                      onContinue: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProfilePhotosScreen(
                              onBack: () {
                                Navigator.pop(context);
                              },

                              onContinue: (userPhoto, partnerPhoto) {
                                debugPrint('User photo: $userPhoto');
                                debugPrint('Partner photo: $partnerPhoto');

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PinSetupScreen(
                                      onBack: () {
                                        Navigator.pop(context);
                                      },

                                      onComplete: () {
                                        debugPrint('PIN setup completed');
                                        // NEXT:
                                        // BiometricScreen will go here.
                                      },

                                        onSet: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => BiometricScreen(
                                              onBack: () {
                                                Navigator.pop(context);
                                              },

                                              onSetBiometric: () {
                                                debugPrint('Biometric setup requested');

                                                // Later we will implement actual
                                                // Face ID / Touch ID authentication here.
                                              },

                                              onSkip: () {
                                                debugPrint('Biometric skipped');

                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) => SetupCompleteScreen(
                                                      onEnterHome: () {
                                                        debugPrint('Enter Home clicked');

                                                        // Later:
                                                        // Navigator.pushReplacement(
                                                        //   context,
                                                        //   MaterialPageRoute(
                                                        //     builder: (_) => const HomeScreen(),
                                                        //   ),
                                                        // );
                                                      },
                                                    ),
                                                  ),
                                                );

                                                // Later this will navigate to
                                                // Setup Complete screen.
                                              },
                                            ),
                                          ),
                                        );
                                      }
                                    ),
                                  ),
                                );
                              },

                              onSkip: () {
                                // Continue without adding photos.
                                debugPrint('Photos skipped');
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },

              // -----------------------------------------
              // STORY PAGE → NOT SURE
              // -----------------------------------------
              onNotSure: () {
                debugPrint('Not sure yet');

                // You can decide later whether
                // "Not sure yet" should go to the
                // Partner Names page or skip this step.
              },
            ),
          ),
        );
      },
    );
  }
}