<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.Part, java.util.UUID"%>
<%@ include file="common.jsp" %>
<%
	/*
		맛집 등록 / 수정 처리
		- 폼이 multipart/form-data 라서 web.xml에 multipart 설정을 해두었음
		- restaurantId가 0이면 새로 등록, 아니면 수정
	*/
	if (!isLogin) {
		alertGo(out, "로그인이 필요합니다.", "login.jsp");
		return;
	}

	int restaurantId = toInt(request.getParameter("restaurantId"), 0);
	boolean isEdit = restaurantId > 0;

	String name = trim(request.getParameter("name"));
	String category = trim(request.getParameter("category"));
	String region = trim(request.getParameter("region"));
	String address = trim(request.getParameter("address"));
	String phone = trim(request.getParameter("phone"));
	String description = trim(request.getParameter("description"));

	// ===== 1. 입력값 검사 =====
	String error = null;
	if (!isEdit && isAdmin) {
		error = "관리자 계정은 맛집을 등록할 수 없습니다.";
	} else if (name.isEmpty() || category.isEmpty() || region.isEmpty() || description.isEmpty()) {
		error = "가게 이름, 카테고리, 지역, 소개글은 꼭 입력해 주세요.";
	} else if (!Arrays.asList("한식", "중식", "일식", "양식", "분식", "카페").contains(category)) {
		error = "카테고리를 다시 선택해 주세요.";
	}

	// ===== 2. 사진 저장 (선택한 경우만) =====
	String fileName = null;
	Part imagePart = request.getPart("image");
	if (error == null && imagePart != null && imagePart.getSize() > 0) {
		String original = imagePart.getSubmittedFileName();
		String ext = "";
		if (original != null && original.lastIndexOf(".") >= 0) {
			ext = original.substring(original.lastIndexOf(".")).toLowerCase();
		}

		if (!Arrays.asList(".jpg", ".jpeg", ".png", ".gif", ".webp").contains(ext)) {
			error = "사진은 jpg, png, gif, webp 파일만 올릴 수 있습니다.";
		} else {
			// 파일 이름이 겹치지 않도록 랜덤 이름 + 원래 확장자
			fileName = UUID.randomUUID().toString() + ext;
			String uploadPath = application.getRealPath("/upload");
			File uploadDir = new File(uploadPath);
			if (!uploadDir.exists()) {
				uploadDir.mkdirs();
			}
			imagePart.write(uploadPath + File.separator + fileName);
		}
	}

	if (error != null) {
		alertBack(out, error);
		return;
	}
%>
<%@ include file="dbconn.jsp" %>
<%
	PreparedStatement pstmt = null;
	String sql;

	if (!isEdit) {
		// ===== 3-1. 새로 등록 (등록한 회원 = 로그인한 회원) =====
		sql = "INSERT INTO restaurants (member_id, name, category, region, address, phone, description, image) "
				+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
		pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
		pstmt.setInt(1, loginId);
		pstmt.setString(2, name);
		pstmt.setString(3, category);
		pstmt.setString(4, region);
		pstmt.setString(5, address);
		pstmt.setString(6, phone);
		pstmt.setString(7, description);
		pstmt.setString(8, fileName);
		pstmt.executeUpdate();

		// 방금 등록된 맛집 번호 가져오기
		ResultSet keys = pstmt.getGeneratedKeys();
		if (keys.next()) {
			restaurantId = keys.getInt(1);
		}
		keys.close();
		pstmt.close();
		conn.close();

		response.sendRedirect("detail.jsp?id=" + restaurantId);

	} else {
		// ===== 3-2. 수정 =====
		// 사진을 새로 올렸을 때만 image 컬럼도 바꿈
		sql = "UPDATE restaurants SET name = ?, category = ?, region = ?, address = ?, phone = ?, description = ?"
				+ (fileName != null ? ", image = ?" : "")
				+ " WHERE restaurant_id = ?";
		// 관리자가 아니면 본인이 등록한 맛집만 수정되도록 조건 추가
		if (!isAdmin) {
			sql += " AND member_id = ?";
		}

		pstmt = conn.prepareStatement(sql);
		int index = 1;
		pstmt.setString(index++, name);
		pstmt.setString(index++, category);
		pstmt.setString(index++, region);
		pstmt.setString(index++, address);
		pstmt.setString(index++, phone);
		pstmt.setString(index++, description);
		if (fileName != null) {
			pstmt.setString(index++, fileName);
		}
		pstmt.setInt(index++, restaurantId);
		if (!isAdmin) {
			pstmt.setInt(index++, loginId);
		}
		int updated = pstmt.executeUpdate();
		pstmt.close();
		conn.close();

		if (updated == 0) {
			alertBack(out, "본인이 등록한 맛집만 수정할 수 있습니다.");
		} else {
			response.sendRedirect("detail.jsp?id=" + restaurantId);
		}
	}
%>
