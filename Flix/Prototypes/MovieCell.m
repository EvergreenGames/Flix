//
//  MovieCell.m
//  Flix
//
//  Created by Ruben Green on 6/24/20.
//  Copyright © 2020 Ruben Green. All rights reserved.
//

#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"

@implementation MovieCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMovie:(Movie *)movie{
    _movie = movie;
    
    self.titleLabel.text = movie.title;
    self.descLabel.text = movie.desc;

    NSURLRequest* requestSmall = [NSURLRequest requestWithURL:movie.posterURL_small];
    
    [self.coverImageView setImageWithURLRequest:requestSmall placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        self.coverImageView.alpha = 0.0;
        self.coverImageView.image = image;
        
        if(response != nil){
            [UIView animateWithDuration:0.3 animations:^{
                self.coverImageView.alpha = 1.0;
            } completion:^(BOOL finished) {
                [self.coverImageView setImageWithURL:movie.posterURL];
            }];
        }
        else{
            self.coverImageView.alpha = 1.0;
            [self.coverImageView setImageWithURL:movie.posterURL];
        }
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        [self.coverImageView setImageWithURL:movie.posterURL];
    }];
}

@end
