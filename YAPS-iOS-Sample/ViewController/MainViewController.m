//
//  MainViewController.m
//  YAPS-iOS-Sample
//
//  Created by Lars Bergelt on 03.06.13.
//  Copyright (c) 2013 Visual Art & Design - Lars Bergelt. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePush:) name:@"YAPS_RECEIVE_PUSH" object:nil];
    
    NSString *appVersionsnumber = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *bundleVersionnumber = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    UILabel *version = [[UILabel alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height - 20.0, self.view.frame.size.width, 20.0)];
    version.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    version.textAlignment = UITextAlignmentCenter;
    version.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0];
    version.text = [NSString stringWithFormat:@"%@-%@",appVersionsnumber, bundleVersionnumber];
    version.tag = 1111;
    [self.view addSubview:version];
    [version release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) receivePush:(NSNotification *)notification {
    for (UIView *view in self.view.subviews) {
        if (view.tag != 1111) {
            [view removeFromSuperview];
        }
    }
    
    NSDictionary *pushDict = [notification object];
//    NSDictionary *aps = [pushDict valueForKey:@"aps"];
//    NSString *pushMessage = [aps valueForKey:@"alert"];
    NSString *pushMessage = [pushDict description];
    
    CGSize maximumSize = CGSizeMake(self.view.frame.size.width - 40.0, 9999);
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
    CGSize messageSize = [pushMessage sizeWithFont:font constrainedToSize:maximumSize lineBreakMode:NSLineBreakByWordWrapping];
    
    UILabel *push = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 20.0, messageSize.width, messageSize.height)];
    push.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    push.textAlignment = UITextAlignmentLeft;
    push.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
    push.text = pushMessage;
    push.numberOfLines = 0;
    push.lineBreakMode = NSLineBreakByWordWrapping;
    push.tag = 2222;
    [self.view addSubview:push];
    [push release];
    
}

@end
