//
//  BANMLBScoreboard.h
//  BANMLBScoreboard
//
//  Created by Brent Nycum on 3/27/14.
//  Copyright (c) 2014 It's Brent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface BANMLBScoreboard : AFHTTPRequestOperationManager

+ (instancetype)sharedClient;

@end
