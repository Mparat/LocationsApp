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
@property (nonatomic, strong) UILabel *actualName;

@end


@implementation SearchCell

@synthesize signedInUser = _signedInUser;
@synthesize name = _name;
@synthesize actualName = _actualName;
@synthesize person = _person;


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

-(void)initWithContact:(parseUser *)user
{
    [self placeNames:user];
}

-(void)placeNames:(parseUser *)user
{
    [self.textLabel setText:[NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName]];
    UIImageView *unselected = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UnselectedCircle"]];
    unselected.frame = CGRectMake(256+20, 19.5, 29, 29);
    [self addSubview:unselected];
}


@end
