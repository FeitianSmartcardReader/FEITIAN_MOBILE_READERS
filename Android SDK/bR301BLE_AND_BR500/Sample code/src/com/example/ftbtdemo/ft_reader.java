package com.example.ftbtdemo;

import android.content.Context;
import android.os.Handler;
import com.feitianBLE.reader.devicecontrol.BleCard;
import com.feitianBLE.readerdk.Tool.DK;

public class ft_reader {
	private boolean isPowerOn = false;
	private BleCard inner_card;

	Handler mHandler;

	public ft_reader(String address, Context c) throws Exception {
		inner_card = new BleCard(address, c);
	}

	public boolean isPowerOn() {
		return isPowerOn;
	}

	public int PowerOn() throws FtBlueReadException {
		int ret = inner_card.PowerOn();
		if (ret != DK.RETURN_SUCCESS) {
			throw new FtBlueReadException("Power On Failed");
		}
		isPowerOn = true;
		return ret;
	}

	public int PowerOff() throws FtBlueReadException {
		int ret = inner_card.PowerOff();
		if (ret != DK.RETURN_SUCCESS) {
			throw new FtBlueReadException("Power Off Failed");
		}
		isPowerOn = false;
		return ret;
	}

	/**/
	public int getHardID(byte recvBuf[], int[] recvBufLen)
			throws FtBlueReadException {
		return inner_card.getHardID(recvBuf, recvBufLen);
	}

	public int getUserID(byte recvBuf[], int[] recvBufLen)
			throws FtBlueReadException {
		return inner_card.getUserID(recvBuf, recvBufLen);
	}

	public int genUserID(byte sendBuf[], int sendLeng)
			throws FtBlueReadException {
		return inner_card.genUserID(sendBuf, sendLeng);
	}

	public int earseUserID(byte sendBuf[], int sendLeng)
			throws FtBlueReadException {
		return inner_card.eraseUserID(sendBuf, sendLeng);
	}

	/**/
	public int getCardStatus() throws FtBlueReadException {
		return inner_card.getcardStatus();
	}

	public int getVersion(byte recvBuf[], int[] recvBufLen)
			throws FtBlueReadException {
		return inner_card.getVersion(recvBuf, recvBufLen);
	}

	public int writeFlash(byte writebuf[], int offset, int len)
			throws FtBlueReadException {
		return inner_card.cmdWriteFlash(writebuf, offset, len);
	}

	public int readFlash(byte recvBuf[], int offset, int len)
			throws FtBlueReadException {
		return inner_card.cmdReadFlash(recvBuf, offset, len);
	}

	/* new api for monitor the card status */
	public void registerCardStatusMonitoring(Handler Handler)
			throws FtBlueReadException {
		mHandler = Handler;
		if (inner_card.registerCardStatusMonitoring(Handler) != DK.RETURN_SUCCESS) {
			throw new FtBlueReadException("not support cardStatusMonitoring");
		}
	}

	public int transApdu(int tx_length, final byte tx_buffer[],
			int rx_length[], final byte rx_buffer[]) throws FtBlueReadException {
		if (isPowerOn == false) {
			throw new FtBlueReadException("Power Off already");
		}
		int ret = inner_card.transApdu(tx_length, tx_buffer, rx_length,
				rx_buffer);
		if (ret == DK.RETURN_SUCCESS) {
			return ret;
		}
		if (ret == DK.BUFFER_NOT_ENOUGH) {
			throw new FtBlueReadException("receive buffer not enough");
		} else if (ret == DK.CARD_ABSENT) {
			mHandler.obtainMessage(DK.CARD_STATUS, DK.CARD_ABSENT, -1)
					.sendToTarget();
			throw new FtBlueReadException("card is absent");
		} else {
			throw new FtBlueReadException("trans apdu error");
		}
	}
	
	public int getProtocol() throws FtBlueReadException{
		if(isPowerOn == false){
			throw new FtBlueReadException("Power Off already");
		}
		return inner_card.getProtocol();
	}

	public void readerClose() {
		inner_card.cardClose();
	}

}
