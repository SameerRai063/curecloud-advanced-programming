<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String message = request.getParameter("message");
    if (message == null || message.isBlank()) message = "Done";
%>
<!DOCTYPE html>
<html>
<head>
    <title>Rating - Upachar</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/rating/rating.css">
</head>
<body>
<div class="page">
    <div class="topbar">
        <h1>Upachar • Rating</h1>
        <div class="sub">Status</div>
    </div>

    <div class="card">
        <div class="alert alert-ok"><b>Message:</b> <%= message %></div>
        <div class="actions">
            <a class="btn btn-primary" href="<%=request.getContextPath()%>/ViewRatingServlet">View Ratings</a>
            <a class="btn" href="<%=request.getContextPath()%>/rating/add-rating.jsp">Add Another Rating</a>
        </div>
    </div>
</div>
</body>
</html>

