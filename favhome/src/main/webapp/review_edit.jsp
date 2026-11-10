<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
			<p class="form-sub">든든국밥</p>

			<form action="#" method="post">
				<input type="hidden" name="reviewId" value="1">

				<div class="form-group">
					<label for="rating">별점</label>
					<select id="rating" name="rating">
						<option value="5" selected>★★★★★ 5점</option>
						<option value="4">★★★★☆ 4점</option>
						<option value="3">★★★☆☆ 3점</option>
						<option value="2">★★☆☆☆ 2점</option>
						<option value="1">★☆☆☆☆ 1점</option>
					</select>
				</div>

				<div class="form-group">
					<label for="content">내용</label>
					<textarea id="content" name="content" required>국물이 정말 진하고 고기도 넉넉하게 들어 있어요. 점심시간에는 줄이 좀 있지만 회전이 빨라서 금방 들어갑니다.</textarea>
				</div>

				<div class="form-actions">
					<a href="detail.jsp?id=1" class="btn btn-gray">취소</a>
					<button type="submit" class="btn">수정 완료</button>
				</div>
			</form>
		</div>
	</main>

	<%@ include file="footer.jsp" %>

</body>
</html>
