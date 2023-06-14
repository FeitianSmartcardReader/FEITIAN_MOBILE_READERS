package com.ftsafe.cardreader.ui;

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

import com.ftsafe.cardreader.R;
import com.ftsafe.cardreader.utils.LogcatHelper;

import java.util.ArrayList;
import java.util.List;

@RequiresApi(api = Build.VERSION_CODES.S)
public class LauncherActivity extends AppCompatActivity {

    private static final int LAUNCHER = 10001;

    public static LogcatHelper logcatHelper;

    private List<String> requestList = new ArrayList<>();
    private final int REQUEST_PERMISSION_CODE = 1;
    private final String[] permissions = {
            Manifest.permission.ACCESS_COARSE_LOCATION,
            Manifest.permission.ACCESS_FINE_LOCATION,
            Manifest.permission.WRITE_EXTERNAL_STORAGE,
            Manifest.permission.READ_EXTERNAL_STORAGE
    };
    private final String[] permissions_12 = {
            Manifest.permission.ACCESS_COARSE_LOCATION,
            Manifest.permission.ACCESS_FINE_LOCATION,
            Manifest.permission.WRITE_EXTERNAL_STORAGE,
            Manifest.permission.READ_EXTERNAL_STORAGE,
            Manifest.permission.BLUETOOTH_SCAN,
            Manifest.permission.BLUETOOTH_CONNECT,
            Manifest.permission.BLUETOOTH_ADVERTISE
    };

    private Handler mHandler = new Handler(){
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
        requestPermission();
    }

    private void requestPermission() {
        // The email file to be sent need add a new line, 
		// or else "android.os.FileUriExposedException" exception will be generated
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            StrictMode.VmPolicy.Builder builder = new StrictMode.VmPolicy.Builder();
            StrictMode.setVmPolicy( builder.build() );
        }
        if(Build.VERSION.SDK_INT >= 23 && Build.VERSION.SDK_INT < Build.VERSION_CODES.S){
            PackageManager pm = getPackageManager();
            if (pm.checkPermission(Manifest.permission.ACCESS_COARSE_LOCATION, getPackageName())
                    == PackageManager.PERMISSION_DENIED || pm.checkPermission(Manifest.permission.ACCESS_FINE_LOCATION, getPackageName())
                    == PackageManager.PERMISSION_DENIED || pm.checkPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE, getPackageName())
                    == PackageManager.PERMISSION_DENIED || pm.checkPermission(Manifest.permission.READ_EXTERNAL_STORAGE, getPackageName())
                    == PackageManager.PERMISSION_DENIED) {
                requestPermissions(permissions, REQUEST_PERMISSION_CODE);
            }else {
                logcatHelper = LogcatHelper.getInstance(this);
                logcatHelper.start();
                mHandler.sendEmptyMessageDelayed(LAUNCHER, 1000);
            }
        }
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.S){
            PackageManager pm = getPackageManager();
            if (pm.checkPermission(Manifest.permission.ACCESS_COARSE_LOCATION, getPackageName())
                    == PackageManager.PERMISSION_DENIED || pm.checkPermission(Manifest.permission.ACCESS_FINE_LOCATION, getPackageName())
                    == PackageManager.PERMISSION_DENIED || pm.checkPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE, getPackageName())
                    == PackageManager.PERMISSION_DENIED || pm.checkPermission(Manifest.permission.READ_EXTERNAL_STORAGE, getPackageName())
                    == PackageManager.PERMISSION_DENIED || pm.checkPermission(Manifest.permission.BLUETOOTH_SCAN, getPackageName())
                    == PackageManager.PERMISSION_DENIED || pm.checkPermission(Manifest.permission.BLUETOOTH_CONNECT, getPackageName())
                    == PackageManager.PERMISSION_DENIED || pm.checkPermission(Manifest.permission.BLUETOOTH_ADVERTISE, getPackageName())
                     == PackageManager.PERMISSION_DENIED) {
                requestPermissions(permissions_12, REQUEST_PERMISSION_CODE);
            }else {
                logcatHelper = LogcatHelper.getInstance(this);
                logcatHelper.start();
                mHandler.sendEmptyMessageDelayed(LAUNCHER, 1000);
            }
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String permissions[], @NonNull int[] grantResults) {
        switch (requestCode) {
            case REQUEST_PERMISSION_CODE: {
                if (grantResults.length > 0){
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S){
                        if(grantResults[0] == PackageManager.PERMISSION_DENIED || grantResults[1] == PackageManager.PERMISSION_DENIED || grantResults[2] == PackageManager.PERMISSION_DENIED || grantResults[3] == PackageManager.PERMISSION_DENIED || grantResults[4] == PackageManager.PERMISSION_DENIED || grantResults[5] == PackageManager.PERMISSION_DENIED || grantResults[6] == PackageManager.PERMISSION_DENIED) {
                            showExitDialog();
                        }else {
                            logcatHelper = LogcatHelper.getInstance(this);
                            logcatHelper.start();
                            mHandler.sendEmptyMessageDelayed(LAUNCHER, 1000);
                        }
                    }else{
                        if(grantResults[0] == PackageManager.PERMISSION_DENIED || grantResults[1] == PackageManager.PERMISSION_DENIED || grantResults[2] == PackageManager.PERMISSION_DENIED || grantResults[3] == PackageManager.PERMISSION_DENIED) {
                            showExitDialog();
                        }else {
                            logcatHelper = LogcatHelper.getInstance(this);
                            logcatHelper.start();
                            mHandler.sendEmptyMessageDelayed(LAUNCHER, 1000);
                        }
                    }
                }
                return;
            }
        }
    }

    private void showExitDialog(){
        new AlertDialog.Builder(this)
                .setMessage("The permission is not allowed, please restart the application and choose to allow the permission or manually set the permission, otherwise the program cannot be used normally and will exit soon！")
                .setPositiveButton("OK", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        System.exit(0);
                    }
                })
                .show();
    }




    /**
     * Disable back button
     */
    @Override
    public void onBackPressed() {
    }
}
