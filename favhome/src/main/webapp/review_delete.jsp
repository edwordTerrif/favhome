<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="common.jsp" %>
<%@ include file="dbconn.jsp" %>
<%
	// 리뷰 삭제: 일반 회원은 본인 리뷰만, 관리자는 모든 리뷰
	int reviewId = toInt(request.getParameter("reviewId"), 0);
	int restaurantId = toInt(request.getParameter("restaurantId"), 0);
	int deleted = 0;

	if (isLogin) {
		String sql = "DELETE FROM reviews WHERE review_id = ?";
		if (!isAdmin) {
			sql += " AND member_id = ?";
		}
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, reviewId);
		if (!isAdmin) {
			pstmt.setInt(2, loginId);
		}
		deleted = pstmt.executeUpdate();
		pstmt.close();
	}
	conn.close();

	if (deleted == 0) {
		alertBack(out, "본인이 쓴 리뷰만 삭제할 수 있습니다.");
	} else {
		response.sendRedirect("detail.jsp?id=" + restaurantId);
	}
%>
