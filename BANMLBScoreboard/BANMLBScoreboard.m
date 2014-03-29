//
//  BANMLBScoreboard.m
//  BANMLBScoreboard
//
//  Created by Brent Nycum on 3/27/14.
//  Copyright (c) 2014 It's Brent. All rights reserved.
//

#import "BANMLBScoreboard.h"

#import <RaptureXML/RXMLElement.h>

static NSString * const BANMLBScoreboardBaseURLString = @"http://gdx.mlb.com/components/game/mlb/";

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
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"'year_'yyyy'/month_'MM'/day_'dd'/scoreboard_mac.xml"];
	
	NSDate *today = [NSDate date];
	
	[self GET:[formatter stringFromDate:today] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
				player.number = [NSNumber numberWithInteger:[winningPitcher attributeAsInt:@"number"]];
				player.wins = [NSNumber numberWithInteger:[winningPitcher attributeAsInt:@"wins"]];
				player.loses = [NSNumber numberWithInteger:[winningPitcher attributeAsInt:@"loses"]];
				player.era = [NSNumber numberWithDouble:[winningPitcher attributeAsDouble:@"era"]];
				
				scoreboardGame.winningPitcher = player;
				
				winningPitcher = nil;
			}
			
			RXMLElement *losingPitcher = [game child:@"losing_pitcher"];
			
			if (losingPitcher) {
				BANScoreboardPlayer *player = [[BANScoreboardPlayer alloc] init];
				player.firstName = [losingPitcher attribute:@"first"];
				player.lastName = [losingPitcher attribute:@"last"];
				player.rosterName = [losingPitcher attribute:@"name_display_roster"];
				player.number = [NSNumber numberWithInteger:[losingPitcher attributeAsInt:@"number"]];
				player.wins = [NSNumber numberWithInteger:[losingPitcher attributeAsInt:@"wins"]];
				player.loses = [NSNumber numberWithInteger:[losingPitcher attributeAsInt:@"loses"]];
				player.era = [NSNumber numberWithDouble:[losingPitcher attributeAsDouble:@"era"]];
				
				scoreboardGame.losingPitcher = player;
				
				losingPitcher = nil;
			}
			
			RXMLElement *savePitcher = [game child:@"save_pitcher"];
			
			if (savePitcher) {
				BANScoreboardPlayer *player = [[BANScoreboardPlayer alloc] init];
				player.firstName = [savePitcher attribute:@"first"];
				player.lastName = [savePitcher attribute:@"last"];
				player.rosterName = [savePitcher attribute:@"name_display_roster"];
				player.number = [NSNumber numberWithInteger:[savePitcher attributeAsInt:@"number"]];
				player.wins = [NSNumber numberWithInteger:[savePitcher attributeAsInt:@"wins"]];
				player.loses = [NSNumber numberWithInteger:[savePitcher attributeAsInt:@"loses"]];
				player.era = [NSNumber numberWithDouble:[savePitcher attributeAsDouble:@"era"]];
				
				scoreboardGame.savePitcher = player;
				
				savePitcher = nil;
			}
			
			RXMLElement *homeProbablePitcher = [game child:@"home_probable_pitcher"];
			
			if (homeProbablePitcher) {
				BANScoreboardPlayer *player = [[BANScoreboardPlayer alloc] init];
				player.firstName = [homeProbablePitcher attribute:@"first"];
				player.lastName = [homeProbablePitcher attribute:@"last"];
				player.rosterName = [homeProbablePitcher attribute:@"name_display_roster"];
				player.number = [NSNumber numberWithInteger:[homeProbablePitcher attributeAsInt:@"number"]];
				player.wins = [NSNumber numberWithInteger:[homeProbablePitcher attributeAsInt:@"wins"]];
				player.loses = [NSNumber numberWithInteger:[homeProbablePitcher attributeAsInt:@"loses"]];
				player.era = [NSNumber numberWithDouble:[homeProbablePitcher attributeAsDouble:@"era"]];
				
				scoreboardGame.homeProbablePitcher = player;
				
				homeProbablePitcher = nil;
			}
			
			RXMLElement *awayProbablePitcher = [game child:@"away_probable_pitcher"];
			
			if (awayProbablePitcher) {
				BANScoreboardPlayer *player = [[BANScoreboardPlayer alloc] init];
				player.firstName = [awayProbablePitcher attribute:@"first"];
				player.lastName = [awayProbablePitcher attribute:@"last"];
				player.rosterName = [awayProbablePitcher attribute:@"name_display_roster"];
				player.number = [NSNumber numberWithInteger:[awayProbablePitcher attributeAsInt:@"number"]];
				player.wins = [NSNumber numberWithInteger:[awayProbablePitcher attributeAsInt:@"wins"]];
				player.loses = [NSNumber numberWithInteger:[awayProbablePitcher attributeAsInt:@"loses"]];
				player.era = [NSNumber numberWithDouble:[awayProbablePitcher attributeAsDouble:@"era"]];
				
				scoreboardGame.awayProbablePitcher = player;
				
				awayProbablePitcher = nil;
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
