using System;

[assembly:global::Android.Runtime.NamespaceMapping (Java = "com.ftsafe", Managed="Com.Ftsafe")]
[assembly:global::Android.Runtime.NamespaceMapping (Java = "com.ftsafe.cardreader.library", Managed="Com.Ftsafe.Cardreader.Library")]
[assembly:global::Android.Runtime.NamespaceMapping (Java = "com.ftsafe.comm", Managed="Com.Ftsafe.Comm")]
[assembly:global::Android.Runtime.NamespaceMapping (Java = "com.ftsafe.comm.bt3", Managed="Com.Ftsafe.Comm.Bt3")]
[assembly:global::Android.Runtime.NamespaceMapping (Java = "com.ftsafe.comm.bt4", Managed="Com.Ftsafe.Comm.Bt4")]
[assembly:global::Android.Runtime.NamespaceMapping (Java = "com.ftsafe.comm.usb", Managed="Com.Ftsafe.Comm.Usb")]
[assembly:global::Android.Runtime.NamespaceMapping (Java = "com.ftsafe.ftnative", Managed="Com.Ftsafe.Ftnative")]
[assembly:global::Android.Runtime.NamespaceMapping (Java = "com.ftsafe.readerScheme", Managed="Com.Ftsafe.ReaderScheme")]
[assembly:global::Android.Runtime.NamespaceMapping (Java = "com.ftsafe.ui", Managed="Com.Ftsafe.UI")]
[assembly:global::Android.Runtime.NamespaceMapping (Java = "com.ftsafe.util", Managed="Com.Ftsafe.Util")]

delegate int _JniMarshal_PP_I (IntPtr jnienv, IntPtr klass);
delegate IntPtr _JniMarshal_PP_L (IntPtr jnienv, IntPtr klass);
delegate void _JniMarshal_PP_V (IntPtr jnienv, IntPtr klass);
delegate bool _JniMarshal_PP_Z (IntPtr jnienv, IntPtr klass);
delegate int _JniMarshal_PPI_I (IntPtr jnienv, IntPtr klass, int p0);
delegate IntPtr _JniMarshal_PPI_L (IntPtr jnienv, IntPtr klass, int p0);
delegate void _JniMarshal_PPI_V (IntPtr jnienv, IntPtr klass, int p0);
delegate IntPtr _JniMarshal_PPII_L (IntPtr jnienv, IntPtr klass, int p0, int p1);
delegate IntPtr _JniMarshal_PPIIIIII_L (IntPtr jnienv, IntPtr klass, int p0, int p1, int p2, int p3, int p4, int p5);
delegate int _JniMarshal_PPIILL_I (IntPtr jnienv, IntPtr klass, int p0, int p1, IntPtr p2, IntPtr p3);
delegate IntPtr _JniMarshal_PPIL_L (IntPtr jnienv, IntPtr klass, int p0, IntPtr p1);
delegate void _JniMarshal_PPIL_V (IntPtr jnienv, IntPtr klass, int p0, IntPtr p1);
delegate int _JniMarshal_PPILI_I (IntPtr jnienv, IntPtr klass, int p0, IntPtr p1, int p2);
delegate void _JniMarshal_PPILI_V (IntPtr jnienv, IntPtr klass, int p0, IntPtr p1, int p2);
delegate IntPtr _JniMarshal_PPL_L (IntPtr jnienv, IntPtr klass, IntPtr p0);
delegate void _JniMarshal_PPL_V (IntPtr jnienv, IntPtr klass, IntPtr p0);
delegate bool _JniMarshal_PPL_Z (IntPtr jnienv, IntPtr klass, IntPtr p0);
delegate void _JniMarshal_PPLII_V (IntPtr jnienv, IntPtr klass, IntPtr p0, int p1, int p2);
delegate int _JniMarshal_PPLL_I (IntPtr jnienv, IntPtr klass, IntPtr p0, IntPtr p1);
delegate void _JniMarshal_PPLL_V (IntPtr jnienv, IntPtr klass, IntPtr p0, IntPtr p1);
delegate void _JniMarshal_PPLLI_V (IntPtr jnienv, IntPtr klass, IntPtr p0, IntPtr p1, int p2);
delegate void _JniMarshal_PPLLIJ_V (IntPtr jnienv, IntPtr klass, IntPtr p0, IntPtr p1, int p2, long p3);
delegate IntPtr _JniMarshal_PPZ_L (IntPtr jnienv, IntPtr klass, bool p0);
delegate bool _JniMarshal_PPZ_Z (IntPtr jnienv, IntPtr klass, bool p0);
#if !NET
namespace System.Runtime.Versioning {
    [System.Diagnostics.Conditional("NEVER")]
    [AttributeUsage(AttributeTargets.Assembly | AttributeTargets.Class | AttributeTargets.Constructor | AttributeTargets.Event | AttributeTargets.Method | AttributeTargets.Module | AttributeTargets.Property | AttributeTargets.Struct, AllowMultiple = true, Inherited = false)]
    internal sealed class SupportedOSPlatformAttribute : Attribute {
        public SupportedOSPlatformAttribute (string platformName) { }
    }
}
#endif

