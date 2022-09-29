using System;
using System.Collections.Generic;
using Android.Runtime;
using Java.Interop;

namespace Com.Ftsafe.Comm {

	// Metadata.xml XPath class reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='LeBluetoothParsedScanRecord']"
	[global::Android.Runtime.Register ("com/ftsafe/comm/LeBluetoothParsedScanRecord", DoNotGenerateAcw=true)]
	public sealed partial class LeBluetoothParsedScanRecord : global::Java.Lang.Object {

		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='LeBluetoothParsedScanRecord']/field[@name='BASE_UUID']"
		[Register ("BASE_UUID")]
		public static global::Android.OS.ParcelUuid BaseUuid {
			get {
				const string __id = "BASE_UUID.Landroid/os/ParcelUuid;";

				var __v = _members.StaticFields.GetObjectValue (__id);
				return global::Java.Lang.Object.GetObject<global::Android.OS.ParcelUuid> (__v.Handle, JniHandleOwnership.TransferLocalRef);
			}
		}

		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='LeBluetoothParsedScanRecord']/field[@name='UUID_BYTES_128_BIT']"
		[Register ("UUID_BYTES_128_BIT")]
		public const int UuidBytes128Bit = (int) 16;

		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='LeBluetoothParsedScanRecord']/field[@name='UUID_BYTES_16_BIT']"
		[Register ("UUID_BYTES_16_BIT")]
		public const int UuidBytes16Bit = (int) 2;

		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='LeBluetoothParsedScanRecord']/field[@name='UUID_BYTES_32_BIT']"
		[Register ("UUID_BYTES_32_BIT")]
		public const int UuidBytes32Bit = (int) 4;

		static readonly JniPeerMembers _members = new XAPeerMembers ("com/ftsafe/comm/LeBluetoothParsedScanRecord", typeof (LeBluetoothParsedScanRecord));

		internal static IntPtr class_ref {
			get { return _members.JniPeerType.PeerReference.Handle; }
		}

		[global::System.Diagnostics.DebuggerBrowsable (global::System.Diagnostics.DebuggerBrowsableState.Never)]
		[global::System.ComponentModel.EditorBrowsable (global::System.ComponentModel.EditorBrowsableState.Never)]
		public override global::Java.Interop.JniPeerMembers JniPeerMembers {
			get { return _members; }
		}

		[global::System.Diagnostics.DebuggerBrowsable (global::System.Diagnostics.DebuggerBrowsableState.Never)]
		[global::System.ComponentModel.EditorBrowsable (global::System.ComponentModel.EditorBrowsableState.Never)]
		protected override IntPtr ThresholdClass {
			get { return _members.JniPeerType.PeerReference.Handle; }
		}

		[global::System.Diagnostics.DebuggerBrowsable (global::System.Diagnostics.DebuggerBrowsableState.Never)]
		[global::System.ComponentModel.EditorBrowsable (global::System.ComponentModel.EditorBrowsableState.Never)]
		protected override global::System.Type ThresholdType {
			get { return _members.ManagedPeerType; }
		}

		internal LeBluetoothParsedScanRecord (IntPtr javaReference, JniHandleOwnership transfer) : base (javaReference, transfer)
		{
		}

		public unsafe int AdvertiseFlags {
			// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='LeBluetoothParsedScanRecord']/method[@name='getAdvertiseFlags' and count(parameter)=0]"
			[Register ("getAdvertiseFlags", "()I", "")]
			get {
				const string __id = "getAdvertiseFlags.()I";
				try {
					var __rm = _members.InstanceMethods.InvokeAbstractInt32Method (__id, this, null);
					return __rm;
				} finally {
				}
			}
		}

		public unsafe string DeviceName {
			// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='LeBluetoothParsedScanRecord']/method[@name='getDeviceName' and count(parameter)=0]"
			[Register ("getDeviceName", "()Ljava/lang/String;", "")]
			get {
				const string __id = "getDeviceName.()Ljava/lang/String;";
				try {
					var __rm = _members.InstanceMethods.InvokeAbstractObjectMethod (__id, this, null);
					return JNIEnv.GetString (__rm.Handle, JniHandleOwnership.TransferLocalRef);
				} finally {
				}
			}
		}

		public unsafe global::Android.Util.SparseArray ManufacturerSpecificData {
			// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='LeBluetoothParsedScanRecord']/method[@name='getManufacturerSpecificData' and count(parameter)=0]"
			[Register ("getManufacturerSpecificData", "()Landroid/util/SparseArray;", "")]
			get {
				const string __id = "getManufacturerSpecificData.()Landroid/util/SparseArray;";
				try {
					var __rm = _members.InstanceMethods.InvokeAbstractObjectMethod (__id, this, null);
					return global::Java.Lang.Object.GetObject<global::Android.Util.SparseArray> (__rm.Handle, JniHandleOwnership.TransferLocalRef);
				} finally {
				}
			}
		}

		public unsafe global::System.Collections.Generic.IDictionary<global::Android.OS.ParcelUuid, byte[]> ServiceData {
			// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='LeBluetoothParsedScanRecord']/method[@name='getServiceData' and count(parameter)=0]"
			[Register ("getServiceData", "()Ljava/util/Map;", "")]
			get {
				const string __id = "getServiceData.()Ljava/util/Map;";
				try {
					var __rm = _members.InstanceMethods.InvokeAbstractObjectMethod (__id, this, null);
					return global::Android.Runtime.JavaDictionary<global::Android.OS.ParcelUuid, byte[]>.FromJniHandle (__rm.Handle, JniHandleOwnership.TransferLocalRef);
				} finally {
				}
			}
		}

		public unsafe global::System.Collections.Generic.IList<global::Android.OS.ParcelUuid> ServiceUuids {
			// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='LeBluetoothParsedScanRecord']/method[@name='getServiceUuids' and count(parameter)=0]"
			[Register ("getServiceUuids", "()Ljava/util/List;", "")]
			get {
				const string __id = "getServiceUuids.()Ljava/util/List;";
				try {
					var __rm = _members.InstanceMethods.InvokeAbstractObjectMethod (__id, this, null);
					return global::Android.Runtime.JavaList<global::Android.OS.ParcelUuid>.FromJniHandle (__rm.Handle, JniHandleOwnership.TransferLocalRef);
				} finally {
				}
			}
		}

		public unsafe int TxPowerLevel {
			// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='LeBluetoothParsedScanRecord']/method[@name='getTxPowerLevel' and count(parameter)=0]"
			[Register ("getTxPowerLevel", "()I", "")]
			get {
				const string __id = "getTxPowerLevel.()I";
				try {
					var __rm = _members.InstanceMethods.InvokeAbstractInt32Method (__id, this, null);
					return __rm;
				} finally {
				}
			}
		}

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='LeBluetoothParsedScanRecord']/method[@name='getBytes' and count(parameter)=0]"
		[Register ("getBytes", "()[B", "")]
		public unsafe byte[] GetBytes ()
		{
			const string __id = "getBytes.()[B";
			try {
				var __rm = _members.InstanceMethods.InvokeAbstractObjectMethod (__id, this, null);
				return (byte[]) JNIEnv.GetArray (__rm.Handle, JniHandleOwnership.TransferLocalRef, typeof (byte));
			} finally {
			}
		}

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='LeBluetoothParsedScanRecord']/method[@name='getManufacturerSpecificData' and count(parameter)=1 and parameter[1][@type='int']]"
		[Register ("getManufacturerSpecificData", "(I)[B", "")]
		public unsafe byte[] GetManufacturerSpecificData (int manufacturerId)
		{
			const string __id = "getManufacturerSpecificData.(I)[B";
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [1];
				__args [0] = new JniArgumentValue (manufacturerId);
				var __rm = _members.InstanceMethods.InvokeAbstractObjectMethod (__id, this, __args);
				return (byte[]) JNIEnv.GetArray (__rm.Handle, JniHandleOwnership.TransferLocalRef, typeof (byte));
			} finally {
			}
		}

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='LeBluetoothParsedScanRecord']/method[@name='getServiceData' and count(parameter)=1 and parameter[1][@type='android.os.ParcelUuid']]"
		[Register ("getServiceData", "(Landroid/os/ParcelUuid;)[B", "")]
		public unsafe byte[] GetServiceData (global::Android.OS.ParcelUuid serviceDataUuid)
		{
			const string __id = "getServiceData.(Landroid/os/ParcelUuid;)[B";
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [1];
				__args [0] = new JniArgumentValue ((serviceDataUuid == null) ? IntPtr.Zero : ((global::Java.Lang.Object) serviceDataUuid).Handle);
				var __rm = _members.InstanceMethods.InvokeAbstractObjectMethod (__id, this, __args);
				return (byte[]) JNIEnv.GetArray (__rm.Handle, JniHandleOwnership.TransferLocalRef, typeof (byte));
			} finally {
				global::System.GC.KeepAlive (serviceDataUuid);
			}
		}

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='LeBluetoothParsedScanRecord']/method[@name='parseFromBytes' and count(parameter)=1 and parameter[1][@type='byte[]']]"
		[Register ("parseFromBytes", "([B)Lcom/ftsafe/comm/LeBluetoothParsedScanRecord;", "")]
		public static unsafe global::Com.Ftsafe.Comm.LeBluetoothParsedScanRecord ParseFromBytes (byte[] scanRecord)
		{
			const string __id = "parseFromBytes.([B)Lcom/ftsafe/comm/LeBluetoothParsedScanRecord;";
			IntPtr native_scanRecord = JNIEnv.NewArray (scanRecord);
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [1];
				__args [0] = new JniArgumentValue (native_scanRecord);
				var __rm = _members.StaticMethods.InvokeObjectMethod (__id, __args);
				return global::Java.Lang.Object.GetObject<global::Com.Ftsafe.Comm.LeBluetoothParsedScanRecord> (__rm.Handle, JniHandleOwnership.TransferLocalRef);
			} finally {
				if (scanRecord != null) {
					JNIEnv.CopyArray (native_scanRecord, scanRecord);
					JNIEnv.DeleteLocalRef (native_scanRecord);
				}
				global::System.GC.KeepAlive (scanRecord);
			}
		}

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='LeBluetoothParsedScanRecord']/method[@name='parseUuidFrom' and count(parameter)=1 and parameter[1][@type='byte[]']]"
		[Register ("parseUuidFrom", "([B)Landroid/os/ParcelUuid;", "")]
		public static unsafe global::Android.OS.ParcelUuid ParseUuidFrom (byte[] uuidBytes)
		{
			const string __id = "parseUuidFrom.([B)Landroid/os/ParcelUuid;";
			IntPtr native_uuidBytes = JNIEnv.NewArray (uuidBytes);
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [1];
				__args [0] = new JniArgumentValue (native_uuidBytes);
				var __rm = _members.StaticMethods.InvokeObjectMethod (__id, __args);
				return global::Java.Lang.Object.GetObject<global::Android.OS.ParcelUuid> (__rm.Handle, JniHandleOwnership.TransferLocalRef);
			} finally {
				if (uuidBytes != null) {
					JNIEnv.CopyArray (native_uuidBytes, uuidBytes);
					JNIEnv.DeleteLocalRef (native_uuidBytes);
				}
				global::System.GC.KeepAlive (uuidBytes);
			}
		}

	}
}
