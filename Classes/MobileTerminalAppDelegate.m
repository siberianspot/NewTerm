// MobileTerminalAppDelegate.m
// MobileTerminal

#import "MobileTerminalAppDelegate.h"
#import "MobileTerminalViewController.h"

@implementation MobileTerminalAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
  [[UIApplication sharedApplication] setStatusBarHidden:YES];
  [window addSubview:viewController.view];
  [window makeKeyAndVisible];
}


- (void)dealloc {
  [viewController release];
  [window release];
  [super dealloc];
}


@end