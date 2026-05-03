<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Upachaar - Receptionists</title>
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
      --card-bg-1: #f8fbfb;
      --card-bg-2: #f0fdf4;
      --card-bg-3: #fff5f5;
    }

    * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Inter', sans-serif; }
    body { background-color: var(--bg-light); color: var(--text-dark); display: flex; height: 100vh; overflow: hidden; }

    /* Sidebar */
    .sidebar { width: 250px; background-color: var(--primary-blue); color: white; display: flex; flex-direction: column; justify-content: space-between; flex-shrink: 0; }
    .sidebar-top { padding: 24px 16px; }
    .brand h1 { font-size: 22px; font-weight: 700; margin-bottom: 4px; }
    .brand p { font-size: 12px; color: var(--sidebar-text-muted); margin-bottom: 32px; }
    .nav-menu { list-style: none; }
    .nav-link { display: flex; align-items: center; padding: 12px 16px; color: white; text-decoration: none; font-size: 14px; font-weight: 500; border-radius: 8px; margin-bottom: 4px; }
    .nav-link i { width: 20px; margin-right: 12px; font-size: 16px; text-align: center; }
    .nav-item.active .nav-link { background-color: white; color: var(--primary-blue); }
    .nav-link:hover:not(.active) { background-color: rgba(255, 255, 255, 0.1); }
    .sidebar-bottom { padding: 20px 16px; }
    .user-profile { display: flex; align-items: center; padding-top: 16px; border-top: 1px solid rgba(255, 255, 255, 0.1); }
    .avatar { width: 36px; height: 36px; background-color: white; color: var(--primary-blue); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 14px; margin-right: 12px; }
    .user-info h4 { font-size: 13px; font-weight: 600; }
    .user-info p { font-size: 11px; color: var(--sidebar-text-muted); }

    /* Main Content */
    .main-wrapper { flex: 1; display: flex; flex-direction: column; overflow: hidden; }
    .topbar { height: 64px; background-color: white; border-bottom: 1px solid var(--border-color); display: flex; align-items: center; justify-content: space-between; padding: 0 32px; }
    .topbar-left { display: flex; gap: 12px; font-size: 16px; font-weight: 600; color: var(--primary-teal); }
    .topbar-left .date { font-size: 13px; color: var(--text-gray); font-weight: 400; }
    .top-search { display: flex; align-items: center; background-color: #f3f4f6; border-radius: 20px; padding: 8px 16px; width: 400px; }
    .top-search input { border: none; background: transparent; outline: none; width: 100%; margin-left: 8px; font-size: 13px; }
    .topbar-right { display: flex; align-items: center; gap: 20px; }
    .top-icon { color: var(--text-gray); cursor: pointer; }
    .btn-support { background-color: #f0fdf4; color: var(--primary-teal); border: 1px solid #bbf7d0; border-radius: 20px; padding: 6px 16px; font-size: 13px; cursor: pointer; }

    /* Content Area */
    .content { padding: 32px; overflow-y: auto; background-color: #fdfdfd; flex: 1; }
    .page-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 24px; }
    .page-title h2 { font-size: 24px; font-weight: 700; color: #1a202c; }
    .page-title p { font-size: 14px; color: var(--text-gray); margin-top: 4px; }
    .btn-action { background-color: var(--primary-teal); color: white; border: none; border-radius: 8px; padding: 10px 20px; font-size: 14px; font-weight: 500; cursor: pointer; display: flex; gap: 8px; align-items: center; }

    /* Stats Grid */
    .stats-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; margin-bottom: 24px; }
    .stat-card { background-color: white; border: 1px solid var(--border-color); border-radius: 12px; padding: 24px; display: flex; justify-content: space-between; align-items: flex-start; position: relative; overflow: hidden; }
    .stat-info h3 { font-size: 12px; font-weight: 600; color: var(--text-gray); text-transform: uppercase; margin-bottom: 12px; }
    .stat-info .value { font-size: 28px; font-weight: 700; color: #111827; display: flex; align-items: baseline; gap: 8px; }
    .stat-info .subtext { font-size: 13px; color: var(--text-gray); font-weight: 400; }
    .badge { background-color: #d1fae5; color: #065f46; font-size: 12px; padding: 2px 8px; border-radius: 12px; margin-left: 8px; font-weight: 500; }
    .stat-icon { font-size: 20px; }
    .stat-card:nth-child(1) .stat-icon { color: #0ea5e9; }
    .stat-card:nth-child(2) .stat-icon { color: #10b981; }
    .stat-card:nth-child(3) .stat-icon { color: #f97316; }

    /* Filter Tabs */
    .filter-tabs { display: flex; gap: 8px; margin-bottom: 24px; }
    .tab-btn { padding: 8px 16px; border: 1px solid var(--border-color); background: white; border-radius: 20px; font-size: 13px; color: var(--text-gray); cursor: pointer; }
    .tab-btn.active { border-color: var(--primary-teal); color: var(--primary-teal); background-color: #f0fdf4; font-weight: 500; }

    /* Table */
    .table-container { background-color: white; border: 1px solid var(--border-color); border-radius: 12px; overflow: hidden; }
    .data-table { width: 100%; border-collapse: collapse; text-align: left; }
    .data-table th { background-color: var(--table-header-bg); padding: 16px 24px; font-size: 12px; font-weight: 700; color: var(--table-header-text); text-transform: uppercase; }
    .data-table td { padding: 16px 24px; font-size: 14px; border-bottom: 1px solid var(--border-color); }
    .empty-state { text-align: center; padding: 60px !important; color: var(--text-gray); }

    /* Utility classes added for dynamic table rendering */
    .action-icon { margin-right: 12px; font-size: 16px; cursor: pointer; }
    .icon-view { color: var(--primary-teal); }
    .icon-edit { color: var(--primary-blue); }
    .icon-delete { color: #ef4444; }
  </style>
</head>
<body>
<aside class="sidebar">
  <div class="sidebar-top">
    <div class="brand"><h1>Upachaar</h1><p>Clinical Oversight</p></div>
    <ul class="nav-menu">
      <li class="nav-item"><a href="dashboard.jsp" class="nav-link"><i class="fa-solid fa-border-all"></i> Dashboard</a></li>
      <li class="nav-item"><a href="doctors.jsp" class="nav-link"><i class="fa-solid fa-stethoscope"></i> Doctors</a></li>
      <li class="nav-item"><a href="patients.jsp" class="nav-link"><i class="fa-solid fa-users"></i> Patients</a></li>
      <li class="nav-item active"><a href="receptionists.jsp" class="nav-link"><i class="fa-solid fa-user-nurse"></i> Receptionists</a></li>
      <li class="nav-item"><a href="appointments.jsp" class="nav-link"><i class="fa-regular fa-calendar"></i> Appointments</a></li>
      <li class="nav-item"><a href="billing.jsp" class="nav-link"><i class="fa-solid fa-file-invoice-dollar"></i> Billing</a></li>
    </ul>
  </div>
  <div class="sidebar-bottom">
    <div class="user-profile">
      <div class="avatar">${not empty sessionScope.loggedInUser ? sessionScope.loggedInUser.name.substring(0,1) : 'S'}</div>
      <div class="user-info">
        <h4>${not empty sessionScope.loggedInUser ? sessionScope.loggedInUser.name : 'Samir'}</h4>
        <p>${not empty sessionScope.loggedInUser ? sessionScope.loggedInUser.role : 'Super Admin'}</p>
      </div>
    </div>
  </div>
</aside>

<div class="main-wrapper">
  <header class="topbar">
    <div class="topbar-left">
      Receptionists <span style="color:#d1d5db;">|</span>
      <span class="date">${not empty currentDate ? currentDate : 'May 1, 2026'}</span>
    </div>

    <form action="searchReceptionists.jsp" method="GET" class="top-search">
      <i class="fa-solid fa-magnifying-glass"></i>
      <input type="text" name="query" placeholder="Search receptionists, schedules, or records...">
    </form>

    <div class="topbar-right">
      <i class="fa-regular fa-bell top-icon"></i>
      <i class="fa-regular fa-circle-question top-icon"></i>
      <button class="btn-support">Support</button>
    </div>
  </header>

  <main class="content">
    <div class="page-header">
      <div class="page-title">
        <h2>Receptionist Management</h2>
        <p>Overview and management of front-desk staff.</p>
      </div>
      <button class="btn-action" onclick="window.location.href='addReceptionist.jsp'">
        <i class="fa-solid fa-plus"></i> Add Receptionist
      </button>
    </div>

    <div class="stats-grid">
      <div class="stat-card" style="background: var(--card-bg-1);">
        <div class="stat-info">
          <h3>TOTAL RECEPTIONISTS</h3>
          <div class="value">${not empty totalStaff ? totalStaff : 0} <span class="subtext">registered</span></div>
        </div>
        <i class="fa-solid fa-user-group stat-icon"></i>
      </div>
      <div class="stat-card" style="background: var(--card-bg-2);">
        <div class="stat-info">
          <h3>ON DUTY</h3>
          <div class="value">${not empty onDutyCount ? onDutyCount : 0} <span class="badge">Available</span></div>
        </div>
        <i class="fa-solid fa-user-check stat-icon"></i>
      </div>
      <div class="stat-card" style="background: var(--card-bg-3);">
        <div class="stat-info">
          <h3>OFF DUTY</h3>
          <div class="value">${not empty offDutyCount ? offDutyCount : 0}</div>
        </div>
        <i class="fa-solid fa-user-minus stat-icon"></i>
      </div>
    </div>

    <div class="filter-tabs">
      <button class="tab-btn active">All</button>
      <button class="tab-btn">Morning</button>
      <button class="tab-btn">Evening</button>
      <button class="tab-btn">Night</button>
    </div>

    <div class="table-container">
      <table class="data-table">
        <thead>
        <tr>
          <th>RECEPTIONIST ID</th>
          <th>NAME</th>
          <th>CONTACT</th>
          <th>SHIFT</th>
          <th>STATUS</th>
          <th>ACTIONS</th>
        </tr>
        </thead>
        <tbody>
        <c:choose>
          <c:when test="${empty receptionistList}">
            <tr>
              <td colspan="6" class="empty-state">No receptionists found matching this criteria.</td>
            </tr>
          </c:when>
          <c:otherwise>
            <c:forEach var="receptionist" items="${receptionistList}">
              <tr>
                <td>${receptionist.id}</td>
                <td>${receptionist.name}</td>
                <td>${receptionist.contact}</td>
                <td>${receptionist.shift}</td>
                <td>
                  <c:choose>
                    <c:when test="${receptionist.status == 'On Duty'}">
                      <span class="badge" style="background-color: #d1fae5; color: #065f46;">On Duty</span>
                    </c:when>
                    <c:otherwise>
                      <span class="badge" style="background-color: #fce7f3; color: #9d174d;">Off Duty</span>
                    </c:otherwise>
                  </c:choose>
                </td>
                <td>
                  <a href="viewReceptionist.jsp?id=${receptionist.id}" class="action-icon icon-view"><i class="fa-solid fa-eye"></i></a>
                  <a href="editReceptionist.jsp?id=${receptionist.id}" class="action-icon icon-edit"><i class="fa-solid fa-pen"></i></a>
                  <a href="deleteReceptionist.jsp?id=${receptionist.id}" class="action-icon icon-delete"><i class="fa-solid fa-trash"></i></a>
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