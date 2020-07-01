//
//  PosterCell.h
//  Flix
//
//  Created by Ruben Green on 6/25/20.
//  Copyright © 2020 Ruben Green. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

NS_ASSUME_NONNULL_BEGIN

@interface PosterCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;

@property (nonatomic, strong) Movie* movie;

@end

NS_ASSUME_NONNULL_END
