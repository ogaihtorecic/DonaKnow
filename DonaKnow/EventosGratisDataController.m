//
//  EventosGratisDataController.m
//  DonaKnow
//
//  Created by Cicero Thiago Nascimento on 17/09/13.
//  Copyright (c) 2013 Cicero Thiago Nascimento. All rights reserved.
//

#import "EventosGratisDataController.h"
#import "Evento.h"

@implementation EventosGratisDataController

- (void)addEventoWithEvento:(Evento *)evento {
    NSNumber *CATEGORIA_GRATIS_ID = [[NSNumber alloc] initWithInt:113];
    if ([evento.categorias indexOfObject:CATEGORIA_GRATIS_ID] != NSNotFound) {
        [self.masterEventoList addObject:evento];
    }
}

@end
