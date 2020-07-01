//
//  MoviesViewController.m
//  Flix
//
//  Created by Ruben Green on 6/24/20.
//  Copyright © 2020 Ruben Green. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "Movie.h"
#import "MovieAPIManager.h"
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
            self.filteredMovies = self.movies;
            
            [self.tableView reloadData];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.refreshControl endRefreshing];
    }];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length != 0) {
        
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(Movie *evaluatedObject, NSDictionary *bindings) {
            return [evaluatedObject.title containsString:searchText];
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
    
    cell.movie = self.filteredMovies[indexPath.row];
    
    return cell;
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UITableViewCell* sourceCell = sender;
    NSIndexPath* sourceIndex = [self.tableView indexPathForCell:sourceCell];
    
    Movie* movie = self.filteredMovies[sourceIndex.row];
    
    DetailsViewController* detailController = [segue destinationViewController];
    
    detailController.movie = movie;
}


@end
