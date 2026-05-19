<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    String userName = (session.getAttribute("userName") != null) ? String.valueOf(session.getAttribute("userName")) : "Admin";
    String userRole = (session.getAttribute("userRole") != null) ? String.valueOf(session.getAttribute("userRole")) : "";
    String currentDate = LocalDate.now().format(DateTimeFormatter.ofPattern("MMM d, yyyy"));

    int totalReviews = 0;
    Object trObj = request.getAttribute("totalReviews");
    if (trObj instanceof Number) {
        totalReviews = ((Number) trObj).intValue();
    } else if (trObj instanceof String) {
        totalReviews = Integer.parseInt((String) trObj);
    }

    double averageRating = 0.0;
    Object arObj = request.getAttribute("averageRating");
    if (arObj instanceof Number) {
        averageRating = ((Number) arObj).doubleValue();
    } else if (arObj instanceof String) {
        averageRating = Double.parseDouble((String) arObj);
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Upachaar - Patient Reviews</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root {
            --primary-blue: #2554ff;
            --primary-teal: #0d7f6b;
            --bg-light: #f8fafc;
            --text-dark: #111827;
            --text-gray: #6b7280;
            --border-color: #e5e7eb;
            --sidebar-text-muted: #a0bafc;
            --table-header-bg: #e2f1ec;
            --table-header-text: #0b6b59;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Inter', sans-serif; }
        body { background-color: var(--bg-light); color: var(--text-dark); display: flex; height: 100vh; overflow: hidden; }

        .sidebar { width: 250px; background-color: var(--primary-blue); color: white; display: flex; flex-direction: column; justify-content: space-between; flex-shrink: 0; }
        .sidebar-top { padding: 24px 16px; }
        .brand h1 { font-size: 22px; font-weight: 700; letter-spacing: 0.5px; margin-bottom: 4px; }
        .brand p   { font-size: 12px; color: var(--sidebar-text-muted); margin-bottom: 32px; }
        .nav-menu { list-style: none; }
        .nav-item  { margin-bottom: 4px; }
        .nav-link { display: flex; align-items: center; padding: 12px 16px; color: white; text-decoration: none; font-size: 14px; font-weight: 500; border-radius: 8px; transition: all 0.2s; }
        .nav-link i { width: 20px; margin-right: 12px; font-size: 16px; text-align: center; }
        .nav-item.active .nav-link { background-color: white; color: var(--primary-blue); }
        .nav-link:hover:not(.active) { background-color: rgba(255,255,255,0.1); }

        .sidebar-bottom { padding: 20px 16px; }
        .user-profile { display: flex; align-items: center; padding-top: 16px; border-top: 1px solid rgba(255,255,255,0.1); }
        .avatar { width: 36px; height: 36px; background-color: white; color: var(--primary-blue); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 14px; margin-right: 12px; }
        .user-info h4 { font-size: 13px; font-weight: 600; }
        .user-info p  { font-size: 11px; color: var(--sidebar-text-muted); }

        .main-wrapper { flex: 1; display: flex; flex-direction: column; overflow: hidden; position: relative; }
        .topbar { height: 64px; background-color: white; border-bottom: 1px solid var(--border-color); display: flex; align-items: center; justify-content: space-between; padding: 0 32px; flex-shrink: 0; }
        .topbar-left { display: flex; align-items: center; gap: 12px; }
        .topbar-left .title   { font-size: 16px; font-weight: 600; color: var(--primary-teal); }
        .topbar-left .divider { color: #d1d5db; }
        .topbar-left .date    { font-size: 13px; color: var(--text-gray); }

        .topbar-center { flex: 1; display: flex; justify-content: center; }
        .top-search { display: flex; align-items: center; background-color: #f3f4f6; border-radius: 20px; padding: 8px 16px; width: 400px; }
        .top-search input { border: none; background: transparent; outline: none; width: 100%; font-size: 13px; color: var(--text-dark); }

        .content { padding: 32px; overflow-y: auto; flex: 1; background-color: #fdfdfd; }
        .page-header { margin-bottom: 24px; }
        .page-title h2 { font-size: 28px; font-weight: 700; color: #1a202c; margin-bottom: 4px; }
        .page-title p  { font-size: 14px; color: var(--text-gray); }

        .stats-row { display: flex; gap: 24px; margin-bottom: 24px; }
        .stat-card { flex: 1; background: white; border: 1px solid var(--border-color); border-radius: 12px; padding: 24px; display: flex; align-items: center; gap: 16px; box-shadow: 0 1px 3px rgba(0,0,0,0.03); }
        .stat-icon { width: 48px; height: 48px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 20px; }
        .stat-icon.yellow { background: #fef3c7; color: #d97706; }
        .stat-icon.green  { background: #d1fae5; color: #059669; }
        .stat-info p  { font-size: 12px; font-weight: 700; color: var(--text-gray); text-transform: uppercase; margin-bottom: 4px; }
        .stat-info h3 { font-size: 24px; font-weight: 900; color: var(--text-dark); }

        .table-container { background-color: white; border: 1px solid var(--border-color); border-radius: 12px; overflow: hidden; }
        .data-table { width: 100%; border-collapse: collapse; text-align: left; }
        .data-table th { background-color: var(--table-header-bg); padding: 16px 24px; font-size: 12px; font-weight: 700; color: var(--table-header-text); text-transform: uppercase; letter-spacing: 0.5px; }
        .data-table td { padding: 16px 24px; font-size: 14px; color: var(--text-dark); border-bottom: 1px solid var(--border-color); }

        .stars { color: #f59e0b; font-size: 13px; }
        .stars .inactive { color: #e5e7eb; }
        .review-text { max-width: 400px; color: var(--text-gray); line-height: 1.5; font-size: 13px; }

        .action-buttons { display: flex; gap: 8px; align-items: center; }
        .btn-view   { background: #0d7f6b; color: white; border: none; padding: 6px 12px; border-radius: 6px; font-size: 12px; font-weight: 500; cursor: pointer; text-decoration: none; }
        .btn-delete { background: #fee2e2; color: #991b1b; border: none; padding: 6px 12px; border-radius: 6px; font-size: 12px; font-weight: 500; cursor: pointer; text-decoration: none; }
    </style>
</head>
<body>

<aside class="sidebar">
    <div class="sidebar-top">
        <div class="brand"><h1>Upachaar</h1><p>Clinical Oversight</p></div>
        <ul class="nav-menu">
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/Admin-dashboard" class="nav-link"><i class="fa-solid fa-border-all"></i> Dashboard</a>
            </li>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/doctors" class="nav-link"><i class="fa-solid fa-stethoscope"></i> Doctors</a>
            </li>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/patients" class="nav-link"><i class="fa-solid fa-users"></i> Patients</a>
            </li>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/receptionists" class="nav-link"><i class="fa-solid fa-user-nurse"></i> Receptionists</a>
            </li>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/appointments" class="nav-link"><i class="fa-regular fa-calendar"></i> Appointments</a>
            </li>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/billing" class="nav-link"><i class="fa-solid fa-file-invoice-dollar"></i> Billing</a>
            </li>
            <li class="nav-item active">
                <a href="<%= request.getContextPath() %>/reviews" class="nav-link"><i class="fa-solid fa-star"></i> Reviews</a>
            </li>
        </ul>
    </div>
    <div class="sidebar-bottom">
        <div class="user-profile">
            <div class="avatar">${(not empty sessionScope.loggedInUser and not empty sessionScope.loggedInUser.name) ? sessionScope.loggedInUser.name.substring(0,1) : 'S'}</div>
            <div class="user-info">
                <h4>${not empty sessionScope.loggedInUser ? sessionScope.loggedInUser.name : ''}</h4>
                <p>${not empty sessionScope.loggedInUser ? sessionScope.loggedInUser.role : ''}</p>
            </div>
        </div>
    </div>
</aside>

<div class="main-wrapper">
    <header class="topbar">
        <div class="topbar-left">
            <span class="title">Reviews & Feedback</span>
            <span class="divider">|</span>
            <span class="date"><%= currentDate %></span>
        </div>

    </header>

    <main class="content">
        <div class="page-header">
            <div class="page-title">
                <h2>Patient Reviews</h2>
                <p>Monitor patient feedback and clinic satisfaction ratings.</p>
            </div>
        </div>

        <div class="stats-row">
            <div class="stat-card">
                <div class="stat-icon yellow"><i class="fa-solid fa-star"></i></div>
                <div class="stat-info">
                    <p>Average Rating</p>
                    <h3><%= String.format("%.1f", averageRating) %> / 5.0</h3>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon green"><i class="fa-solid fa-comment-medical"></i></div>
                <div class="stat-info">
                    <p>Total Reviews</p>
                    <h3><%= totalReviews %></h3>
                </div>
            </div>
        </div>

        <div class="table-container">
            <table class="data-table">
                <thead>
                <tr>
                    <th>Date</th>
                    <th>Patient</th>
                    <th>Patient ID</th>
                    <th>Rating</th>
                    <th>Feedback</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${empty reviewList}">
                        <tr>
                            <td colspan="6" style="text-align: center; color: var(--text-gray);">No reviews found.</td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="review" items="${reviewList}">
                            <tr>
                                <td>${review.date}</td>
                                <td><strong>${review.patientName}</strong></td>
                                <td>${review.patientId}</td>
                                <td>
                                    <div class="stars">
                                        <c:forEach begin="1" end="5" var="i">
                                            <i class="fa-solid fa-star ${i <= review.rating ? '' : 'inactive'}"></i>
                                        </c:forEach>
                                    </div>
                                </td>
                                <td><p class="review-text">${review.comment}</p></td>
                                <td>
                                    <div class="action-buttons">

                                        <a href="<%= request.getContextPath() %>/deleteReview?id=${review.id}" class="btn-delete" onclick="return confirm('Delete this review?');"><i class="fa-solid fa-trash"></i></a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
    </main>
</div>

</body>
</html>
