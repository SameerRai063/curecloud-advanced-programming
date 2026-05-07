<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.hospital.hospitalmanagementsystem.rating.model.Rating" %>
<%@ page import="com.hospital.hospitalmanagementsystem.rating.util.AuthUtil" %>
<%
    if (!AuthUtil.isLoggedIn(request)) {
        response.sendRedirect(request.getContextPath() + "/LoginServlet");
        return;
    }
    if (!AuthUtil.isDoctor(request)) {
        response.sendRedirect(request.getContextPath() + "/rating/rating-success.jsp?message=Access%20Denied");
        return;
    }

    @SuppressWarnings("unchecked")
    List<Rating> ratings = (List<Rating>) request.getAttribute("ratings");
    if (ratings == null) ratings = Collections.emptyList();

      String doctorName = (String) request.getAttribute("doctorName");
      String doctorPhoto = (String) request.getAttribute("doctorPhoto");
      if ((doctorPhoto == null || doctorPhoto.isBlank()) && !ratings.isEmpty()) {
        Rating firstRating = ratings.isEmpty() ? null : ratings.get(0);
        doctorPhoto = firstRating == null ? null : firstRating.getDoctorPhoto();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Doctor Ratings - Upachar</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/rating/rating.css">
</head>
<body>
<div class="page">
    <div class="topbar">
        <h1>Upachar • Doctor Ratings</h1>
        <div class="sub">Feedback received from patients</div>
    </div>

    <div class="card">
        <div class="doctor-meta" style="margin-bottom:14px">
            <img class="avatar avatar-lg" src="<%= doctorPhoto == null ? "" : doctorPhoto %>" alt="Doctor photo">
            <div>
                <h2 style="margin:0 0 6px"><%= doctorName == null ? "Doctor" : doctorName %></h2>
                <div class="muted">Ratings received: <b><%= ratings.size() %></b></div>
            </div>
        </div>

        <div style="overflow:auto">
            <table class="table">
                <thead>
                <tr>
                    <th>Patient</th>
                    <th>Appointment Date</th>
                    <th>Rating</th>
                    <th>Review</th>
                    <th>Submitted</th>
                </tr>
                </thead>
                <tbody>
                <% if (ratings.isEmpty()) { %>
                <tr><td colspan="5" class="muted">No ratings found.</td></tr>
                <% } %>
                <% for (Rating r : ratings) { %>
                    <tr>
                        <td>
                            <b><%= r.getPatientName() == null ? ("Patient #" + r.getPatientId()) : r.getPatientName() %></b>
                            <div class="muted">Patient ID: <%= r.getPatientId() %></div>
                        </td>
                        <td><%= r.getAppointmentDate() == null ? "-" : r.getAppointmentDate() %></td>
                        <td>
                            <span class="stars-read">
                                <% for(int i=1;i<=5;i++){ %>
                                    <% if (i <= r.getScore()) { %><span class="on">★</span><% } else { %><span class="off">★</span><% } %>
                                <% } %>
                            </span>
                            <div class="muted"><%= r.getScore() %>/5</div>
                        </td>
                        <td><%= (r.getReview() == null || r.getReview().isBlank()) ? "<span class='muted'>—</span>" : r.getReview() %></td>
                        <td><%= r.getCreatedAt() == null ? "-" : r.getCreatedAt() %></td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>

        <div class="actions">
            <a class="btn" href="<%=request.getContextPath()%>/DoctorRatingServlet">Refresh</a>
        </div>
    </div>
</div>
</body>
</html>

