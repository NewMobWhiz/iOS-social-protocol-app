//
//  PPWebService.h
//  ProtocolPedia
//


#define PPBaseUrl @"http://www.protocolpedia.com/protocolservice/json/index.php"

#define loginPath @"method=login"
#define signUpPath @"method=register"

#define kMenuKey                            @"kMenuKey"
#define kLiveMenuKey                        @"kLiveMenuKey"
#define kGroupCategories                    @"kGroupCategories"
#define kDidSucceedKey                      @"kDidSucceedKey"
#define kStatusCodeKey                      @"kStatusCodeKey"
#define kErrorObjectKey                     @"kErrorObjectKey"
#define kErrorReasonKey                     @"kErrorReasonKey"
#define kErrorMessageKey                    @"kErrorMessageKey"
#define kErrorNotificationKey               @"kErrorNotificationKey"
#define kCategoryIdentifierKey              @"kCategoryIdentifierKey"
#define kCategoryPageIdKey                  @"kCategoryPageIdKey"
#define kCategoryKey                        @"kCategoryKey"
#define kArticleID                          @"kArticleID"
#define kVideoID                            @"kVideoID"
#define kVideoURL                           @"kVideoURL"

#define JSONParsing 1
#define CENTRALIZE_ERROR_HANDLING           0

#define PP_NOTIFICATION_AUTHENTIFICATION_SUCCEED @"PP_NOTIFICATION_AUTHENTIFICATION_SUCCEED"
#define PP_NOTIFICATION_AUTHENTIFICATION_FAILED @"PP_NOTIFICATION_AUTHENTIFICATION_FAILED"
#define PP_NOTIFICATION_SIGNUP_SUCCEED @"PP_NOTIFICATION_SIGNUP_SUCCEED"
#define PP_NOTIFICATION_SIGNUP_FAILED @"PP_NOTIFICATION_SIGNUP_FAILED"

#import <Foundation/Foundation.h>
#import "NSThread+withBlocks.h"
#import "Reachability.h"


@interface PPWebServices : NSObject <UIAlertViewDelegate>

@property int nbRequete;
@property (nonatomic, retain) NSString *challengeKey;
@property (nonatomic, retain) NSString *sessionKey;
@property (nonatomic, retain) NSTimer *timeOut;
@property (nonatomic, retain) NSString *sessionToken;
@property (nonatomic, retain) NSOperationQueue *queue;

@property (strong, nonatomic) NSString *responseMsg;

@property (nonatomic, retain) UIView * loadingView;

+ (PPWebServices *)sharedInstance;

- (void)checkNetworkActivity;

-(void)connectWithLogin:(NSString *)login andPasswd:(NSString *)passwd;

-(void)signUpWithName:(NSString *)name andUsername:(NSString *)usernama andEmail:(NSString *)email andPassword:(NSString *)password ;

@end
