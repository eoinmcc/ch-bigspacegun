//
//  AppDelegate.h
//  bigspacegun
//
//  Created by Eoin McCarthy on 6/05/12.
//  Copyright (c) 2012 cocoaheads. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseAppController.h"
#import "MainMenuScene.h"
#import "Game.h"

@interface AppController : BaseAppController
{
    MainMenuScene* _mainMenuScene;
    GameScene* _gameScene;
}
@property (nonatomic, retain) MainMenuScene *mainMenuScene;
@property (nonatomic, retain) GameScene *gameScene;

- (void)launchNewGame;
@end
