<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="common.jsp" %>
<%@ include file="dbconn.jsp" %>
<%
	// 리뷰 수정 화면: 본인이 쓴 리뷰만
	int reviewId = toInt(request.getParameter("id"), 0);

	String sql = "SELECT v.*, r.name AS restaurant_name "
			+ "FROM reviews v JOIN restaurants r ON r.restaurant_id = v.restaurant_id "
			+ "WHERE v.review_id = ?";
	PreparedStatement pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, reviewId);
	ResultSet rs = pstmt.executeQuery();

	boolean found = rs.next();
	int writerId = 0, restaurantId = 0, rating = 5;
	String content = "", restaurantName = "";
	if (found) {
		writerId = rs.getInt("member_id");
		restaurantId = rs.getInt("restaurant_id");
		rating = rs.getInt("rating");
		content = rs.getString("content");
		restaurantName = rs.getString("restaurant_name");
	}
	rs.close();
	pstmt.close();
	conn.close();

	if (!found) {
		alertGo(out, "존재하지 않는 리뷰입니다.", "list.jsp");
		return;
	}
	if (!isLogin || loginId != writerId) {
		alertBack(out, "본인이 쓴 리뷰만 수정할 수 있습니다.");
		return;
	}
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>리뷰 수정 - 맛집로그</title>
<link rel="stylesheet" href="style.css">
</head>
<body>

	<%@ include file="header.jsp" %>

	<main class="container">
		<div class="form-box">
			<h2>리뷰 수정</h2>
			<p class="form-sub"><%= esc(restaurantName) %></p>

			<form action="review_save.jsp" method="post">
				<input type="hidden" name="reviewId" value="<%= reviewId %>">
				<input type="hidden" name="restaurantId" value="<%= restaurantId %>">

				<div class="form-group">
					<label for="rating">별점</label>
					<select id="rating" name="rating">
<% for (int i = 5; i >= 1; i--) { %>
						<option value="<%= i %>" <%= i == rating ? "selected" : "" %>><%= stars(i) %> <%= i %>점</option>
<% } %>
					</select>
				</div>

				<div class="form-group">
					<label for="content">내용</label>
					<textarea id="content" name="content" maxlength="1000" required><%= esc(content) %></textarea>
				</div>

				<div class="form-actions">
					<a href="detail.jsp?id=<%= restaurantId %>" class="btn btn-gray">취소</a>
					<button type="submit" class="btn">수정 완료</button>
				</div>
			</form>
		</div>
	</main>

	<%@ include file="footer.jsp" %>

</body>
</html>
