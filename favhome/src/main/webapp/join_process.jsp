<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="common.jsp" %>
<%@ include file="dbconn.jsp" %>
<%
	// 회원가입 처리 (항상 일반 회원 USER로 가입됨. 관리자는 DB에서 직접 지정)
	String newLoginId = trim(request.getParameter("loginId"));
	String password = request.getParameter("password");
	String passwordCheck = request.getParameter("passwordCheck");
	String nickname = trim(request.getParameter("nickname"));

	// 1. 입력값 검사
	String error = null;
	if (!newLoginId.matches("[A-Za-z0-9]{4,20}")) {
		error = "아이디는 영문, 숫자 4~20자로 입력해 주세요.";
	} else if (password == null || password.length() < 4) {
		error = "비밀번호는 4자 이상 입력해 주세요.";
	} else if (!password.equals(passwordCheck)) {
		error = "비밀번호 확인이 일치하지 않습니다.";
	} else if (nickname.isEmpty() || nickname.length() > 20) {
		error = "닉네임은 1~20자로 입력해 주세요.";
	}

	PreparedStatement pstmt = null;
	ResultSet rs = null;

	// 2. 아이디 중복 확인
	if (error == null) {
		pstmt = conn.prepareStatement("SELECT COUNT(*) FROM members WHERE login_id = ?");
		pstmt.setString(1, newLoginId);
		rs = pstmt.executeQuery();
		rs.next();
		if (rs.getInt(1) > 0) {
			error = "이미 사용 중인 아이디입니다.";
		}
		rs.close();
		pstmt.close();
	}

	// 3. 닉네임 중복 확인
	if (error == null) {
		pstmt = conn.prepareStatement("SELECT COUNT(*) FROM members WHERE nickname = ?");
		pstmt.setString(1, nickname);
		rs = pstmt.executeQuery();
		rs.next();
		if (rs.getInt(1) > 0) {
			error = "이미 사용 중인 닉네임입니다.";
		}
		rs.close();
		pstmt.close();
	}

	// 4. 가입 (role은 넣지 않아서 기본값 USER)
	if (error == null) {
		pstmt = conn.prepareStatement("INSERT INTO members (login_id, password, nickname) VALUES (?, ?, ?)");
		pstmt.setString(1, newLoginId);
		pstmt.setString(2, password);
		pstmt.setString(3, nickname);
		pstmt.executeUpdate();
		pstmt.close();
	}

	conn.close();

	if (error == null) {
		alertGo(out, "가입이 완료되었습니다. 로그인해 주세요.", "login.jsp");
	} else {
		alertBack(out, error);
	}
%>
