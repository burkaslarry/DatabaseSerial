 
#import "DBManager.h"
#import "Queue.h"


@implementation DBManager


static DBManager  *sharedInstance = nil;

+ (DBManager *) sharedInstance
{
    if (sharedInstance == nil)
        sharedInstance = [[super alloc] init];
    
   // Queue * bst =   [[Queue alloc] init];
   // [bst enqueue:sharedInstance at:7 ];    
    return sharedInstance;
}

- (id) init
{
    if (self = [super init])
    {
        if(![[NSFileManager defaultManager] fileExistsAtPath:[self getDbFilePath]]) //if the sqlite database file  does not exist
        {
            NSArray *arrayTable =  [[NSArray alloc ]initWithObjects:@"flight" , @"device" ,@"taskpoint" ,@"journey" ,@"trajectory", @"dronepoint" , @"commandsent" ,nil ];
            
            for(int  i = 0 ; i < (int)[arrayTable count] ; i++) {
                [self createTable:[self getDbFilePath]  table: (NSString *)[arrayTable objectAtIndex:i] ];
            }

        }else{
            NSLog(@" all tables exist");
        }
    }
    return self;
}


-(NSString *) getDbFilePath
{
    NSString * docsPath= NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return [docsPath stringByAppendingPathComponent:@"Test.db"];
}

-(int) createTable:(NSString*) filePath table:(NSString*) tablename
{
    sqlite3* db = NULL;
    int rc=0;
    rc = sqlite3_open([filePath UTF8String], &db);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        if([tablename isEqualToString:@"flight"]){
            char * query ="CREATE TABLE IF NOT EXISTS profile ( id INTEGER PRIMARY KEY , pname TEXT, fmode INTEGER ,  maxangle REAL, maxrotate REAL  ,maxclimb REAL , middeadband REAL , slowdacc REAL )";
            char * errMsg;
            rc = sqlite3_exec(db, query,NULL,NULL,&errMsg);
            if(SQLITE_OK != rc)
            {
                NSLog(@"Failed to create profile table rc:%d, msg=%s",rc,errMsg);
            }
            sqlite3_close(db);
        }else if([tablename isEqualToString:@"device"]){
            char * query ="CREATE TABLE IF NOT EXISTS device ( id INTEGER PRIMARY KEY  AUTOINCREMENT , dname TEXT NOT NULL, uuid TEXT  )";
            char * errMsg;
            rc = sqlite3_exec(db, query,NULL,NULL,&errMsg);
            if(SQLITE_OK != rc)
            {
                NSLog(@"Failed to create device list  rc:%d, msg=%s",rc,errMsg);
            }
            sqlite3_close(db);
        }else if([tablename isEqualToString:@"taskpoint"]){
            char * query ="CREATE TABLE IF NOT EXISTS taskpoint ( id INTEGER , mid INTEGER , status INTEGER , alti INTEGER , speed INTEGER , ht INTEGER , df INT , dcw INT, desp TEXT , lat REAL , long REAL   )";
            char * errMsg;
            rc = sqlite3_exec(db, query,NULL,NULL,&errMsg);
            if(SQLITE_OK != rc)
            {
                NSLog(@"Failed to create taskpoint  list rc:%d, msg=%s",rc,errMsg);
            }
            sqlite3_close(db);
        }else if([tablename isEqualToString:@"journey"]){
            char * query ="CREATE TABLE IF NOT EXISTS journey ( id INTEGER PRIMARY KEY  AUTOINCREMENT  , desp TEXT    )";
            char * errMsg;
            rc = sqlite3_exec(db, query,NULL,NULL,&errMsg);
            if(SQLITE_OK != rc)
            {
                NSLog(@"Failed to create journey list  rc:%d, msg=%s",rc,errMsg);
            }
            sqlite3_close(db);
        }else if([tablename isEqualToString:@"trajectory"]){
            char * query ="CREATE TABLE IF NOT EXISTS trajectory ( id INTEGER PRIMARY KEY  AUTOINCREMENT  , desp TEXT    )";
            char * errMsg;
            rc = sqlite3_exec(db, query,NULL,NULL,&errMsg);
            if(SQLITE_OK != rc)
            {
                NSLog(@"Failed to create trajectory list  rc:%d, msg=%s",rc,errMsg);
            }
            sqlite3_close(db);
        }else if([tablename isEqualToString:@"dronepoint"]){
            char * query ="CREATE TABLE IF NOT EXISTS dronepoint ( id  INTEGER PRIMARY KEY  AUTOINCREMENT , tid INTEGER , lat REAL , long REAL  , rotation REAL ,speed INTEGER , ht INTEGER   )";
            char * errMsg;
            rc = sqlite3_exec(db, query,NULL,NULL,&errMsg);
            if(SQLITE_OK != rc)
            {
                NSLog(@"Failed to create dronepoint list  rc:%d, msg=%s",rc,errMsg);
            }
            sqlite3_close(db);
        }else if([tablename isEqualToString:@"commandsent"]){
            char * query ="CREATE TABLE IF NOT EXISTS commandsent ( id INTEGER PRIMARY KEY , desp TEXT    )";
            char * errMsg;
            rc = sqlite3_exec(db, query,NULL,NULL,&errMsg);
            if(SQLITE_OK != rc)
            {
                NSLog(@"Failed to create dronepoint list  rc:%d, msg=%s",rc,errMsg);
            }
            sqlite3_close(db);
        }
        
    }
    return rc;
}


-(int) updateDevice: (NSString *) deviceName   uuid:(NSString *) deviceUuid {

    sqlite3* db = NULL;
    int rc=0;
    rc = sqlite3_open_v2([[self getDbFilePath]  cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString * query  = [NSString
                             stringWithFormat:@"UPDATE device set dname = \'%@\'   ,  uuid = \'%@\'  WHERE uuid  =\'%@\' "
                             , deviceName , deviceUuid , deviceUuid  ];
        char * errMsg;
        rc = sqlite3_exec(db, [query UTF8String] ,NULL,NULL,&errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to update device list  rc:%d, msg=%s",rc,errMsg);
        }
        sqlite3_close(db);
    }
    return rc;
}

-(int) insertDevice : (NSString *) deviceName   uuid:(NSString *) deviceUuid  {
    //maxangle REAL, maxrotate REAL  ,maxclimb REAL , middeadband REAL , slowdacc REAL  name )";
    
    sqlite3* db = NULL;
    int rc=0;
    rc = sqlite3_open_v2([[self getDbFilePath]  cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString * query  = [NSString stringWithFormat:@"INSERT INTO device ( dname , uuid  ) VALUES ( \"%@\" , \"%@\"  ) " ,   deviceName ,  deviceUuid  ];
                char * errMsg;
        rc = sqlite3_exec(db, [query UTF8String] ,NULL,NULL,&errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to insert device  record  rc:%d, msg=%s",rc,errMsg);
        }else{
            NSLog(@"Success to insert device  record  rc:%d, msg=%s",rc,errMsg);
 
        }
        sqlite3_close(db);
    }
    return rc;
}


-(BOOL) isEmptyArrayOrNil :(NSArray *)array
{
    return array == nil || [array count] == 0;
}



-(NSArray *) getDeviceRecord :  (NSString*)  uuid
{
    NSMutableArray * students =[[NSMutableArray alloc] init];
    sqlite3* db = NULL;
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([[self getDbFilePath]  UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString  * query;
        
        if(uuid ==nil){
            NSLog(@"nil  record");

        }else{
            if([uuid isEqualToString:@"null"]  || uuid == nil ){ //if criteria nil , get all devices
                query = [NSString  stringWithFormat: @"SELECT * from device  " ] ;
            }else{
                query = [NSString  stringWithFormat: @"SELECT * from device  WHERE uuid = \"%@\"  ", uuid ] ;
            }
            //        NSString  * query = [NSString  stringWithFormat: @"SELECT * from device  WHERE device = \"%@\"  ", name ] ;
            rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
            if(rc == SQLITE_OK)
            {
                while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
                {
                    NSString * name =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                    
                    NSString * uuid =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
                    
                    NSDictionary *student =[NSDictionary dictionaryWithObjectsAndKeys:name,@"dname",
                                            uuid,@"uuid",   nil];
                    
                    [students addObject:student];
                    
                }
                //   NSLog(@"Done Select");
                sqlite3_finalize(stmt);
            }
            else
            {
                NSLog(@"Failed to prepare statement with rc:%d",rc);
            }
            sqlite3_close(db);
        }
    }
    
    return students;
    
}


-(int) deleteProfile: (int) profile
{
    sqlite3* db = NULL;
    int rc=0;
    rc = sqlite3_open_v2([[self getDbFilePath]  cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString * query  = [NSString
                             stringWithFormat:@"DELETE FROM profile where id=\"%d\"",profile];
        char * errMsg;
        rc = sqlite3_exec(db, [query UTF8String] ,NULL,NULL,&errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to delete record  rc:%d, msg=%s",rc,errMsg);
        }
        sqlite3_close(db);
    }
    
    return  rc;
}





-(int) updateProfile :   (int )profile   fmode:(int)fmode
             maxangle:(float)maxangle  maxrotate:(float) maxrotate  maxclimb:(float) maxclimb middeadband:(float) middeadband slowdacc:(float) slowdacc
                 name:(NSString *) profileNSSame {
    //maxangle REAL, maxrotate REAL  ,maxclimb REAL , middeadband REAL , slowdacc REAL  name )";
    
    sqlite3* db = NULL;
    int rc=0;
    rc = sqlite3_open_v2([[self getDbFilePath] cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString * query  = [NSString
                             stringWithFormat:@"UPDATE profile set pname = \'%@\', fmode = %d , maxangle = %f, maxrotate = %f , maxclimb = %f, middeadband = %f, slowdacc = %f    WHERE id=%d "
                             , profileNSSame , fmode , maxangle , maxrotate , maxclimb , middeadband, slowdacc ,  profile ];
        char * errMsg;
        rc = sqlite3_exec(db, [query UTF8String] ,NULL,NULL,&errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to update profile  rc:%d, msg=%s",rc,errMsg);
        }
        sqlite3_close(db);
    }
    return rc;
}

-(int) insertProfile :  (int )profile   fmode:(int)fmode
             maxangle:(float)maxangle  maxrotate:(float) maxrotate  maxclimb:(float) maxclimb middeadband:(float) middeadband slowdacc:(float) slowdacc
                 name:(NSString *) prozsdafileName {
    //maxangle REAL, maxrotate REAL  ,maxclimb REAL , middeadband REAL , slowdacc REAL  name )";
    
    sqlite3* db = NULL;
    int rc=0;
    rc = sqlite3_open_v2([[self getDbFilePath]  cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString * query  = [NSString stringWithFormat:@"INSERT INTO profile (id , pname , fmode ,maxangle,maxrotate,maxclimb ,middeadband ,slowdacc  ) VALUES ( \"%d\" , \"%@\"  , \"%d\" , \"%f\" , \"%f\", \"%f\", \"%f\", \"%f\"  ) " ,   profile ,  prozsdafileName , fmode , maxangle , maxrotate , maxclimb , middeadband  , slowdacc  ];
        
        char * errMsg;
        
         rc = sqlite3_exec(db, [query UTF8String] ,NULL,NULL,&errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to insert profile  record  rc:%d, msg=%s",rc,errMsg);
        }
        sqlite3_close(db);
    }
    return rc;
}


-(NSArray *) getRecords :(int  ) profileId
{
    NSMutableArray * students =[[NSMutableArray alloc] init];
    sqlite3* db = NULL;
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([[self getDbFilePath]  UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString  * query = [NSString  stringWithFormat: @"SELECT * from profile  WHERE id = %d", profileId ] ;
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                NSString * name =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                int fmode =  sqlite3_column_int(stmt, 2);
                float maxangle =  sqlite3_column_int(stmt, 3);
                float maxrotate =  sqlite3_column_int(stmt, 4);
                float maxclimb =  sqlite3_column_int(stmt, 5);
                double middeadband =  sqlite3_column_double(stmt, 6);
                double slowdacc =  sqlite3_column_double(stmt, 7);
                
                NSLog(@"middeadband %f" ,middeadband);
                
                NSLog(@"slowdacc %f" ,slowdacc);
                
                NSDictionary *student =[NSDictionary dictionaryWithObjectsAndKeys:name,@"name",
                                        [NSNumber numberWithInteger:fmode],@"fmode",
                                        [NSNumber numberWithFloat:maxangle], @"maxangle",
                                        [NSNumber numberWithFloat:maxrotate], @"maxrotate",
                                        [NSNumber numberWithFloat:maxclimb], @"maxclimb",
                                        [NSNumber numberWithDouble:middeadband]    , @"middeadband",
                                        [NSNumber numberWithDouble:slowdacc]   ,  @"slowdacc",nil];
                
                [students addObject:student];
                
            }
          //  NSLog(@"Done");
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    
    return students;
}

    //}else if([tablename isEqualToString:@"journey"]){
//    char * query ="CREATE TABLE IF NOT EXISTS journey ( id INTEGER PRIMARY KEY  AUTOINCREMENT , jname TEXT , desp TEXT ,   createTime REAL   )";
//    char * errMsg;
//    rc = sqlite3_exec(db, query,NULL,NULL,&errMsg);
//    if(SQLITE_OK != rc)
//    {
//        NSLog(@"Failed to create journey list  rc:%d, msg=%s",rc,errMsg);
//    }
//    sqlite3_close(db);
//    
//TaskPoint - Multi-points


-(NSArray *) getTPStatusPaused : (int) status  mid : (int) master  {
    
    NSMutableArray * students =[[NSMutableArray alloc] init];
    sqlite3* db = NULL;
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([[self getDbFilePath]  UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        
        NSString  *query   = [NSString  stringWithFormat: @"SELECT * from taskpoint  WHERE status = %d and mid = %d order by id asc " , status , master     ] ;
        
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                // ( id INTEGER PRIMARY KEY  AUTOINCREMENT , mid INTEGER , status INTEGER , alti INTEGER , speed INTEGER , ht INTEGER , df INT , dcw INT, desp TEXT , lat REAL , long REAL  ,   createTime REAL )";
                //                status INTEGER , alti REAL , speed REAL , ht REAL , df INT , dcw INT, desp TEXT , lat REAL , long REAL  ,
                //      NSString * name =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                
                int tkpid =  sqlite3_column_int(stmt, 0);
                int mid =  sqlite3_column_int(stmt, 1);
                int sta =  sqlite3_column_int(stmt, 2);
                int alti =  sqlite3_column_int(stmt, 3);
                int ve =  sqlite3_column_int(stmt, 4);
                int ht  =  sqlite3_column_int(stmt, 5);
                int droneF =  sqlite3_column_double(stmt, 6);
                int droneCW =  sqlite3_column_double(stmt, 7);
                float lat =  sqlite3_column_double(stmt, 9);
                float lon =  sqlite3_column_double(stmt, 10);
                
                
                NSDictionary *student =[NSDictionary dictionaryWithObjectsAndKeys: [NSString stringWithFormat:@"%d:%d" , tkpid , mid], @"tkpsssid",
                                        [NSNumber numberWithInt:tkpid],@"tkpid",
                                        [NSNumber numberWithInt:mid],@"mid",
                                        [NSNumber numberWithInt:sta], @"taskpointstatus",
                                        [NSNumber numberWithInt:alti], @"alti",
                                        [NSNumber numberWithInt:ve], @"ve",
                                        [NSNumber numberWithInt:ht]    , @"ht",
                                        [NSNumber numberWithInt:droneF]    , @"droneF",
                                        [NSNumber numberWithInt:droneCW]    , @"droneCW",
                                        [NSNumber numberWithFloat:lat]    , @"lat",
                                        [NSNumber numberWithFloat:lon]    , @"lon",
                                        nil];
                
                [students addObject:student];
            }
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    return students;
}




-(NSArray *) getTPGrpp :     (int)  mid  ifLatest : (BOOL) ear    {
    NSMutableArray * students =[[NSMutableArray alloc] init];
    sqlite3* db = NULL;
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([[self getDbFilePath]  UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        
        NSString  * query;
        if(ear == true) {
            // tkpidOrStatusFlag become a status flag
            query   = [NSString  stringWithFormat: @"SELECT * from taskpoint  order by id DESC LIMIT 1" ] ;
        }else{
            // tkpidOrStatusFlag become a unique id for extraction
            query   = [NSString  stringWithFormat: @"SELECT * from taskpoint  WHERE mid = %d", mid ] ;
        }
        
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                               
                int tkpid =  sqlite3_column_int(stmt, 0);
                int mid =  sqlite3_column_int(stmt, 1);
                int sta =  sqlite3_column_int(stmt, 2);
                int alti =  sqlite3_column_int(stmt, 3);
                int ve =  sqlite3_column_int(stmt, 4);
                int ht  =  sqlite3_column_int(stmt, 5);
                int droneF =  sqlite3_column_double(stmt, 6);
                int droneCW =  sqlite3_column_double(stmt, 7);
                float lat =  sqlite3_column_double(stmt, 9);
                float lon =  sqlite3_column_double(stmt, 10);
                
                
                NSDictionary *student =[NSDictionary dictionaryWithObjectsAndKeys: [NSString stringWithFormat:@"%d:%d" , tkpid , mid], @"tkpsid",
                                        [NSNumber numberWithInt:tkpid],@"tkpid",
                                        [NSNumber numberWithInt:mid],@"mid",
                                        [NSNumber numberWithInt:sta], @"taskpointstatus",
                                        [NSNumber numberWithInt:alti], @"alti",
                                        [NSNumber numberWithInt:ve], @"ve",
                                        [NSNumber numberWithInt:ht]    , @"ht",
                                        [NSNumber numberWithInt:droneF]    , @"droneF",
                                        [NSNumber numberWithInt:droneCW]    , @"droneCW",
                                        [NSNumber numberWithFloat:lat]    , @"lat",
                                        [NSNumber numberWithFloat:lon]    , @"lon",
                                        nil];
                
                [students addObject:student];
            }
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    
    return students;
}
 


-(NSArray *) getTPGroupp :     (int)  tkpidOrStatusFlag  ifEarliest : (BOOL) ear  master: (int) mid  {
    NSMutableArray * students =[[NSMutableArray alloc] init];
    sqlite3* db = NULL;
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([[self getDbFilePath]  UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        
        NSString  * query;
        
        if(ear == true) {
            // tkpidOrStatusFlag become a status flag
            query   = [NSString  stringWithFormat: @"SELECT * from taskpoint  WHERE status = %d AND mid = %d order by id ASC LIMIT 1", tkpidOrStatusFlag , mid ] ;
        }else{
            // tkpidOrStatusFlag become a unique id for extraction
            query   = [NSString  stringWithFormat: @"SELECT * from taskpoint  WHERE mid = %d", mid ] ;
        }
        
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                // ( id INTEGER PRIMARY KEY  AUTOINCREMENT , mid INTEGER , status INTEGER , alti INTEGER , speed INTEGER , ht INTEGER , df INT , dcw INT, desp TEXT , lat REAL , long REAL  ,   createTime REAL )";
//                status INTEGER , alti REAL , speed REAL , ht REAL , df INT , dcw INT, desp TEXT , lat REAL , long REAL  ,
          //      NSString * name =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                
                int tkpid =  sqlite3_column_int(stmt, 0);
                int mid =  sqlite3_column_int(stmt, 1);
                int sta =  sqlite3_column_int(stmt, 2);
                int alti =  sqlite3_column_int(stmt, 3);
                int ve =  sqlite3_column_int(stmt, 4);
                int ht  =  sqlite3_column_int(stmt, 5);
                int droneF =  sqlite3_column_double(stmt, 6);
                int droneCW =  sqlite3_column_double(stmt, 7);
                float lat =  sqlite3_column_double(stmt, 9);
                float lon =  sqlite3_column_double(stmt, 10);
                
                
                NSDictionary *student =[NSDictionary dictionaryWithObjectsAndKeys: [NSString stringWithFormat:@"%d:%d" , tkpid , mid], @"tkpsssid",
                                        [NSNumber numberWithInt:tkpid],@"tkpid",
                                        [NSNumber numberWithInt:mid],@"mid",
                                        [NSNumber numberWithInt:sta], @"taskpointstatus",
                                        [NSNumber numberWithInt:alti], @"alti",
                                        [NSNumber numberWithInt:ve], @"ve",
                                        [NSNumber numberWithInt:ht]    , @"ht",
                                        [NSNumber numberWithInt:droneF]    , @"droneF",
                                        [NSNumber numberWithInt:droneCW]    , @"droneCW",
                                        [NSNumber numberWithFloat:lat]    , @"lat",
                                        [NSNumber numberWithFloat:lon]    , @"lon",
                                        nil];
                
                [students addObject:student];
            }
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    return students;
}


//
-(NSArray *) getTP :     (int)  tkpid masterid : (int) mid {
    NSMutableArray * students =[[NSMutableArray alloc] init];
    sqlite3* db = NULL;
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([[self getDbFilePath]  UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        
        NSString  *   query   = [NSString  stringWithFormat: @"SELECT * from taskpoint  WHERE  id = %d AND mid = %d ", tkpid , mid ] ;
         rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                // ( id INTEGER PRIMARY KEY  AUTOINCREMENT , mid INTEGER , status INTEGER , alti INTEGER , speed INTEGER , ht INTEGER , df INT , dcw INT, desp TEXT , lat REAL , long REAL  ,   createTime REAL )";
                //                status INTEGER , alti REAL , speed REAL , ht REAL , df INT , dcw INT, desp TEXT , lat REAL , long REAL  ,
             //   NSString * name =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                
                int tkpid =  sqlite3_column_int(stmt, 0);
                int mid =  sqlite3_column_int(stmt, 1);
                int sta =  sqlite3_column_int(stmt, 2);
                int alti =  sqlite3_column_int(stmt, 3);
                int ve =  sqlite3_column_int(stmt, 4);
                int ht  =  sqlite3_column_int(stmt, 5);
                int droneF =  sqlite3_column_double(stmt, 6);
                int droneCW =  sqlite3_column_double(stmt, 7);
                float lat =  sqlite3_column_double(stmt, 9);
                float lon =  sqlite3_column_double(stmt, 10);
                
                
                NSDictionary *student =[NSDictionary dictionaryWithObjectsAndKeys: [NSString stringWithFormat:@"%d:%d" , tkpid , mid], @"tkpsssid",
                                        [NSNumber numberWithInt:tkpid],@"tkpid",
                                        [NSNumber numberWithInt:mid],@"mid",
                                        [NSNumber numberWithInt:sta], @"taskpointstatus",
                                        [NSNumber numberWithInt:alti], @"alti",
                                        [NSNumber numberWithInt:ve], @"ve",
                                        [NSNumber numberWithInt:ht]    , @"ht",
                                        [NSNumber numberWithInt:droneF]    , @"droneF",
                                        [NSNumber numberWithInt:droneCW]    , @"droneCW",
                                        [NSNumber numberWithFloat:lat]    , @"lat",
                                        [NSNumber numberWithFloat:lon]    , @"lon",
                                        nil];
                
                [students addObject:student];
            }
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    
    return students;
}

-(int) deleteTP :   (int)  tkpid  masterid : (int) mid {
    
    sqlite3* db = NULL;
    int rc=0;
    rc = sqlite3_open_v2([[self getDbFilePath]  cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString * query  = [NSString
                             stringWithFormat:@"DELETE FROM taskpoint where id= %d and mid = %d ", tkpid , mid];
        char * errMsg;
        rc = sqlite3_exec(db, [query UTF8String] ,NULL,NULL,&errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to delete record  rc:%d, msg=%s",rc,errMsg);
        }
        sqlite3_close(db);
    }
    
    return  rc;
    
}

-(int) updateTPStatus : (int ) status   tkpid:(int ) tkpid   mid : (int) mid {
    sqlite3* db = NULL;
    int rc=0;

    NSLog(@"index %d , master index %d" , tkpid , mid);

    rc = sqlite3_open_v2([[self getDbFilePath] cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString * query  = [NSString stringWithFormat:@"UPDATE taskpoint set status=\"%d\" where id=\"%d\" and mid =\"%d\" ", status , tkpid , mid];
         char * errMsg;
        rc = sqlite3_exec(db, [query UTF8String] ,NULL,NULL,&errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to update taskpoint status  rc:%d, msg=%s",rc,errMsg);
        }else{
            NSLog(@"Successsadasdasd");

        }
        
        
        sqlite3_close(db);
    }
    return rc;
}

-(int) insertTP :(int) tkid master:(int) mid  status : (int)  stat altitude : (int) alti  velocity : (int) velo holdtime:(int) holdT : (int) droneF : (int) droneCw : (NSString *) desp  latitude: (float) lat longitude: (float) longi {
    
    sqlite3* db = NULL;
    int rc=0;
    rc = sqlite3_open_v2([[self getDbFilePath]  cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        ////    char * query ="CREATE TABLE IF NOT EXISTS taskpoint ( id INTEGER PRIMARY KEY  AUTOINCREMENT , mid INTEGER , status INTEGER , alti REAL , speed REAL , ht REAL , df INT , dcw INT, desp TEXT , lat REAL , long REAL  ,   createTime REAL )";
        NSString * query  = [NSString stringWithFormat:@"INSERT INTO taskpoint (id , mid , status , alti, speed ,ht ,df ,dcw , desp , lat, long  ) VALUES ( \"%d\" ,  \"%d\" ,  \"%d\", \"%d\",\"%d\",\"%d\",\"%d\",\"%d\", \"%@\", \"%f\" , \"%f\"  ) " ,   tkid ,  mid , stat , alti , velo , holdT , droneF  , droneCw , desp , lat, longi  ];
        
        char * errMsg;
        
        rc = sqlite3_exec(db, [query UTF8String] ,NULL,NULL,&errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to insert profile record  rc:%d, msg=%s",rc,errMsg);
        }
        sqlite3_close(db);
    }
    return rc;
    
}
//
//

-(NSMutableArray *) getJourneyAll {
    NSMutableArray * students =[[NSMutableArray alloc] init];
    sqlite3* db = NULL;
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([[self getDbFilePath]  UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        
        NSString  *   query   =  [NSString  stringWithFormat: @"SELECT * from journey order by id asc "  ] ;
            
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                
                int tkpid =  sqlite3_column_int(stmt, 0);
                
                const char *_abc = (char *) sqlite3_column_text(stmt, 1);
                
                NSString *_abcTemp;
                
                if (_abc)
                    _abcTemp = _abc == NULL ? nil : [[NSString alloc] initWithUTF8String:_abc];
                else
                    _abcTemp = @"Not a valid string";
                
                NSDictionary *student =[NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:tkpid],@"mid",
                                        _abcTemp,@"desp",
                                        nil];
                
                [students addObject:student];
 
            }
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    
    return students;

}


-(NSArray *) getJourney :     (int)  jid  ifLatest : (BOOL) latest {
    NSMutableArray * students =[[NSMutableArray alloc] init];
    sqlite3* db = NULL;
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([[self getDbFilePath]  UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        
        NSString  *   query   ;
        
        if(latest ==true) {
            
            query =  [NSString  stringWithFormat: @"SELECT * from journey order by id desc limit 1"  ] ;
            
        }else{
            
            query =  [NSString  stringWithFormat: @"SELECT * from journey  WHERE id = %d  ",jid   ] ;
        }
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                // ( id INTEGER PRIMARY KEY  AUTOINCREMENT , mid INTEGER , status INTEGER , alti INTEGER , speed INTEGER , ht INTEGER , df INT , dcw INT, desp TEXT , lat REAL , long REAL  ,   createTime REAL )";
                //                status INTEGER , alti REAL , speed REAL , ht REAL , df INT , dcw INT, desp TEXT , lat REAL , long REAL  ,
                //   NSString * name =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                
                int tkpid =  sqlite3_column_int(stmt, 0);
                NSString * desp =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];

                
                NSDictionary *student =[NSDictionary dictionaryWithObjectsAndKeys: [NSString stringWithFormat:@"%d:%@" , tkpid , desp], @"tkpid",
                                        [NSNumber numberWithInt:tkpid],@"mid",
                                        desp,@"desp",
                                        nil];
                
                [students addObject:student];
                
                               
               
            }
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    
    return students;
}

-(BOOL) validRegex:(NSString*) inputString :(NSString *) pattern  {
    
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:inputString options:0 range:NSMakeRange(0, [inputString length])];
    
    if (regExMatches == 0) {
        return NO;
    } else
        return YES;
}


-(int) updateJourney : (NSString * ) desp  : (int)  deviceUuid {

    sqlite3* db = NULL;
    int rc=0;
    rc = sqlite3_open_v2([[self getDbFilePath]  cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString * query  = [NSString
                             stringWithFormat:@"UPDATE journey set desp = \'%@\'    WHERE id= %d", desp , deviceUuid  ];
        char * errMsg;
        rc = sqlite3_exec(db, [query UTF8String] ,NULL,NULL,&errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to update journey list  rc:%d, msg=%s",rc,errMsg);
        }
        sqlite3_close(db);
    }
    return rc;
    
}


- (int) insertJounrey : (NSString * ) desp   {
    sqlite3* db = NULL;
    int rc=0;
    rc = sqlite3_open_v2([[self getDbFilePath]  cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        ////    char * query ="CREATE TABLE IF NOT EXISTS taskpoint ( id INTEGER PRIMARY KEY  AUTOINCREMENT , mid INTEGER , status INTEGER , alti REAL , speed REAL , ht REAL , df INT , dcw INT, desp TEXT , lat REAL , long REAL  ,   createTime REAL )";
        NSString * query  = [NSString stringWithFormat:@"INSERT INTO journey (desp   ) VALUES (  \"%@\" ) " ,   desp  ];
        
        char * errMsg;
        
        rc = sqlite3_exec(db, [query UTF8String] ,NULL,NULL,&errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to insert journey  record  rc:%d, msg=%s",rc,errMsg);
        }
        sqlite3_close(db);
        
        
     //   NSInteger lastRowId = sqlite3_last_insert_rowid(yourdatabasename);

    }
    return rc;
}

-(int) deleteJouney : (int ) jid {
    
    //-(NSArray *) getTP :     (int)  tkpid  masterid : (int) mid;

//    -(int) deleteTP :   (int)  tkpid  masterid : (int) mid;
    
    
    NSArray * stp = [self getTPGrpp:jid ifLatest:false] ;
    for(int i = 0 ; i < [stp count] ; i ++) {
        NSDictionary * profileDict =[stp objectAtIndex:i];
        [self deleteTP :   (int) [[profileDict objectForKey:@"tkpid"] integerValue ]  masterid : jid ] ;
        
    }
    
    sqlite3* db = NULL;
    int rc=0;
    rc = sqlite3_open_v2([[self getDbFilePath]  cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString * query  = [NSString
                             stringWithFormat:@"DELETE FROM journey where id= %d", jid];
        char * errMsg;
        rc = sqlite3_exec(db, [query UTF8String] ,NULL,NULL,&errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to delete record  rc:%d, msg=%s",rc,errMsg);
        }
        sqlite3_close(db);
    }
    
    return  rc;
}



-(NSMutableArray *) getDJourneyAll {
    NSMutableArray * students =[[NSMutableArray alloc] init];
    sqlite3* db = NULL;
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([[self getDbFilePath]  UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        
        NSString  *   query   =  [NSString  stringWithFormat: @"SELECT * from trajectory order by id asc "  ] ;
        
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                
                int tkpid =  sqlite3_column_int(stmt, 0);
                NSString * desp =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                
              
                
                [students addObject:desp];
            }
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    
    return students;
    
}



//TaskPoint = Drone Journey
-(NSArray *) getDJourney :     (int)  jid  ifLatest : (BOOL) latest {
    NSMutableArray * students =[[NSMutableArray alloc] init];
    sqlite3* db = NULL;
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([[self getDbFilePath]  UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        
        NSString  *   query   ;
        
        if(latest ==true) {
            
            query =  [NSString  stringWithFormat: @"SELECT * from trajectory order by id desc limit 1"  ] ;
            
        }else{
            
            query =  [NSString  stringWithFormat: @"SELECT * from trajectory  WHERE id = %d  ",jid   ] ;
        }
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                // ( id INTEGER PRIMARY KEY  AUTOINCREMENT , mid INTEGER , status INTEGER , alti INTEGER , speed INTEGER , ht INTEGER , df INT , dcw INT, desp TEXT , lat REAL , long REAL  ,   createTime REAL )";
                //                status INTEGER , alti REAL , speed REAL , ht REAL , df INT , dcw INT, desp TEXT , lat REAL , long REAL  ,
                //   NSString * name =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                
                int tkpid =  sqlite3_column_int(stmt, 0);
                NSString * desp =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                
                NSDictionary *student =[NSDictionary dictionaryWithObjectsAndKeys: [NSString stringWithFormat:@"%d:%@" , tkpid , desp], @"tkpid",
                                        [NSNumber numberWithInt:tkpid],@"mid",
                                        desp,@"desp",
                                        nil];
                
                [students addObject:student];
            }
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    
    return students;
}


-(int) insertDJounrey : (NSString * ) desp {
    sqlite3* db = NULL;
    int rc=0;
    rc = sqlite3_open_v2([[self getDbFilePath]  cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        ////    char * query ="CREATE TABLE IF NOT EXISTS taskpoint ( id INTEGER PRIMARY KEY  AUTOINCREMENT , mid INTEGER , status INTEGER , alti REAL , speed REAL , ht REAL , df INT , dcw INT, desp TEXT , lat REAL , long REAL  ,   createTime REAL )";
        NSString * query  = [NSString stringWithFormat:@"INSERT INTO trajectory (desp   ) VALUES (  \"%@\" ) " ,   desp  ];
        
        char * errMsg;
        
        rc = sqlite3_exec(db, [query UTF8String] ,NULL,NULL,&errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to insert trajectory  record  rc:%d, msg=%s",rc,errMsg);
        }
        sqlite3_close(db);
    }
    return rc;
}


-(int) deleteDJouney : (int ) jid {
    sqlite3* db = NULL;
    int rc=0;
    rc = sqlite3_open_v2([[self getDbFilePath]  cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString * query  = [NSString
                             stringWithFormat:@"DELETE FROM trajectory where id= %d", jid];
        char * errMsg;
        rc = sqlite3_exec(db, [query UTF8String] ,NULL,NULL,&errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to delete record  rc:%d, msg=%s",rc,errMsg);
        }
        sqlite3_close(db);
    }
    
    return  rc;
}

//TaskPoint = Drone location recorded
-(NSArray *) getDronLocation :     (int)  jid  ifLatest : (BOOL) latest {
    NSMutableArray * students =[[NSMutableArray alloc] init];
    sqlite3* db = NULL;
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([[self getDbFilePath]  UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        
        NSString  *   query   ;
        
        if(latest ==true) {
            
            query =  [NSString  stringWithFormat: @"SELECT * from dronepoint order by id desc limit 1"  ] ;
            
        }else{
            
            query =  [NSString  stringWithFormat: @"SELECT * from dronepoint  WHERE id = %d  ",jid   ] ;
        }
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                // ( id INTEGER PRIMARY KEY  AUTOINCREMENT , mid INTEGER , status INTEGER , alti INTEGER , speed INTEGER , ht INTEGER , df INT , dcw INT, desp TEXT , lat REAL , long REAL  ,   createTime REAL )";
                //                status INTEGER , alti REAL , speed REAL , ht REAL , df INT , dcw INT, desp TEXT , lat REAL , long REAL  ,
                //   NSString * name =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                
                int tkpid =  sqlite3_column_int(stmt, 0);
                NSString * desp =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                
                
                NSDictionary *student =[NSDictionary dictionaryWithObjectsAndKeys: [NSString stringWithFormat:@"%d:%@" , tkpid , desp], @"tkpid",
                                        [NSNumber numberWithInt:tkpid],@"mid",
                                        desp,@"desp",
                                        nil];
                
                [students addObject:student];
            }
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    
    return students;
}


-(int) insertDronLocation : (NSString * ) desp   masterId : (int) tid   altitude : (int) alti  velocity : (int) velo  rotate : (int) rotating   latitude: (float) lat longitude: (float) longi {
    sqlite3* db = NULL;
    int rc=0;
    rc = sqlite3_open_v2([[self getDbFilePath]  cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        ////    char * query ="CREATE TABLE IF NOT EXISTS taskpoint ( id INTEGER PRIMARY KEY  AUTOINCREMENT , mid INTEGER , status INTEGER , alti REAL , speed REAL , ht REAL , df INT , dcw INT, desp TEXT , lat REAL , long REAL  ,   createTime REAL )";
        NSString * query  = [NSString stringWithFormat:@"INSERT INTO dronepoint  ( tid , desp , ht , speed , rotation , lat, long    ) VALUES (  \"%d\" ,  \"%@\" , \"%d\" ,  \"%d\" ,  \"%d\" , \"%f\" , \"%f\" ) " , tid ,  desp , alti , velo , rotating , lat , longi  ];
        
        char * errMsg;
        
        rc = sqlite3_exec(db, [query UTF8String] ,NULL,NULL,&errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to insert journey  record  rc:%d, msg=%s",rc,errMsg);
        }
        sqlite3_close(db);
    }
    return rc;
}


-(int) deleteDronLocation : (int ) jid {
    sqlite3* db = NULL;
    int rc=0;
    rc = sqlite3_open_v2([[self getDbFilePath]  cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString * query  = [NSString
                             stringWithFormat:@"DELETE FROM dronepoint where id=\"%d\"", jid];
        char * errMsg;
        rc = sqlite3_exec(db, [query UTF8String] ,NULL,NULL,&errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to delete record  rc:%d, msg=%s",rc,errMsg);
        }
        sqlite3_close(db);
    }
    
    return  rc;
}

//TaskPoint = save sent command
-(NSArray *) getCommand :     (int)  jid  ifLatest : (BOOL) latest {
    NSMutableArray * students =[[NSMutableArray alloc] init];
    sqlite3* db = NULL;
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([[self getDbFilePath]  UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        
        NSString  *   query   ;
        
        if(latest ==true) {
            
            query =  [NSString  stringWithFormat: @"SELECT * from commandsent order by id desc limit 1"  ] ;
            
        }else{
            
            query =  [NSString  stringWithFormat: @"SELECT * from commandsent  WHERE id = %d  ",jid   ] ;
        }
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                // ( id INTEGER PRIMARY KEY  AUTOINCREMENT , mid INTEGER , status INTEGER , alti INTEGER , speed INTEGER , ht INTEGER , df INT , dcw INT, desp TEXT , lat REAL , long REAL  ,   createTime REAL )";
                //                status INTEGER , alti REAL , speed REAL , ht REAL , df INT , dcw INT, desp TEXT , lat REAL , long REAL  ,
                //   NSString * name =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                
                int tkpid =  sqlite3_column_int(stmt, 0);
                NSString * desp =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                
                
                NSDictionary *student =[NSDictionary dictionaryWithObjectsAndKeys: [NSString stringWithFormat:@"%d:%@" , tkpid , desp], @"tkpid",
                                        [NSNumber numberWithInt:tkpid],@"mid",
                                        desp,@"desp",
                                        nil];
                
                [students addObject:student];
            }
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    
    return students;
}


-(int) insertCommand : (NSString * ) desp   index : (int) index {
    sqlite3* db = NULL;
    int rc=0;
    rc = sqlite3_open_v2([[self getDbFilePath]  cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        ////    char * query ="CREATE TABLE IF NOT EXISTS taskpoint ( id INTEGER PRIMARY KEY  AUTOINCREMENT , mid INTEGER , status INTEGER , alti REAL , speed REAL , ht REAL , df INT , dcw INT, desp TEXT , lat REAL , long REAL  ,   createTime REAL )";
        NSString * query  = [NSString stringWithFormat:@"INSERT INTO commandsent ( id , desp   ) VALUES ( \"%d\" ,  \"%@\" ) " ,  index ,  desp  ];
        
        char * errMsg;
        
        rc = sqlite3_exec(db, [query UTF8String] ,NULL,NULL,&errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to insert journey  record  rc:%d, msg=%s",rc,errMsg);
        }
        sqlite3_close(db);
    }
    return rc;
}

-(int) deleteCommand : (int ) jid  : (BOOL) all {
    sqlite3* db = NULL;
    int rc=0;
    rc = sqlite3_open_v2([[self getDbFilePath]  cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString * query  = [NSString
                             stringWithFormat:@"DELETE FROM commandsent where id=\"%d\"", jid];
        
        if(all){
            query = [NSString
                     stringWithFormat:@"DELETE FROM commandsent" ];
        
        }
        char * errMsg;
        rc = sqlite3_exec(db, [query UTF8String] ,NULL,NULL,&errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to delete record  rc:%d, msg=%s",rc,errMsg);
        }
        sqlite3_close(db);
    }
    
    return  rc;
} 

 



@end
