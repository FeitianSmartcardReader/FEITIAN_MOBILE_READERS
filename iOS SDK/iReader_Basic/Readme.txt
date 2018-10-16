Please follow below steps:
1. Import SDK folder into your project
2. Project-Build->Phase-link binary with Libraries to add ExternalAccessory.framework, CoreBluetooth.framework
3. Import ReaderInterface.h, winscard.h header file into your code file.

Notice:
	- If the code file call API from winscard.h, please make sure you have change the stuffix from .m to .mm
	- The C++ Language Dialect set to GNU++ 14 [-std=gnu++14]
	- The C++ standard library set to libc++ (LLVM C++ standard library with C++11 support)
	- Set Enable Bitcode to Yes

