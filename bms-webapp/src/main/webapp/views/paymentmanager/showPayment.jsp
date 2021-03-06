<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/include/template.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page import="com.qifenqian.bms.paymentmanager.topay.toPayCollectDailyPath" %>
<%@page import="com.qifenqian.bms.basemanager.agency.controller.AgencyPath" %>
<%@page import="com.qifenqian.bms.paymentmanager.PaymentManagerPath"%>

<% String url = request.getScheme()+"://"+ request.getServerName()+":"+request.getServerPort(); %>
<script src='<c:url value="/static/js/jquery-ui.min.js"/>'></script>
<link rel="stylesheet" href='<c:url value="/static/css/iconfont.css"/>' />
<link rel="stylesheet" href="<c:url value='/static/css/combo.select.css' />" />
<script src='<c:url value="/static/js/jquery.divbox.js"/>'></script>
<script src='<c:url value="/static/js/jquery.divbox.js"/>'></script>
<script src='<c:url value="/static/js/ajaxfileupload.js"/>'></script>
<script src='<c:url value="/static/js/jquery-ui.min.js?v=${_jsVersion}"/>'></script>
<script src='<c:url value="/static/js/jquery.divbox.js?v=${_jsVersion}"/>'></script>
<script src='<c:url value="/static/js/ajaxfileupload.js?v=${_jsVersion}"/>'></script>
<script src='<c:url value="/static/js/register.js?v=${_jsVersion}"/>'></script>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>代付查询</title>
<meta name="keywords" content="七分钱后台管理系统" />
<meta name="description" content="七分钱后台管理" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<style type="text/css">
	.headlerPreview{ 
		background-color:#ffbf66; 
		text-align:center; 
		height:30px; 
		font-weight:bold;
	}
	.list-table2 tbody td{padding: 10px 8px;}
	
</style>
<script type="text/javascript">
function loadMerchant(){
	$('.search-table #status').val($("#state_02").val());
 }

</script>
</head>

<body style="overflow-x:hidden;" onload="loadMerchant()">
	<%@ include file="/include/top.jsp"%>
	<div class="main-container" id="main-container">
		<script type="text/javascript">
			try{ace.settings.check('main-container' , 'fixed')}catch(e){}
		</script>
		<div class="main-container-inner">
			<!-- 菜单 -->
			<%@ include file="/include/left.jsp"%>
			<div class="main-content">
				<!-- 路径 -->
				 <%@ include file="/include/path.jsp"%>
				<!-- 主内容 -->
				<div class="page-content">
					<div class="row">
						<div class="col-xs-12">
					    <input id="state_02" value="${queryBean.status}"  type="hidden">
						
						
						<!-- 查询条件 -->
						<form  id="merchantForm" action='<c:url value="<%=toPayCollectDailyPath.BASE + toPayCollectDailyPath.SELECTPAYMENTS%>"/>' method="post">
							<table class="search-table">
								<tr>
									<td class="td-left">状态：</td>
									<td class="td-right">								   
										 <select name="status" id="status" >
										  <option  value="" >请选择 </option>
										  <option  value="00">付款成功 </option>
										  <option  value="01">未提交</option>
										  <option  value="02">已提交 </option>
										  <option  value="04">付款失败 </option>
										 </select>
									    <label class="label-tips" id="businessRegAddrLab"></label>
									</td>
									<td class="td-right" > 
										<span class="input-icon">
											<input type="hidden"  name="batNo" id="batNo"  value="${queryBean.batNo }">
											<i class="icon-leaf blue"></i>
										</span>
									</td>
									
									
									
									<td class="td-left">收款人名称：</td>
									<td class="td-right" > 
										<span class="input-icon">
											<input type="text"  name="recAccountName" id="recAccountName"  value="${queryBean.recAccountName}">
											<i class="icon-leaf blue"></i>
										</span>
									</td>
								
								</tr>
								<tr>
								
								<td class="td-left">注册时间：</td>
									 <td class="td-right">
									 <input type="text" name="startCreateTime"   id="startCreateTime" readonly="readonly" value="${queryBean.createTime }"  onfocus="WdatePicker({skin:'whyGreen',maxDate:'%y-%M-%d'})" style="background:#fff url(/static/My97DatePicker/skin/datePicker.gif) no-repeat right!important;"> 
									 <input type="text" name="endCreateTime"   id="endCreateTime" readonly="readonly" value="${queryBean.endCreateTime }"  onfocus="WdatePicker({skin:'whyGreen',maxDate:'%y-%M-%d'})" style="background:#fff url(/static/My97DatePicker/skin/datePicker.gif) no-repeat right!important;"> 
								</td>
								 
								
								
								</tr>
								<tr>
									<td colspan="6" align="center">
										<span class="input-group-btn">
											<gyzbadmin:function url="<%=toPayCollectDailyPath.BASE + toPayCollectDailyPath.SELECTPAYMENTS %>">
												<button type="submit" class="btn btn-purple btn-sm btn-margin  buttonSearch" >
													查询<i class="icon-search icon-on-right bigger-110"></i>
												</button>
											</gyzbadmin:function>
											<button id="clearMerchantSearch" class="btn btn-purple btn-sm btn-margin clearMerchantSearch" >
												清空<i class=" icon-move icon-on-right bigger-110"></i>
											</button>
											<span class="input-group-btn" style="display:inline;">
												<a class="btn btn-purple btn-sm exportBut">导出报表</a> 
											</span> 
										</span>
									</td>
								</tr>
							</table>
						</form>
						
						<div class="list-table-header">代付明细列表</div>
						<div class="table-responsive">
							<table id="sample-table-2" class="list-table" style="overflow:scroll;">
								<thead>
									<tr >
										        <th width="10%">批次号</th>
		                                        <th width="5%">序号</th>
		                                		<th width="10%">收款人名称</th>
		                                		<th width="15%">收款人账号</th>
		                                		<th width="15%">收款人银行号</th>
		                                		<th width="10%">收款金额</th>
			                                	<th width="10%">状态</th>
			                                	<th width="10%">创建人</th>
			                                	<th width="9%">创建时间</th>
			                                	<th width="15%">处理代付查询</th>
									</tr>
								</thead>
								<tbody>
							
									<c:forEach items="${paymentBatInfos}" var="payment" varStatus="i">
											<tr class="payment" id="payment">
											<td>${payment.batNo}</td>
											<td>${payment.rowNo}</td>
											<td>${payment.recAccountName}</td>
											<td>${payment.recAccountNo}</td>
											<td>${payment.recBankCnaps}</td>
											<td>${payment.transAmt}</td>
											
									  <td>
									    <c:if test="${payment.status =='00'}">
											银行处理完成
										</c:if>
									
										<c:if test="${payment.status =='01'}">
											未提交
										</c:if>
										<c:if test="${payment.status =='02'}">
											<font color="green">已提交</font>	
										 </c:if>	  
							  			<c:if test="${payment.status =='03'}">
											<font color="red"> 银行处理中 </font>		
										 </c:if>		
										 </td>
										  <td>${payment.createId}</td>
										  <td>${payment.createTime}</td>
											<td>	
												<input type="hidden" name="PaymentbatNo" id="PaymentbatNo" value="${payment.batNo}">
												<input type="hidden" name="rowNo" id="rowNo" value="${payment.rowNo}">
												  <c:if test="${payment.status !='00'}">
											      <button type="button" onclick="dealPaymet(this)" data-toggle='modal' id="changeClass"  class="btn btn-primary btn-xs qifenqian_view_tc" >处理代付查询</button> 
											      </c:if>
											      <c:if test="${payment.status =='00'}">
											      <button type="button"  onclick="dealPaymet(this)" data-toggle='modal'  disabled="disabled" class="btn  btn-xs">处理代付查询</button> 
											      </c:if>
											      
											</td>
										</tr>
									</c:forEach>
									<c:if test="${empty paymentBatInfos}">
										<tr>
											<td colspan="9" align="center">
												<font style="color: red; font-weight: bold;font-size: 15px;">暂无数据</font>
											</td>
										</tr>
									</c:if>
									</tbody>
								</table>
								
								<!-- 分页 -->
								<c:if test="${not empty paymentBatInfos}">
									<%@ include file="/include/page.jsp"%>
								</c:if>
							</div>
						</div>
					</div>
				</div><!-- /.page-content -->
				<!-- 底部-->
				<%@ include file="/include/bottom.jsp"%>
			</div><!-- /.main-content -->
			<!-- 设置 -->
			<%@ include file="/include/setting.jsp"%>
	
  <div class="modal fade" style="z-index:1043;" id="firstAuditMessageModel" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		   <div class="modal-dialog" style="width:30%;z-index:99;">
		      <div class="modal-content" >
		         <div class="modal-header" style="background-color:0099CC">
		            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		            <h4 class="modal-title" id="myModalLabel"></h4>
		         </div>
		         <div class="modal-body">
		         
<table id="selectCheckbox">
	


	<td>
	   <textarea rows="5" cols="40" id="auditMessage" ></textarea>
	</td>
	</tr>	 
 </table>				
		    </div> 
		         <div class="modal-footer">
		            <button type="button" class="btn btn-default messageDefault" data-dismiss="modal">取消</button>
		            <button type="button" class="btn btn-primary addadBtn" onclick="firstNotPass();">确定</button>
		         </div>
		      </div><!-- /.modal-content -->
		     </div>
		
		  </div>
	
	
	

	<div class="modal fade" style="z-index:1040;" id="showHistory" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog" style="width:100%;z-index:100;">
	<div class="modal-content"  style="width: 1400px;margin:0 auto" id="merchantDiv">
	<button type="button" class="close" data-dismiss="modal" id="updateMerchantClose" style="margin: 8px 10px 0 0;" aria-hidden="true">&times;</button>
	
	
	<div class="list-table-header">代付明细</div>
	<div class="modal-body">
	<table id="sample-table-5" class="list-table list-table2"  style="overflow:scroll;">
	  <thead>
		<tr>
		<th width="10%">批次号</th>
		<th width="5%">序号</th>
		<th width="10%">收款人名称</th>
		<th width="15%">收款人账号</th>
		<th width="15%">收款人银行号</th>
		<th width="10%">收款金额</th>
		<th width="10%">状态</th>
		<th width="10%">创建人</th>
		<th width="15%">处理代付查询</th>
		</tr>
		</thead>
       <tbody id="getHistory">
         
      </tbody>

	 </table>
	  <div id="showPayment">
	  <%@ include file="/include/page.jsp"%>
	  </div>
	</div>
	</div>
	</div>
	</div>
	</div>
	       
</body>

<script type="text/javascript">
 $(function(){
	/** 缓存 **/
	var custIds = ${paymentBatInfos};
	var custId = $("tr.payment");
	$.each(custIds,function(i,value){
		$.data(custId[i],"payment",value);
	});
});

 /** 点击预览和更新 **/
  /**处理代付请求**/
	 function dealPaymet(obj){
		 var batNo =$(obj).parent().find('#PaymentbatNo').val();
		 var rowNo=$(obj).parent().find('#rowNo').val();
		  
		 $.post(window.Constants.ContextPath + '<%=PaymentManagerPath.BASE+PaymentManagerPath.STATUS %>',
		 		   {
		  	 		"batNo" 	: batNo,
		  	 		"rowNo" 	: rowNo
		  	 		},function(data){
		  	 			var json = eval('(' + data + ')'); 
		  	 			if(json.result=="SUCCESS"){
		  	 				$("#changeClass").attr("class","btn  btn-xs");
		  	 				$("#changeClass").attr("disabled","disabled");
		  	 			}else{
		  	 				$("#changeClass").attr("class","btn btn-primary btn-xs qifenqian_view_tc");
		  	 				$("#changeClass").removeAttr("disabled"); 
		  	 			}
		  	 			
		  	 		  });
	             }

 /** 清空按钮 **/
 $('#clearMerchantSearch').click(function(){
 	$('.search-table #recAccountName').val("");
 	$('.search-table #startCreateTime').val('');
 	$('.search-table #endCreateTime').val('');
 	$('.search-table #status').val('');
 	$("#merchantForm").submit();
 }); 

//导出数据
	$('.exportBut').click(function(){
		var batNo = $('#PaymentbatNo').val();
		var paerAcctNo = $('.search-table #paerAcctNo').val();
		var startCreateTime = $('.search-table #startCreateTime').val();
		var endCreateTime = $('.search-table #endCreateTime').val();
		var src ="<%= request.getContextPath()+ toPayCollectDailyPath.BASE+toPayCollectDailyPath.EXPORTPAYMENTINFOS%>?batNo="+
		batNo+
	    "&paerAcctNo="+
		 paerAcctNo+
		"&startCreateTime="+
		  startCreateTime+
		"&endCreateTime="+
		 endCreateTime;
		$(".exportBut").attr("href",src);
		
	});

</script>
</html>