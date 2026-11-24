<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="common.jsp" %>
<%
	/*
		찜하기 / 찜 해제 처리 (누를 때마다 바뀜)
		- 아직 찜하지 않았으면 favorites에 추가, 이미 찜했으면 삭제
		- 마이페이지에서 눌렀으면(back=mypage) 마이페이지로, 아니면 맛집 상세로 돌아감
	*/
	int restaurantId = toInt(request.getParameter("restaurantId"), 0);
	String back = "mypage".equals(request.getParameter("back"))
			? "mypage.jsp?tab=fav"
			: "detail.jsp?id=" + restaurantId;

	if (!isLogin) {
		alertGo(out, "로그인이 필요합니다.", "login.jsp");
		return;
	}
	if (isAdmin) {
		alertBack(out, "관리자 계정은 찜할 수 없습니다.");
		return;
	}
%>
<%@ include file="dbconn.jsp" %>
<%
	// 1. 있는 맛집인지 확인
	PreparedStatement pstmt = conn.prepareStatement("SELECT COUNT(*) FROM restaurants WHERE restaurant_id = ?");
	pstmt.setInt(1, restaurantId);
	ResultSet rs = pstmt.executeQuery();
	rs.next();
	boolean exists = rs.getInt(1) > 0;
	rs.close();
	pstmt.close();

	if (!exists) {
		conn.close();
		alertGo(out, "존재하지 않는 맛집입니다.", "list.jsp");
		return;
	}

	// 2. 이미 찜했는지 확인
	pstmt = conn.prepareStatement("SELECT COUNT(*) FROM favorites WHERE member_id = ? AND restaurant_id = ?");
	pstmt.setInt(1, loginId);
	pstmt.setInt(2, restaurantId);
	rs = pstmt.executeQuery();
	rs.next();
	boolean already = rs.getInt(1) > 0;
	rs.close();
	pstmt.close();

	// 3. 찜했으면 해제, 안 했으면 추가
	if (already) {
		pstmt = conn.prepareStatement("DELETE FROM favorites WHERE member_id = ? AND restaurant_id = ?");
	} else {
		pstmt = conn.prepareStatement("INSERT INTO favorites (member_id, restaurant_id) VALUES (?, ?)");
	}
	pstmt.setInt(1, loginId);
	pstmt.setInt(2, restaurantId);
	pstmt.executeUpdate();
	pstmt.close();
	conn.close();

	response.sendRedirect(back);
%>
