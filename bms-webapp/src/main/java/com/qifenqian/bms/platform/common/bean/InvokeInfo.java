package com.qifenqian.bms.platform.common.bean;

import java.io.Serializable;

/**
 * 类与类之间的调用信息
 * 
 * @project gyzb-platform-common
 * @fileName InvokeInfo.java
 * @author huiquan.ma
 * @date 2015年11月24日
 * @memo
 */
public class InvokeInfo implements Serializable {

	private static final long serialVersionUID = 1L;

	/**
	 * 调用类的全限定名
	 */
	private String className;
	
	/**
	 * 调用类的文件名
	 */
	private String fileName;
	
	/**
	 * 调用点的代码行号
	 */
	private int lineNumber;
	
	/**
	 * 调用点的方法名
	 */
	private String methodName;

	public String getClassName() {
		return className;
	}

	public void setClassName(String className) {
		this.className = className;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public int getLineNumber() {
		return lineNumber;
	}

	public void setLineNumber(int lineNumber) {
		this.lineNumber = lineNumber;
	}

	public String getMethodName() {
		return methodName;
	}

	public void setMethodName(String methodName) {
		this.methodName = methodName;
	}

}
