import 'package:flutter/material.dart';
import 'package:shunno_prangon/l10n/app_localizations_en.dart';
import 'package:shunno_prangon/l10n/app_localizations_bn.dart';


abstract class AppLocalizations {
  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  // App Info
  String get appName;
  String get appMotto;

  // Common
  String get save;
  String get cancel;
  String get delete;
  String get edit;
  String get ok;
  String get yes;
  String get no;
  String get loading;
  String get error;
  String get retry;
  String get noData;
  String get search;
  String get filter;
  String get sort;
  String get share;
  String get back;
  String get next;
  String get previous;
  String get done;
  String get skip;

  // Navigation
  String get home;
  String get discover;
  String get create;
  String get profile;
  String get settings;

  // Authentication
  String get login;
  String get register;
  String get logout;
  String get email;
  String get password;
  String get confirmPassword;
  String get forgotPassword;
  String get resetPassword;
  String get name;
  String get signInWithGoogle;
  String get signInWithFacebook;
  String get dontHaveAccount;
  String get alreadyHaveAccount;
  String get createAccount;

  // Articles
  String get articles;
  String get article;
  String get title;
  String get content;
  String get author;
  String get publishedOn;
  String get category;
  String get tags;
  String get readTime;
  String get views;
  String get likes;
  String get comments;
  String get featured;
  String get trending;
  String get recent;
  String get saved;
  String get draft;
  String get publish;
  String get unpublish;
  String get addToReadingList;
  String get removeFromReadingList;
  String get shareArticle;

  // Categories
  String get astronomy;
  String get physics;
  String get chemistry;
  String get spaceExploration;
  String get cosmology;
  String get astrophysics;
  String get particlePhysics;
  String get quantumMechanics;
  String get generalScience;

  // Create Article
  String get createArticle;
  String get editArticle;
  String get articleTitle;
  String get writeYourStory;
  String get selectCategory;
  String get addTags;
  String get saveDraft;
  String get publishArticle;
  String get preview;
  String get addCoverImage;
  String get summary;

  // Search
  String get searchArticles;
  String get searchAuthors;
  String get searchResults;
  String get noSearchResults;
  String get recentSearches;
  String get popularTopics;
  String get suggestions;

  // Profile
  String get myProfile;
  String get editProfile;
  String get myArticles;
  String get savedArticles;
  String get drafts;
  String get bio;
  String get website;
  String get twitter;
  String get linkedin;
  String get github;
  String get joinDate;
  String get articlesCount;
  String get followersCount;
  String get followingCount;

  // Settings
  String get appSettings;
  String get theme;
  String get language;
  String get notifications;
  String get privacy;
  String get about;
  String get lightTheme;
  String get darkTheme;
  String get systemTheme;
  String get bengali;
  String get english;

  // Validation Messages
  String get emailRequired;
  String get invalidEmail;
  String get passwordRequired;
  String get passwordTooShort;
  String get passwordMismatch;
  String get nameRequired;
  String get titleRequired;
  String get contentRequired;
  String get categoryRequired;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'bn'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return Future.value(AppLocalizationsEn());
      case 'bn':
        return Future.value(AppLocalizationsBn());
      default:
        return Future.value(AppLocalizationsEn());
    }
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}