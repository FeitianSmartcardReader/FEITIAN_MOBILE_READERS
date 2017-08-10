

package com.example.ftbtdemo;


import android.bluetooth.BluetoothDevice;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Handler;
import android.widget.Toast;

public class BlueToothReceiver extends BroadcastReceiver
{
	private static Handler mHandle = null;
	
	public static final int BLETOOTH_STATUS        = 0xE002;
	public static final int BLETOOTH_CONNECT       = 1;
	public static final int BLETOOTH_DISCONNECT        = 2;

	@Override
	public void onReceive(Context context, Intent intent)
	{
        String action = intent.getAction();
        BluetoothDevice device = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);
        
        if(BluetoothDevice.ACTION_FOUND.equals(action)) 
        {
        	
        }
        else if (BluetoothDevice.ACTION_ACL_CONNECTED.equals(action)) 
        {
            Toast.makeText(context, device.getName() + "Device Connected!", Toast.LENGTH_LONG).show();
			if (mHandle != null) {
//send message to the BlueTooth-Activity that bletooth device is connected!
					mHandle.obtainMessage(BLETOOTH_STATUS,
							BLETOOTH_CONNECT, -1).sendToTarget();
			}
        }
        else if (BluetoothDevice.ACTION_ACL_DISCONNECTED.equals(action)) 
        {
            Toast.makeText(context, device.getName() + "Device Disconnected!", Toast.LENGTH_LONG).show();
			if (mHandle != null) {
				//send message to the BlueTooth-Activity that bletooth device is disconnected!
				mHandle.obtainMessage(BLETOOTH_STATUS,
						BLETOOTH_DISCONNECT, -1).sendToTarget();
			}
        }     

	}
	
	public static int registerCardStatusMonitoring(Handler Handler) {
		
		mHandle = (Handler) Handler;
		return 0;
	}
}
