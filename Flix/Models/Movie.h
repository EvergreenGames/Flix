//
//  Movie.h
//  Flix
//
//  Created by Ruben Green on 7/1/20.
//  Copyright © 2020 Ruben Green. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Movie : NSObject

@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* desc;
@property (nonatomic, strong) NSString* dateString;
@property (nonatomic) int rating;
@property (nonatomic, strong) NSURL* posterURL;
@property (nonatomic, strong) NSURL* posterURL_small;
@property (nonatomic, strong) NSURL* bgURL;
@property (nonatomic, strong) NSString* movieID;

- (id)initWithDictionary:(NSDictionary*) dictionary;
+ (NSArray*)moviesWithDictionaries:(NSArray*) dictionaries;

@end

NS_ASSUME_NONNULL_END
