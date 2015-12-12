//
//  UIColor+ColorWithHex.h
//  ReactiveCocoa-sample
//
//  Created by matsuohiroki on 2015/12/12.
//  Copyright © 2015年 matsuohiroki. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIColor (colorWithHex)

+ (UIColor*)colorWithHexString:(NSString *)hex;
+ (UIColor*)colorWithHexString:(NSString *)hex alpha:(CGFloat)a;

@end
