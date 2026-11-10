<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="common.jsp" %>
<%
	// 관리자(role = ADMIN)만 들어올 수 있는 페이지: 회원이 올린 모든 맛집을 수정·삭제
	if (!isAdmin) {
		alertGo(out, "관리자만 들어올 수 있습니다.", "main.jsp");
		return;
	}
%>
<%@ include file="dbconn.jsp" %>
<%
	int pageNum = toInt(request.getParameter("page"), 1);
	int pageSize = 10;

	// 전체 개수
	PreparedStatement pstmt = conn.prepareStatement("SELECT COUNT(*) FROM restaurants");
	ResultSet rs = pstmt.executeQuery();
	rs.next();
	int totalCount = rs.getInt(1);
	rs.close();
	pstmt.close();

	int totalPage = (totalCount + pageSize - 1) / pageSize;
	if (totalPage < 1) totalPage = 1;
	if (pageNum < 1) pageNum = 1;
	if (pageNum > totalPage) pageNum = totalPage;

	// 맛집 목록 (최근 등록 순)
	String sql = "SELECT r.restaurant_id, r.name, r.category, r.region, r.image, r.created_at, "
			+ "       m.nickname AS writer, COUNT(v.review_id) AS review_count "
			+ "FROM restaurants r "
			+ "JOIN members m ON m.member_id = r.member_id "
			+ "LEFT JOIN reviews v ON v.restaurant_id = r.restaurant_id "
			+ "GROUP BY r.restaurant_id, m.nickname "
			+ "ORDER BY r.restaurant_id DESC "
			+ "LIMIT ? OFFSET ?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, pageSize);
	pstmt.setInt(2, (pageNum - 1) * pageSize);
	rs = pstmt.executeQuery();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>맛집 관리 - 맛집로그</title>
<link rel="stylesheet" href="style.css">
</head>
<body>

	<%@ include file="header.jsp" %>

	<main class="container">
		<div class="section-head">
			<h2>맛집 관리</h2>
			<p class="more">전체 <%= totalCount %>곳</p>
		</div>

<% if (totalCount == 0) { %>
		<p class="empty">등록된 맛집이 없습니다.</p>
<% } else { %>
		<div class="table-wrap">
			<table class="table">
				<thead>
					<tr>
						<th>번호</th>
						<th>사진</th>
						<th>이름</th>
						<th>카테고리</th>
						<th>지역</th>
						<th>등록한 회원</th>
						<th>리뷰</th>
						<th>등록일</th>
						<th>관리</th>
					</tr>
				</thead>
				<tbody>
<%
		while (rs.next()) {
			int id = rs.getInt("restaurant_id");
%>
					<tr>
						<td><%= id %></td>
						<td><div class="thumb-sm"><%= thumb(rs.getString("image"), rs.getString("category")) %></div></td>
						<td class="name"><a href="detail.jsp?id=<%= id %>"><%= esc(rs.getString("name")) %></a></td>
						<td><%= esc(rs.getString("category")) %></td>
						<td><%= esc(rs.getString("region")) %></td>
						<td><%= esc(rs.getString("writer")) %></td>
						<td><%= rs.getInt("review_count") %></td>
						<td><%= dateText(rs.getTimestamp("created_at")) %></td>
						<td class="manage">
							<a href="restaurant_form.jsp?id=<%= id %>" class="btn btn-small btn-gray">수정</a>
							<form action="restaurant_delete.jsp" method="post" class="inline-form" onsubmit="return confirm('맛집과 리뷰가 모두 삭제됩니다. 삭제할까요?');">
								<input type="hidden" name="restaurantId" value="<%= id %>">
								<button type="submit" class="btn btn-small btn-line">삭제</button>
							</form>
						</td>
					</tr>
<%		} %>
				</tbody>
			</table>
		</div>

<%		if (totalPage > 1) { %>
		<div class="pagination">
<%			for (int p = 1; p <= totalPage; p++) { %>
			<a href="admin_list.jsp?page=<%= p %>" class="<%= p == pageNum ? "active" : "" %>"><%= p %></a>
<%			} %>
		</div>
<%		} %>
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
