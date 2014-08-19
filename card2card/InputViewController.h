//
//  InputViewController.h
//  card2card
//
//  Created by Ivan Alekseev on 16.09.13.
//  Copyright (c) 2013 OCEAN BANK CJSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iC2Cprocessing.h"
#import <CardIO.h>

@interface InputViewController : UIViewController <CardIOPaymentViewControllerDelegate, UITextFieldDelegate, UIWebViewDelegate> {
    NSString *opKey;
    iC2Cprocessing *service;
    UITextField *_currentTextField;
    CGPoint scrollOffset;
    NSNumber *keyboardHeight;
    BOOL _animate;
    int _animateCount;
    BOOL _3DShowed;
}

- (void)keyboardWillShow : (NSNotification *) note;
- (void)keyboardDidShow : (NSNotification *) note;
- (void)keyboardWillHide : (NSNotification *) note;

- (void)addDoneButtonToNumberPadKeyboard;
- (void)removeDoneButtonFromNumberPadKeyboard;
- (void)doneButton : (id) sender;

- (IBAction)btnTransfer_Click : (id) sender;
- (IBAction)btnHelp_Click : (id) sender;
- (void)doScan : (id) sender;

- (BOOL)checkFormat : (NSString *)text withFormat : (NSString *)format;
- (BOOL)isValidCC : (NSString *) number;
- (BOOL)checkExpireMonth : (int) month andYear : (int)year;

- (BOOL)validate;
- (void)doTransfer;
- (void)checkTransferState;

- (void)gotoCancel;
- (void)gotoDone;
- (void)gotoHalt;

- (NSString *)getNumberText:(NSNumber *)number;
- (NSString *)getCurrencyText:(int)n :(NSString *)one :(NSString *)two :(NSString *)five;

- (void)scrollToTextField;

- (void)setWaitImagesToBig;
- (void)setWaitImagesToSmall;
- (void)setWaitImageToSmall : (UIImageView *) img;
- (void)setWaitImageToBig : (UIImageView *) img;

- (void)showWait;
- (void)hideWait;

- (void)startWaitingAnimation;

- (void)storeToCloud;
- (void)restoreFromCloud;

- (void)fixToCard : (NSString *)number;

@end
