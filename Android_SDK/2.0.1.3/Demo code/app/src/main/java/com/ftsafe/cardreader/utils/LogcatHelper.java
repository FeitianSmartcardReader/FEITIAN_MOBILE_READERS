package com.ftsafe.cardreader.utils;

import android.content.Context;
import android.os.Environment;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.Date;
import java.text.SimpleDateFormat;

public class LogcatHelper {

    private static LogcatHelper INSTANCE = null;
    private static String PATH_LOGCAT;
    private LogDumper mLogDumper = null;
    private int mPId;
    private String FilePath;

    /**
     *
     * Initialize the directory
     *
     * */
    public void init(Context context) {
        if (Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED)) {// Save to SD card if mounted
            File file = Environment.getExternalStorageDirectory();
            PATH_LOGCAT = file.getAbsolutePath() + File.separator + "Download/" + File.separator + "LogFiles/";
        } else {// Save to App dir if SD card absent
            PATH_LOGCAT = context.getFilesDir().getAbsolutePath()
                    + File.separator + "Download/" + File.separator + "LogFiles/";
        }
        File file = new File(PATH_LOGCAT);
        if (!file.exists()) {
            file.mkdirs();
        }

    }

    public static LogcatHelper getInstance(Context context) {
        if (INSTANCE == null) {
            INSTANCE = new LogcatHelper(context);
        }
        return INSTANCE;
    }

    private LogcatHelper(Context context) {
        init(context);
        mPId = android.os.Process.myPid();
    }

    public void start() {
        if (mLogDumper == null)
            mLogDumper = new LogDumper(String.valueOf(mPId), PATH_LOGCAT);
        mLogDumper.start();
    }

    public void stop() {
        if (mLogDumper != null) {
            mLogDumper.stopLogs();
            mLogDumper = null;
        }
    }

    private class LogDumper extends Thread {

        private Process logcatProc;
        private BufferedReader mReader = null;
        private boolean mRunning = true;
        String cmds = null;
        private String mPID;
        private FileOutputStream out = null;

        public LogDumper(String pid, String dir) {
            mPID = pid;
            try {
                FilePath ="log-" + getFileName() + ".txt";
                out = new FileOutputStream(new File(dir, FilePath));
                FilePath = dir+FilePath;
            } catch (FileNotFoundException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }

            /**
             *
             * Log level：*:v , *:d , *:w , *:e , *:f , *:s
             *
             * show E level and W level log of current mPID program.
             *
             * */

            // cmds = "logcat *:e *:w | grep \"(" + mPID + ")\"";
            // cmds = "logcat  | grep \"(" + mPID + ")\""; //print all log about mPID
            // cmds = "logcat -s way";	//print log filted by label
//            cmds = "logcat *:e *:i | grep \"(" + mPID + ")\"";
//            cmds = "logcat *:e | grep \"(" + mPID + ")\""; // Only print E level log
            cmds = "logcat -s FTSafe"; // print log filted by label

        }

        public void stopLogs() {
            mRunning = false;
        }

        @Override
        public void run() {
            try {
                logcatProc = Runtime.getRuntime().exec(cmds);
                mReader = new BufferedReader(new InputStreamReader(
                        logcatProc.getInputStream()), 1024);
                String line = null;
                while (mRunning && (line = mReader.readLine()) != null) {
                    if (!mRunning) {
                        break;
                    }
                    if (line.length() == 0) {
                        continue;
                    }
                    if (out != null && line.contains(mPID)) {
                        out.write((line + "\n").getBytes());
                    }
                }

            } catch (IOException e) {
                e.printStackTrace();
            } finally {
                if (logcatProc != null) {
                    logcatProc.destroy();
                    logcatProc = null;
                }
                if (mReader != null) {
                    try {
                        mReader.close();
                        mReader = null;
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
                if (out != null) {
                    try {
                        out.close();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                    out = null;
                }

            }

        }

    }
        public  String getFileName() {
            SimpleDateFormat format = new SimpleDateFormat("yyyyMMddHHmmss");// HH:mm:ss
//            SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
            String date = format.format(new Date(System.currentTimeMillis()));
            return date;// 2012-10-03 23:41:31
        }

        public String getFilePath(){
            if (FilePath != null){
                return FilePath;
            }else {
                return null;
            }
        }

//        public  String getDateEN() {
//            SimpleDateFormat format1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
//            String date1 = format1.format(new Date(System.currentTimeMillis()));
//            return date1;// 2012-10-03 23:41:31
//        }
}