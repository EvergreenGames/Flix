//
//  MoviesGridViewController.m
//  Flix
//
//  Created by Ruben Green on 6/25/20.
//  Copyright © 2020 Ruben Green. All rights reserved.
//

#import "MoviesGridViewController.h"
#import "PosterCell.h"
#import "UIImageView+AFNetworking.h"
#import "MBProgressHUD.h"
#import "DetailsViewController.h"

@interface MoviesGridViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) NSArray* movies;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation MoviesGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self fetchMovieList];
    
    UICollectionViewFlowLayout* layout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    
    layout.minimumInteritemSpacing = 3;
    layout.minimumLineSpacing = 3;
    
    CGFloat postersPerLine = 2;
    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (postersPerLine-1)) / postersPerLine;
    CGFloat itemHeight = itemWidth * 1.5;
    
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
}

- (void) fetchMovieList {
    
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
               UIAlertController* errorPopup = [UIAlertController alertControllerWithTitle:@"Error" message:[error localizedDescription] preferredStyle:(UIAlertControllerStyleAlert)];
               
               UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                   [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                   [self fetchMovieList];
               }];
               
               [errorPopup addAction:okAction];
               
               [self presentViewController:errorPopup animated:YES completion:^{
                   //Do nothing
               }];
               
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

               self.movies = dataDictionary[@"results"];

           }
        [self.collectionView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
       }];
    [task resume];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PosterCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PosterCell" forIndexPath:indexPath];
    
    NSDictionary* movie = self.movies[indexPath.item];

    NSString* baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString* baseURLString_small = @"https://image.tmdb.org/t/p/w45";
    NSString* posterURLString = movie[@"poster_path"];
    NSString* fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    NSString* fullPosterURLString_small = [baseURLString_small stringByAppendingString:posterURLString];
    
    NSURL* posterURL = [NSURL URLWithString:fullPosterURLString];
    NSURL* posterURL_small = [NSURL URLWithString:fullPosterURLString_small];
    
    NSURLRequest* requestSmall = [NSURLRequest requestWithURL:posterURL_small];
    
    [cell.posterImageView setImageWithURLRequest:requestSmall placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        cell.posterImageView.alpha = 0.0;
        cell.posterImageView.image = image;
        
        if(response != nil){
            [UIView animateWithDuration:0.3 animations:^{
                cell.posterImageView.alpha = 1.0;
            } completion:^(BOOL finished) {
                [cell.posterImageView setImageWithURL:posterURL];
            }];
        }
        else{
            cell.posterImageView.alpha = 1.0;
            [cell.posterImageView setImageWithURL:posterURL];
        }
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        [cell.posterImageView setImageWithURL:posterURL];
    }];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.movies.count;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UICollectionViewCell* sourceCell = sender;
    NSIndexPath* sourceIndex = [self.collectionView indexPathForCell:sourceCell];
    
    NSDictionary* movie = self.movies[sourceIndex.row];
    
    DetailsViewController* detailController = [segue destinationViewController];
    
    detailController.movie = movie;
}


@end
