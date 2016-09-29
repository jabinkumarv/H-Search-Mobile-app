//
//  AppDelegate.h
//  TestApp
//
//  Created by Jabin on 10/12/16.
//  Copyright (c) 2016 Jabin. All rights reserved.
//


#import "ContentsTableViewCell.h"
#import "UIView+AutolayoutHelper.h"

@implementation ContentsTableViewCell

@synthesize itemImage;
@synthesize itemTitle;
@synthesize itemDescription;
@synthesize lblDistance;

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        itemImage = [[UIImageView alloc] init];
        self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        [self fitView:self.contentView];
        
        [self.contentView addSubview:itemImage];
        itemImage.translatesAutoresizingMaskIntoConstraints = NO;
        
        itemTitle = [[UILabel alloc] init];
        itemTitle.backgroundColor = [UIColor clearColor];
        itemTitle.numberOfLines = 0;
        itemTitle.font=[UIFont boldSystemFontOfSize:15];
        itemTitle.lineBreakMode = NSLineBreakByWordWrapping;
        itemTitle.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:itemTitle];
        itemTitle.translatesAutoresizingMaskIntoConstraints = NO;
        
        itemDescription = [[UILabel alloc] init];
        itemDescription.textColor = [UIColor redColor];
        itemDescription.numberOfLines = 0;
        itemDescription.backgroundColor = [UIColor clearColor];
        itemDescription.font=[UIFont italicSystemFontOfSize:14];
        itemDescription.textAlignment = NSTextAlignmentLeft;
        itemDescription.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:itemDescription];
        itemDescription.translatesAutoresizingMaskIntoConstraints = NO;
        
        lblDistance = [[UILabel alloc] init];
        lblDistance.numberOfLines = 0;
        lblDistance.backgroundColor = [UIColor redColor];
        lblDistance.font=[UIFont systemFontOfSize:13];
        lblDistance.textAlignment = NSTextAlignmentLeft;
        lblDistance.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:lblDistance];
        lblDistance.translatesAutoresizingMaskIntoConstraints = NO;
        
        // itemTitle autolayouts
        float padding = 5.0;
                
        
        NSLayoutConstraint * titleWidthConstraint = [NSLayoutConstraint constraintWithItem:itemTitle attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:itemImage attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
        
        NSLayoutConstraint * titelHeightConstraint = [NSLayoutConstraint constraintWithItem:itemTitle attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:40];
        
        NSLayoutConstraint * titelTopConstraint = [NSLayoutConstraint constraintWithItem:itemTitle attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        
        NSLayoutConstraint * titelleftConstraint = [NSLayoutConstraint constraintWithItem:itemTitle attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:padding];
        
        [self.contentView addConstraints:@[titelHeightConstraint, titleWidthConstraint, titelleftConstraint, titelTopConstraint]];
        
        // itemImage autolayouts
        NSLayoutConstraint * imageTopConstraint = [NSLayoutConstraint constraintWithItem:itemImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:padding];
        
        NSLayoutConstraint * imageWidthConstraint = [NSLayoutConstraint constraintWithItem:itemImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:100];
        
        NSLayoutConstraint * imageHeightConstraint = [NSLayoutConstraint constraintWithItem:itemImage attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:100];
        
        NSLayoutConstraint * imageTrailingConstraint = [NSLayoutConstraint constraintWithItem:itemImage attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-padding];
        
        [self.contentView addConstraints:@[imageWidthConstraint, imageHeightConstraint, imageTrailingConstraint, imageTopConstraint]];
        
        // itemDescription autolayouts
        NSLayoutConstraint * descriptionTopConstraint = [NSLayoutConstraint constraintWithItem:itemDescription attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:itemTitle attribute:NSLayoutAttributeBottom multiplier:1.0 constant:padding];
        
        NSLayoutConstraint * descriptionLeadingConstraint = [NSLayoutConstraint constraintWithItem:itemDescription attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:padding];
        
        NSLayoutConstraint * descriptionTrailingConstraint = [NSLayoutConstraint constraintWithItem:itemDescription attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:itemImage attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-padding];
        
        NSLayoutConstraint * descriptionBottomConstraint = [NSLayoutConstraint constraintWithItem:itemDescription attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottomMargin multiplier:1.0 constant:padding];
        
        
        
        [self.contentView addConstraints:@[descriptionTopConstraint, descriptionLeadingConstraint, descriptionTrailingConstraint, descriptionBottomConstraint]];
        
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    self.textLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.textLabel.frame);
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
