//
//  InputViewController.m
//  card2card
//
//  Created by Ivan Alekseev on 16.09.13.
//  Copyright (c) 2013 OCEAN BANK CJSC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InputViewController.h"
#import "iC2Cprocessing.h"
#import "DoneViewController.h"
#import "CancelViewController.h"
#import "HelpViewController.h"
#import "HaltViewController.h"
#import "AppDelegate.h"

#define MAX_SUMM 75001

@interface InputViewController ()

@property (nonatomic, retain) IBOutlet UITextField *tfFromCardNumber;
@property (nonatomic, retain) IBOutlet UITextField *tfFromCardExpMonth;
@property (nonatomic, retain) IBOutlet UITextField *tfFromCardExpYear;
@property (nonatomic, retain) IBOutlet UITextField *tfFromCardCVV;
@property (nonatomic, retain) IBOutlet UITextField *tfToCardNumber;
@property (nonatomic, retain) IBOutlet UITextField *tfSumma;
@property (nonatomic) BOOL keyboardIsShowing;
@property (nonatomic, retain) UIButton *doneButton;
@property (nonatomic, retain) IBOutlet UIView *vWait;
@property (nonatomic, retain) IBOutlet UILabel *lblComission;
@property (nonatomic, retain) IBOutlet UIButton *btnTransfer;
@property (nonatomic, retain) IBOutlet UIScrollView *svBack;

@property (nonatomic, retain) IBOutlet UIImageView *imgWait1;
@property (nonatomic, retain) IBOutlet UIImageView *imgWait2;
@property (nonatomic, retain) IBOutlet UIImageView *imgWait3;
@property (nonatomic, retain) IBOutlet UIImageView *imgWait4;
@property (nonatomic, retain) IBOutlet UIImageView *imgWait5;
@property (nonatomic, retain) IBOutlet UIImageView *imgWait6;
@property (nonatomic, retain) IBOutlet UIImageView *imgWait7;
@property (nonatomic, retain) IBOutlet UIImageView *imgWait8;

@property (nonatomic, retain) IBOutlet UIWebView *wv3D;
@property (nonatomic) BOOL toCardFixed;

@end

@implementation InputViewController

@synthesize tfFromCardNumber = _tfFromCardNumber;
@synthesize tfFromCardExpMonth = _tfFromCardExpMonth;
@synthesize tfFromCardExpYear = _tfFromCardExpYear;
@synthesize tfFromCardCVV = _tfFromCardCVV;
@synthesize tfToCardNumber = _tfToCardNumber;
@synthesize tfSumma = _tfSumma;
@synthesize keyboardIsShowing = _keyboardIsShowing;
@synthesize doneButton = _doneButton;
@synthesize vWait = _vWait;
@synthesize lblComission = _lblComission;
@synthesize btnTransfer = _btnTransfer;
@synthesize svBack = _svBack;

@synthesize imgWait1 = _imgWait1;
@synthesize imgWait2 = _imgWait2;
@synthesize imgWait3 = _imgWait3;
@synthesize imgWait4 = _imgWait4;
@synthesize imgWait5 = _imgWait5;
@synthesize imgWait6 = _imgWait6;
@synthesize imgWait7 = _imgWait7;
@synthesize imgWait8 = _imgWait8;

@synthesize wv3D = _wv3D;

@synthesize toCardFixed = _toCardFixed;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        service = [iC2Cprocessing service];
        service.logging = YES;
        _currentTextField = nil;
        _3DShowed = NO;
        self.toCardFixed = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.doneButton.frame = CGRectMake(0, 163, 106, 53);
    self.doneButton.adjustsImageWhenHighlighted = NO;
    
    [self.doneButton setTitle:NSLocalizedString(@"OK", @"") forState:UIControlStateApplication];
    [self.doneButton setTitle:NSLocalizedString(@"OK", @"") forState:UIControlStateDisabled];
    [self.doneButton setTitle:NSLocalizedString(@"OK", @"") forState:UIControlStateHighlighted];
    [self.doneButton setTitle:NSLocalizedString(@"OK", @"") forState:UIControlStateNormal];
    [self.doneButton setTitle:NSLocalizedString(@"OK", @"") forState:UIControlStateReserved];
    [self.doneButton setTitle:NSLocalizedString(@"OK", @"") forState:UIControlStateSelected];
    
    [self.doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.wv3D.hidden = YES;
    
    [self hideWait];
    
    self.lblComission.text = [NSString stringWithFormat:NSLocalizedString(@"comission_nosum", @""), @""];
    
    self.navigationItem.title = NSLocalizedString(@"MainTitle", @"");
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor blackColor], NSForegroundColorAttributeName,
      [UIFont fontWithName:@"Helvetica Neue" size:16.0], NSFontAttributeName,nil]];
    
    UIButton *btnHelp = [UIButton buttonWithType:UIButtonTypeInfoDark];
    [btnHelp addTarget:self action:@selector(btnHelp_Click:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnHelp];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(doScan:)];
    
    CGRect frame = self.view.frame;
    frame.size.height -= self.btnTransfer.frame.size.height;
    self.svBack.frame = frame;
    self.svBack.contentSize = CGSizeMake(self.view.frame.size.width, 450);
    
    self.wv3D.frame = self.view.frame;
}

- (void)viewWillAppear : (BOOL) animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillShow:)
     name:UIKeyboardWillShowNotification
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardDidShow:)
     name:UIKeyboardDidShowNotification
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillHide:)
     name:UIKeyboardWillHideNotification
     object:nil];

    self.keyboardIsShowing = NO;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.navigationItem.leftBarButtonItem.enabled = YES;

    [self validate];

    if ([self.tfFromCardNumber.text isEqualToString:@""]) {
        [self restoreFromCloud];
    }
    
    self.svBack.contentSize = CGSizeMake(self.view.frame.size.width, 450);
}

- (void)viewWillDisappear : (BOOL) animated {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)keyboardWillShow : (NSNotification *) note {
	if (self.keyboardIsShowing) return;
    if (self.wv3D.hidden)
        [self addDoneButtonToNumberPadKeyboard];
    else
        [self removeDoneButtonFromNumberPadKeyboard];
    
    CGRect keyboardBounds;
	
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
	
    keyboardHeight = [NSNumber numberWithFloat:keyboardBounds.size.height];
	
	self.keyboardIsShowing = YES;
	
	scrollOffset = self.svBack.contentOffset;
	
	CGRect frame = self.view.frame;
	frame.size.height -= [keyboardHeight floatValue];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.3f];
	
	self.svBack.frame = frame;
	self.svBack.contentSize = CGSizeMake(self.view.frame.size.width, 450);
	
	[UIView commitAnimations];
}

- (void)keyboardDidShow : (NSNotification *) note {
    if (self.wv3D.hidden)
        [self addDoneButtonToNumberPadKeyboard];
    else
        [self removeDoneButtonFromNumberPadKeyboard];
}

- (void)keyboardWillHide : (NSNotification *) note {
    if (self.keyboardIsShowing == YES) {
        self.keyboardIsShowing = NO;
        CGRect frame = self.svBack.frame;
        frame.size.height += [keyboardHeight floatValue];
		
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
		
        self.svBack.frame = frame;
		self.svBack.contentOffset = scrollOffset;
		
		self.svBack.contentSize = CGSizeMake(self.view.frame.size.width, 450);
		
        [UIView commitAnimations];
	}}

- (void)addDoneButtonToNumberPadKeyboard
{
    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    UIView* keyboard;
    for (int i=0; i<[tempWindow.subviews count]; i++) {
        keyboard = [tempWindow.subviews objectAtIndex:i];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            if([[keyboard description] hasPrefix:@"<UIInputSetContainerView"] == YES) {
                NSArray *a = [(UIView *)keyboard subviews];
                [(UIView *)[a objectAtIndex:0] addSubview:self.doneButton];
                [(UIView *)[a objectAtIndex:0] bringSubviewToFront:self.doneButton];
            }
        } else {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
                if([[keyboard description] hasPrefix:@"<UIPeripheralHost"] == YES) {
                    [keyboard addSubview:self.doneButton];
                    [keyboard bringSubviewToFront:self.doneButton];
                }
            } else {
                if([[keyboard description] hasPrefix:@"<UIKeyboard"] == YES)
                    [keyboard addSubview:self.doneButton];
            }
        }
    }
}

- (void)removeDoneButtonFromNumberPadKeyboard {
	if (!self.keyboardIsShowing) return;
	[self.doneButton removeFromSuperview];
}

- (void)doneButton : (id) sender {
    NSLog(@"doneButton");
    [self.view endEditing:TRUE];
    if (self.btnTransfer.enabled)
        [self btnTransfer_Click:sender];
}

- (void)doScan : (id) sender {
    [self hideKeyboard];
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    scanViewController.appToken = @"c1c6b4b15f2441789a2b8821a1fbc2e4";
    scanViewController.useCardIOLogo = YES;
    scanViewController.suppressScanConfirmation = YES;
    scanViewController.collectCVV = YES;
    scanViewController.collectExpiry = YES;
    scanViewController.languageOrLocale = @"ru";
    scanViewController.disableManualEntryButtons = YES;
    [self presentViewController:scanViewController animated:YES completion:nil];
}

- (IBAction)btnTransfer_Click : (id) sender {
    if ([self validate]) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
        self.navigationItem.leftBarButtonItem.enabled = NO;
        [self showWait];
        [self performSelector:@selector(doTransfer) withObject:nil afterDelay:.1];
    }
}

- (IBAction)btnHelp_Click : (id) sender {
    [self hideKeyboard];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    HelpViewController *vHelp = [[HelpViewController alloc] initWithNibName:([app iPhone5] ? @"HelpViewController" : @"HelpViewController4") bundle:nil];
    [self.navigationController pushViewController:vHelp animated:YES];
}

- (BOOL)checkFormat : (NSString *)text withFormat : (NSString *)format {
    NSError *error;
    NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:[format stringByReplacingOccurrencesOfString:@"\n" withString:@""] options:NSRegularExpressionCaseInsensitive error:&error];
    
    return [regExp numberOfMatchesInString:text options:NSMatchingReportProgress range:NSMakeRange(0, [text length])] > 0;
}

- (BOOL)isValidCC : (NSString *) number {
    NSMutableArray *sumTable = [NSMutableArray arrayWithObjects:
                                        [NSMutableArray arrayWithObjects:
                                            [NSNumber numberWithInt:0], [NSNumber numberWithInt:1], [NSNumber numberWithInt:2], [NSNumber numberWithInt:3], [NSNumber numberWithInt:4], [NSNumber numberWithInt:5], [NSNumber numberWithInt:6], [NSNumber numberWithInt:7], [NSNumber numberWithInt:8], [NSNumber numberWithInt:9], nil],
                                        [NSMutableArray arrayWithObjects:
                                            [NSNumber numberWithInt:0], [NSNumber numberWithInt:2], [NSNumber numberWithInt:4], [NSNumber numberWithInt:6], [NSNumber numberWithInt:8], [NSNumber numberWithInt:1], [NSNumber numberWithInt:3], [NSNumber numberWithInt:5], [NSNumber numberWithInt:7], [NSNumber numberWithInt:9], nil], nil];
    int sum = 0, flip = 0;

    for (int i = number.length - 1; i >= 0; i--) {
        int n = [[number substringWithRange:NSMakeRange(i, 1)] intValue];
        sum += [(NSNumber *)[(NSMutableArray *)[sumTable objectAtIndex:(flip++ & 0x1)] objectAtIndex:n] intValue];
    }
    return sum % 10 == 0;
}

- (BOOL)checkExpireMonth : (int) month andYear : (int)year {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    NSInteger m = [components month];
    NSInteger y = [components year];
    return ((2000+year > y) && month > 0 && month < 13) || ((2000 + year == y) && month < 13 && month >= m);
}

- (BOOL)validate {
    @try {
        UIColor *colorGoodBack = [UIColor colorWithRed:130.0/255.0 green:203.0/255.0 blue:161.0/255.0 alpha:1];
        UIColor *colorBadBack = [UIColor colorWithRed:255.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1];
        UIColor *colorGoodFont = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
        UIColor *colorBadFont = [UIColor colorWithRed:233.0/255.0 green:194.0/255.0 blue:194.0/255.0 alpha:1];
        UIColor *colorWhite = [UIColor whiteColor];
        UIColor *colorBlack = [UIColor blackColor];
        
        /*Проверяем карту отправителя*/
        BOOL vFromCardNumber = self.tfFromCardNumber.text ? [self.tfFromCardNumber.text length] == 16 && [self checkFormat: self.tfFromCardNumber.text withFormat:@"^\\d{16}$"] && [self isValidCC:self.tfFromCardNumber.text] : NO;
        
        /*Проверяем карту получателя*/
        BOOL vToCardNumber = self.tfToCardNumber.text ? [self.tfToCardNumber.text length] == 16 && [self checkFormat: self.tfToCardNumber.text withFormat:@"^\\d{16}$"] && [self isValidCC:self.tfToCardNumber.text] : NO;
        
        /*Проверяем месяц и год*/
        BOOL vExp = [self checkExpireMonth: [self.tfFromCardExpMonth.text intValue] andYear: [self.tfFromCardExpYear.text intValue]];
        
        /*Проверяем CVC*/
        BOOL vCVV = self.tfFromCardCVV.text ? [self checkFormat:self.tfFromCardCVV.text withFormat:@"^\\d{3,4}$"] : NO;
        
        /*Проверяем сумму перевода*/
        BOOL vSumma = self.tfSumma.text ? [self checkFormat:self.tfSumma.text withFormat:@"^\\d{1,5}$"] && ([self.tfSumma.text intValue] < MAX_SUMM) && ([self.tfSumma.text intValue] >= 1) : NO;
        
        if (!vSumma) {
            self.lblComission.text = NSLocalizedString(@"SummaError", @"");
        }
        
        /*Меняем цвет редакторов*/
        if (_currentTextField) {
            self.tfFromCardNumber.backgroundColor = vFromCardNumber ? colorGoodBack : (!self.tfFromCardNumber.text || [self.tfFromCardNumber.text isEqualToString:@""] || _currentTextField == self.tfFromCardNumber) ? colorWhite : colorBadBack;
            self.tfToCardNumber.backgroundColor = vToCardNumber ? colorGoodBack : (!self.tfToCardNumber.text || [self.tfToCardNumber.text isEqualToString:@""] || _currentTextField == self.tfToCardNumber) ? colorWhite : colorBadBack;
            self.tfFromCardExpMonth.backgroundColor = vExp ? colorGoodBack : (!self.tfFromCardExpMonth.text || [self.tfFromCardExpMonth.text isEqualToString:@""] || _currentTextField == self.tfFromCardExpMonth) || (!self.tfFromCardExpYear.text || [self.tfFromCardExpYear.text isEqualToString:@""] || _currentTextField == self.tfFromCardExpYear) ? colorWhite : colorBadBack;
            self.tfFromCardExpYear.backgroundColor = vExp ? colorGoodBack : (!self.tfFromCardExpMonth.text || [self.tfFromCardExpMonth.text isEqualToString:@""] || _currentTextField == self.tfFromCardExpMonth) || (!self.tfFromCardExpYear.text || [self.tfFromCardExpYear.text isEqualToString:@""] || _currentTextField == self.tfFromCardExpYear) ? colorWhite : colorBadBack;
            self.tfFromCardCVV.backgroundColor = vCVV ? colorGoodBack : (!self.tfFromCardCVV.text || [self.tfFromCardCVV.text isEqualToString:@""] || _currentTextField == self.tfFromCardCVV) ? colorWhite : colorBadBack;
            self.tfSumma.backgroundColor = vSumma ? colorGoodBack : (!self.tfSumma.text || [self.tfSumma.text isEqualToString:@""] || _currentTextField == self.tfSumma) ? colorWhite : colorBadBack;
        
            [self.tfFromCardNumber setTextColor:(vFromCardNumber ? colorGoodFont : (!self.tfFromCardNumber.text || [self.tfFromCardNumber.text isEqualToString:@""] || _currentTextField == self.tfFromCardNumber) ? colorBlack : colorBadFont)];
            [self.tfToCardNumber setTextColor:(vToCardNumber ? colorGoodFont : (!self.tfToCardNumber.text || [self.tfToCardNumber.text isEqualToString:@""] || _currentTextField == self.tfToCardNumber) ? colorBlack : colorBadFont)];
            [self.tfFromCardExpMonth setTextColor:(vExp ? colorGoodFont : (!self.tfFromCardExpMonth.text || [self.tfFromCardExpMonth.text isEqualToString:@""] || _currentTextField == self.tfFromCardExpMonth) || (!self.tfFromCardExpYear.text || [self.tfFromCardExpYear.text isEqualToString:@""] || _currentTextField == self.tfFromCardExpYear) ? colorBlack : colorBadFont)];
            [self.tfFromCardExpYear setTextColor:(vExp ? colorGoodFont : (!self.tfFromCardExpMonth.text || [self.tfFromCardExpMonth.text isEqualToString:@""] || _currentTextField == self.tfFromCardExpMonth) || (!self.tfFromCardExpYear.text || [self.tfFromCardExpYear.text isEqualToString:@""] || _currentTextField == self.tfFromCardExpYear) ? colorBlack : colorBadFont)];
            [self.tfFromCardCVV setTextColor:(vCVV ? colorGoodFont : (!self.tfFromCardCVV.text || [self.tfFromCardCVV.text isEqualToString:@""] || _currentTextField == self.tfFromCardCVV) ? colorBlack : colorBadFont)];
            [self.tfSumma setTextColor:(vSumma ? colorGoodFont : (!self.tfSumma.text || [self.tfSumma.text isEqualToString:@""] || _currentTextField == self.tfSumma) ? colorBlack : colorBadFont)];
        }
        
        self.btnTransfer.enabled = vFromCardNumber && vToCardNumber && vExp && vCVV && vSumma;
        
        if (self.btnTransfer.enabled) {
            self.btnTransfer.backgroundColor = colorGoodBack;
            self.doneButton.backgroundColor = colorGoodBack;
            
            [self.doneButton setTitle:NSLocalizedString(@"PAY", @"") forState:UIControlStateApplication];
            [self.doneButton setTitle:NSLocalizedString(@"PAY", @"") forState:UIControlStateDisabled];
            [self.doneButton setTitle:NSLocalizedString(@"PAY", @"") forState:UIControlStateHighlighted];
            [self.doneButton setTitle:NSLocalizedString(@"PAY", @"") forState:UIControlStateNormal];
            [self.doneButton setTitle:NSLocalizedString(@"PAY", @"") forState:UIControlStateReserved];
            [self.doneButton setTitle:NSLocalizedString(@"PAY", @"") forState:UIControlStateSelected];

        } else {
            self.btnTransfer.backgroundColor = [UIColor colorWithRed:185.0/255.0 green:192.0/255.0 blue:188.0/255.0 alpha:1];
            self.doneButton.backgroundColor = [UIColor colorWithRed:185.0/255.0 green:192.0/255.0 blue:188.0/255.0 alpha:1];

            [self.doneButton setTitle:NSLocalizedString(@"OK", @"") forState:UIControlStateApplication];
            [self.doneButton setTitle:NSLocalizedString(@"OK", @"") forState:UIControlStateDisabled];
            [self.doneButton setTitle:NSLocalizedString(@"OK", @"") forState:UIControlStateHighlighted];
            [self.doneButton setTitle:NSLocalizedString(@"OK", @"") forState:UIControlStateNormal];
            [self.doneButton setTitle:NSLocalizedString(@"OK", @"") forState:UIControlStateReserved];
            [self.doneButton setTitle:NSLocalizedString(@"OK", @"") forState:UIControlStateSelected];
        }
        
        return vFromCardNumber && vToCardNumber && vExp && vCVV && vSumma;
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.description);
        self.btnTransfer.enabled = NO;
        return NO;
    }
    @finally {
    }
}

- (void)doTransfer {
    iC2CStartRequest *rq = [[iC2CStartRequest alloc] init];
    
    rq.FromCardNumber = self.tfFromCardNumber.text;
    rq.FromCardExpMonth = [self.tfFromCardExpMonth.text intValue];
    rq.FromCardExpYear = [self.tfFromCardExpYear.text intValue];
    rq.FromCardCVC = self.tfFromCardCVV.text;
    rq.ToCardNumber = self.tfToCardNumber.text;
    rq.Summa = [NSDecimalNumber decimalNumberWithString:self.tfSumma.text];
    
    [service Start:self action:@selector(StartHandler:) request: rq];
}

- (void)checkTransferState {
    [service Check:self action:@selector(CheckHandler:) OpKey: opKey];
}

- (void)gotoCancel {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    CancelViewController *vCancel = [[CancelViewController alloc] initWithNibName:([app iPhone5] ? @"CancelViewController" : @"CancelViewController4") bundle:nil];
    vCancel.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vCancel animated:YES completion:nil];
}

- (void)gotoDone {
    [self storeToCloud];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    DoneViewController *vDone = [[DoneViewController alloc] initWithNibName:([app iPhone5] ? @"DoneViewController" : @"DoneViewController4") bundle:nil];
    vDone.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vDone animated:YES completion:nil];
}

- (void)gotoHalt {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    HaltViewController *vHalt = [[HaltViewController alloc] initWithNibName:([app iPhone5] ? @"HaltViewController" : @"HaltViewController4") bundle:nil];
    vHalt.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vHalt animated:YES completion:nil];
}

- (NSString *)getNumberText:(NSNumber *)number {
	NSString *numberStr = @"";
	
	NSDecimalNumber *dn = [NSDecimalNumber decimalNumberWithDecimal:[number decimalValue]];
	
	int rubls = [dn intValue];
	NSDecimalNumber *n = [dn decimalNumberByAdding:[NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithInt:-rubls] decimalValue]]];
	n = [n decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithInt:100] decimalValue]]];
	int cops = [n intValue];
	
	NSString *rs = [self getCurrencyText:rubls :NSLocalizedString(@"rub1", @"") :NSLocalizedString(@"rub2", @"") :NSLocalizedString(@"rub5", @"")];
	NSString *cs = [self getCurrencyText:cops :NSLocalizedString(@"cop1", @"") :NSLocalizedString(@"cop2", @"") :NSLocalizedString(@"cop5", @"")];
	
	numberStr = [numberStr stringByAppendingFormat:@"%i %@ %02i %@", rubls, rs, cops, cs];
	
	return numberStr;
}

- (NSString *)getCurrencyText:(int)n :(NSString *)one :(NSString *)two :(NSString *)five {
	int p = n % 100;
	
	if (p > 20) {
		p = p % 10;
	}
	
	switch (p)
	{
		case 0:
            return five;
		case 1:
            return one;
		case 2:
		case 3:
		case 4:
            return two;
		default:
            return five;
	}
}

- (void)scrollToTextField {
    if (self.keyboardIsShowing) {
        CGRect frame = self.view.frame;
        frame.size.height -= [keyboardHeight floatValue];
        
        self.svBack.frame = frame;
        self.svBack.contentSize = CGSizeMake(self.view.frame.size.width, 450);
    }
    CGRect textFieldRect = [_currentTextField frame];
    textFieldRect.origin.y += 50;
    [self.svBack scrollRectToVisible:textFieldRect animated:YES];
}

- (void)setWaitImagesToBig {
    self.imgWait1.frame = CGRectMake(61, 252, 24, 24);
    self.imgWait2.frame = CGRectMake(86, 252, 24, 24);
    self.imgWait3.frame = CGRectMake(111, 252, 24, 24);
    self.imgWait4.frame = CGRectMake(136, 252, 24, 24);
    self.imgWait5.frame = CGRectMake(161, 252, 24, 24);
    self.imgWait6.frame = CGRectMake(186, 252, 24, 24);
    self.imgWait7.frame = CGRectMake(211, 252, 24, 24);
    self.imgWait8.frame = CGRectMake(236, 252, 24, 24);
}

- (void)setWaitImagesToSmall {
    self.imgWait1.frame = CGRectMake(64, 255, 18, 18);
    self.imgWait2.frame = CGRectMake(89, 255, 18, 18);
    self.imgWait3.frame = CGRectMake(114, 255, 18, 18);
    self.imgWait4.frame = CGRectMake(139, 255, 18, 18);
    self.imgWait5.frame = CGRectMake(164, 255, 18, 18);
    self.imgWait6.frame = CGRectMake(189, 255, 18, 18);
    self.imgWait7.frame = CGRectMake(214, 255, 18, 18);
    self.imgWait8.frame = CGRectMake(239, 255, 18, 18);
}

- (void)setWaitImageToSmall : (UIImageView *) img {
    if (img == self.imgWait1)
        self.imgWait1.frame = CGRectMake(64, 255, 18, 18);
    if (img == self.imgWait2)
        self.imgWait2.frame = CGRectMake(89, 255, 18, 18);
    if (img == self.imgWait3)
        self.imgWait3.frame = CGRectMake(114, 255, 18, 18);
    if (img == self.imgWait4)
        self.imgWait4.frame = CGRectMake(139, 255, 18, 18);
    if (img == self.imgWait5)
        self.imgWait5.frame = CGRectMake(164, 255, 18, 18);
    if (img == self.imgWait6)
        self.imgWait6.frame = CGRectMake(189, 255, 18, 18);
    if (img == self.imgWait7)
        self.imgWait7.frame = CGRectMake(214, 255, 18, 18);
    if (img == self.imgWait8)
        self.imgWait8.frame = CGRectMake(239, 255, 18, 18);
}

- (void)setWaitImageToBig : (UIImageView *) img {
    if (img == self.imgWait1)
        self.imgWait1.frame = CGRectMake(61, 252, 24, 24);
    if (img == self.imgWait2)
        self.imgWait2.frame = CGRectMake(86, 252, 24, 24);
    if (img == self.imgWait3)
        self.imgWait3.frame = CGRectMake(111, 252, 24, 24);
    if (img == self.imgWait4)
        self.imgWait4.frame = CGRectMake(136, 252, 24, 24);
    if (img == self.imgWait5)
        self.imgWait5.frame = CGRectMake(161, 252, 24, 24);
    if (img == self.imgWait6)
        self.imgWait6.frame = CGRectMake(186, 252, 24, 24);
    if (img == self.imgWait7)
        self.imgWait7.frame = CGRectMake(211, 252, 24, 24);
    if (img == self.imgWait8)
        self.imgWait8.frame = CGRectMake(236, 252, 24, 24);
}

- (void)showWait {
    self.vWait.hidden = NO;

    [self setWaitImagesToSmall];
    
    [self startWaitingAnimation];
}

- (void)hideWait {
    self.vWait.hidden = YES;
    _animate = NO;
}

- (void)startWaitingAnimation {
    _animate = YES;
    _animateCount = 0;
    
    [UIView animateWithDuration:0.3f
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{ [self setWaitImageToBig:self.imgWait1]; }
                     completion:^(BOOL Finished){ [self animateNext]; }];
}

- (void)animateNext {
    if (!_animate)
    {
        [self setWaitImagesToSmall];
        return;
    }
    
    [UIView animateWithDuration:0.3f
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         switch (_animateCount) {
                             case 0:
                                 [self setWaitImageToSmall:self.imgWait1];
                                 [self setWaitImageToBig:self.imgWait2];
                                 break;
                             case 1:
                                 [self setWaitImageToSmall:self.imgWait2];
                                 [self setWaitImageToBig:self.imgWait3];
                                 break;
                             case 3:
                                 [self setWaitImageToSmall:self.imgWait3];
                                 [self setWaitImageToBig:self.imgWait4];
                                 break;
                             case 4:
                                 [self setWaitImageToSmall:self.imgWait4];
                                 [self setWaitImageToBig:self.imgWait5];
                                 break;
                             case 5:
                                 [self setWaitImageToSmall:self.imgWait5];
                                 [self setWaitImageToBig:self.imgWait6];
                                 break;
                             case 6:
                                 [self setWaitImageToSmall:self.imgWait6];
                                 [self setWaitImageToBig:self.imgWait7];
                                 break;
                             case 7:
                                 [self setWaitImageToSmall:self.imgWait7];
                                 [self setWaitImageToBig:self.imgWait8];
                                 break;
                             case 8:
                                 [self setWaitImageToSmall:self.imgWait8];
                                 [self setWaitImageToBig:self.imgWait1];
                                 break;
                             default:
                                 break;
                         }
                         
                         _animateCount++;
                         if (_animateCount > 8)
                             _animateCount = 0;
                     }
                     completion:^(BOOL Finished){ [self animateNext]; }];
}

- (void)hideKeyboard {
    [self.tfFromCardCVV resignFirstResponder];
    [self.tfFromCardExpMonth resignFirstResponder];
    [self.tfFromCardExpYear resignFirstResponder];
    [self.tfFromCardNumber resignFirstResponder];
    [self.tfSumma resignFirstResponder];
    [self.tfToCardNumber resignFirstResponder];
}

- (void)storeToCloud {
    @try {
        [[NSUbiquitousKeyValueStore defaultStore] setString:self.tfFromCardNumber.text forKey:@"FromNumber"];
        [[NSUbiquitousKeyValueStore defaultStore] setString:self.tfFromCardExpMonth.text forKey:@"FromMonth"];
        [[NSUbiquitousKeyValueStore defaultStore] setString:self.tfFromCardExpYear.text forKey:@"FromYear"];
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

- (void)restoreFromCloud {
    @try {
        self.tfFromCardNumber.text = [[NSUbiquitousKeyValueStore defaultStore] stringForKey:@"FromNumber"];
        self.tfFromCardExpMonth.text = [[NSUbiquitousKeyValueStore defaultStore] stringForKey:@"FromMonth"];
        self.tfFromCardExpYear.text = [[NSUbiquitousKeyValueStore defaultStore] stringForKey:@"FromYear"];
        
        [self validate];
        
        if (![self.tfFromCardNumber.text isEqualToString:@""])
            [self.tfFromCardCVV becomeFirstResponder];
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

- (void)fixToCard : (NSString *)number {
    self.toCardFixed = YES;
    self.tfToCardNumber.text = number;
    self.tfToCardNumber.enabled = !self.toCardFixed;
    [self validate];
}

#pragma mark - iC2CHandlers

- (void) CheckHandler: (id) value {
	if([value isKindOfClass:[NSError class]]) {
		NSLog(@"%@", value);
        [self performSelector:@selector(checkTransferState) withObject:nil afterDelay:1];
		return;
	}
	if([value isKindOfClass:[SoapFault class]]) {
		NSLog(@"%@", value);
        [self performSelector:@selector(checkTransferState) withObject:nil afterDelay:1];
		return;
	}
    iC2CStateResponse* result = (iC2CStateResponse*)value;
	NSLog(@"Check returned the value: %@", result);
    
    if ([result.Process isEqualToString:@"Done"]) {
        opKey = @"";
        [self hideWait];
        self.wv3D.hidden = YES;
        _3DShowed = NO;
        [self gotoDone];
    } else {
        if ([result.Process isEqualToString:@"Cancel"]) {
            [self hideWait];
            opKey = @"";
            self.wv3D.hidden = YES;
            _3DShowed = NO;
            [self gotoCancel];
        } else {
            if ([result.Process isEqualToString:@"Halt"]) {
                [self hideWait];
                opKey = @"";
                self.wv3D.hidden = YES;
                _3DShowed = NO;
                [self gotoHalt];
            } else {
                if (result.RedirectURL && ![result.RedirectURL isEqualToString:@""] && !_3DShowed) {
                    [self.wv3D loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:result.RedirectURL]]];
                    self.wv3D.hidden = NO;
                    _3DShowed = YES;
                }
                [self performSelector:@selector(checkTransferState) withObject:nil afterDelay:1];
            }
        }
    }
}

- (void) StartHandler: (id) value {
	if([value isKindOfClass:[NSError class]]) {
		NSLog(@"%@", value);
        [self hideWait];
        [self gotoCancel];
		return;
	}
	if([value isKindOfClass:[SoapFault class]]) {
		NSLog(@"%@", value);
        [self hideWait];
        [self gotoCancel];
		return;
	}
    NSString* result = (NSString*)value;
	NSLog(@"Start returned the value: %@", result);
    
    if (![result isEqualToString:@""]) {
        opKey = result;
        [self checkTransferState];
    } else {
        [self hideWait];
        [self gotoCancel];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    _currentTextField = textField;

    [self performSelector:@selector(scrollToTextField) withObject:nil afterDelay:1];
    
    [self validate];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    _currentTextField = nil;
    [self validate];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (((textField == self.tfFromCardNumber || textField == self.tfToCardNumber) && [str length] > 16) ||
        ((textField == self.tfFromCardExpMonth || textField == self.tfFromCardExpYear) && [str length] > 2) ||
        (textField == self.tfFromCardCVV && [str length] > 3)) {
        str = textField.text;
    }
    
    /*Переход назад*/
    if ([str length] == 0) {
        if (textField == self.tfSumma) {
            textField.text = str;
            if (self.toCardFixed) {
                [self.tfFromCardCVV becomeFirstResponder];
            } else {
                [self.tfToCardNumber becomeFirstResponder];
            }
            return NO;
        }
        if (textField == self.tfToCardNumber) {
            textField.text = str;
            [self.tfFromCardCVV becomeFirstResponder];
            return NO;
        }
        if (textField == self.tfFromCardCVV) {
            textField.text = str;
            [self.tfFromCardExpYear becomeFirstResponder];
            return NO;
        }
        if (textField == self.tfFromCardExpYear) {
            textField.text = str;
            [self.tfFromCardExpMonth becomeFirstResponder];
            return NO;
        }
        if (textField == self.tfFromCardExpMonth) {
            textField.text = str;
            [self.tfFromCardNumber becomeFirstResponder];
            return NO;
        }
    }
    
    if (textField == self.tfSumma) {
        /*Рассчитываем комиссию*/
        int summa = [str intValue];
        double comission = summa * 0.0199f;
        if (comission < 50) comission = 50;
        self.lblComission.text = [NSString stringWithFormat:NSLocalizedString(@"comission", @""), [self getNumberText:[NSNumber numberWithDouble:comission]]];
    }
    
    /*Перемещение вперед*/
    if (textField == self.tfFromCardNumber) {
        if ([str length] == 16) {
            self.tfFromCardNumber.text = str;
            [self.tfFromCardExpMonth becomeFirstResponder];
            return NO;
        } else {
            self.tfFromCardNumber.text = str;
            [self validate];
            return NO;
        }
    }
    if (textField == self.tfFromCardExpMonth) {
        if ([str length] == 2) {
            self.tfFromCardExpMonth.text = str;
            [self.tfFromCardExpYear becomeFirstResponder];
            return NO;
        } else {
            self.tfFromCardExpMonth.text = str;
            [self validate];
            return NO;
        }
    }
    if (textField == self.tfFromCardExpYear) {
        if ([str length] == 2) {
            self.tfFromCardExpYear.text = str;
            [self.tfFromCardCVV becomeFirstResponder];
            return NO;
        } else {
            self.tfFromCardExpYear.text = str;
            [self validate];
            return NO;
        }
    }
    if (textField == self.tfFromCardCVV) {
        if ([str length] == 3) {
            self.tfFromCardCVV.text = str;
            if (self.toCardFixed) {
                [self.tfSumma becomeFirstResponder];
            } else {
                [self.tfToCardNumber becomeFirstResponder];
            }
            return NO;
        } else {
            self.tfFromCardCVV.text = str;
            [self validate];
            return NO;
        }
    }
    if (textField == self.tfToCardNumber) {
        if ([str length] == 16) {
            self.tfToCardNumber.text = str;
            [self.tfSumma becomeFirstResponder];
            return NO;
        } else {
            self.tfToCardNumber.text = str;
            [self validate];
            return NO;
        }
    }
    textField.text = str;
    [self validate];
    return NO;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSString *slURL = webView.request.URL.absoluteString;
    if (([slURL rangeOfString:@"misc.roboxchange.com"].location != NSNotFound &&
        [slURL rangeOfString:@"Verify.ashx"].location == NSNotFound) || (
        [slURL rangeOfString:@"ws.roboxchange.com"].location != NSNotFound &&
        [slURL rangeOfString:@"Success.aspx"].location != NSNotFound)) {
        self.wv3D.hidden = YES;
        [self.wv3D loadHTMLString:@"" baseURL:nil];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *slURL = webView.request.URL.absoluteString;
    if (([slURL rangeOfString:@"misc.roboxchange.com"].location != NSNotFound &&
         [slURL rangeOfString:@"Verify.ashx"].location == NSNotFound) || (
         [slURL rangeOfString:@"ws.roboxchange.com"].location != NSNotFound &&
         [slURL rangeOfString:@"Success.aspx"].location != NSNotFound)) {
        self.wv3D.hidden = YES;
        [self.wv3D loadHTMLString:@"" baseURL:nil];
    }
}

#pragma mark - CardIOPaymentViewControllerDelegate

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)scanViewController {
    NSLog(@"User canceled payment info");
    [scanViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)scanViewController {
    NSLog(@"Received card info. Number: %@, expiry: %02i/%i, cvv: %@.", info.cardNumber, info.expiryMonth, info.expiryYear, info.cvv);
    self.tfFromCardNumber.text = info.cardNumber;
    if (info.expiryMonth != 0 && info.expiryYear != 0) {
        self.tfFromCardExpMonth.text = [NSString stringWithFormat:@"%02d", info.expiryMonth];
        self.tfFromCardExpYear.text = [[NSString stringWithFormat:@"%02d", (info.expiryYear + 2000)] substringWithRange:NSMakeRange(2, 2)];
//        self.tfFromCardCVV.text = info.cvv;
        [self.tfFromCardCVV becomeFirstResponder];
    } else {
        [self.tfFromCardExpMonth becomeFirstResponder];
    }
    [self validate];
    [scanViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
