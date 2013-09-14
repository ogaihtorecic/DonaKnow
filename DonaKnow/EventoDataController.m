//
//  EventoDataController.m
//  DonaKnow
//
//  Created by Cicero Thiago Nascimento on 14/09/13.
//  Copyright (c) 2013 Cicero Thiago Nascimento. All rights reserved.
//

#import "EventoDataController.h"

#import "Evento.h"
@interface EventoDataController ()
- (void)initializeDefaultDataList;
@end

@implementation EventoDataController

- (void)initializeDefaultDataList {
    NSMutableArray *eventoList = [[NSMutableArray alloc] init];
    self.masterEventoList = eventoList;
    Evento *evento;
    evento = [[Evento alloc] initWithNome:@"Acustico Joci Carvalho" local:@"Allegro Bar" endereco:@"Rua A" observacoes:@"Festa Legal"];
    [self addEventoWithEvento:evento];
}

- (void)setMasterEventoList:(NSMutableArray *)newList {
    if (_masterEventoList != newList) {
        _masterEventoList = [newList mutableCopy];
    }
}

- (id)init {
    if (self = [super init]) {
        [self initializeDefaultDataList];
        return self;
    }
    return nil;
}

- (NSUInteger)countOfList {
    return [self.masterEventoList count];
}

- (Evento *)objectInListAtIndex:(NSUInteger)theIndex {
    return [self.masterEventoList objectAtIndex:theIndex];
}

- (void)addEventoWithEvento:(Evento *)evento {
    [self.masterEventoList addObject:evento];
}

@end
