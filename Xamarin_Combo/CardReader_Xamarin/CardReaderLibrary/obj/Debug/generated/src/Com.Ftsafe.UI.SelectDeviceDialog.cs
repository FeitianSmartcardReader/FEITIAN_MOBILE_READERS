using System;
using System.Collections.Generic;
using Android.Runtime;
using Java.Interop;

namespace Com.Ftsafe.UI {

	// Metadata.xml XPath class reference: path="/api/package[@name='com.ftsafe.ui']/class[@name='SelectDeviceDialog']"
	[global::Android.Runtime.Register ("com/ftsafe/ui/SelectDeviceDialog", DoNotGenerateAcw=true)]
	public partial class SelectDeviceDialog : global::Android.App.Dialog, global::Android.Content.IDialogInterfaceOnCancelListener, global::Android.Content.IDialogInterfaceOnShowListener, global::Android.Views.View.IOnClickListener, global::Android.Widget.AdapterView.IOnItemClickListener {
		static readonly JniPeerMembers _members = new XAPeerMembers ("com/ftsafe/ui/SelectDeviceDialog", typeof (SelectDeviceDialog));

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

		protected SelectDeviceDialog (IntPtr javaReference, JniHandleOwnership transfer) : base (javaReference, transfer)
		{
		}

		// Metadata.xml XPath constructor reference: path="/api/package[@name='com.ftsafe.ui']/class[@name='SelectDeviceDialog']/constructor[@name='SelectDeviceDialog' and count(parameter)=3 and parameter[1][@type='android.content.Context'] and parameter[2][@type='com.ftsafe.readerScheme.FTReader'] and parameter[3][@type='android.os.Handler']]"
		[Register (".ctor", "(Landroid/content/Context;Lcom/ftsafe/readerScheme/FTReader;Landroid/os/Handler;)V", "")]
		public unsafe SelectDeviceDialog (global::Android.Content.Context context, global::Com.Ftsafe.ReaderScheme.FTReader reader, global::Android.OS.Handler handler) : base (IntPtr.Zero, JniHandleOwnership.DoNotTransfer)
		{
			const string __id = "(Landroid/content/Context;Lcom/ftsafe/readerScheme/FTReader;Landroid/os/Handler;)V";

			if (((global::Java.Lang.Object) this).Handle != IntPtr.Zero)
				return;

			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [3];
				__args [0] = new JniArgumentValue ((context == null) ? IntPtr.Zero : ((global::Java.Lang.Object) context).Handle);
				__args [1] = new JniArgumentValue ((reader == null) ? IntPtr.Zero : ((global::Java.Lang.Object) reader).Handle);
				__args [2] = new JniArgumentValue ((handler == null) ? IntPtr.Zero : ((global::Java.Lang.Object) handler).Handle);
				var __r = _members.InstanceMethods.StartCreateInstance (__id, ((object) this).GetType (), __args);
				SetHandle (__r.Handle, JniHandleOwnership.TransferLocalRef);
				_members.InstanceMethods.FinishCreateInstance (__id, this, __args);
			} finally {
				global::System.GC.KeepAlive (context);
				global::System.GC.KeepAlive (reader);
				global::System.GC.KeepAlive (handler);
			}
		}

		static Delegate cb_onCancel_Landroid_content_DialogInterface_;
#pragma warning disable 0169
		static Delegate GetOnCancel_Landroid_content_DialogInterface_Handler ()
		{
			if (cb_onCancel_Landroid_content_DialogInterface_ == null)
				cb_onCancel_Landroid_content_DialogInterface_ = JNINativeWrapper.CreateDelegate ((_JniMarshal_PPL_V) n_OnCancel_Landroid_content_DialogInterface_);
			return cb_onCancel_Landroid_content_DialogInterface_;
		}

		static void n_OnCancel_Landroid_content_DialogInterface_ (IntPtr jnienv, IntPtr native__this, IntPtr native_dialog)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.UI.SelectDeviceDialog> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			var dialog = (global::Android.Content.IDialogInterface)global::Java.Lang.Object.GetObject<global::Android.Content.IDialogInterface> (native_dialog, JniHandleOwnership.DoNotTransfer);
			__this.OnCancel (dialog);
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.ui']/class[@name='SelectDeviceDialog']/method[@name='onCancel' and count(parameter)=1 and parameter[1][@type='android.content.DialogInterface']]"
		[Register ("onCancel", "(Landroid/content/DialogInterface;)V", "GetOnCancel_Landroid_content_DialogInterface_Handler")]
		public virtual unsafe void OnCancel (global::Android.Content.IDialogInterface dialog)
		{
			const string __id = "onCancel.(Landroid/content/DialogInterface;)V";
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [1];
				__args [0] = new JniArgumentValue ((dialog == null) ? IntPtr.Zero : ((global::Java.Lang.Object) dialog).Handle);
				_members.InstanceMethods.InvokeVirtualVoidMethod (__id, this, __args);
			} finally {
				global::System.GC.KeepAlive (dialog);
			}
		}

		static Delegate cb_onClick_Landroid_view_View_;
#pragma warning disable 0169
		static Delegate GetOnClick_Landroid_view_View_Handler ()
		{
			if (cb_onClick_Landroid_view_View_ == null)
				cb_onClick_Landroid_view_View_ = JNINativeWrapper.CreateDelegate ((_JniMarshal_PPL_V) n_OnClick_Landroid_view_View_);
			return cb_onClick_Landroid_view_View_;
		}

		static void n_OnClick_Landroid_view_View_ (IntPtr jnienv, IntPtr native__this, IntPtr native_v)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.UI.SelectDeviceDialog> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			var v = global::Java.Lang.Object.GetObject<global::Android.Views.View> (native_v, JniHandleOwnership.DoNotTransfer);
			__this.OnClick (v);
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.ui']/class[@name='SelectDeviceDialog']/method[@name='onClick' and count(parameter)=1 and parameter[1][@type='android.view.View']]"
		[Register ("onClick", "(Landroid/view/View;)V", "GetOnClick_Landroid_view_View_Handler")]
		public virtual unsafe void OnClick (global::Android.Views.View v)
		{
			const string __id = "onClick.(Landroid/view/View;)V";
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [1];
				__args [0] = new JniArgumentValue ((v == null) ? IntPtr.Zero : ((global::Java.Lang.Object) v).Handle);
				_members.InstanceMethods.InvokeVirtualVoidMethod (__id, this, __args);
			} finally {
				global::System.GC.KeepAlive (v);
			}
		}

		static Delegate cb_onItemClick_Landroid_widget_AdapterView_Landroid_view_View_IJ;
#pragma warning disable 0169
		static Delegate GetOnItemClick_Landroid_widget_AdapterView_Landroid_view_View_IJHandler ()
		{
			if (cb_onItemClick_Landroid_widget_AdapterView_Landroid_view_View_IJ == null)
				cb_onItemClick_Landroid_widget_AdapterView_Landroid_view_View_IJ = JNINativeWrapper.CreateDelegate ((_JniMarshal_PPLLIJ_V) n_OnItemClick_Landroid_widget_AdapterView_Landroid_view_View_IJ);
			return cb_onItemClick_Landroid_widget_AdapterView_Landroid_view_View_IJ;
		}

		static void n_OnItemClick_Landroid_widget_AdapterView_Landroid_view_View_IJ (IntPtr jnienv, IntPtr native__this, IntPtr native_parent, IntPtr native_view, int position, long id)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.UI.SelectDeviceDialog> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			var parent = global::Java.Lang.Object.GetObject<global::Android.Widget.AdapterView> (native_parent, JniHandleOwnership.DoNotTransfer);
			var view = global::Java.Lang.Object.GetObject<global::Android.Views.View> (native_view, JniHandleOwnership.DoNotTransfer);
			__this.OnItemClick (parent, view, position, id);
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.ui']/class[@name='SelectDeviceDialog']/method[@name='onItemClick' and count(parameter)=4 and parameter[1][@type='android.widget.AdapterView&lt;?&gt;'] and parameter[2][@type='android.view.View'] and parameter[3][@type='int'] and parameter[4][@type='long']]"
		[Register ("onItemClick", "(Landroid/widget/AdapterView;Landroid/view/View;IJ)V", "GetOnItemClick_Landroid_widget_AdapterView_Landroid_view_View_IJHandler")]
		public virtual unsafe void OnItemClick (global::Android.Widget.AdapterView parent, global::Android.Views.View view, int position, long id)
		{
			const string __id = "onItemClick.(Landroid/widget/AdapterView;Landroid/view/View;IJ)V";
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [4];
				__args [0] = new JniArgumentValue ((parent == null) ? IntPtr.Zero : ((global::Java.Lang.Object) parent).Handle);
				__args [1] = new JniArgumentValue ((view == null) ? IntPtr.Zero : ((global::Java.Lang.Object) view).Handle);
				__args [2] = new JniArgumentValue (position);
				__args [3] = new JniArgumentValue (id);
				_members.InstanceMethods.InvokeVirtualVoidMethod (__id, this, __args);
			} finally {
				global::System.GC.KeepAlive (parent);
				global::System.GC.KeepAlive (view);
			}
		}

		static Delegate cb_onShow_Landroid_content_DialogInterface_;
#pragma warning disable 0169
		static Delegate GetOnShow_Landroid_content_DialogInterface_Handler ()
		{
			if (cb_onShow_Landroid_content_DialogInterface_ == null)
				cb_onShow_Landroid_content_DialogInterface_ = JNINativeWrapper.CreateDelegate ((_JniMarshal_PPL_V) n_OnShow_Landroid_content_DialogInterface_);
			return cb_onShow_Landroid_content_DialogInterface_;
		}

		static void n_OnShow_Landroid_content_DialogInterface_ (IntPtr jnienv, IntPtr native__this, IntPtr native_dialog)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.UI.SelectDeviceDialog> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			var dialog = (global::Android.Content.IDialogInterface)global::Java.Lang.Object.GetObject<global::Android.Content.IDialogInterface> (native_dialog, JniHandleOwnership.DoNotTransfer);
			__this.OnShow (dialog);
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.ui']/class[@name='SelectDeviceDialog']/method[@name='onShow' and count(parameter)=1 and parameter[1][@type='android.content.DialogInterface']]"
		[Register ("onShow", "(Landroid/content/DialogInterface;)V", "GetOnShow_Landroid_content_DialogInterface_Handler")]
		public virtual unsafe void OnShow (global::Android.Content.IDialogInterface dialog)
		{
			const string __id = "onShow.(Landroid/content/DialogInterface;)V";
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [1];
				__args [0] = new JniArgumentValue ((dialog == null) ? IntPtr.Zero : ((global::Java.Lang.Object) dialog).Handle);
				_members.InstanceMethods.InvokeVirtualVoidMethod (__id, this, __args);
			} finally {
				global::System.GC.KeepAlive (dialog);
			}
		}

		static Delegate cb_setData_Landroid_bluetooth_BluetoothDevice_;
#pragma warning disable 0169
		static Delegate GetSetData_Landroid_bluetooth_BluetoothDevice_Handler ()
		{
			if (cb_setData_Landroid_bluetooth_BluetoothDevice_ == null)
				cb_setData_Landroid_bluetooth_BluetoothDevice_ = JNINativeWrapper.CreateDelegate ((_JniMarshal_PPL_V) n_SetData_Landroid_bluetooth_BluetoothDevice_);
			return cb_setData_Landroid_bluetooth_BluetoothDevice_;
		}

		static void n_SetData_Landroid_bluetooth_BluetoothDevice_ (IntPtr jnienv, IntPtr native__this, IntPtr native_device)
		{
			var __this = global::Java.Lang.Object.GetObject<global::Com.Ftsafe.UI.SelectDeviceDialog> (jnienv, native__this, JniHandleOwnership.DoNotTransfer);
			var device = global::Java.Lang.Object.GetObject<global::Android.Bluetooth.BluetoothDevice> (native_device, JniHandleOwnership.DoNotTransfer);
			__this.SetData (device);
		}
#pragma warning restore 0169

		// Metadata.xml XPath method reference: path="/api/package[@name='com.ftsafe.ui']/class[@name='SelectDeviceDialog']/method[@name='setData' and count(parameter)=1 and parameter[1][@type='android.bluetooth.BluetoothDevice']]"
		[Register ("setData", "(Landroid/bluetooth/BluetoothDevice;)V", "GetSetData_Landroid_bluetooth_BluetoothDevice_Handler")]
		public virtual unsafe void SetData (global::Android.Bluetooth.BluetoothDevice device)
		{
			const string __id = "setData.(Landroid/bluetooth/BluetoothDevice;)V";
			try {
				JniArgumentValue* __args = stackalloc JniArgumentValue [1];
				__args [0] = new JniArgumentValue ((device == null) ? IntPtr.Zero : ((global::Java.Lang.Object) device).Handle);
				_members.InstanceMethods.InvokeVirtualVoidMethod (__id, this, __args);
			} finally {
				global::System.GC.KeepAlive (device);
			}
		}

	}
}
