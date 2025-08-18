package com.ftsafe.ireader.ui;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.hardware.usb.UsbDevice;
import android.hardware.usb.UsbManager;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.PopupWindow;
import android.widget.Toast;

import androidx.annotation.RequiresApi;
import androidx.core.app.ActivityCompat;

import com.ftsafe.DK;
import com.ftsafe.ireader.R;
import com.ftsafe.ireader.adapter.GridViewItem;
import com.ftsafe.ireader.adapter.ImageAdapter;
import com.ftsafe.ireader.utils.Convection;
import com.ftsafe.readerScheme.FTException;
import com.ftsafe.readerScheme.FTReader;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;

public class ConnectActivity extends BaseActivity implements View.OnClickListener, AdapterView.OnItemClickListener {
    GridView gridView;
    MyArrayList<BluetoothDevice> listDevice;
    MyArrayList<String> listDeviceName;
    public static int deviceType = -1;
    private PopupWindow popWin = null; // 弹出窗口
    private View popView = null; // 保存弹出窗口布局
    private BluetoothStateBroadcastReceive mReceive = null;
    private ProgressDialog waitingDialog;

    public static Boolean isAutoConnect = false;

    private ImageAdapter imageAdapter;

    Handler handler = new Handler();
    Runnable runnable;
    ImageView btn_helpView;
    Button btn_OK;
    public static String TAG = "FTSAFE_iReader";
    List<HashMap<String, GridViewItem>> hashMapList;
    Context mContext;
    public static Handler connectHandler = null;
    static FTReader mFtReader;
    static FTReader mBleFtReader;
    static FTReader mUSBFtReader;
    static FTReader mBle3FtReader;
    int powerState = -1;
    private static BroadcastReceiver mUsbReceiver;
    private static final String ACTION_USB_PERMISSION = "com.android.example.USB_PERMISSION";

    static List<UsbDevice> foundUSBDevices = new ArrayList<>();

    static List<String> connectedDeviceList = new ArrayList<>();

    static List<String> connectedDeviceNameList = new ArrayList<>();

    static List<String[]> connectedDeviceCardSlotList = new ArrayList<>();

    static boolean isConnected = false;

    @RequiresApi(api = Build.VERSION_CODES.TIRAMISU)
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        Log.i(TAG,"ConnectActivity.onCreate");
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_connect);
        mContext = this;
        checkBluetoothValid();
        registerBluetoothReceiver();
        initView();
        initData();
        find();
    }

    private void gConnectHandlerSendMessage(int what, Object obj) {
        if (connectHandler != null) {
            connectHandler.sendMessage(connectHandler.obtainMessage(what, powerState, powerState, obj));
        }
    }

    int n = 1;
    int USBDeviceCount = 0;
    //Used to recieve reader events.
    @SuppressLint("HandlerLeak")
    Handler mHandler = new Handler() {
        @SuppressLint("MissingPermission")
        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            powerState = msg.arg1;
            switch (msg.what) {
                //Bluetooth device scanned.
                case DK.BT3_LOG:
                case DK.BT4_LOG:
                    gConnectHandlerSendMessage(msg.what, msg.obj);
                    break;
                case DK.BT3_NEW:
                    BluetoothDevice device3 = (BluetoothDevice) msg.obj;
                    if (device3 != null && device3.getName() != null) {
                        mFtReader = mBle3FtReader;
                        mBle3FtReader.readerBleStopFind();
                        runnable = new Runnable() {
                            @Override
                            public void run() {
                                deviceType = DK.FTREADER_TYPE_BT3;
                                connect(device3);
                            }
                        };
                        new Thread(runnable).start();
                    }
                    break;
                case DK.BT4_NEW:
                    BluetoothDevice device4 = (BluetoothDevice) msg.obj;
                    if (device4 != null && device4.getName() != null) {
                        if (isAutoConnect) {
                            isAutoConnect = false;
                            try {
                                mBleFtReader.readerBleStopFind();
                                mUSBFtReader.readerClose("");
                                mFtReader = mBleFtReader;
                            } catch (FTException e) {
                                e.printStackTrace();
                            }
                            waitingDialog.setTitle("Bluetooth is connecting...");
                            waitingDialog.setCancelable(false);
                            waitingDialog.show();
                            runnable = new Runnable() {
                                @Override
                                public void run() {
                                    deviceType = DK.FTREADER_TYPE_BT4;
                                    connect(device4);
                                    runOnUiThread(new Runnable() {
                                        @Override
                                        public void run() {
                                            waitingDialog.dismiss();
                                        }
                                    });
                                }
                            };
                            new Thread(runnable).start();
                        } else {
                            setData(device4);
                        }
                    }
                    break;
                case DK.USB_LOG:
                    //Otg device found.
                     if (((String) msg.obj).contains("has USB_PERMISSION")) {
                        if (foundUSBDevices.size() == USBDeviceCount && !isConnected) {
                            mFtReader = mUSBFtReader;
                            deviceType = DK.FTREADER_TYPE_USB;
                            for (int j = 0; j < foundUSBDevices.size(); j++) {
                                USBDeviceCount--;
                                usb_connect(foundUSBDevices.get(j));
                            }
                            Log.i(TAG, "USB device has been connected.");
                        }
                    }
                    if (((String) msg.obj).contains("USB DEVICE ATTACHED") && !isConnected) {
                        try {
                            mUSBFtReader.readerFind();
                        } catch (FTException e) {
                            e.printStackTrace();
                        }
                    }
                    break;
                case DK.USB_COUNT:
                    USBDeviceCount = (int) msg.obj;
                case DK.BT3_DISCONNECTED:
                    Log.i(TAG, "BT3 device has been disconnected.");
                    gConnectHandlerSendMessage(DK.BT3_DISCONNECTED, "");
                    break;
                case DK.BT4_ACL_DISCONNECTED:
                    gConnectHandlerSendMessage(DK.BT4_ACL_DISCONNECTED, "");
                    Log.i(TAG, "BLE device has been disconnected.");
                    break;
                case DK.USB_IN:
                    Log.i(TAG, "Connect Activity: USB device has been inserted.");
                    UsbDevice usbDevice = (UsbDevice) msg.obj;
                    foundUSBDevices.add(usbDevice);
                    gConnectHandlerSendMessage(DK.USB_IN, usbDevice.getProductName());
                    break;
                case DK.USB_OUT:
                    Log.i(TAG, "USB device out");
                    UsbDevice usbDevice1 = (UsbDevice) msg.obj;
                    int index = connectedDeviceList.indexOf(usbDevice1.getDeviceName());
                    String outDeviceName = connectedDeviceNameList.get(index);
                    foundUSBDevices.clear();
                    connectedDeviceList.remove(index);
                    connectedDeviceNameList.remove(index);
                    connectedDeviceCardSlotList.remove(index);
                    gConnectHandlerSendMessage(DK.USB_OUT, outDeviceName);
                    break;
                default:
                    if ((msg.what & DK.CARD_IN_MASK) == DK.CARD_IN_MASK) {
                        //Card in.
                        Log.i(TAG, "Card slot " + (msg.what % DK.CARD_IN_MASK) + " in.");
                        gConnectHandlerSendMessage(msg.what, msg.obj);
                        return;
                    } else if ((msg.what & DK.CARD_OUT_MASK) == DK.CARD_OUT_MASK) {
                        //Card out.
                        gConnectHandlerSendMessage(msg.what, msg.obj);
                        Log.i(TAG, "Card slot " + (msg.what % DK.CARD_OUT_MASK) + " out.");
                        return;
                    }
                    break;
            }
        }
    };

    // @RequiresApi(api = Build.VERSION_CODES.TIRAMISU)
    public void initData() {
        waitingDialog = new ProgressDialog(mContext);
        hashMapList = new ArrayList<HashMap<String, GridViewItem>>();
        listDevice = new MyArrayList<>();
        listDeviceName = new MyArrayList<>();
        isAutoConnect = Convection.getIsAutoConnect(mContext);
        Convection.setIsAutoTurnOff(mContext, false);
        mBle3FtReader = new FTReader(mContext, mHandler, DK.FTREADER_TYPE_BT3);
        mBleFtReader = new FTReader(mContext, mHandler, DK.FTREADER_TYPE_BT4);
        mUSBFtReader = new FTReader(mContext, mHandler, DK.FTREADER_TYPE_USB);
        if (mUsbReceiver == null) {
            mUsbReceiver = new BroadcastReceiver() {
                @Override
                public void onReceive(Context context, Intent intent) {
                    String action = intent.getAction();
                    UsbDevice device = (UsbDevice) intent.getParcelableExtra(UsbManager.EXTRA_DEVICE);
                    if (ACTION_USB_PERMISSION.equals(action)) {
                        synchronized (this) {
                            if (intent.getBooleanExtra(UsbManager.EXTRA_PERMISSION_GRANTED, false)) {
                                if (device != null) {
                                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                                        try {
                                            mUSBFtReader.readerFind();
                                        } catch (FTException e) {
                                            e.printStackTrace();
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            };
        }
        IntentFilter filter = new IntentFilter();
        filter.addAction(ACTION_USB_PERMISSION);
        filter.addAction(UsbManager.ACTION_USB_DEVICE_ATTACHED);
        filter.addAction(UsbManager.ACTION_USB_DEVICE_DETACHED);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            mContext.registerReceiver(mUsbReceiver, filter, Context.RECEIVER_NOT_EXPORTED);
        }else{
            mContext.registerReceiver(mUsbReceiver, filter);
        }
    }

    private void initView() {
        gridView = findViewById(R.id.gview);
        gridView.setOnItemClickListener(this);
        btn_helpView = findViewById(R.id.id_help_png);
        btn_helpView.setOnClickListener(this);
    }

    public GridViewItem getGridViewItem(String devicesName) {

        Bitmap tempBitmap = BitmapFactory.decodeResource(getResources(),
                R.drawable.devices1);

        GridViewItem tempItem = new GridViewItem(tempBitmap, devicesName);

        return tempItem;
    }

    private void updateData() {
        hashMapList.clear();
        for (int i = 0; i < listDeviceName.size(); i++) {
            Log.i(TAG, "listDeviceName:" + listDeviceName.get(i));
            HashMap<String, GridViewItem> tempHashMap = new HashMap<String, GridViewItem>();
            tempHashMap.put("item", getGridViewItem(listDeviceName.get(i)));
            hashMapList.add(tempHashMap);
        }
        imageAdapter = new ImageAdapter(this, hashMapList);
        gridView.setAdapter(imageAdapter);
    }

    @Override
    public void onClick(View v) {
        int id = v.getId();
        if (id == R.id.id_help_png) {
            showPopupWindow();
        } else if (id == R.id.btn_OK) {
            popWin.dismiss();
        }
    }

    @SuppressLint("MissingPermission")
    public void setData(BluetoothDevice device) {
        if (listDevice.contains(device)) {
            //又扫描到设备了，计时重置
            listDevice.resetTimer(device);
            listDeviceName.resetTimer(device.getName());
            return;
        } else {
            listDevice.add(device);
            listDeviceName.add(device.getName());
            updateData();
        }
    }

    //Find device.
    //The device will automatically connect after it is found.
    void find() {
        try {
            listDeviceName.clear();
            listDevice.clear();
            mBleFtReader.readerFind();
            mBle3FtReader.readerFind();
            mUSBFtReader.readerFind();
            //open in handler case usb_in.
        } catch (FTException e) {
            e.printStackTrace();
            Log.e(TAG, "USB device connection failed.");
        }
    }

    void usb_connect(UsbDevice device) {
        if (foundUSBDevices == null || foundUSBDevices.size() == 0) {
            return;
        }
        try {
            String[] str = mFtReader.readerOpen(device.getDeviceName());
            connectedDeviceList.add(device.getDeviceName());
            device.getProductName();
            if (!connectedDeviceNameList.contains(device.getProductName())) {
                connectedDeviceNameList.add(device.getProductName());
            } else {
                String usbName = device.getProductName() + "_" + n++;
                connectedDeviceNameList.add(usbName);
            }

            connectedDeviceCardSlotList.add(str);
            if (mBleFtReader != null && BluetoothAdapter.getDefaultAdapter().isEnabled()) {
                mBleFtReader.readerBleStopFind();
            }

            if (USBDeviceCount != 0) {
                return;
            } else {
                deviceType = DK.FTREADER_TYPE_USB;
                Intent intent = new Intent(ConnectActivity.this, CardReaderManagertActivity.class);
                startActivity(intent);
                mContext.unregisterReceiver(mUsbReceiver);
                unregisterBluetoothReceiver();
                finish();
            }
        } catch (FTException e) {
            e.printStackTrace();
        }
    }

    @SuppressLint("MissingPermission")
    void connect(BluetoothDevice device) {
        try {
            String[] str = mFtReader.readerOpen(device);
            if (mBleFtReader != null && BluetoothAdapter.getDefaultAdapter().isEnabled()) {
                mBleFtReader.readerBleStopFind();
            }
            connectedDeviceList.add(device.getName());

            connectedDeviceNameList.add(device.getName());
            isConnected = true;
            Intent intent = new Intent(ConnectActivity.this, CardReaderManagertActivity.class);
            startActivity(intent);
            if (str[0].equals(connectedDeviceList.get(0))){
                handler.postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        gConnectHandlerSendMessage(DK.BT4_NEW,device);
                    }
                }, 1000);
            }
            mContext.unregisterReceiver(mUsbReceiver);
            unregisterBluetoothReceiver();
            finish();
        } catch (FTException e) {
            e.printStackTrace();
        }
    }

    private void checkBluetoothValid() {
        final BluetoothAdapter adapter = BluetoothAdapter.getDefaultAdapter();
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.BLUETOOTH_CONNECT) != PackageManager.PERMISSION_GRANTED) {
            // TODO: Consider calling
            //    ActivityCompat#requestPermissions
            if(adapter == null) {
                AlertDialog dialog = new AlertDialog.Builder(mContext).setTitle("Error").setMessage("Bluetooth permission not granted.").create();
                dialog.show();
                return;
            }

            if(!adapter.isEnabled()) {
                AlertDialog dialog = new AlertDialog.Builder(mContext).setTitle("Message")
                        .setMessage("Enable Bluetooth to continue!")
                        .setPositiveButton("Yes", new DialogInterface.OnClickListener() {
//                            @SuppressLint("MissingPermission")
                            @Override
                            public void onClick(DialogInterface arg0, int arg1) {
                                //不提示,直接开启蓝牙
                                adapter.enable();
                                //提示选择手动开启蓝牙
//                            Intent enabler = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
//                            startActivityForResult(enabler, 1);
                            }
                        })
                        .create();
                dialog.show();
            }
        }

    }

    @Override
    public void onItemClick(AdapterView<?> adapterView, View view, int position, long l) {
        Log.i(TAG,"listDeviceName:"+listDeviceName.get(position));
        handler.removeCallbacks(runnable);
        mBleFtReader.readerBleStopFind();
        mFtReader = mBleFtReader;
        waitingDialog.setTitle("Bluetooth is connecting...");
        waitingDialog.setCancelable(false);
        waitingDialog.show();
        runnable = new Runnable() {
            @Override
            public void run() {
                deviceType = DK.FTREADER_TYPE_BT4;
                connect(listDevice.get(position));
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        waitingDialog.dismiss();
                    }
                });
            }
        };
        new Thread(runnable).start();
    }

    private void showPopupWindow() {
        LayoutInflater inflater = LayoutInflater.from(ConnectActivity.this); // 取得LayoutInflater对象
        popView = inflater.inflate(R.layout.layout_help, null); // 读取布局管理器
        btn_OK = popView.findViewById(R.id.btn_OK);
        btn_OK.setOnClickListener(this);
        popWin = new PopupWindow(popView, ViewGroup.LayoutParams.FILL_PARENT, ViewGroup.LayoutParams.FILL_PARENT, true); // 实例化PopupWindow
        // 设置PopupWindow的弹出和消失效果
        popWin.setAnimationStyle(R.style.popupAnimation);
        //相对于父控件的位置（例如正中央Gravity.CENTER，下方Gravity.BOTTOM等），可以设置偏移或无偏移
        popWin.showAtLocation(btn_helpView, Gravity.BOTTOM, 0, 0); // 显示弹出窗口
    }

    public class MyArrayList<T> extends ArrayList<T> {
        private final static int DELAY_TIME = 2000;
        private Map<T, Timer> map;

        public MyArrayList() {
            super();
            map = new HashMap<>();
        }

        public boolean add(final T t) {
            //新建一个计时器
            Timer timer = new Timer();
            timer.schedule(new TimerTask() {
                @Override
                public void run() {
                    remove(t);
                    // 更新主线程UI
                    ConnectActivity.this.runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            updateData();
                        }
                    });
                }
            }, DELAY_TIME);
            map.put(t, timer);
            return super.add(t);
        }

        public void resetTimer(final T t) {
            //重置计时器
            Timer timer = map.get(t);
            if (timer != null) {
                timer.cancel();
                timer.purge();
                map.remove(t);
                timer = new Timer();
                map.put(t, timer);
                timer.schedule(new TimerTask() {
                    @Override
                    public void run() {
                        remove(t);
                        // 更新主线程UI
                        ConnectActivity.this.runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                updateData();
                            }
                        });
                    }
                }, DELAY_TIME);
            }
        }

        public boolean remove(Object o) {
            try {
                //清除该计时器
                Timer timer = map.get(o);
                if (timer != null) {
                    timer.cancel();
                    timer.purge();
                    map.remove(o);
                }
                return super.remove(o);
            } catch (Exception e) {
                e.printStackTrace();
                return false;
            }
        }

        public void clear() {
            //清除所有计时器
            for (Map.Entry<T, Timer> entry : map.entrySet()) {
                entry.getValue().cancel();
                entry.getValue().purge();
            }
            map.clear();
            super.clear();
        }
    }

    public class BluetoothStateBroadcastReceive extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
            switch (action){
                case BluetoothAdapter.ACTION_STATE_CHANGED:
                    int blueState = intent.getIntExtra(BluetoothAdapter.EXTRA_STATE, 0);
                    switch (blueState){
                        case BluetoothAdapter.STATE_OFF:
                            Toast.makeText(context , "蓝牙已关闭！", Toast.LENGTH_LONG).show();
                            checkBluetoothValid();
                            break;
                        case BluetoothAdapter.STATE_ON:
                            Toast.makeText(context , "蓝牙已开启！" , Toast.LENGTH_LONG).show();
                            find();
                            break;
                    }
                    break;
            }
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.TIRAMISU)
    private void registerBluetoothReceiver(){
        if(mReceive == null){
            mReceive = new BluetoothStateBroadcastReceive();
        }
        IntentFilter intentFilter = new IntentFilter(BluetoothAdapter.ACTION_STATE_CHANGED);
        intentFilter.addAction("android.bluetooth.BluetoothAdapter.STATE_OFF");
        intentFilter.addAction("android.bluetooth.BluetoothAdapter.STATE_ON");
        registerReceiver(mReceive, intentFilter, Context.RECEIVER_NOT_EXPORTED);
    }

    private void unregisterBluetoothReceiver(){
        if(mReceive != null){
            unregisterReceiver(mReceive);
            mReceive = null;
        }
    }
}
