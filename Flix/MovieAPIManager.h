//
//  MovieAPIManager.h
//  Flix
//
//  Created by Ruben Green on 7/1/20.
//  Copyright © 2020 Ruben Green. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MovieAPIManager : NSObject

@property (nonatomic, strong) NSURLSession* session;

-(void)fetchNowPlaying:(void(^)(NSArray* movies, NSError* error))completion;

@end

NS_ASSUME_NONNULL_END
