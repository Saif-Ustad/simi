import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simi/presentation/period/pages/period_setup_screen.dart';
import '../../../common/widgets/app_bottom_navigation.dart';
import '../../../presentation/chat/pages/chat_details_screen.dart';
import '../../../presentation/chat/pages/create_chat_screen.dart';
import '../../../presentation/chat/pages/custom_chat_screen.dart';
import '../../../presentation/chat/pages/love_chat_conversation_screen.dart';
import '../../../presentation/chat/pages/love_chat_screen.dart';
import '../../../presentation/home/pages/home_screen.dart';
import '../../../presentation/memories/pages/collection_detail_screen.dart';
import '../../../presentation/memories/pages/create_collection_screen.dart';
import '../../../presentation/memories/pages/create_memory_screen.dart';
import '../../../presentation/memories/pages/edit_memory_screen.dart';
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
import '../../../presentation/private_vault/pages/private_vault_home_screen.dart';
import '../../../presentation/private_vault/pages/private_vault_settings_screen.dart';
import '../../../presentation/private_vault/pages/vault_add_item.dart';
import '../../../presentation/private_vault/pages/vault_feature_screen.dart';
import '../../../presentation/private_vault/pages/vault_item_detail_screen.dart';
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
  static const String createMemory = '/memories/create';
  static const String editMemory = '/memories/edit';
  static const String createCollection = '/memories/collection/create';
  static const String collectionDetail = '/memories/collection/detail';
  static const String editCollection = '/memories/collection/edit';

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
  static const String createChat = '/chat/create';
  static const String customChat = '/chat/create/custom';
  static const String chatConversation = '/chat/conversation';
  static const String chatDetails = '/chat/details';


  static const String more = '/more';

  static const String privateVault = '/private-vault';
  static const String privateVaultFeature = '/private-vault/feature';
  static const String addToPrivateVault = '/private-vault/add';
  static const String privateVaultItemDetail = '/private-vault/item-detail';
  static const String privateVaultSettings = '/private-vault/settings';


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
          path: AppRoutes.memories,
          builder: (context, state) {
            // ============================================================
            // ONE MEMORY LIST FOR NOW
            // ============================================================
            final memories = <MemoryItem>[
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
                  AssetImage('assets/images/memories/goa_2.png'),
                  AssetImage('assets/images/memories/goa_3.png'),
                ],
                tags: const ['Travel', 'Special'],
              ),

              MemoryItem(
                title: 'Paris Together',
                description:
                    'We got lost, laughed too much, ate amazing food and '
                    'somehow made the perfect day.',
                date: DateTime(2024, 8, 12),
                folder: 'Travel',
                location: 'Paris',
                tags: const ['Travel', 'Firsts'],
              ),

              MemoryItem(
                title: 'The Proposal',
                description:
                    'The moment everything changed. A memory we will carry '
                    'with us forever.',
                date: DateTime(2024, 12, 24),
                folder: 'Our Story',
                location: 'Mumbai',
                tags: const ['Special', 'Love'],
              ),

              MemoryItem(
                title: 'The Day We Met',
                description:
                    'A simple coffee turned into the beginning of something '
                    'beautiful.',
                date: DateTime(2024, 3, 15),
                folder: 'Our Story',
                location: 'Café',
                tags: const ['Firsts'],
              ),

              MemoryItem(
                title: 'Birthday Together',
                description:
                    'Cake, candles, silly pictures and a night we did not '
                    'want to end.',
                date: DateTime(2023, 11, 8),
                folder: 'Celebrations',
                location: 'Home',
                tags: const ['Birthday', 'Love'],
              ),
            ];

            return MemoriesScreen(
              memories: memories,

              // MEMORY DETAIL
              onMemoryTap: (memory) {
                context.push(AppRoutes.memoryDetail, extra: memory);
              },

              // CREATE MEMORY
              onCreateMemory: () {
                context.push(AppRoutes.createMemory);
              },

              // COLLECTION DETAIL
              onFolderTap: (folder) {
                context.push(
                  AppRoutes.collectionDetail,
                  extra: CollectionDetailArgs(
                    collection: folder,

                    // Send the SAME memory list.
                    memories: memories,
                  ),
                );
              },
            );
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
            final chats = <LoveChatItem>[
              LoveChatItem(
                id: '1',
                title: 'Our Future',
                subtitle: '✨ Future',
                lastMessage:
                'I think Japan would be perfect for us next year.',
                lastMessageAt: DateTime.now().subtract(
                  const Duration(minutes: 18),
                ),
                messageCount: 42,
                icon: Icons.auto_awesome_rounded,
                isUnread: true,
                isFavorite: true,
              ),

              LoveChatItem(
                id: '2',
                title: 'Late Night Thoughts',
                subtitle: '🌙 Deep',
                lastMessage:
                'There is something I have been wanting to tell you...',
                lastMessageAt: DateTime.now().subtract(
                  const Duration(hours: 9),
                ),
                messageCount: 68,
                icon: Icons.nightlight_round,
              ),

              LoveChatItem(
                id: '3',
                title: 'Things I Love About You',
                subtitle: '💕 Appreciation',
                lastMessage:
                'I still love the way you get excited about little things.',
                lastMessageAt: DateTime.now().subtract(
                  const Duration(days: 2),
                ),
                messageCount: 31,
                icon: Icons.favorite_rounded,
                isFavorite: true,
              ),

              LoveChatItem(
                id: '4',
                title: 'Dream Trips',
                subtitle: '✈️ Adventures',
                lastMessage:
                'Okay, adding Switzerland to our list.',
                lastMessageAt: DateTime.now().subtract(
                  const Duration(days: 6),
                ),
                messageCount: 24,
                icon: Icons.flight_takeoff_rounded,
              ),
            ];

            return LoveChatScreen(
              chats: chats,

              onChatTap: (chat) {
                context.push(
                  AppRoutes.chatConversation,
                  extra: chat,
                );
              },

              onCreateChat: () {
                debugPrint('create chat');
                context.push(AppRoutes.createChat);
              },

              onSearch: (query) {
                debugPrint('Search: $query');
              },

              onFavoriteChanged: (chat) {
                debugPrint('Favorite: ${chat.title}');
              },
            );
          },
        ),

        GoRoute(
          path: AppRoutes.more,
          builder: (context, state) {
            return const MoreScreen();
          },
        ),

        //     GoRoute(
        //       path: AppRoutes.privateVault,
        //       builder: (context, state) {
        //         return PrivateVaultHomeScreen(
        //           albums: const [
        //             VaultAlbum(
        //               id: 'us',
        //               name: 'Us',
        //               itemCount: 142,
        //               coverImage: AssetImage(
        //                 'assets/images/memories/goa_cover.png',
        //               ),
        //             ),
        //             VaultAlbum(
        //               id: 'late-nights',
        //               name: 'Late Nights',
        //               itemCount: 45,
        //               coverImage: AssetImage(
        //                 'assets/images/memories/goa_2.png',
        //               ),
        //             ),
        //             VaultAlbum(
        //               id: 'letters',
        //               name: 'Letters',
        //               itemCount: 12,
        //               coverImage: AssetImage(
        //                 'assets/images/memories/goa_3.png',
        //               ),
        //             ),
        //           ],
        //
        //           recentItems: const [
        //             VaultMedia(
        //               id: '1',
        //               title: 'That evening',
        //               subtitle: 'Private',
        //               type: VaultMediaType.photo,
        //               image: AssetImage(
        //                 'assets/images/memories/goa_cover.png',
        //               ),
        //             ),
        //             VaultMedia(
        //               id: '2',
        //               title: 'Our little moment',
        //               subtitle: 'Private',
        //               type: VaultMediaType.photo,
        //               image: AssetImage(
        //                 'assets/images/memories/goa_2.png',
        //               ),
        //             ),
        //             VaultMedia(
        //               id: '3',
        //               title: 'Us',
        //               subtitle: 'Private',
        //               type: VaultMediaType.video,
        //               image: AssetImage(
        //                 'assets/images/memories/goa_3.png',
        //               ),
        //             ),
        //           ],
        //
        //           favoriteItems: const [
        //             VaultMedia(
        //               id: '4',
        //               title: 'Our Anniversary',
        //               subtitle: 'Oct 14, 2025',
        //               type: VaultMediaType.photo,
        //               image: AssetImage(
        //                 'assets/images/memories/goa_cover.png',
        //               ),
        //             ),
        //             VaultMedia(
        //               id: '5',
        //               title: 'Quiet Evening',
        //               subtitle: 'Sep 02, 2025',
        //               type: VaultMediaType.photo,
        //               image: AssetImage(
        //                 'assets/images/memories/goa_2.png',
        //               ),
        //             ),
        //           ],
        //
        //           onAddPhotos: () {
        //             // Next: Add to Vault screen
        //           },
        //
        //           onAddAlbum: () {
        //             // Next: Create Vault Album
        //           },
        //
        //           onLock: () {
        //             // Next: lock the vault
        //           },
        //
        //           onSettings: () {
        //             // Next: Vault Settings
        //           },
        //
        //           onAlbumTap: (album) {
        //             // Next: Album Detail
        //           },
        //
        //           onItemTap: (item) {
        //             // Next: Vault Item Detail
        //           },
        //         );
        //       },
        //     ),

        // ------------------------------------------------------------
        // PRIVATE VAULT
        // ------------------------------------------------------------
        GoRoute(
          path: AppRoutes.privateVault,
          builder: (context, state) {
            return PrivateVaultHomeScreen(
              memoriesCount: 24,
              privateChatsCount: 18,
              specialDatesCount: 6,
              giftWishesCount: 8,
              futureMessagesCount: 5,
              loveNotificationsCount: 12,
              photosCount: 42,
              videosCount: 8,

              onBack: () {
                context.pop();
              },

              onLock: () {
                context.pop();
              },

              onSettings: () {
                context.push(
                  AppRoutes.privateVaultSettings,
                );
              },

              onMemoriesTap: () {
                context.push(
                  AppRoutes.privateVaultFeature,
                  extra: VaultFeatureType.memories,
                );
              },

              onPrivateChatTap: () {
                context.push(
                  AppRoutes.privateVaultFeature,
                  extra: VaultFeatureType.privateChat,
                );
              },

              onSpecialDatesTap: () {
                context.push(
                  AppRoutes.privateVaultFeature,
                  extra: VaultFeatureType.specialDates,
                );
              },

              onGiftWishesTap: () {
                context.push(
                  AppRoutes.privateVaultFeature,
                  extra: VaultFeatureType.giftWishes,
                );
              },

              onFutureMessagesTap: () {
                context.push(
                  AppRoutes.privateVaultFeature,
                  extra: VaultFeatureType.futureMessages,
                );
              },

              onLoveNotificationsTap: () {
                context.push(
                  AppRoutes.privateVaultFeature,
                  extra: VaultFeatureType.loveNotifications,
                );
              },

              onPhotosTap: () {
                context.push(
                  AppRoutes.privateVaultFeature,
                  extra: VaultFeatureType.photos,
                );
              },

              onVideosTap: () {
                context.push(
                  AppRoutes.privateVaultFeature,
                  extra: VaultFeatureType.videos,
                );
              },

              onAddToVault: () {
                context.push(AppRoutes.addToPrivateVault);
              },
            );
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

    // GoRoute(
    //   path: AppRoutes.memories,
    //   builder: (context, state) {
    //     return MemoriesScreen(
    //       memories: [
    //         MemoryItem(
    //           title: 'Our First Trip',
    //           description: 'Our first adventure together.',
    //           date: DateTime(2025, 8, 12),
    //           folder: 'Travel',
    //           location: 'Goa',
    //
    //           coverImage: const AssetImage(
    //             'assets/images/memories/goa_cover.png',
    //           ),
    //           images: const [
    //             AssetImage('assets/images/memories/goa_cover.png'),
    //             AssetImage('assets/images/memories/goa_2.png'),
    //             AssetImage('assets/images/memories/goa_3.png'),
    //           ],
    //
    //           tags: const ['Travel', 'Special'],
    //         ),
    //         MemoryItem(
    //           title: 'The Proposal',
    //           description:
    //               'The moment everything changed. A memory we will carry with us forever.',
    //           date: DateTime(2024, 12, 24),
    //           folder: 'Our Story',
    //           location: 'Mumbai',
    //           tags: const ['Special', 'Love'],
    //         ),
    //
    //         MemoryItem(
    //           title: 'Our First Trip',
    //           description:
    //               'We got lost, laughed too much, ate amazing food and somehow made the perfect day.',
    //           date: DateTime(2024, 8, 12),
    //           folder: 'Travel',
    //           location: 'Paris',
    //           tags: const ['Travel', 'Firsts'],
    //         ),
    //
    //         MemoryItem(
    //           title: 'The Day We Met',
    //           description:
    //               'A simple coffee turned into the beginning of something beautiful.',
    //           date: DateTime(2024, 3, 15),
    //           folder: 'Our Story',
    //           location: 'Café',
    //           tags: const ['Firsts'],
    //         ),
    //
    //         MemoryItem(
    //           title: 'Birthday Together',
    //           description:
    //               'Cake, candles, silly pictures and a night we did not want to end.',
    //           date: DateTime(2023, 11, 8),
    //           folder: 'Celebrations',
    //           location: 'Home',
    //           tags: const ['Birthday', 'Love'],
    //         ),
    //       ],
    //
    //       // ADD THIS
    //       onMemoryTap: (memory) {
    //         context.push(AppRoutes.memoryDetail, extra: memory);
    //       },
    //
    //       onCreateMemory: () {
    //         context.push(AppRoutes.createMemory);
    //       },
    //
    //       onFolderTap: (folder) {
    //         context.push(
    //           AppRoutes.collectionDetail,
    //           extra: CollectionDetailArgs(
    //             collection: folder,
    //             memories: [
    //               MemoryItem(
    //                 title: 'Our First Trip',
    //                 description: 'Our first adventure together.',
    //                 date: DateTime(2025, 8, 12),
    //                 folder: 'Travel',
    //                 location: 'Goa',
    //                 coverImage: const AssetImage(
    //                   'assets/images/memories/goa_cover.png',
    //                 ),
    //                 images: const [
    //                   AssetImage(
    //                     'assets/images/memories/goa_cover.png',
    //                   ),
    //                   AssetImage(
    //                     'assets/images/memories/goa_2.png',
    //                   ),
    //                   AssetImage(
    //                     'assets/images/memories/goa_3.png',
    //                   ),
    //                 ],
    //                 tags: const ['Travel', 'Special'],
    //               ),
    //
    //               MemoryItem(
    //                 title: 'The Proposal',
    //                 description:
    //                 'The moment everything changed. A memory we will carry with us forever.',
    //                 date: DateTime(2024, 12, 24),
    //                 folder: 'Our Story',
    //                 location: 'Mumbai',
    //                 tags: const ['Special', 'Love'],
    //               ),
    //
    //                MemoryItem(
    //                 title: 'Our First Trip',
    //                 description:
    //                 'We got lost, laughed too much, ate amazing food and somehow made the perfect day.',
    //                 date: DateTime(2024, 8, 12),
    //                 folder: 'Travel',
    //                 location: 'Paris',
    //                 tags: ['Travel', 'Firsts'],
    //               ),
    //
    //                MemoryItem(
    //                 title: 'The Day We Met',
    //                 description:
    //                 'A simple coffee turned into the beginning of something beautiful.',
    //                 date: DateTime(2024, 3, 15),
    //                 folder: 'Our Story',
    //                 location: 'Café',
    //                 tags: ['Firsts'],
    //               ),
    //
    //                MemoryItem(
    //                 title: 'Birthday Together',
    //                 description:
    //                 'Cake, candles, silly pictures and a night we did not want to end.',
    //                 date: DateTime(2023, 11, 8),
    //                 folder: 'Celebrations',
    //                 location: 'Home',
    //                 tags: ['Birthday', 'Love'],
    //               ),
    //             ],
    //           ),
    //         );
    //       },
    //
    //
    //     );
    //   },
    // ),
    GoRoute(
      path: AppRoutes.memoryDetail,
      builder: (context, state) {
        final memory = state.extra as MemoryItem;

        return MemoryDetailScreen(
          memory: memory,
          onEdit: () => {context.push(AppRoutes.editMemory, extra: memory)},
        );
      },
    ),

    GoRoute(
      path: AppRoutes.createMemory,
      builder: (context, state) {
        return CreateMemoryScreen(
          collections: const ['Our Travels', 'Date Nights', 'Special Moments'],
          onSave: (data) {
            // We'll connect this to your memory storage later.
            debugPrint(data.title);
            debugPrint(data.photos.length.toString());
            debugPrint(data.coverPhoto?.path);
            debugPrint(data.collection);
          },
          onCreateCollection: (name) {
            debugPrint('Created collection: $name');
          },
        );
      },
    ),

    GoRoute(
      path: AppRoutes.editMemory,
      builder: (context, state) {
        final memory = state.extra as MemoryItem;

        return EditMemoryScreen(
          memory: memory,

          collections: const ['Travel', 'Our Story', 'Celebrations'],

          onSave: (data) {
            debugPrint('Updated memory: ${data.title}');

            debugPrint('Collection: ${data.collection}');

            debugPrint(
              'Photos: ${data.existingPhotos.length + data.newPhotos.length}',
            );

            debugPrint('Tags: ${data.tags}');

            // Later:
            // update the repository/database here.
          },

          onDelete: () {
            debugPrint('Deleted memory: ${memory.title}');

            // Later:
            // delete from repository/database here.
          },
        );
      },
    ),

    GoRoute(
      path: AppRoutes.createCollection,
      builder: (context, state) {
        return CreateCollectionScreen(
          onSave: (data) {
            // Later connect this to your repository/database.
          },
        );
      },
    ),

    GoRoute(
      path: AppRoutes.collectionDetail,
      builder: (context, state) {
        final extra = state.extra as CollectionDetailArgs;

        // ============================================================
        // TEMPORARY CENTRAL MEMORY LIST
        // Keep this here for now.
        // Later we can move it to a repository/database.
        // ============================================================
        final allMemories = <MemoryItem>[
          MemoryItem(
            title: 'Our First Trip',
            description:
                'Our first adventure together. So many little moments '
                'that turned into one beautiful memory.',
            date: DateTime(2025, 8, 12),
            folder: 'Travel',
            location: 'Goa',
            tags: const ['Travel', 'Special'],
          ),

          MemoryItem(
            title: 'Paris Together',
            description:
                'We got lost, laughed too much, ate amazing food and '
                'somehow made the perfect day.',
            date: DateTime(2024, 8, 12),
            folder: 'Travel',
            location: 'Paris',
            tags: const ['Travel', 'Firsts'],
          ),

          MemoryItem(
            title: 'The Proposal',
            description:
                'The moment everything changed. A memory we will carry '
                'with us forever.',
            date: DateTime(2024, 12, 24),
            folder: 'Our Story',
            location: 'Mumbai',
            tags: const ['Special', 'Love'],
          ),

          MemoryItem(
            title: 'The Day We Met',
            description:
                'A simple coffee turned into the beginning of something '
                'beautiful.',
            date: DateTime(2024, 3, 15),
            folder: 'Our Story',
            location: 'Café',
            tags: const ['Firsts'],
          ),

          MemoryItem(
            title: 'Birthday Together',
            description:
                'Cake, candles, silly pictures and a night we did not '
                'want to end.',
            date: DateTime(2023, 11, 8),
            folder: 'Celebrations',
            location: 'Home',
            tags: const ['Birthday', 'Love'],
          ),
        ];

        // Only memories belonging to the selected collection.
        final collectionMemories =
            allMemories
                .where((memory) => memory.folder == extra.collection.name)
                .toList();

        return CollectionDetailScreen(
          collection: extra.collection,

          // IMPORTANT:
          // Use the memories we just created above.
          memories: collectionMemories,

          onMemoryTap: (memory) {
            context.push(AppRoutes.memoryDetail, extra: memory);
          },

          onAddMemory: () {
            context.push(AppRoutes.createMemory, extra: extra.collection.name);
          },

          onCollectionUpdated: (updatedCollection) {
            debugPrint('Collection updated: ${updatedCollection.name}');
          },

          onCollectionDeleted: () {
            debugPrint('Collection deleted: ${extra.collection.name}');

            context.pop();
          },
        );
      },
    ),



    GoRoute(
      path: AppRoutes.privateVaultFeature,
      builder: (context, state) {
        final type = state.extra as VaultFeatureType;

        return VaultFeatureScreen(
          type: type,
          items: getDummyVaultItems(type),

          onBack: () {
            context.pop();
          },

          onAdd: () {
            debugPrint('Add item to $type');
          },

          onItemTap: (item) {
            context.push(
              AppRoutes.privateVaultItemDetail,
              extra: VaultItemDetailArgs(
                type: VaultFeatureType.memories,
                item: item,
              ),
            );
          },

          onMore: () {
            debugPrint('More options');
          },
        );
      },
    ),


    GoRoute(
      path: AppRoutes.addToPrivateVault,
      builder: (context, state) {
        return AddToVaultScreen(
          items: getAvailableVaultItems(),

          onBack: () {
            context.pop();
          },

          onConfirm: (items) {
            for (final item in items) {
              debugPrint(
                'Adding ${item.title} '
                    '(${item.type}) to private vault',
              );
            }

            context.pop();
          },
        );
      },
    ),


    GoRoute(
      path: AppRoutes.privateVaultItemDetail,
      builder: (context, state) {
        final args = state.extra as VaultItemDetailArgs;

        return VaultItemDetailScreen(
          type: args.type,
          item: args.item,

          onBack: () {
            context.pop();
          },

          onFavorite: () {
            debugPrint('Favorite: ${args.item.title}');
          },

          onDelete: () {
            debugPrint('Delete: ${args.item.title}');
            context.pop();
          },

          onOpen: () {
            debugPrint('Open: ${args.item.title}');
          },

          onMore: () {
            debugPrint('More: ${args.item.title}');
          },
        );
      },
    ),



    GoRoute(
      path: AppRoutes.privateVaultSettings,
      builder: (context, state) {
        return PrivateVaultSettingsScreen(
          biometricEnabled: true,
          hidePreviews: true,
          privateNotifications: true,
          autoLock: VaultAutoLock.immediately,

          onBack: () {
            context.pop();
          },

          onLockNow: () {
            debugPrint('Lock vault now');
            context.pop();
          },

          onChangePin: () {
            debugPrint('Change vault PIN');
          },

          onBiometricChanged: (enabled) {
            debugPrint(
              'Biometric unlock: $enabled',
            );
          },

          onHidePreviewsChanged: (enabled) {
            debugPrint(
              'Hide previews: $enabled',
            );
          },

          onPrivateNotificationsChanged: (enabled) {
            debugPrint(
              'Private notifications: $enabled',
            );
          },

          onAutoLockChanged: (value) {
            debugPrint(
              'Auto lock: ${value.label}',
            );
          },

          onClearCache: () {
            debugPrint('Clear vault cache');
          },

          onDeleteVault: () {
            debugPrint('Delete entire vault');
          },
        );
      },
    ),


    GoRoute(
      path: AppRoutes.createChat,
      builder: (context, state) {
        return CreateChatScreen(
          onBack: () => context.pop(),
          onCreateChat: (data) {
            debugPrint('Created chat: ${data.title}');
            debugPrint('Topic: ${data.topic}');
            debugPrint('Prompt: ${data.prompt}');
          },
        );
      },
    ),


    GoRoute(
      path: AppRoutes.customChat,
      builder: (context, state) {
        return CustomChatScreen(
          onBack: () => context.pop(),
          onCreateChat: (data) {
            debugPrint('Custom chat: ${data.title}');
            debugPrint('Topic: ${data.topic}');
            debugPrint('Prompt: ${data.prompt}');
            debugPrint('Icon: ${data.icon}');
          },
        );
      },
    ),

    GoRoute(
      path: AppRoutes.chatConversation,
      builder: (context, state) {
        final chat = state.extra as LoveChatItem;

        return LoveChatConversationScreen(
          chat: chat,
          partnerName: 'Love',
          partnerInitial: 'L',
          messages: [
            LoveChatMessage(
              text: 'I think Japan would be perfect for us next year.',
              time: DateTime.now().subtract(
                const Duration(minutes: 32),
              ),
              isMine: false,
            ),
            LoveChatMessage(
              text: 'Japan? 😭❤️',
              time: DateTime.now().subtract(
                const Duration(minutes: 29),
              ),
              isMine: true,
            ),
            LoveChatMessage(
              text: 'Yes. Imagine us walking through Kyoto together.',
              time: DateTime.now().subtract(
                const Duration(minutes: 27),
              ),
              isMine: false,
            ),
            LoveChatMessage(
              text: 'Okay, now I really want to go.',
              time: DateTime.now().subtract(
                const Duration(minutes: 24),
              ),
              isMine: true,
            ),
          ],
          onBack: () => context.pop(),
          onDetails: () {
            context.push(
              AppRoutes.chatDetails,
              extra: chat,
            );
          },
          onSend: (message) {
            debugPrint('Sent: $message');
          },
        );
      },
    ),


    GoRoute(
      path: AppRoutes.chatDetails,
      builder: (context, state) {
        final chat = state.extra as LoveChatItem;

        return ChatDetailsScreen(
          chat: chat,
          partnerName: 'Love',
          createdAt: DateTime.now().subtract(
            const Duration(days: 18),
          ),
          onBack: () => context.pop(),

          onFavoriteChanged: (value) {
            debugPrint(
              'Favorite ${chat.title}: $value',
            );
          },

          onRename: (name) {
            debugPrint(
              'Renamed ${chat.title} → $name',
            );
          },

          onArchive: () {
            debugPrint(
              'Archived: ${chat.title}',
            );
            context.pop();
          },

          onClearMessages: () {
            debugPrint(
              'Cleared messages: ${chat.title}',
            );
          },

          onDelete: () {
            debugPrint(
              'Deleted: ${chat.title}',
            );
            context.pop();
          },
        );
      },
    ),

  ],
);

class CollectionDetailArgs {
  const CollectionDetailArgs({
    required this.collection,
    required this.memories,
  });

  final MemoryFolder collection;
  final List<MemoryItem> memories;
}



List<VaultFeatureItem> getDummyVaultItems(
    VaultFeatureType type,
    ) {
  switch (type) {
    case VaultFeatureType.memories:
      return [
        VaultFeatureItem(
          title: 'Our First Trip',
          subtitle: 'Our little Goa adventure ❤️',
          dateLabel: '12 Aug 2025',
          image: const AssetImage(
            'assets/images/memories/goa_cover.png',
          ),
          isLocked: true,
        ),
        VaultFeatureItem(
          title: 'The Proposal',
          subtitle: 'The moment everything changed.',
          dateLabel: '24 Dec 2024',
          isLocked: true,
        ),
        VaultFeatureItem(
          title: 'Late Night Drive',
          subtitle: 'Just us, the city and music.',
          dateLabel: '18 Nov 2024',
          isLocked: true,
        ),
      ];

    case VaultFeatureType.privateChat:
      return [
        VaultFeatureItem(
          title: 'Our Secret Conversation',
          subtitle: 'You: "I have something to tell you..."',
          dateLabel: 'Yesterday • 11:42 PM',
          isUnread: true,
          isLocked: true,
        ),
        VaultFeatureItem(
          title: 'Late Night Thoughts',
          subtitle: 'A conversation only we understand.',
          dateLabel: '28 Aug • 12:18 AM',
          isLocked: true,
        ),
      ];

    case VaultFeatureType.specialDates:
      return [
        VaultFeatureItem(
          title: 'Our Anniversary',
          subtitle: 'The day our story began.',
          dateLabel: '15 March',
          isLocked: true,
        ),
        VaultFeatureItem(
          title: 'First Date',
          subtitle: 'That little coffee shop.',
          dateLabel: '28 February',
          isLocked: true,
        ),
      ];

    case VaultFeatureType.giftWishes:
      return [
        VaultFeatureItem(
          title: 'A little gold bracelet',
          subtitle: 'Something I think you would love.',
          dateLabel: 'Added 2 days ago',
          isLocked: true,
        ),
        VaultFeatureItem(
          title: 'That perfume',
          subtitle: 'The one you liked last time.',
          dateLabel: 'Added 18 Aug',
          isLocked: true,
        ),
      ];

    case VaultFeatureType.futureMessages:
      return [
        VaultFeatureItem(
          title: 'For our anniversary',
          subtitle: 'A message waiting for the right day.',
          dateLabel: 'Opens 15 March 2027',
          isLocked: true,
        ),
        VaultFeatureItem(
          title: 'When you need a smile',
          subtitle: 'Something I wrote for you.',
          dateLabel: 'Opens tomorrow',
          isLocked: true,
        ),
      ];

    case VaultFeatureType.loveNotifications:
      return [
        VaultFeatureItem(
          title: 'A little reminder',
          subtitle: 'Tell them you love them today.',
          dateLabel: 'Today',
          isUnread: true,
          isLocked: true,
        ),
        VaultFeatureItem(
          title: 'Date night',
          subtitle: 'Tonight belongs to the two of you.',
          dateLabel: 'Today • 7:00 PM',
          isLocked: true,
        ),
      ];

    case VaultFeatureType.photos:
      return [
        VaultFeatureItem(
          title: 'Us ❤️',
          subtitle: 'Private photo',
          dateLabel: '12 Aug 2025',
          image: const AssetImage(
            'assets/images/memories/goa_cover.png',
          ),
          isLocked: true,
        ),
        VaultFeatureItem(
          title: 'That night',
          subtitle: 'Private photo',
          dateLabel: '24 Dec 2024',
          isLocked: true,
        ),
      ];

    case VaultFeatureType.videos:
      return [
        VaultFeatureItem(
          title: 'Our silly moment',
          subtitle: '00:24',
          dateLabel: '18 Nov 2024',
          isLocked: true,
        ),
        VaultFeatureItem(
          title: 'That night',
          subtitle: '01:12',
          dateLabel: '24 Dec 2024',
          isLocked: true,
        ),
      ];
  }
}


List<VaultAddItem> getAvailableVaultItems() {
  return [
    // Memories
    VaultAddItem(
      id: 'memory_001',
      title: 'Our First Trip',
      subtitle: 'Our little Goa adventure ❤️',
      dateLabel: '12 Aug 2025',
      type: VaultFeatureType.memories,
      image: const AssetImage(
        'assets/images/memories/goa_cover.png',
      ),
    ),

    VaultAddItem(
      id: 'memory_002',
      title: 'Paris Together',
      subtitle: 'The day we got completely lost.',
      dateLabel: '12 Aug 2024',
      type: VaultFeatureType.memories,
    ),

    // Chats
    VaultAddItem(
      id: 'chat_001',
      title: 'Our late night conversation',
      subtitle: 'A private conversation between us.',
      dateLabel: '18 Aug 2026',
      type: VaultFeatureType.privateChat,
    ),

    // Special dates
    VaultAddItem(
      id: 'date_001',
      title: 'Our Anniversary',
      subtitle: 'The day our story began.',
      dateLabel: '15 March',
      type: VaultFeatureType.specialDates,
    ),

    // Gift wishes
    VaultAddItem(
      id: 'gift_001',
      title: 'That necklace',
      subtitle: 'Something I would love someday.',
      type: VaultFeatureType.giftWishes,
    ),

    // Future messages
    VaultAddItem(
      id: 'future_001',
      title: 'Open on our anniversary',
      subtitle: 'A message from us, for us.',
      dateLabel: '15 March 2027',
      type: VaultFeatureType.futureMessages,
    ),

    // Love notifications
    VaultAddItem(
      id: 'love_001',
      title: 'You are my favorite person ❤️',
      subtitle: 'A little love notification.',
      dateLabel: 'Today',
      type: VaultFeatureType.loveNotifications,
    ),

    // Photos
    VaultAddItem(
      id: 'photo_001',
      title: 'Private photo',
      subtitle: 'Added to your gallery.',
      type: VaultFeatureType.photos,
      image: const AssetImage(
        'assets/images/memories/goa_2.png',
      ),
    ),

    // Videos
    VaultAddItem(
      id: 'video_001',
      title: 'Our little video',
      subtitle: 'A private video.',
      dateLabel: '10 Aug 2026',
      type: VaultFeatureType.videos,
    ),
  ];
}


class VaultItemDetailArgs {
  const VaultItemDetailArgs({
    required this.type,
    required this.item,
  });

  final VaultFeatureType type;
  final VaultFeatureItem item;
}