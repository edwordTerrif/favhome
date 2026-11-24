-- =========================================================
-- 맛집로그(favhome) DB 생성 스크립트 (MySQL 8)
-- MySQL Workbench에서 파일 전체를 실행하면
-- DB 생성 → 테이블 생성 → 샘플 데이터 입력까지 한 번에 됩니다.
-- (주의: 기존 favhome DB가 있으면 지우고 새로 만듭니다)
-- =========================================================

DROP DATABASE IF EXISTS favhome;
CREATE DATABASE favhome DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE favhome;


-- ---------------------------------------------------------
-- 1. 회원
-- ---------------------------------------------------------
CREATE TABLE members (
	member_id   INT          NOT NULL AUTO_INCREMENT COMMENT '회원 번호',
	login_id    VARCHAR(20)  NOT NULL COMMENT '로그인 아이디',
	password    VARCHAR(100) NOT NULL COMMENT '비밀번호',
	nickname    VARCHAR(20)  NOT NULL COMMENT '닉네임 (리뷰에 표시)',
	role        VARCHAR(10)  NOT NULL DEFAULT 'USER' COMMENT 'USER: 일반회원, ADMIN: 관리자',
	created_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '가입일',
	PRIMARY KEY (member_id),
	UNIQUE KEY uk_member_login_id (login_id),
	UNIQUE KEY uk_member_nickname (nickname),
	CONSTRAINT ck_member_role CHECK (role IN ('USER', 'ADMIN'))
) COMMENT '회원';


-- ---------------------------------------------------------
-- 2. 맛집
--    일반 회원이 소개글과 함께 직접 등록 (사진은 4번 테이블)
--    등록한 회원이 삭제되면 그 회원이 올린 맛집도 함께 삭제
-- ---------------------------------------------------------
CREATE TABLE restaurants (
	restaurant_id  INT          NOT NULL AUTO_INCREMENT COMMENT '맛집 번호',
	member_id      INT          NOT NULL COMMENT '등록한 회원',
	name           VARCHAR(50)  NOT NULL COMMENT '가게 이름',
	category       VARCHAR(10)  NOT NULL COMMENT '한식/중식/일식/양식/분식/카페',
	region         VARCHAR(20)  NOT NULL COMMENT '지역 (예: 종로)',
	address        VARCHAR(100) NULL     COMMENT '주소',
	phone          VARCHAR(20)  NULL     COMMENT '전화번호',
	description    TEXT         NOT NULL COMMENT '소개글 (등록한 회원이 쓴 글)',
	created_at     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일',
	PRIMARY KEY (restaurant_id),
	CONSTRAINT fk_restaurant_member FOREIGN KEY (member_id)
		REFERENCES members (member_id) ON DELETE CASCADE
) COMMENT '맛집';


-- ---------------------------------------------------------
-- 3. 리뷰
--    맛집이나 회원이 삭제되면 그 리뷰도 함께 삭제 (ON DELETE CASCADE)
-- ---------------------------------------------------------
CREATE TABLE reviews (
	review_id      INT       NOT NULL AUTO_INCREMENT COMMENT '리뷰 번호',
	restaurant_id  INT       NOT NULL COMMENT '어느 맛집의 리뷰인지',
	member_id      INT       NOT NULL COMMENT '누가 썼는지',
	rating         TINYINT   NOT NULL COMMENT '별점 1~5',
	content        TEXT      NOT NULL COMMENT '리뷰 내용',
	created_at     DATETIME  NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
	PRIMARY KEY (review_id),
	CONSTRAINT fk_review_restaurant FOREIGN KEY (restaurant_id)
		REFERENCES restaurants (restaurant_id) ON DELETE CASCADE,
	CONSTRAINT fk_review_member FOREIGN KEY (member_id)
		REFERENCES members (member_id) ON DELETE CASCADE,
	CONSTRAINT ck_review_rating CHECK (rating BETWEEN 1 AND 5)
) COMMENT '리뷰';


-- ---------------------------------------------------------
-- 4. 맛집 사진 (맛집 하나에 여러 장, 최대 10장)
--    가장 먼저 올린 사진(image_id가 가장 작은 것)이 대표 사진
--    사진 파일은 서버의 upload 폴더에 저장하고 DB에는 파일 이름만 저장
--    맛집이 삭제되면 사진 정보도 함께 삭제
-- ---------------------------------------------------------
CREATE TABLE restaurant_images (
	image_id       INT          NOT NULL AUTO_INCREMENT COMMENT '사진 번호',
	restaurant_id  INT          NOT NULL COMMENT '어느 맛집의 사진인지',
	file_name      VARCHAR(200) NOT NULL COMMENT 'upload 폴더에 저장된 파일 이름',
	created_at     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '올린 날짜',
	PRIMARY KEY (image_id),
	CONSTRAINT fk_image_restaurant FOREIGN KEY (restaurant_id)
		REFERENCES restaurants (restaurant_id) ON DELETE CASCADE
) COMMENT '맛집 사진';


-- ---------------------------------------------------------
-- 5. 찜 (회원이 마음에 드는 맛집을 저장)
--    (회원, 맛집) 두 컬럼을 합쳐서 기본키로 써서 같은 맛집을 두 번 찜할 수 없음
--    회원이나 맛집이 삭제되면 찜 정보도 함께 삭제
-- ---------------------------------------------------------
CREATE TABLE favorites (
	member_id      INT       NOT NULL COMMENT '찜한 회원',
	restaurant_id  INT       NOT NULL COMMENT '찜한 맛집',
	created_at     DATETIME  NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '찜한 날짜',
	PRIMARY KEY (member_id, restaurant_id),
	CONSTRAINT fk_favorite_member FOREIGN KEY (member_id)
		REFERENCES members (member_id) ON DELETE CASCADE,
	CONSTRAINT fk_favorite_restaurant FOREIGN KEY (restaurant_id)
		REFERENCES restaurants (restaurant_id) ON DELETE CASCADE
) COMMENT '찜';


-- =========================================================
-- 샘플 데이터 (리뷰는 없음: 사이트에서 직접 작성해서 테스트)
-- 비밀번호는 연습용이라 그대로 저장했습니다.
--   관리자: admin / admin1234  (마스터 권한: 모든 맛집·리뷰 수정/삭제)
--   일반 회원: user1 ~ user4 / 1234  (맛집 등록, 리뷰 작성)
-- 회원가입으로는 항상 USER만 만들어지고,
-- 관리자는 DB에서 role을 'ADMIN'으로 직접 지정합니다.
-- =========================================================

INSERT INTO members (login_id, password, nickname, role, created_at) VALUES
('admin', 'admin1234', '관리자',         'ADMIN', '2026-10-15 10:00:00'),
('user1', '1234',      '맛집탐험가',     'USER',  '2026-10-16 12:30:00'),
('user2', '1234',      '국밥러버',       'USER',  '2026-10-17 18:10:00'),
('user3', '1234',      '점심메뉴고민중', 'USER',  '2026-10-18 09:45:00'),
('user4', '1234',      '디저트요정',     'USER',  '2026-10-19 15:20:00');

-- 실제 음식점 5곳 (주소·업종·메뉴·전화번호는 공개된 가게 정보 기준)
INSERT INTO restaurants (member_id, name, category, region, address, phone, description, created_at) VALUES
(2, '시장분식', '한식', '공주 산성동',
	'충남 공주시 산성시장2길 56-11', '0507-1341-7652',
	'공주 산성시장 안에 있는 식당입니다.\n보리밥과 선지해장국을 판매하며, 일요일은 쉽니다.',
	'2026-10-20 11:00:00'),
(3, '파시 대전본점', '일식', '대전 봉명동',
	'대전 유성구 온천북로33번길 10 104호', '0507-1488-9395',
	'유성온천역 근처 봉명동에 있는 초밥 전문점입니다.\n주방이 보이는 오픈 키친 다찌석과 테이블석이 있고, 프리미엄 스시·근본 스시 같은 초밥 세트와 참치마끼, 우동 등을 판매합니다.',
	'2026-10-21 11:00:00'),
(4, '성심당 케익부띠끄 롯데백화점 대전점', '카페', '대전 괴정동',
	'대전 서구 계룡로 598, 1층', '042-229-5343',
	'롯데백화점 대전점 1층에 있는 성심당의 케이크·디저트 매장입니다.\n롤케이크, 파운드케이크, 카스텔라 같은 케이크류와 쿠키, 마카롱 등 디저트를 판매합니다.',
	'2026-10-22 11:00:00'),
(5, '성심당 DCC점', '카페', '대전 도룡동',
	'대전 유성구 엑스포로 107', '042-220-4198',
	'대전컨벤션센터(DCC)에 있는 성심당 매장입니다.\n1층은 베이커리, 2층은 브런치 카페로 운영되며 DCC점에서만 파는 빵도 있습니다.',
	'2026-10-23 11:00:00'),
(2, '미사리밀빛초계국수 가산하이시티점', '한식', '서울 가산동',
	'서울 금천구 가산디지털1로 131 BYC하이시티 지하 1층', '0507-1448-7102',
	'가산디지털단지 BYC하이시티 지하 1층에 있는 초계국수 전문점입니다.\n초계국수, 비빔국수, 얼큰이 칼국수, 닭반마리 칼국수, 들깨 닭칼국수 등을 판매합니다.',
	'2026-10-24 11:00:00');

-- 가게 사진 (파일은 webapp/upload 폴더에 있음, 가게마다 첫 번째 사진이 대표 사진)
INSERT INTO restaurant_images (restaurant_id, file_name) VALUES
(1, 'shop1_1.jpg'),
(1, 'shop1_2.jpg'),
(1, 'shop1_3.jpg'),
(2, 'shop2_1.jpg'),
(2, 'shop2_2.jpg'),
(2, 'shop2_3.jpg'),
(2, 'shop2_4.jpg'),
(3, 'shop3_1.jpg'),
(3, 'shop3_2.jpg'),
(4, 'shop4_1.jpg'),
(4, 'shop4_2.jpg'),
(4, 'shop4_3.jpg'),
(5, 'shop5_1.jpg'),
(5, 'shop5_2.jpg'),
(5, 'shop5_3.jpg'),
(5, 'shop5_4.jpg'),
(5, 'shop5_5.jpg');

-- 리뷰와 찜은 넣지 않았습니다. 사이트에서 직접 해 보세요.
