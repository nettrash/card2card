//
//  HelpViewController.m
//  card2card
//
//  Created by Ivan Alekseev on 19.09.13.
//  Copyright (c) 2013 OCEAN BANK CJSC. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"HelpTitle", @"");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)btnSupport_Click : (id) sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:support@robokasa.ru"]];
}

@end
