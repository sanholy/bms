package com.sevenpay.bms.basemanager.virtual.dao;

import java.util.List;

import org.gyzb.platform.web.page.Page;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.sevenpay.bms.basemanager.virtual.bean.AgentInfo;
import com.sevenpay.bms.basemanager.virtual.bean.MerchantInfo;
import com.sevenpay.bms.basemanager.virtual.bean.MerchantTradeInfo;
import com.sevenpay.bms.basemanager.virtual.mapper.MerchantInfoMapper;
import com.sevenpay.bms.basemanager.virtual.mapper.MerchantTradeInfoMapper;

@Repository
public class VirtualDAO {

	@Autowired
	private MerchantTradeInfoMapper merchantTradeInfoMapper;
	
	@Autowired
	private MerchantInfoMapper merchantInfoMapper;
	
	@Page
	public List<MerchantInfo> getInfos(MerchantInfo info){
		
		return merchantInfoMapper.getInfos(info);
	}
	
	@Page
	public List<AgentInfo> getAgentInfos(AgentInfo info){
		
		return merchantInfoMapper.getAgentInfo(info);
	}
	
	@Page
	public List<MerchantTradeInfo> getTradeInfos(MerchantTradeInfo info){
		
		return merchantTradeInfoMapper.getTradeInfos(info);
	}
	
	public String getTotalAmt(MerchantTradeInfo info) {
		return merchantTradeInfoMapper.getTotalAmt(info);
	}
	
	public void updateInfos(MerchantInfo info){
		merchantInfoMapper.updateInfos(info);
	}
}
