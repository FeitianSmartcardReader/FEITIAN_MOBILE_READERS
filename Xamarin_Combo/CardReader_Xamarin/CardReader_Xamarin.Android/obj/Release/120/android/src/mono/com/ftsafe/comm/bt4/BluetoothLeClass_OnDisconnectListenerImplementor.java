package mono.com.ftsafe.comm.bt4;


public class BluetoothLeClass_OnDisconnectListenerImplementor
	extends java.lang.Object
	implements
		mono.android.IGCUserPeer,
		com.ftsafe.comm.bt4.BluetoothLeClass.OnDisconnectListener
{
/** @hide */
	public static final String __md_methods;
	static {
		__md_methods = 
			"n_onDisconnect:(Landroid/bluetooth/BluetoothGatt;)V:GetOnDisconnect_Landroid_bluetooth_BluetoothGatt_Handler:Com.Ftsafe.Comm.Bt4.BluetoothLeClass/IOnDisconnectListenerInvoker, CardReaderLibrary\n" +
			"";
		mono.android.Runtime.register ("Com.Ftsafe.Comm.Bt4.BluetoothLeClass+IOnDisconnectListenerImplementor, CardReaderLibrary", BluetoothLeClass_OnDisconnectListenerImplementor.class, __md_methods);
	}


	public BluetoothLeClass_OnDisconnectListenerImplementor ()
	{
		super ();
		if (getClass () == BluetoothLeClass_OnDisconnectListenerImplementor.class) {
			mono.android.TypeManager.Activate ("Com.Ftsafe.Comm.Bt4.BluetoothLeClass+IOnDisconnectListenerImplementor, CardReaderLibrary", "", this, new java.lang.Object[] {  });
		}
	}


	public void onDisconnect (android.bluetooth.BluetoothGatt p0)
	{
		n_onDisconnect (p0);
	}

	private native void n_onDisconnect (android.bluetooth.BluetoothGatt p0);

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
