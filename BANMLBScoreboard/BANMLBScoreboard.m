//
//  BANMLBScoreboard.m
//  BANMLBScoreboard
//
//  Created by Brent Nycum on 3/27/14.
//  Copyright (c) 2014 It's Brent. All rights reserved.
//

#import "BANMLBScoreboard.h"

static NSString * const BANMLBScoreboardBaseURLString = @"http://gdx.mlb.com/components/game/mlb/year_2014/";

@implementation BANMLBScoreboard

+ (instancetype)sharedClient {
	static BANMLBScoreboard *_sharedClient = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_sharedClient = [[BANMLBScoreboard alloc] initWithBaseURL:[NSURL URLWithString:BANMLBScoreboardBaseURLString]];
		_sharedClient.responseSerializer = [AFXMLParserResponseSerializer new];
	});

	return _sharedClient;
}

@end
