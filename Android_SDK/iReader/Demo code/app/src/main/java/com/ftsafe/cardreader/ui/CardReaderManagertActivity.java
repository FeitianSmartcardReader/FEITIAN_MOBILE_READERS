package com.ftsafe.cardreader.ui;

import static com.ftsafe.cardreader.ui.ConnectActivity.TAG;
import static com.ftsafe.cardreader.ui.ConnectActivity.connectedDeviceCardSlotList;
import static com.ftsafe.cardreader.ui.ConnectActivity.connectedDeviceList;
import static com.ftsafe.cardreader.ui.ConnectActivity.connectedDeviceNameList;
import static com.ftsafe.cardreader.ui.ConnectActivity.deviceType;

import android.annotation.SuppressLint;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Rect;
import android.graphics.drawable.BitmapDrawable;
import android.hardware.usb.UsbDevice;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.Display;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.PopupWindow;
import android.widget.Spinner;
import android.widget.TextView;

import androidx.annotation.RequiresApi;

import com.ftsafe.DK;
import com.ftsafe.Utility;
import com.ftsafe.cardreader.R;
import com.ftsafe.cardreader.adapter.GridViewItem;
import com.ftsafe.cardreader.utils.Convection;
import com.ftsafe.comm.StrUtil;
import com.ftsafe.readerScheme.FTException;
import com.ftsafe.readerScheme.FTReader;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class CardReaderManagertActivity extends BaseActivity implements View.OnClickListener{
    private Context mContext;
    private FTReader mFtReader;

    private PopupWindow popWin = null; // the Popup Window
    private View popView = null; // to store popup window layout

    private Bitmap mBitmap;
    ImageView mImageView;
    ImageView mImg_Devicelogo;
    TextView mText_Devicelogo;

    private Button btn_sendMail,btn_LogBack;
    private EditText text_in_recipient,text_in_ccperson,text_in_bccperson,text_in_theme,text_in_message;

    private Spinner spinner_Instruction, spConnectedDevices, spCardSlots;
    private EditText text_EscapeCMD;

    TextView btn_log,text_powerState;
    private File mFileAttachment;
    private ProgressDialog progressDialog;
    private static ListView lvResult;
    private static List<String> mResultList;
    private static ArrayAdapter<String> mAdapterResult;

    private ImageView btn_SendCMD, btn_WriteFlash, btn_ReaderFlash,btn_GetUID,btn_EscapeCMD,btn_SendEscapeCMD;
    private Button btn_PowerOn, btn_PowerOff, btn_CardCMD, btn_ReaderCMD;

    private View include_CardCMD,include_ReaderCMD,include_escapeCMD;

    private int bleDeviceType = -1;

    int mSlotIndex = 0;

    static int connectedReaderIndex = 0;

    private String phoneInfo = "Product: " + android.os.Build.PRODUCT;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_cardreader);
        Log.e(TAG,"进入CardReaderActivity！");
        mContext = this;
        initView();
        initData();
    }

    public void initData(){
        ConnectActivity.connectHandler = mHandler;
        mFtReader = ConnectActivity.mFtReader;
        bleDeviceType = getDeviceType();
        mText_Devicelogo.setText(getReaderName());
        if (deviceType == DK.FTREADER_TYPE_USB){
            for (int i = 0; i < connectedDeviceNameList.size(); i++){
                showMessage("USB_"+connectedDeviceNameList.get(i)+" is connected！");
            }
        }
        if (bleDeviceType == DK.READER_BR500){
            mImg_Devicelogo.setImageResource(R.drawable.br500);
        }else {
            mImg_Devicelogo.setImageResource(R.drawable.br301tag);
        }
        progressDialog = new ProgressDialog(this);
        progressDialog.setCancelable(false);
        progressDialog.setProgressStyle(ProgressDialog.STYLE_SPINNER);
        if (deviceType != DK.FTREADER_TYPE_USB){
            showMessage(connectedDeviceNameList.get(0)+" is connected！");
            getslotstatus(connectedDeviceList.get(0),mSlotIndex);
        }
    }
    @SuppressLint("HandlerLeak")
    Handler mHandler = new Handler(){
        @SuppressLint("MissingPermission")
        @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            text_powerState.setText(msg.arg1+"%");
            switch (msg.what){
                //Bluetooth device scanned.
                case DK.BT4_NEW:
                case DK.BT3_NEW:
                    break;
                case DK.USB_LOG:
                    //Otg device found.
                    break;
                case DK.BT3_DISCONNECTED:
                    showMessage("Bluetooth device has been disconnected.");
                    ConnectActivity.connectHandler = null;
                    connectedDeviceCardSlotList.clear();
                    connectedDeviceList.clear();
                    connectedDeviceNameList.clear();
                    ConnectActivity.connectHandler = null;
                    ConnectActivity.isConnected = false;
                    Intent intent1 = new Intent(CardReaderManagertActivity.this, ConnectActivity.class);
                    startActivity(intent1);
                    finish();
                    break;
                case DK.BT4_ACL_DISCONNECTED:
                    showMessage("BLE device has been disconnected.");
                    ConnectActivity.connectHandler = null;
                    connectedDeviceCardSlotList.clear();
                    connectedDeviceList.clear();
                    connectedDeviceNameList.clear();
                    ConnectActivity.connectHandler = null;
                    ConnectActivity.isConnected = false;
                    Intent intent = new Intent(CardReaderManagertActivity.this, ConnectActivity.class);
                    startActivity(intent);
                    finish();
                    break;
                case DK.USB_IN:
                    showMessage("USB device has been inserted.");
                    break;
                case DK.USB_OUT:
                    showMessage((String)msg.obj+":USB device out");
                    addConnectedSpinnerPrivate(connectedDeviceNameList);
                    if (connectedDeviceList.size() == 0){
                        ConnectActivity.connectHandler = null;
                        ConnectActivity.isConnected = false;
                        intent = new Intent(CardReaderManagertActivity.this, ConnectActivity.class);
                        startActivity(intent);
                        finish();
                    }
                    break;
                default:
                    if((msg.what & DK.CARD_IN_MASK) == DK.CARD_IN_MASK){
                        //Card in.
                        if (deviceType == DK.FTREADER_TYPE_USB){
                            showMessage(connectedDeviceNameList.get(connectedDeviceList.indexOf((String) msg.obj))+":Card slot " + (msg.what%DK.CARD_IN_MASK) + " in.");
                            if (bleDeviceType == DK.READER_BR500){
                                mImg_Devicelogo.setImageResource(R.drawable.br500_1);
                            }else {
                                mImg_Devicelogo.setImageResource(R.drawable.br301_2);
                            }
                        }else {
                            getslotstatus((String) msg.obj,msg.what%DK.CARD_IN_MASK);
                        }
                        return;
                    }else if((msg.what & DK.CARD_OUT_MASK) == DK.CARD_OUT_MASK){
                        //Card out.
                        getslotstatus((String) msg.obj,msg.what%DK.CARD_OUT_MASK);
                        return;
                    }
                    break;
            }
        }
    };

    private void initView() {
        btn_PowerOn = findViewById(R.id.btn_poweron);
        btn_PowerOn.setOnClickListener(this);
        btn_PowerOff = findViewById(R.id.btn_poweroff);
        btn_PowerOff.setOnClickListener(this);
        btn_SendCMD = findViewById(R.id.btn_sendcmd);
        btn_SendCMD.setOnClickListener(this);
        btn_CardCMD = findViewById(R.id.select_cmd_card);
        btn_CardCMD.setOnClickListener(this);
        btn_ReaderCMD = findViewById(R.id.select_cmd_reader);
        btn_ReaderCMD.setOnClickListener(this);
        btn_SendEscapeCMD = findViewById(R.id.btn_sendescapecmd);
        btn_SendEscapeCMD.setOnClickListener(this);

        btn_WriteFlash = findViewById(R.id.btn_writeflash);
        btn_WriteFlash.setOnClickListener(this);
        btn_EscapeCMD = findViewById(R.id.btn_escapecmd);
        btn_EscapeCMD.setOnClickListener(this);
        btn_ReaderFlash = findViewById(R.id.btn_readflash);
        btn_ReaderFlash.setOnClickListener(this);
        btn_GetUID = findViewById(R.id.btn_uid);
        btn_GetUID.setOnClickListener(this);

        mImg_Devicelogo = findViewById(R.id.id_img_logo);
        mText_Devicelogo = findViewById(R.id.id_text_logo);

        findViewById(R.id.btn_info).setOnClickListener(this);
        btn_log = findViewById(R.id.btn_log);
        btn_log.setOnClickListener(this);

        text_powerState = findViewById(R.id.text_powerState);
        text_powerState.setOnClickListener(this);

        lvResult = findViewById(R.id.lv_result);
        mResultList = new ArrayList<>();
        mAdapterResult = new ArrayAdapter<>(this, R.layout.item_lv, mResultList);
        lvResult.setAdapter(mAdapterResult);

        spinner_Instruction = findViewById(R.id.text_spinner);
        ArrayAdapter<String> xfrCommondAdapter = new ArrayAdapter<>(
                this, android.R.layout.simple_list_item_1,
                getResources().getStringArray(R.array.xfr_command));
        spinner_Instruction.setAdapter(xfrCommondAdapter);

        text_EscapeCMD = findViewById(R.id.text_escapecmd);
        text_EscapeCMD.setText("A55A3231");

        include_CardCMD = findViewById(R.id.cardLayout);
        include_ReaderCMD = findViewById(R.id.readerLayout);
        include_escapeCMD = findViewById(R.id.escapeLayout);

        if (deviceType == DK.FTREADER_TYPE_USB || deviceType == DK.FTREADER_TYPE_BT3){
            text_powerState.setVisibility(View.GONE);
        }

        spConnectedDevices = findViewById(R.id.sp_connectedDevices);
        spConnectedDevices.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                connectedReaderIndex = position;
                addCardSlotSpinnerPrivate(connectedDeviceCardSlotList.get(position));
                mText_Devicelogo.setText(getReaderName());
                mSlotIndex = 0;
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {
            }
        });

        spCardSlots = findViewById(R.id.sp_cardSlot);
        spCardSlots.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                mSlotIndex = position;
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {
            }
        });
        if (deviceType != DK.FTREADER_TYPE_USB){
            spCardSlots.setVisibility(View.GONE);
            spConnectedDevices.setVisibility(View.GONE);
        }
        addConnectedSpinnerPrivate(connectedDeviceNameList);

        Log.e("FTSafe",phoneInfo + ", CPU_ABI: " + android.os.Build.CPU_ABI);
        Log.e("FTSafe",phoneInfo + ", SDK: " + android.os.Build.VERSION.SDK);
        Log.e("FTSafe",phoneInfo + ", VERSION.RELEASE: " + android.os.Build.VERSION.RELEASE);
        Log.e("FTSafe",phoneInfo + ", DEVICE: " + android.os.Build.DEVICE);
        Log.e("FTSafe",phoneInfo + ", phoneModel:" + android.os.Build.MODEL);
        Log.e("FTSafe",phoneInfo + ", mobile_phone_manufacturers:" + android.os.Build.MANUFACTURER);
    }

    @Override
    public void onClick(View v) {
        Intent intent = null;
                switch (v.getId()) {
            case R.id.btn_poweron:
                poweron(connectedDeviceList.get(connectedReaderIndex),mSlotIndex);
                break;
            case R.id.btn_poweroff:
                poweroff();
                break;
            case R.id.btn_sendcmd:
                btn_SendCMD.setEnabled(false);
                readerxfr();
                break;
            case R.id.btn_sendescapecmd:
                readerescape();
                break;
            case R.id.btn_uid:
                getUid();
                break;
            case R.id.btn_writeflash:
                try {
                    readerWriteFlash();
                } catch (IOException e) {
                    e.printStackTrace();
                }
                break;
            case R.id.btn_readflash:
                readerReadFlash();
                break;
            case R.id.btn_info:
                intent = new Intent(CardReaderManagertActivity.this, InformationActivity.class);
                startActivity(intent);
//                finish();
                break;
            case R.id.btn_log:
                GetandSaveCurrentImage();
                showPopupWindow();
                btn_log.setEnabled(false);
                break;
            case R.id.select_cmd_card:
                include_CardCMD.setVisibility(View.VISIBLE);
                include_ReaderCMD.setVisibility(View.GONE);
                include_escapeCMD.setVisibility(View.GONE);
                break;
            case R.id.select_cmd_reader:
                include_CardCMD.setVisibility(View.GONE);
                include_ReaderCMD.setVisibility(View.VISIBLE);
                include_escapeCMD.setVisibility(View.GONE);
                break;
            case R.id.btn_escapecmd:
                include_CardCMD.setVisibility(View.GONE);
                include_ReaderCMD.setVisibility(View.GONE);
                include_escapeCMD.setVisibility(View.VISIBLE);
                break;
            case R.id.btn_LogBack:
                popWin.dismiss(); // Dismiss the popup window
                btn_log.setEnabled(true);
                break;
            default:
                break;
        }
    }

    public static void showMessage(final String msg){
        lvResult.post(new Runnable() {
            @Override
            public void run() {
                mResultList.add(msg);
                mAdapterResult.notifyDataSetChanged();
                Log.e(TAG,msg);
            }
        });
    }


    private void doInBackground(final Runnable r){
        new Thread(new Runnable() {
            @Override
            public void run() {
                r.run();
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

    void poweron(String device, int slotindex){
                try {
                    byte[] atr = mFtReader.readerPowerOn(device,slotindex);
                    mText_Devicelogo.setText(getReaderName());
                    if (bleDeviceType == DK.READER_BR500){
                        mImg_Devicelogo.setImageResource(R.drawable.br500_3);
                    }else {
                        mImg_Devicelogo.setImageResource(R.drawable.br301);
                    }
                    showMessage("Power on success. Atr : " + Convection.Bytes2HexString(atr));
                } catch (FTException e) {
                    e.printStackTrace();
                    mText_Devicelogo.setText(getReaderName());
                    if (bleDeviceType == DK.READER_BR500){
                        mImg_Devicelogo.setImageResource(R.drawable.br500_2);
                    }else {
                        mImg_Devicelogo.setImageResource(R.drawable.br301_1);
                    }
                    showMessage("Power on failed.\n" + e.getMessage());
                }
    }

    void poweroff(){
                try {
                    if (bleDeviceType == DK.READER_BR500){
                        showMessage("Power off failed:Special equipment can't be powered down.");
                        return;
                    }else {
                        mFtReader.readerPowerOff(connectedDeviceList.get(connectedReaderIndex),mSlotIndex);
                        mImg_Devicelogo.setImageResource(R.drawable.br301_1);
                        showMessage("Power off success.");
                    }
                } catch (FTException e) {
                    e.printStackTrace();
                    showMessage("Power off failed.\n"  + e.getMessage());
                }
    }

    void getslotstatus(String device, int slotIndex){
        try {
            if (deviceType != DK.FTREADER_TYPE_USB){
                device = connectedDeviceList.get(0);
            }
            int status = mFtReader.readerGetSlotStatus(device,slotIndex);
            switch (status) {
                case DK.CARD_PRESENT_ACTIVE:
                    showMessage(connectedDeviceNameList.get(connectedDeviceList.indexOf(device))+":Card slot " + (slotIndex) + " in.");
                    if (bleDeviceType == DK.READER_BR500){
                        poweron(device,slotIndex);
                    }else {
                        mImg_Devicelogo.setImageResource(R.drawable.br301);
                        mText_Devicelogo.setText(getReaderName());
                    }
                    break;
                case DK.CARD_PRESENT_INACTIVE:
                    showMessage(connectedDeviceNameList.get(connectedDeviceList.indexOf(device))+":Card slot " + (slotIndex) + " in.");
                    poweron(device,slotIndex);
                    break;
                case DK.CARD_NO_PRESENT:
                    showMessage(connectedDeviceNameList.get(connectedDeviceList.indexOf(device))+":Card slot " + (slotIndex) + " out.");
                    if (bleDeviceType == DK.READER_BR500){
                        mImg_Devicelogo.setImageResource(R.drawable.br500);
                    }else {
                        mImg_Devicelogo.setImageResource(R.drawable.br301tag);
                    }
                    break;
            }
        } catch (FTException e) {
            e.printStackTrace();
            showMessage("Get slot status failed.\n" + e.getMessage());
        }
    }

    //Give the card instructions.
    void readerxfr(){
        doInBackground(new Runnable() {
            @Override
            public void run() {
                try {
                    String sendStr = (String)spinner_Instruction.getSelectedItem();
                    showMessage("XFR send : " + sendStr);
                    byte[] send = Utility.hexStrToBytes(sendStr);
                    long startTime = System.currentTimeMillis();
                    byte[] data = mFtReader.readerXfr(connectedDeviceList.get(connectedReaderIndex),mSlotIndex, send);
                    if(data[0] == 0x61){
                        showMessage("XFR recv : " + Convection.Bytes2HexString(data));
                        showMessage("XFR send : 00C00000");
                        send = Utility.hexStrToBytes("00c00000" + StrUtil.byte2HexStr(data[1]));
                        data = mFtReader.readerXfr(connectedDeviceList.get(connectedReaderIndex),mSlotIndex, send);
                    }
                    long endTime = System.currentTimeMillis();
                    showMessage("XFR recv : " + Convection.Bytes2HexString(data) + " (" + (endTime - startTime) + "ms)");
                    btn_SendCMD.setEnabled(true);
                } catch (FTException e) {
                    e.printStackTrace();
                    showMessage("XFR failed.\n" + e.getMessage());
                    btn_SendCMD.setEnabled(true);
                }
            }
        });
    }

    //Give the reader instructions.
    void readerescape(){
        doInBackground(new Runnable() {
            @Override
            public void run() {
                try {
                    String sendStr = text_EscapeCMD.getText().toString();
                    showMessage("ESCAPE send : " + sendStr);
                    byte[] send = Utility.hexStrToBytes(sendStr);
                    long startTime = System.currentTimeMillis();
                    byte[] data = mFtReader.readerEscape(connectedDeviceList.get(connectedReaderIndex), send);
                    long endTime = System.currentTimeMillis();
                    showMessage("ESCAPE recv : " + Convection.Bytes2HexString(data) + " (" + (endTime - startTime) + "ms)");
                } catch (FTException e) {
                    e.printStackTrace();
                    showMessage("ESCAPE failed.\n" + e.getMessage());
                }
            }
        });
    }

    void getUid(){
        doInBackground(new Runnable() {
            @Override
            public void run() {
                try {
                    byte[] uid = mFtReader.readerGetUID(connectedDeviceList.get(connectedReaderIndex));
                    showMessage("Uid : " + Utility.bytes2HexStr(uid));
                } catch (FTException e) {
                    e.printStackTrace();
                    showMessage("Get uid failed.\n" + e.getMessage());
                }
            }
        });
    }

    void readerWriteFlash() throws IOException {
        InputStream is = getAssets().open("flash.txt");
        int lenght = is.available();
        byte[]  buffer = new byte[lenght];
        is.read(buffer);
        byte[] finalBuffer = Convection.hexString2Bytes(new String(buffer));
        int finalLenght = finalBuffer.length;
        doInBackground(new Runnable() {
            @Override
            public void run() {
                try {
                    mFtReader.readerWriteFlash(connectedDeviceList.get(connectedReaderIndex), finalLenght, finalBuffer);
                    if (Convection.Bytes2HexString(finalBuffer).substring(20,24).equals("9000")){
                        showMessage("WriteFlash : Success!" );
                    }else {
                        showMessage("WriteFlash failed." );
                    }
                    if (Convection.Bytes2HexString(finalBuffer).substring(20,24).equals("1234")){
                        showMessage("Recv:"+ Convection.Bytes2HexString(finalBuffer).substring(0,20));
                    }else {
                        showMessage("Recv:"+ Convection.Bytes2HexString(finalBuffer).substring(0,24));
                    }
                } catch (FTException e) {
                    e.printStackTrace();
                    showMessage("WriteFlash failed.\n" + e.getMessage());
                }
            }
        });
    }


    void readerReadFlash() {
        byte[] outData = new byte[257];
        doInBackground(new Runnable() {
            @Override
            public void run() {
                try {
                    mFtReader.readerReadFlash(connectedDeviceList.get(connectedReaderIndex),outData);
                    String str_outData = Convection.Bytes2HexString(outData);
                    if (str_outData.endsWith("9000")){
                        showMessage("ReadFlash : Success!");
                        showMessage("Recv:" + str_outData.substring(0,str_outData.length()-4) + "\nLength:" + (str_outData.length()/2-2));
                    }else{
                        showMessage("ReadFlash failed!");
                        if (str_outData.substring(20,24).equals("1234")){
                            showMessage("Recv:" + str_outData.substring(0,20));
                        }else {
                            showMessage("Recv:" + str_outData.substring(0,24));
                        }
                    }
                } catch (FTException e) {
                    e.printStackTrace();
                    showMessage("ReadFlash failed.\n" + e.getMessage());
                }
            }
        });
    }

    String getReaderName(){
        try {
            byte[] readerName = mFtReader.readerGetReaderName(connectedDeviceList.get(connectedReaderIndex));
            String rederNameStr = Convection.convertHexToString(Convection.Bytes2HexString(readerName));
            return rederNameStr;
        } catch (FTException e) {
            e.printStackTrace();
        }
        return null;
    }

    private void showPopupWindow() {
        LayoutInflater inflater = LayoutInflater.from(CardReaderManagertActivity.this); // Get LayoutInflater object
        popView = inflater.inflate(R.layout.layout_log, null); // Get layout manager
        btn_LogBack = popView.findViewById(R.id.btn_LogBack);
        btn_LogBack.setOnClickListener(this);
        btn_sendMail = popView.findViewById(R.id.btn_sendmail);
        text_in_recipient = (EditText) popView.findViewById(R.id.in_recipient);
        text_in_ccperson = (EditText) popView.findViewById(R.id.in_ccperson);
        text_in_bccperson = popView.findViewById(R.id.in_bccperson);

        mImageView = popView.findViewById(R.id.img_test);
        // Transform to BitmapDrawable object
        BitmapDrawable bmpDraw=new BitmapDrawable(mBitmap);
        // Display the Bitmap
        mImageView.setImageDrawable(bmpDraw);

        text_in_theme = (EditText) popView.findViewById(R.id.in_theme);
        text_in_message = (EditText) popView.findViewById(R.id.in_message);
        text_in_message.setText("SDK Version:" + mFtReader.getSDKVersion()+"\n");
        text_in_message.append("\nFirmware Version:" + getreaderfirmversion());
        btn_sendMail.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String recipient = text_in_recipient.getText().toString();
                String theme = text_in_theme.getText().toString();
                String message = text_in_message.getText().toString();
                String ccPerson = text_in_ccperson.getText().toString();
                String bccPerson = text_in_bccperson.getText().toString();
                Intent email = new Intent(Intent.ACTION_SEND_MULTIPLE);
                email.putExtra(Intent.EXTRA_EMAIL, new String[]{ recipient});
                email.putExtra(Intent.EXTRA_CC, new String[]{ ccPerson});
                email.putExtra(Intent.EXTRA_BCC, new String[]{bccPerson});
                email.putExtra(Intent.EXTRA_SUBJECT, theme);
                email.putExtra(Intent.EXTRA_TEXT, message);
                ArrayList fileUris = new ArrayList();
                fileUris.add(Uri.fromFile(mFileAttachment));
                fileUris.add(Uri.fromFile(new File(LauncherActivity.logcatHelper.getFilePath())));
                email.putParcelableArrayListExtra(Intent.EXTRA_STREAM, fileUris);
                //need this to prompts email client only
                email.setType("image/*");
                email.setType("message/rfc822");
                startActivity(Intent.createChooser(email, "Choose an Email client :"));
            }
        });
        popWin = new PopupWindow(popView, ViewGroup.LayoutParams.FILL_PARENT, ViewGroup.LayoutParams.FILL_PARENT, true); // Instantiate a PopupWindow
        // Set popup&dismiss effect of PopupWindow
        popWin.setAnimationStyle(R.style.popupAnimation);
        popWin.setOutsideTouchable(false);// Ignored if touch outside
        popWin.setOnDismissListener(new PopupWindow.OnDismissListener() {
            @Override
            public void onDismiss() {
                btn_log.setEnabled(true);
            }
        }); //Handle PopupWindow's dismiss event
		
        // Set position offset, relative to its parent (e.g. Gravity.CENTER，Gravity.BOTTOM, etc.）
        popWin.showAtLocation(btn_log, Gravity.BOTTOM, 0, 0); // Show the popup window
    }

    String getreaderfirmversion(){
        String version = null;
        try {
            version = mFtReader.readerGetFirmwareVersion(connectedDeviceList.get(connectedReaderIndex));
        } catch (FTException e) {
            e.printStackTrace();
        }
        return version;
    }

    //Save the bitmap to a specified path
    public void saveMyBitmap(Bitmap bitmap) {
        File appDir = null;
        if (Environment.getExternalStorageState().equals(
                Environment.MEDIA_MOUNTED)) {// Save to SD card is prior
            appDir = new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS),"FeedBackFiles");
        } else {// If SDK card is absent, then try to save it to App directory
            appDir = new File(mContext.getFilesDir().getAbsolutePath()
                    + "/FeedBackFiles/");
        }
        if (!appDir.exists()) {// Create if doesn't exist
            appDir.mkdir();
        }
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyyMMddHHmmssSSS");// HH:mm:ss
        String fileName = "feedback" +  simpleDateFormat.format(new Date()) + ".jpg";
        File file = new File(appDir, fileName);
        try {
            FileOutputStream fos = new FileOutputStream(file);
            bitmap.compress(Bitmap.CompressFormat.JPEG, 100, fos);
            fos.flush();
            fos.close();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        Intent intent = new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE);
        Uri uri = Uri.fromFile(file);
        intent.setData(uri);
        mFileAttachment = file;
        mContext.sendBroadcast(intent);
    }

    /**
     * Retrieve and save current screen snapshot
     */
    private void GetandSaveCurrentImage()
    {
        mBitmap = null;
        // Get the bottom view of the window
        View view=getWindow().getDecorView();
        view.buildDrawingCache();
        // Status bar height
        Rect rect=new Rect();
        view.getWindowVisibleDisplayFrame(rect);
        int stateBarHeight=rect.top;
        Display display=getWindowManager().getDefaultDisplay();
        // Get screen width and height
        int widths=display.getWidth();
        int height=display.getHeight();
        // Allow current window to cache info
        view.setDrawingCacheEnabled(true);
        // remove status height
        Bitmap bitmap=Bitmap.createBitmap(view.getDrawingCache(),0,0,widths,height);
        view.destroyDrawingCache();
        // Save the bitmap
        if (bitmap != null){
            mBitmap = bitmap;
            saveMyBitmap(mBitmap);
        }
    }

    int getDeviceType(){
        int type = -1;
        try {
            type = mFtReader.readerGetType(connectedDeviceList.get(connectedReaderIndex));
            Log.e(TAG,"Reader Type："+type);
        } catch (FTException e) {
            e.printStackTrace();
        }
        return type;
    }

    private void addConnectedSpinnerPrivate(String devName){
        ArrayAdapter<String> arr_adapter = (ArrayAdapter<String>)(((Spinner)findViewById(R.id.sp_connectedDevices)).getAdapter());
        if(arr_adapter == null){
            arr_adapter = new ArrayAdapter<String>(CardReaderManagertActivity.this, R.layout.spinner_item, new ArrayList<String>());
        }
        arr_adapter.add(devName);
        ((Spinner)findViewById(R.id.sp_connectedDevices)).setAdapter(arr_adapter);
    }

    private void addConnectedSpinnerPrivate(List<String> devNameArray){
        ArrayAdapter<String> arr_adapter = (ArrayAdapter<String>)(((Spinner)findViewById(R.id.sp_connectedDevices)).getAdapter());
        if(arr_adapter != null){
            arr_adapter.clear();
        }
        for (String devName : devNameArray) {
            if(devName != null) {
                addConnectedSpinnerPrivate(devName);
            }
        }
    }

    private void addCardSlotSpinnerPrivate(String devName){
        ArrayAdapter<String> arr_adapter = (ArrayAdapter<String>)(((Spinner)findViewById(R.id.sp_cardSlot)).getAdapter());
        if(arr_adapter == null){
            arr_adapter = new ArrayAdapter<String>(CardReaderManagertActivity.this, R.layout.spinner_item, new ArrayList<String>());
        }
        arr_adapter.add(devName);
        ((Spinner)findViewById(R.id.sp_cardSlot)).setAdapter(arr_adapter);
    }

    private void addCardSlotSpinnerPrivate(String[] devNameArray){
        ArrayAdapter<String> arr_adapter = (ArrayAdapter<String>)(((Spinner)findViewById(R.id.sp_cardSlot)).getAdapter());
        if(arr_adapter != null){
            arr_adapter.clear();
        }
        for (String devName : devNameArray) {
            if(devName != null) {
                addCardSlotSpinnerPrivate(devName);
            }
        }
    }

    // Disable the back button
    @Override
    public void onBackPressed() {
    }

    @Override
    protected void onResume() {
        super.onResume();
        ConnectActivity.connectHandler = mHandler;
    }
}
