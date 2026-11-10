<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>맛집로그</title>
<link rel="stylesheet" href="style.css">
</head>
<body>

	<%@ include file="header.jsp" %>

	<!-- 메인 배너 + 검색창 -->
	<section class="banner">
		<h1>오늘 뭐 먹지?</h1>
		<p>직접 다녀온 사람들의 솔직한 맛집 리뷰</p>
		<form class="search" action="list.jsp" method="get">
			<input type="text" name="keyword" placeholder="맛집 이름이나 지역을 검색해 보세요">
			<button type="submit">검색</button>
		</form>
	</section>

	<!-- 인기 맛집 (별점 높은 순 4곳) -->
	<main class="container">
		<div class="section-head">
			<h2>인기 맛집</h2>
			<a href="list.jsp" class="more">전체 보기 →</a>
		</div>

		<div class="card-list">
			<a href="detail.jsp?id=1" class="card">
				<div class="thumb">🍲</div>
				<div class="info">
					<h3>든든국밥</h3>
					<p class="desc">한식 · 종로</p>
					<p class="star">★ 4.8 <span>(리뷰 32)</span></p>
				</div>
			</a>

			<a href="detail.jsp?id=2" class="card">
				<div class="thumb">🍜</div>
				<div class="info">
					<h3>골목라멘</h3>
					<p class="desc">일식 · 홍대</p>
					<p class="star">★ 4.7 <span>(리뷰 27)</span></p>
				</div>
			</a>

			<a href="detail.jsp?id=3" class="card">
				<div class="thumb">🍕</div>
				<div class="info">
					<h3>화덕피자집</h3>
					<p class="desc">양식 · 성수</p>
					<p class="star">★ 4.5 <span>(리뷰 41)</span></p>
				</div>
			</a>

			<a href="detail.jsp?id=4" class="card">
				<div class="thumb">☕</div>
				<div class="info">
					<h3>모퉁이카페</h3>
					<p class="desc">카페 · 연남동</p>
					<p class="star">★ 4.3 <span>(리뷰 18)</span></p>
				</div>
			</a>
		</div>
	</main>

	<%@ include file="footer.jsp" %>

</body>
</html>
