<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="common.jsp" %>
<%@ include file="dbconn.jsp" %>
<%
	// 인기 맛집 4곳: 평균 별점 높은 순 (리뷰가 없는 맛집은 0점)
	String sql = "SELECT r.restaurant_id, r.name, r.category, r.region, r.image, "
			+ "       IFNULL(AVG(v.rating), 0) AS avg_rating, COUNT(v.review_id) AS review_count "
			+ "FROM restaurants r "
			+ "LEFT JOIN reviews v ON v.restaurant_id = r.restaurant_id "
			+ "GROUP BY r.restaurant_id "
			+ "ORDER BY avg_rating DESC, review_count DESC "
			+ "LIMIT 4";
	PreparedStatement pstmt = conn.prepareStatement(sql);
	ResultSet rs = pstmt.executeQuery();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>맛집로그</title>
<link rel="stylesheet" href="style.css">
</head>
<body>

	<%@ include file="header.jsp" %>

	<!-- 메인 배너 + 검색창 -->
	<section class="banner">
		<h1>오늘 뭐 먹지?</h1>
		<p>직접 다녀온 사람들의 솔직한 맛집 리뷰</p>
		<form class="search" action="list.jsp" method="get">
			<input type="text" name="keyword" placeholder="맛집 이름이나 지역을 검색해 보세요">
			<button type="submit">검색</button>
		</form>
	</section>

	<!-- 인기 맛집 -->
	<main class="container">
		<div class="section-head">
			<h2>인기 맛집</h2>
			<a href="list.jsp" class="more">전체 보기 →</a>
		</div>

		<div class="card-list">
<%
	int count = 0;
	while (rs.next()) {
		count++;
%>
			<a href="detail.jsp?id=<%= rs.getInt("restaurant_id") %>" class="card">
				<div class="thumb"><%= thumb(rs.getString("image"), rs.getString("category")) %></div>
				<div class="info">
					<h3><%= esc(rs.getString("name")) %></h3>
					<p class="desc"><%= esc(rs.getString("category")) %> · <%= esc(rs.getString("region")) %></p>
					<p class="star">★ <%= avgText(rs.getDouble("avg_rating")) %> <span>(리뷰 <%= rs.getInt("review_count") %>)</span></p>
				</div>
			</a>
<%
	}
%>
		</div>

<% if (count == 0) { %>
		<p class="empty">아직 등록된 맛집이 없어요. 첫 번째 맛집을 <a href="restaurant_form.jsp">등록</a>해 보세요!</p>
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
