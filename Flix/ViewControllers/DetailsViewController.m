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
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSURLRequest* posterRequest = [NSURLRequest requestWithURL:self.movie.posterURL];
    
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
    
    NSURLRequest* bgRequest = [NSURLRequest requestWithURL:self.movie.bgURL];
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
    
    self.titleLabel.text = self.movie.title;
    self.dateLabel.text = self.movie.dateString;
    self.descLabel.text = self.movie.desc;
    self.navLabel.title = self.movie.title;
    self.ratingLabel.text = [NSString stringWithFormat:@"%d",self.movie.rating];
    
    //[self.titleLabel sizeToFit];
    [self.descLabel sizeToFit];
}

- (void)viewDidAppear:(BOOL)animated{
    CGRect contentRect = CGRectZero;

    for (UIView *view in self.scrollView.subviews) {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    self.scrollView.contentSize = contentRect.size;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    TrailerViewController* trailerController = [segue destinationViewController];
    
    trailerController.movieID = self.movie.movieID;
}


@end
