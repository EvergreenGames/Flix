//
//  MovieAPIManager.m
//  Flix
//
//  Created by Ruben Green on 7/1/20.
//  Copyright © 2020 Ruben Green. All rights reserved.
//

#import "MovieAPIManager.h"
#import "Movie.h"

@implementation MovieAPIManager

-(id)init{
    self = [super init];
    
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    return self;
}

- (void)fetchNowPlaying:(void (^)(NSArray * _Nonnull, NSError * _Nonnull))completion{
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
               completion(nil, error);
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               
               NSArray* dictionaries = dataDictionary[@"results"];
               NSArray* movies = [Movie moviesWithDictionaries:dictionaries];
               
               completion(movies, nil);
           }
    }];
    [task resume];
}

@end
