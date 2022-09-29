package mono.com.ftsafe.comm.bt4;


public class BluetoothLeClass_OnConnectListenerImplementor
	extends java.lang.Object
	implements
		mono.android.IGCUserPeer,
		com.ftsafe.comm.bt4.BluetoothLeClass.OnConnectListener
{
/** @hide */
	public static final String __md_methods;
	static {
		__md_methods = 
			"n_onConnect:(Landroid/bluetooth/BluetoothGatt;)V:GetOnConnect_Landroid_bluetooth_BluetoothGatt_Handler:Com.Ftsafe.Comm.Bt4.BluetoothLeClass/IOnConnectListenerInvoker, CardReaderLibrary\n" +
			"";
		mono.android.Runtime.register ("Com.Ftsafe.Comm.Bt4.BluetoothLeClass+IOnConnectListenerImplementor, CardReaderLibrary", BluetoothLeClass_OnConnectListenerImplementor.class, __md_methods);
	}


	public BluetoothLeClass_OnConnectListenerImplementor ()
	{
		super ();
		if (getClass () == BluetoothLeClass_OnConnectListenerImplementor.class) {
			mono.android.TypeManager.Activate ("Com.Ftsafe.Comm.Bt4.BluetoothLeClass+IOnConnectListenerImplementor, CardReaderLibrary", "", this, new java.lang.Object[] {  });
		}
	}


	public void onConnect (android.bluetooth.BluetoothGatt p0)
	{
		n_onConnect (p0);
	}

	private native void n_onConnect (android.bluetooth.BluetoothGatt p0);

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
