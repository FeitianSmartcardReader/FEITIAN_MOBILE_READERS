package com.ftsafe.cardreader.ui;

import android.Manifest;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Debug;
import android.os.Environment;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.os.StrictMode;
import android.provider.Settings;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.appcompat.app.AppCompatActivity;

import com.ftsafe.cardreader.R;
import com.ftsafe.cardreader.utils.LogcatHelper;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

 @RequiresApi(api = Build.VERSION_CODES.S)
public class LauncherActivity extends AppCompatActivity {

    private static final int LAUNCHER = 10001;
    public static LogcatHelper logcatHelper;

    private static final int REQUEST_BLUETOOTH_PERMISSIONS = 100;

     // 存储权限（仅API ≤ 28需要，若日志存公共目录）
     private static final String STORAGE_PERMISSION = Manifest.permission.WRITE_EXTERNAL_STORAGE;

     private final Handler mHandler = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what){
                case LAUNCHER:
                    startActivity(new Intent(LauncherActivity.this, ConnectActivity.class));
                    finish();
                    break;
            }
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_launcher);
        checkBluetoothPermissions();
    }

     private void checkBluetoothPermissions() {

         //发送邮件用到的文件需要加着一句话，否则会报android.os.FileUriExposedException异常
         if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
             StrictMode.VmPolicy.Builder builder = new StrictMode.VmPolicy.Builder();
             StrictMode.setVmPolicy( builder.build() );
         }

         final List<String> neededPermissions = new ArrayList<>();

         // 基础蓝牙权限（所有版本必需）
         if (checkSelfPermission(Manifest.permission.BLUETOOTH) != PackageManager.PERMISSION_GRANTED) {
             neededPermissions.add(Manifest.permission.BLUETOOTH);
         }

         if (checkSelfPermission(Manifest.permission.BLUETOOTH_ADMIN) != PackageManager.PERMISSION_GRANTED) {
             neededPermissions.add(Manifest.permission.BLUETOOTH_ADMIN);
         }

         // Android 12 (API 31) 及以上需要新权限
         if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
             if (checkSelfPermission(Manifest.permission.BLUETOOTH_CONNECT) != PackageManager.PERMISSION_GRANTED) {
                 neededPermissions.add(Manifest.permission.BLUETOOTH_CONNECT);
             }

             if (checkSelfPermission(Manifest.permission.BLUETOOTH_SCAN) != PackageManager.PERMISSION_GRANTED) {
                 neededPermissions.add(Manifest.permission.BLUETOOTH_SCAN);
             }
         }

         if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) { // Android 6-11 需要位置权限
             if (checkSelfPermission(Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
                 neededPermissions.add(Manifest.permission.ACCESS_COARSE_LOCATION);
             }

             if (checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
                 neededPermissions.add(Manifest.permission.ACCESS_FINE_LOCATION);
             }
         }

         if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) { // Android 9 (Pie) 及以上需要前台服务权限
             if (checkSelfPermission(Manifest.permission.FOREGROUND_SERVICE) != PackageManager.PERMISSION_GRANTED) {
                 neededPermissions.add(Manifest.permission.FOREGROUND_SERVICE);
             }
         }

         // 存储权限
         if (Build.VERSION.SDK_INT <= Build.VERSION_CODES.P) {
             if (checkSelfPermission(STORAGE_PERMISSION) != PackageManager.PERMISSION_GRANTED) {
                 neededPermissions.add(STORAGE_PERMISSION);
             }
         }

         if (!neededPermissions.isEmpty()) {
             requestPermissions( neededPermissions.toArray(new String[0]), REQUEST_BLUETOOTH_PERMISSIONS );
         } else {
             onBluetoothPermissionsGranted();
         }
     }

     @Override
     public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
         super.onRequestPermissionsResult(requestCode, permissions, grantResults);
         if (requestCode == REQUEST_BLUETOOTH_PERMISSIONS) {
             for (int result : grantResults) {
                 if (result != PackageManager.PERMISSION_GRANTED) {
                     // 处理权限被拒绝的情况
                     handlePermissionDenied();
                     return;
                 }
             }
             onBluetoothPermissionsGranted();
         }
     }

     private void onBluetoothPermissionsGranted() {
//         // 执行蓝牙扫描/连接等操作
         startLogcatAndLauncher();
     }

     private void handlePermissionDenied() {
         // 处理权限被拒绝的情况（例如显示提示或关闭功能）
         // 提示用户权限被拒绝
         showExitDialog();
     }

     private void startLogcatAndLauncher() {
         logcatHelper = LogcatHelper.getInstance(this);
         logcatHelper.start();
         mHandler.sendEmptyMessageDelayed(LAUNCHER, 1000);
     }

    private void showExitDialog(){
        new AlertDialog.Builder(this)
                .setMessage("The permission is not allowed, please restart the application and choose to allow the permission or manually set the permission, otherwise the program cannot be used normally and will exit soon！")            //权限未允许，请重启应用选择允许权限或手动设置权限，否则程序无法正常使用，即将退出！
                .setPositiveButton("OK", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        System.exit(0);
                    }
                })
                .show();
    }

    /**
     * 禁用返回键
     */
    @Override
    public void onBackPressed() {
    }

}
