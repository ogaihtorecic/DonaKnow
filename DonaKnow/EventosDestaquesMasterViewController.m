//
//  EventosDestaquesMasterViewController.m
//  DonaKnow
//
//  Created by Cicero Thiago Nascimento on 17/09/13.
//  Copyright (c) 2013 Cicero Thiago Nascimento. All rights reserved.
//

#import "EventosDestaquesMasterViewController.h"
#import "EventosDestaquesDataController.h"
#import "Utilitary.h"

@interface EventosDestaquesMasterViewController ()

@end

@implementation EventosDestaquesMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.dataController = [[EventosDestaquesDataController alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
    if(Utilitary.destaquesList != NULL) {
        self.dataController.masterEventoList = Utilitary.destaquesList;
        [self.tableView reloadData];
        Utilitary.destaquesList = NULL;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
