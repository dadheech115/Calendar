//
//  AgendaDetailTableViewCell.m
//  VDCalendar
//
//  Created by Vikas Dadheech on 10/10/17.
//  Copyright © 2017 startrek. All rights reserved.
//

#import "AgendaDetailTableViewCell.h"
#import "Agenda.h"

/*
 @property (nonatomic, strong) NSString *title;
 @property (nonatomic, strong) NSString *type;
 @property (nonatomic, strong) NSString *venue;
 @property (nonatomic, strong) NSString *location;
 @property (nonatomic, strong) NSString *time;
 @property (nonatomic, strong) NSString *desc;
 @property (nonatomic, strong) NSString *url;
 */

@interface AgendaDetailTableViewCell()
@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UILabel *labelType;
@property (nonatomic, strong) UILabel *labelAddress;
@property (nonatomic, strong) UILabel *labelTime;
@property (nonatomic, strong) UILabel *labelDesc;
@property (nonatomic, strong) UILabel *labelUrl;


@end

@implementation AgendaDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
       [self initializeElements];
    return self;
    
}

-(void)initializeElements{
    if(self){
        CGPoint centerOfCell = self.contentView.center;
        
        //Type Label
        _labelType = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        CGPoint centerOflabelType = _labelType.center;
        centerOflabelType.y = centerOfCell.y;
        _labelType.layer.cornerRadius = _labelType.frame.size.height/2;
        [_labelType setClipsToBounds:YES];
        [_labelType setTextColor:[UIColor whiteColor]];
        [_labelType setBackgroundColor:kConferenceColor];
        [_labelType setTextAlignment:NSTextAlignmentCenter];
        
        //Title Label
        CGFloat originX = _labelType.frame.origin.x+_labelType.frame.size.width+10;
        _labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(originX, 10, 250, 20)];
        [_labelTitle adjustsFontSizeToFitWidth];
        
        //Desc Label
        _labelDesc = [[UILabel alloc] initWithFrame:CGRectMake(originX,_labelTitle.frame.origin.y+_labelTitle.frame.size.height+5, 250, 20)];
        [_labelDesc adjustsFontSizeToFitWidth];
        [_labelDesc setNumberOfLines:2];
        
        //Address Label
        _labelAddress = [[UILabel alloc] initWithFrame:CGRectMake(originX, _labelDesc.frame.origin.y+_labelDesc.frame.size.height+5, 250, 20)];
        [_labelAddress adjustsFontSizeToFitWidth];
        [_labelAddress setNumberOfLines:2];
        
        //Time Label
        _labelTime = [[UILabel alloc] initWithFrame:CGRectMake(originX, _labelAddress.frame.origin.y+_labelAddress.frame.size.height+5, 250, 20)];
        [_labelTime adjustsFontSizeToFitWidth];
        
        [self.contentView addSubview:self.labelType];
        [self.contentView addSubview:self.labelTitle];
        [self.contentView addSubview:self.labelDesc];
        [self.contentView addSubview:self.labelAddress];
        [self.contentView addSubview:self.labelTime];
        
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)prepareForReuse{
    [self.labelType setText:@""];
    [self.labelTitle setText:@""];
    [self.labelAddress setText:@""];
    [self.labelDesc setText:@""];
    [self.labelTime setText:@""];

}

-(void)setupCellDataWithAgendaDetails:(Agenda *)agenda{
    
    //Setting up values in cell
    
    [self.labelType setText:[agenda.type substringToIndex:3]];
    [self.labelTitle setText:agenda.title];
    [self.labelAddress setText:agenda.venue];
    [self.labelDesc setText:agenda.desc];
    [self.labelTime setText:agenda.time];
}

@end
