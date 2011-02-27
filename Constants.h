//
//  Constants.h
//  iMLate
//
//  Created by Benoît Clouet on 26/02/11.
//  Copyright 2011 Myself. All rights reserved.
//

// Constants of the possible keys in a JSon described incident

// Status of the incident : String
#define STATUS @"status"
// Number of times this incident has been reported : integer
#define VOTE_PLUS @"vote_plus"
// Number of times this incident has been denied : integer
#define VOTE_MINUS @"vote_minus"
// Number of times this incident has been reported solved : integer
#define VOTE_ENDED @"vote_ended"
// ID of the incident : integer
#define UID @"uid"
// Given reason of the incident if known : String
#define REASON @"reason"
// Transportation affected by the incident : String
#define LINE @"line"
// Last time the incident was modified : date under the form yyyy-MM-dd HH:mm:ss
#define LAST_MODIFIED_TIME @"last_modified_time"
