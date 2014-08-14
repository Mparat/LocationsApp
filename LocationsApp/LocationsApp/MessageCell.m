//
//  MessageCell.m
//  LocationsApp
//
//  Created by Meera Parat on 7/2/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 10;
        self.layer.shadowPath = [[UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.layer.cornerRadius] CGPath];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}


-(void)configureCell:(LYRMessage *)message layerClient:(LYRClient *)client
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGFloat width =  self.contentView.frame.size.width;
    CGFloat height =  self.contentView.frame.size.height;

    LYRMessagePart *part = [message.parts objectAtIndex:1];
    if ([message.sentByUserID isEqualToString:client.authenticatedUserID]) {
        self.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:173.0/255.0 blue:186.0/255.0 alpha:1.0];
        self.contentView.frame = CGRectMake(rect.size.width-width-8, 0, width, height);
//        self.backgroundView.frame = CGRectMake(rect.size.width-width-8, 0, width, height);
    }
    else
    {
        self.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1.0];
        self.contentView.frame = CGRectMake(0, 0, width, height);
//        self.backgroundView.frame = self.contentView.frame;
    }

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(7, 10, self.frame.size.width, self.frame.size.height)];
    label.numberOfLines = 0;
    
    NSString *text = [NSString stringWithUTF8String:[part.data bytes]];
    [label setText:text];
    [label setFont:[UIFont fontWithName:@"Helvetica" size:14.0]];
    [label sizeToFit];
    [self.contentView addSubview:label];
    

}


@end
