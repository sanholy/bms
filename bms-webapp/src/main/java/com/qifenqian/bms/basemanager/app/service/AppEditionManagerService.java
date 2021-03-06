/**
 * 
 */
package com.qifenqian.bms.basemanager.app.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.qifenqian.bms.basemanager.app.bean.TdAppEditionControl;
import com.qifenqian.bms.basemanager.app.dao.AppEditionManagerDao;
import com.qifenqian.bms.basemanager.app.mapper.TdAppEditionControlMapper;

/**
* @ClassName: AppEditionManagerService
* @Description: TODO(这里用一句话描述这个类的作用)
* @author LvFeng
* @date 2019年12月18日
*
*/
@Service
public class AppEditionManagerService {
	@Autowired
	private AppEditionManagerDao appEditionManagerDao;
	
	public List<TdAppEditionControl> listTdAppEditionControl(TdAppEditionControl tdAppEditionControl) {
		return appEditionManagerDao.listTdAppEditionControl(tdAppEditionControl);
	}
	
	public int updateTdAppEditionControl(TdAppEditionControl tdAppEditionControl) {
		return appEditionManagerDao.updateTdAppEditionControl(tdAppEditionControl);
	}
	
	public int insertTdAppEditionControl(TdAppEditionControl tdAppEditionControl) {
		//将之前的包状态改为失效
		TdAppEditionControl tdAppEditionControl1 = new TdAppEditionControl();
		tdAppEditionControl1.setState("99");
		tdAppEditionControl1.setCreator(tdAppEditionControl.getCreator());
		tdAppEditionControl1.setMachineType(tdAppEditionControl.getMachineType());
		int a = appEditionManagerDao.updateTdAppEditionControlLose(tdAppEditionControl1);
		int b = 0;
		if(a > 0) {
			b = appEditionManagerDao.insertTdAppEditionControl(tdAppEditionControl);
		}
		return b;
	}
}
