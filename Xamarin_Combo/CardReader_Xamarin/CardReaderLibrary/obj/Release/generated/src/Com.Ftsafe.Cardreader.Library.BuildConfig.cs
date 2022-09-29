using System;
using System.Collections.Generic;
using Android.Runtime;
using Java.Interop;

namespace Com.Ftsafe.Cardreader.Library {

	// Metadata.xml XPath class reference: path="/api/package[@name='com.ftsafe.cardreader.library']/class[@name='BuildConfig']"
	[global::Android.Runtime.Register ("com/ftsafe/cardreader/library/BuildConfig", DoNotGenerateAcw=true)]
	public sealed partial class BuildConfig : global::Java.Lang.Object {
		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe.cardreader.library']/class[@name='BuildConfig']/field[@name='BUILD_TYPE']"
		[Register ("BUILD_TYPE")]
		public const string BuildType = (string) "debug";


		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe.cardreader.library']/class[@name='BuildConfig']/field[@name='DEBUG']"
		[Register ("DEBUG")]
		public static bool Debug {
			get {
				const string __id = "DEBUG.Z";

				var __v = _members.StaticFields.GetBooleanValue (__id);
				return __v;
			}
		}

		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe.cardreader.library']/class[@name='BuildConfig']/field[@name='LIBRARY_PACKAGE_NAME']"
		[Register ("LIBRARY_PACKAGE_NAME")]
		public const string LibraryPackageName = (string) "com.ftsafe.cardreader.library";

		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe.cardreader.library']/class[@name='BuildConfig']/field[@name='VERSION_CODE']"
		[Register ("VERSION_CODE")]
		public const int VersionCode = (int) 1;

		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe.cardreader.library']/class[@name='BuildConfig']/field[@name='VERSION_NAME']"
		[Register ("VERSION_NAME")]
		public const string VersionName = (string) "1.0";

		static readonly JniPeerMembers _members = new XAPeerMembers ("com/ftsafe/cardreader/library/BuildConfig", typeof (BuildConfig));

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

		internal BuildConfig (IntPtr javaReference, JniHandleOwnership transfer) : base (javaReference, transfer)
		{
		}

		// Metadata.xml XPath constructor reference: path="/api/package[@name='com.ftsafe.cardreader.library']/class[@name='BuildConfig']/constructor[@name='BuildConfig' and count(parameter)=0]"
		[Register (".ctor", "()V", "")]
		public unsafe BuildConfig () : base (IntPtr.Zero, JniHandleOwnership.DoNotTransfer)
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

	}
}
