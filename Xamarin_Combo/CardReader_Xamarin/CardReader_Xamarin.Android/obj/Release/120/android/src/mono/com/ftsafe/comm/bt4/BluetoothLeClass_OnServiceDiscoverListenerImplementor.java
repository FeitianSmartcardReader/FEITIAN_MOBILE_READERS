package mono.com.ftsafe.comm.bt4;


public class BluetoothLeClass_OnServiceDiscoverListenerImplementor
	extends java.lang.Object
	implements
		mono.android.IGCUserPeer,
		com.ftsafe.comm.bt4.BluetoothLeClass.OnServiceDiscoverListener
{
/** @hide */
	public static final String __md_methods;
	static {
		__md_methods = 
			"n_onServiceDiscover:(Landroid/bluetooth/BluetoothGatt;)V:GetOnServiceDiscover_Landroid_bluetooth_BluetoothGatt_Handler:Com.Ftsafe.Comm.Bt4.BluetoothLeClass/IOnServiceDiscoverListenerInvoker, CardReaderLibrary\n" +
			"";
		mono.android.Runtime.register ("Com.Ftsafe.Comm.Bt4.BluetoothLeClass+IOnServiceDiscoverListenerImplementor, CardReaderLibrary", BluetoothLeClass_OnServiceDiscoverListenerImplementor.class, __md_methods);
	}


	public BluetoothLeClass_OnServiceDiscoverListenerImplementor ()
	{
		super ();
		if (getClass () == BluetoothLeClass_OnServiceDiscoverListenerImplementor.class) {
			mono.android.TypeManager.Activate ("Com.Ftsafe.Comm.Bt4.BluetoothLeClass+IOnServiceDiscoverListenerImplementor, CardReaderLibrary", "", this, new java.lang.Object[] {  });
		}
	}


	public void onServiceDiscover (android.bluetooth.BluetoothGatt p0)
	{
		n_onServiceDiscover (p0);
	}

	private native void n_onServiceDiscover (android.bluetooth.BluetoothGatt p0);

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
