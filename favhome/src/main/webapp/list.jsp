<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="common.jsp" %>
<%@ include file="dbconn.jsp" %>
<%!
	// 검색 조건을 유지한 채로 목록 주소 만들기
	String listUrl(String keyword, String category, String sort, int page) {
		return "list.jsp?keyword=" + enc(keyword) + "&amp;category=" + enc(category)
				+ "&amp;sort=" + sort + "&amp;page=" + page;
	}
%>
<%
	// ===== 1. 파라미터 읽기 =====
	String keyword = trim(request.getParameter("keyword"));      // 검색어
	String category = trim(request.getParameter("category"));    // 카테고리 (빈 값이면 전체)
	String sort = request.getParameter("sort");                  // star / review / new
	if (!"review".equals(sort) && !"new".equals(sort)) {
		sort = "star";
	}
	int pageNum = toInt(request.getParameter("page"), 1);         // 현재 페이지
	int pageSize = 8;                                             // 한 페이지에 8개

	// ===== 2. 검색 조건 (WHERE) 만들기 =====
	String where = " WHERE 1 = 1 ";
	List<String> params = new ArrayList<>();
	if (!keyword.isEmpty()) {
		where += " AND (r.name LIKE ? OR r.region LIKE ?) ";
		params.add("%" + keyword + "%");
		params.add("%" + keyword + "%");
	}
	if (!category.isEmpty()) {
		where += " AND r.category = ? ";
		params.add(category);
	}

	// ===== 3. 정렬 (ORDER BY) =====
	String orderBy;
	if (sort.equals("review")) {
		orderBy = " ORDER BY review_count DESC, avg_rating DESC, r.restaurant_id DESC ";
	} else if (sort.equals("new")) {
		orderBy = " ORDER BY r.created_at DESC, r.restaurant_id DESC ";
	} else {
		orderBy = " ORDER BY avg_rating DESC, review_count DESC, r.restaurant_id DESC ";
	}

	// ===== 4. 전체 개수 → 페이지 수 계산 =====
	PreparedStatement pstmt = conn.prepareStatement("SELECT COUNT(*) FROM restaurants r " + where);
	for (int i = 0; i < params.size(); i++) {
		pstmt.setString(i + 1, params.get(i));
	}
	ResultSet rs = pstmt.executeQuery();
	rs.next();
	int totalCount = rs.getInt(1);
	rs.close();
	pstmt.close();

	int totalPage = (totalCount + pageSize - 1) / pageSize;
	if (totalPage < 1) totalPage = 1;
	if (pageNum < 1) pageNum = 1;
	if (pageNum > totalPage) pageNum = totalPage;

	// ===== 5. 현재 페이지의 맛집 목록 =====
	String sql = "SELECT r.restaurant_id, r.name, r.category, r.region, r.image, r.created_at, "
			+ "       IFNULL(AVG(v.rating), 0) AS avg_rating, COUNT(v.review_id) AS review_count "
			+ "FROM restaurants r "
			+ "LEFT JOIN reviews v ON v.restaurant_id = r.restaurant_id "
			+ where
			+ "GROUP BY r.restaurant_id "
			+ orderBy
			+ "LIMIT ? OFFSET ?";
	pstmt = conn.prepareStatement(sql);
	int index = 1;
	for (String p : params) {
		pstmt.setString(index++, p);
	}
	pstmt.setInt(index++, pageSize);
	pstmt.setInt(index, (pageNum - 1) * pageSize);
	rs = pstmt.executeQuery();

	// 페이지 번호는 5개씩 묶어서 보여줌 (1~5, 6~10 ...)
	int startPage = (pageNum - 1) / 5 * 5 + 1;
	int endPage = Math.min(startPage + 4, totalPage);

	String[] categories = { "한식", "중식", "일식", "양식", "분식", "카페" };
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>맛집 목록 - 맛집로그</title>
<link rel="stylesheet" href="style.css">
</head>
<body>

	<%@ include file="header.jsp" %>

	<main class="container">
		<div class="section-head">
			<h2>맛집 목록</h2>
<% if (!isAdmin) { %>
			<a href="restaurant_form.jsp" class="btn">+ 맛집 등록</a>
<% } %>
		</div>

		<!-- 검색창 (카테고리, 정렬은 그대로 유지) -->
		<form class="list-search" action="list.jsp" method="get">
			<input type="hidden" name="category" value="<%= esc(category) %>">
			<input type="hidden" name="sort" value="<%= sort %>">
			<input type="text" name="keyword" value="<%= esc(keyword) %>" placeholder="맛집 이름이나 지역으로 검색">
			<button type="submit" class="btn">검색</button>
		</form>

		<!-- 카테고리 + 정렬 -->
		<div class="toolbar">
			<div class="tabs">
				<a href="<%= listUrl(keyword, "", sort, 1) %>" class="<%= category.isEmpty() ? "active" : "" %>">전체</a>
<% for (String c : categories) { %>
				<a href="<%= listUrl(keyword, c, sort, 1) %>" class="<%= c.equals(category) ? "active" : "" %>"><%= c %></a>
<% } %>
			</div>
			<div class="sort">
				<a href="<%= listUrl(keyword, category, "star", 1) %>" class="<%= sort.equals("star") ? "active" : "" %>">별점순</a>
				<a href="<%= listUrl(keyword, category, "review", 1) %>" class="<%= sort.equals("review") ? "active" : "" %>">리뷰 많은순</a>
				<a href="<%= listUrl(keyword, category, "new", 1) %>" class="<%= sort.equals("new") ? "active" : "" %>">최신순</a>
			</div>
		</div>

		<p class="result-count">총 <b><%= totalCount %></b>곳</p>

<% if (totalCount == 0) { %>
		<p class="empty">조건에 맞는 맛집이 없습니다.</p>
<% } else { %>
		<div class="card-list">
<%		while (rs.next()) { %>
			<a href="detail.jsp?id=<%= rs.getInt("restaurant_id") %>" class="card">
				<div class="thumb"><%= thumb(rs.getString("image"), rs.getString("category")) %></div>
				<div class="info">
					<h3><%= esc(rs.getString("name")) %></h3>
					<p class="desc"><%= esc(rs.getString("category")) %> · <%= esc(rs.getString("region")) %></p>
					<p class="star">★ <%= avgText(rs.getDouble("avg_rating")) %> <span>(리뷰 <%= rs.getInt("review_count") %>)</span></p>
				</div>
			</a>
<%		} %>
		</div>

		<!-- 페이징 -->
		<div class="pagination">
<%		if (startPage > 1) { %>
			<a href="<%= listUrl(keyword, category, sort, startPage - 1) %>">«</a>
<%		} %>
<%		for (int p = startPage; p <= endPage; p++) { %>
			<a href="<%= listUrl(keyword, category, sort, p) %>" class="<%= p == pageNum ? "active" : "" %>"><%= p %></a>
<%		} %>
<%		if (endPage < totalPage) { %>
			<a href="<%= listUrl(keyword, category, sort, endPage + 1) %>">»</a>
<%		} %>
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
