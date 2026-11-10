<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="common.jsp" %>
<%
	/*
		리뷰 등록 / 수정 처리
		- reviewId가 없으면 새로 등록 (detail.jsp의 리뷰 폼)
		- reviewId가 있으면 수정 (review_edit.jsp)
	*/
	int restaurantId = toInt(request.getParameter("restaurantId"), 0);
	int reviewId = toInt(request.getParameter("reviewId"), 0);
	int rating = toInt(request.getParameter("rating"), 0);
	String content = trim(request.getParameter("content"));

	String error = null;
	if (!isLogin) {
		error = "로그인이 필요합니다.";
	} else if (isAdmin) {
		error = "관리자 계정은 리뷰를 작성할 수 없습니다.";
	} else if (rating < 1 || rating > 5) {
		error = "별점을 선택해 주세요.";
	} else if (content.isEmpty()) {
		error = "리뷰 내용을 입력해 주세요.";
	} else if (content.length() > 1000) {
		error = "리뷰는 1000자까지 쓸 수 있습니다.";
	}

	if (error != null) {
		alertBack(out, error);
		return;
	}
%>
<%@ include file="dbconn.jsp" %>
<%
	PreparedStatement pstmt;
	int changed;

	if (reviewId == 0) {
		// 새 리뷰
		pstmt = conn.prepareStatement("INSERT INTO reviews (restaurant_id, member_id, rating, content) VALUES (?, ?, ?, ?)");
		pstmt.setInt(1, restaurantId);
		pstmt.setInt(2, loginId);
		pstmt.setInt(3, rating);
		pstmt.setString(4, content);
	} else {
		// 수정: 본인 리뷰만 (member_id 조건)
		pstmt = conn.prepareStatement("UPDATE reviews SET rating = ?, content = ? WHERE review_id = ? AND member_id = ?");
		pstmt.setInt(1, rating);
		pstmt.setString(2, content);
		pstmt.setInt(3, reviewId);
		pstmt.setInt(4, loginId);
	}
	changed = pstmt.executeUpdate();
	pstmt.close();
	conn.close();

	if (changed == 0) {
		alertBack(out, "본인이 쓴 리뷰만 수정할 수 있습니다.");
	} else {
		response.sendRedirect("detail.jsp?id=" + restaurantId);
	}
%>
