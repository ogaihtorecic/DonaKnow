//
//  EventoDetailViewController.h
//  DonaKnow
//
//  Created by Cicero Thiago Nascimento on 14/09/13.
//  Copyright (c) 2013 Cicero Thiago Nascimento. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Evento;

@interface EventoDetailViewController : UITableViewController

@property (strong, nonatomic) Evento *evento;
@property (weak, nonatomic) IBOutlet UILabel *nomeEventoLabel;
@property (weak, nonatomic) IBOutlet UILabel *localLabel;
@property (weak, nonatomic) IBOutlet UILabel *enderecoLabel;
@property (weak, nonatomic) IBOutlet UILabel *observacoesLabel;

@end
