package com.qifenqian.bms.merchant.reports.service;

import com.qifenqian.bms.merchant.reports.bean.TdMerchantReportDetail;

/**
 * @description:
 * @author: LiBin
 * @date: 2019/12/25 0025 17:08
 */
public interface TdMerchantReportDetailService {

    TdMerchantReportDetail getDetailParams(String jsonString);

    int addMerchantReportDetail(TdMerchantReportDetail tdMerchantReportDetail);
}
