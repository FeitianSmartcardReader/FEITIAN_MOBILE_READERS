package com.ftsafe.cardreader;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.ProgressDialog;
import android.bluetooth.BluetoothDevice;
import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.AutoCompleteTextView;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.Spinner;
import android.widget.Toast;

import com.ftsafe.DK;
import com.ftsafe.Utility;
import com.ftsafe.comm.StrUtil;
import com.ftsafe.readerScheme.FTException;
import com.ftsafe.readerScheme.FTReader;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import androidx.annotation.RequiresApi;

public class MainActivity extends Activity implements View.OnClickListener {
    FTReader mFtReader;
    Spinner spType, spDeviceName;
    EditText etEscape;
    AutoCompleteTextView autoCompleteTextView;
    SelectDeviceDialog deviceDialog;
    ProgressDialog progressDialog;
    int type = 0;//usb
    int slotIndex = 0;
    private long lastTimesFlag = 0;
    private final int REQUEST_PERMISSION_CODE = 1;
    private final String[] permissions = {
            Manifest.permission.ACCESS_COARSE_LOCATION
    };
    private String[] readerNames;

    List<String> mResultList;
    ArrayAdapter<String> mAdapterResult;
    private Handler uiHandler;
    ListView lvResult;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // Click the home button to restart the app
        if (!isTaskRoot()) {
            finish();
            return;
        }
        setContentView(R.layout.activity_main);

//        mFtReader = new FTReader(this, mHandler, DK.FTREADER_TYPE_USB);

        if(Build.VERSION.SDK_INT >= 23){
            PackageManager pm = getPackageManager();
            if (pm.checkPermission(Manifest.permission.ACCESS_COARSE_LOCATION, getPackageName())
                    == PackageManager.PERMISSION_DENIED) {
                requestPermissions(permissions, REQUEST_PERMISSION_CODE);
            }
        }

        etEscape = findViewById(R.id.et_escape);
        spType = findViewById(R.id.sp_type);
        spType.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                switch (position){
                    case 0:
                        if(type != 0){
                            try {
                                mFtReader.readerClose();
                            } catch (FTException e) {
                                e.printStackTrace();
                            }
                        }
                        mFtReader = new FTReader(MainActivity.this, mHandler, DK.FTREADER_TYPE_USB);
                        spDeviceName.setVisibility(View.VISIBLE);
                        break;
                    case 1:
                        if(type != 1){
                            try {
                                mFtReader.readerClose();
                            } catch (FTException e) {
                                e.printStackTrace();
                            }
                        }
                        mFtReader = new FTReader(MainActivity.this, mHandler, DK.FTREADER_TYPE_BT3);
                        deviceDialog = new SelectDeviceDialog(MainActivity.this, mFtReader, mSelectCallback);
                        spDeviceName.setVisibility(View.GONE);
                        break;
                    case 2:
                        if(type != 2){
                            try {
                                mFtReader.readerClose();
                            } catch (FTException e) {
                                e.printStackTrace();
                            }
                        }
                        mFtReader = new FTReader(MainActivity.this, mHandler, DK.FTREADER_TYPE_BT4);
                        deviceDialog = new SelectDeviceDialog(MainActivity.this, mFtReader, mSelectCallback);
                        spDeviceName.setVisibility(View.GONE);
                        break;
                    default:
                        break;
                }
                type = position;
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {
            }
        });

        spDeviceName = findViewById(R.id.sp_device_name);
        spDeviceName.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                if(readerNames != null && readerNames.length > position){
                    try {
                        mFtReader.readerOpen(readerNames[position]);
                    } catch (FTException e) {
                        e.printStackTrace();
                    }
                }
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {
            }
        });

        lvResult = findViewById(R.id.lv_result);
        mResultList = new ArrayList<>();
        mAdapterResult = new ArrayAdapter<>(this, R.layout.lv_item, mResultList);
        lvResult.setAdapter(mAdapterResult);

        autoCompleteTextView = findViewById(R.id.auto_et_xfr_commond);
        ArrayAdapter<String> xfrCommondAdapter = new ArrayAdapter<>(
                this, android.R.layout.simple_list_item_1,
                getResources().getStringArray(R.array.xfr_command));
        autoCompleteTextView.setAdapter(xfrCommondAdapter);

        progressDialog = new ProgressDialog(this);
        progressDialog.setCancelable(false);
        progressDialog.setProgressStyle(ProgressDialog.STYLE_SPINNER);

        autoCompleteTextView.setOnClickListener(this);
        autoCompleteTextView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                InputMethodManager in = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
                in.hideSoftInputFromWindow(view.getApplicationWindowToken(), 0);
            }
        });
        findViewById(R.id.btn_finder).setOnClickListener(this);
        findViewById(R.id.btn_open).setOnClickListener(this);
        findViewById(R.id.btn_close).setOnClickListener(this);
        findViewById(R.id.btn_poweron).setOnClickListener(this);
        findViewById(R.id.btn_poweroff).setOnClickListener(this);
        findViewById(R.id.btn_readerxfr).setOnClickListener(this);
        findViewById(R.id.btn_readerescape).setOnClickListener(this);
        findViewById(R.id.btn_getslotstatus).setOnClickListener(this);
        findViewById(R.id.btn_getsn).setOnClickListener(this);
        findViewById(R.id.btn_getdevtype).setOnClickListener(this);
        findViewById(R.id.btn_getfirmversion).setOnClickListener(this);
        findViewById(R.id.btn_getuid).setOnClickListener(this);
        findViewById(R.id.btn_getmanufacturer).setOnClickListener(this);
        findViewById(R.id.btn_gethardwareinfo).setOnClickListener(this);
        findViewById(R.id.btn_getreadername).setOnClickListener(this);
        findViewById(R.id.btn_getlibversion).setOnClickListener(this);
        findViewById(R.id.btn_open_auto_turnoff).setOnClickListener(this);
        findViewById(R.id.btn_close_auto_trunoff).setOnClickListener(this);
        findViewById(R.id.btn_clear).setOnClickListener(this);

        uiHandler = new Handler(this.getMainLooper());
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

    SelectDeviceDialog.SelectCallback mSelectCallback = new SelectDeviceDialog.SelectCallback() {
        @Override
        public void onDeviceConnected() {
            showMessage("Bluetooth device has been connected.");
        }
    };

    @SuppressLint("HandlerLeak")
    Handler mHandler = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            String text = "";
            if(msg.obj instanceof String){
                text = (String)msg.obj;
            }
            Log.e("cardreader", "handler msg. what : " + msg.what + ", obj : " + text);
            switch (msg.what){
                case DK.BT4_NEW:
//                    BluetoothDevice device = (BluetoothDevice) msg.obj;
//                    if(device != null && device.getName() != null){
//                        if(device.getName().equals("FT_00A05014292D")) {
//                            open(device);
//                            tvResult.setText("connect success");
//                        }
//                    }
//                    break;
                case DK.BT3_NEW:
                    BluetoothDevice device3 = (BluetoothDevice) msg.obj;
                    if(device3 != null && device3.getName() != null){
                        if(deviceDialog != null) {
                            deviceDialog.setData(device3);
                        }
//                        if(device3.getName().equals("FT__8CDE521A5E1B")) {
//                            open(device3);
//                            tvResult.setText("connect success");
//                        }
                    }
                    break;
                case DK.USB_LOG:
                    if(((String)msg.obj).contains("USB_PERMISSION")) {
                        try {
                            String[] names = mFtReader.readerOpen(null);
                            if (names.length != 0) {
                                addSpinnerPrivate(names);
                            }
                             readerNames = names;
                            showMessage("USB device has been connected.");
                        } catch (FTException e) {
                            e.printStackTrace();
                            runOnUiThread(new Runnable() {
                                @Override
                                public void run() {
                                    showMessage("USB device connection failed.");
                                }
                            });
                        }
                    }
                    break;
                case DK.BT3_DISCONNECTED:
                    showMessage("Bluetooth device has been disconnected.");
                    break;
                case DK.BT4_ACL_DISCONNECTED:
                    showMessage("BLE device has been disconnected.");
                    break;
                case DK.USB_IN:
                    showMessage("USB device has been inserted.");
                    break;
                case DK.USB_OUT:
                    showMessage("USB device out");
                    addSpinnerPrivate(new String[]{});
                    break;
                default:
                    if((msg.what & DK.CARD_IN_MASK) == DK.CARD_IN_MASK){
                        showMessage("Card slot " + (msg.what%DK.CARD_IN_MASK) + " in.");
                        return;
                    }else if((msg.what & DK.CARD_OUT_MASK) == DK.CARD_OUT_MASK){
                        showMessage("Card slot " + (msg.what%DK.CARD_IN_MASK) + " out.");
                        return;
                    }
                    break;
            }
        }
    };

    @Override
    public void onClick(View v) {
        switch (v.getId()){
            case R.id.auto_et_xfr_commond:
                autoCompleteTextView.setText("0");
                autoCompleteTextView.setText("");
                break;
            case R.id.btn_finder:
                find();
                break;
            case R.id.btn_open:
                open(null);
                break;
            case R.id.btn_close:
                close();
                break;
            case R.id.btn_poweron:
                poweron();
                break;
            case R.id.btn_poweroff:
                poweroff();
                break;
            case R.id.btn_readerxfr:
                readerxfr();
                break;
            case R.id.btn_readerescape:
                readerescape();
                break;
            case R.id.btn_getslotstatus:
                getslotstatus();
                break;
            case R.id.btn_getsn:
                getsn();
                break;
            case R.id.btn_getdevtype:
                getDeviceType();
                break;
            case R.id.btn_getfirmversion:
                getfirmversion();
                break;
            case R.id.btn_getuid:
                getUid();
                break;
            case R.id.btn_getmanufacturer:
                getManufacturer();
                break;
            case R.id.btn_gethardwareinfo:
                getHardwareInfo();
                break;
            case R.id.btn_getreadername:
                getReaderName();
                break;
            case R.id.btn_getlibversion:
                showMessage("Lib version : " + mFtReader.readerGetLibVersion());
                break;
            case R.id.btn_open_auto_turnoff:
                autoTurnOff(true);
                break;
            case R.id.btn_close_auto_trunoff:
                autoTurnOff(false);
                break;
            case R.id.btn_clear:
                mResultList.clear();
                mAdapterResult.notifyDataSetChanged();
                break;
            default:
                break;
        }
    }

    void find(){
        if(type == 0) {//usb
            try {
                mFtReader.readerFind();
                //open in handler case usb_in.
            } catch (FTException e) {
                e.printStackTrace();
                showMessage("USB device connection failed.");
            }
        }else {
            deviceDialog.show();
        }
    }

    void open(Object device){
        try {
            mFtReader.readerOpen(null);
        } catch (FTException e) {
            e.printStackTrace();
        }
    }

    void close(){
        try {
            mFtReader.readerClose();
            if(type == DK.FTREADER_TYPE_BT4){
                showMessage("BLE device has been disconnected.");
            }else if(type == DK.FTREADER_TYPE_USB){
                showMessage("USB device has been disconnected.");
                addSpinnerPrivate(new String[]{});
            }
        } catch (FTException e) {
            e.printStackTrace();
        }
    }

    void poweron(){
        doInBackground(new Runnable() {
            @Override
            public void run() {
                try {
                    byte[] atr = mFtReader.readerPowerOn(slotIndex);
                    showMessage("Power on success. Atr : " + Convection.Bytes2HexString(atr));
                } catch (FTException e) {
                    e.printStackTrace();
                    showMessage("Power on failed.\n" + e.getMessage());
                }
            }
        });
    }

    void poweroff(){
        doInBackground(new Runnable() {
            @Override
            public void run() {
                try {
                    mFtReader.readerPowerOff(slotIndex);
                    showMessage("Power off success.");
                } catch (FTException e) {
                    e.printStackTrace();
                    showMessage("Power off failed.\n"  + e.getMessage());
                }
            }
        });
    }

    void readerxfr(){
        doInBackground(new Runnable() {
            @Override
            public void run() {
                try {
                    String sendStr = autoCompleteTextView.getText().toString();
                    showMessage("XFR send : " + sendStr);
                    byte[] send = Utility.hexStrToBytes(sendStr);
                    long startTime = System.currentTimeMillis();
                    byte[] data = mFtReader.readerXfr(slotIndex, send);
                    if(data[0] == 0x61){
                        showMessage("XFR recv : " + Convection.Bytes2HexString(data));
                        showMessage("XFR send : 00C00000");
                        send = Utility.hexStrToBytes("00c00000" + StrUtil.byte2HexStr(data[1]));
                        data = mFtReader.readerXfr(slotIndex, send);
                    }
                    long endTime = System.currentTimeMillis();
                    showMessage("XFR recv : " + Convection.Bytes2HexString(data) + " (" + (endTime - startTime) + "ms)");
                } catch (FTException e) {
                    e.printStackTrace();
                    showMessage("XFR failed.\n" + e.getMessage());
                }
            }
        });
    }

    void readerescape(){
        doInBackground(new Runnable() {
            @Override
            public void run() {
                try {
                    String sendStr = etEscape.getText().toString();
                    showMessage("ESCAPE send : " + sendStr);
                    byte[] send = Utility.hexStrToBytes(sendStr);
                    long startTime = System.currentTimeMillis();
                    byte[] data = mFtReader.readerEscape(slotIndex, send);
                    long endTime = System.currentTimeMillis();
                    showMessage("ESCAPE recv : " + Convection.Bytes2HexString(data) + " (" + (endTime - startTime) + "ms)");
                } catch (FTException e) {
                    e.printStackTrace();
                    showMessage("ESCAPE failed.\n" + e.getMessage());
                }
            }
        });
    }

    void getslotstatus(){
        doInBackground(new Runnable() {
            @Override
            public void run() {
                try {
                    int status = mFtReader.readerGetSlotStatus(slotIndex);
                    switch (status) {
                        case DK.CARD_PRESENT_ACTIVE:
                            showMessage("SlotStatus: a card exists and is powered.");
                            break;
                        case DK.CARD_PRESENT_INACTIVE:
                            showMessage("SlotStatus: a card exists but it is not powered.");
                            break;
                        case DK.CARD_NO_PRESENT:
                            showMessage("SlotStatus: no cards exist.");
                            break;
                    }
                } catch (FTException e) {
                    e.printStackTrace();
                    showMessage("Get slot status failed.\n" + e.getMessage());
                }
            }
        });
    }

    void getsn(){
        doInBackground(new Runnable() {
            @Override
            public void run() {
                try {
                    byte[] sn = mFtReader.readerGetSerialNumber();
                    showMessage("sn : " + Convection.Bytes2HexString(sn));
                } catch (FTException e) {
                    e.printStackTrace();
                    showMessage("Get sn failed.\n" + e.getMessage());
                }
            }
        });
    }

    void getDeviceType(){
        doInBackground(new Runnable() {
            @Override
            public void run() {
                try {
                    int type = mFtReader.readerGetType();
                    String result = "";
                    switch (type){
                        case DK.READER_R301E:
                            result = "READER_R301";
                            break;
                        case DK.READER_BR301FC4:
                            result = "READER_BR301BLE";
                            break;
                        case DK.READER_BR500:
                            result = "READER_BR500";
                            break;
                        case DK.READER_R502_CL:
                            result = "READER_R502_CL";
                            break;
                        case DK.READER_R502_DUAL:
                            result = "READER_R502_DUAL";
                            break;
                        case DK.READER_BR301:
                            result = "READER_BR301";
                            break;
                        case DK.READER_IR301_LT:
                            result = "READER_IR301_LT";
                            break;
                        case DK.READER_IR301:
                            result = "READER_IR301";
                            break;
                        case DK.READER_VR504:
                            result = "READER_VR504";
                            break;
                        case DK.READER_UNKNOWN:
                        default:
                            result = "READER_UNKNOWN";
                    }
                    showMessage("type : " + result);
                } catch (FTException e) {
                    e.printStackTrace();
                    showMessage("Get device type failed.\n" + e.getMessage());
                }
            }
        });
    }

    void getfirmversion(){
        doInBackground(new Runnable() {
            @Override
            public void run() {
                try {
                    String version = mFtReader.readerGetFirmwareVersion();
                    showMessage("Firmware version : " + version);
                } catch (FTException e) {
                    e.printStackTrace();
                    showMessage("Get firmware version failed.\n" + e.getMessage());
                }
            }
        });
    }

    void getUid(){
        doInBackground(new Runnable() {
            @Override
            public void run() {
                try {
                    byte[] uid = mFtReader.readerGetUID();
                    showMessage("Uid : " + Utility.bytes2HexStr(uid));
                } catch (FTException e) {
                    e.printStackTrace();
                    showMessage("Get uid failed.\n" + e.getMessage());
                }
            }
        });
    }

    void getManufacturer(){
        doInBackground(new Runnable() {
            @Override
            public void run() {
                try {
                    byte[] manufacturer = mFtReader.readerGetManufacturer();
                    showMessage("Manufacturer : " + new String(manufacturer));
                } catch (FTException e) {
                    e.printStackTrace();
                    showMessage("Get manufacturer failed.\n" + e.getMessage());
                }
            }
        });
    }

    void getHardwareInfo(){
        doInBackground(new Runnable() {
            @Override
            public void run() {
                try {
                    byte[] hardwareinfo = mFtReader.readerGetHardwareInfo();
                    showMessage("Hardwareinfo : " + Utility.bytes2HexStr(hardwareinfo));
                } catch (FTException e) {
                    e.printStackTrace();
                    showMessage("Get hardware info failed.\n " + e.getMessage());
                }
            }
        });
    }

    void getReaderName(){
        doInBackground(new Runnable() {
            @Override
            public void run() {
                try {
                    byte[] readername = mFtReader.readerGetReaderName();
                    showMessage("Reader name : " + new String(readername));
                } catch (FTException e) {
                    e.printStackTrace();
                    showMessage("Get reader name failed.\n" + e.getMessage());
                }
            }
        });
    }

    void autoTurnOff(final boolean isOpen){
        doInBackground(new Runnable() {
            @Override
            public void run() {
                try {
                    byte[] result = mFtReader.FT_AutoTurnOffReader(isOpen);
                    showMessage((isOpen?"open":"close") + " auto turn off : " + Utility.bytes2HexStr(result));
                } catch (FTException e) {
                    e.printStackTrace();
                    showMessage((isOpen?"open":"close") + " auto turn off \n" + e.getMessage());
                }
            }
        });
    }

    private void addSpinnerPrivate(String devName){
        ArrayAdapter<String> arr_adapter = (ArrayAdapter<String>)(((Spinner)findViewById(R.id.sp_device_name)).getAdapter());
        if(arr_adapter == null){
            arr_adapter = new ArrayAdapter<String>(MainActivity.this, R.layout.spinner_item, new ArrayList<String>());
        }
        arr_adapter.add(devName);
        ((Spinner)findViewById(R.id.sp_device_name)).setAdapter(arr_adapter);
    }

    private void addSpinnerPrivate(String[] devNameArray){
        ArrayAdapter<String> arr_adapter = (ArrayAdapter<String>)(((Spinner)findViewById(R.id.sp_device_name)).getAdapter());
        if(arr_adapter != null){
            arr_adapter.clear();
        }
        for (String devName : devNameArray) {
            if(devName != null) {
                addSpinnerPrivate(devName);
            }
        }
    }

    private void showMessage(final String msg){
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

    public void showLoading(final boolean show){
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

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK) {
            tapFinish();
            return false;
        }
        return keyCode != KeyEvent.KEYCODE_BACK &&
                super.onKeyDown(keyCode, event);
    }

    public void tapFinish() {
        long currentTimes = Calendar.getInstance().getTimeInMillis();
        long diffTime = currentTimes - lastTimesFlag;
        lastTimesFlag = Calendar.getInstance().getTimeInMillis();
        if (diffTime <= 2000 && diffTime > 0) {
            finish();
            System.exit(0);
        } else {
            uiHandler.post(new Runnable() {
                @Override
                public void run() {
                    Toast.makeText(MainActivity.this, "Click again to exit the app", Toast.LENGTH_LONG).show();
                }
            });
        }
    }
}
