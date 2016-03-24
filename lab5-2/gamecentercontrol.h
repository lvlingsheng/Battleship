//
//  GCHelper.h
//  
//
//  Created by 吕凌晟 on 15/11/3.
//
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface gamecentercontrol : NSObject {
    
    BOOL gameCentreAvailable;
    BOOL userAuthenticated;
    
}

@property (assign, readonly) BOOL gameCentreAvailable;

+ (gamecentercontrol *)sharedInstance;

-(void)authenticateLocalUser;

- (void) reportScore: (int64_t) score forLeaderboardID: (NSString*) identifier;
@end