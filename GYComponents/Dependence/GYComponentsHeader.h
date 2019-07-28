//
//  GYComponentsHeader.h
//  GYComponents
//
//  Created by 高洋 on 2019/7/28.
//

#ifndef GYComponentsHeader_h
#define GYComponentsHeader_h

/** frome YYKit!
 
 Add this macro before each category implementation, so we don't have to use
 -all_load or -force_load to load object files from static libraries that only
 contain categories and no classes.
 More info: http://developer.apple.com/library/mac/#qa/qa2006/qa1490.html .
 *******************************************************************************
 Example:
 GYSYNTH_DUMMY_CLASS(NSString_GYAdd)
 */
#ifndef GYSYNTH_DUMMY_CLASS
#define GYSYNTH_DUMMY_CLASS(_name_) \
@interface GYSYNTH_DUMMY_CLASS_ ## _name_ : NSObject @end \
@implementation GYSYNTH_DUMMY_CLASS_ ## _name_ @end
#endif


#endif /* GYComponentsHeader_h */
