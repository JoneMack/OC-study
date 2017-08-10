//
//  TestTableViewCell.m
//  WKTableViewCell

#import "CommonCell.h"

@implementation CommonCell
-(id)initWithStyle:(UITableViewCellStyle)style
   reuseIdentifier:(NSString *)reuseIdentifier
          delegate:(id<WKTableViewCellDelegate>)delegate
       inTableView:(UITableView *)tableView
withRightButtonTitles:(NSArray *)rightButtonTitles{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier delegate:delegate inTableView:tableView withRightButtonTitles:rightButtonTitles];
    if (self){        
        self.userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 40, 40)];
        self.userImageView.backgroundColor = [UIColor clearColor];
        self.userImageView.image = [UIImage imageNamed:@"avtar_placeholder"];
        CALayer *layer = self.userImageView.layer;
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:self.userImageView.frame.size.width/2];
        [self.cellContentView addSubview:self.userImageView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 230, 25 )];
        self.nameLabel.textColor = [UIColor blackColor];
        self.nameLabel.font = [UIFont systemFontOfSize:16];
        [self.cellContentView addSubview:self.nameLabel];
        
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 30, 250, 25 )];
        self.contentLabel.textColor = [UIColor grayColor];
        self.contentLabel.font = [UIFont systemFontOfSize:14];
        [self.cellContentView addSubview:self.contentLabel];
        
        self.downLine = [[UIView alloc] initWithFrame:CGRectMake(70, 60, kSCREEN_HEIGHT-70, 0.5)];
        self.downLine.backgroundColor = COLOR(207, 210, 213, 0.7);
        [self.cellContentView addSubview:self.downLine];
    }
    return self;
}

@end
