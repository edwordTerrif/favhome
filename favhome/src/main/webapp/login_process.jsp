<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="common.jsp" %>
<%@ include file="dbconn.jsp" %>
<%
	// 로그인 처리: 아이디와 비밀번호가 맞으면 세션에 회원 정보를 저장
	String loginIdParam = trim(request.getParameter("loginId"));
	String password = request.getParameter("password");

	String sql = "SELECT member_id, nickname, role FROM members WHERE login_id = ? AND password = ?";
	PreparedStatement pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, loginIdParam);
	pstmt.setString(2, password);
	ResultSet rs = pstmt.executeQuery();

	boolean success = false;
	if (rs.next()) {
		session.setAttribute("memberId", rs.getInt("member_id"));
		session.setAttribute("nickname", rs.getString("nickname"));
		session.setAttribute("role", rs.getString("role"));
		success = true;
	}

	rs.close();
	pstmt.close();
	conn.close();

	if (success) {
		response.sendRedirect("main.jsp");
	} else {
		alertBack(out, "아이디 또는 비밀번호가 맞지 않습니다.");
	}
%>
