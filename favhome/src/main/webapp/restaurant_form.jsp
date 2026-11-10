<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="common.jsp" %>
<%
	/*
		맛집 등록 / 수정 공용 화면
		- restaurant_form.jsp         → 새로 등록 (로그인한 일반 회원만)
		- restaurant_form.jsp?id=번호 → 수정 (등록한 본인 또는 관리자만)
	*/
	int restaurantId = toInt(request.getParameter("id"), 0);
	boolean isEdit = restaurantId > 0;

	if (!isLogin) {
		alertGo(out, "로그인이 필요합니다.", "login.jsp");
		return;
	}
	if (!isEdit && isAdmin) {
		alertBack(out, "관리자 계정은 맛집을 등록할 수 없습니다.");
		return;
	}

	// 입력칸에 미리 채울 값 (수정일 때만)
	String name = "", category = "", region = "", address = "", phone = "", description = "", image = null;

	if (isEdit) {
%>
<%@ include file="dbconn.jsp" %>
<%
		PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM restaurants WHERE restaurant_id = ?");
		pstmt.setInt(1, restaurantId);
		ResultSet rs = pstmt.executeQuery();

		boolean found = rs.next();
		int writerId = 0;
		if (found) {
			writerId = rs.getInt("member_id");
			name = rs.getString("name");
			category = rs.getString("category");
			region = rs.getString("region");
			address = rs.getString("address") == null ? "" : rs.getString("address");
			phone = rs.getString("phone") == null ? "" : rs.getString("phone");
			description = rs.getString("description");
			image = rs.getString("image");
		}
		rs.close();
		pstmt.close();
		conn.close();

		if (!found) {
			alertGo(out, "존재하지 않는 맛집입니다.", "list.jsp");
			return;
		}
		if (!isAdmin && loginId != writerId) {
			alertBack(out, "본인이 등록한 맛집만 수정할 수 있습니다.");
			return;
		}
	}

	String[] categories = { "한식", "중식", "일식", "양식", "분식", "카페" };
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><%= isEdit ? "맛집 수정" : "맛집 등록" %> - 맛집로그</title>
<link rel="stylesheet" href="style.css">
</head>
<body>

	<%@ include file="header.jsp" %>

	<main class="container">
		<div class="form-box">
			<h2><%= isEdit ? "맛집 수정" : "맛집 등록" %></h2>
			<p class="form-sub">직접 다녀온 맛집을 사진과 함께 소개해 주세요</p>

			<!-- 사진 업로드가 있으므로 enctype을 multipart/form-data로 지정 -->
			<form action="restaurant_save.jsp" method="post" enctype="multipart/form-data">
				<input type="hidden" name="restaurantId" value="<%= restaurantId %>">

				<div class="form-group">
					<label for="name">가게 이름 <span class="req">*</span></label>
					<input type="text" id="name" name="name" value="<%= esc(name) %>" placeholder="예) 든든국밥" maxlength="50" required>
				</div>

				<div class="form-row">
					<div class="form-group">
						<label for="category">카테고리 <span class="req">*</span></label>
						<select id="category" name="category" required>
							<option value="">선택하세요</option>
<% for (String c : categories) { %>
							<option value="<%= c %>" <%= c.equals(category) ? "selected" : "" %>><%= c %></option>
<% } %>
						</select>
					</div>
					<div class="form-group">
						<label for="region">지역 <span class="req">*</span></label>
						<input type="text" id="region" name="region" value="<%= esc(region) %>" placeholder="예) 종로" maxlength="20" required>
					</div>
				</div>

				<div class="form-row">
					<div class="form-group">
						<label for="address">주소</label>
						<input type="text" id="address" name="address" value="<%= esc(address) %>" placeholder="예) 서울 종로구 종로 123" maxlength="100">
					</div>
					<div class="form-group">
						<label for="phone">전화번호</label>
						<input type="text" id="phone" name="phone" value="<%= esc(phone) %>" placeholder="예) 02-123-4567" maxlength="20">
					</div>
				</div>

				<div class="form-group">
					<label for="image">대표 사진</label>
<% if (image != null && !image.isEmpty()) { %>
					<div class="current-image"><img src="upload/<%= esc(image) %>" alt="현재 사진"></div>
<% } %>
					<input type="file" id="image" name="image" accept="image/*">
					<p class="help">jpg, png, gif, webp 파일 (최대 10MB)<%= isEdit ? " / 비워두면 기존 사진이 유지됩니다" : "" %></p>
				</div>

				<div class="form-group">
					<label for="description">소개글 <span class="req">*</span></label>
					<textarea id="description" name="description" class="textarea-large" placeholder="어떤 메뉴가 맛있는지, 분위기는 어떤지, 언제 가면 좋은지 자유롭게 써 주세요" required><%= esc(description) %></textarea>
				</div>

				<div class="form-actions">
					<a href="<%= isEdit ? "detail.jsp?id=" + restaurantId : "list.jsp" %>" class="btn btn-gray">취소</a>
					<button type="submit" class="btn"><%= isEdit ? "수정 완료" : "등록하기" %></button>
				</div>
			</form>
		</div>
	</main>

	<%@ include file="footer.jsp" %>

</body>
</html>
