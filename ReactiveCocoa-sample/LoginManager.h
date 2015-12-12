//
//  LoginManager.h
//  ReactiveCocoa-sample
//
//  Created by matsuohiroki on 2015/12/12.
//  Copyright © 2015年 matsuohiroki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface LoginManager : NSObject
@property (assign) BOOL loggingIn;
- (RACSignal *)logInWithUsername:(NSString *)username password:(NSString *)password;
@end
