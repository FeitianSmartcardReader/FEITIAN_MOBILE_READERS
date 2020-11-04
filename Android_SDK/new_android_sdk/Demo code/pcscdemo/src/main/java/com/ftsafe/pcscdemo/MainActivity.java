package com.ftsafe.pcscdemo;

import android.Manifest;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.AutoCompleteTextView;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.Toast;

import com.ftsafe.Utility;
import com.ftsafe.comm.StrUtil;

import java.util.ArrayList;
import java.util.List;

import androidx.annotation.RequiresApi;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;

public class MainActivity extends AppCompatActivity implements View.OnClickListener {
    private EditText etControl;
    ProgressDialog progressDialog;

    private final int REQUEST_PERMISSION_CODE = 1;
    private final String[] permissions = {
            Manifest.permission.ACCESS_COARSE_LOCATION
    };

    static List<String> mResultList;
    static ArrayAdapter<String> mAdapterResult;
    static ListView lvResult;
    AutoCompleteTextView autoCompleteTextView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        PCSCNative.FT_Init();

        if(Build.VERSION.SDK_INT >= 23){
            PackageManager pm = getPackageManager();
            if (pm.checkPermission(Manifest.permission.ACCESS_COARSE_LOCATION, getPackageName())
                    == PackageManager.PERMISSION_DENIED) {
                requestPermissions(permissions, REQUEST_PERMISSION_CODE);
            }
        }

        lvResult = findViewById(R.id.lv_result);
        mResultList = new ArrayList<>();
        mAdapterResult = new ArrayAdapter<>(this, R.layout.lv_item, mResultList);
        lvResult.setAdapter(mAdapterResult);

        autoCompleteTextView = findViewById(R.id.auto_et_transmit_commond);
        ArrayAdapter<String> xfrCommondAdapter = new ArrayAdapter<>(
                this, android.R.layout.simple_list_item_1,
                getResources().getStringArray(R.array.transmit_command));
        autoCompleteTextView.setAdapter(xfrCommondAdapter);

        progressDialog = new ProgressDialog(this);
        progressDialog.setCancelable(false);
        progressDialog.setProgressStyle(ProgressDialog.STYLE_SPINNER);

        etControl = findViewById(R.id.et_control);
        autoCompleteTextView.setOnClickListener(this);
        autoCompleteTextView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                InputMethodManager in = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
                in.hideSoftInputFromWindow(view.getApplicationWindowToken(), 0);
            }
        });
        findViewById(R.id.btn_init).setOnClickListener(this);
        findViewById(R.id.btn_establish).setOnClickListener(this);
        findViewById(R.id.btn_release).setOnClickListener(this);
        findViewById(R.id.btn_isvalid).setOnClickListener(this);
        findViewById(R.id.btn_connect).setOnClickListener(this);
        findViewById(R.id.btn_disconnect).setOnClickListener(this);
        findViewById(R.id.btn_begin_transaction).setOnClickListener(this);
        findViewById(R.id.btn_end_transaction).setOnClickListener(this);
        findViewById(R.id.btn_status).setOnClickListener(this);
        findViewById(R.id.btn_get_status_change).setOnClickListener(this);
        findViewById(R.id.btn_control).setOnClickListener(this);
        findViewById(R.id.btn_transmit).setOnClickListener(this);
        findViewById(R.id.btn_list_reader_groups).setOnClickListener(this);
        findViewById(R.id.btn_list_readers).setOnClickListener(this);
        findViewById(R.id.btn_cancel).setOnClickListener(this);
        findViewById(R.id.btn_reconnect).setOnClickListener(this);
        findViewById(R.id.btn_getattrib).setOnClickListener(this);
        findViewById(R.id.btn_clear).setOnClickListener(this);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        PCSCNative.FT_UnInit();
    }

    @RequiresApi(api = Build.VERSION_CODES.M)
    public void onRequestPermissionsResult(int requestCode,
                                           String[] permissions, int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);

        boolean permissionRefused = false;
        boolean requestPermissionRationale = false;

        for(int i = 0; i < grantResults.length; i ++){
            if(grantResults[i] == PackageManager.PERMISSION_DENIED){
                permissionRefused = true;
                break;
            }
        }
        for(int i = 0; i < permissions.length; i ++){
            if(shouldShowRequestPermissionRationale(permissions[i])){
                requestPermissionRationale = true;
                break;
            }
        }
        if(permissionRefused){
            if(requestPermissionRationale){
                requestPermissions(permissions, REQUEST_PERMISSION_CODE);
            }else{
                Toast.makeText(this, "You have denied permission to apply, please give permission in the system settings.", Toast.LENGTH_SHORT).show();
            }
        }else{
            Toast.makeText(this, "Permissions are allowed.", Toast.LENGTH_SHORT).show();
        }
    }

    @Override
    public void onClick(View v) {
        int ret = 0;
        switch (v.getId()){
            case R.id.auto_et_transmit_commond:
                autoCompleteTextView.setText("0");
                autoCompleteTextView.setText("");
                break;
            case R.id.btn_init:
                PCSCNative.FT_Init();
                break;
            case R.id.btn_establish:
                ret = PCSCNative.SCardEstablishContext();
                showMessage("Establish context ret : 0x" + Integer.toHexString(ret));
                break;
            case R.id.btn_release:
                ret = PCSCNative.SCardReleaseContext();
                showMessage("Release context ret : 0x" + Integer.toHexString(ret));
                break;
            case R.id.btn_isvalid:
                ret = PCSCNative.SCardIsValidContext();
                showMessage("Scard context " + ((ret==0)?"is":"is not") + " valid.");
                break;
            case R.id.btn_connect:
                connect();
                break;
            case R.id.btn_disconnect:
                ret = PCSCNative.SCardDisconnect();
                showMessage("disconnect ret : 0x" + Integer.toHexString(ret));
                break;
            case R.id.btn_begin_transaction:
                ret = PCSCNative.SCardBeginTransaction();
                showMessage("begin transaction ret : 0x" + Integer.toHexString(ret));
                break;
            case R.id.btn_end_transaction:
                ret = PCSCNative.SCardEndTransaction();
                showMessage("end transaction ret : 0x" + Integer.toHexString(ret));
                break;
            case R.id.btn_status:
                cardStatus();
                break;
            case R.id.btn_get_status_change:
                cardStatusChange();
                break;
            case R.id.btn_control:
                control();
                break;
            case R.id.btn_transmit:
                transmit();
                break;
            case R.id.btn_list_reader_groups:
                ret = PCSCNative.SCardListReaderGroups();
                showMessage("list reader group ret : 0x" + Integer.toHexString(ret));
                break;
            case R.id.btn_list_readers:
//                PCSCNative.SCardListReaders();
                break;
            case R.id.btn_cancel:
                ret = PCSCNative.SCardCancel();
                showMessage("cancel ret : 0x" + Integer.toHexString(ret));
                break;
            case R.id.btn_reconnect:
                ret = PCSCNative.SCardReconnect();
                showMessage("reconnect ret : 0x" + Integer.toHexString(ret));
                break;
            case R.id.btn_getattrib:
                getAttrib();
                break;
            case R.id.btn_clear:
                mResultList.clear();
                mAdapterResult.notifyDataSetChanged();
                break;
        }
    }

    void connect(){
        showLoading(true);
        new Thread(new Runnable() {
            @Override
            public void run() {
                byte[] readerNames = new byte[1024];
                int ret = PCSCNative.SCardListReaders(readerNames);
                showLoading(false);
                if(ret != 0){
                    showMessage("list readers ret : 0x" + Integer.toHexString(ret));
                    return;
                }
                final String[] readers = new String(readerNames).split("\0");
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        new AlertDialog.Builder(MainActivity.this).setSingleChoiceItems(readers, 0, new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(final DialogInterface dialog, final int which) {
                                dialog.cancel();
                                showLoading(true);
                                new Thread(new Runnable() {
                                    @Override
                                    public void run() {
                                        int re = PCSCNative.SCardConnect(readers[which].getBytes());
                                        showMessage("connect ret : 0x" + Integer.toHexString(re));
                                        showLoading(false);
                                    }
                                }).start();
                            }
                        }).create().show();
                    }
                });
            }
        }).start();
    }

    void cardStatus(){
        doInBackground(new Runnable() {
            @Override
            public void run() {
                int[] cardState = {0};
                int[] protocol = {0};
                byte[] atr = new byte[128];
                int[] atrLen = {128};
                int ret = PCSCNative.SCardStatus(cardState, protocol, atr, atrLen);
                if(ret != 0){
                    showMessage("scard status ret : 0x" + Integer.toHexString(ret));
                }else{
                    switch (cardState[0]){
                        case 2:
                            showMessage("card no present");
                            break;
                        case 4:
                            showMessage("card present and powered");
                            break;
                        case 8:
                            showMessage("card present and no powered");
                            break;
                        default:
                            showMessage("card error");
                            break;
                    }
                    switch (protocol[0]){
                        case 0:
                            showMessage("no protocol");
                            break;
                        case 1:
                            showMessage("card protocol T0");
                            break;
                        case 2:
                            showMessage("card protocol T1");
                            break;
                        default:
                            showMessage("protocol error");
                            break;
                    }
                    showMessage("atr : " + Utility.bytes2HexStr(atr, atrLen[0]));
                }
            }
        });
    }

    void cardStatusChange(){
        doInBackground(new Runnable() {
            @Override
            public void run() {
                int[] cardState = {0};
                byte[] atr = new byte[128];
                int[] atrLen = {128};
                int ret = PCSCNative.SCardGetStatusChange(cardState, atr, atrLen);
                if(ret != 0){
                    showMessage("scard status ret : 0x" + Integer.toHexString(ret));
                }else{
                    switch (cardState[0]){
                        case 0x10:
                            showMessage("card no present");
                            break;
                        case 0x20:
                            showMessage("card present");
                            break;
                        default:
                            showMessage("card error");
                            break;
                    }
                    showMessage("atr : " + Utility.bytes2HexStr(atr, atrLen[0]));
                }
            }
        });
    }

    void control(){
        doInBackground(new Runnable() {
            @Override
            public void run() {
                String sendStr = etControl.getText().toString();
                byte[] send = Utility.hexStrToBytes(sendStr);
                byte[] recv = new byte[1024];
                int[] recvLen = {1024};
                showMessage("control send : " + sendStr);
                int ret = PCSCNative.SCardControl(send, recv, recvLen);
                if(ret != 0){
                    showMessage("control ret : 0x" + Integer.toHexString(ret));
                }else{
                    showMessage("control recv : " + Utility.bytes2HexStr(recv, recvLen[0]));
                }
            }
        });
    }

    void transmit(){
        doInBackground(new Runnable() {
            @Override
            public void run() {
                String sendStr = autoCompleteTextView.getText().toString();
                byte[] send = Utility.hexStrToBytes(sendStr);
                int[] recvLen = {4096};
                byte[] recv = new byte[recvLen[0]];
                showMessage("transmit send : " + sendStr);
                int ret = PCSCNative.SCardTransmit(send, recv, recvLen);
                if(ret != 0){
                    showMessage("transmit ret : 0x" + Integer.toHexString(ret));
                }else{
                    if(recv[0] == 0x61){
                        showMessage("XFR recv : " + StrUtil.byteArr2HexStr(recv));
                        showMessage("XFR send : 00C00000" + StrUtil.byte2HexStr(recv[1]));
                        send = Utility.hexStrToBytes("00c00000" + StrUtil.byte2HexStr(recv[1]));
                        ret = PCSCNative.SCardTransmit(send, recv, recvLen);
                        if(ret != 0){
                            showMessage("transmit ret : 0x" + Integer.toHexString(ret));
                            return;
                        }
                    }
                    showMessage("transmit recv : " + Utility.bytes2HexStr(recv, recvLen[0]));
                }
            }
        });
    }

    void getAttrib(){
        doInBackground(new Runnable() {
            @Override
            public void run() {
                byte[] atr = new byte[128];
                int[] atrLen = {128};
                int ret = PCSCNative.SCardGetAttrib(atr, atrLen);
                if(ret != 0){
                    showMessage("scard get attrib ret : 0x" + Integer.toHexString(ret));
                }else{
                    showMessage("atr : " + Utility.bytes2HexStr(atr, atrLen[0]));
                }
            }
        });
    }

    public static void showState(int state){
        switch (state){
            case 0x11://USB_IN
                showMessage("USB IN");
                break;
            case 0x12://USB_OUT
                showMessage("USB OUT");
                break;
            case 0x100://CARD_IN
                showMessage("Slot0: CARD IN");
                break;
            case 0x200://CARD_OUT
                showMessage("Slot0: CARD OUT");
                break;
            case 0x101://CARD_IN
                showMessage("Slot1: CARD IN");
                break;
            case 0x201://CARD_OUT
                showMessage("Slot1: CARD OUT");
                break;
            case 0x72://BT3_DISCONNECT
                showMessage("BT3 DEVICE DISCONNECT");
                break;
            case 0x81:
                Log.e("pcsc", "bt4 scaned");
                break;
            case 0x82://BT4_DISCONNECT
                showMessage("BT4 DEVICE DISCONNECT");
                break;
            default:
                break;
        }
    }

    private static void showMessage(final String msg){
        lvResult.post(new Runnable() {
            @Override
            public void run() {
                mResultList.add(msg);
                mAdapterResult.notifyDataSetChanged();
            }
        });
    }

    private void doInBackground(final Runnable r){
        new Thread(new Runnable() {
            @Override
            public void run() {
                showLoading(true);
                r.run();
                showLoading(false);
            }
        }).start();
    }

    private void showLoading(final boolean show){
        lvResult.post(new Runnable() {
            @Override
            public void run() {
                if(show){
                    if(!progressDialog.isShowing()){
                        progressDialog.show();
                    }
                }else{
                    if(progressDialog.isShowing()){
                        progressDialog.dismiss();
                    }
                }
            }
        });
    }
}
