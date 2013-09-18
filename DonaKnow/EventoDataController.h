//
//  EventoDataController.h
//  DonaKnow
//
//  Created by Cicero Thiago Nascimento on 14/09/13.
//  Copyright (c) 2013 Cicero Thiago Nascimento. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Evento;

@interface EventoDataController : NSObject

@property (nonatomic, copy) NSMutableArray *masterEventoList;

- (NSUInteger)countOfList;

- (Evento *)objectInListAtIndex:(NSUInteger)theIndex;

- (void)addEventoWithEvento:(Evento *)evento;

- (void)reloadWithData:(NSData *)data;

@end
