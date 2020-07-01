//
//  PosterCell.m
//  Flix
//
//  Created by Ruben Green on 6/25/20.
//  Copyright © 2020 Ruben Green. All rights reserved.
//

#import "PosterCell.h"
#import "UIImageView+AFNetworking.h"

@implementation PosterCell

- (void)setMovie:(Movie*)movie{
    _movie = movie;
    
    NSURLRequest* requestSmall = [NSURLRequest requestWithURL:movie.posterURL_small];
    
    [self.posterImageView setImageWithURLRequest:requestSmall placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        self.posterImageView.alpha = 0.0;
        self.posterImageView.image = image;
        
        if(response != nil){
            [UIView animateWithDuration:0.3 animations:^{
                self.posterImageView.alpha = 1.0;
            } completion:^(BOOL finished) {
                [self.posterImageView setImageWithURL:movie.posterURL];
            }];
        }
        else{
            self.posterImageView.alpha = 1.0;
            [self.posterImageView setImageWithURL:movie.posterURL];
        }
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        [self.posterImageView setImageWithURL:movie.posterURL];
    }];
}

@end
