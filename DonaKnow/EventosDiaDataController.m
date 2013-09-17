//
//  EventosDiaDataController.m
//  DonaKnow
//
//  Created by Cicero Thiago Nascimento on 16/09/13.
//  Copyright (c) 2013 Cicero Thiago Nascimento. All rights reserved.
//

#import "EventosDiaDataController.h"
#import "Evento.h"

@implementation EventosDiaDataController

- (void)addEventoWithEvento:(Evento *)evento {
    NSDate *currentDate = [NSDate date];
    NSDate *dataEvento = evento.data;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    
    if ([[dateFormatter stringFromDate:dataEvento] isEqual:[dateFormatter stringFromDate:currentDate]]) {
        [self.masterEventoList addObject:evento];
    }
}

@end
