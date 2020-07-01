//
//  MoviesGridViewController.m
//  Flix
//
//  Created by Ruben Green on 6/25/20.
//  Copyright © 2020 Ruben Green. All rights reserved.
//

#import "MoviesGridViewController.h"
#import "MovieAPIManager.h"
#import "Movie.h"
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
    MovieAPIManager* manager = [MovieAPIManager new];
    [manager fetchNowPlaying:^(NSArray * _Nonnull movies, NSError * _Nonnull error) {
        if(error != nil){
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
        else{
            self.movies = movies;
            
            [self.collectionView reloadData];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PosterCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PosterCell" forIndexPath:indexPath];
    
    cell.movie = self.movies[indexPath.item];
    
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
    
    Movie* movie = self.movies[sourceIndex.row];
    
    DetailsViewController* detailController = [segue destinationViewController];
    
    detailController.movie = movie;
}


@end
