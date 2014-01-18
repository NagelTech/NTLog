//
//  LogEntryCell.h
//  NTLogSample
//
//  Created by Ethan Nagel on 1/5/14.
//  Copyright (c) 2014 Nagel Technologies, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogEntryCell : UITableViewCell

+(UINib *)nib;
+(NSString *)reuseIdentifier;

+(float)cellHeightForLogEntry:(NSString *)logEntry width:(float)width;

-(void)configureCellWithLogEntry:(NSString *)logEntry;

@end
