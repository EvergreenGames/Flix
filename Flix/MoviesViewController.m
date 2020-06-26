//
//  MoviesViewController.m
//  Flix
//
//  Created by Ruben Green on 6/24/20.
//  Copyright © 2020 Ruben Green. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"
#import "MBProgressHUD.h"

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray* movies;
@property (nonatomic, strong) NSArray* filteredMovies;
@property (nonatomic, strong) UIRefreshControl* refreshControl;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchBar.delegate = self;
        
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self fetchMovieList];
        
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovieList) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:animated];
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
               self.filteredMovies = self.movies;
               
               [self.tableView reloadData];
           }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.refreshControl endRefreshing];
    }];
    [task resume];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length != 0) {
        
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings) {
            return [evaluatedObject[@"title"] containsString:searchText];
        }];
        self.filteredMovies = [self.movies filteredArrayUsingPredicate:predicate];
        
        NSLog(@"%@", self.filteredMovies);
        
    }
    else {
        self.filteredMovies = self.movies;
    }
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.filteredMovies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MovieCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    NSDictionary* movie = self.filteredMovies[indexPath.row];
    cell.titleLabel.text = movie[@"title"];
    cell.descLabel.text = movie[@"overview"];

    NSString* baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString* baseURLString_small = @"https://image.tmdb.org/t/p/w45";
    NSString* posterURLString = movie[@"poster_path"];
    NSString* fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    NSString* fullPosterURLString_small = [baseURLString_small stringByAppendingString:posterURLString];
    
    NSURL* posterURL = [NSURL URLWithString:fullPosterURLString];
    NSURL* posterURL_small = [NSURL URLWithString:fullPosterURLString_small];
    
    NSURLRequest* requestSmall = [NSURLRequest requestWithURL:posterURL_small];
    
    [cell.coverImageView setImageWithURLRequest:requestSmall placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        cell.coverImageView.alpha = 0.0;
        cell.coverImageView.image = image;
        
        if(response != nil){
            [UIView animateWithDuration:0.3 animations:^{
                cell.coverImageView.alpha = 1.0;
            } completion:^(BOOL finished) {
                [cell.coverImageView setImageWithURL:posterURL];
            }];
        }
        else{
            cell.coverImageView.alpha = 1.0;
            [cell.coverImageView setImageWithURL:posterURL];
        }
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        [cell.coverImageView setImageWithURL:posterURL];
    }];
    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UITableViewCell* sourceCell = sender;
    NSIndexPath* sourceIndex = [self.tableView indexPathForCell:sourceCell];
    
    NSDictionary* movie = self.filteredMovies[sourceIndex.row];
    
    DetailsViewController* detailController = [segue destinationViewController];
    
    detailController.movie = movie;
}


@end
