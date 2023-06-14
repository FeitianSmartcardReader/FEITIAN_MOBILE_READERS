package com.ftsafe.cardreader.utils;

import android.app.Activity;
import android.util.Log;

import java.util.ArrayList;
import java.util.List;

public class ActivityUtil {
    private static List<Activity> activityList = new ArrayList<>();

    public static void addActivity(Activity activity){
        Log.e("ActivityFinishUtil","addActivity:::::::::::::::"+activity);
        activityList.add(activity);
    }

    public static void removeActivity(Activity activity){
        activityList.remove(activity);
    }

    public static void finishOtherAllActivity(Activity activity){
        Log.e("ActivityFinishUtil","Kill all other Activities ！！！！！！！！！！！！！！:"+activityList.size());
//            Iterator<Activity> iterator = activityList.iterator();
//            while (iterator.hasNext()) {
//                Activity item = iterator.next();
//                Log.e("ActivityFinishUtil","finishOtherAllActivity:::::::::::::::"+item);
//                if (item != activity) {
//                    item.finish();
//                    activityList.remove(item);
//                }
//            }
        for (int i = 0; i<activityList.size();i++){
            Log.e("ActivityFinishUtil","finishOtherAllActivity:::::::::::::::"+activityList.get(i));
            Log.e("ActivityFinishUtil","finishOtherAllActivity:::::::::::::::"+(activityList.get(i) == activity));
            if (activityList.get(i) == activity){
                continue;
            }
            activityList.get(i).finish();
            activityList.remove(activityList.get(i));
            i--;
        }
//        activityList.clear();
//        activityList.add(activity);
    }

    public static void finishAllActivity(){
        for (Activity item : activityList){
            item.finish();
        }
    }

}