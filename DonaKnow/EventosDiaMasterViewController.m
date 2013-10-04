//
//  EventosDiaMasterViewController.m
//  DonaKnow
//
//  Created by Cicero Thiago Nascimento on 16/09/13.
//  Copyright (c) 2013 Cicero Thiago Nascimento. All rights reserved.
//

#import "EventosDiaMasterViewController.h"
#import "EventosDiaDataController.h"

@interface EventosDiaMasterViewController ()

@end

@implementation EventosDiaMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.dataController = [[EventosDiaDataController alloc] init];
    [self refreshButtonLoadData];
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
