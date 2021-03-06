<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/include/template.jsp"%>
<%@page import="com.qifenqian.bms.accounting.financequery.FinanceQueryPath"%>
<%@page import="com.qifenqian.bms.accounting.withdraw.WithdrawPath"%>	
<%@page import="com.qifenqian.bms.basemanager.merchantwithdraw.MerchantWithdrawPath"%>
<%@page import="com.qifenqian.bms.accounting.withdrawrevoke.WithdrawRevokePath"%>
<%
	String url = request.getScheme()+"://"+ request.getServerName()+":"+request.getServerPort();
%>

<%-- <script src='<c:url value="/static/js/checkRule_source.js"/>'></script> --%>
<script src='<c:url value="/static/laydate/laydate.js"/>'></script>
<%-- <script src='<c:url value="/static/My97DatePicker/WdatePicker.js"/>'></script> --%>
<link rel="stylesheet" href='<c:url value="/static/css/iconfont.css"/>' />
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>商户提现结算</title>
<meta name="keywords" content="七分钱后台管理系统" />
<meta name="description" content="七分钱后台管理" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<style type="text/css">
table tr td {
	word-wrap: break-word;
	word-break: break-all;
}

li {
	list-style-type: none;
}

.displayUl {
	display: none;
}
</style>
</head>
<body onload="load()">
	<!-- 科目配置信息 -->
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
							<ul id="myTab" class="nav nav-tabs">
							   <li><a href="#balanceWhole"  data-toggle="tab"  id="balanceWhole">汇总余额</a></li>
							   <li><a href="#changeBalance" data-toggle="tab" id="changeBalance">余额变动</a></li>						   
							   <li><a href="#commerciaBalance" data-toggle="tab" id="commerciaBalance"> 商户余额</a></li>
							   <li><a href="#userBalance" data-toggle="tab" id="userBalance">用户余额</a></li>
							   <li><a href="#cashSettlement" data-toggle="tab" id="cashSettlement">客戶提现结算</a></li>
							   <li><a href="#merchantSettlement" data-toggle="tab" id="merchantSettlement">商户提现结算</a></li>
							   <li><a href="#withdrawrevoke" data-toggle="tab" id="withdrawrevoke">客户提现撤销列表</a></li>
							</ul>

							<div class="table-responsive">
						<div id="myTabContent" class="tab-content">
					<div class="row">
						<div class="col-xs-12">
						<input id="auditState2" type="hidden" value="${withdrawBean.auditState }">
						<input id="withdrawState2" type="hidden" value="${withdrawBean.withdrawState }">
						<input id="verificationState2" type="hidden" value="${withdrawBean.verificationState }">
							<form id="tradeForm"  action='<c:url value="<%=MerchantWithdrawPath.BASE + MerchantWithdrawPath.LIST %>"/>' method="post">
								<table class="table search-table" >
									<tr>
										<td class="td-left" >七分钱提现流水号</td>
										<td class="td-right">
											<span class="input-icon">
												<input type="text"	name="withdrawSn" id="withdrawSn" value="${withdrawBean.withdrawSn }">
												<i class="icon-leaf blue"></i>
											</span>
										</td>
										<td class="td-left" >商户编号</td>
										<td class="td-right">
											<span class="input-icon">
												<input type="text" name="merchantCode"  id="merchantCode" value="${withdrawBean.merchantCode }">
												<i class="icon-leaf blue"></i>
											</span>
										</td>
										
										<td class="td-left">提现申请日期</td>
										<td class="td-right">
											 <input type="text" name="beginTime"  id="beginTime" value="${withdrawBean.beginTime }" readonly="readonly" onfocus="WdatePicker({skin:'whyGreen',maxDate:'%y-%M-%d'})" style="background:#fff url(/static/My97DatePicker/skin/datePicker.gif) no-repeat right!important;">
											 	-
											 <input type="text" name="endTime" id="endTime" value="${withdrawBean.endTime }"  readonly="readonly" onfocus="WdatePicker({skin:'whyGreen',maxDate:'%y-%M-%d'})" style="background:#fff url(/static/My97DatePicker/skin/datePicker.gif) no-repeat right!important;">
										</td>
									</tr>
									<tr>
										<td class="td-left" >提现状态</td>
										<td class="td-right" >
											<select name="withdrawState" id="withdrawState">
											   <option value="">-请选择-</option>
												<option value="01">待提现</option>
												<option value="02">核心处理中</option>
												<option value="03">核心处理失败</option>
												<option value="04">核心处理成功</option>
												<option value="05">银行处理中</option>
												<option value="99">取消</option>
												<option value="00">提现成功</option>
											</select>
										</td>
										<td class="td-left" >审核状态</td>
										<td class="td-right" >
											<select name="auditState" id="auditState">
												<option value="">-请选择-</option>
												<option value="01">待审核</option>
												<option value="02">审核通过</option>
												<option value="04">审核不通过</option>
											</select>
										</td>
										<td class="td-left" >核销状态</td>
										<td class="td-right">
											<select  name="verificationState" id="verificationState">
												<option value="">-请选择-</option>
												<option value="01">未核销</option>
												<option value="02">已核销</option>
											</select>
										</td>
										</tr>
										<tr>
										<td colspan="6" align="center">
												<button type="submit" class="btn btn-purple btn-sm buttonSearch">
													查询
												 <i class="icon-search icon-on-right bigger-110"></i>
												</button>
												<button  class="btn btn-purple btn-sm btn-margin clearWithdraw" >
													清空
													<i class=" icon-move icon-on-right bigger-110"></i>
												</button>
												<gyzbadmin:function url="<%=MerchantWithdrawPath.BASE+MerchantWithdrawPath.MERCHANTWITHDRAWEXPORT%>">
												<a class="btn btn-purple btn-sm exportBut">
													导出报表
												</a> 
												</gyzbadmin:function>
										</td>
									</tr>
								</table>
							</form>
							<table id="sample-table-2" class="list-table">
								<thead>
									<tr>
										<th width="10%">七分钱提现流水号</th>
										<th width="10%">商户编号</th>
										<th width="5%">收款名</th>
										<th width="5%">提现银行卡号</th>
										<th width="10%">开户行</th>
										<th width="5%">提现金额</th>
										<th width="10%">提现申请日期</th>
										<th width="6%">审核状态</th>
										<th width="10%">审核时间</th>
										<th width="5%">提现状态</th>
										<th width="7%">核销状态</th>
										<th width="5%">备注</th>
										<th width="12%">操作</th>
									</tr>
								</thead>
								<tbody id="impeachData">
									<c:forEach items="${withdrawList}" var="withdraw">
										<tr class="withdraw">
											<td style="width:140px;">${withdraw.withdrawSn }</td>
											<td style="width:140px;">${withdraw.merchantCode }</td>
											<td>${withdraw.bankAcctName }</td>
											<td>${withdraw.bankCode }</td>
											<td>${withdraw.bankName }</td>
											<td>${withdraw.withdrawAmt}</td>
											<td>${withdraw.createTime }</td>
											<td>
												<c:if test="${withdraw.auditState=='01' }">待审核</c:if>
												<c:if test="${withdraw.auditState=='02' }">审核通过</c:if>
												<c:if test="${withdraw.auditState=='04' }">审核不通过</c:if>
											</td>
											<td>${withdraw.auditTime }</td>
											<td>
												<c:if test="${withdraw.withdrawState=='00' }">提现成功</c:if>
												<c:if test="${withdraw.withdrawState=='01' }">待提现</c:if>
												<c:if test="${withdraw.withdrawState=='02' }">核心处理中</c:if>
												<c:if test="${withdraw.withdrawState=='03' }">核心返回失败</c:if>
												<c:if test="${withdraw.withdrawState=='04' }">核心返回成功</c:if>
												<c:if test="${withdraw.withdrawState=='05' }">银行处理中</c:if>
												<c:if test="${withdraw.withdrawState=='99' }">审核不通过</c:if>
											</td>
											<td>
											<c:if test="${withdraw.verificationState=='01' }">未核销</c:if>
											<c:if test="${withdraw.verificationState=='02' }">已核销</c:if>
											</td>
											<td>${withdraw.coreReturnMsg}</td>
											<td>
												<c:if test="${withdraw.auditState!='01' }">
													<a href="#reviewWithdrawModal"  data-toggle='modal' class="tooltip-error auditWithdraw" data-rel="tooltip" title="查看详情">
														<button type="button"   id="btnEmail2"  class="btn btn-purple btn-xs"  >查看详情</button>	
													</a>	
												</c:if>
											    <gyzbadmin:function url="<%=MerchantWithdrawPath.BASE+MerchantWithdrawPath.MERCHANTWITHDRAWAUDITPASS%>">
													<c:if test="${withdraw.auditState=='01' }">
														<a href="#reviewWithdrawModal"  data-toggle='modal' class="tooltip-error auditWithdraw" data-rel="tooltip" title="审核">
															<button type="button"   id="btnEmail2"  class="btn btn-primary btn-xs"  >提现审核</button>	
														</a>
													</c:if>
												</gyzbadmin:function>
												<gyzbadmin:function url="<%=MerchantWithdrawPath.BASE+MerchantWithdrawPath.MERCHANTWITHDRAWVERIFICATION%>">
													<c:if test="${withdraw.verificationState=='01' and withdraw.auditState=='05'}">
														<a href="#verificationWithdrawModal"  data-toggle='modal' class="tooltip-error verificationWithdraw" data-rel="tooltip" title="核销">
															<button type="button"   id="btnEmail2"  class="btn btn-primary btn-xs"  >确认核销</button>	
														</a>
													</c:if>
													<c:if test="${withdraw.verificationState!='01' or withdraw.auditState!='05'}">
															<button type="button"   id="btnEmail2"  class="btn  btn-xs" disabled="disabled" >确认核销</button>	
													</c:if>
												</gyzbadmin:function>
											</td>
										</tr>
									</c:forEach>
									<c:if test="${empty withdrawList}">
										<tr>
											<td colspan="13" align="center"><font
												style="color: red; font-weight: bold; font-size: 15px;">暂无数据</font></td>
										</tr>
									</c:if>
								</tbody>
							</table>
						</div>
						<c:if test="${not empty withdrawList}">
							<%@ include file="/include/page.jsp"%>
						</c:if>
					</div>
					</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- 底部-->
			<%@ include file="/include/bottom.jsp"%>
		</div>
		<!-- /.main-content -->
		<!-- 设置 -->
		<%@ include file="/include/setting.jsp"%>
	</div>
	<!-- /.main-container-inner -->
	<div>
	<!-- 向上置顶 -->
	<%@ include file="/include/up.jsp"%>
	</div>
	<div class="modal fade" id="reviewWithdrawModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		   <div class="modal-dialog" style="width:50%">
		      <div class="modal-content">
		         <div class="modal-header">
		            <button type="button" class="close" data-dismiss="modal" aria-hidden="true"> &times;</button>
		            <h4 class="modal-title" id="myModalLabel">审核信息</h4>
		         </div>
		         <input type="hidden" id="coreSn" />
		         <input type="hidden" id="bankAcctNoInternal" />
		         <div class="modal-body">
		         	<input type="hidden" id="custId" name="custId" >
		            <table class="modal-input-table" style="width: 100%;">
		                <tr>
							<td class="td-left" width="15%">七分钱提现流水号</td>
							<td class="td-right" width="35%">
								<input type="text" id=withdrawSn name="withdrawSn" readonly="readonly" clasS="width-90">
							</td>
							<td class="td-left" width="15%">提现金额</td>
							<td class="td-right" width="35%">
								<input type="text" id="withdrawAmt" name="withdrawAmt" readonly="readonly" clasS="width-90">
							</td>
						</tr>
						  <tr>
							<td class="td-left">商户编号</td>
							<td class="td-right">
								<input type="hidden" id="custId" name="custId" readonly="readonly" clasS="width-90">
								<input type="text" id="merchantCode" name="merchantCode" readonly="readonly" clasS="width-90">
								
							</td>
							<td class="td-left">审核状态</td>
							<td class="td-right">
								<select id="auditState" name="auditState" clasS="width-90" disabled="disabled">
									<option value="01">待审核</option>
									<option value="02">审核通过</option>
									<option value="04">审核不通过</option>
								</select>
							</td>
						</tr>
		            	<tr>
							<td class="td-left">商户名</td>
							<td class="td-right">
								<input type="text" id=custName name="custName" readonly="readonly" clasS="width-90">
							</td>
							<td class="td-left">审核人</td>
							<td class="td-right">
								<input type="text" id="modifyId" name="modifyId" readonly="readonly" clasS="width-90">
							</td>
						</tr>
						<tr>
							<td class="td-left">审核时间</td>
							<td class="td-right">
								<input type="text" id="auditTime" name="auditTime" readonly="readonly" clasS="width-90">
							</td>
							<td class="td-left">收款名</td>
							<td class="td-right" >
								<input type="text" id="bankAcctName" name="bankAcctName" readonly="readonly" clasS="width-90">
							</td>
							
						</tr>
						<tr>
							<td class="td-left" >开户行</td>
							<td class="td-right">
								<input type="text" id="bankName" name="bankName" readonly="readonly" clasS="width-90">
							</td>
							<td class="td-left">核销状态</td>
							<td class="td-right">
								<select id="verificationState" name="verificationState" clasS="width-90" disabled="disabled">
									<option value="01">未核销</option>
									<option value="02">已核销</option>
								</select>
							</td>
						</tr>
						<tr>
							<td class="td-left" >银行卡</td>
							<td class="td-right" >
								<input type="text" id="bankCode" name="bankCode" readonly="readonly" clasS="width-90">
							</td>
							<td class="td-left">核销人</td>
							<td class="td-right">
								<input type="text" id="verificationUser" name="verificationUser" readonly="readonly" clasS="width-90">
							</td>
						</tr>
						<tr>
							<td class="td-left" >手续费</td>
							<td class="td-right">
								<input type="text" id="fee" name="fee" readonly="readonly" clasS="width-90">
							</td>
							<td class="td-left">核销时间</td>
							<td class="td-right">
								<input type="text" id="verificationDate" name="verificationDate" readonly="readonly" clasS="width-90">
							</td>
						</tr>
		            </table>
		         </div>
		         <div class="modal-footer">
		            <button type="button" class="btn btn-default noAuditBtn" >审核不通过</button>
		            <button type="button" class="btn btn-primary yesAuditBtn">审核通过</button>
		         </div>
		      </div><!-- /.modal-content -->
		     </div>
		</div><!-- /.modal -->
         <div class="modal fade" id="verificationWithdrawModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		   <div class="modal-dialog">
		      <div class="modal-content" style="width: 600px;">
		         <div class="modal-header">
		            <button type="button" class="close" data-dismiss="modal" aria-hidden="true"> &times;</button>
		            <h4 class="modal-title" id="myModalLabel">确认核销</h4>
		         </div>
		         <div class="modal-body" align="center">
		         	<font style="color: red; font-weight: bold; font-size: 15px;">您确定已核销[<span class="withdrawSn"></span>]么？</font>
		         	<input type="hidden" name="withdrawSn" id="withdrawSn" />
		         </div>
		         <div class="modal-footer">
		            <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
		            <button type="button" class="btn btn-primary verificationWithdrawBtn">确定</button>
		         </div>
		      </div><!-- /.modal-content -->
				    </div>
				</div>
<script type="text/javascript">
	function load(){
		var auditState2=$("#auditState2").val();
		$(".search-table #auditState").val(auditState2);
		var withdrawState2=$("#withdrawState2").val();
		$(".search-table #withdrawState").val(withdrawState2);
		var verificationState2=$("#verificationState2").val();
		$(".search-table #verificationState").val(verificationState2);
	}
	
	$(function () {	
		
		$('.clearWithdraw').click(function(){
			$('.search-table #auditState').val('');
			$('.search-table #withdrawState').val('');
			$('.search-table #verificationState').val('');
			$('.search-table #beginTime').val('');
			$('.search-table #endTime').val('');
			$('.search-table #withdrawSn').val('');
			$('.search-table #merchantCode').val('');
		}) 
		
		//按条件查询
		$('.buttonSearch').click(function(){
			var startDate =$("#beginTime").val();
			var endDate= $("#endTime").val();
			if("" != startDate && "" != endDate && startDate > endDate) 
			{
				$.gyzbadmin.alertFailure("结束日期不能小于开始日期");
				return false;
			}
			var form = $('#tradeForm');
			form.submit();
		});
		
		var withdraws= ${withdraws};
		var withdrawList=$("tr.withdraw");
		$.each(withdraws,function(i,value){
			$.data(withdrawList[i],"withdraw",value);
			
		});
		
		$(".exportBut").click(function(){
			var auditState = $('.search-table #auditState').val();
			var withdrawState =$('.search-table #withdrawState').val();
			var verificationState =$('.search-table #verificationState').val();
			var beginTime =$('.search-table #beginTime').val();
			var endTime =$('.search-table #endTime').val();
			var withdrawSn =$('.search-table #withdrawSn').val();
			var merchantCode =$('.search-table #merchantCode').val();
			
			var src ="<%= request.getContextPath()+ MerchantWithdrawPath.BASE+MerchantWithdrawPath.MERCHANTWITHDRAWEXPORT%>?auditState="+
			auditState+"&withdrawState="+withdrawState+"&verificationState="+verificationState+"&beginTime="+beginTime+"&endTime="+endTime+"&merchantCode="+merchantCode+"&withdrawSn="+withdrawSn;
			$(".exportBut").attr("href",src);
		});
		
		
		$(".verificationWithdraw").click(function(){
			var withdraw =$.data($(this).parent().parent()[0],"withdraw");
			
			$('#verificationWithdrawModal').on('show.bs.modal', function () {
				// 赋值
				$('#verificationWithdrawModal .withdrawSn').html(withdraw.withdrawSn);
				$('#verificationWithdrawModal #withdrawSn').val(withdraw.withdrawSn);
			
			});
			$('#verificationWithdrawModal').on('hide.bs.modal', function () {
				// 清除
				$('#verificationWithdrawModal .withdrawSn').empty();
				$('#verificationWithdrawModal #withdrawSn').val('');
				
			});
		})
		

	$('.verificationWithdrawBtn').click(function(){
		var withdrawSn = $('#verificationWithdrawModal #withdrawSn').val();
		$.blockUI();
		$.post(window.Constants.ContextPath + '<%= MerchantWithdrawPath.BASE+MerchantWithdrawPath.MERCHANTWITHDRAWVERIFICATION%>', {
			'withdrawSn':withdrawSn
			}, function(data) {
				$.unblockUI();
				if(data.result == 'SUCCESS'){
					$('#verificationWithdrawModal').modal('hide');
					$.gyzbadmin.alertSuccess('核销成功', null, function(){
						window.location.reload();
					});
				} else {
					$.gyzbadmin.alertFailure(data.message,function(){
					},function(){
						window.location.reload();
					});
				}
			}, 'json'
		);
	});
		
		$(".auditWithdraw").click(function(){
			var withdraw =$.data($(this).parent().parent()[0],"withdraw");
			
			if(withdraw.auditState!='01'){
				$("#reviewWithdrawModal .modal-footer").hide();
			}else{
				$("#reviewWithdrawModal .modal-footer").show();
			}
			
			$('#reviewWithdrawModal').on('show.bs.modal', function () {
				$("#reviewWithdrawModal #coreSn").val(withdraw.coreSn);
				$("#reviewWithdrawModal #withdrawSn").val(withdraw.withdrawSn);
				$("#reviewWithdrawModal #custId").val(withdraw.custId);
				$("#reviewWithdrawModal #custName").val(withdraw.custName);
				$("#reviewWithdrawModal #bankAcctName").val(withdraw.bankAcctName);
				$("#reviewWithdrawModal #bankName").val(withdraw.bankName);
				$("#reviewWithdrawModal #bankCode").val(withdraw.bankCode);
				$("#reviewWithdrawModal #withdrawAmt").val(withdraw.withdrawAmt);
				$("#reviewWithdrawModal #fee").val(withdraw.fee);
				$("#reviewWithdrawModal #bankAcctNoInternal").val(withdraw.bankAcctNoInternal);
				$("#reviewWithdrawModal #custId").val(withdraw.custId);
				$("#reviewWithdrawModal #merchantCode").val(withdraw.merchantCode);
				$("#reviewWithdrawModal #verificationState").val(withdraw.verificationState);
				$("#reviewWithdrawModal #verificationUser").val(withdraw.verificationUser);
				$("#reviewWithdrawModal #verificationDate").val(withdraw.verificationDate);
				$("#reviewWithdrawModal #auditState").val(withdraw.auditState);
				$("#reviewWithdrawModal #modifyId").val(withdraw.modifyId);
				$("#reviewWithdrawModal #auditTime").val(withdraw.auditTime);
			});	
			$('#reviewWithdrawModal').on('hide.bs.modal', function () {
				$("#reviewWithdrawModal #coreSn").val('');
				$("#reviewWithdrawModal #withdrawSn").val('');
				$("#reviewWithdrawModal #custId").val('');
				$("#reviewWithdrawModal #custName").val('');
				$("#reviewWithdrawModal #bankAcctName").val('');
				$("#reviewWithdrawModal #bankName").val('');
				$("#reviewWithdrawModal #bankCode").val('');
				$("#reviewWithdrawModal #withdrawAmt").val('');
				$("#reviewWithdrawModal #fee").val('');
				$("#reviewWithdrawModal #bankAcctNoInternal").val('');
				$("#reviewWithdrawModal #custId").val('');
				$("#reviewWithdrawModal #merchantCode").val('');
				$("#reviewWithdrawModal #verificationState").val('');
				$("#reviewWithdrawModal #verificationUser").val('');
				$("#reviewWithdrawModal #verificationDate").val('');
				$("#reviewWithdrawModal #auditState").val('');
				$("#reviewWithdrawModal #modifyId").val('');
				$("#reviewWithdrawModal #auditTime").val('');
			});	
			
		});
		
		$(".noAuditBtn").click(function(){
			$.blockUI();
			$.post(window.Constants.ContextPath +'<%=MerchantWithdrawPath.BASE+MerchantWithdrawPath.MERCHANTWITHDRAWAUDITNOPASS%>',{
				'withdrawSn'	:$("#reviewWithdrawModal #withdrawSn").val(),
				'custId'		:$("#reviewWithdrawModal #custId").val(),
				'withdrawAmt'	:$("#reviewWithdrawModal #withdrawAmt").val(),
				'bankCode'		:$("#reviewWithdrawModal #bankCode").val(),
				'coreSn'		:$("#reviewWithdrawModal #coreSn").val(),
				'bankAcctNoInternal' 	:$("#reviewWithdrawModal #bankAcctNoInternal").val()
			},function(data){
				$.unblockUI();
				if(data.result=='SUCCESS'){
					$.gyzbadmin.alertSuccess("审核成功！",function(){
						$("#reviewWithdrawModal").modal("hide");
					},function(){
						window.location.reload();
					});
				}else{
					$.gyzbadmin.alertFailure(data.message,function(){
					},function(){
						window.location.reload();
					});
				}
			},'json'
				);
		});
		
		$(".yesAuditBtn").click(function(){
			$.blockUI();
			$.post(window.Constants.ContextPath +'<%=MerchantWithdrawPath.BASE+MerchantWithdrawPath.MERCHANTWITHDRAWAUDITPASS%>',{
				'withdrawSn'	:$("#reviewWithdrawModal #withdrawSn").val(),
				'custId'		:$("#reviewWithdrawModal #custId").val(),
				'withdrawAmt'	:$("#reviewWithdrawModal #withdrawAmt").val(),
				'bankCode'	:$("#reviewWithdrawModal #bankCode").val(),
				'coreSn'		:$("#reviewWithdrawModal #coreSn").val(),
				'bankAcctNoInternal' 	:$("#reviewWithdrawModal #bankAcctNoInternal").val()
			},function(data){
				$.unblockUI();
				if(data.result=='SUCCESS'){
					$.gyzbadmin.alertSuccess("审核成功！",function(){
						$("#reviewWithdrawModal").modal("hide");
					},function(){
						window.location.reload();
					});
				}else{
					$.gyzbadmin.alertFailure(data.message,function(){
					},function(){
						window.location.reload();
					});
				}
			},'json'
				);
		});
		 	
		$('#myTab li:eq(5) a').tab('show');
	   });
	
	$("#balanceWhole").click(function(){
		window.location.href="<%=request.getContextPath()+FinanceQueryPath.BASE + FinanceQueryPath.LIST%>";
	 });
	
	$("#changeBalance").click(function(){
		window.location.href="<%=request.getContextPath()+FinanceQueryPath.BASE + FinanceQueryPath.CHANGEBALANCELIST%>";
	 });
	
	$("#commerciaBalance").click(function(){
		window.location.href="<%=request.getContextPath()+FinanceQueryPath.BASE + FinanceQueryPath.COMMERCIABALANCELIST%>";
	 });
	
	$("#userBalance").click(function(){
		window.location.href="<%=request.getContextPath()+FinanceQueryPath.BASE + FinanceQueryPath.USERBALANCELIST%>";
	 });
	
	$("#cashSettlement").click(function(){
		window.location.href="<%=request.getContextPath()+WithdrawPath.BASE + WithdrawPath.WITHDRAWLIST%>";
	 });
	
	$("#withdrawrevoke").click(function(){
		window.location.href="<%=request.getContextPath()+WithdrawRevokePath.BASE + WithdrawRevokePath.WITHDRAWREVOKE%>";
	 });
	</script>
</body>
</html>