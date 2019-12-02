<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/include/template.jsp"%>
<%@page import="com.qifenqian.bms.basemanager.merchant.MerchantPath" %>
<%@page import="com.qifenqian.bms.basemanager.merchant.MerchantEnterPath" %>
<%@page import="com.qifenqian.bms.basemanager.merchant.TinyMerchantPath" %>
<%@page import="com.qifenqian.bms.basemanager.agency.controller.AgentRegisterPath" %>
<%@ page import="com.qifenqian.bms.basemanager.merchant.bean.Merchant" %>
<%@ page import="com.qifenqian.bms.basemanager.city.CityPath" %>
<script src='<c:url value="/static/js/ajaxfileupload.js"/>'></script>
<script src='<c:url value="/static/js/comm.js"/>'></script>
<script src='<c:url value="/static/js/upload.js"/>'></script>
<script src='<c:url value="/static/js/mobileBUGFix.mini.js"/>'></script>
<script src='<c:url value="/static/js/uploadCompress.js"/>'></script>
<script src='<c:url value="/static/js/register.js"/>'></script>
<script src='<c:url value="/static/js/checkRule_source.js"/>'></script>
<script src="<c:url value='/static/js/jquery.combo.select.js'/>"></script>
<html>
<head>
	<meta charset="utf-8" />
	<title>商户注册新增</title>
	<meta name="keywords" content="七分钱后台管理系统" />
	<meta name="description" content="七分钱后台管理" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<link rel="stylesheet" href="<c:url value='/static/css/combo.select.css' />" />
	<link rel="stylesheet" href="<c:url value='/static/css/combo.select.scss' />" />
	<style type="text/css">
	table tr td{word-wrap:break-word;word-break:break-all;}
	.uploadImage{ float:left;
			background:url(<%=request.getContextPath() %>/static/images/upload.jpg);
			background-size:120px 100px;
			width:120px;
			height:100px;
			margin: 10 10 10 10;
			}
	</style>
</head>
<script type="text/javascript">

$(function(){
	$("input[type=file]").each(
		function() {
			var _this = $(this);
			_this.localResizeIMG({
				quality : 0.8,
				success : function(result,file) {

					var att = pre.substr(pre.lastIndexOf("."));
					//压缩后图片的base64字符串
					var base64_string = result.clearBase64;

					$('#'+_this.attr('id')+'temp').val(att+","+base64_string);
					//图片预览
		            var imgObj = $('#'+_this.attr('id')+'ImageDiv');
		            imgObj.attr("src", "data:image/jpeg;base64," + base64_string).show();
		            var width = result.width;
		            var height = result.height;
		            var scale =  width/height;
		            if(width >800){
		            width = 800;
		            height = width / scale;
		            }
		            $(".showDiv").width(width+"px");
		            $(".showDiv").height(height+"px");

		            //优图
		            var param = "{str:\""+base64_string+"\",flag:\""+_this.attr('id')+"\"}"
		    		$.ajax({
	    	   			async:false,
	    	   			type:"POST",
	    	   			contentType:"application/json;charset=utf-8",
	    	   			dataType:"text",
	    	   			url:window.Constants.ContextPath +'<%=AgentRegisterPath.BASE + AgentRegisterPath.YOUTU%>',
	    	   	        data:param,
	    	   	        success:function(data){
	    	   	      		var json = eval('(' + data + ')');
	    	   	        	if(json.result=="SUCCESS"){
	    	   	        		 if(_this.attr('id')=="certAttribute1"){                    //身份证
	    	       	  				$("#representativeName").val(json.cardName);
	    	       	  				$("#representativeCertNo").val(json.cardId);
	    	       	  			}else if(_this.attr('id')=="businessPhoto"){                //营业执照
	    	       	  				$("#businessLicense").val(json.businessLicense);
	    	       	  				$("#businessTermStart").val(json.businessTermStart);
	    	       	  				if("长期"==json.businessTermEnd){
	    	       	  					$("#businessTermEnd").val("2099-12-31");
	    	       	  				}else{
	    	       	  					$("#businessTermEnd").val(json.businessTermEnd);
	    	       	  				}
	    	       	  				$("#custAdd").val(json.legalAddress);
	    	       	  				$("#custName").val(json.companyName);
	    	       	  			}else if(_this.attr('id')=="bankCardPhoto"){                //银行卡
    	       	  					$("#compMainAcct").val(json.creditCardId);
    	       	  					// $("#compAcctBank").val(json.cardNo);
    	       	  				
	    	       	  			}
	    	   				}
	    	   			}
		    	   	});
				}
			});
		}
	);
	$("#agentName").comboSelect();
	$("#custManager").comboSelect();
});

function getbranchBank(){
	var provVal = $("#bankProvinceName").val().trim();
	var city = $("#bankCityName").val().trim();
	var compAcctBank = $("#compAcctBank").val();
	
	var channelCode ="";
	$.post(window.Constants.ContextPath +"/common/info/bankCnapsInfo",
	{
		"provinceId": provVal,
		"cityCode":   city,
		"bankCode":   compAcctBank,
		"channelCode":channelCode
	},
	function(data){
		if(data.result=="SUCCESS"){
			var branchBankList = data.branchBankList;
			$("#branchBank").html("");
   			for ( var branchBank in branchBankList) {
   				$("#branchBank").append(
   						"<option value='"+ branchBankList[branchBank].branchBankCode +"'>"
   								+ branchBankList[branchBank].bankName + "</option>"); 
   			}
		}
		
	},'json'
	);	
	}
/**开户行城市 **/
function getBankCityList(){

	var provVal = $("#bankProvinceName").val().trim();
	$("#backCityDef").siblings().remove();
	if ("" == provVal || provVal.length == 0) {
		return false;
	}
	$.ajax({
		type:"POST",
		dataType:"json",
		url:window.Constants.ContextPath +'<%=CityPath.BASE+CityPath.GET_CITY_BY_PROVINCEID %>',
		data:
		{
			"provinceId" 	: provVal
		},
		success:function(data){
			var cityList = data.cityList;
			for ( var city in cityList) {
				$("#bankCityName").append(
					"<option value='"+ cityList[city].cityId +"'>" + cityList[city].cityName + "</option>");
			}
		}
	})
}
/**注册城市**/
function getCityList(){

	var provVal = $("#province").val().trim();
	$("#cityDef").siblings().remove();
	$("#areaDef").siblings().remove();
	if ("" == provVal || provVal.length == 0) {
		return false;
	}
	$.ajax({
		type:"POST",
		dataType:"json",
		url:window.Constants.ContextPath +'<%=MerchantPath.BASE+MerchantPath.GRTCITYLIST %>',
		data:
		{
			"province" 	: provVal,
			"choiceType" : "city"
		},
		success:function(data){
			if(data.result=="SUCCESS"){
				var cityList = data.cityList;
				for ( var city in cityList) {
					$("#city").append(
						"<option value='"+ cityList[city].cityId +"'>" + cityList[city].cityName + "</option>");
				}
			}else{
			}
		}
	})
}
/**注册区县**/
function getAreaList(){

	var city = $("#city").val().trim();
	$("#areaDef").siblings().remove();
	if ("" == city || city.length == 0) {
		return false;
	}

	$.ajax({
		type:"POST",
		dataType:"json",
		url:window.Constants.ContextPath +'<%=MerchantPath.BASE+MerchantPath.GRTCITYLIST %>',
		data:
		{
			"city" 	: city,
			"choiceType" : "area"
		},
		success:function(data){
			if(data.result=="SUCCESS"){
				var areaList = data.areaList;
				for ( var area in areaList) {
					$("#country").append(
						"<option value='"+ areaList[area].areaId +"'>" + areaList[area].areaName + "</option>");
				}
			}else{
			}
		}
	})
}




function addMerchantBtn(){
	/*账号校验*/
	if(isNull($("#merchantAccount")[0])){
		$("#merchantAccountLab").text("请设置商户账户");
		$("#merchantAccount").focus();
		return false;
	}

	/*客服号码校验*/
	if(isNull($("#contactPhone")[0])){
		$("#contactPhoneLab").text("请设置客服号码");
		$("#contactPhone").focus();
		return false;
	}
	
	if(!isPhoneNo($("#contactPhone")[0])){
		$("#contactPhoneLab").text("客服号码格式不对 ");
		$("#contactPhone").focus();
		return false;
	}

    /*省*/
    if(isNull($("#province")[0])){
        $("#provinceLab").text("请填写地址");
        $("#province").focus();
        return false;
    }
    /*市*/
    if(isNull($("#city")[0])){
        $("#cityLab").text("请填写地址");
        $("#city").focus();
        return false;
    }
    /*区*/
    if(isNull($("#country")[0])){
        $("#countryLab").text("请填写地址");
        $("#country").focus();
        return false;
    }


	/*商户地址*/
	if(isNull($("#custAdd")[0])){
		$("#custAddLab").text("请填写地址");
		$("#custAdd").focus();
		return false;
	}
	var custType =$("#custType").val();
	var roleId = 'ent';
	var merchantFlag = '0';
	var merchantAccount =$("#merchantAccount").val();
	if(custType =='0'){
		roleId = 'per';
		merchantFlag = '2'
	}else if(custType =='1' ){
		roleId = 'ent';
		merchantFlag = '0';
	}else if(custType =='2'){
		roleId = 'ent';
		merchantFlag = '2';
	}
	var validateLicense =true ;
	//验证商户账户唯一性
	$.ajax({
		async:false,
		dataType:"json",
		url:window.Constants.ContextPath +'<%=MerchantEnterPath.BASE+MerchantEnterPath.VALIDATEMERCHANTACCOUNT%>',
		data:{merchantAccount:merchantAccount,roleId:roleId},
		success:function(data){
			if(data.result=="FAIL"){
				$("#merchantAccountLab").text("该账号已经被使用");
				validateLicense = false;
				return false;
			}else{
				validateLicense = true;
			}
		}});

	
	/*个人*/
	if(custType=='0'){
		
	}
	/*企业*/
	if(custType=='1' || custType=='2' ){

        /*营业执照号*/
        if(isNull($("#businessLicense")[0])){
            $("#businessLicenseLab").text("请填写营业执照注册号");
            $("#businessLicense").focus();
            return false;
        }

		/*营业执照有限期 */
		if(isNull($("#businessTermStart")[0])){
			$("#businessTermStartLab").text("请选择日期");
			$("#businessTermStart").focus();
			return false;
		}

		if(isNull($("#businessTermEnd")[0])){
			$("#businessTermEndLab").text("请选择日期");
			$("#businessTermEnd").focus();
			return false;
		}

		/*起始日期判断 */
		var startDate = $("#businessTermStart").val();
		var endDate= $("#businessTermEnd").val();
		if("" != startDate && "" != endDate && startDate > endDate)
		{
			$.gyzbadmin.alertFailure("结束日期不能小于开始日期");
			return false;
		}

		// 校验营业时间
		if(!Register.validateBusinessTerm($("#businessTermStart").val().trim(),$("#businessTermStartLabel"))){
			return false;
		}

		if($("input:radio[name='end']:checked").val()=='sel'){
			if(!Register.validateBusinessTerm($("#businessTermEnd").val().trim(),$("#businessTermStartLabel"))){
				return false;
			}
			businessTermEnd = $("#businessTermEnd").val();
		}

		//营业执照号
		var flag = Register.validateBusinessLicense($("#businessLicense").val().trim(),$("#businessLicenseLab"));

		if(!flag){
			return false;
		}
	}

	/*法人姓名*/
	if(isNull($("#representativeName")[0])){
		$("#representativeNameLab").text("请填写法人姓名");
		$("#representativeName").focus();
		return false;
	}
	
	/*法人身份证*/
	if(isNull($("#representativeCertNo")[0])){
		$("#representativeCertNoLab").text("请填写法人身份证");
		$("#representativeCertNo").focus();
		return false;
	}

	/*联系人姓名*/
	if(isNull($("#contactName")[0])){
		$("#contactNameLab").text("请填写联系人姓名");
		$("#contactName").focus();
		return false;
	}
	
	/*联系人手机号*/
	if(isNull($("#contactMobile")[0])){
		$("#contactMobileLab").text("请填写联系人手机号");
		$("#contactMobile").focus();
		return false;
	}
	
	if(!isMobilePhone($("#contactMobile")[0])){
		$("#contactMobileLab").text("账号需用手机号 ");
		$("#contactMobile").focus();
		return false;
	}
	
	/*银行卡号*/
	if(isNull($("#compMainAcct")[0])){
		$("#compMainAcctLab").text("请填写银行卡号");
		$("#compMainAcct").focus();
		return false;
	}
	
	/**结算账号*/
    if($("#compMainAcct").val().length < 5 || $("#compMainAcct").val().length > 25){
        $("#compMainAcctLab").text("请填写5-25位银行卡号");
        $("#compMainAcct").focus();
        return false;
    }else{
        $("#compMainAcctLab").text('');
    }

    /*开户银行*/
	var compAcctBank = $("#compAcctBank").val().trim();
	if ("" == compAcctBank || compAcctBank.length == 0) {
		$("#compMainAcctLab").text("请填写开户银行");
		return false;
	}

	/*开户行*/
	if(isNull($("#branchBank")[0])){
		$("#branchBankLab").text("请填写开户行");
		$("#branchBank").focus();
		return false;
	}

	/*开户人 */
	if(isNull($("#bankAcctName")[0])){
		$("#bankAcctNameLab").text("请填写开户人");
		$("#bankAcctName").focus();
		return false;
	}

	/*网点号*/
	/* if(isNull($("#cnaps")[0])){
		$("#cnapseLab").text("请填写银联号");
		$("#cnaps").focus();
		return false;
	} */

	/*结算类型*/
	if(isNull($("#compMainAcctType")[0])){
		$("#compMainAcctTypeLab").text("请填写结算类型");
		$("#compMainAcctType").focus();
		return false;
	}

    if(isNull($("#custName")[0])){
        $("#custNameLab").text("请填写商户名称");
        $("#custName").focus();
        return false;
    }

    if(isNull($("#shortName")[0])){
        $("#shortNameLab").text("请填写商户简称");
        $("#shortName").focus();
        return false;
    }

	// 提交前清空所有错误提示栏
	var merchantAccount = $("#merchantAccount").val().trim();
	var custType = $("#custType").val().trim();
	var custName = $("#custName").val().trim();
	var shortName = $("#shortName").val().trim();
	var merchantEmail = $("#merchantEmail").val().trim();
	var contactPhone =  $("#contactPhone").val().trim();
	var province =  $("#province").val().trim();
	var city = $("#city").val().trim();
	var country = $("#country").val().trim();
	var custAdd = $("#custAdd").val().trim();
	var businessLicense = $("#businessLicense").val().trim();
	var businessTermStart = $("#businessTermStart").val().trim();
	var businessTermEnd = $("#businessTermEnd").val().trim();
	var custManager = $("#custManager").val().trim();
	var agentName = $("#agentName").val().trim();
	var representativeName = $("#representativeName").val().trim();
	var representativeCertNo = $("#representativeCertNo").val().trim();
	var contactName = $("#contactName").val().trim();
	var contactMobile = $("#contactMobile").val().trim();
	var compMainAcct = $("#compMainAcct").val().trim();
	var compAcctBank = $("#compAcctBank").val().trim();
	var branchBank = $("#branchBank").val().trim();
	var bankAcctName = $("#bankAcctName").val().trim();
	var bankProvinceName = $("#bankProvinceName").val().trim();
	var bankCityName = $("#bankCityName").val().trim();
	/* var cnaps =  $("#cnaps").val().trim(); */
	var cnaps =  $("#branchBank").val().trim();
	var compMainAcctType = $("#compMainAcctType").val().trim();
	
	var openAccountPath =  $("#openAccountPath").val();
	var bankCardPhotoPath = $("#bankCardPhotoPath").val();
	var certAttribute2Path = $("#certAttribute2Path").val();
	var certAttribute1Path = $("#certAttribute1Path").val();
	var businessPhotoPath = $("#businessPhotoPath").val();
	$.blockUI();

    $.ajax({
        type : "POST",
        url : window.Constants.ContextPath +'<%=MerchantEnterPath.BASE + MerchantEnterPath.ADD%>',
        data :{
            "merchantAccount":       merchantAccount, 					// 商户账号
            "custType":              custType,							// 商户类型
            "custName":              custName, 							// 客户姓名
            "shortName":             shortName,                         // 客户简称
            "merchantEmail":         merchantEmail,						// 邮箱
            "contactPhone":          contactPhone,						// 客服电话
            "province":              province,							// 省份
            "city":                  city,								// 城市
            "country" :              country,							// 县区
            "custAdd" :              custAdd,							// 详细地址
            "businessLicense":       businessLicense,                   // 营业执照注册号
            "businessTermStart":     businessTermStart,					// 营业执照有限期
            "businessTermEnd" :      businessTermEnd,					// 营业执照有限截止期
            "custManager":           custManager,						// 客户经理
            "agentName":             agentName,							// 代理商
            "representativeName":    representativeName,				// 法人姓名
            "representativeCertNo":  representativeCertNo,				// 法人身份证号
            "contactName":           contactName,						// 联系人姓名
            "contactMobile":         contactMobile,						// 联系人电话
            "compMainAcct":          compMainAcct,						// 银行号
            "compAcctBank":          compAcctBank,						// 开户行
            "branchBank":            branchBank,						// 开户支行
            "bankAcctName":          bankAcctName,						// 开户人
            "bankProvinceName":      bankProvinceName,					// 开户行省份
            "bankCityName":          bankCityName,						// 开户行城市
            "cnaps":                 cnaps,								// 联行号
            "compMainAcctType":      compMainAcctType,					// 结算类型
            "merchantFlag":          merchantFlag						// 商户标识
        },
        dataType : "json",
        success : function(data) {
            if (data.result == 'SUCCESS') {
                //ajax
                $.ajax({
                    type : "POST",
                    url : window.Constants.ContextPath + '<%="/common/files/getPicPath"%>?custId='+data.custId,
                    data : {
                    	"openAccountPath" :  openAccountPath,                //开户许可证
                    	"idCardOPath"     :  certAttribute1Path,             //身份证正面照
                    	"idCardFPath"     :  certAttribute2Path,             //身份证背面照
                    	"bussinessPath"   :  businessPhotoPath,              //商户营业执照
                    	"bankCardPath"    :  bankCardPhotoPath               //开户银行照
                    },
                    dataType : "json",
                    success : function (data) {
                        if(data.result=='SUCCESS'){
                            $.gyzbadmin.alertSuccess("注册申请成功,请等待审批！",null,function(){
                                window.location.href = window.Constants.ContextPath + '<%=MerchantEnterPath.BASE + MerchantEnterPath.LIST %>';
                            });
                        }else{
                            $.gyzbadmin.alertFailure("扫描件上传失败,请选择合适的类型");

                        }
                    }
                });
            } else {
            	$.gyzbadmin.alertFailure("服务器内部错误，请联系相关技术人员");
                /* $.gyzbadmin.alertFailure("服务器内部错误，请联系相关技术人员，错误原因是：" + data.message); */
            }
        }
    });



}


/********************图片预览***********************/


/** 点击预览大图 **/
function bigImg(obj){
    var realWidth;
	var realHeight
	$('#showImageDiv #showImage').attr("src",obj.src).load(function(){
		realWidth = this.width;
		realHeight = this.height;
		var scale =  realWidth/realHeight;
		if(realWidth >800){
			realWidth = 800;
			realHeight = realWidth / scale;
		}
		$("#imageDiv").css("width",realWidth+"px").css("height",realHeight+"px");
	});
}


/** 营业执照预览 **/
function showBusinessPhotoImage(obj){
	 var divObj = document.getElementById("businessPhotoDiv");
	 var imageObj = document.getElementById("businessPhotoImage");
	 var result1 = previewImage(divObj,imageObj,obj);
	 return result1;
}
/** 营业执照点击预览 **/
$('.businessPhotoClick').click(function(){
	var divObj = document.getElementById("showImageDiv");
	var imageObj = document.getElementById("showImage");
	var obj = document.getElementById("businessPhoto");
	return previewImage(divObj,imageObj,obj);
});
/** 身份证正面预览 **/
function showCertAttribute1Image(obj){
	 var divObj = document.getElementById("certAttribute1Div");
	 var imageObj = document.getElementById("certAttribute1Image");
	 var result1 = previewImage(divObj,imageObj,obj);
	 return result1;
}
/** 身份证正面点击预览 **/
$('.certAttribute1Click').click(function(){
	var divObj = document.getElementById("showImageDiv");
	var imageObj = document.getElementById("showImage");
	var obj = document.getElementById("certAttribute1");
	return previewImage(divObj,imageObj,obj);
});
/** 身份证背面预览 **/
function showCertAttribute2Image(obj){
	 var divObj = document.getElementById("certAttribute2Div");
	 var imageObj = document.getElementById("certAttribute2Image");
	 var result1 = previewImage(divObj,imageObj,obj);
	 return result1;
}
/** 身份证背面点击预览 **/
$('.certAttribute2Click').click(function(){
	var divObj = document.getElementById("showImageDiv");
	var imageObj = document.getElementById("showImage");
	var obj = document.getElementById("certAttribute2");
	return previewImage(divObj,imageObj,obj);
});

/** 开户许可证预览 **/
function showOpenAccountImage(obj){
	 var divObj = document.getElementById("openAccountDiv");
	 var imageObj = document.getElementById("openAccountImage");
	 var result1 = previewImage(divObj,imageObj,obj);
	 return result1;
}
/** 开户许可证背面点击预览 **/
$('.openAccountClick').click(function(){
	var divObj = document.getElementById("showImageDiv");
	var imageObj = document.getElementById("showImage");
	var obj = document.getElementById("openAccount");
	return previewImage(divObj,imageObj,obj);
});

/** 银行卡预览 **/
function showBankCardPhotoImage(obj){
	 var divObj = document.getElementById("bankCardPhotoDiv");
	 var imageObj = document.getElementById("bankCardPhotoImage");
	 var result1 = previewImage(divObj,imageObj,obj);
	 return result1;
}
/** 银行卡点击预览 **/
$('.bankCardPhotoClick').click(function(){
	var divObj = document.getElementById("showImageDiv");
	var imageObj = document.getElementById("showImage");
	var obj = document.getElementById("bankCardPhoto");
	return previewImage(divObj,imageObj,obj);
});

//对公对私账户图片
$(function(){
	$('#compMainAcctType').on('change', function (e) {
		//bankCardPhoto_
		let compMainAcctType = $('#compMainAcctType').val();
		if(compMainAcctType == '01'){
			$('#openAccount_').show();
			$('#bankCardPhoto_').hide();
		}else{
			$('#bankCardPhoto_').show();
			$('#openAccount_').hide();
		}
	});
})

/**商户类型 **/
function selCustType(){
	//个人
	if($("#custType").val() =='0'  ){
		$('#businessCodeId_').hide();
		$('#businessPhotoId_').hide();
	}
	//企业 个体户
	if($("#custType").val() =='1' ||$("#custType").val() =='2'){
		$('#businessCodeId_').show();
		$('#businessPhotoId_').show();
	}
}

function businessForever(){
	$("input[name='businessTermEnd']").val("2099-12-31");
	$("#businessTermEnd").attr("value","2099-12-31");
}


/*
* file input file dom object
* pathTarget 路径保存的input元素id 
* preView 图片预览dom id
*/
function commonFileUpload(file, pathTarget, preView) {
	var formdata=new FormData();
    formdata.append("file",$(file).get(0).files[0]);
    $.ajax({
        url:'/common/files/uploadPic',
        type:'post',
        contentType:false,
        data:formdata,
        processData:false,
        async:false,
        success:function(info){ 
             $('#' + pathTarget + '').val(info.path);
        },
        error:function(err){
            console.log(err)
        }
    });

    var prevDiv = document.getElementById(preView);
    if (file.files && file.files[0]) {
        var reader = new FileReader();
        reader.onload = function (evt) {
        	prevDiv.innerHTML = '<img src="' + evt.target.result + '" onclick="bigImg(this);" style="width:120px;height:100px;" />';
        }
        reader.readAsDataURL(file.files[0]);
    } else {
        prevDiv.innerHTML = '<div class="img" style="filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod=scale,src=\'' + file.value + '\'"></div>';
    }
}

//营业执照上传
function showBusinessPhotoImage(file){
	commonFileUpload(file, 'businessPhotoPath', 'businessPhotoDiv');
}

//身份证正面
function showCertAttribute1Image(file){
	commonFileUpload(file, 'certAttribute1Path', 'certAttribute1Div');
}

//身份证反面
function showCertAttribute2Image(file){
	commonFileUpload(file, 'certAttribute2Path', 'certAttribute2Div');
} 

//上传银行卡照
function showBankCardPhotoImage(file){
	commonFileUpload(file, 'bankCardPhotoPath', 'bankCardPhotoDiv');
}

//上传开户许可证
function showOpenAccountImage(file){
	commonFileUpload(file, 'openAccountPath', 'openAccountDiv');
}
</script>
<body>
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
						<input type="hidden" id="businessPhototemp">
						<input type="hidden" id="certAttribute1temp">
						<input type="hidden" id="certAttribute2temp">
						<input type="hidden" id="openAccounttemp" />
						<input type="hidden" id="bankCardPhototemp" />
                    <table id="merchant_table" class="list-table">
					<tbody>
                        <tr>
							<td colspan="4" class="headlerPreview" style="background:#7ebde1;">商户信息</td>
						</tr>
						<tr></tr>
                        <tr>
							<td class="td-left">商户账号：<span style="color:red;">（必填)</span></td>
							<td class="td-right">
								<input type="text" id="merchantAccount" name="merchantAccount" placeholder="请输入手机号" maxlength="50" style="width:90%">
								
								<label class="label-tips" id="merchantAccountLab"></label>
							</td>
						</tr>
                        <tr>
							<td colspan="4" class="headlerPreview" style="background:#7ebde1">基本信息</td>
						</tr>
						<tr>
							<td class="td-left">商户类型：<span style="color:red;">（必填)</span></td>
							<td class="td-right">
							   <select name="custType" class="width-90" id="custType" onchange="selCustType();">
									<option value="1">企业</option>
									<option value="0">个人</option>
									<option value="2">个体户</option>
								</select>
								
							</td>
							<!-- <td class="td-left">商户标志：</td>
							<td class="td-right">
							   <select name="merchantFlag" class="width-90" id="merchantFlag" >
									<option value="0">商户</option>
									<option value="1">非商户</option>
									<option value="2">微商户</option>
									<option value="3">代理商</option>
								</select>
								
							</td> -->
						</tr>
                        <tr>
						    <td class="td-left" width="18%">商户名称：<span style="color:red;">（必填)</span></td>
							<td class="td-right" width="32%">
								<input type="text" id="custName" name="custName" maxlength="100"  placeholder="请输入商户名称" style="width:90%">
								
								<label class="label-tips" id="custNameLab"></label>
							</td>
							<td class="td-left" width="18%">商户简称：<span style="color:red;">（必填)</span></td>
							<td class="td-right" width="32%">
							    <input type="text" id="shortName" name="shortName" placeholder="请输入商户简称" style="width:90%">
								
								<label class="label-tips" id="shortNameLab"></label>
							</td>
						</tr>
						<tr>
							<td class="td-left">商户邮箱：</td>
							<td class="td-right">
								<input type="text" id="merchantEmail" name="merchantEmail" placeholder="请输入商户邮箱" style="width:90%">
								
								<label class="label-tips" id="merchantEmailLab"></label>
							</td>
							<td class="td-left">客服号码：<span style="color:red;">（必填)</span></td>
							<td class="td-right">
								<input type="text" id="contactPhone" name="contactPhone" placeholder="请输入客服号码" style="width:90%">
								
								<label class="label-tips" id="contactPhoneLab"></label>
							</td>
						</tr>
						<tr>
							<td class="td-left">商户地址：<span style="color:red;">（必填)</span></td>
							<td class="td-right" colspan="3">
								<div class="col-xs-2 pd0" style="padding:0">
                                   <select class="form-control" id="province" onchange="getCityList();">
                                       <c:if test="${not empty provincelist_ }">
                                        	<option value="">--请选择--</option>
						               <c:forEach items="${provincelist_ }" var="prov">
						                   <option value="${prov.provinceId }">${prov.provinceName }</option>
						               </c:forEach>
		               				</c:if>
                                   </select>
									<label class="label-tips" id="provinceLab"></label>
                                </div>
                                <div class="col-xs-2 pd0" style="margin:0 1%;padding:0;">
                                <select class="form-control" id="city" onchange="getAreaList();">
                                    <option value="" id="cityDef">--请选择--</option>
                                </select>
									<label class="label-tips" id="cityLab"></label>
                                </div>
                                <div class="col-xs-2 pd0" style="padding:0">
                                <select class="form-control" id="country">
                                    <option value="" id="areaDef">--请选择--</option>
                                </select>
									<label class="label-tips" id="countryLab"></label>
                                </div>
                                <div class="col-xs-5 pd0" >
                                    <input type="text" id="custAdd" name="custAdd"  placeholder="详细地址" style="width:100%">
                                	<label class="label-tips" id="custAddLab"></label>
                                </div>
                                
							</td>
					    </tr>
						<tr id="businessCodeId_"  style="display: " class="tab-pane active">
							<td class="td-left" id="businessCodeId">营业执照编号：<span style="color:red;">（必填)</span></td>
							<td class="td-right">
								<input type="text" id="businessLicense" name="businessLicense"  placeholder="请输入营业执照" style="width:90%">
								
								<label class="label-tips" id="businessLicenseLab"></label>
							</td>
							<td class="td-left" id="businessTimeId">营业执照有效期：<span style="color:red;">（必填)</span></td>
							<td class="td-right">
								<input type="text" id="businessTermStart" name="businessTermStart" readonly="readonly" onfocus="WdatePicker({skin:'whyGreen'})" style="background:#fff url(/static/My97DatePicker/skin/datePicker.gif) no-repeat right!important; width:30%"/>
								<label class="label-tips" id="businessTermLabStart"></label>
								-
								<input type="text" id="businessTermEnd" name="businessTermEnd" readonly="readonly" onfocus="WdatePicker({skin:'whyGreen'})" style="background:#fff url(/static/My97DatePicker/skin/datePicker.gif) no-repeat right!important; width:30%"/>
								<label class="label-tips" id="businessTermLabEnd"></label>
								<input type="button" onclick="businessForever()" value="长期" />
								
							</td>
						</tr>
						<tr id="businessPhotoId_"  style="display: ">
							<td class="td-left" id="businessPhotoId">营业执照扫描件：<span style="color:red">*</span></td>
							<td class="td-right" colspan="3">
								<a data-toggle='modal' class="tooltip-success businessPhotoClick" data-target="#previewImageModal" >
									<label id="businessPhotoDiv" class="uploadImage" >
										<img  id="businessPhotoImage" onclick="bigImg(this);"  style="width:100%;height:100%;display:none"  />
									</label>
								</a>
								<div class="updateImageDiv" style="float:left; margin-top:75 " >
									<input  type="hidden" id="businessPhotoPath" name="businessPhotoPath" />
									<input type="hidden" id="businessPhotoImageVal02"  />
									<input type="file" name="businessPhoto" id="businessPhoto" onchange="showBusinessPhotoImage(this)" />
									<span style="color:gray">支持*jpg、*jpeg、*gif、*bmp、*png图片格式</span>
								</div>
								<label class="label-tips" id="businessPhotoLabel" style="float:left;margin-top:88" ></label>
							</td>
						</tr>
						<tr>
							<td class="td-left">所属业务人员：</td>
							<td class="td-right">
								<sevenpay:selectSysUserTag name="custManager" id="custManager" defaultValue="${queryBean.custManager}"/>
							</td>
							<%-- <td class="td-right">
								<select id="custManager" name="custManager">
									<option value=${sysUser.userName }>${sysUser.userName }</option>
									<c:forEach items="${userlist }" var="bean">
										<option value="${bean.userName }">${bean.userName }</option>
									</c:forEach>
								</select>
							</td> --%>
							<td class="td-left" width="18%">所属代理商：</td>
							<td class="td-right" width="32%">
								<sevenpay:selectAgentMerchantTag name="agentName" id="agentName" defaultValue="${queryBean.agentCustId }"/>
								<%-- <select id="agentName" name="agentName">
									<option value=${sysUser.deptName }>${sysUser.deptName }</option>
									<c:forEach items="${agentList }" var="bean">
										<option value="${bean.custName }">${bean.custName }</option>
									</c:forEach>
								</select> --%>
							</td>
						</tr>
                        <tr>
							<td colspan="4" class="headlerPreview" style="background:#7ebde1;">法人信息</td>
						</tr>
						<tr></tr>
						<tr>
							<td class="td-left">法人真实姓名：<span style="color:red;">（必填)</span></td>
							<td class="td-right">
								<input type="text" id="representativeName" name="representativeName" placeholder="请输入法人真实姓名" maxlength="50" style="width:90%">
								
								<label class="label-tips" id="representativeNameLab"></label>
							</td>
							<td class="td-left">法人身份证号码：<span style="color:red;">（必填)</span></td>
							<td class="td-right">
								<input type="text" name="representativeCertNo" id="representativeCertNo" placeholder="请输入法人身份证号码" style="width:90%">
								
								<label class="label-tips" id="representativeCertNoLab"></label>
							</td>
						</tr>
						<tr >
							<td class="td-left" >法人身份证正面<span style="color:red">*</span></td>
							<td class="td-right" >
								<a data-toggle='modal' class="tooltip-success certAttribute1Click"  data-target="#previewImageModal" >
								<label id="certAttribute1Div" class="uploadImage">
								        <img  id="certAttribute1Image" onClick="bigImg(this);"   style="width:100%;height:100%;display:none"/>
								</label>
								</a>
								<div style="float:left;margin-top:75" >
								    <input  type="hidden" id="certAttribute1Path" name="certAttribute1Path" />
									<input type="file" name="certAttribute1" id="certAttribute1" onChange="showCertAttribute1Image(this)"/> <p> <span style="color:gray">支持*jpg、*jpeg、*gif、*bmp、*png图片格式</span>
								</div>
								<label class="label-tips" id="certAttribute1Label" style="float:left;margin-top:88"></label>
							</td>
						</tr>
						<tr>
							<td class="td-left" >法人身份证背面<span style="color:red">*</span></td>
							<td class="td-right" >
								<a data-toggle='modal' class="tooltip-success certAttribute2Click"  data-target="#previewImageModal" >
									<label id="certAttribute2Div" class="uploadImage">
									        <img  id="certAttribute2Image" onClick="bigImg(this);"  style="width:100%;height:100%;display:none"/>
									</label>
								</a>
								<div style="float:left;margin-top:75" >
									<input  type="hidden" id="certAttribute2Path" name="certAttribute2Path" />
									<input type="file" name="certAttribute2" id="certAttribute2" onChange="showCertAttribute2Image(this)"/> <p> <span style="color:gray">支持*jpg、*jpeg、*gif、*bmp、*png图片格式</span>
								</div>
								<label class="label-tips" id="certAttribute2Label" style="float:left;margin-top:88"></label>
							</td>
						</tr>
                        <tr>
							<td colspan="4" class="headlerPreview" style="background:#7ebde1;">联系信息</td>
						</tr>
						<tr></tr>
                        <tr>
							<td class="td-left">联系人姓名：<span style="color:red;">（必填)</span></td>
							<td class="td-right">
								<input type="text" id="contactName" name="contactName" placeholder="请输入联系人姓名" maxlength="50" style="width:90%">
								
								<label class="label-tips" id="contactNameLab"></label>
							</td>
							<td class="td-left">联系人手机号码：<span style="color:red;">（必填)</span></td>
							<td class="td-right">
								<input type="text" name="contactMobile" id="contactMobile" placeholder="请输入联系人手机号码" style="width:90%">
								
								<label class="label-tips" id="contactMobileLab"></label>
							</td>
						</tr>
						<tr id="next_id">
							<td colspan="4" class="headlerPreview" style="background:#7ebde1;">结算信息</td>
						</tr>
						<tr>
							<td class="td-left">结算账号<span style="color:red;">（必填)</span></td>
							<td class="td-right">
								<input type="text" id="compMainAcct" name="compMainAcct" maxlength="100" placeholder="请输入结算账号" style="width:90%">
								
								<label class="label-tips" id="compMainAcctLab"></label>
							</td>
							<td class="td-left">开户人：<span style="color:red;">（必填)</span></td>
							<td class="td-right">
								<input type="text" id="bankAcctName" name="bankAcctName" placeholder="请输入开户人" style="width:90%">
								
								<label class="label-tips" id="bankAcctNameLab"></label>
							</td>
							
						</tr>
						
                        <tr>
							<td class="td-left">开户省份：<span style="color:red;">（必填)</span></td>
							<td class="td-right">
								<select class="width-90" id="bankProvinceName" onchange="getBankCityList();">
	                                   <c:if test="${not empty provincelist }">
                                        	<option value="">--请选择--</option>
						               <c:forEach items="${provincelist }" var="prov">
						                   <option value="${prov.provinceId }">${prov.provinceName }</option>
						               </c:forEach>
		               				</c:if>
	                               </select>
							</td>
							<td class="td-left">开户城市：<span style="color:red;">（必填)</span></td>
							<td class="td-right">
							   <select class="width-90" id="bankCityName">
                                  <option value="" id="backCityDef">--请选择--</option>
                               </select>
							</td>
						</tr>
						<tr>
							<td class="td-left">开户银行：<span style="color:red;">（必填)</span></td>
							<td class="td-right">
								<select class="width-90" id="compAcctBank" name="compAcctBank" onchange="getbranchBank();">
                                <c:if test="${not empty banklist }">
                                   <option value="">--请选择--</option>
					               <c:forEach items="${banklist }" var="bank">
					                   <option value="${bank.bankCode }">${bank.bankName }</option>
					               </c:forEach>
	               				</c:if>
                                </select>
								<label class="label-tips" id="compAcctBankLab"></label>
							</td>
							<td class="td-left">开户支行：<span style="color:red;">（必填)</span></td>
							<td class="td-right">
								<select name="branchBank" id="branchBank" class="width-90" >
                                    <option value="">--请选择支行--</option>
                                </select>
                               	<label id="branchBankLab" class="label-tips"></label>
								<!-- <input type="text" id="branchBank" name="branchBank" placeholder="请输入开户行" style="width:90%">
								<label class="label-tips" id="branchBankLab"></label> -->
							</td>
							
						</tr>
                        <tr>
							<!-- <td class="td-left">网点号：<span style="color:red;">（必填)</span></td>
							<td class="td-right">
								<input type="text" id="cnaps" name="cnaps" placeholder="请输入网点号" style="width:90%"> <a href="http://www.lianhanghao.com" target="_blank">[查找]</a>
							</td> -->
							<td class="td-left">结算类型：<span style="color:red;">（必填)</span></td>
							<td class="td-right" class="width-90" >
								<select class="width-90 form-control"   id="compMainAcctType">
                                    <option  value="01">对公</option>
                                    <option  value="02">对私</option>
                                </select>
							</td>
						</tr>
						<tr id="bankCardPhoto_"  style="display: none" class="tab-pane active">
							<td class="td-left" id="cnm">银行卡照<span style="color:red">*</span></td>
							<td class="td-right" >
								<a data-toggle='modal' class="tooltip-success bankCardPhotoClick"  data-target="#previewImageModal" >
									<label id="bankCardPhotoDiv" class="uploadImage">
										<img  id="bankCardPhotoImage" onClick="bigImg(this);"  style="width:100%;height:100%;display:none"/>
									</label>
								</a>
								<div style="float:left;margin-top:75" >
									<input  type="hidden" id="bankCardPhotoPath" name="bankCardPhotoPath" />
									<input type="file" name="bankCardPhoto" id="bankCardPhoto" onChange="showBankCardPhotoImage(this)"/> <p> <span style="color:gray">支持*jpg、*jpeg、*gif、*bmp、*png图片格式</span>
								</div>
								<label class="label-tips" id="bankCardPhotoLabel" style="float:left;margin-top:88"></label>
							</td>
						</tr>

						<tr id="openAccount_" class="tab-pane " >
							<td class="td-left" >开户许可证<span style="color:red">*</span></td>
							<td class="td-right" >
								<a data-toggle='modal' class="tooltip-success openAccountClick"  data-target="#previewImageModal" >
									<label id="openAccountDiv" class="uploadImage">
									        <img  id="openAccountImage" onClick="bigImg(this);"  style="width:100%;height:100%;display:none"/>
									</label>
								</a>
								<div style="float:left;margin-top:75" >
									<input  type="hidden" id="openAccountPath" name="openAccountPath" />
									<input type="file" name="openAccount" id="openAccount" onChange="showOpenAccountImage(this)"/> <p> <span style="color:gray">支持*jpg、*jpeg、*gif、*bmp、*png图片格式</span>
								</div>
								<label class="label-tips" id="openAccountLabel" style="float:left;margin-top:88"></label>
							</td>
						</tr>
					</tbody>
					</table>
                        <div style="margin:50px 0 0 0;text-align:center">
                        	<button type="button"  class="btn btn-primary addMerchantBtn" onclick="addMerchantBtn()">保存</button>
                        	<a href="<%=request.getContextPath()+MerchantEnterPath.BASE + MerchantEnterPath.LIST%>"  class="btn btn-default" >关闭</a>
                        </div>
					</div>
					</div>
				</div><!-- /.page-content -->
				<!-- 图片预览 -->
				<div class="modal fade" id="previewImageModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
				    <div class="modal-dialog showDiv" >
	         			<div id="showImageDiv" style="width:100%;height:100%;">
				           <img id="showImage" style="width:100%;height:100%;">
				        </div>
				     </div>
				</div>
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
<script type="text/javascript">


        $("#representativeCertNo").on('blur',function () {
            if ($("#representativeCertNo").val().length < 5 || $("#representativeCertNo").val().length > 25){
                $("#representativeCertNoLab").text('');
            }else {
                $("#representativeCertNoLab").text("请填写5-25位身份证号");
                $("#representativeCertNoLab").focus();
                return false;
            }
        });

        <%-- $("#custManager").on('blur',function () {
            $.ajax({
                async:false,
                dataType:"json",
                url:window.Constants.ContextPath +'<%=MerchantEnterPath.BASE+MerchantEnterPath.VERIFYBUSINESSPERSONNEL%>',
                data:{custManager:$('#custManager').val()},
                success:function(data){
                    if(data.result=="FAIL"){
                        $("#custManagerLab").text("");
                    }else{
                        $("#custManagerLab").text("未查询到该业务员");
                        return false;
                    }
                }});
        });
 --%>
        //代理商
       <%--  $("#agentName").on('blur',function () {
            $.ajax({
                async:false,
                dataType:"json",
                url:window.Constants.ContextPath +'<%=MerchantEnterPath.BASE+MerchantEnterPath.VERIFICATIONAGENT%>',
                data:{deptName:$('#agentName').val()},
                success:function(data){
                    if(data.result=="FAIL"){
                        $("#agentNameLab").text("");
                    }else{
                        $("#agentNameLab").text("未查询到代理商");
                        return false;
                    }
                }});
        });
 --%>

        /*商户账号*/
        <%-- $("#merchantAccount").on('blur',function () {
        	if(!isPhoneNo($("#merchantAccount")[0])){
        		$("#merchantAccountLab").text("商户账户请用手机号 ");
        		$("#merchantAccount").focus();
        		return false;
        	}
            $.ajax({
                async:false,
                dataType:"json",
                url:window.Constants.ContextPath +'<%=MerchantEnterPath.BASE+MerchantEnterPath.VALIDATEMERCHANTACCOUNT%>',
                data:{deptName:$('#merchantAccount').val()},
                success:function(data){
                    if(data.result=="FAIL"){
                        $("#merchantAccountLab").text("");
                    }else{
                        $("#merchantAccountLab").text("未查询到代理商");
                        return false;
                    }
                }});
        }); --%>
		/*商户名称*/
        $("#custName").on('blur',function () {
            $("#custNameLab").text("");
        });
		/*商户简称 */
        $("#shortName").on('blur',function () {
            $("#shortNameLab").text("");
        });
		/*客服号码*/
        $("#contactPhone").on('blur',function () {
            $("#contactPhoneLab").text("");
        });
		/*商户地址*/
        $("#province").on('blur',function () {
            $("#provinceLab").text("");
        });
        $("#city").on('blur',function () {
            $("#cityLab").text("");
        });
        $("#country").on('blur',function () {
            $("#countryLab").text("");
        });
		/*联系人手机号码*/
        $("#contactMobile").on('blur',function () {
            $("#contactMobileLab").text("");
        });
       
</script>
</html>