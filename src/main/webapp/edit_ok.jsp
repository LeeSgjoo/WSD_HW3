<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.URL" %>
<%@ page import="java.net.HttpURLConnection" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="java.io.OutputStream" %>
<%@ page import="org.json.JSONObject" %>

<%!
    // JSP Declaration Tag: API 통신 함수들을 멤버 메서드로 정의 (list.jsp/view.jsp와 동일)
    // ⚠️ 경고: 이 URL을 실제 스키마 데이터를 반환하는 Mock API의 URL로 변경해야 합니다.
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

            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"));
            String output;
            StringBuilder response = new StringBuilder();
            while ((output = br.readLine()) != null) response.append(output.trim());
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

    // 2. Form 데이터 추출 (수정 대상 ID 포함)
    String id = request.getParameter("id"); // Hidden 필드에서 추출
    String name = request.getParameter("name");
    String age = request.getParameter("age");
    String major = request.getParameter("major");
    String rc = request.getParameter("rc");
    String hometown = request.getParameter("hometown");

    // 3. Mock API 전송을 위한 JSON 데이터 구성 (수정할 모든 필드 포함)
    // age는 Number 타입이므로 따옴표를 제거합니다.
    String jsonInput = String.format(
            "{\"id\": \"%s\", \"name\": \"%s\", \"age\": %s, \"major\": \"%s\", \"rc\": \"%s\", \"hometown\": \"%s\"}",
            id, name, age, major, rc, hometown
    );

    // 4. Mock API로 PUT 요청 전송 (CRUD 흐름도: 저장 클릭 -> 수정실행)
    // PUT /students/[id] 엔드포인트를 사용합니다.
    String responseJson = postPutDeleteApi("/" + id, "PUT", jsonInput);

    // 5. 수정 완료 후 상세 보기 페이지로 이동 (response 내장 객체 사용)
    // (과제 흐름도: 수정실행 -> 상세보기 view.jsp)
    response.sendRedirect("view.jsp?id=" + id);
%>