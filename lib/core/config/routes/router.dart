import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simi/presentation/period/pages/period_setup_screen.dart';
import '../../../common/widgets/app_bottom_navigation.dart';
import '../../../presentation/chat/pages/chat_details_screen.dart';
import '../../../presentation/chat/pages/create_chat_screen.dart';
import '../../../presentation/chat/pages/custom_chat_screen.dart';
import '../../../presentation/chat/pages/love_chat_conversation_screen.dart';
import '../../../presentation/chat/pages/love_chat_screen.dart';
import '../../../presentation/future_message/pages/create_future_message_screen.dart';
import '../../../presentation/future_message/pages/future_message_detail_screen.dart';
import '../../../presentation/future_message/pages/future_message_open_screen.dart';
import '../../../presentation/future_message/pages/future_message_review_screen.dart';
import '../../../presentation/future_message/pages/future_message_settings_screen.dart';
import '../../../presentation/future_message/pages/future_message_success_screen.dart';
import '../../../presentation/future_message/pages/future_messages_home_screen.dart';
import '../../../presentation/gift_wishes/pages/create_gift_wish_screen.dart';
import '../../../presentation/gift_wishes/pages/edit_gift_wish_screen.dart';
import '../../../presentation/gift_wishes/pages/gift_wish_categories_screen.dart';
import '../../../presentation/gift_wishes/pages/gift_wish_detail_screen.dart';
import '../../../presentation/gift_wishes/pages/gift_wishes_home_screen.dart';
import '../../../presentation/home/pages/home_screen.dart';
import '../../../presentation/memories/pages/collection_detail_screen.dart';
import '../../../presentation/memories/pages/create_collection_screen.dart';
import '../../../presentation/memories/pages/create_memory_screen.dart';
import '../../../presentation/memories/pages/edit_memory_screen.dart';
import '../../../presentation/memories/pages/memories_screen.dart';
import '../../../presentation/memories/pages/memory_detail_screen.dart';
import '../../../presentation/mood_journal/pages/add_mood_entry_screen.dart';
import '../../../presentation/mood_journal/pages/mood_entry_detail_screen.dart';
import '../../../presentation/mood_journal/pages/mood_journal_home_screen.dart';
import '../../../presentation/more/pages/edit_profile_screen.dart';
import '../../../presentation/more/pages/more_screen.dart';
import '../../../presentation/more/pages/notifications_screen.dart';
import '../../../presentation/more/pages/privacy_security_screen.dart';
import '../../../presentation/more/pages/profile_screen.dart';
import '../../../presentation/more/pages/settings_screen.dart';
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
import '../../../presentation/simi_surprise/pages/simi_surprise_detail_screen.dart';
import '../../../presentation/simi_surprise/pages/simi_surprise_me_screen.dart';
import '../../../presentation/simi_surprise/pages/simi_surprises_home_screen.dart';
import '../../../presentation/simi_surprise/pages/simi_surprises_settings_screen.dart';
import '../../../presentation/special_date/pages/edit_special_date_screen.dart';
import '../../../presentation/special_date/pages/special_date_countdown_screen.dart';
import '../../../presentation/special_date/pages/special_date_date_screen.dart';
import '../../../presentation/special_date/pages/special_date_detail_screen.dart';
import '../../../presentation/special_date/pages/special_date_details_screen.dart';
import '../../../presentation/special_date/pages/special_date_occasion_screen.dart';
import '../../../presentation/special_date/pages/special_date_review_screen.dart';
import '../../../presentation/special_date/pages/special_date_settings_screen.dart';
import '../../../presentation/special_date/pages/special_date_success_screen.dart';
import '../../../presentation/special_date/pages/special_dates_home_screen.dart';
import '../../../presentation/special_date/pages/special_date_category_screen.dart';
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
  static const String settings = '/settings';
  static const String notifications = '/notifications';
  static const String privacySecurity = '/privacy-security';
  static const String profile = '/profile';


  static const String privateVault = '/private-vault';
  static const String privateVaultFeature = '/private-vault/feature';
  static const String addToPrivateVault = '/private-vault/add';
  static const String privateVaultItemDetail = '/private-vault/item-detail';
  static const String privateVaultSettings = '/private-vault/settings';
  static const String editProfile = '/profile/edit';


  static const String giftWishes = '/gift-wishes';
  static const String createGiftWish = '/gift-wishes/create';
  static const String giftWishDetail = '/gift-wishes/detail';
  static const String editGiftWish = '/gift-wishes/edit';
  static const String giftWishCategories = '/gift-wishes/categories';

  static const String specialDates = '/special-dates';
  static const String specialDateDetail = '/special-dates/detail';

  static const String createSpecialDateCategory =
      '/special-dates/create/category';

  static const String createSpecialDateOccasion =
      '/special-dates/create/occasion';

  static const String createSpecialDateDate = '/special-dates/create/date';
  static const String createSpecialDateDetails =
      '/special-dates/create/details';
  static const String specialDateReview = '/special-dates/create/review';
  static const String specialDateSuccess = '/special-dates/create/success';
  static const String specialDateCountdown = '/special-dates/countdown';
  static const String editSpecialDate = '/special-dates/edit';
  static const String specialDateSettings = '/special-dates/settings';

  static const String futureMessages = '/future-messages';
  static const String createFutureMessage = '/future-messages/create';
  static const String futureMessageDetail = '/future-messages/detail';
  static const String futureMessageReview = '/future-messages/review';
  static const String futureMessageSuccess = '/future-messages/success';
  static const String futureMessageEdit = '/future-messages/edit';
  static const String futureMessageSettings = '/future-messages/settings';
  static const String futureMessageOpen = '/future-messages/open';


  static const String moodJournal = '/mood-journal';
  static const String moodEntryDetail = '/mood-journal/detail';
  static const String addMoodEntry = '/mood-journal/add';


  static const String simiSurprises = '/simi-surprises';
  static const String simiSurpriseDetail = '/simi-surprises/detail';
  static const String simiSurprisesSettings = '/simi-surprises/settings';
  static const String simiSurpriseMe = '/simi-surprises/surprise-me';

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
                lastMessage: 'I think Japan would be perfect for us next year.',
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
                lastMessageAt: DateTime.now().subtract(const Duration(days: 2)),
                messageCount: 31,
                icon: Icons.favorite_rounded,
                isFavorite: true,
              ),

              LoveChatItem(
                id: '4',
                title: 'Dream Trips',
                subtitle: '✈️ Adventures',
                lastMessage: 'Okay, adding Switzerland to our list.',
                lastMessageAt: DateTime.now().subtract(const Duration(days: 6)),
                messageCount: 24,
                icon: Icons.flight_takeoff_rounded,
              ),
            ];

            return LoveChatScreen(
              chats: chats,

              onChatTap: (chat) {
                context.push(AppRoutes.chatConversation, extra: chat);
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
                context.push(AppRoutes.privateVaultSettings);
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
            debugPrint('Biometric unlock: $enabled');
          },

          onHidePreviewsChanged: (enabled) {
            debugPrint('Hide previews: $enabled');
          },

          onPrivateNotificationsChanged: (enabled) {
            debugPrint('Private notifications: $enabled');
          },

          onAutoLockChanged: (value) {
            debugPrint('Auto lock: ${value.label}');
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
              time: DateTime.now().subtract(const Duration(minutes: 32)),
              isMine: false,
            ),
            LoveChatMessage(
              text: 'Japan? 😭❤️',
              time: DateTime.now().subtract(const Duration(minutes: 29)),
              isMine: true,
            ),
            LoveChatMessage(
              text: 'Yes. Imagine us walking through Kyoto together.',
              time: DateTime.now().subtract(const Duration(minutes: 27)),
              isMine: false,
            ),
            LoveChatMessage(
              text: 'Okay, now I really want to go.',
              time: DateTime.now().subtract(const Duration(minutes: 24)),
              isMine: true,
            ),
          ],
          onBack: () => context.pop(),
          onDetails: () {
            context.push(AppRoutes.chatDetails, extra: chat);
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
          createdAt: DateTime.now().subtract(const Duration(days: 18)),
          onBack: () => context.pop(),

          onFavoriteChanged: (value) {
            debugPrint('Favorite ${chat.title}: $value');
          },

          onRename: (name) {
            debugPrint('Renamed ${chat.title} → $name');
          },

          onArchive: () {
            debugPrint('Archived: ${chat.title}');
            context.pop();
          },

          onClearMessages: () {
            debugPrint('Cleared messages: ${chat.title}');
          },

          onDelete: () {
            debugPrint('Deleted: ${chat.title}');
            context.pop();
          },
        );
      },
    ),

    GoRoute(
      path: AppRoutes.giftWishes,
      builder: (context, state) {
        final wishes = <GiftWishItem>[
          GiftWishItem(
            id: '1',
            title: 'Sony Headphones',
            description:
                'The ones I keep looking at every time we go shopping.',
            category: 'Tech',
            priority: GiftWishPriority.wouldLove,
            status: GiftWishStatus.wished,
            owner: GiftWishOwner.me,
            addedAt: DateTime.now().subtract(const Duration(days: 2)),
            price: 24999,
            // image: const AssetImage(
            //   'assets/images/gift_wishes/headphones.jpg',
            // ),
            isFavorite: true,
          ),

          GiftWishItem(
            id: '2',
            title: 'That little perfume',
            description: 'I smelled this once and absolutely loved it.',
            category: 'Beauty',
            priority: GiftWishPriority.reallyWant,
            status: GiftWishStatus.planned,
            owner: GiftWishOwner.love,
            addedAt: DateTime.now().subtract(const Duration(days: 5)),
            price: 6800,
          ),

          GiftWishItem(
            id: '3',
            title: 'A weekend in the mountains',
            description: 'Not really a thing. Just somewhere I want us to go.',
            category: 'Travel',
            priority: GiftWishPriority.wouldLove,
            status: GiftWishStatus.wished,
            owner: GiftWishOwner.me,
            addedAt: DateTime.now().subtract(const Duration(days: 11)),
          ),

          GiftWishItem(
            id: '4',
            title: 'The book you mentioned',
            description: 'You said you wanted to read this one.',
            category: 'Books',
            priority: GiftWishPriority.thought,
            status: GiftWishStatus.gifted,
            owner: GiftWishOwner.love,
            addedAt: DateTime.now().subtract(const Duration(days: 20)),
            price: 799,
          ),
        ];

        return GiftWishesHomeScreen(
          wishes: wishes,

          onWishTap: (wish) {
            context.push(AppRoutes.giftWishDetail, extra: wish);
          },

          onCreateWish: () {
            context.push(AppRoutes.createGiftWish);
          },

          onSearch: (query) {
            debugPrint('Gift wish search: $query');
          },

          onFavoriteChanged: (wish) {
            debugPrint('Favorite changed: ${wish.title}');
          },

          onFilterChanged: (filter) {
            debugPrint('Gift wish filter: $filter');
          },

          onCategories: () {
            context.push(AppRoutes.giftWishCategories);
          },
        );
      },
    ),

    GoRoute(
      path: AppRoutes.createGiftWish,
      builder: (context, state) {
        return CreateGiftWishScreen(
          onBack: () => context.pop(),
          onSave: (data) {
            debugPrint('Wish: ${data.title}');
            debugPrint('Category: ${data.category}');
            debugPrint('Priority: ${data.priority}');
            debugPrint('Owner: ${data.owner}');
            debugPrint('Price: ${data.price}');
          },
        );
      },
    ),

    GoRoute(
      path: AppRoutes.giftWishDetail,
      builder: (context, state) {
        final wish = state.extra as GiftWishItem;

        return GiftWishDetailScreen(
          wish: wish,

          onBack: () => context.pop(),

          onEdit: () {
            debugPrint('Edit wish: ${wish.title}');

            context.push(AppRoutes.editGiftWish, extra: wish);
          },

          onDelete: () {
            debugPrint('Deleted wish: ${wish.title}');
            context.pop();
          },

          onFavoriteChanged: (value) {
            debugPrint('Favorite ${wish.title}: $value');
          },

          onMarkAsPlanned: () {
            debugPrint('Marked as planned: ${wish.title}');
          },

          onMarkAsGifted: () {
            debugPrint('Marked as gifted: ${wish.title}');
          },
        );
      },
    ),

    GoRoute(
      path: AppRoutes.editGiftWish,
      builder: (context, state) {
        final wish = state.extra as GiftWishItem;

        return EditGiftWishScreen(
          wish: wish,

          onBack: () => context.pop(),

          onSave: (data) {
            debugPrint('Updated wish: ${data.title}');
            debugPrint('Category: ${data.category}');
            debugPrint('Priority: ${data.priority}');
            debugPrint('Owner: ${data.owner}');
            debugPrint('Price: ${data.price}');
            debugPrint('Remove image: ${data.removeImage}');
            debugPrint('New image: ${data.image?.path}');

            // Later:
            // repository.updateGiftWish(data);
          },

          onDelete: () {
            debugPrint('Deleted wish: ${wish.title}');

            context.pop();
          },
        );
      },
    ),

    // --------------------------------------------------
    // GIFT WISH CATEGORIES
    // --------------------------------------------------
    GoRoute(
      path: AppRoutes.giftWishCategories,
      builder: (context, state) {
        final categories = <GiftWishCategory>[
          const GiftWishCategory(
            name: 'General',
            subtitle: 'Little things that don’t need a box.',
            icon: Icons.auto_awesome_rounded,
            emoji: '✨',
            count: 3,
          ),
          const GiftWishCategory(
            name: 'Tech',
            subtitle: 'Things with screens, buttons and wires.',
            icon: Icons.devices_other_rounded,
            emoji: '🎧',
            count: 4,
          ),
          const GiftWishCategory(
            name: 'Beauty',
            subtitle: 'The little luxuries you secretly love.',
            icon: Icons.spa_outlined,
            emoji: '🌸',
            count: 2,
          ),
          const GiftWishCategory(
            name: 'Fashion',
            subtitle: 'Things you would happily wear.',
            icon: Icons.checkroom_outlined,
            emoji: '👗',
            count: 3,
          ),
          const GiftWishCategory(
            name: 'Books',
            subtitle: 'Stories waiting for the right moment.',
            icon: Icons.menu_book_outlined,
            emoji: '📚',
            count: 2,
          ),
          const GiftWishCategory(
            name: 'Travel',
            subtitle: 'Places and experiences for us.',
            icon: Icons.flight_takeoff_rounded,
            emoji: '✈️',
            count: 3,
          ),
          const GiftWishCategory(
            name: 'Home',
            subtitle: 'Things that make our little space ours.',
            icon: Icons.home_outlined,
            emoji: '🏡',
            count: 1,
          ),
          const GiftWishCategory(
            name: 'Experiences',
            subtitle: 'Moments are sometimes the best gifts.',
            icon: Icons.local_activity_outlined,
            emoji: '🎟️',
            count: 2,
          ),
        ];

        return GiftWishCategoriesScreen(
          categories: categories,

          onBack: () {
            context.pop();
          },

          onCreateWish: () {
            context.push(AppRoutes.createGiftWish);
          },

          onCategoryTap: (category) {
            debugPrint('Selected category: ${category.name}');
          },
        );
      },
    ),

    GoRoute(
      path: AppRoutes.specialDates,
      builder: (context, state) {
        final dates = <SpecialDateItem>[
          SpecialDateItem(
            id: '1',
            title: 'Our Anniversary',
            date: DateTime(2027, 1, 12),
            category: SpecialDateCategory.anniversary,
            description: 'Another year of choosing each other.',
            repeatsYearly: true,
            reminderDays: 7,
            isPinned: true,
          ),

          SpecialDateItem(
            id: '2',
            title: 'First Meeting',
            date: DateTime(2027, 4, 15),
            category: SpecialDateCategory.firstMeeting,
            description: 'The day our story quietly started.',
            repeatsYearly: true,
          ),

          SpecialDateItem(
            id: '3',
            title: 'Our First Trip',
            date: DateTime(2027, 12, 20),
            category: SpecialDateCategory.firstTrip,
            description: 'The trip that gave us so many memories.',
          ),

          SpecialDateItem(
            id: '4',
            title: 'First Date',
            date: DateTime(2026, 4, 5),
            category: SpecialDateCategory.firstDate,
            description: 'That first little date that started everything.',
            status: SpecialDateStatus.past,
          ),
        ];

        return SpecialDatesHomeScreen(
          specialDates: dates,

          onDateTap: (date) {
            context.push(AppRoutes.specialDateDetail, extra: date);
          },

          onAddDate: () {
            context.push(AppRoutes.createSpecialDateCategory);
          },

          onCountdownTap: (date) {
            context.push(AppRoutes.specialDateCountdown, extra: date);
          },

          onSettings: () {
            context.push(AppRoutes.specialDateSettings);
          },

          onSearch: (query) {
            debugPrint('Special date search: $query');
          },
        );
      },
    ),

    GoRoute(
      path: AppRoutes.specialDateDetail,
      builder: (context, state) {
        final specialDate = state.extra as SpecialDateItem;

        return SpecialDateDetailScreen(
          specialDate: specialDate,

          onBack: () {
            context.pop();
          },

          onEdit: () {
            context.push(AppRoutes.editSpecialDate, extra: specialDate);
          },

          onDelete: () {
            debugPrint('Deleted special date: ${specialDate.title}');
            context.pop();
          },

          onCountdown: () {
            context.push(AppRoutes.specialDateCountdown, extra: specialDate);
          },

          onViewMemories: () {
            debugPrint('View memories for: ${specialDate.title}');
          },

          onAddMemory: () {
            debugPrint('Add memory for: ${specialDate.title}');
          },

          onReminderChanged: (enabled) {
            debugPrint('Reminder: $enabled');
          },
        );
      },
    ),

    GoRoute(
      path: AppRoutes.createSpecialDateCategory,
      builder: (context, state) {
        return SpecialDateCategoryScreen(
          onBack: () => context.pop(),

          onCategorySelected: (category) {
            context.push(AppRoutes.createSpecialDateOccasion, extra: category);
          },
        );
      },
    ),

    GoRoute(
      path: AppRoutes.createSpecialDateOccasion,
      builder: (context, state) {
        final category = state.extra as SpecialDateCategory;

        return SpecialDateOccasionScreen(
          category: category,

          onBack: () {
            context.pop();
          },

          onContinue: (title, description) {
            context.push(
              AppRoutes.createSpecialDateDate,
              extra: {
                'category': category,
                'title': title,
                'description': description,
              },
            );
          },
        );
      },
    ),

    GoRoute(
      path: AppRoutes.createSpecialDateDate,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;

        final category = data['category'] as SpecialDateCategory;

        final title = data['title'] as String;

        final description = data['description'] as String;

        return SpecialDateDateScreen(
          category: category,
          title: title,
          description: description,

          onBack: () {
            context.pop();
          },

          onContinue: (date, repeatsYearly) {
            context.push(
              AppRoutes.createSpecialDateDetails,
              extra: {
                'category': category,
                'title': title,
                'description': description,
                'date': date,
                'repeatsYearly': repeatsYearly,
              },
            );
          },
        );
      },
    ),

    GoRoute(
      path: AppRoutes.createSpecialDateDetails,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;

        final category = data['category'] as SpecialDateCategory;

        final title = data['title'] as String;

        final description = data['description'] as String;

        final date = data['date'] as DateTime;

        final repeatsYearly = data['repeatsYearly'] as bool;

        return SpecialDateDetailsScreen(
          category: category,
          title: title,
          description: description,
          date: date,
          repeatsYearly: repeatsYearly,

          onBack: () {
            context.pop();
          },

          onContinue: (reminderDays, note) {
            context.push(
              AppRoutes.specialDateReview,
              extra: {
                'category': category,
                'title': title,
                'description': description,
                'date': date,
                'repeatsYearly': repeatsYearly,
                'reminderDays': reminderDays,
                'note': note,
              },
            );
          },
        );
      },
    ),

    GoRoute(
      path: AppRoutes.specialDateReview,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;

        final category = data['category'] as SpecialDateCategory;

        final title = data['title'] as String;

        final description = data['description'] as String;

        final date = data['date'] as DateTime;

        final repeatsYearly = data['repeatsYearly'] as bool;

        final reminderDays = data['reminderDays'] as int;

        final note = data['note'] as String;

        return SpecialDateReviewScreen(
          category: category,
          title: title,
          description: description,
          date: date,
          repeatsYearly: repeatsYearly,
          reminderDays: reminderDays,
          note: note,

          onBack: () {
            context.pop();
          },

          onSave: () {
            context.push(
              AppRoutes.specialDateSuccess,
              extra: {
                'category': category,
                'title': title,
                'description': description,
                'date': date,
                'repeatsYearly': repeatsYearly,
                'reminderDays': reminderDays,
                'note': note,
              },
            );
          },
        );
      },
    ),

    GoRoute(
      path: AppRoutes.specialDateSuccess,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;

        final category = data['category'] as SpecialDateCategory;

        final title = data['title'] as String;

        final description = data['description'] as String;

        final date = data['date'] as DateTime;

        final repeatsYearly = data['repeatsYearly'] as bool;

        final reminderDays = data['reminderDays'] as int;

        final note = data['note'] as String;

        return SpecialDateSuccessScreen(
          category: category,
          title: title,
          description: description,
          date: date,
          repeatsYearly: repeatsYearly,
          reminderDays: reminderDays,
          note: note,

          onBack: () {
            context.pop();
          },

          onCountdown: () {
            context.push(
              AppRoutes.specialDateCountdown,
              extra: {
                'category': category,
                'title': title,
                'description': description,
                'date': date,
                'repeatsYearly': repeatsYearly,
                'reminderDays': reminderDays,
                'note': note,
              },
            );
          },

          onDone: () {
            context.go(AppRoutes.specialDates);
          },
        );
      },
    ),

    GoRoute(
      path: AppRoutes.specialDateCountdown,
      builder: (context, state) {
        final extra = state.extra;

        late SpecialDateCategory category;
        late String title;
        late String description;
        late DateTime date;
        late bool repeatsYearly;
        late int reminderDays;
        late String note;

        // ------------------------------------------------------------
        // Coming from Special Dates Home / Detail
        // ------------------------------------------------------------
        if (extra is SpecialDateItem) {
          final specialDate = extra;

          category = specialDate.category;
          title = specialDate.title;
          description = specialDate.description;
          date = specialDate.date;
          repeatsYearly = specialDate.repeatsYearly;
          reminderDays = specialDate.reminderDays;
          note = '';
        }
        // ------------------------------------------------------------
        // Coming from Create / Success flow
        // ------------------------------------------------------------
        else if (extra is Map<String, dynamic>) {
          category = extra['category'] as SpecialDateCategory;

          title = extra['title'] as String;

          description = extra['description'] as String;

          date = extra['date'] as DateTime;

          repeatsYearly = extra['repeatsYearly'] as bool;

          reminderDays = extra['reminderDays'] as int;

          note = extra['note'] as String? ?? '';
        }
        // ------------------------------------------------------------
        // Invalid navigation
        // ------------------------------------------------------------
        else {
          return const Scaffold(
            body: Center(child: Text('Unable to open this special date.')),
          );
        }

        return SpecialDateCountdownScreen(
          category: category,
          title: title,
          description: description,
          date: date,
          repeatsYearly: repeatsYearly,
          reminderDays: reminderDays,
          note: note,

          onBack: () {
            context.pop();
          },

          onEdit: () {
            context.push(
              AppRoutes.editSpecialDate,
              extra: {
                'category': category,
                'title': title,
                'description': description,
                'date': date,
                'repeatsYearly': repeatsYearly,
                'reminderDays': reminderDays,
                'note': note,
              },
            );
          },

          onDone: () {
            context.go(AppRoutes.specialDates);
          },
        );
      },
    ),

    GoRoute(
      path: AppRoutes.editSpecialDate,
      builder: (context, state) {
        final extra = state.extra;

        late SpecialDateCategory category;
        late String title;
        late String description;
        late DateTime date;
        late bool repeatsYearly;
        late int reminderDays;
        late String note;

        // ------------------------------------------------------------
        // Coming from Special Dates Home / Detail
        // ------------------------------------------------------------
        if (extra is SpecialDateItem) {
          final specialDate = extra;

          category = specialDate.category;
          title = specialDate.title;
          description = specialDate.description;
          date = specialDate.date;
          repeatsYearly = specialDate.repeatsYearly;
          reminderDays = specialDate.reminderDays;
          note = '';
        }
        // ------------------------------------------------------------
        // Coming from Countdown / other edit flow
        // ------------------------------------------------------------
        else if (extra is Map<String, dynamic>) {
          category = extra['category'] as SpecialDateCategory;

          title = extra['title'] as String;

          description = extra['description'] as String;

          date = extra['date'] as DateTime;

          repeatsYearly = extra['repeatsYearly'] as bool;

          reminderDays = extra['reminderDays'] as int;

          note = extra['note'] as String? ?? '';
        }
        // ------------------------------------------------------------
        // Invalid navigation
        // ------------------------------------------------------------
        else {
          return const Scaffold(
            body: Center(child: Text('Unable to edit this special date.')),
          );
        }

        return EditSpecialDateScreen(
          category: category,
          title: title,
          description: description,
          date: date,
          repeatsYearly: repeatsYearly,
          reminderDays: reminderDays,
          note: note,

          onBack: () {
            context.pop();
          },

          onSave: (updated) {
            debugPrint('Updated special date: ${updated.title}');

            debugPrint('Date: ${updated.date}');

            debugPrint('Category: ${updated.originalCategory}');

            debugPrint('Repeats yearly: ${updated.repeatsYearly}');

            debugPrint('Reminder: ${updated.reminderDays}');

            debugPrint('Note: ${updated.note}');

            // Later:
            // repository.updateSpecialDate(updated);

            context.pop();
          },

          onDelete: () {
            debugPrint('Deleted special date: $title');

            // Later:
            // repository.deleteSpecialDate(...);

            context.go(AppRoutes.specialDates);
          },
        );
      },
    ),

    GoRoute(
      path: AppRoutes.specialDateSettings,
      builder: (context, state) {
        return SpecialDateSettingsScreen(
          notificationsEnabled: true,
          defaultReminder: SpecialDateDefaultReminder.oneWeek,
          yearlyDatesEnabled: true,
          countdownEnabled: true,
          showPastDates: true,

          onBack: () {
            context.pop();
          },

          onNotificationsChanged: (value) {
            debugPrint('Special date notifications: $value');
          },

          onDefaultReminderChanged: (value) {
            debugPrint('Default reminder: $value');
          },

          onYearlyDatesChanged: (value) {
            debugPrint('Yearly dates: $value');
          },

          onCountdownChanged: (value) {
            debugPrint('Countdowns: $value');
          },

          onShowPastDatesChanged: (value) {
            debugPrint('Show past dates: $value');
          },

          onClearPastDates: () {
            debugPrint('Clear past special dates');
          },
        );
      },
    ),


    GoRoute(
      path: AppRoutes.futureMessages,
      builder: (context, state) {
        final messages = <FutureMessageItem>[
          FutureMessageItem(
            id: '1',
            title: 'Open when you miss me',
            description:
            'A small reminder of our trip and all the little moments I want you to remember.',
            createdAt: DateTime.now().subtract(
              const Duration(days: 12),
            ),
            openAt: DateTime.now().add(
              const Duration(days: 14),
            ),
            status: FutureMessageStatus.locked,
            photoCount: 4,
          ),

          FutureMessageItem(
            id: '2',
            title: 'For our anniversary',
            description:
            'I wrote this down today because I know I will want you to read it someday.',
            createdAt: DateTime.now().subtract(
              const Duration(days: 8),
            ),
            openAt: DateTime.now().add(
              const Duration(days: 60),
            ),
            status: FutureMessageStatus.locked,
            isFavorite: true,
          ),

          FutureMessageItem(
            id: '3',
            title: 'A Note from Last Year',
            description:
            'You left this little piece of us here for the future.',
            createdAt: DateTime.now().subtract(
              const Duration(days: 300),
            ),
            openAt: DateTime.now().subtract(
              const Duration(days: 1),
            ),
            status: FutureMessageStatus.ready,
            photoCount: 4,
            voiceDuration: const Duration(seconds: 45),

            voicePath:
            'assets/audio/note_from_last_year.mp3',
          ),

          FutureMessageItem(
            id: '4',
            title: 'Our mountain weekend',
            description:
            'The words we wanted to keep from one of our favorite little escapes.',
            createdAt: DateTime.now().subtract(
              const Duration(days: 400),
            ),
            openAt: DateTime.now().subtract(
              const Duration(days: 30),
            ),
            status: FutureMessageStatus.opened,
            photoCount: 3,
            voiceDuration: const Duration(seconds: 32),
            voicePath:
            'assets/audio/note_from_last_year.mp3',
          ),
        ];

        return FutureMessagesHomeScreen(
          messages: messages,

          onMessageTap: (message) {
            context.push(
              AppRoutes.futureMessageDetail,
              extra: message,
            );
          },

          onCreateMessage: () {
            context.push(
              AppRoutes.createFutureMessage,
            );
          },

          onFavoriteChanged: (message) {
            debugPrint(
              'Favorite changed: ${message.title}',
            );
          },

          onMore: (message) {
            debugPrint(
              'More: ${message.title}',
            );
          },

          onSearch: (query) {
            debugPrint(
              'Future message search: $query',
            );
          },
        );
      },
    ),


    GoRoute(
      path: AppRoutes.createFutureMessage,
      builder: (context, state) {
        return CreateFutureMessageScreen(
          onBack: () {
            context.pop();
          },

          onSave: (data) {
            context.push(
              AppRoutes.futureMessageReview,
              extra: data,
            );
          },
        );
      },
    ),


    GoRoute(
      path: AppRoutes.futureMessageReview,
      builder: (context, state) {
        final data =
        state.extra as CreateFutureMessageData;

        return FutureMessageReviewScreen(
          data: data,

          onBack: () {
            context.pop();
          },

          onEdit: () {
            context.pop();
          },

          onSeal: () {
            context.push(
              AppRoutes.futureMessageSuccess,
              extra: data,
            );
          },
        );
      },
    ),

    GoRoute(
      path: AppRoutes.futureMessageSuccess,
      builder: (context, state) {
        final data =
        state.extra as CreateFutureMessageData;

        return FutureMessageSuccessScreen(
          data: data,

          onViewMessages: () {
            context.go(
              AppRoutes.futureMessages,
            );
          },

          onCreateAnother: () {
            context.go(
              AppRoutes.createFutureMessage,
            );
          },
        );
      },
    ),


    GoRoute(
      path: AppRoutes.futureMessageDetail,
      builder: (context, state) {
        final message =
        state.extra as FutureMessageItem;

        return FutureMessageDetailScreen(
          message: message,

          onBack: () {
            context.pop();
          },

          onOpen: () {
            context.push(
              AppRoutes.futureMessageOpen,
              extra: message,
            );
          },

          onFavoriteChanged: (value) {
            debugPrint(
              'Favorite ${message.title}: $value',
            );
          },

          onMore: () {
            debugPrint(
              'More: ${message.title}',
            );
          },

          onDelete: () {
            debugPrint(
              'Deleted: ${message.title}',
            );

            context.pop();
          },
        );
      },
    ),


    GoRoute(
      path: AppRoutes.futureMessageOpen,
      builder: (context, state) {
        final message =
        state.extra as FutureMessageItem;

        return FutureMessageOpenScreen(
          message: message,

          onBack: () {
            context.pop();
          },

          onOpened: () {
            // Later connect this to repository/database.
            debugPrint(
              'Message opened: ${message.title}',
            );

            // context.pushReplacement(
            //   AppRoutes.futureMessageDetail,
            //   extra: message,
            // );
          },
        );
      },
    ),


    GoRoute(
      path: AppRoutes.futureMessageSettings,
      builder: (context, state) {
        return FutureMessageSettingsScreen(
          notificationsEnabled: true,
          defaultReminder:
          FutureMessageDefaultReminder.oneWeek,
          notificationPreview: true,
          autoMarkAsOpened: true,
          saveAttachments: true,

          onBack: () {
            context.pop();
          },

          onNotificationsChanged: (value) {
            debugPrint(
              'Future message notifications: $value',
            );
          },

          onDefaultReminderChanged: (value) {
            debugPrint(
              'Default reminder: $value',
            );
          },

          onNotificationPreviewChanged: (value) {
            debugPrint(
              'Notification preview: $value',
            );
          },

          onAutoMarkAsOpenedChanged: (value) {
            debugPrint(
              'Auto mark opened: $value',
            );
          },

          onSaveAttachmentsChanged: (value) {
            debugPrint(
              'Save attachments: $value',
            );
          },

          onClearAttachments: () {
            debugPrint(
              'Clear future message attachments',
            );
          },
        );
      },
    ),


    GoRoute(
      path: AppRoutes.moodJournal,
      builder: (context, state) {
        final moods = <MoodEntry>[
          MoodEntry(
            date: DateTime.now(),
            mood: MoodType.loved,
            note: 'Feeling really close to you today ❤️',
            isShared: true, intensity: 0,
          ),
          MoodEntry(
            date: DateTime.now().subtract(
              const Duration(days: 1),
            ),
            mood: MoodType.calm,
            note: 'A peaceful day.', intensity: 0,
          ),
          MoodEntry(
            date: DateTime.now().subtract(
              const Duration(days: 2),
            ),
            mood: MoodType.happy,
            note: 'Had such a good day.', intensity: 0,
          ),
          MoodEntry(
            date: DateTime.now().subtract(
              const Duration(days: 4),
            ),
            mood: MoodType.loved,
            note: 'Missing you a little extra.', intensity: 0,
          ),
          MoodEntry(
            date: DateTime.now().subtract(
              const Duration(days: 6),
            ),
            mood: MoodType.tired, intensity: 0,
          ),
          MoodEntry(
            date: DateTime.now().subtract(
              const Duration(days: 8),
            ),
            mood: MoodType.happy, intensity: 0,
          ),
        ];

        return MoodJournalHomeScreen(
          entries: moods,

          onDateTap: (date) {
            MoodEntry? selectedEntry;

            for (final mood in moods) {
              if (mood.date.year == date.year &&
                  mood.date.month == date.month &&
                  mood.date.day == date.day) {
                selectedEntry = mood;
                break;
              }
            }

            context.push(
              AppRoutes.moodEntryDetail,
              extra: {
                'date': date,
                'entry': selectedEntry,
              },
            );
          },

          onAddMood: () {
            context.push(
              AppRoutes.addMoodEntry,
            );
          },
        );
      },
    ),


    GoRoute(
      path: AppRoutes.addMoodEntry,
      builder: (context, state) {
        return AddMoodEntryScreen(
          onBack: () => context.pop(),

          onSave: (data) {
            debugPrint('Mood: ${data.mood}');
            debugPrint('Date: ${data.date}');
            debugPrint('Intensity: ${data.intensity}');
            debugPrint('Note: ${data.note}');
            debugPrint('Shared: ${data.isShared}');

            context.pop();
          },
        );
      },
    ),


    GoRoute(
      path: AppRoutes.moodEntryDetail,
      builder: (context, state) {
        final data =
        state.extra as Map<String, dynamic>;

        final date =
        data['date'] as DateTime;

        final entry =
        data['entry'] as MoodEntry?;

        return MoodEntryDetailScreen(
          date: date,
          entry: entry,

          onBack: () {
            context.pop();
          },

          onEdit: () {
            context.push(
              AppRoutes.addMoodEntry,
              extra: {
                'date': date,
                'entry': entry,
              },
            );
          },

          onDelete: () {
            debugPrint(
              'Delete mood entry: $date',
            );

            context.pop();
          },

          onAddMood: () {
            context.push(
              AppRoutes.addMoodEntry,
              extra: {
                'date': date,
              },
            );
          },
        );
      },
    ),





    GoRoute(
      path: AppRoutes.simiSurprises,
      builder: (context, state) {
        final surprises = <SimiSurpriseItem>[
          SimiSurpriseItem(
            id: 'memory-1',
            type: SimiSurpriseType.memory,
            title: 'One year ago today',
            message:
            'You were in Goa together. '
                'You saved 6 memories on this day.',
            timeLabel: 'Today',
            actionLabel: 'Relive this memory',
            isNew: true,
          ),

          SimiSurpriseItem(
            id: 'chat-1',
            type: SimiSurpriseType.chat,
            title: 'A little coincidence',
            message:
            'You mentioned Japan 4 times this month. '
                'Maybe someone really wants to go. ✈️',
            timeLabel: '18 min ago',
            actionLabel: 'See your conversations',
          ),

          SimiSurpriseItem(
            id: 'mood-1',
            type: SimiSurpriseType.mood,
            title: 'Something SIMI noticed',
            message:
            'You felt loved 3 times this week. '
                'That feels like a nice little pattern.',
            timeLabel: 'Today',
            actionLabel: 'See your moods',
          ),

          SimiSurpriseItem(
            id: 'date-1',
            type: SimiSurpriseType.specialDate,
            title: 'It\'s getting close',
            message:
            'Your first date is in 8 days. '
                'Maybe it deserves a little something this year.',
            timeLabel: '8 days away',
            actionLabel: 'See special date',
          ),

          SimiSurpriseItem(
            id: 'future-1',
            type: SimiSurpriseType.futureMessage,
            title: 'Someone from the past',
            message:
            'A message you wrote 30 days ago '
                'is ready to be opened.',
            timeLabel: 'Ready now',
            actionLabel: 'Open your message',
            isNew: true,
          ),

          SimiSurpriseItem(
            id: 'period-1',
            type: SimiSurpriseType.period,
            title: 'Your rhythm',
            message:
            'Your next period may be approaching '
                'in 4 days.',
            timeLabel: '4 days away',
            actionLabel: 'See your period',
          ),

          SimiSurpriseItem(
            id: 'gift-1',
            type: SimiSurpriseType.giftWish,
            title: 'You might have forgotten this',
            message:
            'Those headphones have been sitting '
                'in your wishes for 3 months.',
            timeLabel: '3 months ago',
            actionLabel: 'See the wish',
          ),

          SimiSurpriseItem(
            id: 'milestone-1',
            type: SimiSurpriseType.milestone,
            title: 'You just reached 100 memories',
            message:
            '100 little pieces of your story, '
                'all kept together.',
            timeLabel: 'Just now',
            actionLabel: 'Look through them',
            isFeatured: true,
          ),
        ];

        return SimiSurprisesHomeScreen(
          surprises: surprises,
          totalMoments: 128,

          onSurpriseTap: (item) {
            context.push(
              AppRoutes.simiSurpriseDetail,
              extra: item,
            );
          },

          onSurpriseUs: () {
            context.push(
              AppRoutes.simiSurpriseMe,
              extra: surprises,
            );
          },

          onSettings: () {
            context.push(AppRoutes.simiSurprisesSettings);
          },

          onSearch: (query) {
            debugPrint(
              'Search SIMI surprises: $query',
            );
          },
        );
      },
    ),


    GoRoute(
      path: AppRoutes.simiSurpriseDetail,
      builder: (context, state) {
        final surprise =
        state.extra as SimiSurpriseItem;

        return SimiSurpriseDetailScreen(
          surprise: surprise,

          onBack: () => context.pop(),

          onOpenOriginal: () {
            debugPrint(
              'Open original: ${surprise.type}',
            );

            // Later we connect each type:
            //
            // Memory       → MemoryDetailScreen
            // Chat         → LoveChatConversationScreen
            // Period       → PeriodHomeScreen
            // Special Date → SpecialDateDetailScreen
            // Future Msg   → FutureMessageDetailScreen
            // Mood         → MoodEntryDetailScreen
            // Gift Wish    → GiftWishDetailScreen
          },

          onFavorite: () {
            debugPrint(
              'Favorite surprise: ${surprise.id}',
            );
          },

          onDismiss: () {
            debugPrint(
              'Dismiss surprise: ${surprise.id}',
            );
            context.pop();
          },
        );
      },
    ),



    GoRoute(
      path: AppRoutes.simiSurprisesSettings,
      builder: (context, state) {
        return SimiSurprisesSettingsScreen(
          surprisesEnabled: true,

          memoriesEnabled: true,
          chatEnabled: true,
          periodEnabled: true,
          specialDatesEnabled: true,
          futureMessagesEnabled: true,
          moodJournalEnabled: true,
          giftWishesEnabled: true,

          notificationEnabled: true,

          onBack: () => context.pop(),

          onSurprisesChanged: (value) {
            debugPrint('SIMI Surprises: $value');
          },

          onMemoriesChanged: (value) {
            debugPrint('Memory surprises: $value');
          },

          onChatChanged: (value) {
            debugPrint('Chat surprises: $value');
          },

          onPeriodChanged: (value) {
            debugPrint('Period surprises: $value');
          },

          onSpecialDatesChanged: (value) {
            debugPrint('Special date surprises: $value');
          },

          onFutureMessagesChanged: (value) {
            debugPrint('Future message surprises: $value');
          },

          onMoodJournalChanged: (value) {
            debugPrint('Mood surprises: $value');
          },

          onGiftWishesChanged: (value) {
            debugPrint('Gift wish surprises: $value');
          },

          onNotificationChanged: (value) {
            debugPrint('Surprise notifications: $value');
          },
        );
      },
    ),


    GoRoute(
      path: AppRoutes.simiSurpriseMe,
      builder: (context, state) {
        final surprises =
        state.extra as List<SimiSurpriseItem>;

        return SimiSurpriseMeScreen(
          surprises: surprises,

          onBack: () => context.pop(),

          onOpenSurprise: (surprise) {
            context.push(
              AppRoutes.simiSurpriseDetail,
              extra: surprise,
            );
          },
        );
      },
    ),


    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) {
        return SettingsScreen(
          userName: 'You',
          partnerName: 'Love',
          userInitial: 'Y',
          partnerInitial: 'L',

          onBack: () {
            context.pop();
          },

          onProfile: () {
            context.push(AppRoutes.profile);
          },

          onNotifications: () {
            context.push(
              AppRoutes.notifications,
            );
          },

          onPrivacySecurity: () {
            context.push(
              AppRoutes.privacySecurity,
            );
          },

          onAppearance: () {
            debugPrint('Appearance');
          },

          onRelationship: () {
            debugPrint('Relationship settings');
          },

          onDataStorage: () {
            debugPrint('Data & storage');
          },

          onAbout: () {
            debugPrint('About SIMI');
          },

          onHelp: () {
            debugPrint('Help & support');
          },

          onFeedback: () {
            debugPrint('Send feedback');
          },

          onLogout: () {
            debugPrint('Logout');
          },
        );
      },
    ),


    GoRoute(
      path: AppRoutes.notifications,
      builder: (context, state) {
        return NotificationsScreen(
          notificationsEnabled: true,

          loveMessages: true,
          specialDates: true,
          memories: true,
          futureMessages: true,
          moodUpdates: true,
          giftWishes: true,
          simiSurprises: true,

          notificationPreview: true,
          sound: true,
          vibration: true,

          onBack: () => context.pop(),

          onNotificationsChanged: (value) {
            debugPrint(
              'Notifications: $value',
            );
          },

          onLoveMessagesChanged: (value) {
            debugPrint(
              'Love messages: $value',
            );
          },

          onSpecialDatesChanged: (value) {
            debugPrint(
              'Special dates: $value',
            );
          },

          onMemoriesChanged: (value) {
            debugPrint(
              'Memories notifications: $value',
            );
          },

          onFutureMessagesChanged: (value) {
            debugPrint(
              'Future message notifications: $value',
            );
          },

          onMoodUpdatesChanged: (value) {
            debugPrint(
              'Mood notifications: $value',
            );
          },

          onGiftWishesChanged: (value) {
            debugPrint(
              'Gift wish notifications: $value',
            );
          },

          onSimiSurprisesChanged: (value) {
            debugPrint(
              'SIMI Surprises: $value',
            );
          },

          onPreviewChanged: (value) {
            debugPrint(
              'Notification preview: $value',
            );
          },

          onSoundChanged: (value) {
            debugPrint(
              'Notification sound: $value',
            );
          },

          onVibrationChanged: (value) {
            debugPrint(
              'Notification vibration: $value',
            );
          },
        );
      },
    ),

    GoRoute(
      path: AppRoutes.privacySecurity,
      builder: (context, state) {
        return PrivacySecurityScreen(
          appLockEnabled: true,
          biometricEnabled: true,
          hideNotificationPreviews: true,
          appSwitcherPrivacy: true,
          screenshotProtection: true,
          privateContentEnabled: true,
          analyticsEnabled: false,
          crashReportsEnabled: true,

          onBack: () => context.pop(),

          onAppLockChanged: (value) {
            debugPrint(
              'App lock: $value',
            );
          },

          onBiometricChanged: (value) {
            debugPrint(
              'Biometric: $value',
            );
          },

          onNotificationPreviewChanged: (value) {
            debugPrint(
              'Hide notification previews: $value',
            );
          },

          onAppSwitcherPrivacyChanged: (value) {
            debugPrint(
              'App switcher privacy: $value',
            );
          },

          onScreenshotProtectionChanged: (value) {
            debugPrint(
              'Screenshot protection: $value',
            );
          },

          onPrivateContentChanged: (value) {
            debugPrint(
              'Private content: $value',
            );
          },

          onAnalyticsChanged: (value) {
            debugPrint(
              'Analytics: $value',
            );
          },

          onCrashReportsChanged: (value) {
            debugPrint(
              'Crash reports: $value',
            );
          },

          onChangePin: () {
            debugPrint('Change PIN');
          },

          onManagePrivateContent: () {
            debugPrint(
              'Manage private content',
            );
          },

          onExportData: () {
            debugPrint('Export SIMI data');
          },

          onDeleteAccount: () {
            debugPrint('Delete SIMI data');
          },
        );
      },
    ),


    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) {
        return ProfileScreen(
          name: 'Saif',
          partnerName: 'Love',
          initial: 'S',
          bio: 'A little corner of the world, just for us.',
          relationshipLabel: 'Together',
          relationshipStartDate: DateTime(2024, 2, 14),
          city: 'Mumbai',
          favoriteMemory: 'Our first trip together',
          memoriesCount: 24,
          specialDatesCount: 6,
          giftWishesCount: 8,
          photosCount: 42,

          onBack: () => context.pop(),

          onEditProfile: () {
            context.push(
              AppRoutes.editProfile,
            );
          },

          onChangePhoto: () {
            debugPrint('Change profile photo');
          },

          onRelationshipTap: () {
            debugPrint('Relationship details');
          },
        );
      },
    ),


    GoRoute(
      path: AppRoutes.editProfile,
      builder: (context, state) {
        return EditProfileScreen(
          name: 'Saif',
          partnerName: 'Love',
          bio: 'A little corner of the world, just for us.',
          relationshipLabel: 'Together',
          relationshipStartDate:
          DateTime(2024, 2, 14),
          city: 'Mumbai',
          favoriteMemory:
          'Our first trip together',

          onBack: () => context.pop(),

          onSave: (data) {
            debugPrint(
              'Profile saved: ${data.name}',
            );
            debugPrint(
              'Partner: ${data.partnerName}',
            );
            debugPrint(
              'Bio: ${data.bio}',
            );
            debugPrint(
              'Relationship: ${data.relationshipLabel}',
            );
            debugPrint(
              'Date: ${data.relationshipStartDate}',
            );
            debugPrint(
              'City: ${data.city}',
            );
            debugPrint(
              'Favorite memory: ${data.favoriteMemory}',
            );
            debugPrint(
              'New photo: ${data.profileImage?.path}',
            );
            debugPrint(
              'Remove photo: ${data.removeProfileImage}',
            );

            // Later:
            // repository.updateProfile(data);
          },

          onChangePhoto: () {
            debugPrint('Change profile photo');
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

List<VaultFeatureItem> getDummyVaultItems(VaultFeatureType type) {
  switch (type) {
    case VaultFeatureType.memories:
      return [
        VaultFeatureItem(
          title: 'Our First Trip',
          subtitle: 'Our little Goa adventure ❤️',
          dateLabel: '12 Aug 2025',
          image: const AssetImage('assets/images/memories/goa_cover.png'),
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
          image: const AssetImage('assets/images/memories/goa_cover.png'),
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
      image: const AssetImage('assets/images/memories/goa_cover.png'),
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
      image: const AssetImage('assets/images/memories/goa_2.png'),
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
  const VaultItemDetailArgs({required this.type, required this.item});

  final VaultFeatureType type;
  final VaultFeatureItem item;
}
