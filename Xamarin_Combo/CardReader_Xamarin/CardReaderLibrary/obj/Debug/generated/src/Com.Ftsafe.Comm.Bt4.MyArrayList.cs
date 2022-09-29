using System;
using System.Collections.Generic;
using Android.Runtime;
using Java.Interop;

namespace Com.Ftsafe.Comm.Bt4 {

	// Metadata.xml XPath class reference: path="/api/package[@name='com.ftsafe.comm.bt4']/class[@name='MyArrayList']"
	[global::Android.Runtime.Register ("com/ftsafe/comm/bt4/MyArrayList", DoNotGenerateAcw=true)]
	[global::Java.Interop.JavaTypeParameters (new string [] {"T"})]
	public partial class MyArrayList : global::Java.Util.ArrayList {
		static readonly JniPeerMembers _members = new XAPeerMembers ("com/ftsafe/comm/bt4/MyArrayList", typeof (MyArrayList));

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

		protected MyArrayList (IntPtr javaReference, JniHandleOwnership transfer) : base (javaReference, transfer)
		{
		}

		// Metadata.xml XPath constructor reference: path="/api/package[@name='com.ftsafe.comm.bt4']/class[@name='MyArrayList']/constructor[@name='MyArrayList' and count(parameter)=0]"
		[Register (".ctor", "()V", "")]
		public unsafe MyArrayList () : base (IntPtr.Zero, JniHandleOwnership.DoNotTransfer)
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

		static Delegate cb_add_Ljava_lang_Object_;
#pragma warning disable 0169
		static Delegate GetAdd_Ljava_lang_Object_Handler ()
		{
			if (cb_add_Ljava_lang_Object_ == null)
				cb_add_Ljava_lang_Object_ = JNINativeWrapper.CreateDelegate ((_JniMarshal_PPL_Z) n_Add_Ljava_lang_Object_);
			return cb_add_Ljava_lang_Object_;
		}

		static bool n_Add_Ljava_lang_Object_ (IntPtr jnienv, IntPtr native__this, IntPtr native_t)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.Comm.Bt4.MyArrayList> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			var t = global::Java.Lang.Object.GetObject<global::Java.Lang.Object> (native_t, JniHandleOwnership.DoNotTransfer);
			bool __ret = __this.Add (t);
			return __ret;
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm.bt4']/class[@name='MyArrayList']/method[@name='add' and count(parameter)=1 and parameter[1][@type='T']]"
		[Register ("add", "(Ljava/lang/Object;)Z", "GetAdd_Ljava_lang_Object_Handler")]
		public override unsafe bool Add (global::Java.Lang.Object t)
		{
			const string __id = "add.(Ljava/lang/Object;)Z";
			IntPtr native_t = JNIEnv.ToLocalJniHandle (t);
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [1];
				__args [0] = new JniArgumentValue (native_t);
				var __rm = _members.InstanceMethods.InvokeVirtualBooleanMethod (__id, this, __args);
				return __rm;
			} finally {
				JNIEnv.DeleteLocalRef (native_t);
				global::System.GC.KeepAlive (t);
			}
		}

		static Delegate cb_resetTimer_Ljava_lang_Object_;
#pragma warning disable 0169
		static Delegate GetResetTimer_Ljava_lang_Object_Handler ()
		{
			if (cb_resetTimer_Ljava_lang_Object_ == null)
				cb_resetTimer_Ljava_lang_Object_ = JNINativeWrapper.CreateDelegate ((_JniMarshal_PPL_V) n_ResetTimer_Ljava_lang_Object_);
			return cb_resetTimer_Ljava_lang_Object_;
		}

		static void n_ResetTimer_Ljava_lang_Object_ (IntPtr jnienv, IntPtr native__this, IntPtr native_t)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.Comm.Bt4.MyArrayList> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			var t = global::Java.Lang.Object.GetObject<global::Java.Lang.Object> (native_t, JniHandleOwnership.DoNotTransfer);
			__this.ResetTimer (t);
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.comm.bt4']/class[@name='MyArrayList']/method[@name='resetTimer' and count(parameter)=1 and parameter[1][@type='T']]"
		[Register ("resetTimer", "(Ljava/lang/Object;)V", "GetResetTimer_Ljava_lang_Object_Handler")]
		public virtual unsafe void ResetTimer (global::Java.Lang.Object t)
		{
			const string __id = "resetTimer.(Ljava/lang/Object;)V";
			IntPtr native_t = JNIEnv.ToLocalJniHandle (t);
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [1];
				__args [0] = new JniArgumentValue (native_t);
				_members.InstanceMethods.InvokeVirtualVoidMethod (__id, this, __args);
			} finally {
				JNIEnv.DeleteLocalRef (native_t);
				global::System.GC.KeepAlive (t);
			}
		}

	}
}
