//
//  SignUp.h
//  ProtocolPedia
//
//  Created by bk_sport on 11/13/13.
//  Copyright (c) 2013 chinhlt. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SignUpWSDelegate;

@interface SignUp : NSObject<NSXMLParserDelegate>
{
    id<SignUpWSDelegate> delegate;
}

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

@property (nonatomic,retain)id<SignUpWSDelegate> delegate;

@property (nonatomic,retain )  NSMutableData *webData;
@property (nonatomic,retain)NSXMLParser *xmlParser;

- (void) startThreadLogin:(NSString*) name :(NSString *) email :(NSString*) strUser :(NSString *) strPass;

- (void)startLoadLogin;
- (void)goLogin;

@end

@protocol SignUpWSDelegate <NSObject>

-(void) SignUpSuccess: (int)userID;
-(void) SignUpFailed;

@end
