//
//  LogEntryCell.m
//  NTLogSample
//
//  Created by Ethan Nagel on 1/5/14.
//  Copyright (c) 2014 Nagel Technologies, Inc. All rights reserved.
//

#import "LogEntryCell.h"


@interface LogEntryCell ()

@property (weak, nonatomic) IBOutlet UILabel *logEntryLabel;

@end


@implementation LogEntryCell


static UIFont *sFont = nil;


+(UINib *)nib
{
    static UINib *nib = nil;
    
    if ( !nib )
    {
        nib = [UINib nibWithNibName:NSStringFromClass(self) bundle:nil];
    }
    
    return nib;
}


+(NSString *)reuseIdentifier
{
    return NSStringFromClass(self);
}


+(float)cellHeightForLogEntry:(NSString *)logEntry width:(float)width
{
    width = 320;
    
    if ( !sFont )
    {
        // create an instance so awakeFromNib will be called, giving us sFont
        [[self nib] instantiateWithOwner:nil options:nil];
    }
    
    NSDictionary *attributes =
    @{
      NSFontAttributeName: sFont,
    };
    
    CGRect boundingRect = [logEntry boundingRectWithSize:CGSizeMake(width, 1000)
                                                 options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                              attributes:attributes
                                                 context:nil];
    
    return boundingRect.size.height + 1;
}


-(void)awakeFromNib
{
    [super awakeFromNib];
    
    if ( !sFont )
    {
        sFont = self.logEntryLabel.font;
    }
}


-(void)configureCellWithLogEntry:(NSString *)logEntry
{
    self.frame = CGRectMake(0, 0, self.frame.size.width, [self.class cellHeightForLogEntry:logEntry width:self.frame.size.width]);
    self.logEntryLabel.text = logEntry;
}


@end
