//
//  NTLogCrashlyticsListener.h
//  TakeANumber-iOS
//
//  Created by Ethan Nagel on 11/26/12.
//  Copyright (c) 2012 Tomfoolery, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NTLog.h"

@interface NTLogCrashlyticsListener : NSObject <NTLogListener>

-(void)writeLine:(NSString *)line;

@end
