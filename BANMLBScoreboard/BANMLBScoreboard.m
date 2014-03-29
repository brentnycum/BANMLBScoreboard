//
//  BANMLBScoreboard.m
//  BANMLBScoreboard
//
//  Created by Brent Nycum on 3/27/14.
//  Copyright (c) 2014 It's Brent. All rights reserved.
//

#import "BANMLBScoreboard.h"

#import <RaptureXML/RXMLElement.h>

static NSString * const BANMLBScoreboardBaseURLString = @"http://gdx.mlb.com/components/game/mlb/year_2014/";

@implementation BANMLBScoreboard

#pragma mark - Singleton

+ (instancetype)sharedClient {
	static BANMLBScoreboard *_sharedClient = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_sharedClient = [[BANMLBScoreboard alloc] initWithBaseURL:[NSURL URLWithString:BANMLBScoreboardBaseURLString]];
		_sharedClient.responseSerializer = [AFXMLParserResponseSerializer new];
	});

	return _sharedClient;
}

#pragma mark - BANMLBScoreboard

- (void)todaysGames:(void (^)(NSArray *games, NSError *error))block {
	[self GET:@"" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSMutableArray *games = [NSMutableArray array];
		
		RXMLElement *xml = [RXMLElement elementFromXMLString:operation.responseString encoding:operation.responseStringEncoding];
		
		[xml iterate:@"game" usingBlock:^(RXMLElement *game) {
			BANScoreboardGame *scoreboardGame = [[BANScoreboardGame alloc] init];
			
			scoreboardGame.scoreboardId = [game attribute:@"id"];
			
			RXMLElement *gameStatus = [game child:@"status"];
			
			scoreboardGame.gameStatus = [gameStatus attribute:@"status"];
			scoreboardGame.gameStatusInd = [gameStatus attribute:@"ind"];
			scoreboardGame.gameInning = [NSNumber numberWithInteger:[gameStatus attributeAsInt:@"inning"]];
			scoreboardGame.gameTopOfInning = [[gameStatus attribute:@"top_inning"] isEqualTo:@"Y"];
			
			gameStatus = nil;
			
			scoreboardGame.awayTeamAbbrev = [game attribute:@"away_name_abbrev"];
			scoreboardGame.awayTeamCity = [game attribute:@"away_team_city"];
			scoreboardGame.awayTeamName = [game attribute:@"away_team_name"];
			scoreboardGame.awayTeamWins = [NSNumber numberWithInteger:[game attributeAsInt:@"away_win"]];
			scoreboardGame.awayTeamLoses = [NSNumber numberWithInteger:[game attributeAsInt:@"away_loss"]];
			
			scoreboardGame.homeTeamAbbrev = [game attribute:@"home_name_abbrev"];
			scoreboardGame.homeTeamCity = [game attribute:@"home_team_city"];
			scoreboardGame.homeTeamName = [game attribute:@"home_team_name"];
			scoreboardGame.homeTeamWins = [NSNumber numberWithInteger:[game attributeAsInt:@"home_win"]];
			scoreboardGame.homeTeamLoses = [NSNumber numberWithInteger:[game attributeAsInt:@"home_loss"]];
			
			if ([game child:@"linescore"]) {
				NSMutableArray *innings = [NSMutableArray array];
				
				[game iterate:@"linescore.inning" usingBlock:^(RXMLElement *inning) {
					BANScoreboardInning *gameInning = [[BANScoreboardInning alloc] init];
					
					gameInning.awayTeamRuns = [NSNumber numberWithInteger:[inning attributeAsInt:@"away"]];
					
					if ([inning attribute:@"home"]) {
						gameInning.homeTeamRuns = [NSNumber numberWithInteger:[inning attributeAsInt:@"home"]];
					}
					
					[innings addObject:gameInning];
				}];
				
				RXMLElement *gameRuns = [game child:@"linescore.r"];
				
				scoreboardGame.awayTeamRuns = [NSNumber numberWithInteger:[gameRuns attributeAsInt:@"away"]];
				scoreboardGame.homeTeamRuns = [NSNumber numberWithInteger:[gameRuns attributeAsInt:@"home"]];
				
				gameRuns = nil;
				
				RXMLElement *gameHits = [game child:@"linescore.h"];
				
				scoreboardGame.awayTeamHits = [NSNumber numberWithInteger:[gameRuns attributeAsInt:@"away"]];
				scoreboardGame.homeTeamHits = [NSNumber numberWithInteger:[gameRuns attributeAsInt:@"home"]];
				
				gameHits = nil;
				
				RXMLElement *gameErrors = [game child:@"linescore.e"];
				
				scoreboardGame.awayTeamErrors = [NSNumber numberWithInteger:[gameRuns attributeAsInt:@"away"]];
				scoreboardGame.homeTeamErrors = [NSNumber numberWithInteger:[gameRuns attributeAsInt:@"home"]];
				
				gameErrors = nil;
			}
			
			scoreboardGame.awayTeamTV = [[game child:@"broadcast.away.tv"] text];
			scoreboardGame.awayTeamRadio = [[game child:@"broadcast.away.radio"] text];
			
			scoreboardGame.homeTeamTV = [[game child:@"broadcast.home.tv"] text];
			scoreboardGame.homeTeamRadio = [[game child:@"broadcast.home.radio"] text];
			
			RXMLElement *winningPitcher = [game child:@"winning_pitcher"];
			
			if (winningPitcher) {
				BANScoreboardPlayer *player = [[BANScoreboardPlayer alloc] init];
				player.firstName = [winningPitcher attribute:@"first"];
				player.lastName = [winningPitcher attribute:@"last"];
				player.rosterName = [winningPitcher attribute:@"name_display_roster"];
				
				scoreboardGame.winningPitcher = player;
				
				winningPitcher = nil;
			}
			
			RXMLElement *losingPitcher = [game child:@"losing_pitcher"];
			
			if (losingPitcher) {
				BANScoreboardPlayer *player = [[BANScoreboardPlayer alloc] init];
				player.firstName = [losingPitcher attribute:@"first"];
				player.lastName = [losingPitcher attribute:@"last"];
				player.rosterName = [losingPitcher attribute:@"name_display_roster"];
				
				scoreboardGame.losingPitcher = player;
				
				losingPitcher = nil;
			}
			
			RXMLElement *savePitcher = [game child:@"save_pitcher"];
			
			if (savePitcher) {
				BANScoreboardPlayer *player = [[BANScoreboardPlayer alloc] init];
				player.firstName = [savePitcher attribute:@"first"];
				player.lastName = [savePitcher attribute:@"last"];
				player.rosterName = [savePitcher attribute:@"name_display_roster"];
				
				scoreboardGame.savePitcher = player;
				
				savePitcher = nil;
			}
			
			[games addObject:scoreboardGame];
		}];
		
		if (block) {
			block(games, nil);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (block) {
			block(nil, error);
		}
	}];
}

@end
