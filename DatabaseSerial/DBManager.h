
#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManager : NSObject


+ (id)sharedInstance;

-(NSString *) getDbFilePath;

//pairing device
-(int) updateDevice: (NSString *) deviceName   uuid:(NSString *) deviceUuid  ;
-(int) insertDevice : (NSString *) deviceName   uuid:(NSString *) deviceUuid;
-(NSArray *) getDeviceRecord :     (NSString*)  uuid;


//flight bank profile
-(int) deleteProfile: (int) profile;
-(int) updateProfile :   (int )profile   fmode:(int)fmode
             maxangle:(float)maxangle  maxrotate:(float) maxrotate  maxclimb:(float) maxclimb middeadband:(float) middeadband slowdacc:(float) slowdacc
                 name:(NSString *) profileNSSame;
-(int) insertProfile :  (int )profile   fmode:(int)fmode
             maxangle:(float)maxangle  maxrotate:(float) maxrotate  maxclimb:(float) maxclimb middeadband:(float) middeadband slowdacc:(float) slowdacc
                 name:(NSString *) prozsdafileName;
-(NSArray *) getRecords: (int  ) profileId;



//TaskPoint - Multi-points
-(NSArray *) getTPGrpp :     (int)  mid  ifLatest : (BOOL) ear    ;
-(NSArray *) getTPGroupp :     (int)  tkpidOrStatusFlag  ifEarliest : (BOOL) ear master: (int) mid;
-(NSArray *) getTP :     (int)  tkpid  masterid : (int) mid;
-(NSArray *) getTPStatusPaused : (int) status  mid : (int) master;
 
-(int) updateTPStatus : (int ) status   tkpid:(int ) tkpid  mid : (int) mid;
-(int) insertTP :(int) tkid master:(int) mid  status : (int)  stat altitude : (int) alti  velocity : (int) velo holdtime:(int) holdT : (int) droneF : (int) droneCw : (NSString *) desp  latitude: (float) lat longitude: (float) longi ;
-(int) deleteTP :   (int)  tkpid  masterid : (int) mid;


//TaskPoint =Multi-points path]
-(NSMutableArray *) getJourneyAll;
-(NSArray *) getJourney :     (int)  jid  ifLatest : (BOOL) latest;
-(int) insertJounrey : (NSString * ) desp ;
-(int) deleteJouney : (int ) jid;
-(int) updateJourney : (NSString * ) desp  : (int)  deviceUuid ;


//TaskPoint = Drone Journey

-(NSMutableArray *) getDJourneyAll ;
-(NSArray *) getDJourney :     (int)  jid  ifLatest : (BOOL) latest;
-(int) insertDJounrey : (NSString * ) desp ;
-(int) deleteDJouney : (int ) jid;

//TaskPoint = Drone location recorded
-(NSArray *) getDronLocation :     (int)  jid  ifLatest : (BOOL) latest;
-(int) insertDronLocation : (NSString * ) desp  masterId : (int) tid  altitude : (int) alti  velocity : (int) velo  rotate : (int) rotating   latitude: (float) lat longitude: (float) longi ;
-(int) deleteDronLocation : (int ) jid;

//TaskPoint = save sent command
-(NSArray *) getCommand :     (int)  jid  ifLatest : (BOOL) latest;
-(int) insertCommand : (NSString * ) desp  index  : (int) index;
-(int) deleteCommand : (int ) jid : (BOOL) all;




@end
