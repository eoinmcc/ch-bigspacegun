//
//  MainMenuScreen.m
//  bigspacegun
//
//  Created by Eoin McCarthy on 5/06/12.
//  Copyright (c) 2012 cocoaheads. All rights reserved.
//

#import "MainMenuScene.h"
#import "AppDelegate.h"

@implementation MainMenuScene
@synthesize layer = _layer;

- (id)init {
    
    if ((self = [super init])) {
        self.layer = [[[MainMenuLayer alloc] init] autorelease];
        [self addChild:_layer];
    }
    return self;
    
}

@end

@implementation MainMenuLayer
@synthesize main_bkgrnd = _main_bkgrnd;

- (id) init {
    
    if ((self = [super init])) {
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        self.main_bkgrnd = [CCSprite spriteWithFile:@"background.png"];
        _main_bkgrnd.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:_main_bkgrnd];
        CCSprite *newGameSprite = [CCSprite spriteWithFile:@"new-game.png"];
        CCMenuItem *newGameItem = [CCMenuItemSprite itemWithNormalSprite:newGameSprite selectedSprite:nil target:self selector:@selector(newGameSpriteTapped:)];
        CCMenu *menu = [CCMenu menuWithItems:newGameItem, nil];
        [self addChild:menu];
        
    }
    
    return self;
    
}

- (void)newGameSpriteTapped:(id)sender {
    NSLog(@"New Game");
    AppController *delegate = (AppController *) [UIApplication sharedApplication].delegate;
    [delegate launchNewGame];
    
}

@end
