//
//  EventosMasterViewController.h
//  DonaKnow
//
//  Created by Cicero Thiago Nascimento on 14/09/13.
//  Copyright (c) 2013 Cicero Thiago Nascimento. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EventoDataController;

@interface EventosMasterViewController : UITableViewController

@property (strong, nonatomic) EventoDataController *dataController;

@end
