<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.hospital.hospitalmanagementsystem.rating.model.Rating" %>
<%@ page import="com.hospital.hospitalmanagementsystem.rating.util.AuthUtil" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%
    if (!AuthUtil.isLoggedIn(request)) {
        response.sendRedirect(request.getContextPath() + "/LoginServlet");
        return;
    }
    if (!AuthUtil.isAdmin(request)) {
        response.sendRedirect(request.getContextPath() + "/rating/rating-success.jsp?message=Access%20Denied");
        return;
    }

    @SuppressWarnings("unchecked")
    List<Rating> ratings = (List<Rating>) request.getAttribute("ratings");
    if (ratings == null) ratings = Collections.emptyList();
    request.setAttribute("ratings", ratings);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Ratings - Upachar</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/rating/rating.css">
</head>
<body>
<div class="page">
    <div class="topbar">
        <h1>Upachar • Admin Ratings</h1>
        <div class="sub">All doctor ratings are visible here with full management actions.</div>
    </div>

    <div class="card">
        <div class="section-title">
            <div class="muted">Total: <b><%= ratings.size() %></b></div>
            <a class="btn btn-primary" href="<%=request.getContextPath()%>/ViewRatingServlet">Refresh</a>
        </div>

        <div style="overflow:auto">
            <table class="table">
                <thead>
                <tr>
                    <th>Doctor</th>
                    <th>Patient</th>
                    <th>Appointment Date</th>
                    <th>Rating</th>
                    <th>Review</th>
                    <th>Submitted</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:if test="${empty ratings}">
                    <tr><td colspan="7" class="muted">No ratings found.</td></tr>
                </c:if>

                <c:forEach var="r" items="${ratings}">
                    <tr>
                        <td>
                            <div class="doctor-meta">
                                <img class="avatar" src="${r.doctorPhoto}" alt="Doctor photo">
                                <div>
                                    <b>
                                        <c:choose>
                                            <c:when test="${empty r.doctorName}">Doctor #<c:out value="${r.doctorId}"/></c:when>
                                            <c:otherwise><c:out value="${r.doctorName}"/></c:otherwise>
                                        </c:choose>
                                    </b>
                                    <div class="muted">Doctor ID: <c:out value="${r.doctorId}"/></div>
                                </div>
                            </div>
                        </td>
                        <td>
                            <b>
                                <c:choose>
                                    <c:when test="${empty r.patientName}">Patient #<c:out value="${r.patientId}"/></c:when>
                                    <c:otherwise><c:out value="${r.patientName}"/></c:otherwise>
                                </c:choose>
                            </b>
                            <div class="muted">Patient ID: <c:out value="${r.patientId}"/></div>
                        </td>
                        <td><c:out value="${empty r.appointmentDate ? '-' : r.appointmentDate}"/></td>
                        <td>
                            <span class="stars-read" aria-label="Rating">
                                <c:forEach var="i" begin="1" end="5">
                                    <c:choose>
                                        <c:when test="${i <= r.score}"><span class="on">★</span></c:when>
                                        <c:otherwise><span class="off">★</span></c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </span>
                            <div class="muted"><c:out value="${r.score}"/>/5</div>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${empty r.review}"><span class="muted">—</span></c:when>
                                <c:otherwise><c:out value="${r.review}"/></c:otherwise>
                            </c:choose>
                        </td>
                        <td><c:out value="${empty r.createdAt ? '-' : r.createdAt}"/></td>
                        <td>
                            <div class="row-actions">
                                <a class="btn" href="<%=request.getContextPath()%>/UpdateRatingServlet?id=${r.id}">Edit</a>
                                <form method="post" action="<%=request.getContextPath()%>/DeleteRatingServlet" style="margin:0">
                                    <input type="hidden" name="id" value="${r.id}">
                                    <button type="submit" class="btn btn-danger" onclick="return confirm('Delete this rating?')">Delete</button>
                                </form>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>

