//
//  HelloWorldLayer.h
//  bigspacegun
//
//  Created by Eoin McCarthy on 6/05/12.
//  Copyright (c) 2012 cocoaheads. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

@interface Game : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
    NSMutableArray *_enemies;
    NSMutableArray *_projectiles;
    CCSpriteBatchNode *_batchNode;
    CCSprite* _level_bkgrnd;
    CCSprite* _player;
    CCSprite* _nextProjectile;
    
    BOOL _hasEnemies;
}

@property (nonatomic, retain) NSMutableArray *enemies;
@property (nonatomic, retain) NSMutableArray *projectiles;
@property (nonatomic, retain) CCSpriteBatchNode *batchNode;
@property (nonatomic, retain) CCSprite* level_bkgrnd;
@property (nonatomic, retain) CCSprite* player;
@property (nonatomic, retain) CCSprite* nextProjectile;
@end

@interface GameScene : CCScene {
    Game *_layer;
}

@property (nonatomic, assign) Game *layer;

@end

