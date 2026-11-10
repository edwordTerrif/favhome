<%@ page pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, java.io.*, java.net.URLEncoder"%>
<%!
	// ===== 모든 페이지에서 같이 쓰는 함수 =====

	// 회원이 쓴 글을 그대로 출력하면 <script> 같은 태그가 실행될 수 있어서
	// 특수문자를 바꿔서 출력한다
	String esc(Object value) {
		if (value == null) return "";
		return value.toString()
				.replace("&", "&amp;")
				.replace("<", "&lt;")
				.replace(">", "&gt;")
				.replace("\"", "&quot;")
				.replace("'", "&#39;");
	}

	// 숫자 파라미터 읽기 (없거나 숫자가 아니면 기본값)
	int toInt(String value, int defaultValue) {
		try {
			return Integer.parseInt(value);
		} catch (Exception e) {
			return defaultValue;
		}
	}

	// null이면 빈 문자열, 아니면 앞뒤 공백 제거
	String trim(String value) {
		return value == null ? "" : value.trim();
	}

	// 주소에 넣을 글자 (한글, 공백 등) 바꾸기
	String enc(String value) {
		try {
			return URLEncoder.encode(value == null ? "" : value, "UTF-8");
		} catch (Exception e) {
			return "";
		}
	}

	// 별점 숫자 → ★★★★☆
	String stars(int rating) {
		String result = "";
		for (int i = 1; i <= 5; i++) {
			result += (i <= rating) ? "★" : "☆";
		}
		return result;
	}

	// 평균 별점 → 4.7 처럼 소수 첫째 자리까지
	String avgText(double avg) {
		return String.format("%.1f", avg);
	}

	// 날짜 → 2026.11.10
	String dateText(Timestamp time) {
		if (time == null) return "";
		return new java.text.SimpleDateFormat("yyyy.MM.dd").format(time);
	}

	// 사진이 있으면 <img>, 없으면 카테고리별 기본 그림
	String thumb(String image, String category) {
		if (image != null && !image.isEmpty()) {
			return "<img src=\"upload/" + esc(image) + "\" alt=\"\">";
		}
		if ("한식".equals(category)) return "🍚";
		if ("중식".equals(category)) return "🥟";
		if ("일식".equals(category)) return "🍣";
		if ("양식".equals(category)) return "🍝";
		if ("분식".equals(category)) return "🍢";
		if ("카페".equals(category)) return "☕";
		return "🍽️";
	}

	// 알림창을 띄우고 이전 화면으로 돌아가기
	void alertBack(JspWriter out, String message) throws IOException {
		out.println("<script>alert('" + message + "'); history.back();</script>");
	}

	// 알림창을 띄우고 다른 페이지로 이동
	void alertGo(JspWriter out, String message, String url) throws IOException {
		out.println("<script>alert('" + message + "'); location.href='" + url + "';</script>");
	}
%>
<%
	// 한글 깨짐 방지
	request.setCharacterEncoding("UTF-8");

	// 로그인 정보 (login_process.jsp에서 세션에 저장한 값)
	Integer loginId = (Integer) session.getAttribute("memberId");
	String loginNickname = (String) session.getAttribute("nickname");
	boolean isLogin = (loginId != null);
	boolean isAdmin = "ADMIN".equals(session.getAttribute("role"));
%>
