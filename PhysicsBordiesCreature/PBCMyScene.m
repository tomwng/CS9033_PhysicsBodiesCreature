//
//  PBCMyScene.m
//  PhysicsBordiesCreature
//
//  Created by Tom on 2/18/14.
//  Copyright (c) 2014 Tom. All rights reserved.
//

#import "PBCMyScene.h"

@implementation PBCMyScene

-(void)addSquare {
	SKSpriteNode *sq = [SKSpriteNode new];
	sq = [SKSpriteNode spriteNodeWithColor: [SKColor colorWithHue: self.hue
													   saturation: 1
													   brightness: 1
															alpha: 0.75]
									  size: CGSizeMake(20, 20)];
	[sq setPosition:CGPointMake(CGRectGetMidX(self.frame),
								CGRectGetMidY(self.frame))];
	sq.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize: sq.size];
	[self.mySquares addObject: sq];
	[self addChild: [self.mySquares lastObject]];
	self.hue += 1.0 / 12;
	self.hue -= floor(self.hue);
}

-(void)addJoint {
	switch(self.jointMode) {
		case 1: [self addJointLimit]; break;
		case 2: [self addJointSpring]; break;
		default:
			if(arc4random() % 2) {
				[self addJointLimit];
			} else {
				[self addJointSpring];
			}
	}
}

-(void)addJointLimit {
	unsigned long l = [self.mySquares count];
	// if there are 2+ squares, joint last two
	if(l < 2) return;
	SKPhysicsJointLimit *j = [SKPhysicsJointLimit new];
	j = [SKPhysicsJointLimit jointWithBodyA: [[self.mySquares objectAtIndex: l - 2] physicsBody]
									  bodyB: [[self.mySquares objectAtIndex: l - 1] physicsBody]
									anchorA: [[self.mySquares objectAtIndex: l - 2] position]
									anchorB: [[self.mySquares objectAtIndex: l - 1] position]];
	j.maxLength = 25;
	[self.physicsWorld addJoint: j];
}

-(void)addJointSpring {
	unsigned long l = [self.mySquares count];
	if(l < 2) return;
	SKPhysicsJointPin *j = [SKPhysicsJointPin new];
	j = [SKPhysicsJointPin jointWithBodyA: [[self.mySquares objectAtIndex: l - 2] physicsBody]
									bodyB: [[self.mySquares objectAtIndex: l - 1] physicsBody]
								   anchor: [[self.mySquares objectAtIndex: l - 1] position]];
	[self.physicsWorld addJoint: j];
}

-(void)spawnBackgroundSettings {
	self.scaleMode = SKSceneScaleModeAspectFit;
	self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect: self.frame];
	[self.physicsBody setRestitution:0.5]; // bounciness
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
		
		self.mySquares = [NSMutableArray array];
		self.hue = 0.0;
		self.jointMode = 1;

		SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
		myLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        myLabel.fontSize = 12;
        myLabel.position = CGPointMake(6, 6);
        switch(self.jointMode) {
			case 1: myLabel.text = @"Joint mode: limit"; break;
			case 2: myLabel.text = @"Joint mode: spring"; break;
			default: myLabel.text = @"Joint mode: random"; break;
		}
        
        [self addChild:myLabel];

		[self spawnBackgroundSettings];
		[self addSquare];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
	
	[self addSquare];
	[self addJoint];
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
		[[[self.mySquares objectAtIndex: 0] physicsBody] setDynamic: NO];
        [[self.mySquares objectAtIndex: 0] setPosition:location];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        [[self.mySquares objectAtIndex: 0] setPosition:location	];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
		[[[self.mySquares objectAtIndex: 0] physicsBody] setDynamic: YES];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end // @implementation PBCMyScene
