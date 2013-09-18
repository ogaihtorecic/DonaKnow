//
//  EventosDestaquesMasterViewController.m
//  DonaKnow
//
//  Created by Cicero Thiago Nascimento on 17/09/13.
//  Copyright (c) 2013 Cicero Thiago Nascimento. All rights reserved.
//

#import "EventosDestaquesMasterViewController.h"
#import "EventosDestaquesDataController.h"

@interface EventosDestaquesMasterViewController ()

@end

@implementation EventosDestaquesMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.dataController = [[EventosDestaquesDataController alloc] init];
    [self loadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
