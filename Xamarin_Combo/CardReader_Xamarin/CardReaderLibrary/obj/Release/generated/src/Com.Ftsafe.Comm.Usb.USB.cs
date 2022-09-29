using System;
using System.Collections.Generic;
using Android.Runtime;
using Java.Interop;

namespace Com.Ftsafe.Comm.Usb {

	// Metadata.xml XPath class reference: path="/api/package[@name='com.ftsafe.comm.usb']/class[@name='USB']"
	[global::Android.Runtime.Register ("com/ftsafe/comm/usb/USB", DoNotGenerateAcw=true)]
	public partial class USB : global::Java.Lang.Object, global::Com.Ftsafe.ReaderScheme.IFTReaderInf {

		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe.comm.usb']/class[@name='USB']/field[@name='mUsbDevice']"
		[Register ("mUsbDevice")]
		public global::Android.Hardware.Usb.UsbDevice MUsbDevice {
			get {
				const string __id = "mUsbDevice.Landroid/hardware/usb/UsbDevice;";

				var __v = _members.InstanceFields.GetObjectValue (__id, this);
				return global::Java.Lang.Object.GetObject<global::Android.Hardware.Usb.UsbDevice> (__v.Handle, JniHandleOwnership.TransferLocalRef);
			}
			set {
				const string __id = "mUsbDevice.Landroid/hardware/usb/UsbDevice;";

				IntPtr native_value = global::Android.Runtime.JNIEnv.ToLocalJniHandle (value);
				try {
					_members.InstanceFields.SetValue (__id, this, new JniObjectReference (native_value));
				} finally {
					global::Android.Runtime.JNIEnv.DeleteLocalRef (native_value);
				}
			}
		}


		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe.comm.usb']/class[@name='USB']/field[@name='mUsbDeviceConnection']"
		[Register ("mUsbDeviceConnection")]
		public global::Android.Hardware.Usb.UsbDeviceConnection MUsbDeviceConnection {
			get {
				const string __id = "mUsbDeviceConnection.Landroid/hardware/usb/UsbDeviceConnection;";

				var __v = _members.InstanceFields.GetObjectValue (__id, this);
				return global::Java.Lang.Object.GetObject<global::Android.Hardware.Usb.UsbDeviceConnection> (__v.Handle, JniHandleOwnership.TransferLocalRef);
			}
			set {
				const string __id = "mUsbDeviceConnection.Landroid/hardware/usb/UsbDeviceConnection;";

				IntPtr native_value = global::Android.Runtime.JNIEnv.ToLocalJniHandle (value);
				try {
					_members.InstanceFields.SetValue (__id, this, new JniObjectReference (native_value));
				} finally {
					global::Android.Runtime.JNIEnv.DeleteLocalRef (native_value);
				}
			}
		}

		static readonly JniPeerMembers _members = new XAPeerMembers ("com/ftsafe/comm/usb/USB", typeof (USB));

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

		protected USB (IntPtr javaReference, JniHandleOwnership transfer) : base (javaReference, transfer)
		{
		}

		// Metadata.xml XPath constructor reference: path="/api/package[@name='com.ftsafe.comm.usb']/class[@name='USB']/constructor[@name='USB' and count(parameter)=2 and parameter[1][@type='android.content.Context'] and parameter[2][@type='com.ftsafe.comm.CommBase.CommCallback']]"
		[Register (".ctor", "(Landroid/content/Context;Lcom/ftsafe/comm/CommBase$CommCallback;)V", "")]
		public unsafe USB (global::Android.Content.Context context, global::Com.Ftsafe.Comm.CommBase.ICommCallback @callback) : base (IntPtr.Zero, JniHandleOwnership.DoNotTransfer)
		{
			const string __id = "(Landroid/content/Context;Lcom/ftsafe/comm/CommBase$CommCallback;)V";

			if (((global::Java.Lang.Object) this).Handle != IntPtr.Zero)
				return;

			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [2];
				__args [0] = new JniArgumentValue ((context == null) ? IntPtr.Zero : ((global::Java.Lang.Object) context).Handle);
				__args [1] = new JniArgumentValue ((@callback == null) ? IntPtr.Zero : ((global::Java.Lang.Object) @callback).Handle);
				var __r = _members.InstanceMethods.StartCreateInstance (__id, ((object) this).GetType (), __args);
				SetHandle (__r.Handle, JniHandleOwnership.TransferLocalRef);
				_members.InstanceMethods.FinishCreateInstance (__id, this, __args);
			} finally {
				global::System.GC.KeepAlive (context);
				global::System.GC.KeepAlive (@callback);
			}
		}

		static Delegate cb_getProductName;
#pragma warning disable 0169
		static Delegate GetGetProductNameHandler ()
		{
			if (cb_getProductName == null)
				cb_getProductName = JNINativeWrapper.CreateDelegate ((_JniMarshal_PP_L) n_GetProductName);
			return cb_getProductName;
		}

		static IntPtr n_GetProductName (IntPtr jnienv, IntPtr native__this)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.Comm.Usb.USB> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			return JNIEnv.NewString (__this.ProductName);
		}
#pragma warning restore 0169

		public virtual unsafe string ProductName {
			// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm.usb']/class[@name='USB']/method[@name='getProductName' and count(parameter)=0]"
			[Register ("getProductName", "()Ljava/lang/String;", "GetGetProductNameHandler")]
			get {
				const string __id = "getProductName.()Ljava/lang/String;";
				try {
					var __rm = _members.InstanceMethods.InvokeVirtualObjectMethod (__id, this, null);
					return JNIEnv.GetString (__rm.Handle, JniHandleOwnership.TransferLocalRef);
				} finally {
				}
			}
		}

		static Delegate cb_getSlotIndex;
#pragma warning disable 0169
		static Delegate GetGetSlotIndexHandler ()
		{
			if (cb_getSlotIndex == null)
				cb_getSlotIndex = JNINativeWrapper.CreateDelegate ((_JniMarshal_PP_I) n_GetSlotIndex);
			return cb_getSlotIndex;
		}

		static int n_GetSlotIndex (IntPtr jnienv, IntPtr native__this)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.Comm.Usb.USB> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			return __this.SlotIndex;
		}
#pragma warning restore 0169

		static Delegate cb_setSlotIndex_I;
#pragma warning disable 0169
		static Delegate GetSetSlotIndex_IHandler ()
		{
			if (cb_setSlotIndex_I == null)
				cb_setSlotIndex_I = JNINativeWrapper.CreateDelegate ((_JniMarshal_PPI_V) n_SetSlotIndex_I);
			return cb_setSlotIndex_I;
		}

		static void n_SetSlotIndex_I (IntPtr jnienv, IntPtr native__this, int slotIndex)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.Comm.Usb.USB> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			__this.SlotIndex = slotIndex;
		}
#pragma warning restore 0169

		public virtual unsafe int SlotIndex {
			// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm.usb']/class[@name='USB']/method[@name='getSlotIndex' and count(parameter)=0]"
			[Register ("getSlotIndex", "()I", "GetGetSlotIndexHandler")]
			get {
				const string __id = "getSlotIndex.()I";
				try {
					var __rm = _members.InstanceMethods.InvokeVirtualInt32Method (__id, this, null);
					return __rm;
				} finally {
				}
			}
			// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm.usb']/class[@name='USB']/method[@name='setSlotIndex' and count(parameter)=1 and parameter[1][@type='int']]"
			[Register ("setSlotIndex", "(I)V", "GetSetSlotIndex_IHandler")]
			set {
				const string __id = "setSlotIndex.(I)V";
				try {
					JniArgumentValue* __args = stackalloc JniArgumentValue [1];
					__args [0] = new JniArgumentValue (value);
					_members.InstanceMethods.InvokeVirtualVoidMethod (__id, this, __args);
				} finally {
				}
			}
		}

		static Delegate cb_ft_close;
#pragma warning disable 0169
		static Delegate GetFt_closeHandler ()
		{
			if (cb_ft_close == null)
				cb_ft_close = JNINativeWrapper.CreateDelegate ((_JniMarshal_PP_V) n_Ft_close);
			return cb_ft_close;
		}

		static void n_Ft_close (IntPtr jnienv, IntPtr native__this)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.Comm.Usb.USB> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			__this.Ft_close ();
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm.usb']/class[@name='USB']/method[@name='ft_close' and count(parameter)=0]"
		[Register ("ft_close", "()V", "GetFt_closeHandler")]
		public virtual unsafe void Ft_close ()
		{
			const string __id = "ft_close.()V";
			try {
				_members.InstanceMethods.InvokeVirtualVoidMethod (__id, this, null);
			} finally {
			}
		}

		static Delegate cb_ft_control_IIIIII;
#pragma warning disable 0169
		static Delegate GetFt_control_IIIIIIHandler ()
		{
			if (cb_ft_control_IIIIII == null)
				cb_ft_control_IIIIII = JNINativeWrapper.CreateDelegate ((_JniMarshal_PPIIIIII_L) n_Ft_control_IIIIII);
			return cb_ft_control_IIIIII;
		}

		static IntPtr n_Ft_control_IIIIII (IntPtr jnienv, IntPtr native__this, int requestType, int request, int value, int index, int length, int timeOut)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.Comm.Usb.USB> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			return JNIEnv.NewArray (__this.Ft_control (requestType, request, value, index, length, timeOut));
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm.usb']/class[@name='USB']/method[@name='ft_control' and count(parameter)=6 and parameter[1][@type='int'] and parameter[2][@type='int'] and parameter[3][@type='int'] and parameter[4][@type='int'] and parameter[5][@type='int'] and parameter[6][@type='int']]"
		[Register ("ft_control", "(IIIIII)[B", "GetFt_control_IIIIIIHandler")]
		public virtual unsafe byte[] Ft_control (int requestType, int request, int value, int index, int length, int timeOut)
		{
			const string __id = "ft_control.(IIIIII)[B";
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [6];
				__args [0] = new JniArgumentValue (requestType);
				__args [1] = new JniArgumentValue (request);
				__args [2] = new JniArgumentValue (value);
				__args [3] = new JniArgumentValue (index);
				__args [4] = new JniArgumentValue (length);
				__args [5] = new JniArgumentValue (timeOut);
				var __rm = _members.InstanceMethods.InvokeVirtualObjectMethod (__id, this, __args);
				return (byte[]) JNIEnv.GetArray (__rm.Handle, JniHandleOwnership.TransferLocalRef, typeof (byte));
			} finally {
			}
		}

		static Delegate cb_ft_find;
#pragma warning disable 0169
		static Delegate GetFt_findHandler ()
		{
			if (cb_ft_find == null)
				cb_ft_find = JNINativeWrapper.CreateDelegate ((_JniMarshal_PP_V) n_Ft_find);
			return cb_ft_find;
		}

		static void n_Ft_find (IntPtr jnienv, IntPtr native__this)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.Comm.Usb.USB> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			__this.Ft_find ();
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm.usb']/class[@name='USB']/method[@name='ft_find' and count(parameter)=0]"
		[Register ("ft_find", "()V", "GetFt_findHandler")]
		public virtual unsafe void Ft_find ()
		{
			const string __id = "ft_find.()V";
			try {
				_members.InstanceMethods.InvokeVirtualVoidMethod (__id, this, null);
			} finally {
			}
		}

		static Delegate cb_ft_open_Ljava_lang_Object_;
#pragma warning disable 0169
		static Delegate GetFt_open_Ljava_lang_Object_Handler ()
		{
			if (cb_ft_open_Ljava_lang_Object_ == null)
				cb_ft_open_Ljava_lang_Object_ = JNINativeWrapper.CreateDelegate ((_JniMarshal_PPL_V) n_Ft_open_Ljava_lang_Object_);
			return cb_ft_open_Ljava_lang_Object_;
		}

		static void n_Ft_open_Ljava_lang_Object_ (IntPtr jnienv, IntPtr native__this, IntPtr native_device)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.Comm.Usb.USB> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			var device = global::Java.Lang.Object.GetObject<global::Java.Lang.Object> (native_device, JniHandleOwnership.DoNotTransfer);
			__this.Ft_open (device);
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm.usb']/class[@name='USB']/method[@name='ft_open' and count(parameter)=1 and parameter[1][@type='java.lang.Object']]"
		[Register ("ft_open", "(Ljava/lang/Object;)V", "GetFt_open_Ljava_lang_Object_Handler")]
		public virtual unsafe void Ft_open (global::Java.Lang.Object device)
		{
			const string __id = "ft_open.(Ljava/lang/Object;)V";
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [1];
				__args [0] = new JniArgumentValue ((device == null) ? IntPtr.Zero : ((global::Java.Lang.Object) device).Handle);
				_members.InstanceMethods.InvokeVirtualVoidMethod (__id, this, __args);
			} finally {
				global::System.GC.KeepAlive (device);
			}
		}

		static Delegate cb_ft_recv_II;
#pragma warning disable 0169
		static Delegate GetFt_recv_IIHandler ()
		{
			if (cb_ft_recv_II == null)
				cb_ft_recv_II = JNINativeWrapper.CreateDelegate ((_JniMarshal_PPII_L) n_Ft_recv_II);
			return cb_ft_recv_II;
		}

		static IntPtr n_Ft_recv_II (IntPtr jnienv, IntPtr native__this, int @in, int timeOut)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.Comm.Usb.USB> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			return JNIEnv.NewArray (__this.Ft_recv (@in, timeOut));
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm.usb']/class[@name='USB']/method[@name='ft_recv' and count(parameter)=2 and parameter[1][@type='int'] and parameter[2][@type='int']]"
		[Register ("ft_recv", "(II)[B", "GetFt_recv_IIHandler")]
		public virtual unsafe byte[] Ft_recv (int @in, int timeOut)
		{
			const string __id = "ft_recv.(II)[B";
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [2];
				__args [0] = new JniArgumentValue (@in);
				__args [1] = new JniArgumentValue (timeOut);
				var __rm = _members.InstanceMethods.InvokeVirtualObjectMethod (__id, this, __args);
				return (byte[]) JNIEnv.GetArray (__rm.Handle, JniHandleOwnership.TransferLocalRef, typeof (byte));
			} finally {
			}
		}

		static Delegate cb_ft_send_IarrayBI;
#pragma warning disable 0169
		static Delegate GetFt_send_IarrayBIHandler ()
		{
			if (cb_ft_send_IarrayBI == null)
				cb_ft_send_IarrayBI = JNINativeWrapper.CreateDelegate ((_JniMarshal_PPILI_V) n_Ft_send_IarrayBI);
			return cb_ft_send_IarrayBI;
		}

		static void n_Ft_send_IarrayBI (IntPtr jnienv, IntPtr native__this, int @out, IntPtr native_writeDataBuff, int timeOut)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.Comm.Usb.USB> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			var writeDataBuff = (byte[]) JNIEnv.GetArray (native_writeDataBuff, JniHandleOwnership.DoNotTransfer, typeof (byte));
			__this.Ft_send (@out, writeDataBuff, timeOut);
			if (writeDataBuff != null)
				JNIEnv.CopyArray (writeDataBuff, native_writeDataBuff);
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm.usb']/class[@name='USB']/method[@name='ft_send' and count(parameter)=3 and parameter[1][@type='int'] and parameter[2][@type='byte[]'] and parameter[3][@type='int']]"
		[Register ("ft_send", "(I[BI)V", "GetFt_send_IarrayBIHandler")]
		public virtual unsafe void Ft_send (int @out, byte[] writeDataBuff, int timeOut)
		{
			const string __id = "ft_send.(I[BI)V";
			IntPtr native_writeDataBuff = JNIEnv.NewArray (writeDataBuff);
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [3];
				__args [0] = new JniArgumentValue (@out);
				__args [1] = new JniArgumentValue (native_writeDataBuff);
				__args [2] = new JniArgumentValue (timeOut);
				_members.InstanceMethods.InvokeVirtualVoidMethod (__id, this, __args);
			} finally {
				if (writeDataBuff != null) {
					JNIEnv.CopyArray (native_writeDataBuff, writeDataBuff);
					JNIEnv.DeleteLocalRef (native_writeDataBuff);
				}
				global::System.GC.KeepAlive (writeDataBuff);
			}
		}

		static Delegate cb_isFtExist;
#pragma warning disable 0169
		static Delegate GetIsFtExistHandler ()
		{
			if (cb_isFtExist == null)
				cb_isFtExist = JNINativeWrapper.CreateDelegate ((_JniMarshal_PP_L) n_IsFtExist);
			return cb_isFtExist;
		}

		static IntPtr n_IsFtExist (IntPtr jnienv, IntPtr native__this)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.Comm.Usb.USB> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			return JNIEnv.ToLocalJniHandle (__this.IsFtExist ());
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm.usb']/class[@name='USB']/method[@name='isFtExist' and count(parameter)=0]"
		[Register ("isFtExist", "()Ljava/lang/Boolean;", "GetIsFtExistHandler")]
		public virtual unsafe global::Java.Lang.Boolean IsFtExist ()
		{
			const string __id = "isFtExist.()Ljava/lang/Boolean;";
			try {
				var __rm = _members.InstanceMethods.InvokeVirtualObjectMethod (__id, this, null);
				return global::Java.Lang.Object.GetObject<global::Java.Lang.Boolean> (__rm.Handle, JniHandleOwnership.TransferLocalRef);
			} finally {
			}
		}

	}
}
