//
//  Evento.h
//  DonaKnow
//
//  Created by Cicero Thiago Nascimento on 14/09/13.
//  Copyright (c) 2013 Cicero Thiago Nascimento. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Evento : NSObject

@property (nonatomic, copy) NSString *nome;
@property (nonatomic, copy) NSString *local;
@property (nonatomic, copy) NSString *endereco;
@property (nonatomic, copy) NSString *atracoes;
@property (nonatomic, copy) NSString *informacoes;
@property (nonatomic, copy) NSString *valor;
@property (nonatomic, copy) NSString *observacoes;

@property (nonatomic, copy) NSString *thumbnail;

+ (Evento *) withDictionary: (NSDictionary *) dictionary;

@end
