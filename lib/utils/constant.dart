import 'package:eClassify/data/model/category_model.dart';
import 'package:eClassify/data/model/item_filter_model.dart';
import 'package:eClassify/data/model/system_settings_model.dart';
import 'package:eClassify/settings.dart';
import 'package:eClassify/ui/screens/filter_screen.dart';
import 'package:eClassify/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';

const String svgPath = 'assets/svg/';

class Constant {
  static const String appName = AppSettings.applicationName;
  static const String packageName = AppSettings.packageName;
  static String playstoreURLAndroid = "";
  static String appstoreURLios = "";
  static String iOSAppId = '';
  static const String shareappText = AppSettings.shareAppText;

  //backend url
  static String baseUrl = AppSettings.baseUrl;

  static String isGoogleBannerAdsEnabled = "";
  static String isGoogleInterstitialAdsEnabled = "";
  static String isGoogleNativeAdsEnabled = "1";

  static String bannerAdIdAndroid = '';
  static String bannerAdIdIOS = "";

  static String interstitialAdIdAndroid = '';
  static String interstitialAdIdIOS = '';

  static String nativeAdIdAndroid = '';
  static String nativeAdIdIOS = '';

  static String currencySymbol = "";
  static bool currencyPositionIsLeft = true;
  static String defaultLatitude = "";
  static String defaultLongitude = "";
  static String mobileAuthentication = "";
  static String googleAuthentication = "";
  static String emailAuthentication = "";
  static String appleAuthentication = "";
  static String minRadius = "";
  static String maxRadius = "";
  static String autoApproveEditedItem = "";
  static String otpServiceProvider = "";

  //
  static int otpTimeOutSecond = AppSettings.otpTimeOutSecond; //otp time out
  static int otpResendSecond = AppSettings.otpResendSecond; // resend otp timer
  //

  static String logintypeMobile = "1"; //always 1
  //
  static String maintenanceMode = "0"; //OFF
  static bool isUserDeactivated = false;

  //
  static int loadLimit = AppSettings.apiDataLoadLimit;

  static const String defaultCountryCode = AppSettings.defaultCountryCode;

  static const int maxCategoryLength =
      AppSettings.maxCategoryShowLengthInHomeScreen;

  static const String loadingSuccessLottieFile =
      AppSettings.successLoadingLottieFile;
  static const String successItemLottieFile =
      AppSettings.successCheckLottieFile;
  static const String progressLottieFileWhite =
      AppSettings.progressLottieFileWhite;

  static const String maintenanceModeLottieFile =
      AppSettings.maintenanceModeLottieFile;

  static const bool useLottieProgress = AppSettings.useLottieProgress;

  static const String notificationChannel = AppSettings.notificationChannel;
  static int uploadImageQuality = AppSettings.uploadImageQuality;

  static const int maxSizeInBytes = 2 * 1000000;

  static String? subscriptionPackageId;
  static ItemFilterModel? itemFilter;
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static String typeRent = "rent";
  static String generalNotification = "0";
  static String enquiryNotification = "1";
  static String notificationItemEnquiry = "item_inquiry";
  static String notificationDefault = "default";

  static List<PostedSinceItem> postedSince = [
    PostedSinceItem(status: "allTime", value: "all-time"),
    PostedSinceItem(status: "today", value: "today"),
    PostedSinceItem(status: "within1week", value: "within-1-week"),
    PostedSinceItem(status: "within2week", value: "within-2-week"),
    PostedSinceItem(status: "within1month", value: "within-1-month"),
    PostedSinceItem(status: "within3month", value: "within-3-month"),
  ];

//

  static List<CategoryModel> selectedCategory = [];

  //
  static double borderWidth = 1.5;
  static int nativeAdsAfterItemNumber = 4; //Only add even numbers

  static List<int> interestedItemIds = [];
  static List<int> favoriteItemList = [];

  static Map<SystemSetting, String> systemSettingKeys = {
    SystemSetting.otpServiceProvider: "otp_service_provider",
    SystemSetting.currencySymbol: "currency_symbol",
    SystemSetting.currencySymbolPosition: "currency_symbol_position",
    SystemSetting.freeAdListing: "free_ad_listing",
    SystemSetting.privacyPolicy: "privacy_policy",
    SystemSetting.contactUs: "contact_us",
    SystemSetting.maintenanceMode: "maintenance_mode",
    SystemSetting.termsConditions: "terms_conditions",
    SystemSetting.subscription: "subscription",
    SystemSetting.language: "languages",
    SystemSetting.defaultLanguage: "default_language",
    SystemSetting.forceUpdate: "force_update",
    SystemSetting.androidVersion: "android_version",
    SystemSetting.numberWithSuffix: "number_with_suffix",
    SystemSetting.iosVersion: "ios_version",
    SystemSetting.bannerAdStatus: "banner_ad_status",
    SystemSetting.bannerAdAndroidAd: "banner_ad_id_android",
    SystemSetting.bannerAdiOSAd: "banner_ad_id_ios",
    SystemSetting.interstitialAdStatus: "interstitial_ad_status",
    SystemSetting.interstitialAdAndroidAd: "interstitial_ad_id_android",
    SystemSetting.interstitialAdiOSAd: "interstitial_ad_id_ios",
    SystemSetting.nativeAdStatus: "native_ad_status",
    SystemSetting.nativeAndroidAd: "native_app_id_android",
    SystemSetting.nativeAdiOSAd: "native_app_id_android",
    SystemSetting.playStoreLink: "play_store_link",
    SystemSetting.appStoreLink: "app_store_link",
    SystemSetting.defaultLatitude: "default_latitude",
    SystemSetting.defaultLongitude: "default_longitude",
    SystemSetting.mobileAuthentication: "mobile_authentication",
    SystemSetting.googleAuthentication: "google_authentication",
    SystemSetting.appleAuthentication: "apple_authentication",
    SystemSetting.emailAuthentication: "email_authentication",
    SystemSetting.minRadius: "min_length",
    SystemSetting.maxRadius: "max_length",
    SystemSetting.autoApproveEditedItem: "auto_approve_edited_item",
  };

  static int minChatMessages = 35;

  static bool showExperimentals = true;

  static bool isUpdateAvailable = false;
  static String newVersionNumber = "";
  static bool isNumberWithSuffix = false;

  //Demo mode settings
  static bool isDemoModeOn = false;
  static String demoCountryCode = "91";
  static String demoMobileNumber = "9876598765";
  static String demoModeOTP = "123456";

  static String currentLocale = 'en_US';
  static const countryLocaleMap = {
    'AF': 'ps_AF', // Afghanistan
    'AL': 'sq_AL', // Albania
    'DZ': 'ar_DZ', // Algeria
    'AS': 'en_AS', // American Samoa
    'AD': 'ca_AD', // Andorra
    'AO': 'pt_AO', // Angola
    'AI': 'en_AI', // Anguilla
    'AG': 'en_AG', // Antigua and Barbuda
    'AR': 'es_AR', // Argentina
    'AM': 'hy_AM', // Armenia
    'AU': 'en_AU', // Australia
    'AT': 'de_AT', // Austria
    'AZ': 'az_AZ', // Azerbaijan
    'BS': 'en_BS', // Bahamas
    'BH': 'ar_BH', // Bahrain
    'BD': 'bn_BD', // Bangladesh
    'BB': 'en_BB', // Barbados
    'BY': 'be_BY', // Belarus
    'BE': 'nl_BE', // Belgium
    'BZ': 'en_BZ', // Belize
    'BJ': 'fr_BJ', // Benin
    'BM': 'en_BM', // Bermuda
    'BT': 'dz_BT', // Bhutan
    'BO': 'es_BO', // Bolivia
    'BA': 'bs_BA', // Bosnia and Herzegovina
    'BW': 'en_BW', // Botswana
    'BR': 'pt_BR', // Brazil
    'BN': 'ms_BN', // Brunei
    'BG': 'bg_BG', // Bulgaria
    'BF': 'fr_BF', // Burkina Faso
    'BI': 'fr_BI', // Burundi
    'KH': 'km_KH', // Cambodia
    'CM': 'fr_CM', // Cameroon
    'CA': 'en_CA', // Canada
    'CV': 'pt_CV', // Cape Verde
    'KY': 'en_KY', // Cayman Islands
    'CF': 'fr_CF', // Central African Republic
    'TD': 'fr_TD', // Chad
    'CL': 'es_CL', // Chile
    'CN': 'zh_CN', // China
    'CO': 'es_CO', // Colombia
    'KM': 'ar_KM', // Comoros
    'CG': 'fr_CG', // Congo
    'CR': 'es_CR', // Costa Rica
    'HR': 'hr_HR', // Croatia
    'CU': 'es_CU', // Cuba
    'CY': 'el_CY', // Cyprus
    'CZ': 'cs_CZ', // Czech Republic
    'DK': 'da_DK', // Denmark
    'DJ': 'fr_DJ', // Djibouti
    'DM': 'en_DM', // Dominica
    'DO': 'es_DO', // Dominican Republic
    'EC': 'es_EC', // Ecuador
    'EG': 'ar_EG', // Egypt
    'SV': 'es_SV', // El Salvador
    'GQ': 'es_GQ', // Equatorial Guinea
    'ER': 'ti_ER', // Eritrea
    'EE': 'et_EE', // Estonia
    'SZ': 'en_SZ', // Eswatini
    'ET': 'am_ET', // Ethiopia
    'FJ': 'en_FJ', // Fiji
    'FI': 'fi_FI', // Finland
    'FR': 'fr_FR', // France
    'GA': 'fr_GA', // Gabon
    'GM': 'en_GM', // Gambia
    'GE': 'ka_GE', // Georgia
    'DE': 'de_DE', // Germany
    'GH': 'en_GH', // Ghana
    'GR': 'el_GR', // Greece
    'GD': 'en_GD', // Grenada
    'GU': 'en_GU', // Guam
    'GT': 'es_GT', // Guatemala
    'GN': 'fr_GN', // Guinea
    'GW': 'pt_GW', // Guinea-Bissau
    'GY': 'en_GY', // Guyana
    'HT': 'fr_HT', // Haiti
    'HN': 'es_HN', // Honduras
    'HU': 'hu_HU', // Hungary
    'IS': 'is_IS', // Iceland
    'IN': 'en_IN', // India
    'ID': 'id_ID', // Indonesia
    'IR': 'fa_IR', // Iran
    'IQ': 'ar_IQ', // Iraq
    'IE': 'en_IE', // Ireland
    'IL': 'he_IL', // Israel
    'IT': 'it_IT', // Italy
    'JM': 'en_JM', // Jamaica
    'JP': 'ja_JP', // Japan
    'JO': 'ar_JO', // Jordan
    'KZ': 'kk_KZ', // Kazakhstan
    'KE': 'en_KE', // Kenya
    'KI': 'en_KI', // Kiribati
    'KP': 'ko_KP', // North Korea
    'KR': 'ko_KR', // South Korea
    'KW': 'ar_KW', // Kuwait
    'KG': 'ky_KG', // Kyrgyzstan
    'LA': 'lo_LA', // Laos
    'LV': 'lv_LV', // Latvia
    'LB': 'ar_LB', // Lebanon
    'LS': 'en_LS', // Lesotho
    'LR': 'en_LR', // Liberia
    'LY': 'ar_LY', // Libya
    'LI': 'de_LI', // Liechtenstein
    'LT': 'lt_LT', // Lithuania
    'LU': 'fr_LU', // Luxembourg
    'MG': 'fr_MG', // Madagascar
    'MW': 'en_MW', // Malawi
    'MY': 'ms_MY', // Malaysia
    'MV': 'dv_MV', // Maldives
    'ML': 'fr_ML', // Mali
    'MT': 'mt_MT', // Malta
    'MH': 'en_MH', // Marshall Islands
    'MR': 'ar_MR', // Mauritania
    'MU': 'en_MU', // Mauritius
    'MX': 'es_MX', // Mexico
    'FM': 'en_FM', // Micronesia
    'MD': 'ro_MD', // Moldova
    'MC': 'fr_MC', // Monaco
    'MN': 'mn_MN', // Mongolia
    'ME': 'sr_ME', // Montenegro
    'MA': 'ar_MA', // Morocco
    'MZ': 'pt_MZ', // Mozambique
    'MM': 'my_MM', // Myanmar
    'NA': 'en_NA', // Namibia
    'NR': 'en_NR', // Nauru
    'NP': 'ne_NP', // Nepal
    'NL': 'nl_NL', // Netherlands
    'NZ': 'en_NZ', // New Zealand
    'NI': 'es_NI', // Nicaragua
    'NE': 'fr_NE', // Niger
    'NG': 'en_NG', // Nigeria
    'NO': 'no_NO', // Norway
    'OM': 'ar_OM', // Oman
    'PK': 'ur_PK', // Pakistan
    'PW': 'en_PW', // Palau
    'PS': 'ar_PS', // Palestine
    'PA': 'es_PA', // Panama
    'PG': 'en_PG', // Papua New Guinea
    'PY': 'es_PY', // Paraguay
    'PE': 'es_PE', // Peru
    'PH': 'en_PH', // Philippines
    'PL': 'pl_PL', // Poland
    'PT': 'pt_PT', // Portugal
    'QA': 'ar_QA', // Qatar
    'RO': 'ro_RO', // Romania
    'RU': 'ru_RU', // Russia
    'RW': 'rw_RW', // Rwanda
    'KN': 'en_KN', // Saint Kitts and Nevis
    'LC': 'en_LC', // Saint Lucia
    'VC': 'en_VC', // Saint Vincent and the Grenadines
    'WS': 'en_WS', // Samoa
    'SM': 'it_SM', // San Marino
    'ST': 'pt_ST', // Sao Tome and Principe
    'SA': 'ar_SA', // Saudi Arabia
    'SN': 'fr_SN', // Senegal
    'RS': 'sr_RS', // Serbia
    'SC': 'en_SC', // Seychelles
    'SL': 'en_SL', // Sierra Leone
    'SG': 'en_SG', // Singapore
    'SK': 'sk_SK', // Slovakia
    'SI': 'sl_SI', // Slovenia
    'SB': 'en_SB', // Solomon Islands
    'SO': 'so_SO', // Somalia
    'ZA': 'en_ZA', // South Africa
    'ES': 'es_ES', // Spain
    'LK': 'si_LK', // Sri Lanka
    'SD': 'ar_SD', // Sudan
    'SR': 'nl_SR', // Suriname
    'SE': 'sv_SE', // Sweden
    'CH': 'de_CH', // Switzerland
    'SY': 'ar_SY', // Syria
    'TW': 'zh_TW', // Taiwan
    'TJ': 'tg_TJ', // Tajikistan
    'TZ': 'sw_TZ', // Tanzania
    'TH': 'th_TH', // Thailand
    'TG': 'fr_TG', // Togo
    'TO': 'en_TO', // Tonga
    'TT': 'en_TT', // Trinidad and Tobago
    'TN': 'ar_TN', // Tunisia
    'TR': 'tr_TR', // Turkey
    'TM': 'tk_TM', // Turkmenistan
    'UG': 'en_UG', // Uganda
    'UA': 'uk_UA', // Ukraine
    'AE': 'ar_AE', // United Arab Emirates
    'GB': 'en_GB', // United Kingdom
    'US': 'en_US', // United States
    'UY': 'es_UY', // Uruguay
    'UZ': 'uz_UZ', // Uzbekistan
    'VU': 'en_VU', // Vanuatu
    'VE': 'es_VE', // Venezuela
    'VN': 'vi_VN', // Vietnam
    'YE': 'ar_YE', // Yemen
    'ZM': 'en_ZM', // Zambia
    'ZW': 'en_ZW', // Zimbabwe
  };
}
