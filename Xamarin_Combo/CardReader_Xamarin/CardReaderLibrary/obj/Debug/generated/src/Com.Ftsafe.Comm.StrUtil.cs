using System;
using System.Collections.Generic;
using Android.Runtime;
using Java.Interop;

namespace Com.Ftsafe.Comm {

	// Metadata.xml XPath class reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='StrUtil']"
	[global::Android.Runtime.Register ("com/ftsafe/comm/StrUtil", DoNotGenerateAcw=true)]
	public partial class StrUtil : global::Java.Lang.Object {
		static readonly JniPeerMembers _members = new XAPeerMembers ("com/ftsafe/comm/StrUtil", typeof (StrUtil));

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

		protected StrUtil (IntPtr javaReference, JniHandleOwnership transfer) : base (javaReference, transfer)
		{
		}

		// Metadata.xml XPath constructor reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='StrUtil']/constructor[@name='StrUtil' and count(parameter)=0]"
		[Register (".ctor", "()V", "")]
		public unsafe StrUtil () : base (IntPtr.Zero, JniHandleOwnership.DoNotTransfer)
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

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='StrUtil']/method[@name='byte2HexStr' and count(parameter)=1 and parameter[1][@type='byte']]"
		[Register ("byte2HexStr", "(B)Ljava/lang/String;", "")]
		public static unsafe string Byte2HexStr (sbyte b)
		{
			const string __id = "byte2HexStr.(B)Ljava/lang/String;";
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [1];
				__args [0] = new JniArgumentValue (b);
				var __rm = _members.StaticMethods.InvokeObjectMethod (__id, __args);
				return JNIEnv.GetString (__rm.Handle, JniHandleOwnership.TransferLocalRef);
			} finally {
			}
		}

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='StrUtil']/method[@name='byte2int' and count(parameter)=1 and parameter[1][@type='byte[]']]"
		[Register ("byte2int", "([B)I", "")]
		public static unsafe int Byte2int (byte[] res)
		{
			const string __id = "byte2int.([B)I";
			IntPtr native_res = JNIEnv.NewArray (res);
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [1];
				__args [0] = new JniArgumentValue (native_res);
				var __rm = _members.StaticMethods.InvokeInt32Method (__id, __args);
				return __rm;
			} finally {
				if (res != null) {
					JNIEnv.CopyArray (native_res, res);
					JNIEnv.DeleteLocalRef (native_res);
				}
				global::System.GC.KeepAlive (res);
			}
		}

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='StrUtil']/method[@name='byteArr2HexStr' and count(parameter)=1 and parameter[1][@type='byte[]']]"
		[Register ("byteArr2HexStr", "([B)Ljava/lang/String;", "")]
		public static unsafe string ByteArr2HexStr (byte[] bt)
		{
			const string __id = "byteArr2HexStr.([B)Ljava/lang/String;";
			IntPtr native_bt = JNIEnv.NewArray (bt);
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [1];
				__args [0] = new JniArgumentValue (native_bt);
				var __rm = _members.StaticMethods.InvokeObjectMethod (__id, __args);
				return JNIEnv.GetString (__rm.Handle, JniHandleOwnership.TransferLocalRef);
			} finally {
				if (bt != null) {
					JNIEnv.CopyArray (native_bt, bt);
					JNIEnv.DeleteLocalRef (native_bt);
				}
				global::System.GC.KeepAlive (bt);
			}
		}

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='StrUtil']/method[@name='byteArr2HexStr' and count(parameter)=3 and parameter[1][@type='byte[]'] and parameter[2][@type='int'] and parameter[3][@type='int']]"
		[Register ("byteArr2HexStr", "([BII)Ljava/lang/String;", "")]
		public static unsafe string ByteArr2HexStr (byte[] bt, int start, int end)
		{
			const string __id = "byteArr2HexStr.([BII)Ljava/lang/String;";
			IntPtr native_bt = JNIEnv.NewArray (bt);
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [3];
				__args [0] = new JniArgumentValue (native_bt);
				__args [1] = new JniArgumentValue (start);
				__args [2] = new JniArgumentValue (end);
				var __rm = _members.StaticMethods.InvokeObjectMethod (__id, __args);
				return JNIEnv.GetString (__rm.Handle, JniHandleOwnership.TransferLocalRef);
			} finally {
				if (bt != null) {
					JNIEnv.CopyArray (native_bt, bt);
					JNIEnv.DeleteLocalRef (native_bt);
				}
				global::System.GC.KeepAlive (bt);
			}
		}

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='StrUtil']/method[@name='byteArr2HexStr' and count(parameter)=4 and parameter[1][@type='byte[]'] and parameter[2][@type='int'] and parameter[3][@type='int'] and parameter[4][@type='java.lang.String']]"
		[Register ("byteArr2HexStr", "([BIILjava/lang/String;)Ljava/lang/String;", "")]
		public static unsafe string ByteArr2HexStr (byte[] bt, int start, int end, string sep)
		{
			const string __id = "byteArr2HexStr.([BIILjava/lang/String;)Ljava/lang/String;";
			IntPtr native_bt = JNIEnv.NewArray (bt);
			IntPtr native_sep = JNIEnv.NewString ((string)sep);
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [4];
				__args [0] = new JniArgumentValue (native_bt);
				__args [1] = new JniArgumentValue (start);
				__args [2] = new JniArgumentValue (end);
				__args [3] = new JniArgumentValue (native_sep);
				var __rm = _members.StaticMethods.InvokeObjectMethod (__id, __args);
				return JNIEnv.GetString (__rm.Handle, JniHandleOwnership.TransferLocalRef);
			} finally {
				if (bt != null) {
					JNIEnv.CopyArray (native_bt, bt);
					JNIEnv.DeleteLocalRef (native_bt);
				}
				JNIEnv.DeleteLocalRef (native_sep);
				global::System.GC.KeepAlive (bt);
			}
		}

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='StrUtil']/method[@name='byteArr2HexStr' and count(parameter)=3 and parameter[1][@type='byte[]'] and parameter[2][@type='int'] and parameter[3][@type='java.lang.String']]"
		[Register ("byteArr2HexStr", "([BILjava/lang/String;)Ljava/lang/String;", "")]
		public static unsafe string ByteArr2HexStr (byte[] bt, int end, string sep)
		{
			const string __id = "byteArr2HexStr.([BILjava/lang/String;)Ljava/lang/String;";
			IntPtr native_bt = JNIEnv.NewArray (bt);
			IntPtr native_sep = JNIEnv.NewString ((string)sep);
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [3];
				__args [0] = new JniArgumentValue (native_bt);
				__args [1] = new JniArgumentValue (end);
				__args [2] = new JniArgumentValue (native_sep);
				var __rm = _members.StaticMethods.InvokeObjectMethod (__id, __args);
				return JNIEnv.GetString (__rm.Handle, JniHandleOwnership.TransferLocalRef);
			} finally {
				if (bt != null) {
					JNIEnv.CopyArray (native_bt, bt);
					JNIEnv.DeleteLocalRef (native_bt);
				}
				JNIEnv.DeleteLocalRef (native_sep);
				global::System.GC.KeepAlive (bt);
			}
		}

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='StrUtil']/method[@name='byteArr2HexStr' and count(parameter)=2 and parameter[1][@type='byte[]'] and parameter[2][@type='java.lang.String']]"
		[Register ("byteArr2HexStr", "([BLjava/lang/String;)Ljava/lang/String;", "")]
		public static unsafe string ByteArr2HexStr (byte[] bt, string sep)
		{
			const string __id = "byteArr2HexStr.([BLjava/lang/String;)Ljava/lang/String;";
			IntPtr native_bt = JNIEnv.NewArray (bt);
			IntPtr native_sep = JNIEnv.NewString ((string)sep);
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [2];
				__args [0] = new JniArgumentValue (native_bt);
				__args [1] = new JniArgumentValue (native_sep);
				var __rm = _members.StaticMethods.InvokeObjectMethod (__id, __args);
				return JNIEnv.GetString (__rm.Handle, JniHandleOwnership.TransferLocalRef);
			} finally {
				if (bt != null) {
					JNIEnv.CopyArray (native_bt, bt);
					JNIEnv.DeleteLocalRef (native_bt);
				}
				JNIEnv.DeleteLocalRef (native_sep);
				global::System.GC.KeepAlive (bt);
			}
		}

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='StrUtil']/method[@name='byteArr2Int' and count(parameter)=3 and parameter[1][@type='byte[]'] and parameter[2][@type='int'] and parameter[3][@type='int']]"
		[Register ("byteArr2Int", "([BII)I", "")]
		public static unsafe int ByteArr2Int (byte[] b, int start, int len)
		{
			const string __id = "byteArr2Int.([BII)I";
			IntPtr native_b = JNIEnv.NewArray (b);
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [3];
				__args [0] = new JniArgumentValue (native_b);
				__args [1] = new JniArgumentValue (start);
				__args [2] = new JniArgumentValue (len);
				var __rm = _members.StaticMethods.InvokeInt32Method (__id, __args);
				return __rm;
			} finally {
				if (b != null) {
					JNIEnv.CopyArray (native_b, b);
					JNIEnv.DeleteLocalRef (native_b);
				}
				global::System.GC.KeepAlive (b);
			}
		}

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='StrUtil']/method[@name='compare' and count(parameter)=2 and parameter[1][@type='java.util.List&lt;T&gt;'] and parameter[2][@type='java.util.List&lt;T&gt;']]"
		[Register ("compare", "(Ljava/util/List;Ljava/util/List;)Z", "")]
		[global::Java.Interop.JavaTypeParameters (new string [] {"T extends java.lang.Comparable<T>"})]
		public static unsafe bool Compare (global::System.Collections.IList a, global::System.Collections.IList b)
		{
			const string __id = "compare.(Ljava/util/List;Ljava/util/List;)Z";
			IntPtr native_a = global::Android.Runtime.JavaList.ToLocalJniHandle (a);
			IntPtr native_b = global::Android.Runtime.JavaList.ToLocalJniHandle (b);
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [2];
				__args [0] = new JniArgumentValue (native_a);
				__args [1] = new JniArgumentValue (native_b);
				var __rm = _members.StaticMethods.InvokeBooleanMethod (__id, __args);
				return __rm;
			} finally {
				JNIEnv.DeleteLocalRef (native_a);
				JNIEnv.DeleteLocalRef (native_b);
				global::System.GC.KeepAlive (a);
				global::System.GC.KeepAlive (b);
			}
		}

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='StrUtil']/method[@name='hexChar2Byte' and count(parameter)=1 and parameter[1][@type='char']]"
		[Register ("hexChar2Byte", "(C)B", "")]
		public static unsafe sbyte HexChar2Byte (char c)
		{
			const string __id = "hexChar2Byte.(C)B";
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [1];
				__args [0] = new JniArgumentValue (c);
				var __rm = _members.StaticMethods.InvokeSByteMethod (__id, __args);
				return __rm;
			} finally {
			}
		}

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='StrUtil']/method[@name='hexStr2Byte' and count(parameter)=1 and parameter[1][@type='java.lang.String']]"
		[Register ("hexStr2Byte", "(Ljava/lang/String;)B", "")]
		public static unsafe sbyte HexStr2Byte (string str)
		{
			const string __id = "hexStr2Byte.(Ljava/lang/String;)B";
			IntPtr native_str = JNIEnv.NewString ((string)str);
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [1];
				__args [0] = new JniArgumentValue (native_str);
				var __rm = _members.StaticMethods.InvokeSByteMethod (__id, __args);
				return __rm;
			} finally {
				JNIEnv.DeleteLocalRef (native_str);
			}
		}

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='StrUtil']/method[@name='hexStr2ByteArr' and count(parameter)=1 and parameter[1][@type='java.lang.String']]"
		[Register ("hexStr2ByteArr", "(Ljava/lang/String;)[B", "")]
		public static unsafe byte[] HexStr2ByteArr (string str)
		{
			const string __id = "hexStr2ByteArr.(Ljava/lang/String;)[B";
			IntPtr native_str = JNIEnv.NewString ((string)str);
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [1];
				__args [0] = new JniArgumentValue (native_str);
				var __rm = _members.StaticMethods.InvokeObjectMethod (__id, __args);
				return (byte[]) JNIEnv.GetArray (__rm.Handle, JniHandleOwnership.TransferLocalRef, typeof (byte));
			} finally {
				JNIEnv.DeleteLocalRef (native_str);
			}
		}

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='StrUtil']/method[@name='int2byte' and count(parameter)=1 and parameter[1][@type='int']]"
		[Register ("int2byte", "(I)[B", "")]
		public static unsafe byte[] Int2byte (int res)
		{
			const string __id = "int2byte.(I)[B";
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [1];
				__args [0] = new JniArgumentValue (res);
				var __rm = _members.StaticMethods.InvokeObjectMethod (__id, __args);
				return (byte[]) JNIEnv.GetArray (__rm.Handle, JniHandleOwnership.TransferLocalRef, typeof (byte));
			} finally {
			}
		}

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='StrUtil']/method[@name='toString' and count(parameter)=1 and parameter[1][@type='android.util.SparseArray&lt;byte[]&gt;']]"
		[Register ("toString", "(Landroid/util/SparseArray;)Ljava/lang/String;", "")]
		public static unsafe string ToString (global::Android.Util.SparseArray array)
		{
			const string __id = "toString.(Landroid/util/SparseArray;)Ljava/lang/String;";
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [1];
				__args [0] = new JniArgumentValue ((array == null) ? IntPtr.Zero : ((global::Java.Lang.Object) array).Handle);
				var __rm = _members.StaticMethods.InvokeObjectMethod (__id, __args);
				return JNIEnv.GetString (__rm.Handle, JniHandleOwnership.TransferLocalRef);
			} finally {
				global::System.GC.KeepAlive (array);
			}
		}

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm']/class[@name='StrUtil']/method[@name='toString' and count(parameter)=1 and parameter[1][@type='java.util.Map&lt;T, byte[]&gt;']]"
		[Register ("toString", "(Ljava/util/Map;)Ljava/lang/String;", "")]
		[global::Java.Interop.JavaTypeParameters (new string [] {"T"})]
		public static unsafe string ToString (global::System.Collections.IDictionary map)
		{
			const string __id = "toString.(Ljava/util/Map;)Ljava/lang/String;";
			IntPtr native_map = global::Android.Runtime.JavaDictionary.ToLocalJniHandle (map);
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [1];
				__args [0] = new JniArgumentValue (native_map);
				var __rm = _members.StaticMethods.InvokeObjectMethod (__id, __args);
				return JNIEnv.GetString (__rm.Handle, JniHandleOwnership.TransferLocalRef);
			} finally {
				JNIEnv.DeleteLocalRef (native_map);
				global::System.GC.KeepAlive (map);
			}
		}

	}
}
