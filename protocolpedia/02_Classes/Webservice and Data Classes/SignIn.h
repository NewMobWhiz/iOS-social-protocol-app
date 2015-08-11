//
//  SignIn.h
//  ProtocolPedia
//
//  Created by bk_sport on 11/13/13.
//  Copyright (c) 2013 chinhlt. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SignInWSDelegate;

@interface SignIn : NSObject<NSXMLParserDelegate>
{
    id<SignInWSDelegate> delegate;
}

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

@property (nonatomic,retain)id<SignInWSDelegate> delegate;

@property (nonatomic,retain )  NSMutableData *webData;
@property (nonatomic,retain)NSXMLParser *xmlParser;

- (void) startThreadLogin:(NSString*) strUser :(NSString *) strPass;

- (void)startLoadLogin;
- (void)goLogin;

@end

@protocol SignInWSDelegate <NSObject>

-(void) SignInSuccess: (int)userID;
-(void) SignInFailed;

@end
