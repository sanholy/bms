package com.qifenqian.bms.merchant.serviceparenter.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.mybatis.spring.annotation.MapperScan;

import com.qifenqian.bms.basemanager.merchant.bean.MerchantVo;

@MapperScan
public interface ServiceParenterMapper {

	List<MerchantVo> serviceList(MerchantVo merchantVo);

	List<MerchantVo> myServicesList(MerchantVo merchantVo);
	
	//zhanggc 查询代理商立标  
	List<MerchantVo> serviceNewList(MerchantVo merchantVo);
	
	/**
	 * zhanggc 表 td_cust_info 修改审核状态
	 */
	int updateTdCustInfoState(@Param("custId") String custId , @Param("newState") String newState, @Param("state") String state);
	/**
	 * zhanggc 表td_certificate_auth 修改审核状态
	 */
	int updateTdCertificateAuthState(@Param("custId") String custId ,@Param("newState") String newState, @Param("state") String state );
}
