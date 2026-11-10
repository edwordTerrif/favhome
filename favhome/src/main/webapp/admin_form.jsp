<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>맛집 등록 - 맛집로그</title>
<link rel="stylesheet" href="style.css">
</head>
<body>

	<%@ include file="header.jsp" %>

	<!-- 관리자 전용: 맛집 등록 / 수정 공용 화면 (id가 있으면 수정) -->
	<main class="container">
		<div class="form-box">
			<h2>맛집 등록</h2>

			<!-- 사진 업로드가 있으므로 enctype을 multipart/form-data로 지정 -->
			<form action="#" method="post" enctype="multipart/form-data">
				<div class="form-group">
					<label for="name">가게 이름</label>
					<input type="text" id="name" name="name" placeholder="예) 든든국밥" maxlength="50" required>
				</div>

				<div class="form-row">
					<div class="form-group">
						<label for="category">카테고리</label>
						<select id="category" name="category" required>
							<option value="">선택하세요</option>
							<option value="한식">한식</option>
							<option value="중식">중식</option>
							<option value="일식">일식</option>
							<option value="양식">양식</option>
							<option value="분식">분식</option>
							<option value="카페">카페</option>
						</select>
					</div>
					<div class="form-group">
						<label for="region">지역</label>
						<input type="text" id="region" name="region" placeholder="예) 종로" maxlength="20" required>
					</div>
				</div>

				<div class="form-group">
					<label for="address">주소</label>
					<input type="text" id="address" name="address" placeholder="예) 서울 종로구 종로 123" maxlength="100">
				</div>

				<div class="form-group">
					<label for="phone">전화번호</label>
					<input type="text" id="phone" name="phone" placeholder="예) 02-123-4567" maxlength="20">
				</div>

				<div class="form-group">
					<label for="description">소개</label>
					<textarea id="description" name="description" placeholder="가게를 간단히 소개해 주세요"></textarea>
				</div>

				<div class="form-group">
					<label for="image">대표 사진</label>
					<input type="file" id="image" name="image" accept="image/*">
					<p class="help">jpg, png 파일 / 수정할 때 비워두면 기존 사진이 유지됩니다</p>
				</div>

				<div class="form-actions">
					<a href="admin_list.jsp" class="btn btn-gray">취소</a>
					<button type="submit" class="btn">등록하기</button>
				</div>
			</form>
		</div>
	</main>

	<%@ include file="footer.jsp" %>

</body>
</html>
