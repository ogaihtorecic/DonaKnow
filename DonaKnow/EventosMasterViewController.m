//
//  EventosMasterViewController.m
//  DonaKnow
//
//  Created by Cicero Thiago Nascimento on 14/09/13.
//  Copyright (c) 2013 Cicero Thiago Nascimento. All rights reserved.
//

#import "EventosMasterViewController.h"

#import "EventoDetailViewController.h"
#import "EventoDataController.h"
#import "Evento.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface EventosMasterViewController ()

@end

@implementation EventosMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.dataController = [[EventoDataController alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataController countOfList];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"EventoCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Evento *eventoAtIndex = [self.dataController objectInListAtIndex:indexPath.row];
    [[cell textLabel] setText:eventoAtIndex.nome];
    [[cell detailTextLabel] setText:eventoAtIndex.local];
    
    [cell.imageView setImageWithURL:[NSURL URLWithString:eventoAtIndex.thumbnail] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ShowEventoDetails"]) {
        EventoDetailViewController *detailViewController = [segue destinationViewController];
        
        detailViewController.evento = [self.dataController objectInListAtIndex:[self.tableView indexPathForSelectedRow].row];
    }
}

@end
