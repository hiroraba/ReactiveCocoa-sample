//
//  ViewController.m
//  ReactiveCocoa-sample
//
//  Created by matsuohiroki on 2015/12/12.
//  Copyright © 2015年 matsuohiroki. All rights reserved.
//

#import "ViewController.h"
#import "LoginManager.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import "UIColor+ColorWithHex.h"

static NSString *const UserDidLogOutNotification = @"UserDidLogOutNotification";

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *logInButton;
@property (weak, nonatomic) IBOutlet UIButton *logOutButton;
@property (assign, nonatomic) BOOL loggedIn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setAppearence];
    
    LoginManager *Loginmanager = [[LoginManager alloc] init];
    @weakify(self);

    RAC(self.logInButton, enabled) = [RACSignal
                                      combineLatest:@[
                                                      self.usernameTextField.rac_textSignal,
                                                      self.passwordTextField.rac_textSignal,
                                                      RACObserve(Loginmanager, loggingIn),
                                                      RACObserve(self, loggedIn)
                                                      ] reduce:^(NSString *username, NSString *password, NSNumber *loggingIn, NSNumber *loggedIn) {
                                                          return @(username.length > 0 && password.length > 0 && !loggingIn.boolValue && !loggedIn.boolValue);
                                                      }];
    
    [[self.logInButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        @strongify(self);
        
        RACSignal *loginSignal = [Loginmanager
                                  logInWithUsername:self.usernameTextField.text
                                  password:self.passwordTextField.text];
        
        [loginSignal subscribeError:^(NSError *error) {
            [self showAlertWithStatus:NO];
        } completed:^{
            @strongify(self);
            [self showAlertWithStatus:YES];
            self.loggedIn = YES;
        }];
    }];
    
    [[self.logOutButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLogOutNotification object:nil];
    }];
    
    RAC(self, loggedIn) = [[NSNotificationCenter.defaultCenter
                            rac_addObserverForName:UserDidLogOutNotification object:nil]
                           mapReplace:@NO];
    
    [RACObserve(self.logInButton, enabled) subscribeNext:^(id isEnabled) {
        if ([isEnabled boolValue]) {
            [self.logInButton setBackgroundColor:[UIColor colorWithHexString:@"374555"]];
        } else {
            [self.logInButton setBackgroundColor:[UIColor colorWithHexString:@"DFDFDF"]];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setAppearence
{
    self.logOutButton.layer.cornerRadius = 10.0f;
    self.logInButton.layer.cornerRadius = 10.0f;
    [self.passwordTextField setSecureTextEntry:YES];
}

-(void)showAlertWithStatus:(BOOL)status
{
    NSString *title = (status) ? @"Login Success" : @"Login failed";
    NSString *message = (status) ? @"welcome!" : @"username or password is wrong.";
    
    UIAlertController * ac =
    [UIAlertController alertControllerWithTitle:title
                                        message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction * okAction =
    [UIAlertAction actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action) {
                               NSLog(@"OK button tapped.");
                           }];
    
    [ac addAction:okAction];
    
    [self presentViewController:ac animated:YES completion:nil];

}

@end
