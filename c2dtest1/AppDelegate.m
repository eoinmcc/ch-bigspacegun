//
//  AppDelegate.m
//  bigspacegun
//
//  Created by Eoin McCarthy on 6/05/12.
//  Copyright (c) 2012 cocoaheads All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"
#import "Game.h"


@implementation AppController
@synthesize mainMenuScene=_mainMenuScene;
@synthesize gameScene=_gameScene;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[super application:application didFinishLaunchingWithOptions:launchOptions];
    self.mainMenuScene = [[[MainMenuScene alloc] init] autorelease];
    [director_ pushScene: _mainMenuScene];
	return YES;
}

- (void)launchNewGame {
    self.gameScene = [[[GameScene alloc] init] autorelease];
    [director_ pushScene: _gameScene]; 

}

// Supported orientations: Landscape. Customize it for your own needs
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void) dealloc
{
	[window_ release];
	[navController_ release];

	[super dealloc];
}
@end
