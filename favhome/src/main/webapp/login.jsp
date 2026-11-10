<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="common.jsp" %>
<%
	// 이미 로그인했으면 메인으로
	if (isLogin) {
		response.sendRedirect("main.jsp");
		return;
	}
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>로그인 - 맛집로그</title>
<link rel="stylesheet" href="style.css">
</head>
<body>

	<%@ include file="header.jsp" %>

	<main class="container">
		<div class="auth-box">
			<h2>로그인</h2>

			<form action="login_process.jsp" method="post">
				<div class="form-group">
					<label for="loginId">아이디</label>
					<input type="text" id="loginId" name="loginId" placeholder="아이디를 입력하세요" required>
				</div>
				<div class="form-group">
					<label for="password">비밀번호</label>
					<input type="password" id="password" name="password" placeholder="비밀번호를 입력하세요" required>
				</div>

				<button type="submit" class="btn btn-full">로그인</button>
			</form>

			<p class="auth-link">아직 회원이 아니신가요? <a href="join.jsp">회원가입</a></p>
		</div>
	</main>

	<%@ include file="footer.jsp" %>

</body>
</html>
