//
//  ZRAlertController.m
//  ZRAlertController
//
//  Created by Victor John on 16/1/10.
//  Copyright (c) 2016年 XiaoRuiGeGeStudio. All rights reserved.
//
//  https://github.com/VictorZhang2014/AlertView-Demo-for-iOS
//  An open source library for iOS in Objective-C that is being compatible with iOS 7.0 and later.
//  Its main function that wrapped UIAlertView and UIAlertController that are easier to call.
//

#import "ZRAlertController.h" 

#define kiOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

static AlertBlock okayBlock;
static AlertBlock cancelBlock;

static AlertBlock1 okayBlock1;
static AlertBlock1 cancelBlock1;

static AlertBlock2 okayBlock2;
static AlertBlock2 cancelBlock2;

typedef NS_ENUM(NSInteger){
    ZRAlertMethodStyleDefault,
    ZRAlertMethodStyleOneInput,
    ZRAlertMethodStyleTwoInput
}ZRAlertMethodStyle;

@interface ZRDelegateController : UIViewController<UIAlertViewDelegate>
@property (nonatomic, assign) ZRAlertMethodStyle methodStyle;
@end

@implementation ZRDelegateController

#pragma mark - UIAlertViewDelegate events
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        switch (self.methodStyle) {
            case ZRAlertMethodStyleDefault:
                if (okayBlock)
                    okayBlock();
                break;
            case ZRAlertMethodStyleOneInput:
                if (okayBlock1)
                    okayBlock1([alertView textFieldAtIndex:0]);
                break;
            case ZRAlertMethodStyleTwoInput:
                if (okayBlock2)
                    okayBlock2([alertView textFieldAtIndex:0], [alertView textFieldAtIndex:1]);
                break;
            default:
                break;
        }
    } else {
        switch (self.methodStyle) {
            case ZRAlertMethodStyleDefault:
                if (cancelBlock)
                    cancelBlock();
                break;
            case ZRAlertMethodStyleOneInput:
                if (cancelBlock1)
                    cancelBlock1([alertView textFieldAtIndex:0]);
                break;
            case ZRAlertMethodStyleTwoInput:
                if (cancelBlock2)
                    cancelBlock2([alertView textFieldAtIndex:0], [alertView textFieldAtIndex:1]);
                break;
            default:
                break;
        }

    }
}

@end




@interface ZRAlertController()
@property (nonatomic, strong) ZRDelegateController *delegateController;
@end

@implementation ZRAlertController

+ (instancetype)defaultAlert
{
    static ZRAlertController *alertController;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        alertController = [[ZRAlertController alloc] init];
    });
    return alertController;
}

- (ZRDelegateController *)delegateController
{
    if (!_delegateController) {
        _delegateController = [[ZRDelegateController alloc] init];
    }
    return _delegateController;
}

- (void)alertShow:(UIViewController *)controller title:(NSString *)title message:(NSString *)message okayButton:(NSString *)okay
{
    if (kiOS8) {
        
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:okay style:UIAlertActionStyleDefault handler:nil];
        [alertC addAction:action];
        [controller presentViewController:alertC animated:YES completion:nil];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:okay, nil];
        [alert show];
    }
}

- (void)alertShow:(UIViewController *)controller title:(NSString *)title message:(NSString *)message cancelButton:(NSString *)cancel okayButton:(NSString *)okay okayHandler:(AlertBlock)okayHandler cancelHandler:(AlertBlock)cancelHandler
{
    okayBlock = okayHandler;
    cancelBlock = cancelHandler;
    
    if (kiOS8) {
        
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action0 = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (cancelBlock)
                cancelBlock();
        }];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:okay style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (okayBlock)
                okayBlock();
        }];
        [alertC addAction:action0];
        [alertC addAction:action1];
        [controller presentViewController:alertC animated:YES completion:nil];
        
    } else {
        self.delegateController.methodStyle = ZRAlertMethodStyleDefault;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self.delegateController cancelButtonTitle:cancel otherButtonTitles:okay, nil];
        [alert show];
        
    }
}

- (void)alertShow:(UIViewController *)controller title:(NSString *)title message:(NSString *)message cancelButton:(NSString *)cancel okayButton:(NSString *)okay alertStyle:(ZRAlertStyle)style placeHolder:(NSString *)placeHolder okayHandler:(AlertBlock1)okayHandler cancelHandler:(AlertBlock1)cancelHandler
{
    okayBlock1 = okayHandler;
    cancelBlock1 = cancelHandler;
    
    if (kiOS8) {
        
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        [alertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = placeHolder;
            if (style == ZRAlertStylePlainTextInput) {
                textField.secureTextEntry = NO;
            } else if (style == ZRAlertStyleSecureTextInput) {
                textField.secureTextEntry = YES;
            } else {
               NSLog(@"The parameter of ZRAlertStyle is not correct!");
            }
        }];
        
        UIAlertAction *action0 = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (cancelBlock1)
                cancelBlock1(alertC.textFields.firstObject);
        }];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:okay style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (okayBlock1)
                okayBlock1(alertC.textFields.firstObject);
        }];
        [alertC addAction:action0];
        [alertC addAction:action1];
        [controller presentViewController:alertC animated:YES completion:nil];
        
    } else {
        
        self.delegateController.methodStyle = ZRAlertMethodStyleOneInput;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self.delegateController cancelButtonTitle:cancel otherButtonTitles:okay, nil];
        
        if (style == ZRAlertStylePlainTextInput) {
            [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        } else if (style == ZRAlertStyleSecureTextInput) {
            [alert setAlertViewStyle:UIAlertViewStyleSecureTextInput];
        } else {
            NSLog(@"The parameter of ZRAlertStyle is not correct!");
            return;
        }
        [alert textFieldAtIndex:0].placeholder = placeHolder;
        [alert show];
        
    }
}

- (void)alertShow:(UIViewController *)controller title:(NSString *)title message:(NSString *)message cancelButton:(NSString *)cancel okayButton:(NSString *)okay alertStyle:(ZRAlertStyle)style placeHolder1:(NSString *)placeHolder1 placeHolder2:(NSString *)placeHolder2 sureHandler:(AlertBlock2)okayHandler abolishHandler:(AlertBlock2)cancelHandler
{
    okayBlock2 = okayHandler;
    cancelBlock2 = cancelHandler;
    
    if (kiOS8) {
        
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        [alertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = placeHolder1;
        }];
        
        [alertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = placeHolder2;
            textField.secureTextEntry = YES;
        }];
        
        UIAlertAction *action0 = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (cancelBlock2)
                cancelBlock2(alertC.textFields.firstObject, alertC.textFields.lastObject);
        }];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:okay style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (okayBlock2)
                okayBlock2(alertC.textFields.firstObject, alertC.textFields.lastObject);
        }];
        [alertC addAction:action0];
        [alertC addAction:action1];
        [controller presentViewController:alertC animated:YES completion:nil];
        
    } else {
        
        self.delegateController.methodStyle = ZRAlertMethodStyleTwoInput;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self.delegateController cancelButtonTitle:cancel otherButtonTitles:okay, nil];
        
        if (style == ZRAlertStyleLoginAndPasswordInput) {
            [alert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
        } else {
            NSLog(@"The parameter of ZRAlertStyle is not correct!");
            return;
        }
        
        [alert show];
        
    }
}


@end
