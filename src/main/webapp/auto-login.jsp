<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Auto Login (development only)</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 24px; }
        .card { max-width:600px; margin:20px auto; padding:16px; border:1px solid #ddd; border-radius:8px }
        .btn { display:inline-block; margin:6px; padding:8px 12px; background:#1d4ed8; color:white; text-decoration:none; border-radius:4px }
        .note { color:#555; font-size:0.95em }
    </style>
</head>
<body>
<div class="card">
    <h2>Auto Login (development)</h2>
    <p class="note">Use these links to create a session for a seeded user and open the ratings pages without entering credentials. Do NOT enable in production.</p>

    <div>
        <a class="btn" href="<%=request.getContextPath()%>/AutoLoginServlet?user=admin&redirect=/rating/view-ratings.jsp">Login as admin</a>
        <a class="btn" href="<%=request.getContextPath()%>/AutoLoginServlet?user=patient1&redirect=/rating/patient-ratings.jsp">Login as patient1</a>
        <a class="btn" href="<%=request.getContextPath()%>/AutoLoginServlet?user=doctor1&redirect=/rating/doctor-ratings.jsp">Login as doctor1</a>
    </div>

    <hr>
    <h4>If you saw "HTTP Status 405 - Method Not Allowed"</h4>
    <p class="note">That happened because you opened <code>/LoginServlet</code> in the browser using GET. The real login endpoint is implemented to accept POST only (it's used by an AJAX/form submit). Use the links above (they call <code>/AutoLoginServlet</code>) or submit a POST to <code>/LoginServlet</code> instead.</p>

    <h4>Manual POST examples</h4>
    <pre class="note">curl -X POST -d "username=patient1&password=patient" http://localhost:8080/LoginServlet</pre>

    <p class="note">After using a link, you will be redirected to the selected ratings page as that user.</p>
</div>
</body>
</html>

