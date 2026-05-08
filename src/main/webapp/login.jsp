<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Login</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 24px; }
        .card { max-width:400px; margin:40px auto; padding:16px; border:1px solid #ddd; border-radius:8px }
        input[type=text], input[type=password] { width:100%; padding:8px; margin:8px 0; box-sizing:border-box }
        .btn { display:inline-block; padding:8px 12px; background:#1d4ed8; color:white; text-decoration:none; border-radius:4px; border:none }
        .error { color: #b91c1c }
    </style>
</head>
<body>
<div class="card">
    <h2>Login</h2>
    <c:if test="${param.error != null}">
        <p class="error">${param.error}</p>
    </c:if>
    <form method="post" action="<%=request.getContextPath()%>/LoginUserServlet">
        <label>Username</label>
        <input type="text" name="username" required />
        <label>Password</label>
        <input type="password" name="password" required />
        <div style="margin-top:12px">
            <button class="btn" type="submit">Login</button>
            <a style="margin-left:8px" href="<%=request.getContextPath()%>/auto-login.jsp" class="btn">Auto Login (dev)</a>
        </div>
    </form>
</div>
</body>
</html>

