//
//  LoginManager.m
//  ReactiveCocoa-sample
//
//  Created by matsuohiroki on 2015/12/12.
//  Copyright © 2015年 matsuohiroki. All rights reserved.
//

#import "LoginManager.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
@implementation LoginManager

- (id)init
{
    self = [super init];
    if (self) {
        self.loggingIn = NO;
    }
    return self;
}

- (RACSignal *)logInWithUsername:(NSString *)username password:(NSString *)password
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        if([username isEqualToString:@"sandbox"] && [password isEqualToString:@"pass"])
        {
            [subscriber sendCompleted];
        } else {
            [subscriber sendError:nil];
        }
        
       return [RACDisposable disposableWithBlock:^{
           
       }];
    }];
}

@end
