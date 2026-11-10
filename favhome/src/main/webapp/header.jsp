<%@ page pageEncoding="UTF-8"%>
<%
	// 상단 메뉴 (모든 페이지 공통, include로 불러옴)
	// 이 파일만 따로 열어도 오류가 나지 않도록 세션에서 직접 로그인 정보를 읽는다
	// (다른 페이지의 변수와 이름이 겹치지 않게 header로 시작하는 이름 사용)
	String headerNickname = (String) session.getAttribute("nickname");
	boolean headerLogin = (session.getAttribute("memberId") != null);
	boolean headerAdmin = "ADMIN".equals(session.getAttribute("role"));
	if (headerNickname != null) {
		headerNickname = headerNickname.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
	}
%>
<header class="header">
	<a href="main.jsp" class="logo">맛집로그</a>
	<nav class="nav">
		<a href="list.jsp">맛집 목록</a>
<% if (headerAdmin) { %>
		<a href="admin_list.jsp">맛집 관리</a>
<% } else { %>
		<a href="restaurant_form.jsp">맛집 등록</a>
<% } %>
<% if (headerLogin) { %>
		<span class="nav-user"><%= headerNickname %>님</span>
		<a href="logout.jsp">로그아웃</a>
<% } else { %>
		<a href="login.jsp">로그인</a>
		<a href="join.jsp" class="btn-join">회원가입</a>
<% } %>
	</nav>
</header>
