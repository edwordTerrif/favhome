<%@ page pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
	// DB 연결 (DB를 쓰는 페이지 맨 위에서 include)
	// 페이지 마지막에 conn.close()로 꼭 닫아준다
	Connection conn = null;
	String driverName = "com.mysql.cj.jdbc.Driver";
	String url = "jdbc:mysql://localhost:3306/favhome";
	Class.forName(driverName);
	conn = DriverManager.getConnection(url, "root", "123456");
%>
