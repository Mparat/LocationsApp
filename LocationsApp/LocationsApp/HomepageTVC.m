//
//  HomepageTVC.m
//  LocationsApp
//
//  Created by Meera Parat on 6/6/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import "HomepageTVC.h"
#import "HomepageChatCell.h"
#import "MessageVC.h"

@interface HomepageTVC ()

@end

@implementation HomepageTVC

#define chatCell @"chatCell"

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[HomepageChatCell class] forCellReuseIdentifier:chatCell];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Text field delegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    header.backgroundColor = [UIColor whiteColor];
    self.searchBar = [[UITextField alloc] init];
    self.searchBar.placeholder = [NSString stringWithFormat:@"Search"];
    self.searchBar.frame = CGRectMake(1*header.frame.size.width/10, 5, 7*header.frame.size.width/10, 20);
    self.searchBar.borderStyle = UITextBorderStyleRoundedRect;
    self.searchBar.backgroundColor = [UIColor clearColor];
    self.searchBar.textAlignment = NSTextAlignmentNatural;
//    self.searchBar.layer.cornerRadius = 10;
//    self.searchBar.layer.borderColor = [UIColor grayColor].CGColor;
    self.searchBar.delegate = self;
    [header addSubview:self.searchBar];
    
    findFriends = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    findFriends.frame = CGRectMake(8*header.frame.size.width/10, 5, 2*header.frame.size.width/10, 20);
    [findFriends setTitle:@"Add" forState:UIControlStateNormal];
    [header addSubview:findFriends];
    [findFriends addTarget:self action:@selector(addFriends) forControlEvents:UIControlEventTouchUpInside];
    
    return header;
}

-(void)addFriends
{
    return;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomepageChatCell *cell = [tableView dequeueReusableCellWithIdentifier:chatCell forIndexPath:indexPath];
//    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

-(void)configureCell:(HomepageChatCell *)cell atIndexPath:(NSIndexPath *)path
{
    return;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [(HomepageChatCell *)cell placeSubviewsForCell];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
