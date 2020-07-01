//
//  Movie.m
//  Flix
//
//  Created by Ruben Green on 7/1/20.
//  Copyright © 2020 Ruben Green. All rights reserved.
//

#import "Movie.h"

@implementation Movie

- (id)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    
    self.title = dictionary[@"title"];
    self.desc = dictionary[@"overview"];
    self.dateString = dictionary[@"release_date"];
    self.rating = [dictionary[@"vote_average"] intValue];
    
    NSString* baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString* baseURLString_small = @"https://image.tmdb.org/t/p/w45";
    NSString* posterURLString = dictionary[@"poster_path"];
    self.posterURL = [NSURL URLWithString:[baseURLString stringByAppendingString:posterURLString]];
    self.posterURL_small = [NSURL URLWithString:[baseURLString_small stringByAppendingString:posterURLString]];
    
    NSString* bgURLString = dictionary[@"backdrop_path"];
    self.bgURL = [NSURL URLWithString:[baseURLString stringByAppendingString:bgURLString]];
    
    self.movieID = [dictionary[@"id"] stringValue];
    
    return self;
}

+ (NSArray *)moviesWithDictionaries:(NSArray *)dictionaries{
    NSMutableArray* movies = [[NSMutableArray alloc] init];
    for(NSDictionary* dictionary in dictionaries){
        Movie* movie = [[Movie alloc] initWithDictionary:dictionary];
        [movies addObject:movie];
    }
    return movies;
}

@end
