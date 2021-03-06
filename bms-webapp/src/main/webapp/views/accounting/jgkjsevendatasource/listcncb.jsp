<%@page import="com.qifenqian.bms.platform.common.utils.ReflectUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/include/template.jsp"%>
<%@page import="com.qifenqian.bms.accounting.jgkjsevendatasource.BalJgkjSevenDataSourcePath" %> 
<%@page import="com.qifenqian.bms.accounting.balunionpayuniondatasource.BalUnionpayUnionDataSourcePath" %> 
<%@page import="com.qifenqian.bms.accounting.jgkjdatasource.BalJgkjDataSourcePath" %>
<%@page import="com.qifenqian.bms.accounting.balunionpayuniondatasource.BalUnionpaySevenDataSourcePath" %>  
<%@page import="com.qifenqian.bms.accounting.cncbdatasource.BalCncbDataSourcePath" %> 

<html>
<head>
	<meta charset="utf-8" />
	<title>中信对账源数据表</title>
	<meta name="keywords" content="七分钱后台管理系统" />
	<meta name="description" content="七分钱后台管理" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<style type="text/css">
		table tr td{word-wrap:break-word;word-break:break-all;}
	</style>
</head>
<script src='<c:url value="/static/My97DatePicker/WdatePicker.js"/>'></script>
<script src='<c:url value="/static/My97DatePicker/AutoDatePicker.js"/>'></script>
<script type="text/javascript">
$(document).ready(function(){
	$('.clearJgkjTradeClr').click(function(){
		$(':input','#searchForm')  
		 .not(':button, :submit, :reset, :hidden')  
		 .val('')  
		 .removeAttr('checked')  
		 .removeAttr('selected'); 
	});
	 
	$("#exportbalancewaterlist").click(function(){	 
		var channelOrderId= $(".search-table #channelOrderId").val();
		
		var transStatus= $(".search-table #transStatus").val();
		
		var transDatetime= $(".search-table #transDatetime").val();   
		var src="<%=request.getContextPath()+BalCncbDataSourcePath.BASE+BalCncbDataSourcePath.CNCBEXPORT%>?channelOrderId="+channelOrderId+
				"&transStatus="+transStatus+
				"&transDatetime="+transDatetime;
		$("#exportbalancewaterlist").attr("href",src); 
	})
	
	$("#ylSource").click(function(){
		window.location.href="<%=request.getContextPath()+BalUnionpayUnionDataSourcePath.BASE + BalUnionpayUnionDataSourcePath.LISTUNION%>";
	 });
	
	$("#qfqSource").click(function(){
		window.location.href="<%=request.getContextPath()+BalJgkjSevenDataSourcePath.BASE+BalJgkjSevenDataSourcePath.LIST%>";
	 });
	
	$("#zytSource").click(function(){
		window.location.href="<%=request.getContextPath()+BalJgkjDataSourcePath.BASE+ BalJgkjDataSourcePath.JGKJLIST%>";
	 });
	
	$("#ylqSource").click(function(){
		window.location.href="<%=request.getContextPath()+BalUnionpaySevenDataSourcePath.BASE+ BalUnionpaySevenDataSourcePath.LISTUNIONSEVEN%>";
	 });

	$("#cncbSource").click(function(){
		window.location.href="<%=request.getContextPath()+BalCncbDataSourcePath.BASE+ BalCncbDataSourcePath.CNCBLIST%>";
	 });
	$('#myTab li:eq(4) a').tab('show');
});
</script>
<body>
	<!-- 充值/支付未明处理 -->
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
						<ul id="myTab" class="nav nav-tabs" style="margin-bottom:5px;">
						   <li><a href="#qfq"  data-toggle="tab"  id="qfqSource">七分钱交广科技银联对账源数据表</a></li>
						    <li><a href="yl"  data-toggle="tab"  id="ylSource">银联对账源数据表</a></li>
						   <li><a href="#zyt" data-toggle="tab"  id="zytSource">交广科技对账源数据表</a></li>
						   <li><a href="#ylq" data-toggle="tab"  id="ylqSource">七分钱银联对账源数据表</a></li>
						   <li><a herf="#cncb" data-toggle="tab" id="cncbSource">中信对账源数据表</a></li>
						</ul>
						<!-- 查询条件 -->
							<form id="searchForm" action='<c:url value="<%=BalCncbDataSourcePath.BASE+ BalCncbDataSourcePath.CNCBLIST%>"/>' method="post">
							<table class="search-table">
								<tr>
									<td class="td-left">威富通订单号</td>
									<td class="td-right">
										<span class="input-icon">
											<input type="text"  name="channelOrderId" id="channelOrderId" value="${queryBean.channelOrderId }">
											<i class="icon-leaf blue"></i>
										</span>
									</td>
									<td class="td-left">会计日期</td>
									<td class="td-right">
											<input type="text" name="workDate" id="workDate"  value="${queryBean.workDate}"   readonly="readonly"  onfocus="AutoDatePicker({skin:'whyGreen',maxDate:'%y-%M-%d'})" style="background:#fff url(/static/My97DatePicker/skin/datePicker.gif) no-repeat right!important;">
									</td>
								</tr>
					
								<tr>
									<td colspan="4" align="center">
										<span class="input-group-btn">
											<gyzbadmin:function url="<%=BalCncbDataSourcePath.BASE + BalCncbDataSourcePath.CNCBLIST%>">
											<button type="submit" class="btn btn-purple btn-sm">
												查询
												<i class="icon-search icon-on-right bigger-110"></i>
											</button> 
											</gyzbadmin:function>
											<button class="btn btn-purple btn-sm btn-margin clearJgkjTradeClr"  >
												清空
												<i class=" icon-move icon-on-right bigger-110"></i>
											</button>
											
											<gyzbadmin:function url="<%=BalCncbDataSourcePath.BASE + BalCncbDataSourcePath.CNCBEXPORT%>">
												<span class="input-group-btn" style="display:inline;">
													<a class="btn btn-purple btn-sm"  id="exportbalancewaterlist"  >
														导出报表
														<i class="icon-download bigger-110"></i> 
													</a> 
												</span>	
											</gyzbadmin:function>											
										</span>
									</td>
								</tr>
							</table>
							</form>
							<div class="list-table-header">
								中信对账源数据
							</div>
							<div class="table-responsive">
								<table id="sample-table-2" class="list-table">
									<thead>
										<tr>
											<th>威富通订单号</th>
											<th>交易类型</th>
											<th>交易状态</th>
											<th>货币种类</th>
											<th>金额</th>										
											<th>用户标识</th>
											<th>商户号</th>
											<th>会计日期 </th>
											<th>交易时间</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach items="${cncbDataSourceList}" var="result">
											<tr class="result">
											    <td width="20%">${result.channelOrderId }</td>	
											    <td width="10%">${result.transType }</td>
												<td width="10%">${result.transStatus }</td>
												<td width="10%">${result.currencyCode }</td>
												<td width="10%">${result.totalAmt }</td>
												<td width="10%">${result.userMark }</td>
												<td width="10%">${result.merchantId }</td>
												<td width="10%">${result.workDate }</td>												
												<td width="10%">${result.transDatetime }</td>
											</tr>
										</c:forEach>
										<c:if test="${empty cncbDataSourceList}">
											<tr><td colspan="12" align="center"><font style="color: red; font-weight: bold;font-size: 15px;">暂无数据</font></td></tr>
										</c:if>
									</tbody>
								</table>
							</div>
							<!-- 分页 -->
							<c:if test="${not empty cncbDataSourceList}">
								<%@ include file="/include/page.jsp"%>
							</c:if>
						</div>
					</div>
				</div><!-- /.page-content -->
				<!-- 底部-->
				<%@ include file="/include/bottom.jsp"%>
			</div><!-- /.main-content -->
			<!-- 设置 -->
			<%@ include file="/include/setting.jsp"%>
		</div><!-- /.main-container-inner -->
		<!-- 向上置顶 -->
		<%@ include file="/include/up.jsp"%>
	</div><!-- /.main-container -->
</body>
</html>