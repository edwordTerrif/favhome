<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>맛집 목록 - 맛집로그</title>
<link rel="stylesheet" href="style.css">
</head>
<body>

	<%@ include file="header.jsp" %>

	<main class="container">
		<h2>맛집 목록</h2>

		<!-- 검색창 -->
		<form class="list-search" action="list.jsp" method="get">
			<input type="text" name="keyword" placeholder="맛집 이름이나 지역으로 검색">
			<button type="submit" class="btn">검색</button>
		</form>

		<!-- 카테고리 + 정렬 -->
		<div class="toolbar">
			<div class="tabs">
				<a href="list.jsp" class="active">전체</a>
				<a href="list.jsp?category=한식">한식</a>
				<a href="list.jsp?category=중식">중식</a>
				<a href="list.jsp?category=일식">일식</a>
				<a href="list.jsp?category=양식">양식</a>
				<a href="list.jsp?category=분식">분식</a>
				<a href="list.jsp?category=카페">카페</a>
			</div>
			<div class="sort">
				<a href="list.jsp?sort=star" class="active">별점순</a>
				<a href="list.jsp?sort=review">리뷰 많은순</a>
				<a href="list.jsp?sort=new">최신순</a>
			</div>
		</div>

		<p class="result-count">총 <b>12</b>곳</p>

		<!-- 맛집 카드 (한 페이지에 8개) -->
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

			<a href="detail.jsp?id=6" class="card">
				<div class="thumb">🍣</div>
				<div class="info">
					<h3>스시하루</h3>
					<p class="desc">일식 · 강남</p>
					<p class="star">★ 4.6 <span>(리뷰 22)</span></p>
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

			<a href="detail.jsp?id=7" class="card">
				<div class="thumb">🍖</div>
				<div class="info">
					<h3>연탄갈비</h3>
					<p class="desc">한식 · 마포</p>
					<p class="star">★ 4.5 <span>(리뷰 19)</span></p>
				</div>
			</a>

			<a href="detail.jsp?id=5" class="card">
				<div class="thumb">🥟</div>
				<div class="info">
					<h3>진짜루반점</h3>
					<p class="desc">중식 · 을지로</p>
					<p class="star">★ 4.4 <span>(리뷰 25)</span></p>
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

			<a href="detail.jsp?id=9" class="card">
				<div class="thumb">🍢</div>
				<div class="info">
					<h3>신촌떡볶이</h3>
					<p class="desc">분식 · 신촌</p>
					<p class="star">★ 4.2 <span>(리뷰 15)</span></p>
				</div>
			</a>
		</div>

		<!-- 페이징 -->
		<div class="pagination">
			<a href="#">«</a>
			<a href="list.jsp?page=1" class="active">1</a>
			<a href="list.jsp?page=2">2</a>
			<a href="#">»</a>
		</div>

		<!-- 검색 결과가 없을 때 보여줄 화면 (백엔드 연결 후 사용) -->
		<!-- <p class="empty">검색 결과가 없습니다.</p> -->
	</main>

	<%@ include file="footer.jsp" %>

</body>
</html>
