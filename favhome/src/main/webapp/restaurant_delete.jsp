<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="common.jsp" %>
<%@ include file="dbconn.jsp" %>
<%
	// 맛집 삭제: 등록한 본인 또는 관리자만 (리뷰도 같이 삭제됨)
	int restaurantId = toInt(request.getParameter("restaurantId"), 0);
	int deleted = 0;

	if (isLogin) {
		String sql = "DELETE FROM restaurants WHERE restaurant_id = ?";
		if (!isAdmin) {
			sql += " AND member_id = ?";    // 일반 회원은 본인 글만
		}
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, restaurantId);
		if (!isAdmin) {
			pstmt.setInt(2, loginId);
		}
		deleted = pstmt.executeUpdate();
		pstmt.close();
	}
	conn.close();

	if (deleted == 0) {
		alertBack(out, "삭제할 수 없습니다. 본인이 등록한 맛집인지 확인해 주세요.");
	} else if (isAdmin) {
		alertGo(out, "삭제되었습니다.", "admin_list.jsp");
	} else {
		alertGo(out, "삭제되었습니다.", "list.jsp");
	}
%>
