<!--
list.jsp (목록 조회 페이지)
MockAPI에 get요청을 보내서 전체 데이터를 받아온다음 출력하는 코드
1. API 호출: Java 코드를 사용해서 MockAPI의 엔드포인트에 GET 요청을 보낸다.
2. 데이터 처리: 응답 받은 JSON 문자열을 파싱하여 게시글 목록(List<Item>)으로 변환한다.
출력: HTML <table> 태그와 JSP 반복문을 사용하여 목록을 출력한다.
링크: 제목에 view.jsp?id=글번호, "새 글 작성" 버튼에 write.html 링크를 연결해서 add 기능을 구현할 수 있도록 한다.
>

<%-- list.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.URL, java.net.HttpURLConnection, java.io.*, java.util.*" %>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper" %>
<%@ page import="com.fasterxml.jackson.core.type.TypeReference" %>

<%
    // ⚠️ 1. 수정된 MockAPI 엔드포인트 설정 (올바른 ID와 리소스 'db' 반영)
    final String API_ENDPOINT = "https://68e126f893207c4b47966580.mockapi.io/db";

    // JSON 파싱 결과를 담을 리스트 (게시글 목록)
    List<Map<String, Object>> boardList = new ArrayList<>();

    try {
        // 2. HTTP GET 요청 준비
        URL url = new URL(API_ENDPOINT);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Accept", "application/json");

        // 3. 응답 읽기
        if (conn.getResponseCode() == HttpURLConnection.HTTP_OK) {

            // 응답 스트림을 UTF-8로 읽어들이기
            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
            StringBuilder response = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                response.append(line);
            }
            br.close();

            // 4. JSON 파싱 (Jackson ObjectMapper 사용)
            ObjectMapper mapper = new ObjectMapper();

            // JSON 배열을 List<Map> 형태로 파싱
            boardList = mapper.readValue(response.toString(),
                    new TypeReference<List<Map<String, Object>>>() {});

        } else {
            // API 오류 처리
            out.println("<p style='color:red;'>API 호출 실패: 응답 코드 " + conn.getResponseCode() + "</p>");
        }
        conn.disconnect();
    } catch (Exception e) {
        // 네트워크 또는 파싱 오류 처리
        out.println("<p style='color:red;'>데이터 로딩 중 오류 발생: " + e.getMessage() + "</p>");
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시판 목록</title>
    <style>
        table { width: 80%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: center; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>
    <h2>게시판 목록</h2>

    <a href="write.html">새 글 작성</a>

    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>제목</th>
                <th>작성자</th>
                <th>작성일</th>
                <th>기능</th>
            </tr>
        </thead>
        <tbody>
            <%
                // 6. 목록 반복 출력
                for (Map<String, Object> item : boardList) {
                    // MockAPI ID는 문자열일 수 있으므로 String으로 처리
                    String itemId = String.valueOf(item.get("id"));
            %>
<tr>
<td><%= itemId %></td>
<td>
<a href="view.jsp?id=<%= itemId %>">
<%= item.get("title") %>
</a>
</td>
<td><%= item.get("writer") %></td>
<td><%= item.get("createdAt") %></td>
<td>
<a href="edit.html?id=<%= itemId %>">수정</a> /
<a href="delete_ok.jsp?id=<%= itemId %>">삭제</a>
</td>
</tr>
<% } %>
<% if (boardList.isEmpty()) { %>
<tr>
<td colspan="5">등록된 게시글이 없습니다.</td>
</tr>
<% } %>
</tbody>
</table>
</body>
</html>