//
//  DetailsViewController.m
//  Flix
//
//  Created by Ruben Green on 6/25/20.
//  Copyright © 2020 Ruben Green. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TrailerViewController.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UINavigationItem *navLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString* baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString* posterURLString = self.movie[@"poster_path"];
    NSString* fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    
    NSURL* posterURL = [NSURL URLWithString:fullPosterURLString];
    NSURLRequest* posterRequest = [NSURLRequest requestWithURL:posterURL];
    
    [self.posterImageView setImageWithURLRequest:posterRequest placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        self.posterImageView.alpha = 0.0;
        self.posterImageView.image = image;
        
        if(response != nil){
        [UIView animateWithDuration:0.3 animations:^{
            self.posterImageView.alpha = 1.0;
        }];
        }
        else self.posterImageView.alpha = 1.0;
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        NSLog(@"Failed to load poster Image");
    }];
    
    NSString* bgURLString = self.movie[@"backdrop_path"];
    NSString* fullBgURLString = [baseURLString stringByAppendingString:bgURLString];
    
    NSURL* bgURL = [NSURL URLWithString:fullBgURLString];
    NSURLRequest* bgRequest = [NSURLRequest requestWithURL:bgURL];
    [self.backgroundImageView setImageWithURLRequest:bgRequest placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        self.backgroundImageView.alpha = 0.0;
        self.backgroundImageView.image = image;
        
        if(response != nil){
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundImageView.alpha = 1.0;
        }];
        }
        else self.backgroundImageView.alpha = 1.0;
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        NSLog(@"Failed to load BG Image");
    }];
    
    [self.posterImageView setImageWithURL:posterURL];
    [self.backgroundImageView setImageWithURL:bgURL];
    self.titleLabel.text = self.movie[@"title"];
    self.dateLabel.text = self.movie[@"release_date"];
    self.descLabel.text = self.movie[@"overview"];
    self.navLabel.title = self.movie[@"title"];
    self.ratingLabel.text = [self.movie[@"vote_average"] stringValue];
    
    //[self.titleLabel sizeToFit];
    [self.descLabel sizeToFit];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    TrailerViewController* trailerController = [segue destinationViewController];
    
    trailerController.movieID = [self.movie[@"id"] stringValue];
}


@end
