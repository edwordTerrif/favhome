<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 세션을 지우면 로그아웃
	session.invalidate();
	response.sendRedirect("main.jsp");
%>
