<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.hospital.hospitalmanagementsystem.rating.model.Rating" %>
<%@ page import="com.hospital.hospitalmanagementsystem.rating.util.AuthUtil" %>
<%
    if (!AuthUtil.isLoggedIn(request)) {
        response.sendRedirect(request.getContextPath() + "/rating/rating-success.jsp?message=Please%20login%20first");
        return;
    }
    if (!AuthUtil.isPatient(request) && !AuthUtil.isAdmin(request)) {
        response.sendRedirect(request.getContextPath() + "/rating/rating-success.jsp?message=Access%20Denied");
        return;
    }

    Rating rating = (Rating) request.getAttribute("rating");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Rating - Upachar</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/rating/rating.css">
</head>
<body>
<div class="page">
    <div class="topbar">
        <h1>Upachar • Edit Rating</h1>
        <div class="sub">Update your rating and review</div>
    </div>

    <div class="card">
        <% if (error != null && !error.isBlank()) { %>
            <div class="alert"><b>Error:</b> <%= error %></div>
        <% } %>

        <% if (rating == null) { %>
            <div class="alert"><b>Error:</b> Rating not found.</div>
            <div class="actions">
                <a class="btn" href="<%=request.getContextPath()%>/ViewRatingServlet">Back</a>
            </div>
        <% } else { %>
            <div class="meta">
                <span class="chip"><b>Doctor:</b> <%= rating.getDoctorName() == null ? ("Doctor #" + rating.getDoctorId()) : rating.getDoctorName() %></span>
                <span class="chip"><b>Appointment:</b> <%= rating.getAppointmentId() %></span>
                <span class="chip"><b>Date:</b> <%= rating.getAppointmentDate() == null ? "-" : rating.getAppointmentDate() %></span>
            </div>

            <form method="post" action="<%=request.getContextPath()%>/UpdateRatingServlet" style="margin-top:14px">
                <input type="hidden" name="id" value="<%=rating.getId()%>">

                <div class="field">
                    <label>Rating (1 to 5)</label>
                    <div class="star-input">
                        <input type="radio" id="e5" name="score" value="5" <%= rating.getScore()==5 ? "checked" : "" %> required><label for="e5"></label>
                        <input type="radio" id="e4" name="score" value="4" <%= rating.getScore()==4 ? "checked" : "" %>><label for="e4"></label>
                        <input type="radio" id="e3" name="score" value="3" <%= rating.getScore()==3 ? "checked" : "" %>><label for="e3"></label>
                        <input type="radio" id="e2" name="score" value="2" <%= rating.getScore()==2 ? "checked" : "" %>><label for="e2"></label>
                        <input type="radio" id="e1" name="score" value="1" <%= rating.getScore()==1 ? "checked" : "" %>><label for="e1"></label>
                    </div>
                </div>

                <div class="field" style="margin-top:12px">
                    <label for="review">Review</label>
                    <textarea id="review" name="review" maxlength="1000"><%= rating.getReview() == null ? "" : rating.getReview() %></textarea>
                </div>

                <div class="actions">
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                    <a class="btn" href="<%=request.getContextPath()%>/ViewRatingServlet">Cancel</a>
                </div>
            </form>
        <% } %>
    </div>
</div>
</body>
</html>

