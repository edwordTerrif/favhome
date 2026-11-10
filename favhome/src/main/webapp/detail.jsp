<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="common.jsp" %>
<%@ include file="dbconn.jsp" %>
<%
	int restaurantId = toInt(request.getParameter("id"), 0);
	String reviewSort = "star".equals(request.getParameter("sort")) ? "star" : "new";
	int pageNum = toInt(request.getParameter("page"), 1);
	int pageSize = 5;   // 리뷰 5개씩

	// ===== 1. 맛집 정보 + 등록한 회원 + 평균 별점 =====
	String sql = "SELECT r.*, m.nickname AS writer, "
			+ "       IFNULL(AVG(v.rating), 0) AS avg_rating, COUNT(v.review_id) AS review_count "
			+ "FROM restaurants r "
			+ "JOIN members m ON m.member_id = r.member_id "
			+ "LEFT JOIN reviews v ON v.restaurant_id = r.restaurant_id "
			+ "WHERE r.restaurant_id = ? "
			+ "GROUP BY r.restaurant_id, m.nickname";
	PreparedStatement pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, restaurantId);
	ResultSet rs = pstmt.executeQuery();

	if (!rs.next()) {
		rs.close();
		pstmt.close();
		conn.close();
		alertGo(out, "존재하지 않는 맛집입니다.", "list.jsp");
		return;
	}

	String name = rs.getString("name");
	String category = rs.getString("category");
	String region = rs.getString("region");
	String address = rs.getString("address");
	String phone = rs.getString("phone");
	String description = rs.getString("description");
	String image = rs.getString("image");
	Timestamp createdAt = rs.getTimestamp("created_at");
	int writerId = rs.getInt("member_id");
	String writer = rs.getString("writer");
	double avgRating = rs.getDouble("avg_rating");
	int reviewCount = rs.getInt("review_count");
	rs.close();
	pstmt.close();

	// 맛집 수정/삭제: 등록한 본인 또는 관리자
	boolean canEditRestaurant = isAdmin || (isLogin && loginId == writerId);

	// ===== 2. 리뷰 목록 (작성자 닉네임 포함) =====
	int totalPage = (reviewCount + pageSize - 1) / pageSize;
	if (totalPage < 1) totalPage = 1;
	if (pageNum < 1) pageNum = 1;
	if (pageNum > totalPage) pageNum = totalPage;

	String orderBy = reviewSort.equals("star")
			? " ORDER BY v.rating DESC, v.created_at DESC, v.review_id DESC "
			: " ORDER BY v.created_at DESC, v.review_id DESC ";
	sql = "SELECT v.review_id, v.member_id, v.rating, v.content, v.created_at, m.nickname "
			+ "FROM reviews v "
			+ "JOIN members m ON m.member_id = v.member_id "
			+ "WHERE v.restaurant_id = ? "
			+ orderBy
			+ "LIMIT ? OFFSET ?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, restaurantId);
	pstmt.setInt(2, pageSize);
	pstmt.setInt(3, (pageNum - 1) * pageSize);
	rs = pstmt.executeQuery();

	String baseUrl = "detail.jsp?id=" + restaurantId;
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><%= esc(name) %> - 맛집로그</title>
<link rel="stylesheet" href="style.css">
</head>
<body>

	<%@ include file="header.jsp" %>

	<main class="container">

		<!-- 맛집 정보 -->
		<section class="detail-top">
			<div class="detail-thumb"><%= thumb(image, category) %></div>
			<div class="detail-info">
				<span class="tag"><%= esc(category) %> · <%= esc(region) %></span>
				<h1><%= esc(name) %></h1>
				<p class="detail-star">★ <%= avgText(avgRating) %> <span>(리뷰 <%= reviewCount %>)</span></p>
				<ul class="detail-meta">
<% if (address != null && !address.isEmpty()) { %>
					<li><b>주소</b><%= esc(address) %></li>
<% } %>
<% if (phone != null && !phone.isEmpty()) { %>
					<li><b>전화</b><%= esc(phone) %></li>
<% } %>
					<li><b>등록</b><%= esc(writer) %> · <%= dateText(createdAt) %></li>
				</ul>

				<!-- 등록한 회원이 쓴 소개글 (줄바꿈 그대로 표시) -->
				<p class="detail-desc"><%= esc(description) %></p>

<% if (canEditRestaurant) { %>
				<div class="detail-actions">
					<a href="restaurant_form.jsp?id=<%= restaurantId %>" class="btn btn-small btn-gray">수정</a>
					<form action="restaurant_delete.jsp" method="post" class="inline-form" onsubmit="return confirm('맛집과 리뷰가 모두 삭제됩니다. 삭제할까요?');">
						<input type="hidden" name="restaurantId" value="<%= restaurantId %>">
						<button type="submit" class="btn btn-small btn-line">삭제</button>
					</form>
				</div>
<% } %>
			</div>
		</section>

		<!-- 리뷰 -->
		<section class="review-section">
			<div class="section-head">
				<h2>리뷰 <span class="count"><%= reviewCount %></span></h2>
				<div class="sort">
					<a href="<%= baseUrl %>&amp;sort=new" class="<%= reviewSort.equals("new") ? "active" : "" %>">최신순</a>
					<a href="<%= baseUrl %>&amp;sort=star" class="<%= reviewSort.equals("star") ? "active" : "" %>">별점순</a>
				</div>
			</div>

<% if (!isLogin) { %>
			<p class="notice">리뷰를 작성하려면 <a href="login.jsp">로그인</a>이 필요합니다.</p>
<% } else if (!isAdmin) { %>
			<!-- 리뷰 작성 (일반 회원만) -->
			<form class="review-form" action="review_save.jsp" method="post">
				<input type="hidden" name="restaurantId" value="<%= restaurantId %>">
				<div class="review-form-row">
					<label for="rating">별점</label>
					<select id="rating" name="rating">
						<option value="5">★★★★★ 5점</option>
						<option value="4">★★★★☆ 4점</option>
						<option value="3">★★★☆☆ 3점</option>
						<option value="2">★★☆☆☆ 2점</option>
						<option value="1">★☆☆☆☆ 1점</option>
					</select>
				</div>
				<textarea name="content" placeholder="방문 후기를 남겨주세요" maxlength="1000" required></textarea>
				<div class="form-actions-right">
					<button type="submit" class="btn">리뷰 등록</button>
				</div>
			</form>
<% } %>

<% if (reviewCount == 0) { %>
			<p class="empty">아직 리뷰가 없어요. 첫 리뷰를 남겨주세요!</p>
<% } else { %>
			<ul class="review-list">
<%
		while (rs.next()) {
			int reviewId = rs.getInt("review_id");
			boolean isMine = isLogin && loginId == rs.getInt("member_id");
%>
				<li class="review-item">
					<div class="review-head">
						<p class="review-writer"><%= esc(rs.getString("nickname")) %><% if (isMine) { %> <span class="mine">내 리뷰</span><% } %><span class="review-date"><%= dateText(rs.getTimestamp("created_at")) %></span></p>
						<p class="review-stars"><%= stars(rs.getInt("rating")) %></p>
					</div>
					<p class="review-content"><%= esc(rs.getString("content")) %></p>
<%			if (isMine || isAdmin) { %>
					<div class="review-btns">
<%				if (isMine) { %>
						<a href="review_edit.jsp?id=<%= reviewId %>" class="btn btn-small btn-gray">수정</a>
<%				} %>
						<form action="review_delete.jsp" method="post" class="inline-form" onsubmit="return confirm('리뷰를 삭제할까요?');">
							<input type="hidden" name="reviewId" value="<%= reviewId %>">
							<input type="hidden" name="restaurantId" value="<%= restaurantId %>">
							<button type="submit" class="btn btn-small btn-line">삭제</button>
						</form>
					</div>
<%			} %>
				</li>
<%		} %>
			</ul>

			<!-- 리뷰 페이징 -->
<%		if (totalPage > 1) { %>
			<div class="pagination">
<%			for (int p = 1; p <= totalPage; p++) { %>
				<a href="<%= baseUrl %>&amp;sort=<%= reviewSort %>&amp;page=<%= p %>" class="<%= p == pageNum ? "active" : "" %>"><%= p %></a>
<%			} %>
			</div>
<%		} %>
<% } %>
		</section>
	</main>

	<%@ include file="footer.jsp" %>

</body>
</html>
<%
	rs.close();
	pstmt.close();
	conn.close();
%>
