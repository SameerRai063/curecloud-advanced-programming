<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.hospital.hospitalmanagementsystem.rating.util.AuthUtil" %>
<%
    if (!AuthUtil.isLoggedIn(request)) {
        // Redirect to the interactive login page (LoginServlet expects POST; use the JSP login form)
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    if (AuthUtil.isDoctor(request)) {
        response.sendRedirect(request.getContextPath() + "/DoctorRatingServlet");
        return;
    }

    if (AuthUtil.isAdmin(request)) {
        response.sendRedirect(request.getContextPath() + "/ViewRatingServlet");
        return;
    }

    if (AuthUtil.isPatient(request)) {
        response.sendRedirect(request.getContextPath() + "/ViewRatingServlet");
        return;
    }

    response.sendRedirect(request.getContextPath() + "/LoginServlet");
%>
