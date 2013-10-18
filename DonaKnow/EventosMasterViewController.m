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
#import "MBProgressHUD.h"
#import "Reachability.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface EventosMasterViewController ()

- (void) loadDataOperationWithMessage:(id)showMessage;
- (void) showWaitMessage;
- (void) dismissWaitMessage;

@end

@implementation EventosMasterViewController

BOOL loadDataRunning = false;
UIAlertView *noInternetAlert;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem.target = self;
    self.navigationItem.rightBarButtonItem.action = @selector(refreshButtonLoadData);
    
    self.tabBarController.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    noInternetAlert = [[UIAlertView alloc] initWithTitle:@"Sem Internet!" message:@"Verifique sua conexão e tente novamente" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
}

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    return !loadDataRunning;
}

- (void) loadDataWithMessage:(id)showMessage {
    NSOperationQueue *queue = [NSOperationQueue new];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadDataOperationWithMessage:) object:showMessage];
    
    [queue addOperation:operation];
    
}

- (void) refreshButtonLoadData {
    [self loadDataWithMessage:[NSNumber numberWithBool:YES]];
    [[[[self.tabBarController.viewControllers objectAtIndex:1] viewControllers] objectAtIndex:0] loadDataWithMessage:[NSNumber numberWithBool:NO]];
    [[[[self.tabBarController.viewControllers objectAtIndex:2] viewControllers] objectAtIndex:0] loadDataWithMessage:[NSNumber numberWithBool:NO]];
}

- (void) loadDataOperationWithMessage:(id)showMessage {
    [self performSelectorOnMainThread:@selector(showWaitMessage) withObject:nil waitUntilDone:YES];
    
    if(self.isThereConnection) {
        NSString *url = [NSString stringWithFormat:@"http://dk.aondefui.com/?count=100&json=1&custom_fields=quanto,bandas,observacao,informacoes&taxonomy=local&taxonomy_fields=cidade,mapa_do_local"];
        
        NSData *jsonData = [NSData dataWithContentsOfURL: [NSURL URLWithString:url]];
        [self.dataController reloadWithData:jsonData];
        
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(dismissWaitMessage) withObject:nil waitUntilDone:YES];
        
    } else {
        [self performSelectorOnMainThread:@selector(dismissWaitMessage) withObject:nil waitUntilDone:YES];
        
        if ([showMessage boolValue]) {
            [self performSelectorOnMainThread:@selector(showErrorMessage) withObject:nil waitUntilDone:YES];
        }
    }
}

- (void)showWaitMessage {
    self.navigationItem.rightBarButtonItem.enabled = FALSE;
    [self.tableView setUserInteractionEnabled:FALSE];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    loadDataRunning = true;
}

- (void)dismissWaitMessage {
    self.navigationItem.rightBarButtonItem.enabled = TRUE;
    [self.tableView setUserInteractionEnabled:TRUE];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    loadDataRunning = false;
}

- (void)showErrorMessage {
    [noInternetAlert show];
}

-(BOOL)isThereConnection {
    Reachability *internetReachability = [Reachability reachabilityForInternetConnection];
    [internetReachability startNotifier];
    
    return internetReachability.currentReachabilityStatus != NotReachable;
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
    
    [cell.imageView setImageWithURL:[NSURL URLWithString:eventoAtIndex.thumbnail] placeholderImage:[UIImage imageNamed:@"placeholder_50x50.png"]];
    
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
        detailViewController.hidesBottomBarWhenPushed = YES;
    }
}

@end
