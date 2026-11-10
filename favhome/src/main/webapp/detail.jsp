<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>든든국밥 - 맛집로그</title>
<link rel="stylesheet" href="style.css">
</head>
<body>

	<%@ include file="header.jsp" %>

	<main class="container">

		<!-- 맛집 정보 -->
		<section class="detail-top">
			<div class="detail-thumb">🍲</div>
			<div class="detail-info">
				<span class="tag">한식 · 종로</span>
				<h1>든든국밥</h1>
				<p class="detail-star">★ 4.8 <span>(리뷰 32)</span></p>
				<ul class="detail-meta">
					<li><b>주소</b>서울 종로구 종로 123</li>
					<li><b>전화</b>02-123-4567</li>
				</ul>
				<p class="detail-desc">24시간 푹 고아낸 진한 국물의 돼지국밥집입니다. 깍두기와 부추무침은 셀프로 마음껏 드실 수 있어요.</p>
			</div>
		</section>

		<!-- 리뷰 -->
		<section class="review-section">
			<div class="section-head">
				<h2>리뷰 <span class="count">32</span></h2>
				<div class="sort">
					<a href="detail.jsp?id=1&sort=new" class="active">최신순</a>
					<a href="detail.jsp?id=1&sort=star">별점순</a>
				</div>
			</div>

			<!-- 리뷰 작성 (로그인한 사용자에게만 보여줌) -->
			<form class="review-form" action="#" method="post">
				<input type="hidden" name="restaurantId" value="1">
				<div class="review-form-row">
					<label for="rating">별점</label>
					<select id="rating" name="rating">
						<option value="5">★★★★★ 5점</option>
						<option value="4">★★★★☆ 4점</option>
						<option value="3">★★★☆☆ 3점</option>
						<option value="2">★★☆☆☆ 2점</option>
						<option value="1">★☆☆☆☆ 1점</option>
					</select>
				</div>
				<textarea name="content" placeholder="방문 후기를 남겨주세요" required></textarea>
				<div class="form-actions-right">
					<button type="submit" class="btn">리뷰 등록</button>
				</div>
			</form>

			<!-- 로그인 안 했을 때는 위 폼 대신 이 문구를 보여줌 (백엔드 연결 후 사용) -->
			<!-- <p class="notice">리뷰를 작성하려면 <a href="login.jsp">로그인</a>이 필요합니다.</p> -->

			<!-- 리뷰 목록 -->
			<ul class="review-list">
				<!-- 내가 쓴 리뷰: 수정/삭제 버튼이 보임 -->
				<li class="review-item">
					<div class="review-head">
						<p class="review-writer">맛집탐험가 <span class="mine">내 리뷰</span><span class="review-date">2026.11.08</span></p>
						<p class="review-stars">★★★★★</p>
					</div>
					<p class="review-content">국물이 정말 진하고 고기도 넉넉하게 들어 있어요. 점심시간에는 줄이 좀 있지만 회전이 빨라서 금방 들어갑니다.</p>
					<div class="review-btns">
						<a href="review_edit.jsp?id=1" class="btn btn-small btn-gray">수정</a>
						<form action="#" method="post" class="inline-form" onsubmit="return confirm('리뷰를 삭제할까요?');">
							<input type="hidden" name="reviewId" value="1">
							<button type="submit" class="btn btn-small btn-line">삭제</button>
						</form>
					</div>
				</li>

				<li class="review-item">
					<div class="review-head">
						<p class="review-writer">국밥러버<span class="review-date">2026.11.05</span></p>
						<p class="review-stars">★★★★★</p>
					</div>
					<p class="review-content">해장하러 자주 옵니다. 다대기 조금 풀어서 먹으면 최고예요.</p>
				</li>

				<li class="review-item">
					<div class="review-head">
						<p class="review-writer">점심메뉴고민중<span class="review-date">2026.10.29</span></p>
						<p class="review-stars">★★★★☆</p>
					</div>
					<p class="review-content">맛은 좋은데 가게가 좁아서 조금 붐벼요. 그래도 가격 대비 만족스럽습니다.</p>
				</li>
			</ul>

			<!-- 리뷰 페이징 -->
			<div class="pagination">
				<a href="#">«</a>
				<a href="#" class="active">1</a>
				<a href="#">2</a>
				<a href="#">3</a>
				<a href="#">»</a>
			</div>
		</section>
	</main>

	<%@ include file="footer.jsp" %>

</body>
</html>
