//
//  EventosGratisMasterViewController.m
//  DonaKnow
//
//  Created by Cicero Thiago Nascimento on 17/09/13.
//  Copyright (c) 2013 Cicero Thiago Nascimento. All rights reserved.
//

#import "EventosGratisMasterViewController.h"
#import "EventosGratisDataController.h"
#import "Utilitary.h"

@interface EventosGratisMasterViewController ()

@end

@implementation EventosGratisMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.dataController = [[EventosGratisDataController alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
    if(Utilitary.gratisList != NULL) {
        self.dataController.masterEventoList = Utilitary.gratisList;
        [self.tableView reloadData];
        Utilitary.gratisList = NULL;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
