<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.URL" %>
<%@ page import="java.net.HttpURLConnection" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="java.io.OutputStream" %>
<%@ page import="org.json.JSONObject" %>
<%-- org.json.JSONArray는 상세 조회에 필요 없으므로 JSONObject만 import --%>

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

            if (conn.getResponseCode() != 200) return "{}"; // 상세 조회는 단일 객체이므로 빈 객체 반환

            BufferedReader br = new BufferedReader(new InputStreamReader((conn.getInputStream())));
            String output;
            StringBuilder response = new StringBuilder();
            while ((output = br.readLine()) != null) response.append(output);
            conn.disconnect();
            return response.toString();

        } catch (Exception e) {
            return "{}"; // 예외 발생 시 빈 객체 반환
        }
    }

    /**
     * POST, PUT, DELETE 요청 (데이터 추가, 수정, 삭제)
     */
    public String postPutDeleteApi(String path, String method, String jsonInput) {
        // [list.jsp의 POST/PUT/DELETE 로직 복사]
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

    // 1. 요청 ID 추출 (list.jsp에서 전달받은 id 파라미터)
    String id = request.getParameter("id");

    // 2. Mock API로 GET 요청하여 상세 데이터 JSON 가져오기
    String jsonString = getApi("/" + id);

    JSONObject student = new JSONObject(jsonString);

    // 3. JSON에서 스키마 필드 추출 (추출 전에 필드 존재 여부 확인 로직 권장)
    String name = student.optString("name", "N/A");
    String age = student.optString("age", "N/A");
    String major = student.optString("major", "N/A");
    String rc = student.optString("rc", "N/A");
    String hometown = student.optString("hometown", "N/A");

    // "id"가 없거나 유효하지 않은 경우 처리
    if (name.equals("N/A") && !jsonString.equals("{}")) {
        // 만약 API가 데이터를 못찾았다고 응답했으나, 유효한 JSON을 보낸 경우
        // 이 부분에서 메시지를 설정하여 사용자에게 보여줄 수 있습니다.
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title><%= name %>님 상세 정보</title>

    <!-- Bootstrap CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet"
          xintegrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
          crossorigin="anonymous">
</head>
<body>

<div class="container mt-5">
    <h2 class="mb-4 text-info">학생 상세 정보 (ID: <%= id %>)</h2>
    <h3 class="mb-3"><%= name %></h3>

    <div class="card shadow-sm">
        <div class="card-body">
            <!-- 테이블 형식으로 상세 정보 출력 -->
            <table class="table table-bordered">
                <tbody>
                <tr>
                    <th scope="row" class="w-25">이름 (name)</th>
                    <td><%= name %></td>
                </tr>
                <tr>
                    <th scope="row">나이 (age)</th>
                    <td><%= age %></td>
                </tr>
                <tr>
                    <th scope="row">전공 (major)</th>
                    <td><%= major %></td>
                </tr>
                <tr>
                    <th scope="row">생활관 (rc)</th>
                    <td><%= rc %></td>
                </tr>
                <tr>
                    <th scope="row">고향 (hometown)</th>
                    <td><%= hometown %></td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>

    <!-- 버튼 그룹 -->
    <div class="mt-4">
        <button onclick="location.href='list.jsp'" class="btn btn-secondary me-2">목록 보기</button>
        <a href="edit.html?id=<%= id %>" class="btn btn-warning me-2">수정 클릭</a>
        <a href="delete_ok.jsp?id=<%= id %>"
           onclick="return confirm('<%= name %>님의 정보를 삭제하시겠습니까?');"
           class="btn btn-danger">삭제 클릭</a>
    </div>

</div>

<!-- Bootstrap JS CDN -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        xintegrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>
</body>
</html>