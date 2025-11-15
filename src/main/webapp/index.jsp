<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>JSP - Hello World</title>
</head>
<body>
<h1><%= "Hello World!" %></h1>
<br/>
<h1><%= "반드시 엘리먼트는 네임이 있어야 한다 form_ok.jsp 서버로 보낸 데이터를 처리하는 것" %>
</h1>
<h1><%= "바꼈다" %>

<form method = "get" action = "list.jsp">
    <label>사용자 이름 :</label> <input type = "text" name = "username">
    <input type = "submit" name = "전송">
</form>

<br/>
<a href="hello-servlet">Hello Servlet</a>
</body>
</html>