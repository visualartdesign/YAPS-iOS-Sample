//
//  AppDelegate.m
//  YAPP-iOS-Sample
//
//  Created by Lars Bergelt on 03.06.13.
//  Copyright (c) 2013 Visual Art & Design - Lars Bergelt. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import <AudioToolbox/AudioToolbox.h>

// Wordpress URL
#warning Enter your Wordpress URL.
#define     YAPPURL     @""

// YAPP Password
#warning Enter your YAPP-Password. You find it at the Wordpress YAPP Options page
#define     YAPPKEY     @""

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    MainViewController *mVC = [[MainViewController alloc] init];
    self.viewController = mVC;
    self.window.rootViewController = _viewController;
    [mVC release];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    
    // Reset app badge count.
    [application setApplicationIconBadgeNumber:0];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

#pragma mark -
#pragma mark Push Service

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
#if !TARGET_IPHONE_SIMULATOR
    if (YAPPURL.length <= 0) {
        [self alertNotice:@"" withMessage:@"Error in registration. Please set the 'YAPPURL' in your app." cancleButtonTitle:@"OK" otherButtonTitle:@""];
        return;
    }
    
    NSString *dt = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	dt = [dt stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // DEVICE TOKEN
	NSString *getString = [NSString stringWithFormat:@"?yapp-api[deviceId]=%@", dt];
    
    // OS TYPE
    getString = [getString stringByAppendingString:@"&yapp-api[type]=ios"];
    
    // YAPP KEY
    getString = [getString stringByAppendingString:@"&yapp-api[passkey]="];
    getString = [getString stringByAppendingString:YAPPKEY];
    
    // BADGE COUNT
    getString = [getString stringByAppendingString:@"&yapp-api[badgeCount]="];
    getString = [getString stringByAppendingString:[NSString stringWithFormat:@"%d", [UIApplication sharedApplication].applicationIconBadgeNumber]];
    
    // DEVELOPER STATUS
#ifdef DEBUG
    getString = [getString stringByAppendingString:@"&yapp-api[development]="];
    getString = [getString stringByAppendingString:@"sandbox"];
#else
    getString = [getString stringByAppendingString:@"&yapp-api[development]="];
    getString = [getString stringByAppendingString:@"production"];
#endif
    
	NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@", YAPPURL, getString]];
    
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    
    
#ifdef DEBUG
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *responseTxt = [[[NSString alloc] initWithData:returnData encoding:NSASCIIStringEncoding] autorelease];
    NSLog(@"Full RegisterURL : '%@'", url);
    NSLog(@"Device Token : %@", deviceToken);
    NSLog(@"Response: %@", responseTxt);
#else
    [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
#endif
    
    [url release];
    [request release];
    
    
    [app setApplicationIconBadgeNumber:0];
#endif
    
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
#ifdef DEBUG
    NSLog(@"Error in registration. Error: %@", err);
#endif
    
#if !TARGET_IPHONE_SIMULATOR
    [self alertNotice:@"" withMessage:[NSString stringWithFormat:@"Error in registration. Error: %@", err] cancleButtonTitle:@"OK" otherButtonTitle:@""];
#endif
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {

#if !TARGET_IPHONE_SIMULATOR

#ifdef DEBUG
    NSLog(@"userInfo : %@", [userInfo description]);
#endif
    
    switch ( [[UIApplication sharedApplication] applicationState]) {
        case UIApplicationStateActive:
            NSLog(@"UIApplicationStateActive");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"YAPP_RECEIVE_PUSH" object:userInfo];
            
            [self playSound:[[userInfo valueForKey:@"aps"] valueForKey:@"sound"]];
            
            break;
        case UIApplicationStateInactive:
            NSLog(@"UIApplicationStateInactive");
            
            break;
        case UIApplicationStateBackground:
            NSLog(@"UIApplicationStateBackground");
            
            break;
            
        default:
            break;
    }
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
#endif
}

- (void) playSound:(NSString *)soundfile {
    if (soundfile == nil) return;
    
    if ([soundfile isEqualToString:@"default"]) {
        AudioServicesPlaySystemSound(1002);
        return;
    }
    
    NSString *soundpath = [[NSBundle mainBundle] pathForResource:[soundfile stringByDeletingPathExtension] ofType:[soundfile pathExtension]];
    
    if (!soundpath) return;
    
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:soundpath], &soundID);
    AudioServicesPlaySystemSound (soundID);
}

#pragma mark -
#pragma mark Alert

- (void) alertNotice:(NSString *)title withMessage:(NSString *)message cancleButtonTitle:(NSString *)cancleTitle otherButtonTitle:(NSString *)otherTitle{
    UIAlertView *alert;
    
    if([otherTitle isEqualToString:@""])
        alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancleTitle otherButtonTitles:nil];
    else
        alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancleTitle otherButtonTitles:otherTitle,nil];
    
    [alert show];
    [alert release];
}

@end
