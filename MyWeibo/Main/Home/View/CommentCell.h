//
//  CommentCell.h
//  MyWeibo
//
//  Created by mac on 15/10/16.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXLabel.h"
#import "CommentModel.h"

@interface CommentCell : UITableViewCell<WXLabelDelegate>
{
    
    __weak IBOutlet UILabel *_nameLabel;
    
    __weak IBOutlet UIImageView *_imgView;
    
    WXLabel *_commentTextLabel;
}
@property (nonatomic, retain)CommentModel *commentModel;

+ (float)getCommentHeight:(CommentModel *)commentModel;
@end
