//
//  TrailerViewController.m
//  Flix
//
//  Created by Ruben Green on 6/25/20.
//  Copyright © 2020 Ruben Green. All rights reserved.
//

#import "TrailerViewController.h"
#import "WebKit/WebKit.h"

@interface TrailerViewController ()

@property (weak, nonatomic) IBOutlet WKWebView *webView;

@end

@implementation TrailerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString* baseURLString = @"https://api.themoviedb.org/3/movie/";
    NSString* keyString = @"/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US";
    
    NSString* urlString = [[baseURLString stringByAppendingString:self.movieID] stringByAppendingString:keyString];
    NSURL* url = [NSURL URLWithString:urlString];
    
    [self fetchTrailer: url];
}

- (void) fetchTrailer:(NSURL*) url {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
               UIAlertController* errorPopup = [UIAlertController alertControllerWithTitle:@"Error" message:[error localizedDescription] preferredStyle:(UIAlertControllerStyleAlert)];
               
               UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                   //Dismiss
               }];
               
               [errorPopup addAction:okAction];
               
               [self presentViewController:errorPopup animated:YES completion:^{
                   //Do nothing
               }];
               
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

               NSArray* resultsDict = dataDictionary[@"results"];
               NSString* ytID = resultsDict[0][@"key"];
               
               NSString* ytURLString = [(@"https://www.youtube.com/watch?v=") stringByAppendingString:ytID];
               NSURL* ytURL = [NSURL URLWithString:ytURLString];
               
               NSURLRequest* trailerRequest = [NSURLRequest requestWithURL:ytURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
               
               [self.webView loadRequest:trailerRequest];
           }
       }];
    [task resume];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
