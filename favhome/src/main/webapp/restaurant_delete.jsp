<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="common.jsp" %>
<%@ include file="dbconn.jsp" %>
<%
	// 맛집 삭제: 등록한 본인 또는 관리자만 (리뷰, 사진 정보도 같이 삭제됨)
	int restaurantId = toInt(request.getParameter("restaurantId"), 0);
	int deleted = 0;

	if (isLogin) {
		// 지울 사진 파일 이름을 먼저 기억해 둠 (DB에서 지우면 이름을 알 수 없으니까)
		List<String> files = new ArrayList<>();
		PreparedStatement pstmt = conn.prepareStatement("SELECT file_name FROM restaurant_images WHERE restaurant_id = ?");
		pstmt.setInt(1, restaurantId);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			files.add(rs.getString("file_name"));
		}
		rs.close();
		pstmt.close();

		String sql = "DELETE FROM restaurants WHERE restaurant_id = ?";
		if (!isAdmin) {
			sql += " AND member_id = ?";    // 일반 회원은 본인 글만
		}
		pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, restaurantId);
		if (!isAdmin) {
			pstmt.setInt(2, loginId);
		}
		deleted = pstmt.executeUpdate();
		pstmt.close();

		// 삭제에 성공했을 때만 upload 폴더의 사진 파일도 지움
		if (deleted > 0) {
			for (String f : files) {
				deleteUploadFile(application, f);
			}
		}
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
