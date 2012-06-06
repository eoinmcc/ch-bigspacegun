//
//  MainMenuScreen.h
//  bigspacegun
//
//  Created by Eoin McCarthy on 5/06/12.
//  Copyright (c) 2012 cocoaheads. All rights reserved.
//

#import "cocos2d.h"

@interface MainMenuLayer : CCLayer {
    CCSprite *_main_bkgrnd;
}

@property (nonatomic, assign) CCSprite *main_bkgrnd;

@end

@interface MainMenuScene : CCScene {
    MainMenuLayer *_layer;
}

@property (nonatomic, assign) MainMenuLayer *layer;

@end
