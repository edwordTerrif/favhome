<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="common.jsp" %>
<%
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
<title>회원가입 - 맛집로그</title>
<link rel="stylesheet" href="style.css">
</head>
<body>

	<%@ include file="header.jsp" %>

	<main class="container">
		<div class="auth-box">
			<h2>회원가입</h2>

			<form action="join_process.jsp" method="post">
				<div class="form-group">
					<label for="loginId">아이디</label>
					<input type="text" id="loginId" name="loginId" placeholder="영문, 숫자 4~20자" maxlength="20" required>
				</div>
				<div class="form-group">
					<label for="password">비밀번호</label>
					<input type="password" id="password" name="password" placeholder="4자 이상" required>
				</div>
				<div class="form-group">
					<label for="passwordCheck">비밀번호 확인</label>
					<input type="password" id="passwordCheck" name="passwordCheck" placeholder="비밀번호를 한 번 더 입력하세요" required>
				</div>
				<div class="form-group">
					<label for="nickname">닉네임</label>
					<input type="text" id="nickname" name="nickname" placeholder="맛집과 리뷰에 표시될 이름" maxlength="20" required>
				</div>

				<button type="submit" class="btn btn-full">가입하기</button>
			</form>

			<p class="auth-link">이미 회원이신가요? <a href="login.jsp">로그인</a></p>
		</div>
	</main>

	<%@ include file="footer.jsp" %>

</body>
</html>
