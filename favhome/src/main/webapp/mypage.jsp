<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="common.jsp" %>
<%!
	// 회원 번호 하나로 개수를 세는 SQL 실행 (탭에 표시할 숫자)
	int countOf(Connection conn, String sql, int memberId) throws SQLException {
		PreparedStatement p = conn.prepareStatement(sql);
		p.setInt(1, memberId);
		ResultSet r = p.executeQuery();
		r.next();
		int count = r.getInt(1);
		r.close();
		p.close();
		return count;
	}
%>
<%
	/*
		마이페이지 (일반 회원만)
		- tab=fav    : 찜한 맛집 (기본)
		- tab=mine   : 내가 등록한 맛집
		- tab=review : 내가 쓴 리뷰
	*/
	if (!isLogin) {
		alertGo(out, "로그인이 필요합니다.", "login.jsp");
		return;
	}
	if (isAdmin) {
		response.sendRedirect("admin_list.jsp");
		return;
	}

	String tab = request.getParameter("tab");
	if (!"mine".equals(tab) && !"review".equals(tab)) {
		tab = "fav";
	}
%>
<%@ include file="dbconn.jsp" %>
<%
	// ===== 1. 내 정보 =====
	PreparedStatement pstmt = conn.prepareStatement("SELECT login_id, nickname, created_at FROM members WHERE member_id = ?");
	pstmt.setInt(1, loginId);
	ResultSet rs = pstmt.executeQuery();
	rs.next();
	String myLoginId = rs.getString("login_id");
	String myNickname = rs.getString("nickname");
	Timestamp joinedAt = rs.getTimestamp("created_at");
	rs.close();
	pstmt.close();

	// ===== 2. 탭에 표시할 개수 =====
	int favCount = countOf(conn, "SELECT COUNT(*) FROM favorites WHERE member_id = ?", loginId);
	int mineCount = countOf(conn, "SELECT COUNT(*) FROM restaurants WHERE member_id = ?", loginId);
	int reviewCount = countOf(conn, "SELECT COUNT(*) FROM reviews WHERE member_id = ?", loginId);

	// ===== 3. 선택한 탭의 목록 =====
	String sql;
	if (tab.equals("review")) {
		// 내가 쓴 리뷰 (어느 맛집에 썼는지 포함)
		sql = "SELECT v.review_id, v.restaurant_id, v.rating, v.content, v.created_at, r.name AS restaurant_name "
				+ "FROM reviews v "
				+ "JOIN restaurants r ON r.restaurant_id = v.restaurant_id "
				+ "WHERE v.member_id = ? "
				+ "ORDER BY v.created_at DESC, v.review_id DESC";
	} else {
		// 맛집 카드: 대표 사진, 평균 별점, 리뷰 수는 서브쿼리로 계산
		String cardColumns = "SELECT r.restaurant_id, r.name, r.category, r.region, "
				+ "  (SELECT i.file_name FROM restaurant_images i "
				+ "    WHERE i.restaurant_id = r.restaurant_id ORDER BY i.image_id LIMIT 1) AS image, "
				+ "  (SELECT IFNULL(AVG(v.rating), 0) FROM reviews v WHERE v.restaurant_id = r.restaurant_id) AS avg_rating, "
				+ "  (SELECT COUNT(*) FROM reviews v WHERE v.restaurant_id = r.restaurant_id) AS review_count ";
		if (tab.equals("fav")) {
			// 찜한 맛집 (최근에 찜한 순)
			sql = cardColumns
					+ "FROM favorites f "
					+ "JOIN restaurants r ON r.restaurant_id = f.restaurant_id "
					+ "WHERE f.member_id = ? "
					+ "ORDER BY f.created_at DESC, r.restaurant_id DESC";
		} else {
			// 내가 등록한 맛집 (최근 등록 순)
			sql = cardColumns
					+ "FROM restaurants r "
					+ "WHERE r.member_id = ? "
					+ "ORDER BY r.created_at DESC, r.restaurant_id DESC";
		}
	}
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, loginId);
	rs = pstmt.executeQuery();

	int shownCount = tab.equals("fav") ? favCount : tab.equals("mine") ? mineCount : reviewCount;
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>마이페이지 - 맛집로그</title>
<link rel="stylesheet" href="style.css">
</head>
<body>

	<%@ include file="header.jsp" %>

	<main class="container">

		<!-- 내 정보 -->
		<section class="profile">
			<div class="avatar"><%= esc(myNickname.substring(0, 1)) %></div>
			<div>
				<h2><%= esc(myNickname) %>님</h2>
				<p class="profile-meta">아이디 <%= esc(myLoginId) %> · 가입일 <%= dateText(joinedAt) %></p>
			</div>
		</section>

		<!-- 탭 -->
		<div class="tabs my-tabs">
			<a href="mypage.jsp?tab=fav" class="<%= tab.equals("fav") ? "active" : "" %>">찜한 맛집 <%= favCount %></a>
			<a href="mypage.jsp?tab=mine" class="<%= tab.equals("mine") ? "active" : "" %>">내가 등록한 맛집 <%= mineCount %></a>
			<a href="mypage.jsp?tab=review" class="<%= tab.equals("review") ? "active" : "" %>">내 리뷰 <%= reviewCount %></a>
		</div>

<% if (shownCount == 0) { %>
		<!-- 목록이 비었을 때 -->
<%	if (tab.equals("fav")) { %>
		<p class="empty">아직 찜한 맛집이 없어요. <a href="list.jsp">맛집 목록</a>에서 마음에 드는 곳을 찜해 보세요.</p>
<%	} else if (tab.equals("mine")) { %>
		<p class="empty">아직 등록한 맛집이 없어요. <a href="restaurant_form.jsp">맛집 등록</a>으로 다녀온 곳을 소개해 보세요.</p>
<%	} else { %>
		<p class="empty">아직 쓴 리뷰가 없어요.</p>
<%	} %>

<% } else if (tab.equals("review")) { %>
		<!-- 내 리뷰 목록 -->
		<ul class="review-list">
<%	while (rs.next()) {
		int reviewId = rs.getInt("review_id");
		int restaurantId = rs.getInt("restaurant_id");
%>
			<li class="review-item">
				<div class="review-head">
					<p class="review-writer"><a href="detail.jsp?id=<%= restaurantId %>" class="review-shop"><%= esc(rs.getString("restaurant_name")) %></a><span class="review-date"><%= dateText(rs.getTimestamp("created_at")) %></span></p>
					<p class="review-stars"><%= stars(rs.getInt("rating")) %></p>
				</div>
				<p class="review-content"><%= esc(rs.getString("content")) %></p>
				<div class="review-btns">
					<a href="review_edit.jsp?id=<%= reviewId %>" class="btn btn-small btn-gray">수정</a>
					<form action="review_delete.jsp" method="post" class="inline-form" onsubmit="return confirm('리뷰를 삭제할까요?');">
						<input type="hidden" name="reviewId" value="<%= reviewId %>">
						<input type="hidden" name="restaurantId" value="<%= restaurantId %>">
						<input type="hidden" name="back" value="mypage">
						<button type="submit" class="btn btn-small btn-line">삭제</button>
					</form>
				</div>
			</li>
<%	} %>
		</ul>

<% } else { %>
		<!-- 맛집 카드 (찜한 맛집 / 내가 등록한 맛집) -->
		<div class="card-list">
<%	while (rs.next()) {
		int restaurantId = rs.getInt("restaurant_id");
%>
			<div class="card-wrap">
				<a href="detail.jsp?id=<%= restaurantId %>" class="card">
					<div class="thumb"><%= thumb(rs.getString("image"), rs.getString("category")) %></div>
					<div class="info">
						<h3><%= esc(rs.getString("name")) %></h3>
						<p class="desc"><%= esc(rs.getString("category")) %> · <%= esc(rs.getString("region")) %></p>
						<p class="star">★ <%= avgText(rs.getDouble("avg_rating")) %> <span>(리뷰 <%= rs.getInt("review_count") %>)</span></p>
					</div>
				</a>
				<div class="card-action">
<%		if (tab.equals("fav")) { %>
					<form action="favorite_toggle.jsp" method="post" class="inline-form">
						<input type="hidden" name="restaurantId" value="<%= restaurantId %>">
						<input type="hidden" name="back" value="mypage">
						<button type="submit" class="btn btn-small btn-line">♥ 찜 해제</button>
					</form>
<%		} else { %>
					<a href="restaurant_form.jsp?id=<%= restaurantId %>" class="btn btn-small btn-gray">수정</a>
<%		} %>
				</div>
			</div>
<%	} %>
		</div>
<% } %>
	</main>

	<%@ include file="footer.jsp" %>

</body>
</html>
<%
	rs.close();
	pstmt.close();
	conn.close();
%>
