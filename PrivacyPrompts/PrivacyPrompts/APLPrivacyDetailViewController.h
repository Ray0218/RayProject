 
@import UIKit;

typedef void (^CheckAccessBlock)();
typedef void (^RequestAccessBlock)();

@interface APLPrivacyDetailViewController : UITableViewController

@property (nonatomic, copy) CheckAccessBlock checkBlock;
@property (nonatomic, copy) RequestAccessBlock requestBlock;

@end
