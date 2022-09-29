using System;
using System.Collections.Generic;
using Android.Runtime;
using Java.Interop;

namespace Com.Ftsafe {

	// Metadata.xml XPath class reference: path="/api/package[@name='com.ftsafe']/class[@name='Utility']"
	[global::Android.Runtime.Register ("com/ftsafe/Utility", DoNotGenerateAcw=true)]
	public partial class Utility : global::Java.Lang.Object {
		static readonly JniPeerMembers _members = new XAPeerMembers ("com/ftsafe/Utility", typeof (Utility));

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

		protected Utility (IntPtr javaReference, JniHandleOwnership transfer) : base (javaReference, transfer)
		{
		}

		// Metadata.xml XPath constructor reference: path="/api/package[@name='com.ftsafe']/class[@name='Utility']/constructor[@name='Utility' and count(parameter)=0]"
		[Register (".ctor", "()V", "")]
		public unsafe Utility () : base (IntPtr.Zero, JniHandleOwnership.DoNotTransfer)
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

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe']/class[@name='Utility']/method[@name='bytes2HexStr' and count(parameter)=1 and parameter[1][@type='byte[]']]"
		[Register ("bytes2HexStr", "([B)Ljava/lang/String;", "")]
		public static unsafe string Bytes2HexStr (byte[] src)
		{
			const string __id = "bytes2HexStr.([B)Ljava/lang/String;";
			IntPtr native_src = JNIEnv.NewArray (src);
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [1];
				__args [0] = new JniArgumentValue (native_src);
				var __rm = _members.StaticMethods.InvokeObjectMethod (__id, __args);
				return JNIEnv.GetString (__rm.Handle, JniHandleOwnership.TransferLocalRef);
			} finally {
				if (src != null) {
					JNIEnv.CopyArray (native_src, src);
					JNIEnv.DeleteLocalRef (native_src);
				}
				global::System.GC.KeepAlive (src);
			}
		}

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe']/class[@name='Utility']/method[@name='bytes2HexStr' and count(parameter)=2 and parameter[1][@type='byte[]'] and parameter[2][@type='int']]"
		[Register ("bytes2HexStr", "([BI)Ljava/lang/String;", "")]
		public static unsafe string Bytes2HexStr (byte[] src, int len)
		{
			const string __id = "bytes2HexStr.([BI)Ljava/lang/String;";
			IntPtr native_src = JNIEnv.NewArray (src);
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [2];
				__args [0] = new JniArgumentValue (native_src);
				__args [1] = new JniArgumentValue (len);
				var __rm = _members.StaticMethods.InvokeObjectMethod (__id, __args);
				return JNIEnv.GetString (__rm.Handle, JniHandleOwnership.TransferLocalRef);
			} finally {
				if (src != null) {
					JNIEnv.CopyArray (native_src, src);
					JNIEnv.DeleteLocalRef (native_src);
				}
				global::System.GC.KeepAlive (src);
			}
		}

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe']/class[@name='Utility']/method[@name='hexStrToBytes' and count(parameter)=1 and parameter[1][@type='java.lang.String']]"
		[Register ("hexStrToBytes", "(Ljava/lang/String;)[B", "")]
		public static unsafe byte[] HexStrToBytes (string hexString)
		{
			const string __id = "hexStrToBytes.(Ljava/lang/String;)[B";
			IntPtr native_hexString = JNIEnv.NewString ((string)hexString);
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [1];
				__args [0] = new JniArgumentValue (native_hexString);
				var __rm = _members.StaticMethods.InvokeObjectMethod (__id, __args);
				return (byte[]) JNIEnv.GetArray (__rm.Handle, JniHandleOwnership.TransferLocalRef, typeof (byte));
			} finally {
				JNIEnv.DeleteLocalRef (native_hexString);
			}
		}

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe']/class[@name='Utility']/method[@name='hexStrToBytes' and count(parameter)=2 and parameter[1][@type='java.lang.String'] and parameter[2][@type='int']]"
		[Register ("hexStrToBytes", "(Ljava/lang/String;I)[B", "")]
		public static unsafe byte[] HexStrToBytes (string hexString, int len)
		{
			const string __id = "hexStrToBytes.(Ljava/lang/String;I)[B";
			IntPtr native_hexString = JNIEnv.NewString ((string)hexString);
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [2];
				__args [0] = new JniArgumentValue (native_hexString);
				__args [1] = new JniArgumentValue (len);
				var __rm = _members.StaticMethods.InvokeObjectMethod (__id, __args);
				return (byte[]) JNIEnv.GetArray (__rm.Handle, JniHandleOwnership.TransferLocalRef, typeof (byte));
			} finally {
				JNIEnv.DeleteLocalRef (native_hexString);
			}
		}

	}
}
