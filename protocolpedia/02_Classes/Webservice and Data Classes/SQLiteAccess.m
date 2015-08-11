//
//  SQLiteAccess.m
//  ProtocolPedia
//
//   4/16/10.
//  Copyright MandellMobileApps. All rights reserved.
//

#import "SQLiteAccess.h"
#import <sqlite3.h>

@implementation SQLiteAccess

//static int singleRowCallback(void *queryValuesVP, int columnCount, char **values, char **columnNames) {
//    NSMutableDictionary *queryValues = (NSMutableDictionary *)queryValuesVP;
//    int i;
//    for(i=0; i<columnCount; i++) {
//        [queryValues setObject:values[i] ? [NSString stringWithFormat:@"%s",values[i]] : [NSNull null] 
//                        forKey:[NSString stringWithFormat:@"%s", columnNames[i]]];
//    }
//    return 0;
//}
//
//static int multipleRowCallback(void *queryValuesVP, int columnCount, char **values, char **columnNames) {
//    NSMutableArray *queryValues = (NSMutableArray *)queryValuesVP;
//    NSMutableDictionary *individualQueryValues = [NSMutableDictionary dictionary];
//    int i;
//    for(i=0; i<columnCount; i++) {
//        [individualQueryValues setObject:values[i] ? [NSString stringWithFormat:@"%s",values[i]] : [NSNull null] 
//                                  forKey:[NSString stringWithFormat:@"%s", columnNames[i]]];
//    }
//    [queryValues addObject:[NSDictionary dictionaryWithDictionary:individualQueryValues]];
//
//    return 0;
//}


static int singleRowCallback(void *queryValuesVP, int columnCount, char **values, char **columnNames) {
	NSMutableDictionary *queryValues = (NSMutableDictionary *)queryValuesVP;
	int i;
	for(i=0; i<columnCount; i++) {
		[queryValues setObject:values[i] ? [NSString stringWithUTF8String:values[i]] : [NSNull null]
						forKey:[NSString stringWithFormat:@"%s", columnNames[i]]];
	}
	return 0;
}


static int multipleRowCallback(void *queryValuesVP, int columnCount, char **values, char **columnNames) {
	NSMutableArray *queryValues = (NSMutableArray *)queryValuesVP;
	NSMutableDictionary *individualQueryValues = [NSMutableDictionary dictionary];
	int i;
	for(i=0; i<columnCount; i++) {
		[individualQueryValues setObject:values[i] ? [NSString stringWithUTF8String:values[i]] : [NSNull null]
								  forKey:[NSString stringWithFormat:@"%s", columnNames[i]]];
	}
	[queryValues addObject:[NSDictionary dictionaryWithDictionary:individualQueryValues]];
	return 0;
}



+ (NSNumber *)executeSQL:(NSString *)sql withCallback:(void *)callbackFunction context:(id)contextObject {
// add @try here
    NSString *path = [GlobalMethods dataFilePathofDocuments:@"ProtocolPedia.db"];
    sqlite3 *db = NULL;
    int rc = SQLITE_OK;
    NSInteger lastRowId = 0;
    rc = sqlite3_open([path UTF8String], &db);
	
	// suggestion to prevent sqlite from caching your queries and slowly consuming all of your memory.	
	const char *pragmaSql = "PRAGMA cache_size = 50";
	if (sqlite3_exec(db, pragmaSql, NULL, NULL, NULL) != SQLITE_OK) {
		NSAssert1(0, @"Error: failed to execute pragma statement with message '%s'.", sqlite3_errmsg(db));
	}
	
	
    if(SQLITE_OK != rc) {
        NSLog(@"Can't open database: %s\n", sqlite3_errmsg(db));
        sqlite3_close(db);
        return nil;
    } else {
        char *zErrMsg = NULL;
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        rc = sqlite3_exec(db, [sql UTF8String], callbackFunction, (void*)contextObject, &zErrMsg);
        if(SQLITE_OK != rc) {
            NSLog(@"Can't run query '%@' error message: %s\n", sql, sqlite3_errmsg(db));
            sqlite3_free(zErrMsg);
        }
        lastRowId = sqlite3_last_insert_rowid(db);
        sqlite3_close(db);
        [pool release];
    }
    NSNumber *lastInsertRowId = nil;
    if(0 != lastRowId) {
        lastInsertRowId = [NSNumber numberWithInteger:lastRowId];
    }
    return lastInsertRowId;
}

+ (NSString *)selectOneValueSQL:(NSString *)sql {
    NSMutableDictionary *queryValues = [NSMutableDictionary dictionary];
    [self executeSQL:sql withCallback:singleRowCallback context:queryValues];
    NSString *value = nil;
    if([queryValues count] == 1) {
        value = [[queryValues objectEnumerator] nextObject];
    }
    return value;
}

+ (NSArray *)selectManyValuesWithSQL:(NSString *)sql {
    NSMutableArray *queryValues = [NSMutableArray array];
    [self executeSQL:sql withCallback:multipleRowCallback context:queryValues];
    NSMutableArray *values = [NSMutableArray array];
    for(NSDictionary *dict in queryValues) {
        [values addObject:[[dict objectEnumerator] nextObject]];
//		NSLog(@"%@", *nextObject);
    }
    return values;
}

+ (NSDictionary *)selectOneRowWithSQL:(NSString *)sql {
    NSMutableDictionary *queryValues = [NSMutableDictionary dictionary];
    [self executeSQL:sql withCallback:singleRowCallback context:queryValues];
    return [NSDictionary dictionaryWithDictionary:queryValues];    
}

+ (NSArray *)selectManyRowsWithSQL:(NSString *)sql {
    NSMutableArray *queryValues = [NSMutableArray array];
    [self executeSQL:sql withCallback:multipleRowCallback context:queryValues];
    return [NSArray arrayWithArray:queryValues];
}

+ (NSNumber *)insertWithSQL:(NSString *)sql {
    sql = [NSString stringWithFormat:@"BEGIN TRANSACTION; %@; COMMIT TRANSACTION;", sql];
//	NSLog(@"sql %@",sql);

    return [self executeSQL:sql withCallback:NULL context:NULL];
}

+ (void)updateWithSQL:(NSString *)sql {
    sql = [NSString stringWithFormat:@"BEGIN TRANSACTION; %@; COMMIT TRANSACTION;", sql];
    [self executeSQL:sql withCallback:NULL context:nil];
}

+ (void)deleteWithSQL:(NSString *)sql {
    sql = [NSString stringWithFormat:@"BEGIN TRANSACTION; %@; COMMIT TRANSACTION;", sql];
    [self executeSQL:sql withCallback:NULL context:nil];
}

@end
