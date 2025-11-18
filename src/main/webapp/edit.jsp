<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.URL" %>
<%@ page import="java.net.HttpURLConnection" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="java.io.OutputStream" %>
<%@ page import="org.json.JSONObject" %>

<%!
// JSP Declaration Tag: API 통신 함수 (view.jsp와 동일)
private final String API_BASE_URL = "https://68e126f893207c4b47966580.mockapi.io/db";

/**
* GET 요청 (데이터 조회)
*/
public String getApi(String path) {
// [list.jsp 및 view.jsp의 getApi 로직 복사]
try {
URL url = new URL(API_BASE_URL + path);
HttpURLConnection conn = (HttpURLConnection) url.openConnection();
conn.setRequestMethod("GET");
conn.setRequestProperty("Accept", "application/json");

if (conn.getResponseCode() != 200) return "{}";

BufferedReader br = new BufferedReader(new InputStreamReader((conn.getInputStream())));
String output;
StringBuilder response = new StringBuilder();
while ((output = br.readLine()) != null) response.append(output);
conn.disconnect();
return response.toString();

} catch (Exception e) {
return "{}";
}
}

/**
* POST, PUT, DELETE 요청 (데이터 조작)
*/
public String postPutDeleteApi(String path, String method, String jsonInput) {
// [list.jsp 및 view.jsp의 postPutDeleteApi 로직 복사]
try {
URL url = new URL(API_BASE_URL + path);
HttpURLConnection conn = (HttpURLConnection) url.openConnection();
conn.setRequestMethod(method);
conn.setRequestProperty("Content-Type", "application/json");
conn.setDoOutput(true);

if (jsonInput != null && !jsonInput.isEmpty()) {
try (OutputStream os = conn.getOutputStream()) {
byte[] input = jsonInput.getBytes("utf-8");
os.write(input, 0, input.length);
}
}

BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"));
String output;
StringBuilder response = new StringBuilder();
while ((output = br.readLine()) != null) response.append(output.trim());
conn.disconnect();
return response.toString();

} catch (Exception e) {
return "{\"status\": \"error\"}";
}
}
%>

<!-- -------------------------------------------------------- -->

<%
request.setCharacterEncoding("UTF-8");

// 1. 요청 ID 추출
String id = request.getParameter("id");

// 2. Mock API로 GET 요청하여 기존 데이터 가져오기
String jsonString = getApi("/" + id);
JSONObject student = new JSONObject(jsonString);

// 3. JSON에서 스키마 필드 추출 및 기본값 설정
// optString을 사용하여 필드가 없을 경우 예외를 피하고 "N/A"를 반환하도록 합니다.
String current_name = student.optString("name", "");
String current_age = student.optString("age", "");
String current_major = student.optString("major", "");
String current_rc = student.optString("rc", "");
String current_hometown = student.optString("hometown", "");

// 데이터가 유효하지 않은 경우 목록으로 리다이렉트 처리 권장
if (current_name.isEmpty()) {
// response.sendRedirect("list.jsp");
// return;
}
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title><%= current_name %>님 정보 수정</title>

    <!-- Bootstrap CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet"
          xintegrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
          crossorigin="anonymous">
</head>
<body>

<div class="container mt-5">
    <h2 class="mb-4 text-warning">학생 리소스 수정 (ID: <%= id %>)</h2>

    <!--  Form 설정: action은 edit_ok.jsp, method는 POST  -->
    <!-- Hidden 필드로 수정 대상 ID를 함께 전송합니다. -->
    <form action="edit_ok.jsp" method="post" class="shadow p-4 rounded bg-light">

        <!-- 수정 대상 ID (사용자에게 보이지 않지만, 서버로 전송되어야 함) -->
        <input type="hidden" name="id" value="<%= id %>">

        <!-- 이름 (name) -->
        <div class="mb-3">
            <label for="name" class="form-label">이름 (name):</label>
            <!-- 기존 값을 value에 채워 넣습니다. -->
            <input type="text" class="form-control" id="name" name="name" value="<%= current_name %>" required>
        </div>

        <!-- 나이 (age) -->
        <div class="mb-3">
            <label for="age" class="form-label">나이 (age):</label>
            <input type="number" class="form-control" id="age" name="age" value="<%= current_age %>" required min="10" max="100">
        </div>

        <!-- 전공 (major) -->
        <div class="mb-3">
            <label for="major" class="form-label">전공 (major):</label>
            <input type="text" class="form-control" id="major" name="major" value="<%= current_major %>" required>
        </div>

        <!-- 생활관 (rc) -->
        <div class="mb-3">
            <label for="rc" class="form-label">생활관 (rc):</label>
            <input type="text" class="form-control" id="rc" name="rc" value="<%= current_rc %>" required>
        </div>

        <!-- 고향 (hometown) -->
        <div class="mb-3">
            <label for="hometown" class="form-label">고향 (hometown):</label>
            <input type="text" class="form-control" id="hometown" name="hometown" value="<%= current_hometown %>" required>
        </div>

        <!-- 버튼 그룹 -->
        <div class="mt-4">
            <input type="submit" value="저장 클릭" class="btn btn-warning me-2">
            <button type="button" onclick="location.href='view.jsp?id=<%= id %>'" class="btn btn-secondary">취소</button>
        </div>
    </form>
</div>

<!-- Bootstrap JS CDN -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>
</body>
</html>