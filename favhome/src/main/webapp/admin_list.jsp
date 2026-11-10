<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>맛집 관리 - 맛집로그</title>
<link rel="stylesheet" href="style.css">
</head>
<body>

	<%@ include file="header.jsp" %>

	<!-- 관리자(role = ADMIN)만 들어올 수 있는 페이지 -->
	<main class="container">
		<div class="section-head">
			<h2>맛집 관리</h2>
			<a href="admin_form.jsp" class="btn">+ 맛집 등록</a>
		</div>

		<div class="table-wrap">
			<table class="table">
				<thead>
					<tr>
						<th>번호</th>
						<th>사진</th>
						<th>이름</th>
						<th>카테고리</th>
						<th>지역</th>
						<th>리뷰</th>
						<th>등록일</th>
						<th>관리</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>12</td>
						<td><div class="thumb-sm">🍔</div></td>
						<td class="name"><a href="detail.jsp?id=12">버거스탠드</a></td>
						<td>양식</td>
						<td>한남</td>
						<td>9</td>
						<td>2026.11.09</td>
						<td class="manage">
							<a href="admin_form.jsp?id=12" class="btn btn-small btn-gray">수정</a>
							<form action="#" method="post" class="inline-form" onsubmit="return confirm('맛집과 리뷰가 모두 삭제됩니다. 삭제할까요?');">
								<input type="hidden" name="restaurantId" value="12">
								<button type="submit" class="btn btn-small btn-line">삭제</button>
							</form>
						</td>
					</tr>
					<tr>
						<td>11</td>
						<td><div class="thumb-sm">🌶️</div></td>
						<td class="name"><a href="detail.jsp?id=11">마라한스푼</a></td>
						<td>중식</td>
						<td>건대</td>
						<td>12</td>
						<td>2026.11.07</td>
						<td class="manage">
							<a href="admin_form.jsp?id=11" class="btn btn-small btn-gray">수정</a>
							<form action="#" method="post" class="inline-form" onsubmit="return confirm('맛집과 리뷰가 모두 삭제됩니다. 삭제할까요?');">
								<input type="hidden" name="restaurantId" value="11">
								<button type="submit" class="btn btn-small btn-line">삭제</button>
							</form>
						</td>
					</tr>
					<tr>
						<td>10</td>
						<td><div class="thumb-sm">🥐</div></td>
						<td class="name"><a href="detail.jsp?id=10">달콤베이커리</a></td>
						<td>카페</td>
						<td>성수</td>
						<td>14</td>
						<td>2026.11.05</td>
						<td class="manage">
							<a href="admin_form.jsp?id=10" class="btn btn-small btn-gray">수정</a>
							<form action="#" method="post" class="inline-form" onsubmit="return confirm('맛집과 리뷰가 모두 삭제됩니다. 삭제할까요?');">
								<input type="hidden" name="restaurantId" value="10">
								<button type="submit" class="btn btn-small btn-line">삭제</button>
							</form>
						</td>
					</tr>
					<tr>
						<td>9</td>
						<td><div class="thumb-sm">🍢</div></td>
						<td class="name"><a href="detail.jsp?id=9">신촌떡볶이</a></td>
						<td>분식</td>
						<td>신촌</td>
						<td>15</td>
						<td>2026.11.03</td>
						<td class="manage">
							<a href="admin_form.jsp?id=9" class="btn btn-small btn-gray">수정</a>
							<form action="#" method="post" class="inline-form" onsubmit="return confirm('맛집과 리뷰가 모두 삭제됩니다. 삭제할까요?');">
								<input type="hidden" name="restaurantId" value="9">
								<button type="submit" class="btn btn-small btn-line">삭제</button>
							</form>
						</td>
					</tr>
					<tr>
						<td>8</td>
						<td><div class="thumb-sm">🥞</div></td>
						<td class="name"><a href="detail.jsp?id=8">브런치하우스</a></td>
						<td>양식</td>
						<td>이태원</td>
						<td>11</td>
						<td>2026.11.01</td>
						<td class="manage">
							<a href="admin_form.jsp?id=8" class="btn btn-small btn-gray">수정</a>
							<form action="#" method="post" class="inline-form" onsubmit="return confirm('맛집과 리뷰가 모두 삭제됩니다. 삭제할까요?');">
								<input type="hidden" name="restaurantId" value="8">
								<button type="submit" class="btn btn-small btn-line">삭제</button>
							</form>
						</td>
					</tr>
				</tbody>
			</table>
		</div>

		<div class="pagination">
			<a href="#">«</a>
			<a href="#" class="active">1</a>
			<a href="#">2</a>
			<a href="#">»</a>
		</div>
	</main>

	<%@ include file="footer.jsp" %>

</body>
</html>
