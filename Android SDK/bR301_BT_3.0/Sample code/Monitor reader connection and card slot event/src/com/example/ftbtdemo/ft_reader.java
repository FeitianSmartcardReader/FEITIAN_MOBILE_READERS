package com.example.ftbtdemo;

import java.io.InputStream;
import java.io.OutputStream;

import android.os.Handler;
import com.feitian.reader.devicecontrol.Card;
import com.feitian.readerdk.Tool.DK;


public class ft_reader{
	private boolean isPowerOn   = false;
    private Card inner_card;
    
    Handler mHandler;
	public ft_reader(InputStream Intmp, OutputStream Outmp) {
		inner_card = new Card(Intmp, Outmp);
	}
	public boolean isPowerOn(){
		return isPowerOn;
	}
	public int PowerOn() throws FtBlueReadException{
		int ret = inner_card.PowerOn();
		if(ret != DK.RETURN_SUCCESS){
			throw new FtBlueReadException("Power On Failed");
		}
		isPowerOn = true;
		return ret;
	}
	public int PowerOff() throws FtBlueReadException{
		int ret = inner_card.PowerOff();
		if(ret != DK.RETURN_SUCCESS){
			throw new FtBlueReadException("Power Off Failed");
		}
		isPowerOn = false;
		return ret;
	}
	public int getProtocol() throws FtBlueReadException{
		if(isPowerOn == false){
			throw new FtBlueReadException("Power Off already");
		}
		return inner_card.getProtocol();
	}
	public byte[] getAtr() throws FtBlueReadException{
		if(isPowerOn == false){
			throw new FtBlueReadException("Power Off already");
		}
		return inner_card.getAtr();
	}
	public int getVersion(byte []recvBuf,int []recvBufLen){
		return inner_card.getVersion(recvBuf, recvBufLen);
	}
	
	public String getDkVersion(){
		return inner_card.GetDkVersion();
	}
	/**/
	public int getCardStatus() throws FtBlueReadException{
		return inner_card.getcardStatus();
	}
	
	/**/
	public int getSerialNum(byte[] serial,int serialLen[]){
		return inner_card.FtGetSerialNum(serial, serialLen);
	}
	public int readFlash(byte[] buf,int offset,int len){
		return inner_card.FtReadFlash(buf, offset, len);
	}
	public int writeFlash(byte[] buf,int offset,int len){
		return inner_card.FtWriteFlash(buf, offset, len);
	}
	
	//To minitor card slot status
	//new api for monitor the card status
	//#1 register card status monitoring 
	public void registerCardStatusMonitoring(Handler Handler) throws FtBlueReadException{
		 mHandler = Handler;
		 if(inner_card.registerCardStatusMonitoring(Handler) !=DK.RETURN_SUCCESS){
			 throw new FtBlueReadException("not support cardStatusMonitoring");
		 }
	}
	public int transApdu(int tx_length,final  byte tx_buffer[],
			int rx_length[],final  byte rx_buffer[]) throws FtBlueReadException{
		if(isPowerOn == false){
			throw new FtBlueReadException("Power Off already");
		}
		int ret = inner_card.transApdu(tx_length, tx_buffer, rx_length, rx_buffer);
		if(ret == DK.RETURN_SUCCESS){
			return ret;
		}
		if(ret == DK.BUFFER_NOT_ENOUGH){
			throw new FtBlueReadException("receive buffer not enough");
		}else if(ret == DK.CARD_ABSENT){
			mHandler.obtainMessage(DK.CARD_STATUS,
					DK.CARD_ABSENT, -1).sendToTarget();
			throw new FtBlueReadException("card is absent");
		}else{
			throw new FtBlueReadException("trans apdu error");
		}
	}
	public void readerClose(){
		inner_card.cardClose();
	}
	
}
