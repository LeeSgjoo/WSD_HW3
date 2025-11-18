<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.URL" %>
<%@ page import="java.net.HttpURLConnection" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="java.io.OutputStream" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONObject" %>

<%!
    private final String API_BASE_URL = "https://68e126f893207c4b47966580.mockapi.io/db";

    /**
     * GET 요청 (데이터 조회: 목록, 상세)
     */
    public String getApi(String path) {
        try {
            URL url = new URL(API_BASE_URL + path);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Accept", "application/json");

            if (conn.getResponseCode() != 200) return "[]";

            BufferedReader br = new BufferedReader(new InputStreamReader((conn.getInputStream())));
            String output;
            StringBuilder response = new StringBuilder();
            while ((output = br.readLine()) != null) response.append(output);
            conn.disconnect();
            return response.toString();

        } catch (Exception e) {
            return "[]";
        }
    }

    /**
     * POST, PUT, DELETE 요청 (데이터 추가, 수정, 삭제)
     */
    public String postPutDeleteApi(String path, String method, String jsonInput) {
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

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <!-- 뷰포트 설정 (Bootstrap 반응형 필수) -->
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>학생 리소스 목록</title>

    <!-- ⭐️ Bootstrap CSS CDN 추가 ⭐️ -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet"
          xintegrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
          crossorigin="anonymous">
</head>
<body>

<!-- ⭐️ Bootstrap 컨테이너 적용 (페이지 중앙 정렬 및 여백) ⭐️ -->
<div class="container mt-5">
    <h2 class="mb-4 text-primary">학생 리소스 목록</h2>

    <!-- 버튼 스타일 적용 -->
    <a href="write.html" class="btn btn-success mb-3">새 리소스 작성 클릭</a>
    <button onclick="location.href='list.jsp'" class="btn btn-secondary mb-3">목록 새로고침</button>

    <!-- 테이블 스타일 적용 -->
    <table class="table table-striped table-hover table-bordered">
        <thead>
        <tr class="table-dark">
            <th>id (번호)</th>
            <th>name (이름)</th>
            <th>age (나이)</th>
            <th>major (전공)</th>
            <th>rc (생활관)</th>
            <th>hometown (고향)</th>
            <th>메뉴</th>
        </tr>
        </thead>
        <tbody>
        <%
            // Controller/Logic 부분: API 호출 및 데이터 파싱
            String jsonString = getApi("");
            JSONArray jsonArray = new JSONArray(jsonString);

            for (int i = 0; i < jsonArray.length(); i++) {
                JSONObject post = jsonArray.getJSONObject(i);

                // 실제 API JSON 필드명 그대로 추출
                String id = post.getString("id");               // id (번호)
                String name = post.getString("name");           // name (이름)
                String age = String.valueOf(post.getInt("age")); // age (나이)
                String major = post.getString("major");         // major (전공)
                String rc = post.getString("rc");               // rc (생활관)
                String hometown = post.getString("hometown");   // hometown (고향)
        %>
        <tr>
            <td><%= id %></td>
            <!-- 상세보기 링크 -->
            <td><a href="view.jsp?id=<%= id %>"><%= name %></a></td>
            <td><%= age %></td>
            <td><%= major %></td>
            <td><%= rc %></td>
            <td><%= hometown %></td>
            <td>
                <!-- 버튼 그룹 스타일 적용 -->
                <div class="btn-group btn-group-sm" role="group">
                    <a href="edit.html?id=<%= id %>" class="btn btn-warning">수정</a>
                    <a href="delete_ok.jsp?id=<%= id %>"
                       onclick="return confirm('삭제하시겠습니까?');"
                       class="btn btn-danger">삭제</a>
                </div>
            </td>
        </tr>
        <%
            } // end of for loop
        %>
        </tbody>
    </table>
</div>

<!-- ⭐️ Bootstrap JS CDN 추가 (</body> 닫는 태그 직전에 위치) ⭐️ -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        xintegrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>
</body>
</html>