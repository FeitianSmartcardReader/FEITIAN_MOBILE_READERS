using System;
using System.Collections.Generic;
using Android.Runtime;
using Java.Interop;

namespace Com.Ftsafe.ReaderScheme {

	// Metadata.xml XPath class reference: path="/api/package[@name='com.ftsafe.readerScheme']/class[@name='FTReader']"
	[global::Android.Runtime.Register ("com/ftsafe/readerScheme/FTReader", DoNotGenerateAcw=true)]
	public partial class FTReader : global::Java.Lang.Object {
		static readonly JniPeerMembers _members = new XAPeerMembers ("com/ftsafe/readerScheme/FTReader", typeof (FTReader));

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

		protected FTReader (IntPtr javaReference, JniHandleOwnership transfer) : base (javaReference, transfer)
		{
		}

		// Metadata.xml XPath constructor reference: path="/api/package[@name='com.ftsafe.readerScheme']/class[@name='FTReader']/constructor[@name='FTReader' and count(parameter)=3 and parameter[1][@type='android.content.Context'] and parameter[2][@type='android.os.Handler'] and parameter[3][@type='int']]"
		[Register (".ctor", "(Landroid/content/Context;Landroid/os/Handler;I)V", "")]
		public unsafe FTReader (global::Android.Content.Context context, global::Android.OS.Handler handler, int FTREADER_TYPE) : base (IntPtr.Zero, JniHandleOwnership.DoNotTransfer)
		{
			const string __id = "(Landroid/content/Context;Landroid/os/Handler;I)V";

			if (((global::Java.Lang.Object) this).Handle != IntPtr.Zero)
				return;

			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [3];
				__args [0] = new JniArgumentValue ((context == null) ? IntPtr.Zero : ((global::Java.Lang.Object) context).Handle);
				__args [1] = new JniArgumentValue ((handler == null) ? IntPtr.Zero : ((global::Java.Lang.Object) handler).Handle);
				__args [2] = new JniArgumentValue (FTREADER_TYPE);
				var __r = _members.InstanceMethods.StartCreateInstance (__id, ((object) this).GetType (), __args);
				SetHandle (__r.Handle, JniHandleOwnership.TransferLocalRef);
				_members.InstanceMethods.FinishCreateInstance (__id, this, __args);
			} finally {
				global::System.GC.KeepAlive (context);
				global::System.GC.KeepAlive (handler);
			}
		}

		static Delegate cb_getBleFirmwareVersion;
#pragma warning disable 0169
		static Delegate GetGetBleFirmwareVersionHandler ()
		{
			if (cb_getBleFirmwareVersion == null)
				cb_getBleFirmwareVersion = JNINativeWrapper.CreateDelegate ((_JniMarshal_PP_L) n_GetBleFirmwareVersion);
			return cb_getBleFirmwareVersion;
		}

		static IntPtr n_GetBleFirmwareVersion (IntPtr jnienv, IntPtr native__this)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.ReaderScheme.FTReader> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			return JNIEnv.NewString (__this.BleFirmwareVersion);
		}
#pragma warning restore 0169

		public virtual unsafe string BleFirmwareVersion {
			// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.readerScheme']/class[@name='FTReader']/method[@name='getBleFirmwareVersion' and count(parameter)=0]"
			[Register ("getBleFirmwareVersion", "()Ljava/lang/String;", "GetGetBleFirmwareVersionHandler")]
			get {
				const string __id = "getBleFirmwareVersion.()Ljava/lang/String;";
				try {
					var __rm = _members.InstanceMethods.InvokeVirtualObjectMethod (__id, this, null);
					return JNIEnv.GetString (__rm.Handle, JniHandleOwnership.TransferLocalRef);
				} finally {
				}
			}
		}

		static Delegate cb_FT_AutoTurnOffReader_Z;
#pragma warning disable 0169
		static Delegate GetFT_AutoTurnOffReader_ZHandler ()
		{
			if (cb_FT_AutoTurnOffReader_Z == null)
				cb_FT_AutoTurnOffReader_Z = JNINativeWrapper.CreateDelegate ((_JniMarshal_PPZ_L) n_FT_AutoTurnOffReader_Z);
			return cb_FT_AutoTurnOffReader_Z;
		}

		static IntPtr n_FT_AutoTurnOffReader_Z (IntPtr jnienv, IntPtr native__this, bool isOpen)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.ReaderScheme.FTReader> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			return JNIEnv.NewArray (__this.FT_AutoTurnOffReader (isOpen));
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.readerScheme']/class[@name='FTReader']/method[@name='FT_AutoTurnOffReader' and count(parameter)=1 and parameter[1][@type='boolean']]"
		[Register ("FT_AutoTurnOffReader", "(Z)[B", "GetFT_AutoTurnOffReader_ZHandler")]
		public virtual unsafe byte[] FT_AutoTurnOffReader (bool isOpen)
		{
			const string __id = "FT_AutoTurnOffReader.(Z)[B";
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [1];
				__args [0] = new JniArgumentValue (isOpen);
				var __rm = _members.InstanceMethods.InvokeVirtualObjectMethod (__id, this, __args);
				return (byte[]) JNIEnv.GetArray (__rm.Handle, JniHandleOwnership.TransferLocalRef, typeof (byte));
			} finally {
			}
		}

		static Delegate cb_readerClose;
#pragma warning disable 0169
		static Delegate GetReaderCloseHandler ()
		{
			if (cb_readerClose == null)
				cb_readerClose = JNINativeWrapper.CreateDelegate ((_JniMarshal_PP_V) n_ReaderClose);
			return cb_readerClose;
		}

		static void n_ReaderClose (IntPtr jnienv, IntPtr native__this)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.ReaderScheme.FTReader> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			__this.ReaderClose ();
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.readerScheme']/class[@name='FTReader']/method[@name='readerClose' and count(parameter)=0]"
		[Register ("readerClose", "()V", "GetReaderCloseHandler")]
		public virtual unsafe void ReaderClose ()
		{
			const string __id = "readerClose.()V";
			try {
				_members.InstanceMethods.InvokeVirtualVoidMethod (__id, this, null);
			} finally {
			}
		}

		static Delegate cb_readerEscape_IarrayB;
#pragma warning disable 0169
		static Delegate GetReaderEscape_IarrayBHandler ()
		{
			if (cb_readerEscape_IarrayB == null)
				cb_readerEscape_IarrayB = JNINativeWrapper.CreateDelegate ((_JniMarshal_PPIL_L) n_ReaderEscape_IarrayB);
			return cb_readerEscape_IarrayB;
		}

		static IntPtr n_ReaderEscape_IarrayB (IntPtr jnienv, IntPtr native__this, int index, IntPtr native_send)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.ReaderScheme.FTReader> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			var send = (byte[]) JNIEnv.GetArray (native_send, JniHandleOwnership.DoNotTransfer, typeof (byte));
			IntPtr __ret = JNIEnv.NewArray (__this.ReaderEscape (index, send));
			if (send != null)
				JNIEnv.CopyArray (send, native_send);
			return __ret;
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.readerScheme']/class[@name='FTReader']/method[@name='readerEscape' and count(parameter)=2 and parameter[1][@type='int'] and parameter[2][@type='byte[]']]"
		[Register ("readerEscape", "(I[B)[B", "GetReaderEscape_IarrayBHandler")]
		public virtual unsafe byte[] ReaderEscape (int index, byte[] send)
		{
			const string __id = "readerEscape.(I[B)[B";
			IntPtr native_send = JNIEnv.NewArray (send);
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [2];
				__args [0] = new JniArgumentValue (index);
				__args [1] = new JniArgumentValue (native_send);
				var __rm = _members.InstanceMethods.InvokeVirtualObjectMethod (__id, this, __args);
				return (byte[]) JNIEnv.GetArray (__rm.Handle, JniHandleOwnership.TransferLocalRef, typeof (byte));
			} finally {
				if (send != null) {
					JNIEnv.CopyArray (native_send, send);
					JNIEnv.DeleteLocalRef (native_send);
				}
				global::System.GC.KeepAlive (send);
			}
		}

		static Delegate cb_readerFind;
#pragma warning disable 0169
		static Delegate GetReaderFindHandler ()
		{
			if (cb_readerFind == null)
				cb_readerFind = JNINativeWrapper.CreateDelegate ((_JniMarshal_PP_V) n_ReaderFind);
			return cb_readerFind;
		}

		static void n_ReaderFind (IntPtr jnienv, IntPtr native__this)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.ReaderScheme.FTReader> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			__this.ReaderFind ();
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.readerScheme']/class[@name='FTReader']/method[@name='readerFind' and count(parameter)=0]"
		[Register ("readerFind", "()V", "GetReaderFindHandler")]
		public virtual unsafe void ReaderFind ()
		{
			const string __id = "readerFind.()V";
			try {
				_members.InstanceMethods.InvokeVirtualVoidMethod (__id, this, null);
			} finally {
			}
		}

		static Delegate cb_readerGetFirmwareVersion;
#pragma warning disable 0169
		static Delegate GetReaderGetFirmwareVersionHandler ()
		{
			if (cb_readerGetFirmwareVersion == null)
				cb_readerGetFirmwareVersion = JNINativeWrapper.CreateDelegate ((_JniMarshal_PP_L) n_ReaderGetFirmwareVersion);
			return cb_readerGetFirmwareVersion;
		}

		static IntPtr n_ReaderGetFirmwareVersion (IntPtr jnienv, IntPtr native__this)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.ReaderScheme.FTReader> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			return JNIEnv.NewString (__this.ReaderGetFirmwareVersion ());
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.readerScheme']/class[@name='FTReader']/method[@name='readerGetFirmwareVersion' and count(parameter)=0]"
		[Register ("readerGetFirmwareVersion", "()Ljava/lang/String;", "GetReaderGetFirmwareVersionHandler")]
		public virtual unsafe string ReaderGetFirmwareVersion ()
		{
			const string __id = "readerGetFirmwareVersion.()Ljava/lang/String;";
			try {
				var __rm = _members.InstanceMethods.InvokeVirtualObjectMethod (__id, this, null);
				return JNIEnv.GetString (__rm.Handle, JniHandleOwnership.TransferLocalRef);
			} finally {
			}
		}

		static Delegate cb_readerGetHardwareInfo;
#pragma warning disable 0169
		static Delegate GetReaderGetHardwareInfoHandler ()
		{
			if (cb_readerGetHardwareInfo == null)
				cb_readerGetHardwareInfo = JNINativeWrapper.CreateDelegate ((_JniMarshal_PP_L) n_ReaderGetHardwareInfo);
			return cb_readerGetHardwareInfo;
		}

		static IntPtr n_ReaderGetHardwareInfo (IntPtr jnienv, IntPtr native__this)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.ReaderScheme.FTReader> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			return JNIEnv.NewArray (__this.ReaderGetHardwareInfo ());
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.readerScheme']/class[@name='FTReader']/method[@name='readerGetHardwareInfo' and count(parameter)=0]"
		[Register ("readerGetHardwareInfo", "()[B", "GetReaderGetHardwareInfoHandler")]
		public virtual unsafe byte[] ReaderGetHardwareInfo ()
		{
			const string __id = "readerGetHardwareInfo.()[B";
			try {
				var __rm = _members.InstanceMethods.InvokeVirtualObjectMethod (__id, this, null);
				return (byte[]) JNIEnv.GetArray (__rm.Handle, JniHandleOwnership.TransferLocalRef, typeof (byte));
			} finally {
			}
		}

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.readerScheme']/class[@name='FTReader']/method[@name='readerGetLibVersion' and count(parameter)=0]"
		[Register ("readerGetLibVersion", "()Ljava/lang/String;", "")]
		public static unsafe string ReaderGetLibVersion ()
		{
			const string __id = "readerGetLibVersion.()Ljava/lang/String;";
			try {
				var __rm = _members.StaticMethods.InvokeObjectMethod (__id, null);
				return JNIEnv.GetString (__rm.Handle, JniHandleOwnership.TransferLocalRef);
			} finally {
			}
		}

		static Delegate cb_readerGetManufacturer;
#pragma warning disable 0169
		static Delegate GetReaderGetManufacturerHandler ()
		{
			if (cb_readerGetManufacturer == null)
				cb_readerGetManufacturer = JNINativeWrapper.CreateDelegate ((_JniMarshal_PP_L) n_ReaderGetManufacturer);
			return cb_readerGetManufacturer;
		}

		static IntPtr n_ReaderGetManufacturer (IntPtr jnienv, IntPtr native__this)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.ReaderScheme.FTReader> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			return JNIEnv.NewArray (__this.ReaderGetManufacturer ());
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.readerScheme']/class[@name='FTReader']/method[@name='readerGetManufacturer' and count(parameter)=0]"
		[Register ("readerGetManufacturer", "()[B", "GetReaderGetManufacturerHandler")]
		public virtual unsafe byte[] ReaderGetManufacturer ()
		{
			const string __id = "readerGetManufacturer.()[B";
			try {
				var __rm = _members.InstanceMethods.InvokeVirtualObjectMethod (__id, this, null);
				return (byte[]) JNIEnv.GetArray (__rm.Handle, JniHandleOwnership.TransferLocalRef, typeof (byte));
			} finally {
			}
		}

		static Delegate cb_readerGetReaderName;
#pragma warning disable 0169
		static Delegate GetReaderGetReaderNameHandler ()
		{
			if (cb_readerGetReaderName == null)
				cb_readerGetReaderName = JNINativeWrapper.CreateDelegate ((_JniMarshal_PP_L) n_ReaderGetReaderName);
			return cb_readerGetReaderName;
		}

		static IntPtr n_ReaderGetReaderName (IntPtr jnienv, IntPtr native__this)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.ReaderScheme.FTReader> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			return JNIEnv.NewArray (__this.ReaderGetReaderName ());
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.readerScheme']/class[@name='FTReader']/method[@name='readerGetReaderName' and count(parameter)=0]"
		[Register ("readerGetReaderName", "()[B", "GetReaderGetReaderNameHandler")]
		public virtual unsafe byte[] ReaderGetReaderName ()
		{
			const string __id = "readerGetReaderName.()[B";
			try {
				var __rm = _members.InstanceMethods.InvokeVirtualObjectMethod (__id, this, null);
				return (byte[]) JNIEnv.GetArray (__rm.Handle, JniHandleOwnership.TransferLocalRef, typeof (byte));
			} finally {
			}
		}

		static Delegate cb_readerGetSerialNumber;
#pragma warning disable 0169
		static Delegate GetReaderGetSerialNumberHandler ()
		{
			if (cb_readerGetSerialNumber == null)
				cb_readerGetSerialNumber = JNINativeWrapper.CreateDelegate ((_JniMarshal_PP_L) n_ReaderGetSerialNumber);
			return cb_readerGetSerialNumber;
		}

		static IntPtr n_ReaderGetSerialNumber (IntPtr jnienv, IntPtr native__this)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.ReaderScheme.FTReader> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			return JNIEnv.NewArray (__this.ReaderGetSerialNumber ());
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.readerScheme']/class[@name='FTReader']/method[@name='readerGetSerialNumber' and count(parameter)=0]"
		[Register ("readerGetSerialNumber", "()[B", "GetReaderGetSerialNumberHandler")]
		public virtual unsafe byte[] ReaderGetSerialNumber ()
		{
			const string __id = "readerGetSerialNumber.()[B";
			try {
				var __rm = _members.InstanceMethods.InvokeVirtualObjectMethod (__id, this, null);
				return (byte[]) JNIEnv.GetArray (__rm.Handle, JniHandleOwnership.TransferLocalRef, typeof (byte));
			} finally {
			}
		}

		static Delegate cb_readerGetSlotStatus_I;
#pragma warning disable 0169
		static Delegate GetReaderGetSlotStatus_IHandler ()
		{
			if (cb_readerGetSlotStatus_I == null)
				cb_readerGetSlotStatus_I = JNINativeWrapper.CreateDelegate ((_JniMarshal_PPI_I) n_ReaderGetSlotStatus_I);
			return cb_readerGetSlotStatus_I;
		}

		static int n_ReaderGetSlotStatus_I (IntPtr jnienv, IntPtr native__this, int index)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.ReaderScheme.FTReader> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			return __this.ReaderGetSlotStatus (index);
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.readerScheme']/class[@name='FTReader']/method[@name='readerGetSlotStatus' and count(parameter)=1 and parameter[1][@type='int']]"
		[Register ("readerGetSlotStatus", "(I)I", "GetReaderGetSlotStatus_IHandler")]
		public virtual unsafe int ReaderGetSlotStatus (int index)
		{
			const string __id = "readerGetSlotStatus.(I)I";
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [1];
				__args [0] = new JniArgumentValue (index);
				var __rm = _members.InstanceMethods.InvokeVirtualInt32Method (__id, this, __args);
				return __rm;
			} finally {
			}
		}

		static Delegate cb_readerGetType;
#pragma warning disable 0169
		static Delegate GetReaderGetTypeHandler ()
		{
			if (cb_readerGetType == null)
				cb_readerGetType = JNINativeWrapper.CreateDelegate ((_JniMarshal_PP_I) n_ReaderGetType);
			return cb_readerGetType;
		}

		static int n_ReaderGetType (IntPtr jnienv, IntPtr native__this)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.ReaderScheme.FTReader> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			return __this.ReaderGetType ();
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.readerScheme']/class[@name='FTReader']/method[@name='readerGetType' and count(parameter)=0]"
		[Register ("readerGetType", "()I", "GetReaderGetTypeHandler")]
		public virtual unsafe int ReaderGetType ()
		{
			const string __id = "readerGetType.()I";
			try {
				var __rm = _members.InstanceMethods.InvokeVirtualInt32Method (__id, this, null);
				return __rm;
			} finally {
			}
		}

		static Delegate cb_readerGetUID;
#pragma warning disable 0169
		static Delegate GetReaderGetUIDHandler ()
		{
			if (cb_readerGetUID == null)
				cb_readerGetUID = JNINativeWrapper.CreateDelegate ((_JniMarshal_PP_L) n_ReaderGetUID);
			return cb_readerGetUID;
		}

		static IntPtr n_ReaderGetUID (IntPtr jnienv, IntPtr native__this)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.ReaderScheme.FTReader> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			return JNIEnv.NewArray (__this.ReaderGetUID ());
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.readerScheme']/class[@name='FTReader']/method[@name='readerGetUID' and count(parameter)=0]"
		[Register ("readerGetUID", "()[B", "GetReaderGetUIDHandler")]
		public virtual unsafe byte[] ReaderGetUID ()
		{
			const string __id = "readerGetUID.()[B";
			try {
				var __rm = _members.InstanceMethods.InvokeVirtualObjectMethod (__id, this, null);
				return (byte[]) JNIEnv.GetArray (__rm.Handle, JniHandleOwnership.TransferLocalRef, typeof (byte));
			} finally {
			}
		}

		static Delegate cb_readerOpen_Ljava_lang_Object_;
#pragma warning disable 0169
		static Delegate GetReaderOpen_Ljava_lang_Object_Handler ()
		{
			if (cb_readerOpen_Ljava_lang_Object_ == null)
				cb_readerOpen_Ljava_lang_Object_ = JNINativeWrapper.CreateDelegate ((_JniMarshal_PPL_L) n_ReaderOpen_Ljava_lang_Object_);
			return cb_readerOpen_Ljava_lang_Object_;
		}

		static IntPtr n_ReaderOpen_Ljava_lang_Object_ (IntPtr jnienv, IntPtr native__this, IntPtr native_device)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.ReaderScheme.FTReader> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			var device = global::Java.Lang.Object.GetObject<global::Java.Lang.Object> (native_device, JniHandleOwnership.DoNotTransfer);
			IntPtr __ret = JNIEnv.NewArray (__this.ReaderOpen (device));
			return __ret;
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.readerScheme']/class[@name='FTReader']/method[@name='readerOpen' and count(parameter)=1 and parameter[1][@type='java.lang.Object']]"
		[Register ("readerOpen", "(Ljava/lang/Object;)[Ljava/lang/String;", "GetReaderOpen_Ljava_lang_Object_Handler")]
		public virtual unsafe string[] ReaderOpen (global::Java.Lang.Object device)
		{
			const string __id = "readerOpen.(Ljava/lang/Object;)[Ljava/lang/String;";
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [1];
				__args [0] = new JniArgumentValue ((device == null) ? IntPtr.Zero : ((global::Java.Lang.Object) device).Handle);
				var __rm = _members.InstanceMethods.InvokeVirtualObjectMethod (__id, this, __args);
				return (string[]) JNIEnv.GetArray (__rm.Handle, JniHandleOwnership.TransferLocalRef, typeof (string));
			} finally {
				global::System.GC.KeepAlive (device);
			}
		}

		static Delegate cb_readerPowerOff_I;
#pragma warning disable 0169
		static Delegate GetReaderPowerOff_IHandler ()
		{
			if (cb_readerPowerOff_I == null)
				cb_readerPowerOff_I = JNINativeWrapper.CreateDelegate ((_JniMarshal_PPI_V) n_ReaderPowerOff_I);
			return cb_readerPowerOff_I;
		}

		static void n_ReaderPowerOff_I (IntPtr jnienv, IntPtr native__this, int index)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.ReaderScheme.FTReader> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			__this.ReaderPowerOff (index);
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.readerScheme']/class[@name='FTReader']/method[@name='readerPowerOff' and count(parameter)=1 and parameter[1][@type='int']]"
		[Register ("readerPowerOff", "(I)V", "GetReaderPowerOff_IHandler")]
		public virtual unsafe void ReaderPowerOff (int index)
		{
			const string __id = "readerPowerOff.(I)V";
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [1];
				__args [0] = new JniArgumentValue (index);
				_members.InstanceMethods.InvokeVirtualVoidMethod (__id, this, __args);
			} finally {
			}
		}

		static Delegate cb_readerPowerOn_I;
#pragma warning disable 0169
		static Delegate GetReaderPowerOn_IHandler ()
		{
			if (cb_readerPowerOn_I == null)
				cb_readerPowerOn_I = JNINativeWrapper.CreateDelegate ((_JniMarshal_PPI_L) n_ReaderPowerOn_I);
			return cb_readerPowerOn_I;
		}

		static IntPtr n_ReaderPowerOn_I (IntPtr jnienv, IntPtr native__this, int index)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.ReaderScheme.FTReader> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			return JNIEnv.NewArray (__this.ReaderPowerOn (index));
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.readerScheme']/class[@name='FTReader']/method[@name='readerPowerOn' and count(parameter)=1 and parameter[1][@type='int']]"
		[Register ("readerPowerOn", "(I)[B", "GetReaderPowerOn_IHandler")]
		public virtual unsafe byte[] ReaderPowerOn (int index)
		{
			const string __id = "readerPowerOn.(I)[B";
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [1];
				__args [0] = new JniArgumentValue (index);
				var __rm = _members.InstanceMethods.InvokeVirtualObjectMethod (__id, this, __args);
				return (byte[]) JNIEnv.GetArray (__rm.Handle, JniHandleOwnership.TransferLocalRef, typeof (byte));
			} finally {
			}
		}

		static Delegate cb_readerXfr_IarrayB;
#pragma warning disable 0169
		static Delegate GetReaderXfr_IarrayBHandler ()
		{
			if (cb_readerXfr_IarrayB == null)
				cb_readerXfr_IarrayB = JNINativeWrapper.CreateDelegate ((_JniMarshal_PPIL_L) n_ReaderXfr_IarrayB);
			return cb_readerXfr_IarrayB;
		}

		static IntPtr n_ReaderXfr_IarrayB (IntPtr jnienv, IntPtr native__this, int index, IntPtr native_send)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.ReaderScheme.FTReader> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			var send = (byte[]) JNIEnv.GetArray (native_send, JniHandleOwnership.DoNotTransfer, typeof (byte));
			IntPtr __ret = JNIEnv.NewArray (__this.ReaderXfr (index, send));
			if (send != null)
				JNIEnv.CopyArray (send, native_send);
			return __ret;
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.readerScheme']/class[@name='FTReader']/method[@name='readerXfr' and count(parameter)=2 and parameter[1][@type='int'] and parameter[2][@type='byte[]']]"
		[Register ("readerXfr", "(I[B)[B", "GetReaderXfr_IarrayBHandler")]
		public virtual unsafe byte[] ReaderXfr (int index, byte[] send)
		{
			const string __id = "readerXfr.(I[B)[B";
			IntPtr native_send = JNIEnv.NewArray (send);
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [2];
				__args [0] = new JniArgumentValue (index);
				__args [1] = new JniArgumentValue (native_send);
				var __rm = _members.InstanceMethods.InvokeVirtualObjectMethod (__id, this, __args);
				return (byte[]) JNIEnv.GetArray (__rm.Handle, JniHandleOwnership.TransferLocalRef, typeof (byte));
			} finally {
				if (send != null) {
					JNIEnv.CopyArray (native_send, send);
					JNIEnv.DeleteLocalRef (native_send);
				}
				global::System.GC.KeepAlive (send);
			}
		}

	}
}
