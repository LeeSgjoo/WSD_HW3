<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.URL" %>
<%@ page import="java.net.HttpURLConnection" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="java.io.OutputStream" %>
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

            // 응답 코드가 201 (Created) 또는 200 (OK)이 아닐 경우 오류 처리 로직 추가 가능

            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"));
            String output;
            StringBuilder response = new StringBuilder();
            while ((output = br.readLine()) != null) {
                response.append(output.trim());
            }
            conn.disconnect();
            return response.toString();

        } catch (Exception e) {
            return "{\"status\": \"error\", \"message\": \"" + e.getMessage() + "\"}";
        }
    }
%>

<!-- -------------------------------------------------------- -->

<%
    // Controller/Logic 부분: 데이터 추출 및 Mock API 요청

    // 1. 요청 인코딩 설정 (한글 처리 필수)
    request.setCharacterEncoding("UTF-8");

    // 2. Form 데이터 추출 (request 내장 객체 사용)
    String name = request.getParameter("name");
    String age = request.getParameter("age");
    String major = request.getParameter("major");
    String rc = request.getParameter("rc");
    String hometown = request.getParameter("hometown");

    // 3. Mock API 전송을 위한 JSON 데이터 구성
    String jsonInput = String.format(
            "{\"name\": \"%s\", \"age\": %s, \"major\": \"%s\", \"rc\": \"%s\", \"hometown\": \"%s\"}",
            name, age, major, rc, hometown
    );

    // 4. Mock API로 POST 요청 전송
    String responseJson = postPutDeleteApi("", "POST", jsonInput);

    // 5. 응답 JSON에서 새로 생성된 ID 추출 및 페이지 이동
    String newId = "0"; // 기본값 설정
    try {
        //  변수명을 'jsonResponse'로 변경하여 충돌 해결
        JSONObject jsonResponse = new JSONObject(responseJson);
        // Mock API가 생성한 ID를 "id" 필드로 반환한다고 가정합니다.
        newId = jsonResponse.getString("id");
    } catch (Exception e) {
        response.sendRedirect("list.jsp");
        return;
    }

    // 6. 저장 완료 후 상세 보기 페이지로 이동 (response 내장 객체 사용)
    response.sendRedirect("view.jsp?id=" + newId);
%>