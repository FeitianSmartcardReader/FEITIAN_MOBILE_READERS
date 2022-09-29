using System;
using System.Collections.Generic;
using Android.Runtime;
using Java.Interop;

namespace Com.Ftsafe.Comm.Usb {

	// Metadata.xml XPath class reference: path="/api/package[@name='com.ftsafe.comm.usb']/class[@name='USBParse']"
	[global::Android.Runtime.Register ("com/ftsafe/comm/usb/USBParse", DoNotGenerateAcw=true)]
	public partial class USBParse : global::Java.Lang.Object {
		static readonly JniPeerMembers _members = new XAPeerMembers ("com/ftsafe/comm/usb/USBParse", typeof (USBParse));

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

		protected USBParse (IntPtr javaReference, JniHandleOwnership transfer) : base (javaReference, transfer)
		{
		}

		// Metadata.xml XPath constructor reference: path="/api/package[@name='com.ftsafe.comm.usb']/class[@name='USBParse']/constructor[@name='USBParse' and count(parameter)=0]"
		[Register (".ctor", "()V", "")]
		public unsafe USBParse () : base (IntPtr.Zero, JniHandleOwnership.DoNotTransfer)
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

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm.usb']/class[@name='USBParse']/method[@name='getCCIDDescriptorList' and count(parameter)=1 and parameter[1][@type='byte[]']]"
		[Register ("getCCIDDescriptorList", "([B)Ljava/util/List;", "")]
		public static unsafe global::System.Collections.Generic.IList<global::Com.Ftsafe.Comm.Usb.CCIDDescriptor> GetCCIDDescriptorList (byte[] data)
		{
			const string __id = "getCCIDDescriptorList.([B)Ljava/util/List;";
			IntPtr native_data = JNIEnv.NewArray (data);
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [1];
				__args [0] = new JniArgumentValue (native_data);
				var __rm = _members.StaticMethods.InvokeObjectMethod (__id, __args);
				return global::Android.Runtime.JavaList<global::Com.Ftsafe.Comm.Usb.CCIDDescriptor>.FromJniHandle (__rm.Handle, JniHandleOwnership.TransferLocalRef);
			} finally {
				if (data != null) {
					JNIEnv.CopyArray (native_data, data);
					JNIEnv.DeleteLocalRef (native_data);
				}
				global::System.GC.KeepAlive (data);
			}
		}

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm.usb']/class[@name='USBParse']/method[@name='getInterfaceIndexFromRawDescriptor' and count(parameter)=1 and parameter[1][@type='byte[]']]"
		[Register ("getInterfaceIndexFromRawDescriptor", "([B)[I", "")]
		public static unsafe int[] GetInterfaceIndexFromRawDescriptor (byte[] rawDescriptor)
		{
			const string __id = "getInterfaceIndexFromRawDescriptor.([B)[I";
			IntPtr native_rawDescriptor = JNIEnv.NewArray (rawDescriptor);
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [1];
				__args [0] = new JniArgumentValue (native_rawDescriptor);
				var __rm = _members.StaticMethods.InvokeObjectMethod (__id, __args);
				return (int[]) JNIEnv.GetArray (__rm.Handle, JniHandleOwnership.TransferLocalRef, typeof (int));
			} finally {
				if (rawDescriptor != null) {
					JNIEnv.CopyArray (native_rawDescriptor, rawDescriptor);
					JNIEnv.DeleteLocalRef (native_rawDescriptor);
				}
				global::System.GC.KeepAlive (rawDescriptor);
			}
		}

	}
}
