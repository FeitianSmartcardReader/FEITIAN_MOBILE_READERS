package mono.com.ftsafe.comm.bt4;


public class BluetoothLeClass_OnDataAvailableListenerImplementor
	extends java.lang.Object
	implements
		mono.android.IGCUserPeer,
		com.ftsafe.comm.bt4.BluetoothLeClass.OnDataAvailableListener
{
/** @hide */
	public static final String __md_methods;
	static {
		__md_methods = 
			"n_onCharacteristicChanged:(Landroid/bluetooth/BluetoothGatt;Landroid/bluetooth/BluetoothGattCharacteristic;)V:GetOnCharacteristicChanged_Landroid_bluetooth_BluetoothGatt_Landroid_bluetooth_BluetoothGattCharacteristic_Handler:Com.Ftsafe.Comm.Bt4.BluetoothLeClass/IOnDataAvailableListenerInvoker, CardReaderLibrary\n" +
			"n_onCharacteristicRead:(Landroid/bluetooth/BluetoothGatt;Landroid/bluetooth/BluetoothGattCharacteristic;I)V:GetOnCharacteristicRead_Landroid_bluetooth_BluetoothGatt_Landroid_bluetooth_BluetoothGattCharacteristic_IHandler:Com.Ftsafe.Comm.Bt4.BluetoothLeClass/IOnDataAvailableListenerInvoker, CardReaderLibrary\n" +
			"";
		mono.android.Runtime.register ("Com.Ftsafe.Comm.Bt4.BluetoothLeClass+IOnDataAvailableListenerImplementor, CardReaderLibrary", BluetoothLeClass_OnDataAvailableListenerImplementor.class, __md_methods);
	}


	public BluetoothLeClass_OnDataAvailableListenerImplementor ()
	{
		super ();
		if (getClass () == BluetoothLeClass_OnDataAvailableListenerImplementor.class) {
			mono.android.TypeManager.Activate ("Com.Ftsafe.Comm.Bt4.BluetoothLeClass+IOnDataAvailableListenerImplementor, CardReaderLibrary", "", this, new java.lang.Object[] {  });
		}
	}


	public void onCharacteristicChanged (android.bluetooth.BluetoothGatt p0, android.bluetooth.BluetoothGattCharacteristic p1)
	{
		n_onCharacteristicChanged (p0, p1);
	}

	private native void n_onCharacteristicChanged (android.bluetooth.BluetoothGatt p0, android.bluetooth.BluetoothGattCharacteristic p1);


	public void onCharacteristicRead (android.bluetooth.BluetoothGatt p0, android.bluetooth.BluetoothGattCharacteristic p1, int p2)
	{
		n_onCharacteristicRead (p0, p1, p2);
	}

	private native void n_onCharacteristicRead (android.bluetooth.BluetoothGatt p0, android.bluetooth.BluetoothGattCharacteristic p1, int p2);

	private java.util.ArrayList refList;
	public void monodroidAddReference (java.lang.Object obj)
	{
		if (refList == null)
			refList = new java.util.ArrayList ();
		refList.add (obj);
	}

	public void monodroidClearReferences ()
	{
		if (refList != null)
			refList.clear ();
	}
}
