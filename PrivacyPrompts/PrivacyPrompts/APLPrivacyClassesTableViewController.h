 
@import UIKit;
@import CoreBluetooth;
@import CoreLocation;

#define kDataClassLocation NSLocalizedString(@"LOCATION_SERVICE", @"地理位置")
#define kDataClassCalendars NSLocalizedString(@"CALENDARS_SERVICE", @"日历")
#define kDataClassContacts NSLocalizedString(@"CONTACTS_SERVICE", @"联系人")
#define kDataClassPhotos NSLocalizedString(@"PHOTOS_SERVICE", @"相册")
#define kDataClassReminders NSLocalizedString(@"REMINDERS_SERVICE", @"提醒事件")
#define kDataClassMicrophone NSLocalizedString(@"MICROPHONE_SERVICE", @"麦克风")
#define kDataClassMotion NSLocalizedString(@"MOTION_SERVICE", @"")
#define kDataClassBluetooth NSLocalizedString(@"BLUETOOTH_SERVICE", @"蓝牙")
#define kDataClassFacebook NSLocalizedString(@"FACEBOOK_SERVICE", @"Facebook")
#define kDataClassTwitter NSLocalizedString(@"TWITTER_SERVICE", @"Twitter账户")
#define kDataClassSinaWeibo NSLocalizedString(@"SINA_WEIBO_SERVICE", @"新浪微博")
#define kDataClassTencentWeibo NSLocalizedString(@"TENCENT_WEIBO_SERVICE", @"腾讯微博")
#define kDataClassAdvertising NSLocalizedString(@"ADVERTISING_SERVICE", @"")

typedef NS_ENUM(NSInteger, DataClass)  {
    Location,
    Calendars,
    Contacts,
    Photos,
    Reminders,
    Microphone,
    Motion,
    Bluetooth,
    Facebook,
    Twitter,
    SinaWeibo,
    TencentWeibo,
    Advertising
};

@interface APLPrivacyClassesTableViewController : UITableViewController <UINavigationControllerDelegate, CLLocationManagerDelegate, UIImagePickerControllerDelegate, CBCentralManagerDelegate>

@end