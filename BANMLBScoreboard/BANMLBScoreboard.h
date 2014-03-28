//
//  BANMLBScoreboard.h
//  BANMLBScoreboard
//
//  Created by Brent Nycum on 3/27/14.
//  Copyright (c) 2014 It's Brent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

#import "BANScoreboardGame.h"
#import "BANScoreboardInning.h"
#import "BANScoreboardPlayer.h"

@interface BANMLBScoreboard : AFHTTPRequestOperationManager

+ (instancetype)sharedClient;

- (void)todaysGames:(void (^)(NSArray *games, NSError *error))block;

@end
