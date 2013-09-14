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
    
    NSString *url = [NSString stringWithFormat:@"http://dk.aondefui.com/?json=1&custom_fields=quanto,bandas,observacao,informacoes&taxonomy=local&taxonomy_fields=cidade,mapa_do_local"];
    NSData *jsonData = [NSData dataWithContentsOfURL: [NSURL URLWithString:url]];
    NSError* error;
    NSDictionary *resultados = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    if(!error){
        NSArray *postsArray = [resultados objectForKey:@"posts"];
    
        for (NSDictionary *post in postsArray ){
            Evento *evento = [Evento withDictionary: post];
            [self addEventoWithEvento:evento];
        }
    }
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
