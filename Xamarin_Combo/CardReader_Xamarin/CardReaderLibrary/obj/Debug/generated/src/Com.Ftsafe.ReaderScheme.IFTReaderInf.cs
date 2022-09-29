using System;
using System.Collections.Generic;
using Android.Runtime;
using Java.Interop;

namespace Com.Ftsafe.ReaderScheme {

	// Metadata.xml XPath interface reference: path="/api/package[@name='com.ftsafe.readerScheme']/interface[@name='FTReaderInf']"
	[Register ("com/ftsafe/readerScheme/FTReaderInf", "", "Com.Ftsafe.ReaderScheme.IFTReaderInfInvoker")]
	public partial interface IFTReaderInf : IJavaObject, IJavaPeerable {
		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.readerScheme']/interface[@name='FTReaderInf']/method[@name='ft_close' and count(parameter)=0]"
		[Register ("ft_close", "()V", "GetFt_closeHandler:Com.Ftsafe.ReaderScheme.IFTReaderInfInvoker, CardReaderLibrary")]
		void Ft_close ();

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.readerScheme']/interface[@name='FTReaderInf']/method[@name='ft_control' and count(parameter)=6 and parameter[1][@type='int'] and parameter[2][@type='int'] and parameter[3][@type='int'] and parameter[4][@type='int'] and parameter[5][@type='int'] and parameter[6][@type='int']]"
		[Register ("ft_control", "(IIIIII)[B", "GetFt_control_IIIIIIHandler:Com.Ftsafe.ReaderScheme.IFTReaderInfInvoker, CardReaderLibrary")]
		byte[] Ft_control (int p0, int p1, int p2, int p3, int p4, int p5);

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.readerScheme']/interface[@name='FTReaderInf']/method[@name='ft_find' and count(parameter)=0]"
		[Register ("ft_find", "()V", "GetFt_findHandler:Com.Ftsafe.ReaderScheme.IFTReaderInfInvoker, CardReaderLibrary")]
		void Ft_find ();

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.readerScheme']/interface[@name='FTReaderInf']/method[@name='ft_open' and count(parameter)=1 and parameter[1][@type='java.lang.Object']]"
		[Register ("ft_open", "(Ljava/lang/Object;)V", "GetFt_open_Ljava_lang_Object_Handler:Com.Ftsafe.ReaderScheme.IFTReaderInfInvoker, CardReaderLibrary")]
		void Ft_open (global::Java.Lang.Object p0);

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.readerScheme']/interface[@name='FTReaderInf']/method[@name='ft_recv' and count(parameter)=2 and parameter[1][@type='int'] and parameter[2][@type='int']]"
		[Register ("ft_recv", "(II)[B", "GetFt_recv_IIHandler:Com.Ftsafe.ReaderScheme.IFTReaderInfInvoker, CardReaderLibrary")]
		byte[] Ft_recv (int p0, int p1);

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.readerScheme']/interface[@name='FTReaderInf']/method[@name='ft_send' and count(parameter)=3 and parameter[1][@type='int'] and parameter[2][@type='byte[]'] and parameter[3][@type='int']]"
		[Register ("ft_send", "(I[BI)V", "GetFt_send_IarrayBIHandler:Com.Ftsafe.ReaderScheme.IFTReaderInfInvoker, CardReaderLibrary")]
		void Ft_send (int p0, byte[] p1, int p2);

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.readerScheme']/interface[@name='FTReaderInf']/method[@name='isFtExist' and count(parameter)=0]"
		[Register ("isFtExist", "()Ljava/lang/Boolean;", "GetIsFtExistHandler:Com.Ftsafe.ReaderScheme.IFTReaderInfInvoker, CardReaderLibrary")]
		global::Java.Lang.Boolean IsFtExist ();

	}

	[global::Android.Runtime.Register ("com/ftsafe/readerScheme/FTReaderInf", DoNotGenerateAcw=true)]
	internal partial class IFTReaderInfInvoker : global::Java.Lang.Object, IFTReaderInf {
		static readonly JniPeerMembers _members = new XAPeerMembers ("com/ftsafe/readerScheme/FTReaderInf", typeof (IFTReaderInfInvoker));

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

		public static IFTReaderInf GetObject (IntPtr handle, JniHandleOwnership transfer)
		{
			return global::Java.Lang.Object.GetObject<IFTReaderInf> (handle, transfer);
		}

		static IntPtr Validate (IntPtr handle)
		{
			if (!JNIEnv.IsInstanceOf (handle, java_class_ref))
				throw new InvalidCastException ($"Unable to convert instance of type '{JNIEnv.GetClassNameFromInstance (handle)}' to type 'com.ftsafe.readerScheme.FTReaderInf'.");
			return handle;
		}

		protected override void Dispose (bool disposing)
		{
			if (this.class_ref != IntPtr.Zero)
				JNIEnv.DeleteGlobalRef (this.class_ref);
			this.class_ref = IntPtr.Zero;
			base.Dispose (disposing);
		}

		public IFTReaderInfInvoker (IntPtr handle, JniHandleOwnership transfer) : base (Validate (handle), transfer)
		{
			IntPtr local_ref = JNIEnv.GetObjectClass (((global::Java.Lang.Object) this).Handle);
			this.class_ref = JNIEnv.NewGlobalRef (local_ref);
			JNIEnv.DeleteLocalRef (local_ref);
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
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.ReaderScheme.IFTReaderInf> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			__this.Ft_close ();
		}
#pragma warning restore 0169

		IntPtr id_ft_close;
		public unsafe void Ft_close ()
		{
			if (id_ft_close == IntPtr.Zero)
				id_ft_close = JNIEnv.GetMethodID (class_ref, "ft_close", "()V");
			JNIEnv.CallVoidMethod (((global::Java.Lang.Object) this).Handle, id_ft_close);
		}

		static Delegate cb_ft_control_IIIIII;
#pragma warning disable 0169
		static Delegate GetFt_control_IIIIIIHandler ()
		{
			if (cb_ft_control_IIIIII == null)
				cb_ft_control_IIIIII = JNINativeWrapper.CreateDelegate ((_JniMarshal_PPIIIIII_L) n_Ft_control_IIIIII);
			return cb_ft_control_IIIIII;
		}

		static IntPtr n_Ft_control_IIIIII (IntPtr jnienv, IntPtr native__this, int p0, int p1, int p2, int p3, int p4, int p5)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.ReaderScheme.IFTReaderInf> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			return JNIEnv.NewArray (__this.Ft_control (p0, p1, p2, p3, p4, p5));
		}
#pragma warning restore 0169

		IntPtr id_ft_control_IIIIII;
		public unsafe byte[] Ft_control (int p0, int p1, int p2, int p3, int p4, int p5)
		{
			if (id_ft_control_IIIIII == IntPtr.Zero)
				id_ft_control_IIIIII = JNIEnv.GetMethodID (class_ref, "ft_control", "(IIIIII)[B");
			JValue* __args = stackalloc JValue [6];
			__args [0] = new JValue (p0);
			__args [1] = new JValue (p1);
			__args [2] = new JValue (p2);
			__args [3] = new JValue (p3);
			__args [4] = new JValue (p4);
			__args [5] = new JValue (p5);
			return (byte[]) JNIEnv.GetArray (JNIEnv.CallObjectMethod (((global::Java.Lang.Object) this).Handle, id_ft_control_IIIIII, __args), JniHandleOwnership.TransferLocalRef, typeof (byte));
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
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.ReaderScheme.IFTReaderInf> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			__this.Ft_find ();
		}
#pragma warning restore 0169

		IntPtr id_ft_find;
		public unsafe void Ft_find ()
		{
			if (id_ft_find == IntPtr.Zero)
				id_ft_find = JNIEnv.GetMethodID (class_ref, "ft_find", "()V");
			JNIEnv.CallVoidMethod (((global::Java.Lang.Object) this).Handle, id_ft_find);
		}

		static Delegate cb_ft_open_Ljava_lang_Object_;
#pragma warning disable 0169
		static Delegate GetFt_open_Ljava_lang_Object_Handler ()
		{
			if (cb_ft_open_Ljava_lang_Object_ == null)
				cb_ft_open_Ljava_lang_Object_ = JNINativeWrapper.CreateDelegate ((_JniMarshal_PPL_V) n_Ft_open_Ljava_lang_Object_);
			return cb_ft_open_Ljava_lang_Object_;
		}

		static void n_Ft_open_Ljava_lang_Object_ (IntPtr jnienv, IntPtr native__this, IntPtr native_p0)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.ReaderScheme.IFTReaderInf> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			var p0 = global::Java.Lang.Object.GetObject<global::Java.Lang.Object> (native_p0, JniHandleOwnership.DoNotTransfer);
			__this.Ft_open (p0);
		}
#pragma warning restore 0169

		IntPtr id_ft_open_Ljava_lang_Object_;
		public unsafe void Ft_open (global::Java.Lang.Object p0)
		{
			if (id_ft_open_Ljava_lang_Object_ == IntPtr.Zero)
				id_ft_open_Ljava_lang_Object_ = JNIEnv.GetMethodID (class_ref, "ft_open", "(Ljava/lang/Object;)V");
			JValue* __args = stackalloc JValue [1];
			__args [0] = new JValue ((p0 == null) ? IntPtr.Zero : ((global::Java.Lang.Object) p0).Handle);
			JNIEnv.CallVoidMethod (((global::Java.Lang.Object) this).Handle, id_ft_open_Ljava_lang_Object_, __args);
		}

		static Delegate cb_ft_recv_II;
#pragma warning disable 0169
		static Delegate GetFt_recv_IIHandler ()
		{
			if (cb_ft_recv_II == null)
				cb_ft_recv_II = JNINativeWrapper.CreateDelegate ((_JniMarshal_PPII_L) n_Ft_recv_II);
			return cb_ft_recv_II;
		}

		static IntPtr n_Ft_recv_II (IntPtr jnienv, IntPtr native__this, int p0, int p1)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.ReaderScheme.IFTReaderInf> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			return JNIEnv.NewArray (__this.Ft_recv (p0, p1));
		}
#pragma warning restore 0169

		IntPtr id_ft_recv_II;
		public unsafe byte[] Ft_recv (int p0, int p1)
		{
			if (id_ft_recv_II == IntPtr.Zero)
				id_ft_recv_II = JNIEnv.GetMethodID (class_ref, "ft_recv", "(II)[B");
			JValue* __args = stackalloc JValue [2];
			__args [0] = new JValue (p0);
			__args [1] = new JValue (p1);
			return (byte[]) JNIEnv.GetArray (JNIEnv.CallObjectMethod (((global::Java.Lang.Object) this).Handle, id_ft_recv_II, __args), JniHandleOwnership.TransferLocalRef, typeof (byte));
		}

		static Delegate cb_ft_send_IarrayBI;
#pragma warning disable 0169
		static Delegate GetFt_send_IarrayBIHandler ()
		{
			if (cb_ft_send_IarrayBI == null)
				cb_ft_send_IarrayBI = JNINativeWrapper.CreateDelegate ((_JniMarshal_PPILI_V) n_Ft_send_IarrayBI);
			return cb_ft_send_IarrayBI;
		}

		static void n_Ft_send_IarrayBI (IntPtr jnienv, IntPtr native__this, int p0, IntPtr native_p1, int p2)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.ReaderScheme.IFTReaderInf> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			var p1 = (byte[]) JNIEnv.GetArray (native_p1, JniHandleOwnership.DoNotTransfer, typeof (byte));
			__this.Ft_send (p0, p1, p2);
			if (p1 != null)
				JNIEnv.CopyArray (p1, native_p1);
		}
#pragma warning restore 0169

		IntPtr id_ft_send_IarrayBI;
		public unsafe void Ft_send (int p0, byte[] p1, int p2)
		{
			if (id_ft_send_IarrayBI == IntPtr.Zero)
				id_ft_send_IarrayBI = JNIEnv.GetMethodID (class_ref, "ft_send", "(I[BI)V");
			IntPtr native_p1 = JNIEnv.NewArray (p1);
			JValue* __args = stackalloc JValue [3];
			__args [0] = new JValue (p0);
			__args [1] = new JValue (native_p1);
			__args [2] = new JValue (p2);
			JNIEnv.CallVoidMethod (((global::Java.Lang.Object) this).Handle, id_ft_send_IarrayBI, __args);
			if (p1 != null) {
				JNIEnv.CopyArray (native_p1, p1);
				JNIEnv.DeleteLocalRef (native_p1);
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
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.ReaderScheme.IFTReaderInf> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			return JNIEnv.ToLocalJniHandle (__this.IsFtExist ());
		}
#pragma warning restore 0169

		IntPtr id_isFtExist;
		public unsafe global::Java.Lang.Boolean IsFtExist ()
		{
			if (id_isFtExist == IntPtr.Zero)
				id_isFtExist = JNIEnv.GetMethodID (class_ref, "isFtExist", "()Ljava/lang/Boolean;");
			return global::Java.Lang.Object.GetObject<global::Java.Lang.Boolean> (JNIEnv.CallObjectMethod (((global::Java.Lang.Object) this).Handle, id_isFtExist), JniHandleOwnership.TransferLocalRef);
		}

	}
}
