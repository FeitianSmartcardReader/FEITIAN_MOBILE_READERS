using System;
using CardReader_Xamarin;
using CardReader_Xamarin.iOS;
using Feitian.CardReader.Library.iOS;

[assembly: Xamarin.Forms.Dependency(typeof(CardReaderInterfaceImpl))]

namespace CardReader_Xamarin.iOS
{
    public class SubReaderInterfaceDelegate : ReaderInterfaceDelegate
    {
        CardReaderInterfaceImpl parent;

        public SubReaderInterfaceDelegate(CardReaderInterface parent)
        {
            this.parent = (CardReaderInterfaceImpl)parent;
        }



        public override void CardInterfaceDidDetach(bool attached)
        {

            if (attached == true)
            {
                //parent.ShowMessage("card insert");

                Console.WriteLine("card insert-----------------");
                InvokeOnMainThread(delegate {

                    parent.ShowMessage("card insert");
                });

            }
            else
            {
                //parent.ShowMessage("card absent");
                Console.WriteLine("card absent-----------------");


                InvokeOnMainThread(delegate {

                    parent.ShowMessage("card absent");
                });
            }
        }

        public override void ReaderInterfaceDidChange(bool attached, string bluetoothID)
        {
            string ss;
            if (attached == true)
            {
                ss = bluetoothID + "--" + "connect success";

                parent.cardreadername = bluetoothID;
            }
            else
            {
                ss = bluetoothID + "--" + "disconnect ";
            }
            Console.WriteLine(ss);
            //parent.ShowMessage(ss);

            InvokeOnMainThread(delegate {

                parent.ShowMessage(ss);
            });



        }

        public override void didGetBattery(int battery)
        {

        }

        public override void findPeripheralReader(string devicename)
        {

        }
    }
}
