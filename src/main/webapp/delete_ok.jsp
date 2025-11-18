<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.URL" %>
<%@ page import="java.net.HttpURLConnection" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="java.io.OutputStream" %>

<%!
    private final String API_BASE_URL = "https://68e126f893207c4b47966580.mockapi.io/db";

    /**
     * GET 요청 (데이터 조회: 목록, 상세)
     */
    public String getApi(String path) {
        // DELETE 실행 시 GET은 사용하지 않지만, Declaration Tag는 모든 JSP에 동일하게 복사됨
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

            // DELETE 요청은 body(jsonInput)가 필요 없을 수 있지만, 함수 형태 유지를 위해 포함
            if (jsonInput != null && !jsonInput.isEmpty()) {
                try (OutputStream os = conn.getOutputStream()) {
                    byte[] input = jsonInput.getBytes("utf-8");
                    os.write(input, 0, input.length);
                }
            }

            // 응답 스트림 읽기 (삭제 성공은 보통 204 No Content나 200 OK)
            // 성공 응답 시에는 내용이 없을 수 있으므로 try-catch로 예외 처리 권장

            // 단순화를 위해 응답 코드가 200 범위가 아니면 오류 발생하도록 처리
            int responseCode = conn.getResponseCode();
            if (responseCode >= 400) {
                // 실제 구현 시 여기서 로그를 남기거나 에러를 던져야 함
                return "{\"status\": \"error\", \"code\": " + responseCode + "}";
            }

            // 응답 본문을 읽어오지만, DELETE는 보통 빈 응답을 반환
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
    // Controller/Logic 부분: 삭제 대상 ID 추출 및 Mock API 요청

    // 1. 삭제 대상 ID 추출
    String id = request.getParameter("id");

    // 2. Mock API로 DELETE 요청 전송 (CRUD 흐름도: 삭제 클릭 -> 삭제실행)
    // DELETE /students/[id] 엔드포인트를 사용합니다.
    String responseJson = postPutDeleteApi("/" + id, "DELETE", null); // DELETE는 body 없음

    // 3. 삭제 완료 후 목록 페이지로 이동 (response 내장 객체 사용)
    // (과제 흐름도: 삭제실행 -> 목록보기 list.jsp)
    response.sendRedirect("list.jsp");
%>