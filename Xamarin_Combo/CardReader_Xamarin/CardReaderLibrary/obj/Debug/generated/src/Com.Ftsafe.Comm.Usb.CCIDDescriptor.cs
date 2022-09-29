using System;
using System.Collections.Generic;
using Android.Runtime;
using Java.Interop;

namespace Com.Ftsafe.Comm.Usb {

	// Metadata.xml XPath class reference: path="/api/package[@name='com.ftsafe.comm.usb']/class[@name='CCIDDescriptor']"
	[global::Android.Runtime.Register ("com/ftsafe/comm/usb/CCIDDescriptor", DoNotGenerateAcw=true)]
	public partial class CCIDDescriptor : global::Java.Lang.Object {
		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe.comm.usb']/class[@name='CCIDDescriptor']/field[@name='CCID_HEAD_LEN']"
		[Register ("CCID_HEAD_LEN")]
		public const int CcidHeadLen = (int) 10;

		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe.comm.usb']/class[@name='CCIDDescriptor']/field[@name='DW_FEATURES_INDEX']"
		[Register ("DW_FEATURES_INDEX")]
		public const int DwFeaturesIndex = (int) 40;

		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe.comm.usb']/class[@name='CCIDDescriptor']/field[@name='DW_FEATURES_LEN']"
		[Register ("DW_FEATURES_LEN")]
		public const int DwFeaturesLen = (int) 4;

		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe.comm.usb']/class[@name='CCIDDescriptor']/field[@name='DW_PROTOCOLS_INDEX']"
		[Register ("DW_PROTOCOLS_INDEX")]
		public const int DwProtocolsIndex = (int) 6;

		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe.comm.usb']/class[@name='CCIDDescriptor']/field[@name='DW_PROTOCOLS_LEN']"
		[Register ("DW_PROTOCOLS_LEN")]
		public const int DwProtocolsLen = (int) 4;

		static readonly JniPeerMembers _members = new XAPeerMembers ("com/ftsafe/comm/usb/CCIDDescriptor", typeof (CCIDDescriptor));

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

		protected CCIDDescriptor (IntPtr javaReference, JniHandleOwnership transfer) : base (javaReference, transfer)
		{
		}

		// Metadata.xml XPath constructor reference: path="/api/package[@name='com.ftsafe.comm.usb']/class[@name='CCIDDescriptor']/constructor[@name='CCIDDescriptor' and count(parameter)=0]"
		[Register (".ctor", "()V", "")]
		public unsafe CCIDDescriptor () : base (IntPtr.Zero, JniHandleOwnership.DoNotTransfer)
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

		static Delegate cb_getDwFeatures;
#pragma warning disable 0169
		static Delegate GetGetDwFeaturesHandler ()
		{
			if (cb_getDwFeatures == null)
				cb_getDwFeatures = JNINativeWrapper.CreateDelegate ((_JniMarshal_PP_L) n_GetDwFeatures);
			return cb_getDwFeatures;
		}

		static IntPtr n_GetDwFeatures (IntPtr jnienv, IntPtr native__this)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.Comm.Usb.CCIDDescriptor> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			return JNIEnv.NewArray (__this.GetDwFeatures ());
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm.usb']/class[@name='CCIDDescriptor']/method[@name='getDwFeatures' and count(parameter)=0]"
		[Register ("getDwFeatures", "()[B", "GetGetDwFeaturesHandler")]
		public virtual unsafe byte[] GetDwFeatures ()
		{
			const string __id = "getDwFeatures.()[B";
			try {
				var __rm = _members.InstanceMethods.InvokeVirtualObjectMethod (__id, this, null);
				return (byte[]) JNIEnv.GetArray (__rm.Handle, JniHandleOwnership.TransferLocalRef, typeof (byte));
			} finally {
			}
		}

		static Delegate cb_getDwProtocols;
#pragma warning disable 0169
		static Delegate GetGetDwProtocolsHandler ()
		{
			if (cb_getDwProtocols == null)
				cb_getDwProtocols = JNINativeWrapper.CreateDelegate ((_JniMarshal_PP_L) n_GetDwProtocols);
			return cb_getDwProtocols;
		}

		static IntPtr n_GetDwProtocols (IntPtr jnienv, IntPtr native__this)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.Comm.Usb.CCIDDescriptor> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			return JNIEnv.NewArray (__this.GetDwProtocols ());
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm.usb']/class[@name='CCIDDescriptor']/method[@name='getDwProtocols' and count(parameter)=0]"
		[Register ("getDwProtocols", "()[B", "GetGetDwProtocolsHandler")]
		public virtual unsafe byte[] GetDwProtocols ()
		{
			const string __id = "getDwProtocols.()[B";
			try {
				var __rm = _members.InstanceMethods.InvokeVirtualObjectMethod (__id, this, null);
				return (byte[]) JNIEnv.GetArray (__rm.Handle, JniHandleOwnership.TransferLocalRef, typeof (byte));
			} finally {
			}
		}

		static Delegate cb_parse_arrayBII;
#pragma warning disable 0169
		static Delegate GetParse_arrayBIIHandler ()
		{
			if (cb_parse_arrayBII == null)
				cb_parse_arrayBII = JNINativeWrapper.CreateDelegate ((_JniMarshal_PPLII_V) n_Parse_arrayBII);
			return cb_parse_arrayBII;
		}

		static void n_Parse_arrayBII (IntPtr jnienv, IntPtr native__this, IntPtr native_data, int index, int len)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.Comm.Usb.CCIDDescriptor> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			var data = (byte[]) JNIEnv.GetArray (native_data, JniHandleOwnership.DoNotTransfer, typeof (byte));
			__this.Parse (data, index, len);
			if (data != null)
				JNIEnv.CopyArray (data, native_data);
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm.usb']/class[@name='CCIDDescriptor']/method[@name='parse' and count(parameter)=3 and parameter[1][@type='byte[]'] and parameter[2][@type='int'] and parameter[3][@type='int']]"
		[Register ("parse", "([BII)V", "GetParse_arrayBIIHandler")]
		public virtual unsafe void Parse (byte[] data, int index, int len)
		{
			const string __id = "parse.([BII)V";
			IntPtr native_data = JNIEnv.NewArray (data);
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [3];
				__args [0] = new JniArgumentValue (native_data);
				__args [1] = new JniArgumentValue (index);
				__args [2] = new JniArgumentValue (len);
				_members.InstanceMethods.InvokeVirtualVoidMethod (__id, this, __args);
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
