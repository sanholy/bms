package com.qifenqian.bms.merchant.serviceparenter;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.filefilter.TrueFileFilter;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.alibaba.fastjson.JSONObject;
import com.qifenqian.bms.basemanager.agency.bean.AgenReport;
import com.qifenqian.bms.basemanager.bank.bean.Bank;
import com.qifenqian.bms.basemanager.bank.mapper.BankMapper;
import com.qifenqian.bms.basemanager.city.service.CityService;
import com.qifenqian.bms.basemanager.custInfo.bean.TdCustInfo;
import com.qifenqian.bms.basemanager.custInfo.bean.TdLoginUserInfo;
import com.qifenqian.bms.basemanager.custInfo.mapper.TdCustInfoMapper;
import com.qifenqian.bms.basemanager.custInfo.service.TdCustInfoService;
import com.qifenqian.bms.basemanager.merchant.bean.Merchant;
import com.qifenqian.bms.basemanager.merchant.bean.MerchantVo;
import com.qifenqian.bms.basemanager.merchant.bean.PicturePath;
import com.qifenqian.bms.basemanager.merchant.mapper.MerchantMapper;
import com.qifenqian.bms.basemanager.merchant.service.MerchantEnterService;
import com.qifenqian.bms.basemanager.merchant.service.MerchantService;
import com.qifenqian.bms.basemanager.merchant.service.MerchantWorkFlowAuditService;
import com.qifenqian.bms.basemanager.rule.bean.Rule;
import com.qifenqian.bms.basemanager.rule.mapper.RuleMapper;
import com.qifenqian.bms.basemanager.sysuser.bean.SysUser;
import com.qifenqian.bms.basemanager.sysuser.mapper.SysUserMapper;
import com.qifenqian.bms.basemanager.utils.GenSN;
import com.qifenqian.bms.expresspay.CommonService;
import com.qifenqian.bms.merchant.serviceparenter.service.ServiceParenterService;
import com.qifenqian.bms.platform.utils.SequenceUtils;
import com.qifenqian.bms.platform.web.admin.user.bean.User;
import com.qifenqian.bms.platform.web.admin.user.service.UserService;
import com.qifenqian.bms.platform.web.admin.utils.WebUtils;
import com.sevenpay.invoke.common.message.response.ResponseMessage;
import com.sevenpay.invoke.common.type.RequestColumnValues;
import com.sevenpay.invoke.transaction.bindbankcard.BindBankCardResponse;
import com.sevenpay.plugin.IPlugin;
import com.sevenpay.plugin.message.bean.MessageBean;
import com.sevenpay.plugin.message.bean.MessageColumnValues;
/**
 * 服务商列表
 * @author Lx
 *
 */
@Controller
@RequestMapping("/merchant/serviceParenter")
public class ServiceParenterController {
	
	private Logger logger = LoggerFactory.getLogger(ServiceParenterController.class);
	
	@Autowired
	private MerchantService merchantService;
	@Autowired
	private RuleMapper ruleMapper;
	@Autowired
	private CityService cityService;
	@Autowired
	private UserService userService;
	@Autowired
	private MerchantMapper merchantMapper;
	@Autowired
	private MerchantWorkFlowAuditService merchantWorkFlowAuditService;
	@Autowired
	private SysUserMapper sysUserMapper;
	@Autowired
	private TdCustInfoService tdCustInfoService;
	@Autowired
	private BankMapper bankMapper;
	@Autowired
	private ServiceParenterService serviceParenterService;
	@Autowired
	private MerchantEnterService merchantEnterService;
	@Autowired 
	private TdCustInfoMapper custInfoMapper; 
	@Autowired
	private CommonService commonService;
	@RequestMapping("/list")
	public ModelAndView serviceParenter(MerchantVo merchantVo) {
		
		ModelAndView mv = new ModelAndView("/merchant/serviceParenter/list");
		Bank bank = new Bank();
		String userId  = String.valueOf(WebUtils.getUserInfo().getUserId());
		//是否有权限查看所有订单
		boolean isAllList = tdCustInfoService.isAllList(userId);
		List<MerchantVo> list = null;
		/** 去掉多余的空格 */
		if (!StringUtils.isBlank(merchantVo.getMerchantCode())) {
			merchantVo.setMerchantCode(merchantVo.getMerchantCode().trim());
		}
		if (!StringUtils.isBlank(merchantVo.getCustName())) {
			merchantVo.setCustName(merchantVo.getCustName().trim());
		}
		if (!StringUtils.isBlank(merchantVo.getEmail())) {
			merchantVo.setEmail(merchantVo.getEmail().trim());
		}
		String startTime = null;//起止最大时间
		String endTime = null;//结束时间
		if (!StringUtils.isBlank(merchantVo.getStartTime())) {
			startTime = merchantVo.getStartTime().trim();
			merchantVo.setStartTime(startTime+" 00:00:00");
		}
		if (!StringUtils.isBlank(merchantVo.getEndTime())) {
			endTime = merchantVo.getEndTime().trim();
			merchantVo.setEndTime(endTime+" 23:59:59");
		}
		if(isAllList){
			list = serviceParenterService.selectNewServices(merchantVo);
		}else{
			merchantVo.setUserId(userId);
			merchantVo.setUserName(WebUtils.getUserInfo().getUserName());
			list = serviceParenterService.myServicesNewList(merchantVo);
		}
		merchantVo.setStartTime(startTime);
		merchantVo.setEndTime(endTime);
		mv.addObject("isFirst","No");
		mv.addObject("banklist", bankMapper.selectBanks(bank));
		mv.addObject("agencyList", JSONObject.toJSON(list));
		mv.addObject("queryBean", merchantVo);
		return mv;
		
		
	}
	
	/**
	 * 跳转到相应的页面
	 */
	@RequestMapping("/addPage")
	public ModelAndView addview(AgenReport agenReport,HttpServletRequest request){
		ModelAndView mv = new ModelAndView("/merchant/serviceParenter/addPage");
		
		Bank bank = new Bank();
		Rule rule = new Rule();
		User user = new User();
		rule.setStatus("VALID");
		//获取用户信息
	//	String userId  = String.valueOf(WebUtils.getUserInfo().getUserId());
	//	SysUser  sysUser = sysUserMapper.selectUserById(userId);
	//	mv.addObject("sysUser", sysUser);
	//	mv.addObject("taskId", request.getParameter("taskId"));
		mv.addObject("banklist", bankMapper.selectBanks(bank));
	//	mv.addObject("rulelist", ruleMapper.selectRules(rule));
	//	mv.addObject("userlist", userService.getUserList(user));
		mv.addObject("provincelist", cityService.selectAllProvince());
		mv.addObject("provincelist_", cityService.selAllProvince());
	//	mv.addObject("agentList", merchantMapper.selectAgent());
		mv.addObject("queryBean", agenReport);
		return mv;
		
	}
	
	@RequestMapping("/updatePage")
	public ModelAndView updateView(HttpServletRequest request ,String custId ){
		ModelAndView mv = new ModelAndView("/merchant/serviceParenter/updatePage");
		
		Bank bank = new Bank();
		//获取用户信息
	//	String userId  = String.valueOf(WebUtils.getUserInfo().getUserId());
		MerchantVo merchantVo = merchantMapper.newFindMerchantInfo(custId);//获取商户信息
		mv.addObject("banklist", bankMapper.selectBanks(bank));
		mv.addObject("provincelist", cityService.selectAllProvince());
		mv.addObject("provincelist_", cityService.selAllProvince());
		mv.addObject("merchantVo",merchantVo);//商户信息
		PicturePath picturePathOld = merchantEnterService.getPicPath(merchantVo);
		mv.addObject("picturePathOld",picturePathOld); //图片地址信息
		return mv;
		
	}	
	/**
	 * @param merchantVo  修改代理商信息
	 * @param request
	 * @return
	 */
	@RequestMapping("/update")
	@ResponseBody
	public String update(MerchantVo merchantVo,HttpServletRequest request ){
        JSONObject object = new JSONObject();
        try {
        	merchantMapper.updateMerchant(merchantVo);
        	//修改完成改成待审核状态
        	serviceParenterService.updateState(merchantVo.getCustId(), "update");//
		} catch (Exception e) {
			// TODO: handle exception
			 object.put("result", "fail");
	         object.put("message", "系统错误");
	         return object.toJSONString();
		}
        object.put("result", "SUCCESS");
		object.put("message", "修改成功");
        return object.toJSONString();
	}

	/**
	 * @param request zhanggc  打开浏览jsp页面
	 * @param custId
	 * @return
	 */
	@RequestMapping("/showPage")
	public ModelAndView showPageView(HttpServletRequest request ,String custId ){
		ModelAndView mv = new ModelAndView("/merchant/serviceParenter/showPage");
		Bank bank = new Bank();
		//获取用户信息
		MerchantVo merchantVo = merchantMapper.newFindMerchantInfo(custId);//获取商户信息
		mv.addObject("banklist", bankMapper.selectBanks(bank));
		mv.addObject("provincelist", cityService.selectAllProvince());
		mv.addObject("provincelist_", cityService.selAllProvince());
		mv.addObject("merchantVo",merchantVo);//商户信息
		PicturePath picturePathOld = merchantEnterService.getPicPath(merchantVo);
		mv.addObject("picturePathOld",picturePathOld); //图片地址信息
		return mv;
	}
	/**
	 * 商户新增
	 *
	 * @return
	 */
	@RequestMapping("/add")
	@ResponseBody
	public String regist(HttpServletRequest request, Merchant merchant) {

		logger.info("商户新增");

		//是否有权限新增
		String userId  = String.valueOf(WebUtils.getUserInfo().getUserId());
		boolean isAddMerchant = tdCustInfoService.isAddMerchant(userId);
        JSONObject object = new JSONObject();
		if (!isAddMerchant){
            logger.error("没有新增权限", userId);
            object.put("result", "fail");
            object.put("message", userId+"没有新增权限");
            return object.toJSONString();
		}

		try {

			// 设置商户custId
			String merchantCode = null;
			if (merchant.getBusinessLicense() == null || "".equals(merchant.getBusinessLicense())){
				//表示个人
				merchantCode = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + GenSN.getRandomNum(3);
			}else{
				merchant.setMerchantCode("P" + GenSN.getRandomNum(18));
//				merchant  Code = BusinessUtils.getMerchantId(merchant.getBusinessLicense());
			}
			if("".equals(merchant.getMerchantCode()) || null == merchant.getMerchantCode()) {
				merchant.setMerchantCode(GenSN.getRandomNum(19));
			}

			String custId = GenSN.getSN();

			merchant.setCustId(custId);
			// 任务ID
			String taskId = request.getParameter("taskId");
			this.saveMerchant(userId,custId, merchant, null);
			// 流程到下一步
			String auditName = request.getParameter("auditName");
			merchantService.startProcess(custId, taskId, auditName);
			object.put("custId", custId);
			object.put("result", "SUCCESS");
			object.put("message", "新增成功");
		} catch (Exception e) {
			logger.error("新增失败", e);
			object.put("result", "fail");
			object.put("message", e.getMessage());
		}

		return object.toJSONString();
	}
	
	
	/**
	 * @param request zhanggc 打开审核页面
	 * @param custId
	 * @return
	 */
	@RequestMapping("/auditPage")
	public ModelAndView auditPageView(HttpServletRequest request ,String custId ){
		ModelAndView mv = new ModelAndView("/merchant/serviceParenter/auditPage");
		Bank bank = new Bank();
		//获取用户信息
		MerchantVo merchantVo = merchantMapper.newFindMerchantInfo(custId);//获取商户信息
		
		if ("".equals(merchantVo.getState()) || merchantVo.getState()==null ) {
			return  new ModelAndView("");
		}
		mv.addObject("banklist", bankMapper.selectBanks(bank));
		mv.addObject("provincelist", cityService.selectAllProvince());
		mv.addObject("provincelist_", cityService.selAllProvince());
		mv.addObject("merchantVo",merchantVo);//商户信息
		PicturePath picturePathOld = merchantEnterService.getPicPath(merchantVo);
		mv.addObject("picturePathOld",picturePathOld); //图片地址信息
		return mv;
	}
	
	/**
	 * @return zhanggc 审核服务商
	 */
	@RequestMapping("/audit")
	@ResponseBody
	public String updateStatis(String custId , String fals) {
		 JSONObject ob = new JSONObject();
		 if (!StringUtils.isBlank(custId) && !StringUtils.isBlank(fals)) {
			 try { 
				 	//服务商审核状态
				 	String updateState = serviceParenterService.updateState(custId, fals);
				 
				 	if ("SUCCESS".equals(updateState))
				 	{	
				 		try {
				 			//发消息通知
					 		if ("yes".equals(fals)) {
					 			sendEews(custId ,fals);
							}
					 		if ("no".equals(fals)) {
					 			sendEewsNo(custId,fals);
							}
					 		ob.put("result", "SUCCESS");
						    ob.put("message", "操作成功");
						    return ob.toJSONString();
				 			
						} catch (Exception e) {
							ob.put("result", "messageErr");
						    ob.put("message", "审核成功发送信息异常");
						    return ob.toJSONString();
						}
					}
			
				} catch (Exception e) {
					//强制改变状态为 待审核状态
   				    serviceParenterService.updateState(custId, "update");
   				    ob.put("result", "ERR");
				    ob.put("message", "审核信息异常");
			        return ob.toJSONString();
				}
		}
		 ob.put("result", "FAILE");
	     ob.put("message", "参数为空");
		return ob.toJSONString();
	}

	
	/**
	 * 审核通过后发生消息 zhanggc
	 */
	public void sendEews(String custId , String fals) {
		  TdLoginUserInfo loginInfo = tdCustInfoService.selectTdLoginInfo(custId);
		  
		  if (!"".equals(loginInfo.getEmail()) && loginInfo.getEmail() != null)
		  {			
			  		//发邮件
			  		sendEmail(custId,loginInfo);
			  		return ;
		  }
		  if (!"".equals(loginInfo.getMobile()) && loginInfo.getMobile() != null)
		  {
			  		//审核不通过发短信
			  		smsMessage(loginInfo, fals);
			  		return ;
		  }
	}
	
	/**
	 * @param custId    审核不通过后发生消息 zhanggc
	 * @param fals  审核表示   
	 */
	public void sendEewsNo(String custId, String fals ) {
		  TdLoginUserInfo loginInfo = tdCustInfoService.selectTdLoginInfo(custId);
		  
		  if (!"".equals(loginInfo.getEmail()) && loginInfo.getEmail() != null)
		  {			
			  		//发邮件
			  		unEPass(custId, loginInfo);
			  		return ;
		  }
		  if (!"".equals(loginInfo.getMobile()) && loginInfo.getMobile() != null)
		  {
			  		//审核不通过发短信
			  		smsMessage(loginInfo, fals);
			  		return ;
			  
		  }
	}
	
	
	
	/**
	 * @param loginInfo
	 * @param fals  发送短信
	 */
	public void smsMessage(TdLoginUserInfo loginInfo,String fals) {
		//发送短信
		final IPlugin plugin = commonService.getIPlugin();
		final MessageBean messageBean = new MessageBean();
		messageBean.setMsgType(MessageColumnValues.MsgType.SMS);
		if ("yes".equals(fals)) {
			messageBean.setContent("【七分钱支付】用户审核已通过,初始密码为< 123456 >,如有任何问题，请拨打400-633-0707。");
		}
		if ("no".equals(fals)) {
			messageBean.setContent("【七分钱支付】用户审核未通过,如有任何问题，请拨打400-633-0707。");
		}
		messageBean.setSubject("【七分钱支付】用户审核通过");// 标题
		String[] tos = new String[] { loginInfo.getMobile() };
		messageBean.setTos(tos);
		messageBean.setBusType(MessageColumnValues.busType.REGISTER_VERIFY);
		plugin.sendMessage(MessageColumnValues.MsgType.SMS, messageBean); // 电话SMS
	}
	
	/**
	 * @param custId  审核通过发生邮件
	 * @param loginInfo
	 * @return
	 */
	private JSONObject sendEmail(String custId , TdLoginUserInfo loginInfo) {
        /**
         * 启动流程完成任务
         */
        JSONObject ob = new JSONObject();
        logger.info("启动流程完成任务");
        //查找登录信息表
        TdCustInfo tdCustInfo = custInfoMapper.selectLoginAndcustInfo(custId);
        /**
         * 发送邮件
         */
        MerchantVo merchant = merchantMapper.findMerchantInfo(tdCustInfo.getCustId());

        String content = "<html><body><div style=\"width:700px;margin:0 auto;\">"
                + "<div style=\"margin-bottom:10px;\">"
                + "</div><div style=\"border-top: 1px solid #ccc; margin-top: 20px;\"></div>"
                + "<div style=\"padding:20px 10px 60px;\"><div style=\"line-height:1.5;color:#4d4d4d;\">"
                + "<h3 style=\"font-weight:normal;font-size:16px;\">尊敬的" + merchant.getCustName() + "：您好！</h3>"
                + "<b style=\"font-size:18px;color:#ff9900\">您的账号为" + loginInfo.getEmail() + "</b>"
                + "已经审核通过，可以通过 密码为<123456 >"
                + "<a href=\"https://www.qifenqian.com\">www.qifenqian.com</a>" + " 登录系统。" + "</p>"
                + "<p style=\"font-size:14px;margin-top:15px;\">如有疑问，请联系我们</p>"
                + "<p style=\"font-size:14px;margin-top:15px;\">电话：0755-83026070</p>"	
                + "<p style=\"font-size:14px;margin-top:15px;\">七分钱因您而努力</p>"
                + "</div></div>	<div style=\"border-bottom: 1px dashed #d8d8d8\"></div>"
                + "<div style=\"width:700px;margin:0 auto;margin-top:10px;color:#8a8a8a;\">"
                + "<p>此为系统邮件，请勿回复；Copyright ©2015-2016七分钱（国银证保旗下支付平台）  版权所有</p></div></div></body></html>";
        String subject = "七分钱--亲爱的" + merchant.getCustName() + "，你的七分钱商户账号已经审核通过，欢迎登录！登录密码为:123456";
        logger.info("{}发送邮件(审核通过)!",tdCustInfo.getCustId());
        boolean flag = false;
        flag = merchantService.sendInfo(loginInfo.getEmail(), content, subject, MessageColumnValues.MsgType.EMAIL, MessageColumnValues.busType.REGISTER_VERIFY);
        if(flag){
            logger.info("{}审核通过发送邮件成功(审核通过)!",tdCustInfo.getCustId());
        }
        return ob;
    }
	
	

    private JSONObject unEPass(String custId , TdLoginUserInfo loginInfo) {
        logger.info("开始商户{}一级审核不通过流程",custId);
        JSONObject ob = new JSONObject();
        TdCustInfo custInfo =  custInfoMapper.selectLoginAndcustInfo(custId);
        ob.put("result", "SUCCESS");

        /**
         * 发送邮件
         */
        MerchantVo merchant = merchantMapper.findMerchantInfo(custInfo.getCustId());
        String content = "<html><body><div style=\"width:700px;margin:0 auto;\">"
                + "<div style=\"margin-bottom:10px;\">"
                + "</div><div style=\"border-top: 1px solid #ccc; margin-top: 20px;\"></div>"
                + "<div style=\"padding:20px 10px 60px;\"><div style=\"line-height:1.5;color:#4d4d4d;\">"
                + "<h3 style=\"font-weight:normal;font-size:16px;\">尊敬的" + merchant.getCustName() + "：您好！</h3>"
                + "<b style=\"font-size:18px;color:#ff9900\">您的账号为" + loginInfo.getEmail() + "</b>"
                + "审核不通过，可以通过 "
                + "<a href=\"https://www.qifenqian.com\">www.qifenqian.com</a>" + "登录系统，重新提交资料。" + "</p>"
                + "<p style=\"font-size:14px;margin-top:15px;\">如有疑问，请联系我们</p>"
                + "<p style=\"font-size:14px;margin-top:15px;\">电话：0755-83026070</p>"
                + "<p style=\"font-size:14px;margin-top:15px;\">七分钱因您而努力</p>"
                + "</div></div>	<div style=\"border-bottom: 1px dashed #d8d8md8\"></div>"
                + "<div style=\"width:700px;margin:0 auto;margin-top:10px;color:#8a8a8a;\">"
                + "<p>此为系统邮件，请勿回复；Copyright ©2015-2016七分钱（国银证保旗下支付平台）  版权所有</p></div></div></body></html>";
        String subject = "七分钱--亲爱的" + merchant.getCustName() + "，你的七分钱商户账号没有审核通过，请重新提交！";
        logger.info("{}发送邮件()!",custInfo.getCustId());
        boolean flag = merchantService.sendInfo(loginInfo.getEmail(), content, subject, MessageColumnValues.MsgType.EMAIL, MessageColumnValues.busType.REGISTER_VERIFY);
        if(flag){
            logger.info("{}发送邮件成功()!",custInfo.getCustId());
        }
        return ob;
    }

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	private JSONObject pass(String merchantCode, String message, String isPass) {
        /**
         * 启动流程完成任务
         */
        JSONObject ob = new JSONObject();
        logger.info("启动流程完成任务");
        TdCustInfo tdCustInfo = tdCustInfoService.selectByMerchantCode(merchantCode);
        merchantWorkFlowAuditService.startProcessAndCompleteTaskEnter(tdCustInfo.getCustId(),isPass,message);
        //赋值给
        tdCustInfo.setRepresentativeMobile(tdCustInfo.getContactMobile());
        //二级审核
        //TdCustInfo custInfo = tdCustInfoService.selectById(custId);
        ResponseMessage<BindBankCardResponse> response = merchantService.requestBindBank(tdCustInfo);
        if (RequestColumnValues.RtnResult.SUCCESS == response.getRtnResult()) {

        }else{
            ob.put("result", "FAILE");
            ob.put("message", "七分钱账户开户失败"+response.getRtnInfo());
            return ob;
        }
        //merchantWorkFlowAuditService.secondAudit(tdCustInfo.getCustId(),number, true, tdCustInfo.getAuthId(), message, "30", "0","3","notEmpty");
        merchantWorkFlowAuditService.secondAuditEnter(tdCustInfo.getCustId(), true, tdCustInfo.getAuthId(), message, "30", "0","3","notEmpty");

        ob.put("result", "SUCCESS");

        /**
         * 发送邮件
         */

        MerchantVo merchant = merchantMapper.findMerchantInfo(tdCustInfo.getCustId());

        String content = "<html><body><div style=\"width:700px;margin:0 auto;\">"
                + "<div style=\"margin-bottom:10px;\">"
                + "</div><div style=\"border-top: 1px solid #ccc; margin-top: 20px;\"></div>"
                + "<div style=\"padding:20px 10px 60px;\"><div style=\"line-height:1.5;color:#4d4d4d;\">"
                + "<h3 style=\"font-weight:normal;font-size:16px;\">尊敬的" + merchant.getCustName() + "：您好！</h3>"
                + "<b style=\"font-size:18px;color:#ff9900\">您的账号为" + merchant.getEmail() + "</b>"
                + "已经审核通过，可以通过 "
                + "<a href=\"https://www.qifenqian.com\">www.qifenqian.com</a>" + " 登录系统。" + "</p>"
                + "<p style=\"font-size:14px;margin-top:15px;\">如有疑问，请联系我们</p>"
                + "<p style=\"font-size:14px;margin-top:15px;\">电话：0755-83026070</p>"
                + "<p style=\"font-size:14px;margin-top:15px;\">七分钱因您而努力</p>"
                + "</div></div>	<div style=\"border-bottom: 1px dashed #d8d8d8\"></div>"
                + "<div style=\"width:700px;margin:0 auto;margin-top:10px;color:#8a8a8a;\">"
                + "<p>此为系统邮件，请勿回复；Copyright ©2015-2016七分钱（国银证保旗下支付平台）  版权所有</p></div></div></body></html>";
        String subject = "七分钱--亲爱的" + merchant.getCustName() + "，你的七分钱商户账号已经审核通过，欢迎登录！";
        logger.info("{}发送邮件(审核通过)!",tdCustInfo.getCustId());
        boolean flag = false;
        flag = merchantService.sendInfo(merchant.getEmail(), content, subject, MessageColumnValues.MsgType.EMAIL, MessageColumnValues.busType.REGISTER_VERIFY);
        if(flag){
            logger.info("{}审核通过发送邮件成功(审核通过)!",tdCustInfo.getCustId());
        }
        return ob;
    }

    private JSONObject unPass(String merchantCode, String message, String isPass) {
        logger.info("开始商户{}一级审核不通过流程",merchantCode);
        JSONObject ob = new JSONObject();
        TdCustInfo custInfo = tdCustInfoService.selectByMerchantCode(merchantCode);
        merchantWorkFlowAuditService.firstNotPass(custInfo.getCustId(), message, false, "35", custInfo.getAuthId(), "2");//35  实名认证不通过        2：审核不通过
        ob.put("result", "SUCCESS");


        //二级审核不通过
       /* merchantWorkFlowAuditService.secondAuditEnter(custInfo.getCustId(),false, custInfo.getAuthId(), message, "35", "2",null,"");
        ob.put("result", "SUCCESS");*/

        /**
         * 发送邮件
         */
        MerchantVo merchant = merchantMapper.findMerchantInfo(custInfo.getCustId());
        String content = "<html><body><div style=\"width:700px;margin:0 auto;\">"
                + "<div style=\"margin-bottom:10px;\">"
                + "</div><div style=\"border-top: 1px solid #ccc; margin-top: 20px;\"></div>"
                + "<div style=\"padding:20px 10px 60px;\"><div style=\"line-height:1.5;color:#4d4d4d;\">"
                + "<h3 style=\"font-weight:normal;font-size:16px;\">尊敬的" + merchant.getCustName() + "：您好！</h3>"
                + "<b style=\"font-size:18px;color:#ff9900\">您的账号为" + merchant.getEmail() + "</b>"
                + "审核不通过，可以通过 "
                + "<a href=\"https://www.qifenqian.com\">www.qifenqian.com</a>" + "登录系统，重新提交资料。" + "</p>"
                + "<p style=\"font-size:14px;margin-top:15px;\">如有疑问，请联系我们</p>"
                + "<p style=\"font-size:14px;margin-top:15px;\">电话：0755-83026070</p>"
                + "<p style=\"font-size:14px;margin-top:15px;\">七分钱因您而努力</p>"
                + "</div></div>	<div style=\"border-bottom: 1px dashed #d8d8md8\"></div>"
                + "<div style=\"width:700px;margin:0 auto;margin-top:10px;color:#8a8a8a;\">"
                + "<p>此为系统邮件，请勿回复；Copyright ©2015-2016七分钱（国银证保旗下支付平台）  版权所有</p></div></div></body></html>";
        String subject = "七分钱--亲爱的" + merchant.getCustName() + "，你的七分钱商户账号没有审核通过，请重新提交！";
        logger.info("{}发送邮件(二级审核不通过)!",custInfo.getCustId());
        boolean flag = merchantService.sendInfo(merchant.getEmail(), content, subject, MessageColumnValues.MsgType.EMAIL, MessageColumnValues.busType.REGISTER_VERIFY);
        if(flag){
            logger.info("{}发送邮件成功(二级审核不通过)!",custInfo.getCustId());
        }
        return ob;
    }

	/**
	 * 事务处理
	 *
	 * @param custId
	 * @param merchant
	 */
	public void saveMerchant(String userId,String custId, Merchant merchant, String paths) {
		merchantService.addMerchant(userId,custId, merchant, paths);
	}
}
