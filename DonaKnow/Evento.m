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
        
        NSString *poster = [[[attachment objectForKey:@"images"] objectForKey:@"post-thumbnail"] objectForKey:@"url"];
        [evento setPoster: poster];
        
        NSString *posterGrande = [[[attachment objectForKey:@"images"] objectForKey:@"full"] objectForKey:@"url"];
        [evento setPosterGrande: posterGrande];
    }

    NSArray *termsArray = [dictionary objectForKey:@"terms"];
    
    if (termsArray.count > 0) {
        NSDictionary *term = [termsArray objectAtIndex:0];
        [evento setLocal: [term objectForKey:@"title"]];
        [evento setEndereco: [term objectForKey:@"description"]];
        
        NSString *mapaString = [[term objectForKey:@"custom_fields"] objectForKey:@"mapa_do_local"];
        
        NSString *param = nil;
        NSRange start = [mapaString rangeOfString:@"q="];
        
        if (start.location != NSNotFound && start.location != 0)
        {
            param = [mapaString substringFromIndex:start.location + start.length];
            NSRange end = [param rangeOfString:@"&"];
            if (end.location != NSNotFound)
            {
                param = [param substringToIndex:end.location];
                NSArray *array = [param componentsSeparatedByString:@","];
                if (array.count > 1) {
                    evento.latitude = [[array objectAtIndex:0] doubleValue];
                    evento.longitude = [[array objectAtIndex:1] doubleValue];
                }
                
            }
            
        }
    }
    
    NSDictionary *customFields = [dictionary objectForKey:@"custom_fields"];
    
    NSArray *atracoesArray = [customFields objectForKey:@"bandas"];
    if (atracoesArray.count > 0) {
        [evento setAtracoes: [atracoesArray objectAtIndex:0]];
    }
    
    NSArray *informacoesArray = [customFields objectForKey:@"informacoes"];
    if (informacoesArray.count > 0) {
        NSString *informacoes = [informacoesArray objectAtIndex:0];
        informacoes = [informacoes stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        informacoes = [informacoes stringByReplacingOccurrencesOfString:@" " withString:@"-"];
        [evento setInformacoes: informacoes];
    }
    
    NSArray *valorArray = [customFields objectForKey:@"quanto"];
    if (valorArray.count > 0) {
        [evento setValor: [valorArray objectAtIndex:0]];
    }
    
    NSArray *observacaoArray = [customFields objectForKey:@"observacao"];
    if (observacaoArray.count > 0) {
        [evento setObservacoes: [observacaoArray objectAtIndex:0]];
    }
    
    return evento;
}

@end
