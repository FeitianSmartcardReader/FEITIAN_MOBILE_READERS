//
// Auto-generated from generator.cs, do not edit
//
// We keep references to objects, so warning 414 is expected
#pragma warning disable 414
using System;
using System.Drawing;
using System.Diagnostics;
using System.ComponentModel;
using System.Threading.Tasks;
using System.Runtime.InteropServices;
using System.Diagnostics.CodeAnalysis;
using UIKit;
using GLKit;
using Metal;
using CoreML;
using MapKit;
using Photos;
using ModelIO;
using Network;
using SceneKit;
using Contacts;
using Security;
using Messages;
using AudioUnit;
using CoreVideo;
using CoreMedia;
using QuickLook;
using CoreImage;
using SpriteKit;
using Foundation;
using CoreMotion;
using ObjCRuntime;
using AddressBook;
using MediaPlayer;
using GameplayKit;
using CoreGraphics;
using CoreLocation;
using AVFoundation;
using NewsstandKit;
using FileProvider;
using CoreAnimation;
using CoreFoundation;
using NetworkExtension;
using MetalPerformanceShadersGraph;
#nullable enable
#if !NET
using NativeHandle = System.IntPtr;
#endif
namespace Feitian.CardReader.Library.iOS {
	[Protocol (Name = "ReaderInterfaceDelegate", WrapperType = typeof (ReaderInterfaceDelegateWrapper))]
	[ProtocolMember (IsRequired = true, IsProperty = false, IsStatic = false, Name = "findPeripheralReader", Selector = "findPeripheralReader:", ParameterType = new Type [] { typeof (string) }, ParameterByRef = new bool [] { false })]
	[ProtocolMember (IsRequired = true, IsProperty = false, IsStatic = false, Name = "ReaderInterfaceDidChange", Selector = "readerInterfaceDidChange:bluetoothID:", ParameterType = new Type [] { typeof (bool), typeof (string) }, ParameterByRef = new bool [] { false, false })]
	[ProtocolMember (IsRequired = true, IsProperty = false, IsStatic = false, Name = "CardInterfaceDidDetach", Selector = "cardInterfaceDidDetach:", ParameterType = new Type [] { typeof (bool) }, ParameterByRef = new bool [] { false })]
	[ProtocolMember (IsRequired = true, IsProperty = false, IsStatic = false, Name = "didGetBattery", Selector = "didGetBattery:", ParameterType = new Type [] { typeof (int) }, ParameterByRef = new bool [] { false })]
	public partial interface IReaderInterfaceDelegate : INativeObject, IDisposable
	{
		[BindingImpl (BindingImplOptions.GeneratedCode | BindingImplOptions.Optimizable)]
		[Export ("findPeripheralReader:")]
		[Preserve (Conditional = true)]
		void findPeripheralReader (string devicename);
		[BindingImpl (BindingImplOptions.GeneratedCode | BindingImplOptions.Optimizable)]
		[Export ("readerInterfaceDidChange:bluetoothID:")]
		[Preserve (Conditional = true)]
		void ReaderInterfaceDidChange (bool attached, string bluetoothID);
		[BindingImpl (BindingImplOptions.GeneratedCode | BindingImplOptions.Optimizable)]
		[Export ("cardInterfaceDidDetach:")]
		[Preserve (Conditional = true)]
		void CardInterfaceDidDetach (bool attached);
		[BindingImpl (BindingImplOptions.GeneratedCode | BindingImplOptions.Optimizable)]
		[Export ("didGetBattery:")]
		[Preserve (Conditional = true)]
		void didGetBattery (int battery);
	}
	internal sealed class ReaderInterfaceDelegateWrapper : BaseWrapper, IReaderInterfaceDelegate {
		[Preserve (Conditional = true)]
		public ReaderInterfaceDelegateWrapper (IntPtr handle, bool owns)
			: base (handle, owns)
		{
		}
		[Export ("findPeripheralReader:")]
		[BindingImpl (BindingImplOptions.GeneratedCode | BindingImplOptions.Optimizable)]
		public void findPeripheralReader (string devicename)
		{
			if (devicename is null)
				ObjCRuntime.ThrowHelper.ThrowArgumentNullException (nameof (devicename));
			var nsdevicename = CFString.CreateNative (devicename);
			global::ApiDefinition.Messaging.void_objc_msgSend_IntPtr (this.Handle, Selector.GetHandle ("findPeripheralReader:"), nsdevicename);
			CFString.ReleaseNative (nsdevicename);
		}
		[Export ("readerInterfaceDidChange:bluetoothID:")]
		[BindingImpl (BindingImplOptions.GeneratedCode | BindingImplOptions.Optimizable)]
		public void ReaderInterfaceDidChange (bool attached, string bluetoothID)
		{
			if (bluetoothID is null)
				ObjCRuntime.ThrowHelper.ThrowArgumentNullException (nameof (bluetoothID));
			var nsbluetoothID = CFString.CreateNative (bluetoothID);
			global::ApiDefinition.Messaging.void_objc_msgSend_bool_IntPtr (this.Handle, Selector.GetHandle ("readerInterfaceDidChange:bluetoothID:"), attached, nsbluetoothID);
			CFString.ReleaseNative (nsbluetoothID);
		}
		[Export ("cardInterfaceDidDetach:")]
		[BindingImpl (BindingImplOptions.GeneratedCode | BindingImplOptions.Optimizable)]
		public void CardInterfaceDidDetach (bool attached)
		{
			global::ApiDefinition.Messaging.void_objc_msgSend_bool (this.Handle, Selector.GetHandle ("cardInterfaceDidDetach:"), attached);
		}
		[Export ("didGetBattery:")]
		[BindingImpl (BindingImplOptions.GeneratedCode | BindingImplOptions.Optimizable)]
		public void didGetBattery (int battery)
		{
			global::ApiDefinition.Messaging.void_objc_msgSend_int (this.Handle, Selector.GetHandle ("didGetBattery:"), battery);
		}
	}
}
namespace Feitian.CardReader.Library.iOS {
	[Protocol()]
	[Register("ReaderInterfaceDelegate", false)]
	[Model]
	public unsafe abstract partial class ReaderInterfaceDelegate : NSObject, IReaderInterfaceDelegate {
		[BindingImpl (BindingImplOptions.GeneratedCode | BindingImplOptions.Optimizable)]
		[EditorBrowsable (EditorBrowsableState.Advanced)]
		[Export ("init")]
		protected ReaderInterfaceDelegate () : base (NSObjectFlag.Empty)
		{
			IsDirectBinding = false;
			InitializeHandle (global::ApiDefinition.Messaging.IntPtr_objc_msgSendSuper (this.SuperHandle, global::ObjCRuntime.Selector.GetHandle ("init")), "init");
		}

		[BindingImpl (BindingImplOptions.GeneratedCode | BindingImplOptions.Optimizable)]
		[EditorBrowsable (EditorBrowsableState.Advanced)]
		protected ReaderInterfaceDelegate (NSObjectFlag t) : base (t)
		{
			IsDirectBinding = false;
		}

		[BindingImpl (BindingImplOptions.GeneratedCode | BindingImplOptions.Optimizable)]
		[EditorBrowsable (EditorBrowsableState.Advanced)]
		protected internal ReaderInterfaceDelegate (IntPtr handle) : base (handle)
		{
			IsDirectBinding = false;
		}

		[Export ("cardInterfaceDidDetach:")]
		[BindingImpl (BindingImplOptions.GeneratedCode | BindingImplOptions.Optimizable)]
		public abstract void CardInterfaceDidDetach (bool attached);
		[Export ("readerInterfaceDidChange:bluetoothID:")]
		[BindingImpl (BindingImplOptions.GeneratedCode | BindingImplOptions.Optimizable)]
		public abstract void ReaderInterfaceDidChange (bool attached, string bluetoothID);
		[Export ("didGetBattery:")]
		[BindingImpl (BindingImplOptions.GeneratedCode | BindingImplOptions.Optimizable)]
		public abstract void didGetBattery (int battery);
		[Export ("findPeripheralReader:")]
		[BindingImpl (BindingImplOptions.GeneratedCode | BindingImplOptions.Optimizable)]
		public abstract void findPeripheralReader (string devicename);
	} /* class ReaderInterfaceDelegate */
}
