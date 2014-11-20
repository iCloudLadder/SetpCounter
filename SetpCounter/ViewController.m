//
//  ViewController.m
//  SetpCounter
//
//  待测...
//  需要在真机调试，要求具备M7处理器
//  设备系统要求最低版本为iOS8
//

#import "ViewController.h"
#import "MyMotionActivity.h"
#import "MyPedometer.h"

@interface ViewController ()
{
    BOOL _startPedometer;
    BOOL _startActivity;
}

// 获得 步数、路程、台阶数
@property (nonatomic, strong) CMPedometer *pedometer;

// 运动状态
@property (nonatomic, strong) CMMotionActivityManager *motionActivityManager;
@property (nonatomic, strong) NSOperationQueue *motionActivityQueue;

// 获取 步数 iOS8中被CMPedometer替代
// @property (nonatomic, strong) CMStepCounter *stepCounter;

@property (weak, nonatomic) IBOutlet UILabel *startDateLable;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *stepsLable;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *floorsAscendedLabel;
@property (weak, nonatomic) IBOutlet UILabel *floorsDescendedLable;
@property (weak, nonatomic) IBOutlet UILabel *activityTypeLable;
@property (weak, nonatomic) IBOutlet UILabel *activityConfidenceLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _startDateLable.text = [self getDateStringWith:[NSDate date]];
    _endDateLabel.text = [self getDateStringWith:[NSDate date]];

    // 启动运动状态监测
    [self startMotionActivityManager];
    // 启动运动数据检测
    [self startPedometer];

}

#pragma mark - CMMotionActivityManager

-(void)startMotionActivityManager
{
    if ([self creatMotionActivityManagerSuccess] && _motionActivityManager && _motionActivityQueue) {
        __weak ViewController *weakSelf = self;
        [_motionActivityManager startActivityUpdatesToQueue:_motionActivityQueue withHandler:^(CMMotionActivity *activity) {
            // 处理监测的数据
            [MyMotionActivity getMotionActivityDataWith:activity handle:^(NSString *confidenceStr, NSString *type) {
                weakSelf.activityConfidenceLabel.text = confidenceStr;
                weakSelf.activityTypeLable.text = type;
            }];
        }];
        _startActivity = YES;
        
    }else{
        // 无法监测运动状态
        [self showAlertViewWith:@"啊哦!I am sorry!您的设备不具备监测运动状态的条件(iOS7 & M7处理器)哦!"];
    }
}

-(BOOL)creatMotionActivityManagerSuccess
{
    if ([CMMotionActivityManager isActivityAvailable] && !_motionActivityManager) {
        _motionActivityManager = [[CMMotionActivityManager alloc] init];
        _motionActivityQueue = [[NSOperationQueue alloc] init];
    }
    return _motionActivityManager?YES:NO;
}

#pragma mark -  CMPedometer

-(void)startPedometer
{
    // 获得 步数、路程、台阶数
    if ([self creatPedometerSuccess] && _pedometer) {
        __weak ViewController *weakSelf = self;
        [_pedometer startPedometerUpdatesFromDate:[NSDate date] withHandler:^(CMPedometerData *pedometerData, NSError *error) {
            if (error) {
                NSLog(@"因为%@，数据更新失败!",error.localizedDescription);
                [weakSelf showAlertViewWith:[NSString stringWithFormat:@"因为%@，数据更新失败!",error.localizedDescription]];
            }else{
                // 处理获得的数据 步数、路程、台阶数
                [MyPedometer getPedometerDataWith:pedometerData handle:^(MyPedometerDataModel *myPedometerDataModel) {
                    [weakSelf getPedometerData:myPedometerDataModel];
                }];
            }
        }];
        _startPedometer = YES;
    }else{
        [self showAlertViewWith:@"啊哦!I am sorry!您的设备不具备监测运动数据的条件(iOS8 & M7处理器)哦!"];
    }
}

-(BOOL)creatPedometerSuccess
{
    if ([self checkPedometerIsAvailable] && !_pedometer) {
        _pedometer = [[CMPedometer alloc] init];
    }
    return _pedometer?YES:NO;
}

-(BOOL)checkPedometerIsAvailable
{
    return ([CMPedometer isStepCountingAvailable] && [CMPedometer isDistanceAvailable] && [CMPedometer isFloorCountingAvailable]);
}


#pragma mark - handle CMPedometer data


-(void)getPedometerData:(MyPedometerDataModel*)myPedometerDataModel
{
    _startDateLable.text = myPedometerDataModel.startDate;
    _endDateLabel.text = myPedometerDataModel.endDate;
    _stepsLable.text = myPedometerDataModel.numbersOfStep;
    _distanceLabel.text = myPedometerDataModel.distance;
    _floorsAscendedLabel.text = myPedometerDataModel.floorsAscended;
    _floorsDescendedLable.text = myPedometerDataModel.floorsDescended;
}





#pragma mark - NSNumber to NSString

-(NSString*)getNumberStringWith:(NSNumber*)number
{
    return [NSString stringWithFormat:@"%d",number.intValue];
}

#pragma mark - NSDate to NSString
-(NSString*)getDateStringWith:(NSDate*)date
{
    return [[self getDateFormatter] stringFromDate:date];
}

-(NSDateFormatter*)getDateFormatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return dateFormatter;
}
#pragma mark - show alertView

-(void)showAlertViewWith:(NSString*)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Hello Buddy" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark - buttons clicked event

- (IBAction)stopPedometer:(id)sender {
    if (_startPedometer) {
        [_pedometer stopPedometerUpdates];
        [(UIButton*)sender setTitle:@"开始检测运动数据" forState:UIControlStateNormal];
        _startPedometer = NO;
    }else{
        [self startPedometer];
        [(UIButton*)sender setTitle:@"停止检测运动数据" forState:UIControlStateNormal];
    }
}

- (IBAction)stopMotionActivity:(id)sender {
    if (_startActivity) {
        [_motionActivityManager stopActivityUpdates];
        [(UIButton*)sender setTitle:@"开始检测运动状态" forState:UIControlStateNormal];
        _startActivity = NO;
    }else{
        [self startMotionActivityManager];
        [(UIButton*)sender setTitle:@"停止检测运动状态" forState:UIControlStateNormal];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
