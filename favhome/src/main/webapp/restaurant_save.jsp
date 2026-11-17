<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.Part, java.util.UUID"%>
<%@ include file="common.jsp" %>
<%
	/*
		맛집 등록 / 수정 처리
		- 폼이 multipart/form-data 라서 web.xml에 multipart 설정을 해두었음
		- restaurantId가 0이면 새로 등록, 아니면 수정
		- 사진은 여러 장 (name="images"), 수정할 때 체크한 사진은 삭제 (name="deleteImageIds")
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

	// ===== 2. 새로 올린 사진 모으기 (아직 저장하지 않고 검사만) =====
	List<Part> newImages = new ArrayList<>();
	List<String> newExts = new ArrayList<>();
	if (error == null) {
		for (Part part : request.getParts()) {
			// 파일을 고르지 않은 칸은 크기가 0
			if (!part.getName().equals("images") || part.getSize() == 0) {
				continue;
			}
			String original = part.getSubmittedFileName();
			String ext = "";
			if (original != null && original.lastIndexOf(".") >= 0) {
				ext = original.substring(original.lastIndexOf(".")).toLowerCase();
			}
			if (!Arrays.asList(".jpg", ".jpeg", ".png", ".gif", ".webp").contains(ext)) {
				error = "사진은 jpg, png, gif, webp 파일만 올릴 수 있습니다.";
				break;
			}
			newImages.add(part);
			newExts.add(ext);
		}
	}

	// 수정할 때 삭제하려고 체크한 사진 번호
	List<Integer> deleteIds = new ArrayList<>();
	String[] deleteParams = request.getParameterValues("deleteImageIds");
	if (deleteParams != null) {
		for (String d : deleteParams) {
			int id = toInt(d, 0);
			if (id > 0) {
				deleteIds.add(id);
			}
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
	ResultSet rs = null;

	// ===== 3. 수정이면 권한 확인 + 사진 수 확인 =====
	int keepCount = 0;   // 수정 후에도 남는 기존 사진 수
	if (isEdit) {
		pstmt = conn.prepareStatement("SELECT member_id FROM restaurants WHERE restaurant_id = ?");
		pstmt.setInt(1, restaurantId);
		rs = pstmt.executeQuery();
		int writerId = rs.next() ? rs.getInt("member_id") : 0;
		rs.close();
		pstmt.close();

		if (writerId == 0) {
			error = "존재하지 않는 맛집입니다.";
		} else if (!isAdmin && loginId != writerId) {
			error = "본인이 등록한 맛집만 수정할 수 있습니다.";
		} else {
			pstmt = conn.prepareStatement("SELECT image_id FROM restaurant_images WHERE restaurant_id = ?");
			pstmt.setInt(1, restaurantId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				if (!deleteIds.contains(rs.getInt("image_id"))) {
					keepCount++;
				}
			}
			rs.close();
			pstmt.close();
		}
	}

	if (error == null && keepCount + newImages.size() > MAX_IMAGES) {
		error = "사진은 최대 " + MAX_IMAGES + "장까지 올릴 수 있습니다. (지금 " + (keepCount + newImages.size()) + "장)";
	}

	if (error != null) {
		conn.close();
		alertBack(out, error);
		return;
	}

	// ===== 4. 맛집 정보 저장 =====
	if (!isEdit) {
		// 새로 등록 (등록한 회원 = 로그인한 회원)
		pstmt = conn.prepareStatement(
				"INSERT INTO restaurants (member_id, name, category, region, address, phone, description) VALUES (?, ?, ?, ?, ?, ?, ?)",
				Statement.RETURN_GENERATED_KEYS);
		pstmt.setInt(1, loginId);
		pstmt.setString(2, name);
		pstmt.setString(3, category);
		pstmt.setString(4, region);
		pstmt.setString(5, address);
		pstmt.setString(6, phone);
		pstmt.setString(7, description);
		pstmt.executeUpdate();

		// 방금 등록된 맛집 번호 가져오기
		rs = pstmt.getGeneratedKeys();
		if (rs.next()) {
			restaurantId = rs.getInt(1);
		}
		rs.close();
		pstmt.close();
	} else {
		// 수정 (권한은 3번에서 확인함)
		pstmt = conn.prepareStatement(
				"UPDATE restaurants SET name = ?, category = ?, region = ?, address = ?, phone = ?, description = ? WHERE restaurant_id = ?");
		pstmt.setString(1, name);
		pstmt.setString(2, category);
		pstmt.setString(3, region);
		pstmt.setString(4, address);
		pstmt.setString(5, phone);
		pstmt.setString(6, description);
		pstmt.setInt(7, restaurantId);
		pstmt.executeUpdate();
		pstmt.close();

		// 체크한 사진 삭제 (이 맛집의 사진인 것만)
		for (int imageId : deleteIds) {
			pstmt = conn.prepareStatement("SELECT file_name FROM restaurant_images WHERE image_id = ? AND restaurant_id = ?");
			pstmt.setInt(1, imageId);
			pstmt.setInt(2, restaurantId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				deleteUploadFile(application, rs.getString("file_name"));
			}
			rs.close();
			pstmt.close();

			pstmt = conn.prepareStatement("DELETE FROM restaurant_images WHERE image_id = ? AND restaurant_id = ?");
			pstmt.setInt(1, imageId);
			pstmt.setInt(2, restaurantId);
			pstmt.executeUpdate();
			pstmt.close();
		}
	}

	// ===== 5. 새 사진 저장: 파일은 upload 폴더에, 파일 이름은 DB에 =====
	String uploadPath = application.getRealPath("/upload");
	File uploadDir = new File(uploadPath);
	if (!uploadDir.exists()) {
		uploadDir.mkdirs();
	}

	for (int i = 0; i < newImages.size(); i++) {
		// 파일 이름이 겹치지 않도록 랜덤 이름 + 원래 확장자
		String fileName = UUID.randomUUID().toString() + newExts.get(i);
		newImages.get(i).write(uploadPath + File.separator + fileName);

		pstmt = conn.prepareStatement("INSERT INTO restaurant_images (restaurant_id, file_name) VALUES (?, ?)");
		pstmt.setInt(1, restaurantId);
		pstmt.setString(2, fileName);
		pstmt.executeUpdate();
		pstmt.close();
	}

	conn.close();
	response.sendRedirect("detail.jsp?id=" + restaurantId);
%>
