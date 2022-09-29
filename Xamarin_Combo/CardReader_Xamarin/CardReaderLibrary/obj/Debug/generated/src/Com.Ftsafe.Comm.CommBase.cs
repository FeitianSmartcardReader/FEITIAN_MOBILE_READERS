using System;
using System.Collections.Generic;
using Android.Runtime;
using Java.Interop;

namespace Com.Ftsafe.Comm {

	// Metadata.xml XPath class reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='CommBase']"
	[global::Android.Runtime.Register ("com/ftsafe/comm/CommBase", DoNotGenerateAcw=true)]
	public partial class CommBase : global::Java.Lang.Object {
		// Metadata.xml XPath interface reference: path="/api/package[@name='com.ftsafe.comm']/interface[@name='CommBase.CommCallback']"
		[Register ("com/ftsafe/comm/CommBase$CommCallback", "", "Com.Ftsafe.Comm.CommBase/ICommCallbackInvoker")]
		public partial interface ICommCallback : IJavaObject, IJavaPeerable {
			// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm']/interface[@name='CommBase.CommCallback']/method[@name='onResult' and count(parameter)=2 and parameter[1][@type='int'] and parameter[2][@type='java.lang.Object']]"
			[Register ("onResult", "(ILjava/lang/Object;)V", "GetOnResult_ILjava_lang_Object_Handler:Com.Ftsafe.Comm.CommBase/ICommCallbackInvoker, CardReaderLibrary")]
			void OnResult (int p0, global::Java.Lang.Object p1);

		}

		[global::Android.Runtime.Register ("com/ftsafe/comm/CommBase$CommCallback", DoNotGenerateAcw=true)]
		internal partial class ICommCallbackInvoker : global::Java.Lang.Object, ICommCallback {
			static readonly JniPeerMembers _members = new XAPeerMembers ("com/ftsafe/comm/CommBase$CommCallback", typeof (ICommCallbackInvoker));

			static IntPtr java_class_ref {
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
				get { return class_ref; }
			}

			[global::System.Diagnostics.DebuggerBrowsable (global::System.Diagnostics.DebuggerBrowsableState.Never)]
			[global::System.ComponentModel.EditorBrowsable (global::System.ComponentModel.EditorBrowsableState.Never)]
			protected override global::System.Type ThresholdType {
				get { return _members.ManagedPeerType; }
			}

			IntPtr class_ref;

			public static ICommCallback GetObject (IntPtr handle, JniHandleOwnership transfer)
			{
				return global::Java.Lang.Object.GetObject<ICommCallback> (handle, transfer);
			}

			static IntPtr Validate (IntPtr handle)
			{
				if (!JNIEnv.IsInstanceOf (handle, java_class_ref))
					throw new InvalidCastException ($"Unable to convert instance of type '{JNIEnv.GetClassNameFromInstance (handle)}' to type 'com.ftsafe.comm.CommBase.CommCallback'.");
				return handle;
			}

			protected override void Dispose (bool disposing)
			{
				if (this.class_ref != IntPtr.Zero)
					JNIEnv.DeleteGlobalRef (this.class_ref);
				this.class_ref = IntPtr.Zero;
				base.Dispose (disposing);
			}

			public ICommCallbackInvoker (IntPtr handle, JniHandleOwnership transfer) : base (Validate (handle), transfer)
			{
				IntPtr local_ref = JNIEnv.GetObjectClass (((global::Java.Lang.Object) this).Handle);
				this.class_ref = JNIEnv.NewGlobalRef (local_ref);
				JNIEnv.DeleteLocalRef (local_ref);
			}

			static Delegate cb_onResult_ILjava_lang_Object_;
#pragma warning disable 0169
			static Delegate GetOnResult_ILjava_lang_Object_Handler ()
			{
				if (cb_onResult_ILjava_lang_Object_ == null)
					cb_onResult_ILjava_lang_Object_ = JNINativeWrapper.CreateDelegate ((_JniMarshal_PPIL_V) n_OnResult_ILjava_lang_Object_);
				return cb_onResult_ILjava_lang_Object_;
			}

			static void n_OnResult_ILjava_lang_Object_ (IntPtr jnienv, IntPtr native__this, int p0, IntPtr native_p1)
			{
				var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.Comm.CommBase.ICommCallback> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
				var p1 = global::Java.Lang.Object.GetObject<global::Java.Lang.Object> (native_p1, JniHandleOwnership.DoNotTransfer);
				__this.OnResult (p0, p1);
			}
#pragma warning restore 0169

			IntPtr id_onResult_ILjava_lang_Object_;
			public unsafe void OnResult (int p0, global::Java.Lang.Object p1)
			{
				if (id_onResult_ILjava_lang_Object_ == IntPtr.Zero)
					id_onResult_ILjava_lang_Object_ = JNIEnv.GetMethodID (class_ref, "onResult", "(ILjava/lang/Object;)V");
				JValue* __args = stackalloc JValue [2];
				__args [0] = new JValue (p0);
				__args [1] = new JValue ((p1 == null) ? IntPtr.Zero : ((global::Java.Lang.Object) p1).Handle);
				JNIEnv.CallVoidMethod (((global::Java.Lang.Object) this).Handle, id_onResult_ILjava_lang_Object_, __args);
			}

		}

		static readonly JniPeerMembers _members = new XAPeerMembers ("com/ftsafe/comm/CommBase", typeof (CommBase));

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

		protected CommBase (IntPtr javaReference, JniHandleOwnership transfer) : base (javaReference, transfer)
		{
		}

		// Metadata.xml XPath constructor reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='CommBase']/constructor[@name='CommBase' and count(parameter)=0]"
		[Register (".ctor", "()V", "")]
		public unsafe CommBase () : base (IntPtr.Zero, JniHandleOwnership.DoNotTransfer)
		{
			const string __id = "()V";

			if (((global::Java.Lang.Object) this).Handle != IntPtr.Zero)
				return;

			try {
				var __r = _members.InstanceMethods.StartCreateInstance (__id, ((object) this).GetType (), null);
				SetHandle (__r.Handle, JniHandleOwnership.TransferLocalRef);
				_members.InstanceMethods.FinishCreateInstance (__id, this, null);
			} finally {
			}
		}

		// Metadata.xml XPath constructor reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='CommBase']/constructor[@name='CommBase' and count(parameter)=3 and parameter[1][@type='int'] and parameter[2][@type='android.content.Context'] and parameter[3][@type='android.os.Handler']]"
		[Register (".ctor", "(ILandroid/content/Context;Landroid/os/Handler;)V", "")]
		public unsafe CommBase (int devType, global::Android.Content.Context context, global::Android.OS.Handler handler) : base (IntPtr.Zero, JniHandleOwnership.DoNotTransfer)
		{
			const string __id = "(ILandroid/content/Context;Landroid/os/Handler;)V";

			if (((global::Java.Lang.Object) this).Handle != IntPtr.Zero)
				return;

			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [3];
				__args [0] = new JniArgumentValue (devType);
				__args [1] = new JniArgumentValue ((context == null) ? IntPtr.Zero : ((global::Java.Lang.Object) context).Handle);
				__args [2] = new JniArgumentValue ((handler == null) ? IntPtr.Zero : ((global::Java.Lang.Object) handler).Handle);
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
				cb_getBleFirmwareVersion = JNINativeWrapper.CreateDelegate ((_JniMarshal_PP_I) n_GetBleFirmwareVersion);
			return cb_getBleFirmwareVersion;
		}

		static int n_GetBleFirmwareVersion (IntPtr jnienv, IntPtr native__this)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.Comm.CommBase> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			return __this.BleFirmwareVersion;
		}
#pragma warning restore 0169

		public virtual unsafe int BleFirmwareVersion {
			// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='CommBase']/method[@name='getBleFirmwareVersion' and count(parameter)=0]"
			[Register ("getBleFirmwareVersion", "()I", "GetGetBleFirmwareVersionHandler")]
			get {
				const string __id = "getBleFirmwareVersion.()I";
				try {
					var __rm = _members.InstanceMethods.InvokeVirtualInt32Method (__id, this, null);
					return __rm;
				} finally {
				}
			}
		}

		static Delegate cb_getCCIDDescriptorDwFeatures;
#pragma warning disable 0169
		static Delegate GetGetCCIDDescriptorDwFeaturesHandler ()
		{
			if (cb_getCCIDDescriptorDwFeatures == null)
				cb_getCCIDDescriptorDwFeatures = JNINativeWrapper.CreateDelegate ((_JniMarshal_PP_I) n_GetCCIDDescriptorDwFeatures);
			return cb_getCCIDDescriptorDwFeatures;
		}

		static int n_GetCCIDDescriptorDwFeatures (IntPtr jnienv, IntPtr native__this)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.Comm.CommBase> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			return __this.CCIDDescriptorDwFeatures;
		}
#pragma warning restore 0169

		public virtual unsafe int CCIDDescriptorDwFeatures {
			// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='CommBase']/method[@name='getCCIDDescriptorDwFeatures' and count(parameter)=0]"
			[Register ("getCCIDDescriptorDwFeatures", "()I", "GetGetCCIDDescriptorDwFeaturesHandler")]
			get {
				const string __id = "getCCIDDescriptorDwFeatures.()I";
				try {
					var __rm = _members.InstanceMethods.InvokeVirtualInt32Method (__id, this, null);
					return __rm;
				} finally {
				}
			}
		}

		static Delegate cb_getDevType;
#pragma warning disable 0169
		static Delegate GetGetDevTypeHandler ()
		{
			if (cb_getDevType == null)
				cb_getDevType = JNINativeWrapper.CreateDelegate ((_JniMarshal_PP_I) n_GetDevType);
			return cb_getDevType;
		}

		static int n_GetDevType (IntPtr jnienv, IntPtr native__this)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.Comm.CommBase> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			return __this.DevType;
		}
#pragma warning restore 0169

		public virtual unsafe int DevType {
			// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='CommBase']/method[@name='getDevType' and count(parameter)=0]"
			[Register ("getDevType", "()I", "GetGetDevTypeHandler")]
			get {
				const string __id = "getDevType.()I";
				try {
					var __rm = _members.InstanceMethods.InvokeVirtualInt32Method (__id, this, null);
					return __rm;
				} finally {
				}
			}
		}

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='CommBase']/method[@name='byteArrayToInt' and count(parameter)=1 and parameter[1][@type='byte[]']]"
		[Register ("byteArrayToInt", "([B)I", "")]
		public static unsafe int ByteArrayToInt (byte[] bytes)
		{
			const string __id = "byteArrayToInt.([B)I";
			IntPtr native_bytes = JNIEnv.NewArray (bytes);
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [1];
				__args [0] = new JniArgumentValue (native_bytes);
				var __rm = _members.StaticMethods.InvokeInt32Method (__id, __args);
				return __rm;
			} finally {
				if (bytes != null) {
					JNIEnv.CopyArray (native_bytes, bytes);
					JNIEnv.DeleteLocalRef (native_bytes);
				}
				global::System.GC.KeepAlive (bytes);
			}
		}

		static Delegate cb_getUSBManufacturer;
#pragma warning disable 0169
		static Delegate GetGetUSBManufacturerHandler ()
		{
			if (cb_getUSBManufacturer == null)
				cb_getUSBManufacturer = JNINativeWrapper.CreateDelegate ((_JniMarshal_PP_L) n_GetUSBManufacturer);
			return cb_getUSBManufacturer;
		}

		static IntPtr n_GetUSBManufacturer (IntPtr jnienv, IntPtr native__this)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.Comm.CommBase> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			return JNIEnv.NewArray (__this.GetUSBManufacturer ());
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='CommBase']/method[@name='getUSBManufacturer' and count(parameter)=0]"
		[Register ("getUSBManufacturer", "()[B", "GetGetUSBManufacturerHandler")]
		public virtual unsafe byte[] GetUSBManufacturer ()
		{
			const string __id = "getUSBManufacturer.()[B";
			try {
				var __rm = _members.InstanceMethods.InvokeVirtualObjectMethod (__id, this, null);
				return (byte[]) JNIEnv.GetArray (__rm.Handle, JniHandleOwnership.TransferLocalRef, typeof (byte));
			} finally {
			}
		}

		static Delegate cb_getUSBReaderName;
#pragma warning disable 0169
		static Delegate GetGetUSBReaderNameHandler ()
		{
			if (cb_getUSBReaderName == null)
				cb_getUSBReaderName = JNINativeWrapper.CreateDelegate ((_JniMarshal_PP_L) n_GetUSBReaderName);
			return cb_getUSBReaderName;
		}

		static IntPtr n_GetUSBReaderName (IntPtr jnienv, IntPtr native__this)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.Comm.CommBase> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			return JNIEnv.NewArray (__this.GetUSBReaderName ());
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='CommBase']/method[@name='getUSBReaderName' and count(parameter)=0]"
		[Register ("getUSBReaderName", "()[B", "GetGetUSBReaderNameHandler")]
		public virtual unsafe byte[] GetUSBReaderName ()
		{
			const string __id = "getUSBReaderName.()[B";
			try {
				var __rm = _members.InstanceMethods.InvokeVirtualObjectMethod (__id, this, null);
				return (byte[]) JNIEnv.GetArray (__rm.Handle, JniHandleOwnership.TransferLocalRef, typeof (byte));
			} finally {
			}
		}

		static Delegate cb_getUSBSlotName;
#pragma warning disable 0169
		static Delegate GetGetUSBSlotNameHandler ()
		{
			if (cb_getUSBSlotName == null)
				cb_getUSBSlotName = JNINativeWrapper.CreateDelegate ((_JniMarshal_PP_L) n_GetUSBSlotName);
			return cb_getUSBSlotName;
		}

		static IntPtr n_GetUSBSlotName (IntPtr jnienv, IntPtr native__this)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.Comm.CommBase> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			return JNIEnv.NewArray (__this.GetUSBSlotName ());
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='CommBase']/method[@name='getUSBSlotName' and count(parameter)=0]"
		[Register ("getUSBSlotName", "()[Ljava/lang/String;", "GetGetUSBSlotNameHandler")]
		public virtual unsafe string[] GetUSBSlotName ()
		{
			const string __id = "getUSBSlotName.()[Ljava/lang/String;";
			try {
				var __rm = _members.InstanceMethods.InvokeVirtualObjectMethod (__id, this, null);
				return (string[]) JNIEnv.GetArray (__rm.Handle, JniHandleOwnership.TransferLocalRef, typeof (string));
			} finally {
			}
		}

		static Delegate cb_isTPDUReader;
#pragma warning disable 0169
		static Delegate GetIsTPDUReaderHandler ()
		{
			if (cb_isTPDUReader == null)
				cb_isTPDUReader = JNINativeWrapper.CreateDelegate ((_JniMarshal_PP_I) n_IsTPDUReader);
			return cb_isTPDUReader;
		}

		static int n_IsTPDUReader (IntPtr jnienv, IntPtr native__this)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.Comm.CommBase> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			return __this.IsTPDUReader ();
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='CommBase']/method[@name='isTPDUReader' and count(parameter)=0]"
		[Register ("isTPDUReader", "()I", "GetIsTPDUReaderHandler")]
		public virtual unsafe int IsTPDUReader ()
		{
			const string __id = "isTPDUReader.()I";
			try {
				var __rm = _members.InstanceMethods.InvokeVirtualInt32Method (__id, this, null);
				return __rm;
			} finally {
			}
		}

		static Delegate cb_isTPDUReader_check_by_version;
#pragma warning disable 0169
		static Delegate GetIsTPDUReader_check_by_versionHandler ()
		{
			if (cb_isTPDUReader_check_by_version == null)
				cb_isTPDUReader_check_by_version = JNINativeWrapper.CreateDelegate ((_JniMarshal_PP_I) n_IsTPDUReader_check_by_version);
			return cb_isTPDUReader_check_by_version;
		}

		static int n_IsTPDUReader_check_by_version (IntPtr jnienv, IntPtr native__this)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.Comm.CommBase> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			return __this.IsTPDUReader_check_by_version ();
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='CommBase']/method[@name='isTPDUReader_check_by_version' and count(parameter)=0]"
		[Register ("isTPDUReader_check_by_version", "()I", "GetIsTPDUReader_check_by_versionHandler")]
		public virtual unsafe int IsTPDUReader_check_by_version ()
		{
			const string __id = "isTPDUReader_check_by_version.()I";
			try {
				var __rm = _members.InstanceMethods.InvokeVirtualInt32Method (__id, this, null);
				return __rm;
			} finally {
			}
		}

		static Delegate cb_readData_IIarrayBarrayI;
#pragma warning disable 0169
		static Delegate GetReadData_IIarrayBarrayIHandler ()
		{
			if (cb_readData_IIarrayBarrayI == null)
				cb_readData_IIarrayBarrayI = JNINativeWrapper.CreateDelegate ((_JniMarshal_PPIILL_I) n_ReadData_IIarrayBarrayI);
			return cb_readData_IIarrayBarrayI;
		}

		static int n_ReadData_IIarrayBarrayI (IntPtr jnienv, IntPtr native__this, int index, int timeout, IntPtr native_data, IntPtr native_dataLen)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.Comm.CommBase> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			var data = (byte[]) JNIEnv.GetArray (native_data, JniHandleOwnership.DoNotTransfer, typeof (byte));
			var dataLen = (int[]) JNIEnv.GetArray (native_dataLen, JniHandleOwnership.DoNotTransfer, typeof (int));
			int __ret = __this.ReadData (index, timeout, data, dataLen);
			if (data != null)
				JNIEnv.CopyArray (data, native_data);
			if (dataLen != null)
				JNIEnv.CopyArray (dataLen, native_dataLen);
			return __ret;
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='CommBase']/method[@name='readData' and count(parameter)=4 and parameter[1][@type='int'] and parameter[2][@type='int'] and parameter[3][@type='byte[]'] and parameter[4][@type='int[]']]"
		[Register ("readData", "(II[B[I)I", "GetReadData_IIarrayBarrayIHandler")]
		public virtual unsafe int ReadData (int index, int timeout, byte[] data, int[] dataLen)
		{
			const string __id = "readData.(II[B[I)I";
			IntPtr native_data = JNIEnv.NewArray (data);
			IntPtr native_dataLen = JNIEnv.NewArray (dataLen);
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [4];
				__args [0] = new JniArgumentValue (index);
				__args [1] = new JniArgumentValue (timeout);
				__args [2] = new JniArgumentValue (native_data);
				__args [3] = new JniArgumentValue (native_dataLen);
				var __rm = _members.InstanceMethods.InvokeVirtualInt32Method (__id, this, __args);
				return __rm;
			} finally {
				if (data != null) {
					JNIEnv.CopyArray (native_data, data);
					JNIEnv.DeleteLocalRef (native_data);
				}
				if (dataLen != null) {
					JNIEnv.CopyArray (native_dataLen, dataLen);
					JNIEnv.DeleteLocalRef (native_dataLen);
				}
				global::System.GC.KeepAlive (data);
				global::System.GC.KeepAlive (dataLen);
			}
		}

		static Delegate cb_readerClose;
#pragma warning disable 0169
		static Delegate GetReaderCloseHandler ()
		{
			if (cb_readerClose == null)
				cb_readerClose = JNINativeWrapper.CreateDelegate ((_JniMarshal_PP_I) n_ReaderClose);
			return cb_readerClose;
		}

		static int n_ReaderClose (IntPtr jnienv, IntPtr native__this)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.Comm.CommBase> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			return __this.ReaderClose ();
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='CommBase']/method[@name='readerClose' and count(parameter)=0]"
		[Register ("readerClose", "()I", "GetReaderCloseHandler")]
		public virtual unsafe int ReaderClose ()
		{
			const string __id = "readerClose.()I";
			try {
				var __rm = _members.InstanceMethods.InvokeVirtualInt32Method (__id, this, null);
				return __rm;
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
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.Comm.CommBase> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			var send = (byte[]) JNIEnv.GetArray (native_send, JniHandleOwnership.DoNotTransfer, typeof (byte));
			IntPtr __ret = JNIEnv.NewArray (__this.ReaderEscape (index, send));
			if (send != null)
				JNIEnv.CopyArray (send, native_send);
			return __ret;
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='CommBase']/method[@name='readerEscape' and count(parameter)=2 and parameter[1][@type='int'] and parameter[2][@type='byte[]']]"
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
				cb_readerFind = JNINativeWrapper.CreateDelegate ((_JniMarshal_PP_I) n_ReaderFind);
			return cb_readerFind;
		}

		static int n_ReaderFind (IntPtr jnienv, IntPtr native__this)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.Comm.CommBase> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			return __this.ReaderFind ();
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='CommBase']/method[@name='readerFind' and count(parameter)=0]"
		[Register ("readerFind", "()I", "GetReaderFindHandler")]
		public virtual unsafe int ReaderFind ()
		{
			const string __id = "readerFind.()I";
			try {
				var __rm = _members.InstanceMethods.InvokeVirtualInt32Method (__id, this, null);
				return __rm;
			} finally {
			}
		}

		static Delegate cb_readerGetBcdDevice;
#pragma warning disable 0169
		static Delegate GetReaderGetBcdDeviceHandler ()
		{
			if (cb_readerGetBcdDevice == null)
				cb_readerGetBcdDevice = JNINativeWrapper.CreateDelegate ((_JniMarshal_PP_I) n_ReaderGetBcdDevice);
			return cb_readerGetBcdDevice;
		}

		static int n_ReaderGetBcdDevice (IntPtr jnienv, IntPtr native__this)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.Comm.CommBase> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			return __this.ReaderGetBcdDevice ();
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='CommBase']/method[@name='readerGetBcdDevice' and count(parameter)=0]"
		[Register ("readerGetBcdDevice", "()I", "GetReaderGetBcdDeviceHandler")]
		public virtual unsafe int ReaderGetBcdDevice ()
		{
			const string __id = "readerGetBcdDevice.()I";
			try {
				var __rm = _members.InstanceMethods.InvokeVirtualInt32Method (__id, this, null);
				return __rm;
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
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.Comm.CommBase> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			return JNIEnv.NewArray (__this.ReaderGetFirmwareVersion ());
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='CommBase']/method[@name='readerGetFirmwareVersion' and count(parameter)=0]"
		[Register ("readerGetFirmwareVersion", "()[B", "GetReaderGetFirmwareVersionHandler")]
		public virtual unsafe byte[] ReaderGetFirmwareVersion ()
		{
			const string __id = "readerGetFirmwareVersion.()[B";
			try {
				var __rm = _members.InstanceMethods.InvokeVirtualObjectMethod (__id, this, null);
				return (byte[]) JNIEnv.GetArray (__rm.Handle, JniHandleOwnership.TransferLocalRef, typeof (byte));
			} finally {
			}
		}

		static Delegate cb_readerGetPid;
#pragma warning disable 0169
		static Delegate GetReaderGetPidHandler ()
		{
			if (cb_readerGetPid == null)
				cb_readerGetPid = JNINativeWrapper.CreateDelegate ((_JniMarshal_PP_I) n_ReaderGetPid);
			return cb_readerGetPid;
		}

		static int n_ReaderGetPid (IntPtr jnienv, IntPtr native__this)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.Comm.CommBase> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			return __this.ReaderGetPid ();
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='CommBase']/method[@name='readerGetPid' and count(parameter)=0]"
		[Register ("readerGetPid", "()I", "GetReaderGetPidHandler")]
		public virtual unsafe int ReaderGetPid ()
		{
			const string __id = "readerGetPid.()I";
			try {
				var __rm = _members.InstanceMethods.InvokeVirtualInt32Method (__id, this, null);
				return __rm;
			} finally {
			}
		}

		static Delegate cb_readerOpen_arrayBarrayI;
#pragma warning disable 0169
		static Delegate GetReaderOpen_arrayBarrayIHandler ()
		{
			if (cb_readerOpen_arrayBarrayI == null)
				cb_readerOpen_arrayBarrayI = JNINativeWrapper.CreateDelegate ((_JniMarshal_PPLL_I) n_ReaderOpen_arrayBarrayI);
			return cb_readerOpen_arrayBarrayI;
		}

		static int n_ReaderOpen_arrayBarrayI (IntPtr jnienv, IntPtr native__this, IntPtr native_name, IntPtr native_slotIndex)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.Comm.CommBase> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			var name = (byte[]) JNIEnv.GetArray (native_name, JniHandleOwnership.DoNotTransfer, typeof (byte));
			var slotIndex = (int[]) JNIEnv.GetArray (native_slotIndex, JniHandleOwnership.DoNotTransfer, typeof (int));
			int __ret = __this.ReaderOpen (name, slotIndex);
			if (name != null)
				JNIEnv.CopyArray (name, native_name);
			if (slotIndex != null)
				JNIEnv.CopyArray (slotIndex, native_slotIndex);
			return __ret;
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='CommBase']/method[@name='readerOpen' and count(parameter)=2 and parameter[1][@type='byte[]'] and parameter[2][@type='int[]']]"
		[Register ("readerOpen", "([B[I)I", "GetReaderOpen_arrayBarrayIHandler")]
		public virtual unsafe int ReaderOpen (byte[] name, int[] slotIndex)
		{
			const string __id = "readerOpen.([B[I)I";
			IntPtr native_name = JNIEnv.NewArray (name);
			IntPtr native_slotIndex = JNIEnv.NewArray (slotIndex);
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [2];
				__args [0] = new JniArgumentValue (native_name);
				__args [1] = new JniArgumentValue (native_slotIndex);
				var __rm = _members.InstanceMethods.InvokeVirtualInt32Method (__id, this, __args);
				return __rm;
			} finally {
				if (name != null) {
					JNIEnv.CopyArray (native_name, name);
					JNIEnv.DeleteLocalRef (native_name);
				}
				if (slotIndex != null) {
					JNIEnv.CopyArray (native_slotIndex, slotIndex);
					JNIEnv.DeleteLocalRef (native_slotIndex);
				}
				global::System.GC.KeepAlive (name);
				global::System.GC.KeepAlive (slotIndex);
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
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.Comm.CommBase> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			var device = global::Java.Lang.Object.GetObject<global::Java.Lang.Object> (native_device, JniHandleOwnership.DoNotTransfer);
			IntPtr __ret = JNIEnv.NewArray (__this.ReaderOpen (device));
			return __ret;
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='CommBase']/method[@name='readerOpen' and count(parameter)=1 and parameter[1][@type='java.lang.Object']]"
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
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.Comm.CommBase> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			__this.ReaderPowerOff (index);
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='CommBase']/method[@name='readerPowerOff' and count(parameter)=1 and parameter[1][@type='int']]"
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

		static Delegate cb_readerPowerOn_II;
#pragma warning disable 0169
		static Delegate GetReaderPowerOn_IIHandler ()
		{
			if (cb_readerPowerOn_II == null)
				cb_readerPowerOn_II = JNINativeWrapper.CreateDelegate ((_JniMarshal_PPII_L) n_ReaderPowerOn_II);
			return cb_readerPowerOn_II;
		}

		static IntPtr n_ReaderPowerOn_II (IntPtr jnienv, IntPtr native__this, int index, int type)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.Comm.CommBase> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			return JNIEnv.NewArray (__this.ReaderPowerOn (index, type));
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='CommBase']/method[@name='readerPowerOn' and count(parameter)=2 and parameter[1][@type='int'] and parameter[2][@type='int']]"
		[Register ("readerPowerOn", "(II)[B", "GetReaderPowerOn_IIHandler")]
		public virtual unsafe byte[] ReaderPowerOn (int index, int type)
		{
			const string __id = "readerPowerOn.(II)[B";
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [2];
				__args [0] = new JniArgumentValue (index);
				__args [1] = new JniArgumentValue (type);
				var __rm = _members.InstanceMethods.InvokeVirtualObjectMethod (__id, this, __args);
				return (byte[]) JNIEnv.GetArray (__rm.Handle, JniHandleOwnership.TransferLocalRef, typeof (byte));
			} finally {
			}
		}

		static Delegate cb_readerSlotStatus_I;
#pragma warning disable 0169
		static Delegate GetReaderSlotStatus_IHandler ()
		{
			if (cb_readerSlotStatus_I == null)
				cb_readerSlotStatus_I = JNINativeWrapper.CreateDelegate ((_JniMarshal_PPI_I) n_ReaderSlotStatus_I);
			return cb_readerSlotStatus_I;
		}

		static int n_ReaderSlotStatus_I (IntPtr jnienv, IntPtr native__this, int index)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.Comm.CommBase> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			return __this.ReaderSlotStatus (index);
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='CommBase']/method[@name='readerSlotStatus' and count(parameter)=1 and parameter[1][@type='int']]"
		[Register ("readerSlotStatus", "(I)I", "GetReaderSlotStatus_IHandler")]
		public virtual unsafe int ReaderSlotStatus (int index)
		{
			const string __id = "readerSlotStatus.(I)I";
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [1];
				__args [0] = new JniArgumentValue (index);
				var __rm = _members.InstanceMethods.InvokeVirtualInt32Method (__id, this, __args);
				return __rm;
			} finally {
			}
		}

		static Delegate cb_readerXfrBlock_IarrayB;
#pragma warning disable 0169
		static Delegate GetReaderXfrBlock_IarrayBHandler ()
		{
			if (cb_readerXfrBlock_IarrayB == null)
				cb_readerXfrBlock_IarrayB = JNINativeWrapper.CreateDelegate ((_JniMarshal_PPIL_L) n_ReaderXfrBlock_IarrayB);
			return cb_readerXfrBlock_IarrayB;
		}

		static IntPtr n_ReaderXfrBlock_IarrayB (IntPtr jnienv, IntPtr native__this, int index, IntPtr native_send)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.Comm.CommBase> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			var send = (byte[]) JNIEnv.GetArray (native_send, JniHandleOwnership.DoNotTransfer, typeof (byte));
			IntPtr __ret = JNIEnv.NewArray (__this.ReaderXfrBlock (index, send));
			if (send != null)
				JNIEnv.CopyArray (send, native_send);
			return __ret;
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='CommBase']/method[@name='readerXfrBlock' and count(parameter)=2 and parameter[1][@type='int'] and parameter[2][@type='byte[]']]"
		[Register ("readerXfrBlock", "(I[B)[B", "GetReaderXfrBlock_IarrayBHandler")]
		public virtual unsafe byte[] ReaderXfrBlock (int index, byte[] send)
		{
			const string __id = "readerXfrBlock.(I[B)[B";
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

		static Delegate cb_uninit;
#pragma warning disable 0169
		static Delegate GetUninitHandler ()
		{
			if (cb_uninit == null)
				cb_uninit = JNINativeWrapper.CreateDelegate ((_JniMarshal_PP_V) n_Uninit);
			return cb_uninit;
		}

		static void n_Uninit (IntPtr jnienv, IntPtr native__this)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.Comm.CommBase> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			__this.Uninit ();
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='CommBase']/method[@name='uninit' and count(parameter)=0]"
		[Register ("uninit", "()V", "GetUninitHandler")]
		public virtual unsafe void Uninit ()
		{
			const string __id = "uninit.()V";
			try {
				_members.InstanceMethods.InvokeVirtualVoidMethod (__id, this, null);
			} finally {
			}
		}

		static Delegate cb_writeData_IarrayBI;
#pragma warning disable 0169
		static Delegate GetWriteData_IarrayBIHandler ()
		{
			if (cb_writeData_IarrayBI == null)
				cb_writeData_IarrayBI = JNINativeWrapper.CreateDelegate ((_JniMarshal_PPILI_I) n_WriteData_IarrayBI);
			return cb_writeData_IarrayBI;
		}

		static int n_WriteData_IarrayBI (IntPtr jnienv, IntPtr native__this, int index, IntPtr native_data, int dataLen)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.Comm.CommBase> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			var data = (byte[]) JNIEnv.GetArray (native_data, JniHandleOwnership.DoNotTransfer, typeof (byte));
			int __ret = __this.WriteData (index, data, dataLen);
			if (data != null)
				JNIEnv.CopyArray (data, native_data);
			return __ret;
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='CommBase']/method[@name='writeData' and count(parameter)=3 and parameter[1][@type='int'] and parameter[2][@type='byte[]'] and parameter[3][@type='int']]"
		[Register ("writeData", "(I[BI)I", "GetWriteData_IarrayBIHandler")]
		public virtual unsafe int WriteData (int index, byte[] data, int dataLen)
		{
			const string __id = "writeData.(I[BI)I";
			IntPtr native_data = JNIEnv.NewArray (data);
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [3];
				__args [0] = new JniArgumentValue (index);
				__args [1] = new JniArgumentValue (native_data);
				__args [2] = new JniArgumentValue (dataLen);
				var __rm = _members.InstanceMethods.InvokeVirtualInt32Method (__id, this, __args);
				return __rm;
			} finally {
				if (data != null) {
					JNIEnv.CopyArray (native_data, data);
					JNIEnv.DeleteLocalRef (native_data);
				}
				global::System.GC.KeepAlive (data);
			}
		}

	}
}
