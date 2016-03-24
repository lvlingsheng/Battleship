//
//  GCHelper.m
//  
//
//  Created by 吕凌晟 on 15/11/3.
//
//

#import "gamecentercontrol.h"

@interface gamecentercontrol () <GKGameCenterControllerDelegate> {
    
    BOOL _gameCenterFeaturesEnabled;
    
}
@end


@implementation gamecentercontrol

@synthesize gameCentreAvailable;

static gamecentercontrol *sharedControl = nil;
//+ (gamecentercontrol *) sharedInstance {
//    if (!sharedControl) {
//        sharedControl = [[gamecentercontrol alloc]init];
//    }
//    return sharedControl;
//}

+ (gamecentercontrol *) sharedInstance {
    static gamecentercontrol *sharedGameKitHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGameKitHelper =
        [[gamecentercontrol alloc] init];
    });
    return sharedGameKitHelper;
}

-(BOOL)isGameCentreAvailable {
    // check for presence of GKLocalPlayer API
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    //check if the device is running iOS 4.1 or later
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
}

- (id)init {
    if ((self = [super init])) {
        
        gameCentreAvailable = [self isGameCentreAvailable];
        if (gameCentreAvailable) {
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            [nc addObserver:self selector:@selector(authenticationChanged) name:GKPlayerAuthenticationDidChangeNotificationName object:nil];
        }
        
    }
    return self;
}


- (void)authenticationChanged {
    
    if ([GKLocalPlayer localPlayer].isAuthenticated && !userAuthenticated) {
        NSLog(@"Authentication Changed. User Authenticated");
        userAuthenticated = TRUE;
    }
    else if (![GKLocalPlayer localPlayer].isAuthenticated && userAuthenticated) {
        
        NSLog(@"Authentication Changed. User Not Authenticated");
        userAuthenticated = FALSE;
    }
    
}


-(void) authenticateLocalUser {
    if ([GKLocalPlayer localPlayer].authenticated == NO) {
        GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
        
        localPlayer.authenticateHandler = ^(UIViewController *gcvc,NSError *error) {
            
            if(gcvc) {
                
                [self presentViewController:gcvc];
            }
            else {
                _gameCenterFeaturesEnabled = NO;
            }
        };
    }
    
    else if ([GKLocalPlayer localPlayer].authenticated == YES){
        _gameCenterFeaturesEnabled = YES;
    }
    
}

-(UIViewController*) getRootViewController {
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}

-(void)presentViewController:(UIViewController*)gcvc {
    UIViewController* rootVC = [self getRootViewController];
    [rootVC presentViewController:gcvc animated:YES completion:nil];
}


-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController {
    
    
}

- (void) reportScore: (int64_t) score forLeaderboardID: (NSString*) identifier
{
    GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier: identifier];
    scoreReporter.value = score;
    scoreReporter.context = 0;
    
    NSArray *scores = @[scoreReporter];
    [GKScore reportScores:scores withCompletionHandler:^(NSError *error) {
        //Do something interesting here.
    }];
}

@end