//
//  MovieCell.h
//  Flix
//
//  Created by Ruben Green on 6/24/20.
//  Copyright © 2020 Ruben Green. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

NS_ASSUME_NONNULL_BEGIN

@interface MovieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

@property (nonatomic, strong) Movie* movie;

@end

NS_ASSUME_NONNULL_END
