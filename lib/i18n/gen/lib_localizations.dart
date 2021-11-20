
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'lib_localizations_en.dart';
import 'lib_localizations_zh.dart';

/// Callers can lookup localized strings with an instance of LibLocalizations returned
/// by `LibLocalizations.of(context)`.
///
/// Applications need to include `LibLocalizations.delegate()` in their app's
/// localizationDelegates list, and the locales they support in the app's
/// supportedLocales list. For example:
///
/// ```
/// import 'gen/lib_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: LibLocalizations.localizationsDelegates,
///   supportedLocales: LibLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the LibLocalizations.supportedLocales
/// property.
abstract class LibLocalizations {
  LibLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static LibLocalizations of(BuildContext context) {
    return Localizations.of<LibLocalizations>(context, LibLocalizations)!;
  }

  static const LocalizationsDelegate<LibLocalizations> delegate = _LibLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
    Locale('zh', 'TW')
  ];

  /// No description provided for @searchButtonText.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchButtonText;

  /// No description provided for @loadingLabel.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loadingLabel;

  /// No description provided for @tapToRetryButtonText.
  ///
  /// In en, this message translates to:
  /// **'Tap to retry'**
  String get tapToRetryButtonText;

  /// No description provided for @refreshButtonText.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refreshButtonText;

  /// No description provided for @retryButtonText.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryButtonText;

  /// No description provided for @okButtonText.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get okButtonText;

  /// No description provided for @cancelButtonText.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButtonText;

  /// No description provided for @closeButtonText.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeButtonText;

  /// No description provided for @yesButtonText.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yesButtonText;

  /// No description provided for @noButtonText.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get noButtonText;

  /// No description provided for @addButtonText.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addButtonText;

  /// No description provided for @deleteButtonText.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteButtonText;

  /// No description provided for @saveButtonText.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButtonText;

  /// No description provided for @backButtonText.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backButtonText;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorTitle;

  /// No description provided for @errorMessage.
  ///
  /// In en, this message translates to:
  /// **'Oops, something went wrong'**
  String get errorMessage;

  /// No description provided for @errorNotified.
  ///
  /// In en, this message translates to:
  /// **'The developer team has been notified of this issue, Please try again later'**
  String get errorNotified;

  /// No description provided for @errorEmailUsLink.
  ///
  /// In en, this message translates to:
  /// **'Send email to support team'**
  String get errorEmailUsLink;

  /// No description provided for @errorNetworkSlowMessage.
  ///
  /// In en, this message translates to:
  /// **'your network is slow than usual'**
  String get errorNetworkSlowMessage;

  /// No description provided for @errorNetworkNoServiceMessage.
  ///
  /// In en, this message translates to:
  /// **'This service isn\'t available right now, Please try again later'**
  String get errorNetworkNoServiceMessage;

  /// No description provided for @errorNetworkNoInternetMessage.
  ///
  /// In en, this message translates to:
  /// **'Poor network connection detected, Please check your connectivity'**
  String get errorNetworkNoInternetMessage;

  /// No description provided for @errorNetworkBlockedMessage.
  ///
  /// In en, this message translates to:
  /// **'Our service is blocked by your Firewall or antivirus software'**
  String get errorNetworkBlockedMessage;

  /// No description provided for @errorNetworkTimeoutMessage.
  ///
  /// In en, this message translates to:
  /// **'Your operation didn\'t complete in time, Please try again later'**
  String get errorNetworkTimeoutMessage;

  /// No description provided for @errorDiskErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Write failed!, Insufficient disk space or write access denied'**
  String get errorDiskErrorMessage;

  /// No description provided for @errorFirewallBlockShort.
  ///
  /// In en, this message translates to:
  /// **'Processing Request. Please Wait'**
  String get errorFirewallBlockShort;

  /// No description provided for @errorFirewallBlockLong.
  ///
  /// In en, this message translates to:
  /// **'Too many failed attempts, Please try again tomorrow'**
  String get errorFirewallBlockLong;

  /// No description provided for @errorFirewallInFlight.
  ///
  /// In en, this message translates to:
  /// **'Please wait while we are processing your request'**
  String get errorFirewallInFlight;

  /// No description provided for @errorFirewallOverflow.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts, Please try again later'**
  String get errorFirewallOverflow;

  /// No description provided for @emailField.
  ///
  /// In en, this message translates to:
  /// **'email address'**
  String get emailField;

  /// No description provided for @domainField.
  ///
  /// In en, this message translates to:
  /// **'domain name'**
  String get domainField;

  /// No description provided for @urlField.
  ///
  /// In en, this message translates to:
  /// **'url'**
  String get urlField;

  /// No description provided for @fieldHintYouMean.
  ///
  /// In en, this message translates to:
  /// **'Did you mean: '**
  String get fieldHintYouMean;

  /// No description provided for @fieldEnterYour.
  ///
  /// In en, this message translates to:
  /// **'Enter your %1'**
  String get fieldEnterYour;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This Field is required.'**
  String get fieldRequired;

  /// No description provided for @fieldValueInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid %1.  (Example: %2)'**
  String get fieldValueInvalid;

  /// No description provided for @fieldTextTooShort.
  ///
  /// In en, this message translates to:
  /// **'%1 must contain at least %2 character. You entered %3 characters'**
  String get fieldTextTooShort;

  /// No description provided for @fieldTextTooLong.
  ///
  /// In en, this message translates to:
  /// **'%1 must be %2 characters or fewer. You entered %3 characters'**
  String get fieldTextTooLong;

  /// No description provided for @scanQRButtonText.
  ///
  /// In en, this message translates to:
  /// **'Scan QR code'**
  String get scanQRButtonText;

  /// No description provided for @pagingMany.
  ///
  /// In en, this message translates to:
  /// **'of many'**
  String get pagingMany;

  /// No description provided for @pagingCount.
  ///
  /// In en, this message translates to:
  /// **'of %1'**
  String get pagingCount;

  /// No description provided for @noDataLabel.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get noDataLabel;

  /// No description provided for @archiveButtonText.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archiveButtonText;

  /// No description provided for @imageSaveButtonText.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get imageSaveButtonText;

  /// No description provided for @imageResizeButtonText.
  ///
  /// In en, this message translates to:
  /// **'Resize Image'**
  String get imageResizeButtonText;

  /// No description provided for @imageFlipButtonText.
  ///
  /// In en, this message translates to:
  /// **'Flip'**
  String get imageFlipButtonText;

  /// No description provided for @imageRotateLeftButtonText.
  ///
  /// In en, this message translates to:
  /// **'Rotate Left'**
  String get imageRotateLeftButtonText;

  /// No description provided for @imageRotateRightButtonText.
  ///
  /// In en, this message translates to:
  /// **'Rotate Right'**
  String get imageRotateRightButtonText;

  /// No description provided for @imageResetButtonText.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get imageResetButtonText;

  /// No description provided for @permissionAsk.
  ///
  /// In en, this message translates to:
  /// **'This app requires access to the %1 , do you want allow it in app setting?'**
  String get permissionAsk;

  /// No description provided for @permissionBluetooth.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth'**
  String get permissionBluetooth;

  /// No description provided for @permissionCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get permissionCamera;

  /// No description provided for @permissionLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get permissionLocation;

  /// No description provided for @permissionPhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get permissionPhoto;

  /// No description provided for @permissionNotification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get permissionNotification;

  /// No description provided for @permissionMic.
  ///
  /// In en, this message translates to:
  /// **'Microphone'**
  String get permissionMic;

  /// No description provided for @permissionGotoSetting.
  ///
  /// In en, this message translates to:
  /// **'Go to setting'**
  String get permissionGotoSetting;

  /// No description provided for @uploadDrop.
  ///
  /// In en, this message translates to:
  /// **'Drop your image here, or '**
  String get uploadDrop;

  /// No description provided for @uploadBrowse.
  ///
  /// In en, this message translates to:
  /// **'tap to browse'**
  String get uploadBrowse;

  /// No description provided for @uploadDropHere.
  ///
  /// In en, this message translates to:
  /// **'Drop files here'**
  String get uploadDropHere;

  /// No description provided for @uploadButtonText.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get uploadButtonText;

  /// No description provided for @uploadImageTooBig.
  ///
  /// In en, this message translates to:
  /// **'image file is too big. your image size is %1, try sending a file smaller than %2'**
  String get uploadImageTooBig;

  /// No description provided for @uploadImageNotValid.
  ///
  /// In en, this message translates to:
  /// **'not a valid image. Only JPG, PNG, GIF and WEBP files are allowed'**
  String get uploadImageNotValid;

  /// No description provided for @ticketTypeReceipt.
  ///
  /// In en, this message translates to:
  /// **'Receipt'**
  String get ticketTypeReceipt;

  /// No description provided for @ticketTypeCopy.
  ///
  /// In en, this message translates to:
  /// **'Receipt Copy'**
  String get ticketTypeCopy;

  /// No description provided for @ticketTypeOrder.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get ticketTypeOrder;

  /// No description provided for @ticketOrderTakeout.
  ///
  /// In en, this message translates to:
  /// **'Take Out'**
  String get ticketOrderTakeout;

  /// No description provided for @ticketOrderDelivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get ticketOrderDelivery;

  /// No description provided for @ticketOrderDineIn.
  ///
  /// In en, this message translates to:
  /// **'Dine in'**
  String get ticketOrderDineIn;

  /// No description provided for @ticketItemCount.
  ///
  /// In en, this message translates to:
  /// **'Item Count: %1'**
  String get ticketItemCount;

  /// No description provided for @ticketPickup.
  ///
  /// In en, this message translates to:
  /// **'Pickup'**
  String get ticketPickup;

  /// No description provided for @ticketSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get ticketSubtotal;

  /// No description provided for @ticketTax.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get ticketTax;

  /// No description provided for @ticketService.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get ticketService;

  /// No description provided for @ticketTip.
  ///
  /// In en, this message translates to:
  /// **'Tip'**
  String get ticketTip;

  /// No description provided for @ticketTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get ticketTotal;

  /// No description provided for @ticketPaperSize.
  ///
  /// In en, this message translates to:
  /// **'Paper Size'**
  String get ticketPaperSize;

  /// No description provided for @ticket58mm.
  ///
  /// In en, this message translates to:
  /// **'58 mm'**
  String get ticket58mm;

  /// No description provided for @ticket80mm.
  ///
  /// In en, this message translates to:
  /// **'80 mm'**
  String get ticket80mm;

  /// No description provided for @errorPrint.
  ///
  /// In en, this message translates to:
  /// **'Failed to Print on %1'**
  String get errorPrint;

  /// No description provided for @networkPrinter.
  ///
  /// In en, this message translates to:
  /// **'Network Printer'**
  String get networkPrinter;

  /// No description provided for @bluetoothPrinter.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth Printer'**
  String get bluetoothPrinter;

  /// No description provided for @printerList.
  ///
  /// In en, this message translates to:
  /// **'Printer List'**
  String get printerList;

  /// No description provided for @printerName.
  ///
  /// In en, this message translates to:
  /// **'Printer Name'**
  String get printerName;

  /// No description provided for @printerNameExists.
  ///
  /// In en, this message translates to:
  /// **'%1 already been used. please try another name'**
  String get printerNameExists;

  /// No description provided for @printerNameHint.
  ///
  /// In en, this message translates to:
  /// **'Give printer a name (e.g. Kitchen)'**
  String get printerNameHint;

  /// No description provided for @printerNeedIP.
  ///
  /// In en, this message translates to:
  /// **'Please input the printer IP address'**
  String get printerNeedIP;

  /// No description provided for @printerNeedBT.
  ///
  /// In en, this message translates to:
  /// **'Please select a Bluetooth Printer'**
  String get printerNeedBT;

  /// No description provided for @printerIP.
  ///
  /// In en, this message translates to:
  /// **'Printer\"s IP Address'**
  String get printerIP;

  /// No description provided for @printerIPHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 192.168.1.2'**
  String get printerIPHint;

  /// No description provided for @printerIPNotValid.
  ///
  /// In en, this message translates to:
  /// **'%1 is not a valid IP. (Example: 192.168.1.2)'**
  String get printerIPNotValid;

  /// No description provided for @printerFindIP.
  ///
  /// In en, this message translates to:
  /// **'How to Print Printer\"s IP Address'**
  String get printerFindIP;

  /// No description provided for @bluetoothPrinterNotSupport.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth printer only support on iPhone or Android device. and you need enable bluetooth permission in app settings'**
  String get bluetoothPrinterNotSupport;

  /// No description provided for @bluetoothPrinterHint.
  ///
  /// In en, this message translates to:
  /// **'Click Search to select bluetooth device'**
  String get bluetoothPrinterHint;

  /// No description provided for @printTestPage.
  ///
  /// In en, this message translates to:
  /// **'Print Test Page'**
  String get printTestPage;

  /// No description provided for @printAutoLabel.
  ///
  /// In en, this message translates to:
  /// **'Automatically print when receive'**
  String get printAutoLabel;

  /// No description provided for @errorConnect.
  ///
  /// In en, this message translates to:
  /// **'Cannot Connect to the printer, make sure printer is turned on, and connected to the network, also IP address is correct'**
  String get errorConnect;

  /// No description provided for @errorTimeout.
  ///
  /// In en, this message translates to:
  /// **'Printer connection timeout, make sure printer is turned on'**
  String get errorTimeout;

  /// No description provided for @errorPrinterNotSelected.
  ///
  /// In en, this message translates to:
  /// **'Printer not selected'**
  String get errorPrinterNotSelected;

  /// No description provided for @errorEmptyTicket.
  ///
  /// In en, this message translates to:
  /// **'Ticket is empty'**
  String get errorEmptyTicket;

  /// No description provided for @errorAnotherPrinting.
  ///
  /// In en, this message translates to:
  /// **'Another print in progress'**
  String get errorAnotherPrinting;

  /// No description provided for @errorScanInProgress.
  ///
  /// In en, this message translates to:
  /// **'Printer scanning in progress'**
  String get errorScanInProgress;

  /// No description provided for @errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get errorUnknown;

  /// No description provided for @testTicketTitle.
  ///
  /// In en, this message translates to:
  /// **'piyuo.com'**
  String get testTicketTitle;

  /// No description provided for @testTicketAddress.
  ///
  /// In en, this message translates to:
  /// **'Test Receipt'**
  String get testTicketAddress;

  /// No description provided for @testTicketCustomerName.
  ///
  /// In en, this message translates to:
  /// **'Customer 1'**
  String get testTicketCustomerName;

  /// No description provided for @testTicketNotes.
  ///
  /// In en, this message translates to:
  /// **'The tableware of chopsticks, forks and so on'**
  String get testTicketNotes;

  /// No description provided for @testTicketProductName1.
  ///
  /// In en, this message translates to:
  /// **'Product 1'**
  String get testTicketProductName1;

  /// No description provided for @testTicketProductItem1.
  ///
  /// In en, this message translates to:
  /// **'Extra Large'**
  String get testTicketProductItem1;

  /// No description provided for @testTicketProductItem2.
  ///
  /// In en, this message translates to:
  /// **'Honey BBQ Sauce'**
  String get testTicketProductItem2;

  /// No description provided for @testTicketProductName2.
  ///
  /// In en, this message translates to:
  /// **'Product 2'**
  String get testTicketProductName2;

  /// No description provided for @testTicketProductName3.
  ///
  /// In en, this message translates to:
  /// **'product 3'**
  String get testTicketProductName3;

  /// No description provided for @testTicketQRCode.
  ///
  /// In en, this message translates to:
  /// **'Scan QR code to see order online'**
  String get testTicketQRCode;

  /// No description provided for @testTicketMessage.
  ///
  /// In en, this message translates to:
  /// **'Thank your!'**
  String get testTicketMessage;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;
}

class _LibLocalizationsDelegate extends LocalizationsDelegate<LibLocalizations> {
  const _LibLocalizationsDelegate();

  @override
  Future<LibLocalizations> load(Locale locale) {
    return SynchronousFuture<LibLocalizations>(lookupLibLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_LibLocalizationsDelegate old) => false;
}

LibLocalizations lookupLibLocalizations(Locale locale) {

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh': {
  switch (locale.countryCode) {
    case 'TW': return LibLocalizationsZhTw();
   }
  break;
   }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return LibLocalizationsEn();
    case 'zh': return LibLocalizationsZh();
  }

  throw FlutterError(
    'LibLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
