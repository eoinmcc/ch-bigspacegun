//
//  HelloWorldLayer.m
//  bigspacegun
//
//  Created by Eoin McCarthy on 6/05/12.
//  Copyright (c) 2012 cocoaheads. All rights reserved.
//


// Import the interfaces
#import "Game.h"
#import "CCTouchDispatcher.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

@implementation GameScene
@synthesize layer = _layer;

- (id)init {
    
    if ((self = [super init])) {
        self.layer = [[[Game alloc] init] autorelease];
        [self addChild:_layer];
    }
    return self;
}

@end

#pragma mark - Game

// Game implementation
@implementation Game
@synthesize enemies = _enemies;
@synthesize projectiles = _projectiles;
@synthesize batchNode = _batchNode;
@synthesize level_bkgrnd = _level_bkgrnd;
@synthesize player = _player;
@synthesize nextProjectile =_nextProjectile;

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	if( (self=[super init]) ) {
        
        self.isTouchEnabled = YES;
        _hasEnemies = NO;
        self.enemies = [[[NSMutableArray alloc] init] autorelease];
        self.projectiles = [[[NSMutableArray alloc] init] autorelease];
        
        self.batchNode = [CCSpriteBatchNode batchNodeWithFile:@"sprites.png"];
        [self addChild:_batchNode z:0];
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        self.level_bkgrnd = [CCSprite spriteWithFile:@"background.png"];
        _level_bkgrnd.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:self.level_bkgrnd z:-1];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"sprites.plist"];
        // Add tom to the scene
        static int TOM_LEFT_MARGIN = 80;
        self.player = [CCSprite spriteWithSpriteFrameName:@"enemy_7.png"];
        _player.position = ccp(_player.contentSize.width/2 + TOM_LEFT_MARGIN, winSize.height/2);
        [self addChild:_player z:1];
	}
	return self;
}

- (void)onEnter {
    
    [super onEnter];
    //Clear all other sprites
    for (CCSprite *enemies in _enemies) {
        [_batchNode removeChild:enemies cleanup:YES];
    }
    [_enemies removeAllObjects];
    
    for (CCSprite *projectile in _projectiles) {
        [_batchNode removeChild:projectile cleanup:YES];
    }
    [_projectiles removeAllObjects];
    
    // Schedule loops
    [self schedule:@selector(update:)];
    [self schedule:@selector(gameLogic:) interval:0.1f];    
}

- (void)gameLogic:(ccTime)dt {
    if([_enemies count]==0) {
        [self addEnemies];
        _hasEnemies = YES;
    }
}

- (void)update:(ccTime)dt {
    NSMutableArray *projectilesToDelete = [[NSMutableArray alloc] init];
	for (CCSprite *projectile in _projectiles) {
		CGRect projectileRect = CGRectMake(projectile.position.x - (projectile.contentSize.width/2),
										   projectile.position.y - (projectile.contentSize.height/2),
										   projectile.contentSize.width,
										   projectile.contentSize.height);
        
        CCSprite * enemy = nil;
		for (CCSprite *curEnemy in _enemies) {
			CGRect enemyRect = CGRectMake(curEnemy.position.x - (curEnemy.contentSize.width/2),
										    curEnemy.position.y - (curEnemy.contentSize.height/2),
										    curEnemy.contentSize.width,
										    curEnemy.contentSize.height);
			if (CGRectIntersectsRect(projectileRect, enemyRect)) {
                enemy = curEnemy;
                break;
			}
		}
        
		if (enemy != nil) {
            
            // Remove the monster if it's dead
                [_enemies removeObject:enemy];
                [_batchNode removeChild:enemy cleanup:YES];
            
            // Add the projectile to the list to delete
			[projectilesToDelete addObject:projectile];
		}
	}
    
	for (CCSprite *projectile in projectilesToDelete) {
		[_projectiles removeObject:projectile];
		[_batchNode removeChild:projectile cleanup:YES];
	}
	[projectilesToDelete release];
}

-(void) addEnemies {
    for (int i=0;i<10;i++) {
//        int enemyId = i;
        [self addEnemy];
    }
}

-(void)addEnemy {
    int rand = arc4random() % 4;
    NSString* enemySprite;
    switch (rand) {
        case 0:
            enemySprite = @"enemy_1a.png";
            break;
        case 1:
            enemySprite = @"enemy_2a.png";
            break;
        case 2:
            enemySprite = @"enemy_3.png";
            break;
        case 3:
            enemySprite = @"enemy_4a.png";
            break;
        default:
            break;
    }
    CCSprite* enemy = [CCSprite spriteWithSpriteFrameName:enemySprite];
	// Determine where to spawn the monster along the Y axis
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	int minY = enemy.contentSize.height/2;
	int maxY = winSize.height - enemy.contentSize.height/2;
	int rangeY = maxY - minY;
	int actualY = (arc4random() % rangeY) + minY;
    
	// Create the monster slightly off-screen along the right edge,
	// and along a random position along the Y axis as calculated above
	enemy.position = ccp(winSize.width + (enemy.contentSize.width/2), actualY);
	[_batchNode addChild:enemy z:1];
    
	// Determine speed of the enemy
	int minDuration = 2.0; //2.0;
	int maxDuration = 4.0; //4.0;
	int rangeDuration = maxDuration - minDuration;
	int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
	// Create the actions
    static int X_OFFSET = 40;
	id actionMove = [CCMoveTo actionWithDuration:actualDuration position:ccp(X_OFFSET+enemy.contentSize.width/2, actualY)];
    id actionPause = [CCDelayTime actionWithDuration:0.5f];
    id actionMoveBack = [CCMoveTo actionWithDuration:actualDuration position:enemy.position];
	id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)];
	[enemy runAction:[CCSequence actions:actionMove, actionPause, actionMoveBack, actionMoveDone, nil]];
    
	// Add to monsters array
	enemy.tag = 1;
	[_enemies addObject:enemy];
    
}

-(void)spriteMoveFinished:(id)sender {
    
	CCSprite *sprite = (CCSprite *)sender;
	[_batchNode removeChild:sprite cleanup:YES];
    
	if (sprite.tag == 1) { // monster
		[_enemies removeObject:sprite];
	} else if (sprite.tag == 2) { // projectile
		[_projectiles removeObject:sprite];
	}
    
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint location = [self convertTouchToNodeSpace: touch];
    
    if(location.x < 200) {
        //MOVE
        location.x = _player.position.x;
        [_player runAction: [CCMoveTo actionWithDuration:1 position:location]];
    } else {
        //SHOOT
        if (_nextProjectile != nil) return;

        self.nextProjectile = [CCSprite spriteWithSpriteFrameName:@"blast_01.png"];
        
        // Actually set up the actions
        [_player runAction:[CCSequence actions:
                            [CCCallFunc actionWithTarget:self selector:@selector(finishShoot)],
                            nil]];

        
        // Move projectile offscreen
        
        ccTime delta = 1.0f;

        CGPoint overshotVector = location;//CGPointMake(1076.0f, location.y);
        
        [_nextProjectile runAction:[CCSequence actions:
                                    [CCMoveTo actionWithDuration:delta position:overshotVector],
                                    [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)],
                                    nil]];
        
        // Add to projectiles array
        _nextProjectile.tag = 2;
    }
        
//	[_player runAction: [CCMoveTo actionWithDuration:1 position:location]];
}

- (void)finishShoot {
    
    // Ok to add now - we've finished rotation!
    _nextProjectile.position = [_player convertToWorldSpace:ccp(_player.contentSize.width, _player.contentSize.height/2)];
    [_batchNode addChild:_nextProjectile z:1];
    [_projectiles addObject:_nextProjectile];
    
    // Release
    [_nextProjectile release];
    _nextProjectile = nil;
    
}

-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    
}

- (void) dealloc
{
    self.enemies = nil;
    self.projectiles = nil;
    
    [super dealloc];
}


#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
