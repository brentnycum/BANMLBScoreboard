//
//  BANScoreboardGame.h
//  BANMLBScoreboard
//
//  Created by Brent Nycum on 3/26/14.
//  Copyright (c) 2014 It's Brent. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BANScoreboardPlayer;

@interface BANScoreboardGame : NSObject

@property (nonatomic, retain) NSString *scoreboardId;

@property (nonatomic, retain) NSString *homeTeamAbbrev;
@property (nonatomic, retain) NSString *homeTeamCity;
@property (nonatomic, retain) NSString *homeTeamName;
@property (nonatomic, retain) NSNumber *homeTeamWins;
@property (nonatomic, retain) NSNumber *homeTeamLoses;

@property (nonatomic, retain) NSString *awayTeamAbbrev;
@property (nonatomic, retain) NSString *awayTeamCity;
@property (nonatomic, retain) NSString *awayTeamName;
@property (nonatomic, retain) NSNumber *awayTeamWins;
@property (nonatomic, retain) NSNumber *awayTeamLoses;

@property (nonatomic, retain) NSString *gameStatus;
@property (nonatomic, retain) NSString *gameStatusInd;
@property (nonatomic, retain) NSNumber *gameInning;
@property (nonatomic, assign) BOOL gameTopOfInning;

@property (nonatomic, retain) NSArray *lineScoreInnings;

@property (nonatomic, retain) NSNumber *awayTeamRuns;
@property (nonatomic, retain) NSNumber *homeTeamRuns;

@property (nonatomic, retain) NSNumber *awayTeamHits;
@property (nonatomic, retain) NSNumber *homeTeamHits;

@property (nonatomic, retain) NSNumber *awayTeamErrors;
@property (nonatomic, retain) NSNumber *homeTeamErrors;

@property (nonatomic, retain) NSString *homeTeamTV;
@property (nonatomic, retain) NSString *homeTeamRadio;

@property (nonatomic, retain) NSString *awayTeamTV;
@property (nonatomic, retain) NSString *awayTeamRadio;

@property (nonatomic, retain) BANScoreboardPlayer *winningPitcher;
@property (nonatomic, retain) BANScoreboardPlayer *losingPitcher;
@property (nonatomic, retain) BANScoreboardPlayer *savePitcher;

@property (nonatomic, retain) BANScoreboardPlayer *homeProbablePitcher;
@property (nonatomic, retain) BANScoreboardPlayer *awayProbablePitcher;

@property (nonatomic, retain) NSArray *homeRuns;

@end
