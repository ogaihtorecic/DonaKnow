//
//  Evento.m
//  DonaKnow
//
//  Created by Cicero Thiago Nascimento on 14/09/13.
//  Copyright (c) 2013 Cicero Thiago Nascimento. All rights reserved.
//

#import "Evento.h"

@implementation Evento

+ (Evento *) withDictionary: (NSDictionary *) dictionary {
    Evento * evento = [[Evento alloc] init];
    [evento setNome: [dictionary objectForKey:@"title"]];
    
    NSDateFormatter *stringFormatter = [[NSDateFormatter alloc] init];
    [stringFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [stringFormatter dateFromString:[dictionary objectForKey:@"date"]];
    [evento setData: date];
    
    NSArray *categoriesArray = [dictionary objectForKey:@"categories"];
    NSMutableArray *categorias = [[NSMutableArray alloc] init];
    for (NSDictionary *categoria in categoriesArray) {
        [categorias addObject:[categoria objectForKey:@"id"]];
    }
    [evento setCategorias:categorias];
    
    NSArray *attachmentsArray = [dictionary objectForKey:@"attachments"];
    if(attachmentsArray.count > 0) {
        NSDictionary *attachment = [attachmentsArray objectAtIndex:[attachmentsArray count] - 1];
        NSString *thumbnail = [[[attachment objectForKey:@"images"] objectForKey:@"small"] objectForKey:@"url"];
        [evento setThumbnail: thumbnail];
    }

    NSArray *termsArray = [dictionary objectForKey:@"terms"];
    
    NSDictionary *term = [termsArray objectAtIndex:0];
    [evento setLocal: [term objectForKey:@"title"]];
    [evento setEndereco: [term objectForKey:@"description"]];
    
    NSDictionary *customFields = [dictionary objectForKey:@"custom_fields"];
    
    NSArray *atracoesArray = [customFields objectForKey:@"bandas"];
    [evento setAtracoes: [atracoesArray objectAtIndex:0]];
    
    NSArray *informacoesArray = [customFields objectForKey:@"informacoes"];
    NSString *informacoes = [informacoesArray objectAtIndex:0];
    informacoes = [informacoes stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    informacoes = [informacoes stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    [evento setInformacoes: informacoes];
    
    NSArray *valorArray = [customFields objectForKey:@"quanto"];
    [evento setValor: [valorArray objectAtIndex:0]];
    
    NSArray *observacaoArray = [customFields objectForKey:@"observacao"];
    [evento setObservacoes: [observacaoArray objectAtIndex:0]];
    
    NSString *mapaString = [[term objectForKey:@"custom_fields"] objectForKey:@"mapa_do_local"];
    
    NSString *param = nil;
    NSRange start = [mapaString rangeOfString:@"q="];
    if (start.location != NSNotFound)
    {
        param = [mapaString substringFromIndex:start.location + start.length];
        NSRange end = [param rangeOfString:@"&"];
        if (end.location != NSNotFound)
        {
            param = [param substringToIndex:end.location];
            NSArray *array = [param componentsSeparatedByString:@","];
            
            evento.latitude = [[array objectAtIndex:0] doubleValue];
            evento.longitude = [[array objectAtIndex:1] doubleValue];
        }

    }
    
    return evento;
}

@end
