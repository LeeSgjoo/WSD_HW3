<!---
view.jsp (상세 조회 페이지)
ID 수신: URL에서 request.getParameter("id")를 사용해 조회할 글번호를 캐치한다.
API 호출: MockAPI에 GET /board/{id} 형태로 요청을 보내고 해당 글의 JSON을 받아온다.
출력: 받아온 데이터를 출력한다.
링크: "수정" 버튼에 edit.html?id=글번호, "삭제" 버튼에 delete_ok.jsp?id=글번호 링크를 연결해서
delete 기능을 구현할 수 있게 한다.
>