//
//  BANScoreboardPlayer.h
//  BANMLBScoreboard
//
//  Created by Brent Nycum on 3/26/14.
//  Copyright (c) 2014 It's Brent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BANScoreboardPlayer : NSObject

@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSString *rosterName;

@property (nonatomic, retain) NSNumber *number;

@property (nonatomic, retain) NSNumber *era;
@property (nonatomic, retain) NSNumber *wins;
@property (nonatomic, retain) NSNumber *loses;
@property (nonatomic, retain) NSNumber *saves;

@property (nonatomic, retain) NSNumber *homeruns;
@property (nonatomic, retain) NSNumber *gameHomeruns;

@end
