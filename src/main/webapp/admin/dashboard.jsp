<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    String userName    = (session.getAttribute("userName") != null) ? (String) session.getAttribute("userName") : "Admin";
    String userRole    = (session.getAttribute("userRole") != null) ? (String) session.getAttribute("userRole") : "Super Admin";
    String currentDate = LocalDate.now().format(DateTimeFormatter.ofPattern("MMM d, yyyy"));

    // FIX: read real data from AdminDashboardServlet instead of hardcoded mock values
    int    totalDoctors       = (request.getAttribute("totalDoctors")       != null) ? (Integer) request.getAttribute("totalDoctors")       : 0;
    int    totalPatients      = (request.getAttribute("totalPatients")      != null) ? (Integer) request.getAttribute("totalPatients")      : 0;
    int    totalReceptionists = (request.getAttribute("totalReceptionists") != null) ? (Integer) request.getAttribute("totalReceptionists") : 0;
    double totalRevenue       = (request.getAttribute("totalRevenue")       != null) ? (Double)  request.getAttribute("totalRevenue")       : 0.0;

    // Error surfacing — remove after confirming everything works
    String errorMessage = (String) request.getAttribute("errorMessage");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Upachaar Dashboard</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root {
            --primary-blue: #2554ff;
            --primary-teal: #0d7f6b;
            --quick-action-teal: #1cb59b;
            --bg-light: #f8fafc;
            --text-dark: #111827;
            --text-gray: #6b7280;
            --border-color: #e5e7eb;
            --sidebar-text-muted: #a0bafc;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Inter', sans-serif;
        }

        body {
            background-color: var(--bg-light);
            color: var(--text-dark);
            display: flex;
            height: 100vh;
            overflow: hidden;
        }

        .sidebar {
            width: 250px;
            background-color: var(--primary-blue);
            color: white;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            flex-shrink: 0;
        }

        .sidebar-top { padding: 24px 16px; }

        .brand h1 {
            font-size: 22px;
            font-weight: 700;
            letter-spacing: 0.5px;
            margin-bottom: 4px;
        }

        .brand p {
            font-size: 12px;
            color: var(--sidebar-text-muted);
            margin-bottom: 32px;
        }

        .nav-menu { list-style: none; }

        .nav-item { margin-bottom: 4px; }

        .nav-link {
            display: flex;
            align-items: center;
            padding: 12px 16px;
            color: white;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            border-radius: 8px;
            transition: all 0.2s;
        }

        .nav-link i {
            width: 20px;
            margin-right: 12px;
            font-size: 16px;
            text-align: center;
        }

        .nav-item.active .nav-link {
            background-color: white;
            color: var(--primary-blue);
        }

        .nav-link:hover:not(.active) {
            background-color: rgba(255, 255, 255, 0.1);
        }

        .sidebar-bottom { padding: 20px 16px; }

        .social-links {
            margin-bottom: 24px;
            padding: 0 8px;
        }

        .social-links p {
            font-size: 11px;
            color: var(--sidebar-text-muted);
            margin-bottom: 8px;
        }

        .social-links i {
            margin-right: 12px;
            font-size: 14px;
            cursor: pointer;
            color: var(--sidebar-text-muted);
        }

        .user-profile {
            display: flex;
            align-items: center;
            padding-top: 16px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }

        .avatar {
            width: 36px;
            height: 36px;
            background-color: white;
            color: var(--primary-blue);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 14px;
            margin-right: 12px;
            text-transform: uppercase;
        }

        .user-info h4 { font-size: 13px; font-weight: 600; }
        .user-info p  { font-size: 11px; color: var(--sidebar-text-muted); }

        .main-wrapper {
            flex: 1;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }

        .topbar {
            height: 64px;
            background-color: white;
            border-bottom: 1px solid var(--border-color);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 32px;
            flex-shrink: 0;
        }

        .topbar-left { font-size: 16px; font-weight: 600; color: var(--primary-teal); }

        .topbar-right { display: flex; align-items: center; gap: 20px; }

        .date { font-size: 13px; color: var(--text-gray); }

        .topbar-icons { display: flex; align-items: center; }

        .topbar-icons i {
            font-size: 18px;
            color: var(--text-gray);
            margin-left: 16px;
            cursor: pointer;
        }

        .btn-support {
            background-color: #f0fdf4;
            color: var(--primary-teal);
            border: 1px solid #bbf7d0;
            border-radius: 20px;
            padding: 6px 16px;
            font-size: 13px;
            font-weight: 500;
            cursor: pointer;
            margin-left: 16px;
        }

        .content {
            padding: 32px;
            overflow-y: auto;
            flex: 1;
            background-color: #fdfdfd;
        }

        .page-header { margin-bottom: 24px; }

        .page-header h2 {
            font-size: 26px;
            font-weight: 700;
            color: #1a202c;
            margin-bottom: 4px;
        }

        .page-header p { font-size: 14px; color: var(--text-gray); }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
            margin-bottom: 24px;
        }

        .stat-card {
            background-color: white;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            padding: 20px;
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            box-shadow: 0 1px 2px rgba(0,0,0,0.02);
        }

        .stat-info h3 {
            font-size: 13px;
            font-weight: 500;
            color: var(--text-gray);
            margin-bottom: 8px;
        }

        .stat-info .value {
            font-size: 28px;
            font-weight: 700;
            color: var(--text-dark);
        }

        .stat-icon { color: var(--primary-teal); font-size: 22px; }

        .card {
            background-color: white;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            padding: 24px;
            margin-bottom: 24px;
            box-shadow: 0 1px 2px rgba(0,0,0,0.02);
        }

        .card-title {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 20px;
            color: #1a202c;
        }

        .quick-actions-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
        }

        .btn-quick-action {
            background-color: var(--quick-action-teal);
            color: white;
            border: none;
            border-radius: 8px;
            padding: 16px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            text-align: center;
            text-decoration: none;
            display: block;
        }

        .btn-quick-action:hover { background-color: #16a086; }

        .recent-activity-container {
            min-height: 150px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--text-gray);
            font-size: 14px;
        }

        .error-banner {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #fca5a5;
            border-radius: 8px;
            padding: 12px 20px;
            margin-bottom: 20px;
            font-size: 13px;
        }
    </style>
</head>
<body>

<aside class="sidebar">
    <div class="sidebar-top">
        <div class="brand">
            <h1>Upachaar</h1>
            <p>Clinical Oversight</p>
        </div>

        <ul class="nav-menu">
            <%-- FIX: all links use getContextPath() so they work from any URL --%>
            <li class="nav-item active">
                <a href="<%= request.getContextPath() %>/Admin-dashboard" class="nav-link">
                    <i class="fa-solid fa-border-all"></i> Dashboard
                </a>
            </li>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/doctors" class="nav-link">
                    <i class="fa-solid fa-stethoscope"></i> Doctors
                </a>
            </li>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/patients" class="nav-link">
                    <i class="fa-solid fa-users"></i> Patients
                </a>
            </li>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/receptionists" class="nav-link">
                    <i class="fa-solid fa-user-nurse"></i> Receptionists
                </a>
            </li>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/appointments" class="nav-link">
                    <i class="fa-regular fa-calendar"></i> Appointments
                </a>
            </li>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/billing" class="nav-link">
                    <i class="fa-solid fa-file-invoice-dollar"></i> Billing
                </a>
            </li>
        </ul>
    </div>

    <div class="sidebar-bottom">
        <div class="social-links">
            <p>Follow us</p>
            <i class="fa-brands fa-facebook-f"></i>
            <i class="fa-brands fa-twitter"></i>
            <i class="fa-regular fa-envelope"></i>
        </div>

        <div class="user-profile">
            <div class="avatar"><%= userName.substring(0, 1).toUpperCase() %></div>
            <div class="user-info">
                <h4><%= userName %></h4>
                <p><%= userRole %></p>
            </div>
        </div>
    </div>
</aside>

<div class="main-wrapper">

    <header class="topbar">
        <div class="topbar-left">Dashboard</div>
        <div class="topbar-right">
            <span class="date"><%= currentDate %></span>
            <div class="topbar-icons">
                <i class="fa-regular fa-bell"></i>
                <i class="fa-regular fa-circle-question"></i>
                <button class="btn-support">Support</button>
            </div>
        </div>
    </header>

    <main class="content">

        <%-- Error banner — remove after confirming fix --%>
        <% if (errorMessage != null) { %>
        <div class="error-banner">
            <strong>Error:</strong> <%= errorMessage %>
        </div>
        <% } %>

        <div class="page-header">
            <h2>Welcome, <%= userName %>!</h2>
            <p>Clinical Oversight Dashboard</p>
        </div>

        <%-- FIX: replaced all hardcoded mock values with real servlet data --%>
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-info">
                    <h3>Total Doctors</h3>
                    <div class="value"><%= totalDoctors %></div>
                </div>
                <div class="stat-icon">
                    <i class="fa-solid fa-stethoscope"></i>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-info">
                    <h3>Total Patients</h3>
                    <div class="value"><%= totalPatients %></div>
                </div>
                <div class="stat-icon">
                    <i class="fa-solid fa-user-group"></i>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-info">
                    <h3>Total Receptionists</h3>
                    <div class="value"><%= totalReceptionists %></div>
                </div>
                <div class="stat-icon">
                    <i class="fa-solid fa-user-nurse"></i>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-info">
                    <h3>Total Revenue</h3>
                    <div class="value">NPR <%= String.format("%,.2f", totalRevenue) %></div>
                </div>
                <div class="stat-icon">
                    <i class="fa-solid fa-file-invoice-dollar"></i>
                </div>
            </div>
        </div>

        <div class="card">
            <h3 class="card-title">Quick Actions</h3>
            <div class="quick-actions-grid">
                <%-- FIX: direct links instead of a single form with action values --%>
                <a href="<%= request.getContextPath() %>/admin/addDoctor.jsp"   class="btn-quick-action">Add Doctor</a>
                <a href="<%= request.getContextPath() %>/admin/addPatient.jsp"  class="btn-quick-action">Add Patient</a>
                <a href="<%= request.getContextPath() %>/appointments"          class="btn-quick-action">Schedule Appointment</a>
                <a href="<%= request.getContextPath() %>/billing"               class="btn-quick-action">View Billing</a>
            </div>
        </div>

        <div class="card">
            <h3 class="card-title">Recent Activity</h3>
            <div class="recent-activity-container">
                No recent activity to display
            </div>
        </div>

    </main>
</div>

</body>
</html>
