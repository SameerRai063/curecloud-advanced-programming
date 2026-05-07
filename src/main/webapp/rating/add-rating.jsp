<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.hospital.hospitalmanagementsystem.rating.util.AuthUtil" %>
<%
    // Patient-only page (basic guard; servlet also enforces)
    if (!AuthUtil.isLoggedIn(request)) {
        response.sendRedirect(request.getContextPath() + "/rating/rating-success.jsp?message=Please%20login%20first");
        return;
    }
    if (!AuthUtil.isPatient(request)) {
        response.sendRedirect(request.getContextPath() + "/rating/rating-success.jsp?message=Access%20Denied");
        return;
    }

    String appointmentId = request.getParameter("appointmentId");
    String doctorId = request.getParameter("doctorId");
    String doctorName = request.getParameter("doctorName");
    String appointmentDate = request.getParameter("appointmentDate");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Add Doctor Rating - Upachar</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/rating/rating.css">
</head>
<body>
<div class="page">
    <div class="topbar">
        <h1>Upachar • Add Rating</h1>
        <div class="sub">Rate your doctor after a completed appointment</div>
    </div>

    <div class="card">
        <div class="meta">
            <span class="chip"><b>Doctor:</b> <%= (doctorName != null && !doctorName.isBlank()) ? doctorName : ("#" + (doctorId == null ? "" : doctorId)) %></span>
            <span class="chip"><b>Appointment:</b> <%= (appointmentId == null ? "" : appointmentId) %></span>
            <span class="chip"><b>Date:</b> <%= (appointmentDate == null ? "-" : appointmentDate) %></span>
        </div>

        <% if (error != null && !error.isBlank()) { %>
            <div class="alert"><b>Error:</b> <%= error %></div>
        <% } %>

        <form method="post" action="<%=request.getContextPath()%>/AddRatingServlet">
            <div class="grid" style="margin-top:14px">
                <div class="field">
                    <label for="appointmentId">Appointment ID (required)</label>
                    <input id="appointmentId" type="number" name="appointmentId" required min="1" value="<%= appointmentId == null ? "" : appointmentId %>">
                </div>
                <div class="field">
                    <label for="doctorId">Doctor ID (optional if appointment is valid)</label>
                    <input id="doctorId" type="number" name="doctorId" min="1" value="<%= doctorId == null ? "" : doctorId %>">
                </div>
            </div>

            <div class="field" style="margin-top:12px">
                <label>Rating (1 to 5)</label>
                <div class="star-input" aria-label="Star rating">
                    <input type="radio" id="star5" name="score" value="5" required><label for="star5" title="5 stars"></label>
                    <input type="radio" id="star4" name="score" value="4"><label for="star4" title="4 stars"></label>
                    <input type="radio" id="star3" name="score" value="3"><label for="star3" title="3 stars"></label>
                    <input type="radio" id="star2" name="score" value="2"><label for="star2" title="2 stars"></label>
                    <input type="radio" id="star1" name="score" value="1"><label for="star1" title="1 star"></label>
                </div>
                <div class="muted" style="margin-top:6px;font-size:13px">Tip: Hover and click to choose stars.</div>
            </div>

            <div class="field" style="margin-top:12px">
                <label for="review">Review</label>
                <textarea id="review" name="review" maxlength="1000" placeholder="Write your experience (optional)"></textarea>
            </div>

            <div class="actions">
                <button type="submit" class="btn btn-primary">Submit Rating</button>
                <a class="btn" href="<%=request.getContextPath()%>/ViewRatingServlet">Back to Ratings</a>
            </div>
        </form>
    </div>
</div>
</body>
</html>

