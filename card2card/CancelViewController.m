//
//  CancelViewController.m
//  card2card
//
//  Created by Ivan Alekseev on 17.09.13.
//  Copyright (c) 2013 OCEAN BANK CJSC. All rights reserved.
//

#import "CancelViewController.h"

@interface CancelViewController ()

@end

@implementation CancelViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) btnBack_Click : (id) sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
