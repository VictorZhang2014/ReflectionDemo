//
//  ZRAlertController.h
//  ZRAlertController
//
//  Created by Victor John on 16/1/10.
//  Copyright (c) 2016年 XiaoRuiGeGeStudio. All rights reserved.
//
//  https://github.com/VictorZhang2014/AlertView-Demo-for-iOS
//  An open source library for iOS in Objective-C that is being compatible with iOS 7.0 and later.
//  Its main function that wrapped UIAlertView and UIAlertController that are easier to call.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger){
    ZRAlertStylePlainTextInput,
    ZRAlertStyleSecureTextInput,
    ZRAlertStyleLoginAndPasswordInput
}ZRAlertStyle;


typedef void(^AlertBlock)(void);
typedef void(^AlertBlock1)(UITextField *textFiled);
typedef void(^AlertBlock2)(UITextField *textFiled1, UITextField *textFiled2);

@interface ZRAlertController : NSObject

+ (instancetype)defaultAlert;

- (void)alertShow:(UIViewController *)controller title:(NSString *)title message:(NSString *)message okayButton:(NSString *)okay;

- (void)alertShow:(UIViewController *)controller title:(NSString *)title message:(NSString *)message cancelButton:(NSString *)cancel okayButton:(NSString *)okay okayHandler:(AlertBlock)okayHandler cancelHandler:(AlertBlock)cancelHandler;

- (void)alertShow:(UIViewController *)controller title:(NSString *)title message:(NSString *)message cancelButton:(NSString *)cancel okayButton:(NSString *)okay alertStyle:(ZRAlertStyle)style placeHolder:(NSString *)placeHolder okayHandler:(AlertBlock1)okayHandler cancelHandler:(AlertBlock1)cancelHandler;

- (void)alertShow:(UIViewController *)controller title:(NSString *)title message:(NSString *)message cancelButton:(NSString *)cancel okayButton:(NSString *)okay alertStyle:(ZRAlertStyle)style placeHolder1:(NSString *)placeHolder1 placeHolder2:(NSString *)placeHolder2 sureHandler:(AlertBlock2)okayHandler abolishHandler:(AlertBlock2)cancelHandler;

@end
