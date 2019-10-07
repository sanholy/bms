package com.sevenpay.bms.meeting.activity.bean;

import java.io.Serializable;
import java.util.Date;

import com.sevenpay.bms.meeting.activity.type.ActivityPermitType;
import com.sevenpay.bms.meeting.activity.type.ActivityStatus;
import com.sevenpay.bms.meeting.activity.type.ActivityType;

public class ActivityBean implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = -7544074227618115599L;

	/** 活动索引编号 */
	private Integer activityId;
	/** 活动类型 */
	private ActivityType activityType;
	/** 活动编码 */
	private String activityNo;
	/** 活动英文编码 */
	private String activityCode;
	/** 活动中文名称 */
	private String activityName;
	/** 活动地点 */
	private String activityPlace;
	/** 开始日期 */
	private String startDate;
	/** 结束日期 */
	private String endDate;
	/** 许可类型：ALL全部/IP/USER用户/MAC地址... */
	private ActivityPermitType permitType;
	/** 备注多个以分号分割 */
	private String permitValue;
	/** 备注 */
	private String memo;
	/** 状态：INIT初始/STAGE_ING进行中/OVER已结束/DISABLE无效 */
	private ActivityStatus status;
	/** 初始写入人 */
	private int instUser;
	/** 初始时间 */
	private Date instDatetime;
	/** 最后更改人 */
	private int lupdUser;
	/** 最后更改时间 */
	private Date lupdDatetime;
	
	private String instUserName;
	
	private String lupdUserName;
	
	public Integer getActivityId() {
		return activityId;
	}
	public void setActivityId(Integer activityId) {
		this.activityId = activityId;
	}
	public ActivityType getActivityType() {
		return activityType;
	}
	public void setActivityType(ActivityType activityType) {
		this.activityType = activityType;
	}
	public String getActivityNo() {
		return activityNo;
	}
	public void setActivityNo(String activityNo) {
		this.activityNo = activityNo;
	}
	public String getActivityCode() {
		return activityCode;
	}
	public void setActivityCode(String activityCode) {
		this.activityCode = activityCode;
	}
	public String getActivityName() {
		return activityName;
	}
	public void setActivityName(String activityName) {
		this.activityName = activityName;
	}
	public String getActivityPlace() {
		return activityPlace;
	}
	public void setActivityPlace(String activityPlace) {
		this.activityPlace = activityPlace;
	}
	public String getStartDate() {
		return startDate;
	}
	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}
	public String getEndDate() {
		return endDate;
	}
	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}
	public ActivityPermitType getPermitType() {
		return permitType;
	}
	public void setPermitType(ActivityPermitType permitType) {
		this.permitType = permitType;
	}
	public String getPermitValue() {
		return permitValue;
	}
	public void setPermitValue(String permitValue) {
		this.permitValue = permitValue;
	}
	public String getMemo() {
		return memo;
	}
	public void setMemo(String memo) {
		this.memo = memo;
	}
	public ActivityStatus getStatus() {
		return status;
	}
	public void setStatus(ActivityStatus status) {
		this.status = status;
	}
	public int getInstUser() {
		return instUser;
	}
	public void setInstUser(int instUser) {
		this.instUser = instUser;
	}
	public Date getInstDatetime() {
		return instDatetime;
	}
	public void setInstDatetime(Date instDatetime) {
		this.instDatetime = instDatetime;
	}
	public int getLupdUser() {
		return lupdUser;
	}
	public void setLupdUser(int lupdUser) {
		this.lupdUser = lupdUser;
	}
	public Date getLupdDatetime() {
		return lupdDatetime;
	}
	public void setLupdDatetime(Date lupdDatetime) {
		this.lupdDatetime = lupdDatetime;
	}
	public String getInstUserName() {
		return instUserName;
	}
	public void setInstUserName(String instUserName) {
		this.instUserName = instUserName;
	}
	public String getLupdUserName() {
		return lupdUserName;
	}
	public void setLupdUserName(String lupdUserName) {
		this.lupdUserName = lupdUserName;
	}
	
}
