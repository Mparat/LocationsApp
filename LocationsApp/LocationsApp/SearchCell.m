//
//  SearchCell.m
//  LocationsApp
//
//  Created by Meera Parat on 6/16/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import "SearchCell.h"

@interface SearchCell ()

@property (nonatomic, strong) UILabel *name;

@end


@implementation SearchCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)placeSubviewsForCell:(NSString *)name
{
    [self initWithUsername:name];
}

-(void)initWithUsername:(NSString *)username
{
    self.name = [[UILabel alloc] init];
    self.name.text = username;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.name.font, NSFontAttributeName, nil];
    self.name.frame = CGRectMake(self.name.frame.origin.x,
                                     self.name.frame.origin.y,
                                     [self.name.text sizeWithAttributes:dict].width,
                                     [self.name.text sizeWithAttributes:dict].height);
    
    self.name.frame = CGRectMake(70, 20, self.name.frame.size.width, 16);
    self.name.font = [UIFont fontWithName:@"Helvetica" size:16];
    self.name.textColor = [UIColor blackColor];
    [self addSubview:self.name];
}

@end
