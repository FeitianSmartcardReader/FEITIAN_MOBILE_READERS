using System;
using System.Collections.Generic;
using Android.Runtime;
using Java.Interop;

namespace Com.Ftsafe {

	// Metadata.xml XPath class reference: path="/api/package[@name='com.ftsafe']/class[@name='DK']"
	[global::Android.Runtime.Register ("com/ftsafe/DK", DoNotGenerateAcw=true)]
	public partial class DK : global::Java.Lang.Object {
		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe']/class[@name='DK']/field[@name='BT3_DISCONNECTED']"
		[Register ("BT3_DISCONNECTED")]
		public const int Bt3Disconnected = (int) 114;

		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe']/class[@name='DK']/field[@name='BT3_LOG']"
		[Register ("BT3_LOG")]
		public const int Bt3Log = (int) 112;

		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe']/class[@name='DK']/field[@name='BT3_NEW']"
		[Register ("BT3_NEW")]
		public const int Bt3New = (int) 113;

		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe']/class[@name='DK']/field[@name='BT4_ACL_DISCONNECTED']"
		[Register ("BT4_ACL_DISCONNECTED")]
		public const int Bt4AclDisconnected = (int) 130;

		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe']/class[@name='DK']/field[@name='BT4_CONNECTED']"
		[Register ("BT4_CONNECTED")]
		public const int Bt4Connected = (int) 131;

		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe']/class[@name='DK']/field[@name='BT4_LOG']"
		[Register ("BT4_LOG")]
		public const int Bt4Log = (int) 128;

		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe']/class[@name='DK']/field[@name='BT4_NEW']"
		[Register ("BT4_NEW")]
		public const int Bt4New = (int) 129;

		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe']/class[@name='DK']/field[@name='CARD_IN_MASK']"
		[Register ("CARD_IN_MASK")]
		public const int CardInMask = (int) 256;

		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe']/class[@name='DK']/field[@name='CARD_NO_PRESENT']"
		[Register ("CARD_NO_PRESENT")]
		public const int CardNoPresent = (int) 2;

		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe']/class[@name='DK']/field[@name='CARD_OUT_MASK']"
		[Register ("CARD_OUT_MASK")]
		public const int CardOutMask = (int) 512;

		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe']/class[@name='DK']/field[@name='CARD_PRESENT_ACTIVE']"
		[Register ("CARD_PRESENT_ACTIVE")]
		public const int CardPresentActive = (int) 0;

		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe']/class[@name='DK']/field[@name='CARD_PRESENT_INACTIVE']"
		[Register ("CARD_PRESENT_INACTIVE")]
		public const int CardPresentInactive = (int) 1;

		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe']/class[@name='DK']/field[@name='CCIDSCHEME_LOG']"
		[Register ("CCIDSCHEME_LOG")]
		public const int CcidschemeLog = (int) 64;

		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe']/class[@name='DK']/field[@name='FTREADER_LOG']"
		[Register ("FTREADER_LOG")]
		public const int FtreaderLog = (int) 80;

		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe']/class[@name='DK']/field[@name='FTREADER_TYPE_BT3']"
		[Register ("FTREADER_TYPE_BT3")]
		public const int FtreaderTypeBt3 = (int) 1;

		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe']/class[@name='DK']/field[@name='FTREADER_TYPE_BT4']"
		[Register ("FTREADER_TYPE_BT4")]
		public const int FtreaderTypeBt4 = (int) 2;

		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe']/class[@name='DK']/field[@name='FTREADER_TYPE_USB']"
		[Register ("FTREADER_TYPE_USB")]
		public const int FtreaderTypeUsb = (int) 0;

		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe']/class[@name='DK']/field[@name='PCSCSERVER_LOG']"
		[Register ("PCSCSERVER_LOG")]
		public const int PcscserverLog = (int) 96;

		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe']/class[@name='DK']/field[@name='READER_BR301']"
		[Register ("READER_BR301")]
		public const int ReaderBr301 = (int) 105;

		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe']/class[@name='DK']/field[@name='READER_BR301FC4']"
		[Register ("READER_BR301FC4")]
		public const int ReaderBr301fc4 = (int) 101;

		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe']/class[@name='DK']/field[@name='READER_BR500']"
		[Register ("READER_BR500")]
		public const int ReaderBr500 = (int) 102;

		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe']/class[@name='DK']/field[@name='READER_IR301']"
		[Register ("READER_IR301")]
		public const int ReaderIr301 = (int) 107;

		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe']/class[@name='DK']/field[@name='READER_IR301_LT']"
		[Register ("READER_IR301_LT")]
		public const int ReaderIr301Lt = (int) 106;

		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe']/class[@name='DK']/field[@name='READER_R301E']"
		[Register ("READER_R301E")]
		public const int ReaderR301e = (int) 100;

		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe']/class[@name='DK']/field[@name='READER_R502_C9_U01']"
		[Register ("READER_R502_C9_U01")]
		public const int ReaderR502C9U01 = (int) 109;

		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe']/class[@name='DK']/field[@name='READER_R502_C9_U02']"
		[Register ("READER_R502_C9_U02")]
		public const int ReaderR502C9U02 = (int) 110;

		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe']/class[@name='DK']/field[@name='READER_R502_C9_U10']"
		[Register ("READER_R502_C9_U10")]
		public const int ReaderR502C9U10 = (int) 111;

		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe']/class[@name='DK']/field[@name='READER_R502_C9_U11']"
		[Register ("READER_R502_C9_U11")]
		public const int ReaderR502C9U11 = (int) 112;

		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe']/class[@name='DK']/field[@name='READER_R502_C9_U12']"
		[Register ("READER_R502_C9_U12")]
		public const int ReaderR502C9U12 = (int) 113;

		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe']/class[@name='DK']/field[@name='READER_R502_CL']"
		[Register ("READER_R502_CL")]
		public const int ReaderR502Cl = (int) 103;

		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe']/class[@name='DK']/field[@name='READER_R502_DUAL']"
		[Register ("READER_R502_DUAL")]
		public const int ReaderR502Dual = (int) 104;

		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe']/class[@name='DK']/field[@name='READER_UNKNOWN']"
		[Register ("READER_UNKNOWN")]
		public const int ReaderUnknown = (int) 120;

		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe']/class[@name='DK']/field[@name='READER_VR504']"
		[Register ("READER_VR504")]
		public const int ReaderVr504 = (int) 108;

		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe']/class[@name='DK']/field[@name='USB_IN']"
		[Register ("USB_IN")]
		public const int UsbIn = (int) 17;

		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe']/class[@name='DK']/field[@name='USB_LOG']"
		[Register ("USB_LOG")]
		public const int UsbLog = (int) 16;

		// Metadata.xml XPath field reference: path="/api/package[@name='com.ftsafe']/class[@name='DK']/field[@name='USB_OUT']"
		[Register ("USB_OUT")]
		public const int UsbOut = (int) 18;

		static readonly JniPeerMembers _members = new XAPeerMembers ("com/ftsafe/DK", typeof (DK));

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

		protected DK (IntPtr javaReference, JniHandleOwnership transfer) : base (javaReference, transfer)
		{
		}

		// Metadata.xml XPath constructor reference: path="/api/package[@name='com.ftsafe']/class[@name='DK']/constructor[@name='DK' and count(parameter)=0]"
		[Register (".ctor", "()V", "")]
		public unsafe DK () : base (IntPtr.Zero, JniHandleOwnership.DoNotTransfer)
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
