<%@ page language="java" contentType="text/html; charset=gb2312"
    pageEncoding="gb2312"%>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<title>商户管理</title>
<link href="css/tq.css" rel="stylesheet" type="text/css">
<link href="css/iconbuttons.css" rel="stylesheet" type="text/css">
<script src="js/jquery.js" type="text/javascript">//jquery</script>
<script src="js/tq.js?0817" type="text/javascript">//表格</script>
<script src="js/tq.public.js?0817" type="text/javascript">//表格</script>
<script src="js/tq.datatable.js?0817" type="text/javascript">//表格</script>
<script src="js/tq.form.js?0817" type="text/javascript">//表单</script>
<script src="js/tq.searchform.js?0817" type="text/javascript">//查询表单</script>
<script src="js/tq.window.js?0817" type="text/javascript">//弹窗</script>
<script src="js/tq.hash.js?0817" type="text/javascript">//哈希</script>
<script src="js/tq.stab.js?0817" type="text/javascript">//切换</script>
<script src="js/tq.validata.js?0817" type="text/javascript">//验证</script>
<script src="js/My97DatePicker/WdatePicker.js" type="text/javascript">//日期</script>
</head>
<body>
<div id="shopobj" style="width:100%;height:100%;margin:0px;"></div>
<script language="javascript">
/*权限*/
var authlist = T.A.sendData("getdata.do?action=getauth&authid=${authid}");
var subauth=[false,false,false,false,false,false];
var ownsubauth=authlist.split(",");
for(var i=0;i<ownsubauth.length;i++){
	subauth[ownsubauth[i]]=true;
}
//添加
var _addmediaField = [
		{fieldcnname:"编号",fieldname:"id",fieldvalue:'',inputtype:"text", twidth:"100" ,height:"",issort:false,edit:false},
		{fieldcnname:"商户名称",fieldname:"name",fieldvalue:'',inputtype:"text", twidth:"150" ,height:"",issort:false},
		{fieldcnname:"地址",fieldname:"address",fieldvalue:'',inputtype:"text", twidth:"130" ,height:""},
		//{fieldcnname:"创建时间",fieldname:"create_time",fieldvalue:'',inputtype:"date", twidth:"130" ,height:"",hide:true},
		{fieldcnname:"手机",fieldname:"mobile",fieldvalue:'',inputtype:"text", twidth:"100" ,height:"",issort:false},
		{fieldcnname:"优惠券类型",fieldname:"ticket_type",defaultValue:'1',inputtype:"select", noList:[{"value_no":1,"value_name":"时长减免"},{"value_no":2,"value_name":"金额减免"}],twidth:"130" ,height:"",issort:false},
		{fieldcnname:"默认显示额度",fieldname:"default_limit",fieldvalue:'',defaultValue:'5,10,20,30', inputtype:"text",twidth:"130" ,height:""},
		{fieldcnname:"商户折扣/%",fieldname:"discount_percent",fieldvalue:'',defaultValue:"100",inputtype:"number", twidth:"150" ,height:"",issort:false},
		{fieldcnname:"每小时/元",fieldname:"discount_money",fieldvalue:'',defaultValue:"1",inputtype:"number", twidth:"150" ,height:"",issort:false},
		{fieldcnname:"有效期/小时",fieldname:"validite_time",fieldvalue:'',defaultValue:"24",inputtype:"number", twidth:"150" ,height:"",issort:false},
		];
//查看
var _showmediaField = [
		{fieldcnname:"编号",fieldname:"id",fieldvalue:'',inputtype:"text", twidth:"100" ,height:"",issort:false,edit:false},
		{fieldcnname:"商户名称",fieldname:"name",fieldvalue:'',inputtype:"text", twidth:"150" ,height:"",issort:false},
		{fieldcnname:"地址",fieldname:"address",fieldvalue:'',inputtype:"text", twidth:"130" ,height:""},
		{fieldcnname:"创建时间",fieldname:"create_time",fieldvalue:'',inputtype:"date", twidth:"130" ,height:"",hide:true},
		{fieldcnname:"手机",fieldname:"mobile",fieldvalue:'',inputtype:"text", twidth:"100" ,height:"",issort:false},
		{fieldcnname:"优惠券额度(小时)",fieldname:"ticket_limit",fieldvalue:'',inputtype:"text",twidth:"200" ,height:"",hide:true},
		//{fieldcnname:"全免券额度(张)",fieldname:"ticketfree_limit",fieldvalue:'',inputtype:"text",twidth:"200" ,height:"",issort:false},
		{fieldcnname:"优惠券额度(元)",fieldname:"ticket_money",fieldvalue:'',inputtype:"text",twidth:"200" ,height:"",issort:false},
		{fieldcnname:"优惠券类型",fieldname:"ticket_type",fieldvalue:'',inputtype:"select", noList:[{"value_no":1,"value_name":"时长减免"},{"value_no":2,"value_name":"金额减免"}],twidth:"130" ,height:"",issort:false},
		{fieldcnname:"默认显示额度",fieldname:"default_limit",fieldvalue:'',inputtype:"text",twidth:"200" ,height:"",issort:false,hide:true},
		{fieldcnname:"商户折扣/%",fieldname:"discount_percent",fieldvalue:'',inputtype:"number", twidth:"150" ,height:"",issort:false,fhide:true},
		{fieldcnname:"每小时/元",fieldname:"discount_money",fieldvalue:'',inputtype:"number", twidth:"150" ,height:"",issort:false,fhide:true},
		{fieldcnname:"有效期/小时",fieldname:"validite_time",fieldvalue:'',defaultValue:"24",inputtype:"number", twidth:"150" ,height:"",issort:false},
	];
var _shopT = new TQTable({
	tabletitle:"商户查询",
	ischeck:false,
	tablename:"shop_tables",
	dataUrl:"shop.do",
	iscookcol:false,
	//dbuttons:false,
	buttons:getAuthButtons(),
	//searchitem:true,
	param:"action=quickquery",
	tableObj:T("#shopobj"),
	fit:[true,true,true],
	tableitems:_showmediaField,
	isoperate:getAuthIsoperateButtons()
});

function getAuthButtons(){
	var bts = [];
	if(subauth[1]){
		bts.push({dname:"添加商户",icon:"edit_add.png",onpress:function(Obj){
		T.each(_shopT.tc.tableitems,function(o,j){
			o.fieldvalue ="";
		});
		Twin({Id:"shoppingmarket_add",Title:"添加商户",Width:550,sysfun:function(tObj){
				Tform({
					formname: "shoppingmarket_edit_f",
					formObj:tObj,
					recordid:"id",
					suburl:"shop.do?action=create",
					method:"POST",
					formAttr:[{
						formitems:[{kindname:"",kinditemts:_addmediaField}]
					}],
					buttons : [//工具
						{name: "cancel", dname: "取消", tit:"取消添加",icon:"cancel.gif", onpress:function(){TwinC("shoppingmarket_add");} }
					],
					Callback:
					function(f,rcd,ret,o){
						if(ret=="1"){
							T.loadTip(1,"添加成功！",2,"");
							TwinC("shoppingmarket_add");
							_shopT.M();
						}else{
							T.loadTip(1,ret,2,o);
						}
					}
				});	
			}
		})
	
	}});
	}
	return bts;
}
function getAuthIsoperateButtons(){
	var bts = [];
	if(subauth[2])
	bts.push({name:"编辑",fun:function(id){
		T.each(_shopT.tc.tableitems,function(o,j){
			o.fieldvalue = _shopT.GD(id)[j]
		});
		//编号
		var shop_id = _shopT.GD(id,"id");
		//商户名称
		var shop_name = _shopT.GD(id,"name");
		//地址
		var address = _shopT.GD(id,"address");
		//创建时间
		var create_time = _shopT.GD(id,"create_time");
		//手机
		var mobile = _shopT.GD(id,"mobile");
		//优惠券类型
		var ticket_type = _shopT.GD(id,"ticket_type");
		//默认显示额度
		var default_limit = _shopT.GD(id,"default_limit");
		//商户折扣金额-百分比
		var discount_percent = _shopT.GD(id,"discount_percent");
		//商户折扣小时-每小时元
		var discount_money = _shopT.GD(id,"discount_money");
		//有效期/小时
		var validite_time = _shopT.GD(id,"validite_time");
		Twin({Id:"shop_edit_"+id,Title:"编辑",Width:550,sysfunI:id,sysfun:function(id,tObj){
				Tform({
					formname: "shop_edit_f",
					formObj:tObj,
					recordid:"shop_id",
					suburl:"shop.do?action=edit&id="+id,
					method:"POST",
					formAttr:[{
						formitems:[{kindname:"",kinditemts:
							[
								{fieldcnname:"编号",fieldname:"id",fieldvalue:shop_id,inputtype:"text", twidth:"100" ,height:"",issort:false,edit:false},
								{fieldcnname:"商户名称",fieldname:"name",fieldvalue:shop_name,inputtype:"text", twidth:"150" ,height:"",issort:false},
								{fieldcnname:"地址",fieldname:"address",fieldvalue:address,inputtype:"text", twidth:"130" ,height:""},
								//{fieldcnname:"创建时间",fieldname:"create_time",fieldvalue:create_time,inputtype:"date", twidth:"130" ,height:"",hide:true},
								{fieldcnname:"手机",fieldname:"mobile",fieldvalue:mobile,inputtype:"text", twidth:"100" ,height:"",issort:false},
								{fieldcnname:"优惠券类型",fieldname:"ticket_type",fieldvalue:ticket_type,inputtype:"select", noList:[{"value_no":1,"value_name":"时长减免"},{"value_no":2,"value_name":"金额减免"}],twidth:"130" ,height:"",issort:false},
								{fieldcnname:"默认显示额度",fieldname:"default_limit",fieldvalue:default_limit,inputtype:"text",twidth:"130" ,height:""},
								{fieldcnname:"商户折扣/%",fieldname:"discount_percent",fieldvalue:discount_percent,inputtype:"number", twidth:"150" ,height:"",issort:false},
								{fieldcnname:"每小时/元",fieldname:"discount_money",fieldvalue:discount_money,inputtype:"number", twidth:"150" ,height:"",issort:false},
								{fieldcnname:"有效期/小时",fieldname:"validite_time",fieldvalue:validite_time,inputtype:"number", twidth:"150" ,height:"",issort:false},
							]	
						}]
					}],
					buttons : [//工具
						{name: "cancel", dname: "取消", tit:"取消编辑",icon:"cancel.gif", onpress:function(){TwinC("shop_edit_"+id);} }
					],
					Callback:
					function(f,rcd,ret,o){
						if(ret=="1"){
							T.loadTip(1,"编辑成功！",2,"");
							TwinC("shop_edit_"+id);
							_shopT.M()
						}else{
							T.loadTip(1,ret,2,o)
						}
					}
				});	
			}
		})
	}});
	if(subauth[4])
	bts.push({name:"设置",fun:function(id){
		Twin({
			Id:"shop_detail_"+id,
			Title:"商户设置  &nbsp;&nbsp;&nbsp;&nbsp;<font color='red'> 提示：双击关闭此对话框</font>",
			Content:"<iframe src=\"shop.do?action=setting&id="+id+"\" style=\"width:100%;height:100%\" frameborder=\"0\"></iframe>",
			Width:T.gww()-100,
			Height:T.gwh()-50
		})
	}});
	if(subauth[5])
		bts.push({name:"续费",fun:function(id){
			//编号
			var shop_id = _shopT.GD(id,"id");
			//优惠券类型
			var ticket_type = _shopT.GD(id,"ticket_type");
			var obj = eval('('+T.A.sendData("shop.do?action=getShop&shop_id="+shop_id)+')');
			//商户折扣--百分比
			var discount_percent = typeof(obj.discount_percent) == "undefined" ? "100" : obj.discount_percent;
			//商户折扣--每小时/元
			var discount_money = typeof(obj.discount_money) == "undefined"? "1.00" : obj.discount_money;
			T.each(_shopT.tc.tableitems,function(o,j){
				o.fieldvalue = _shopT.GD(id)[j];
			});
			var title="减免券购买(时长)";
			if(ticket_type == 2){
				title="减免券购买(金额)";
			}
			if(ticket_type==1){
				Twin({
					Id:"shop_addmoney_"+id,
					Title:title+"&nbsp;&nbsp;&nbsp;&nbsp;<font color='red'> 提示：双击关闭此对话框</font>",
					Content:"<form>"
								+"<table cellpadding=\"10\">"
					   				+"<tr align=\"left\">"
					   					+"<th><span style=\"margin-left: 130px\">减免小时(时):&nbsp&nbsp&nbsp</span><input type=\"text\" id=\"ticket_time\" name=\"ticket_time\" onblur=\"toAddmoney(this.value,"+shop_id+")\" width=\"130\" />"
					   					+"<span>(每小时"+discount_money+"元)</span></br></th>"
					   				+"</tr>"
					   				+"<tr align=\"left\">"
					   					+"<th><span style=\"margin-left: 130px\">应收金额(元):&nbsp&nbsp&nbsp</span><input type=\"text\" id=\"should_pay\" name=\"should_pay\" disabled=\"true\" width=\"130\"/></br></th>"
					   				+"</tr>"
					   				+"<tr align=\"left\">"
					   					+"<th><span style=\"margin-left: 130px\">当前折扣(%):&nbsp&nbsp&nbsp</span><input type=\"text\" width=\"130\" value=\""+discount_percent+"\" disabled=\"true\"/></br></th>"
					   				+"</tr>"
					   				//+"<tr>"
					   				//	+"<th><span style=\"margin-left: 130px\">当前折扣(元/时):&nbsp&nbsp&nbsp</span><input type=\"text\" width=\"130\" value=\""+discount_money+"\" disabled=\"true\"/></br></th>"
					   				//+"</tr>"
					   				+"<tr align=\"left\">"
					   					+"<th><span style=\"margin-left: 130px\">实收金额(元):&nbsp&nbsp&nbsp</span><input type=\"text\" id=\"addmoney\" name=\"addmoney\" width=\"130\" disabled=\"true\"/></th>"
					   				+"</tr>"
					   			+"</table>"
						   		+"<input type=\"button\" onclick=\"renewal("+shop_id+")\" style=\"margin-left: 350px;margin-top:25px;width:60px\" value=\"确  定\">"	
							+"</form>",
					Width:550,height:200
				})
			}else{
				Twin({
					Id:"shop_addmoney_"+id,
					Title:title+"&nbsp;&nbsp;&nbsp;&nbsp;<font color='red'> 提示：双击关闭此对话框</font>",
					Content:"<form>"
								+"<table cellpadding=\"10\">"
					   				+"<tr>"
					   					+"<th><span style=\"margin-left: 130px\">减免券(元):&nbsp&nbsp&nbsp&nbsp&nbsp</spn><input type=\"text\" id=\"ticket_money\" onblur=\"toAddmoney(this.value,"+shop_id+")\" name=\"ticket_money\" width=\"130\" /></br></th>"
					   				+"</tr>"
					   				+"<tr>"
					   					+"<th><span style=\"margin-left: 130px\">应收金额(元):&nbsp&nbsp&nbsp</span><input type=\"text\" id=\"should_pay\" name=\"should_pay\" width=\"130\" disabled=\"true\"/></br></th>"
					   				+"</tr>"
					   				+"<tr>"
					   					+"<th><span style=\"margin-left: 130px\">当前折扣(%):&nbsp&nbsp&nbsp</span><input type=\"text\" width=\"130\" value=\""+discount_percent+"\" disabled=\"true\"/></br></th>"
					   				+"</tr>"
					   				+"<tr>"
					   					+"<th><span style=\"margin-left: 130px\">实收金额(元):&nbsp&nbsp&nbsp</span><input type=\"text\" id=\"addmoney\" name=\"addmoney\" width=\"130\" disabled=\"true\"/></th>"
					   				+"</tr>"
					   			+"</table>"
						   		+"<input type=\"button\" onclick=\"renewal("+shop_id+")\" style=\"margin-left: 350px;margin-top:25px;width:60px\" value=\"确  定\">"	
							+"</form>",
					Width:550,height:200
				})
			}
	}});
	if(subauth[3])
	bts.push({name:"删除",fun:function(id){
		var id_this = id ;
		Tconfirm({Title:"确认删除吗",Content:"确认删除吗",OKFn:function(){T.A.sendData("shop.do?action=delete","post","selids="+id_this,
			function deletebackfun(ret){
				if(ret=="1"){
					T.loadTip(1,"删除成功！",2,"");
					_shopT.M()
				}else{
					T.loadTip(1,ret,2,"");
				}
			}
		)}})
	}});
	if(bts.length <= 0){return false;}
	return bts;
}
_shopT.C();
function toAddmoney(money,shop_id){
	var obj = eval('('+T.A.sendData("shop.do?action=getShop&shop_id="+shop_id)+')');
	var discount_money = typeof(obj.discount_money) == "undefined" ? 1.00 : obj.discount_money;
	var discount_percent = typeof(obj.discount_percent) == "undefined" ? 100 : obj.discount_percent;
	if(obj.ticket_type == "1"){
		
		var should_pay = money*discount_money;
		$("#should_pay").val(should_pay.toFixed(2));
		var addmoney = should_pay*discount_percent/100;
		$("#addmoney").val(addmoney.toFixed(2));
	}else if(obj.ticket_type == "2"){
		$("#should_pay").val(money);
		$("#addmoney").val((money*discount_percent/100).toFixed(2));
	}	
}
function renewal(shop_id){
		T.A.sendData("shop.do?action=addmoney","post","shop_id="+shop_id+"&ticket_time="+$("#ticket_time").val()
				+"&ticket_money="+$("#ticket_money").val()+"&addmoney="+$("#addmoney").val(),
				function deletebackfun(ret){
					if(ret=="1"){
						T.loadTip(1,"续费成功！",2,"");
						TwinC("shop_addmoney_"+shop_id);
						_shopT.M()
					}else{
						T.loadTip(1,ret,2,"");
					}
				}
		)
	}
</script>

</body>
</html>
