using System;
using System.Collections.Generic;
using Android.Runtime;
using Java.Interop;

namespace Com.Ftsafe.Ftnative {

	// Metadata.xml XPath class reference: path="/api/package[@name='com.ftsafe.ftnative']/class[@name='FTNative']"
	[global::Android.Runtime.Register ("com/ftsafe/ftnative/FTNative", DoNotGenerateAcw=true)]
	public partial class FTNative : global::Java.Lang.Object {
		static readonly JniPeerMembers _members = new XAPeerMembers ("com/ftsafe/ftnative/FTNative", typeof (FTNative));

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

		protected FTNative (IntPtr javaReference, JniHandleOwnership transfer) : base (javaReference, transfer)
		{
		}

		// Metadata.xml XPath constructor reference: path="/api/package[@name='com.ftsafe.ftnative']/class[@name='FTNative']/constructor[@name='FTNative' and count(parameter)=0]"
		[Register (".ctor", "()V", "")]
		public unsafe FTNative () : base (IntPtr.Zero, JniHandleOwnership.DoNotTransfer)
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

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.ftnative']/class[@name='FTNative']/method[@name='init' and count(parameter)=1 and parameter[1][@type='com.ftsafe.comm.CommBase']]"
		[Register ("init", "(Lcom/ftsafe/comm/CommBase;)V", "")]
		public static unsafe void Init (global::Com.Ftsafe.Comm.CommBase p0)
		{
			const string __id = "init.(Lcom/ftsafe/comm/CommBase;)V";
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [1];
				__args [0] = new JniArgumentValue ((p0 == null) ? IntPtr.Zero : ((global::Java.Lang.Object) p0).Handle);
				_members.StaticMethods.InvokeVoidMethod (__id, __args);
			} finally {
				global::System.GC.KeepAlive (p0);
			}
		}

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.ftnative']/class[@name='FTNative']/method[@name='readerEscape' and count(parameter)=5 and parameter[1][@type='int'] and parameter[2][@type='byte[]'] and parameter[3][@type='int'] and parameter[4][@type='byte[]'] and parameter[5][@type='int[]']]"
		[Register ("readerEscape", "(I[BI[B[I)I", "")]
		public static unsafe int ReaderEscape (int p0, byte[] p1, int p2, byte[] p3, int[] p4)
		{
			const string __id = "readerEscape.(I[BI[B[I)I";
			IntPtr native_p1 = JNIEnv.NewArray (p1);
			IntPtr native_p3 = JNIEnv.NewArray (p3);
			IntPtr native_p4 = JNIEnv.NewArray (p4);
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [5];
				__args [0] = new JniArgumentValue (p0);
				__args [1] = new JniArgumentValue (native_p1);
				__args [2] = new JniArgumentValue (p2);
				__args [3] = new JniArgumentValue (native_p3);
				__args [4] = new JniArgumentValue (native_p4);
				var __rm = _members.StaticMethods.InvokeInt32Method (__id, __args);
				return __rm;
			} finally {
				if (p1 != null) {
					JNIEnv.CopyArray (native_p1, p1);
					JNIEnv.DeleteLocalRef (native_p1);
				}
				if (p3 != null) {
					JNIEnv.CopyArray (native_p3, p3);
					JNIEnv.DeleteLocalRef (native_p3);
				}
				if (p4 != null) {
					JNIEnv.CopyArray (native_p4, p4);
					JNIEnv.DeleteLocalRef (native_p4);
				}
				global::System.GC.KeepAlive (p1);
				global::System.GC.KeepAlive (p3);
				global::System.GC.KeepAlive (p4);
			}
		}

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.ftnative']/class[@name='FTNative']/method[@name='readerGetFirmwareVersion' and count(parameter)=2 and parameter[1][@type='byte[]'] and parameter[2][@type='int[]']]"
		[Register ("readerGetFirmwareVersion", "([B[I)I", "")]
		public static unsafe int ReaderGetFirmwareVersion (byte[] p0, int[] p1)
		{
			const string __id = "readerGetFirmwareVersion.([B[I)I";
			IntPtr native_p0 = JNIEnv.NewArray (p0);
			IntPtr native_p1 = JNIEnv.NewArray (p1);
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [2];
				__args [0] = new JniArgumentValue (native_p0);
				__args [1] = new JniArgumentValue (native_p1);
				var __rm = _members.StaticMethods.InvokeInt32Method (__id, __args);
				return __rm;
			} finally {
				if (p0 != null) {
					JNIEnv.CopyArray (native_p0, p0);
					JNIEnv.DeleteLocalRef (native_p0);
				}
				if (p1 != null) {
					JNIEnv.CopyArray (native_p1, p1);
					JNIEnv.DeleteLocalRef (native_p1);
				}
				global::System.GC.KeepAlive (p0);
				global::System.GC.KeepAlive (p1);
			}
		}

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.ftnative']/class[@name='FTNative']/method[@name='readerGetSlotStatus' and count(parameter)=2 and parameter[1][@type='int'] and parameter[2][@type='int[]']]"
		[Register ("readerGetSlotStatus", "(I[I)I", "")]
		public static unsafe int ReaderGetSlotStatus (int p0, int[] p1)
		{
			const string __id = "readerGetSlotStatus.(I[I)I";
			IntPtr native_p1 = JNIEnv.NewArray (p1);
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [2];
				__args [0] = new JniArgumentValue (p0);
				__args [1] = new JniArgumentValue (native_p1);
				var __rm = _members.StaticMethods.InvokeInt32Method (__id, __args);
				return __rm;
			} finally {
				if (p1 != null) {
					JNIEnv.CopyArray (native_p1, p1);
					JNIEnv.DeleteLocalRef (native_p1);
				}
				global::System.GC.KeepAlive (p1);
			}
		}

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.ftnative']/class[@name='FTNative']/method[@name='readerPowerOff' and count(parameter)=1 and parameter[1][@type='int']]"
		[Register ("readerPowerOff", "(I)I", "")]
		public static unsafe int ReaderPowerOff (int p0)
		{
			const string __id = "readerPowerOff.(I)I";
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [1];
				__args [0] = new JniArgumentValue (p0);
				var __rm = _members.StaticMethods.InvokeInt32Method (__id, __args);
				return __rm;
			} finally {
			}
		}

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.ftnative']/class[@name='FTNative']/method[@name='readerPowerOn' and count(parameter)=4 and parameter[1][@type='int'] and parameter[2][@type='byte[]'] and parameter[3][@type='int[]'] and parameter[4][@type='int']]"
		[Register ("readerPowerOn", "(I[B[II)I", "")]
		public static unsafe int ReaderPowerOn (int p0, byte[] p1, int[] p2, int p3)
		{
			const string __id = "readerPowerOn.(I[B[II)I";
			IntPtr native_p1 = JNIEnv.NewArray (p1);
			IntPtr native_p2 = JNIEnv.NewArray (p2);
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [4];
				__args [0] = new JniArgumentValue (p0);
				__args [1] = new JniArgumentValue (native_p1);
				__args [2] = new JniArgumentValue (native_p2);
				__args [3] = new JniArgumentValue (p3);
				var __rm = _members.StaticMethods.InvokeInt32Method (__id, __args);
				return __rm;
			} finally {
				if (p1 != null) {
					JNIEnv.CopyArray (native_p1, p1);
					JNIEnv.DeleteLocalRef (native_p1);
				}
				if (p2 != null) {
					JNIEnv.CopyArray (native_p2, p2);
					JNIEnv.DeleteLocalRef (native_p2);
				}
				global::System.GC.KeepAlive (p1);
				global::System.GC.KeepAlive (p2);
			}
		}

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.ftnative']/class[@name='FTNative']/method[@name='readerXfrBlock' and count(parameter)=5 and parameter[1][@type='int'] and parameter[2][@type='byte[]'] and parameter[3][@type='int'] and parameter[4][@type='byte[]'] and parameter[5][@type='int[]']]"
		[Register ("readerXfrBlock", "(I[BI[B[I)I", "")]
		public static unsafe int ReaderXfrBlock (int p0, byte[] p1, int p2, byte[] p3, int[] p4)
		{
			const string __id = "readerXfrBlock.(I[BI[B[I)I";
			IntPtr native_p1 = JNIEnv.NewArray (p1);
			IntPtr native_p3 = JNIEnv.NewArray (p3);
			IntPtr native_p4 = JNIEnv.NewArray (p4);
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [5];
				__args [0] = new JniArgumentValue (p0);
				__args [1] = new JniArgumentValue (native_p1);
				__args [2] = new JniArgumentValue (p2);
				__args [3] = new JniArgumentValue (native_p3);
				__args [4] = new JniArgumentValue (native_p4);
				var __rm = _members.StaticMethods.InvokeInt32Method (__id, __args);
				return __rm;
			} finally {
				if (p1 != null) {
					JNIEnv.CopyArray (native_p1, p1);
					JNIEnv.DeleteLocalRef (native_p1);
				}
				if (p3 != null) {
					JNIEnv.CopyArray (native_p3, p3);
					JNIEnv.DeleteLocalRef (native_p3);
				}
				if (p4 != null) {
					JNIEnv.CopyArray (native_p4, p4);
					JNIEnv.DeleteLocalRef (native_p4);
				}
				global::System.GC.KeepAlive (p1);
				global::System.GC.KeepAlive (p3);
				global::System.GC.KeepAlive (p4);
			}
		}

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.ftnative']/class[@name='FTNative']/method[@name='uninit' and count(parameter)=0]"
		[Register ("uninit", "()V", "")]
		public static unsafe void Uninit ()
		{
			const string __id = "uninit.()V";
			try {
				_members.StaticMethods.InvokeVoidMethod (__id, null);
			} finally {
			}
		}

	}
}
