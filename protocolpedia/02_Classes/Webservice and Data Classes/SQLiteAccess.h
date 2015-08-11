//
//  SQLiteAccess.h
//  ProtocolPedia
//
//   4/16/10.
//  Copyright MandellMobileApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SQLiteAccess : NSObject <UIApplicationDelegate> {
}

+ (NSString *)selectOneValueSQL:(NSString *)sql;
+ (NSDictionary *)selectOneRowWithSQL:(NSString *)sql;
+ (NSArray *)selectManyRowsWithSQL:(NSString *)sql;
+ (NSNumber *)insertWithSQL:(NSString *)sql;
+ (void)updateWithSQL:(NSString *)sql;
+ (void)deleteWithSQL:(NSString *)sql;

@end
