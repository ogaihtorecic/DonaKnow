//
//  EventosDestaquesDataController.m
//  DonaKnow
//
//  Created by Cicero Thiago Nascimento on 17/09/13.
//  Copyright (c) 2013 Cicero Thiago Nascimento. All rights reserved.
//

#import "EventosDestaquesDataController.h"
#import "Evento.h"

@implementation EventosDestaquesDataController

- (void)addEventoWithEvento:(Evento *)evento {
    NSNumber *CATEGORIA_DESTAQUE_ID = [[NSNumber alloc] initWithInt:25];
    if ([evento.categorias indexOfObject:CATEGORIA_DESTAQUE_ID] != NSNotFound) {
        [self.masterEventoList addObject:evento];
    }
}

@end
