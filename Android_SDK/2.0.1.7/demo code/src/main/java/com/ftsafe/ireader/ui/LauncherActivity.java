package com.ftsafe.ireader.ui;

import android.Manifest;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.os.StrictMode;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.appcompat.app.AppCompatActivity;

import com.ftsafe.ireader.R;
import com.ftsafe.ireader.utils.LogcatHelper;

import java.util.ArrayList;
import java.util.List;

 @RequiresApi(api = Build.VERSION_CODES.S)
public class LauncherActivity extends AppCompatActivity {

    private static final int LAUNCHER = 10001;
    public static LogcatHelper logcatHelper;

//    private List<String> requestList = new ArrayList<>();
    private static final int REQUEST_BLUETOOTH_PERMISSIONS = 100;
//    private List<String> missingPermissions = new ArrayList<>();

//     // 通用权限（全版本需要）
//     private static final String[] BASE_PERMISSIONS = {
//             Manifest.permission.BLUETOOTH,
//             Manifest.permission.BLUETOOTH_ADMIN, // API < 31需要
//     };
//
//     // API 31+ 替代 BLUETOOTH_ADMIN 的细粒度权限
//     private static final String[] BLUETOOTH_FINE_PERMISSIONS = {
//             Manifest.permission.BLUETOOTH_SCAN,
//             Manifest.permission.BLUETOOTH_CONNECT
//     };

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
//        requestPermission();
        checkBluetoothPermissions();
//        checkStoragePermissions();
    }

//    private void requestPermission() {
//        //发送邮件用到的文件需要加着一句话，否则会报android.os.FileUriExposedException异常
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
//            StrictMode.VmPolicy.Builder builder = new StrictMode.VmPolicy.Builder();
//            StrictMode.setVmPolicy( builder.build() );
//        }
//        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && Build.VERSION.SDK_INT < Build.VERSION_CODES.S){
//            PackageManager pm = getPackageManager();
//            if (pm.checkPermission(Manifest.permission.ACCESS_COARSE_LOCATION, getPackageName()) == PackageManager.PERMISSION_DENIED
//                    || pm.checkPermission(Manifest.permission.ACCESS_FINE_LOCATION, getPackageName()) == PackageManager.PERMISSION_DENIED
//                    || pm.checkPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE, getPackageName()) == PackageManager.PERMISSION_DENIED
//                    || pm.checkPermission(Manifest.permission.READ_EXTERNAL_STORAGE, getPackageName()) == PackageManager.PERMISSION_DENIED
//                    || pm.checkPermission(Manifest.permission.BLUETOOTH, getPackageName()) == PackageManager.PERMISSION_DENIED) {
//                requestPermissions(new String[]{
//                        Manifest.permission.ACCESS_COARSE_LOCATION,
//                        Manifest.permission.ACCESS_FINE_LOCATION,
//                        Manifest.permission.WRITE_EXTERNAL_STORAGE,
//                        Manifest.permission.READ_EXTERNAL_STORAGE,
//                        Manifest.permission.BLUETOOTH
//                }, REQUEST_PERMISSION_CODE);
//            }else {
//                logcatHelper = LogcatHelper.getInstance(this);
//                logcatHelper.start();
//                mHandler.sendEmptyMessageDelayed(LAUNCHER, 1000);
//            }
//        } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S){
//            PackageManager pm = getPackageManager();
//            if (
//            pm.checkPermission(Manifest.permission.ACCESS_COARSE_LOCATION, getPackageName()) == PackageManager.PERMISSION_DENIED
//                    || pm.checkPermission(Manifest.permission.ACCESS_FINE_LOCATION, getPackageName()) == PackageManager.PERMISSION_DENIED
//                    || pm.checkPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE, getPackageName()) == PackageManager.PERMISSION_DENIED
//                    || pm.checkPermission(Manifest.permission.READ_EXTERNAL_STORAGE, getPackageName()) == PackageManager.PERMISSION_DENIED
//                    || pm.checkPermission(Manifest.permission.BLUETOOTH, getPackageName()) == PackageManager.PERMISSION_DENIED
//                    || pm.checkPermission(Manifest.permission.BLUETOOTH_SCAN, getPackageName()) == PackageManager.PERMISSION_DENIED
//                    || pm.checkPermission(Manifest.permission.BLUETOOTH_CONNECT, getPackageName()) == PackageManager.PERMISSION_DENIED
//                    || pm.checkPermission(Manifest.permission.BLUETOOTH_ADVERTISE, getPackageName()) == PackageManager.PERMISSION_DENIED
//            ) {
//                requestPermissions(new String[]{
//                        Manifest.permission.ACCESS_COARSE_LOCATION,
//                        Manifest.permission.ACCESS_FINE_LOCATION,
//                        Manifest.permission.WRITE_EXTERNAL_STORAGE,
//                        Manifest.permission.READ_EXTERNAL_STORAGE,
//                        Manifest.permission.BLUETOOTH,
//                        Manifest.permission.BLUETOOTH_SCAN,
//                        Manifest.permission.BLUETOOTH_CONNECT,
//                        Manifest.permission.BLUETOOTH_ADVERTISE
//                }, REQUEST_PERMISSION_CODE);
//            } else {
//                logcatHelper = LogcatHelper.getInstance(this);
//                logcatHelper.start();
//                mHandler.sendEmptyMessageDelayed(LAUNCHER, 1000);
//            }
//        }
//    }

//     private List<String> getRequiredPermissions() {
//         List<String> permissions = new ArrayList<>();
//
//         if (Build.VERSION.SDK_INT <= Build.VERSION_CODES.R) {
//             permissions.addAll(Arrays.asList(BASE_PERMISSIONS));
//             permissions.add(Manifest.permission.ACCESS_FINE_LOCATION);
//         }
//
//         // API 31+ 替换为细粒度蓝牙权限
//         if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
//             permissions.remove(Manifest.permission.BLUETOOTH); // 移除旧权限
//             permissions.remove(Manifest.permission.BLUETOOTH_ADMIN); // 移除旧权限
////             permissions.remove(Manifest.permission.ACCESS_FINE_LOCATION); // 移除旧权限
//             permissions.addAll(Arrays.asList(BLUETOOTH_FINE_PERMISSIONS));
//         }
//
//         // 存储权限（仅API ≤ 28且日志存公共目录时需要）
//         if (Build.VERSION.SDK_INT <= Build.VERSION_CODES.P) {
//             permissions.add(STORAGE_PERMISSION);
//         }
//
//         // 过滤已授权的权限
//         List<String> missingPermissions = new ArrayList<>();
//         for (String perm : permissions) {
//             if (checkSelfPermission(perm) != PackageManager.PERMISSION_GRANTED) {
//                 missingPermissions.add(perm);
//             }
//         }
//
//         return missingPermissions;
//     }

     private void checkBluetoothPermissions() {

         //发送邮件用到的文件需要加着一句话，否则会报android.os.FileUriExposedException异常
         if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
             StrictMode.VmPolicy.Builder builder = new StrictMode.VmPolicy.Builder();
             StrictMode.setVmPolicy( builder.build() );
         }
//         checkManageAllFilesAccessPermission();

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
//         // 所有权限都已授予，执行蓝牙操作
//         BluetoothAdapter bluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
//         if (bluetoothAdapter == null) {
//             // 设备不支持蓝牙
//             return;
//         }
//         if (!bluetoothAdapter.isEnabled()) {
//             // 可选：请求打开蓝牙
//         }
//         // 执行蓝牙扫描/连接等操作
         startLogcatAndLauncher();
     }

     private void handlePermissionDenied() {
         // 处理权限被拒绝的情况（例如显示提示或关闭功能）
         // 提示用户权限被拒绝
//                 Toast.makeText(this, "需要权限以使用全部功能", Toast.LENGTH_SHORT).show();
//         Log.e("Permission::::::::::", "权限申请失败: " + String.join(", ", permissions));
         showExitDialog();
     }

//     private void checkStoragePermissions() {
//                  // 存储权限（仅API ≤ 28且日志存公共目录时需要）
//
//
//
//     }

////     private List<String> getMissingPermissions() {
////         List<String> missing = new ArrayList<>();
//         // 添加通用和版本特定权限检查逻辑（同checkPermissions方法）
//         return missingPermissions;
//     }

//     private boolean checkPermissions() {
//         List<String> deniedPermissions = new ArrayList<>();
//         // 通用权限（所有版本需要）
//         String[] commonPerms = {
//                 Manifest.permission.ACCESS_FINE_LOCATION,
//                 Manifest.permission.BLUETOOTH // 旧版本可能需要
//         };
//         for (String perm : commonPerms) {
//             if (checkSelfPermission(perm) != PackageManager.PERMISSION_GRANTED) {
//                 deniedPermissions.add(perm);
//             }
//         }
//         // 版本特定权限
//         if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
//             // 定位组COARSE（可选）
//             if (checkSelfPermission(Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
//                 deniedPermissions.add(Manifest.permission.ACCESS_COARSE_LOCATION);
//             }
//         }
//         if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
//             // 存储权限（按需）
//             if (checkSelfPermission(Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
//                 deniedPermissions.add(Manifest.permission.READ_EXTERNAL_STORAGE);
//             }
//         }
//         if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
//             // 蓝牙细粒度权限
//             String[] bluetoothPerms = {
//                     Manifest.permission.BLUETOOTH_SCAN,
//                     Manifest.permission.BLUETOOTH_CONNECT
//             };
//             for (String perm : bluetoothPerms) {
//                 if (checkSelfPermission(perm) != PackageManager.PERMISSION_GRANTED) {
//                     deniedPermissions.add(perm);
//                 }
//             }
//         }
//         missingPermissions = deniedPermissions;
//         return deniedPermissions.isEmpty();
//     }

//     @Override
//     public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
//         super.onRequestPermissionsResult(requestCode, permissions, grantResults);
//         if (requestCode == REQUEST_PERMISSION_CODE && grantResults.length > 0) {
//             boolean allGranted = true;
//             for (int result : grantResults) {
//                 if (result != PackageManager.PERMISSION_GRANTED) {
//                     allGranted = false;
//                     break;
//                 }
//             }
//             if (allGranted) {
//                 startLogcatAndLauncher();
//             } else {
//                 // 提示用户权限被拒绝
////                 Toast.makeText(this, "需要权限以使用全部功能", Toast.LENGTH_SHORT).show();
//                Log.e("Permission::::::::::", "权限申请失败: " + String.join(", ", permissions));
//                showExitDialog();
//             }
//         }
//     }

     private void startLogcatAndLauncher() {
         logcatHelper = LogcatHelper.getInstance(this);
         logcatHelper.start();
         mHandler.sendEmptyMessageDelayed(LAUNCHER, 1000);
     }
//
//    @Override
//    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
//        if (requestCode == REQUEST_PERMISSION_CODE) {
//            if (grantResults.length > 0) {
//                boolean permissionAllowed = true;
//                for (int grantResult : grantResults) {
//                    if (grantResult == PackageManager.PERMISSION_DENIED) {
//                        permissionAllowed = false;
//                        break;
//                    }
//                }
//                if (permissionAllowed) {
//                    // 创建一个 Handler 对象
//                    logcatHelper = LogcatHelper.getInstance(this);
//                    logcatHelper.start();
//                    mHandler.sendEmptyMessageDelayed(LAUNCHER, 1000);
//                } else {
//                    Log.e("Permission::::::::::", "权限申请失败: " + String.join(", ", permissions));
//                    showExitDialog();
//                }
//            }
//            return;
//        }
//    }

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

     // 跳转至设置页面，让用户手动开启
//     private void checkManageAllFilesAccessPermission() {
//         if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
//             if (!Environment.isExternalStorageManager()) {
//                 Intent intent = new Intent(
//                         Settings.ACTION_MANAGE_APP_ALL_FILES_ACCESS_PERMISSION);
//                 intent.setData(Uri.parse("package:" + getPackageName()));
//                 startActivity(intent);
//             }
//         }
//     }
}
