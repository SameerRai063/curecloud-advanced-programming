<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Upachaar - Billing</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    :root { --primary-blue: #2554ff; --primary-teal: #0d7f6b; --bg-light: #f8fafc; --text-dark: #111827; --text-gray: #6b7280; --border-color: #e5e7eb; --sidebar-text-muted: #a0bafc; --table-header-bg: #e2f1ec; --table-header-text: #0b6b59; }
    * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Inter', sans-serif; }
    body { background-color: var(--bg-light); color: var(--text-dark); display: flex; height: 100vh; overflow: hidden; }

    .sidebar { width: 250px; background-color: var(--primary-blue); color: white; display: flex; flex-direction: column; justify-content: space-between; flex-shrink: 0; }
    .sidebar-top { padding: 24px 16px; }
    .brand h1 { font-size: 22px; font-weight: 700; margin-bottom: 4px; }
    .brand p { font-size: 12px; color: var(--sidebar-text-muted); margin-bottom: 32px; }
    .nav-menu { list-style: none; }
    .nav-link { display: flex; align-items: center; padding: 12px 16px; color: white; text-decoration: none; font-size: 14px; font-weight: 500; border-radius: 8px; margin-bottom: 4px; }
    .nav-link i { width: 20px; margin-right: 12px; font-size: 16px; text-align: center; }
    .nav-item.active .nav-link { background-color: white; color: var(--primary-blue); }
    .nav-link:hover:not(.active) { background-color: rgba(255, 255, 255, 0.1); }
    .user-profile { display: flex; align-items: center; padding: 16px; border-top: 1px solid rgba(255, 255, 255, 0.1); }
    .avatar { width: 36px; height: 36px; background-color: white; color: var(--primary-blue); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 14px; margin-right: 12px; }
    .user-info h4 { font-size: 13px; font-weight: 600; }
    .user-info p { font-size: 11px; color: var(--sidebar-text-muted); }

    .main-wrapper { flex: 1; display: flex; flex-direction: column; overflow: hidden; }
    .topbar { height: 64px; background-color: white; border-bottom: 1px solid var(--border-color); display: flex; align-items: center; justify-content: space-between; padding: 0 32px; }
    .topbar-left { display: flex; gap: 12px; font-size: 16px; font-weight: 600; color: var(--primary-teal); }
    .topbar-left .date { font-size: 13px; color: var(--text-gray); font-weight: 400; }
    .top-search { display: flex; align-items: center; background-color: #f3f4f6; border-radius: 20px; padding: 8px 16px; width: 400px; }
    .top-search input { border: none; background: transparent; outline: none; width: 100%; margin-left: 8px; }
    .btn-support { background-color: #f0fdf4; color: var(--primary-teal); border: 1px solid #bbf7d0; border-radius: 20px; padding: 6px 16px; font-size: 13px; cursor: pointer; }

    .content { padding: 32px; overflow-y: auto; background-color: #fdfdfd; flex: 1; }
    .page-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 24px; }
    .page-title h2 { font-size: 24px; font-weight: 700; color: #1a202c; }
    .page-title p { font-size: 14px; color: var(--text-gray); margin-top: 4px; }

    .stats-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; margin-bottom: 24px; }
    .stat-card { background-color: white; border: 1px solid var(--border-color); border-radius: 12px; padding: 24px; }
    .stat-info h3 { font-size: 12px; font-weight: 600; color: var(--text-gray); text-transform: uppercase; margin-bottom: 12px; }
    .stat-info .value { font-size: 24px; font-weight: 700; color: #111827; }
    .stat-info .subtext { font-size: 13px; font-weight: 400; color: var(--text-gray); }

    .search-bar-content { background: white; border: 1px solid var(--border-color); padding: 12px 16px; border-radius: 8px; display: flex; align-items: center; margin-bottom: 24px; }
    .search-bar-content input { border: none; outline: none; width: 100%; margin-left: 12px; font-size: 14px; }

    .table-container { background-color: white; border: 1px solid var(--border-color); border-radius: 12px; overflow: hidden; }
    .data-table { width: 100%; border-collapse: collapse; text-align: left; }
    .data-table th { background-color: var(--table-header-bg); padding: 16px 24px; font-size: 12px; font-weight: 700; color: var(--table-header-text); text-transform: uppercase; }
    .data-table td { padding: 16px 24px; font-size: 14px; border-bottom: 1px solid var(--border-color); }

    .action-icon { margin-right: 12px; font-size: 16px; cursor: pointer; color: var(--text-gray); }
    .action-icon:hover { color: var(--primary-teal); }
    .badge { padding: 4px 8px; border-radius: 12px; font-size: 12px; font-weight: 500; }
    .badge-paid { background-color: #d1fae5; color: #065f46; }
    .badge-pending { background-color: #fef3c7; color: #92400e; }
    .badge-failed { background-color: #fee2e2; color: #991b1b; }
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
      <li class="nav-item"><a href="receptionists.jsp" class="nav-link"><i class="fa-solid fa-user-nurse"></i> Receptionists</a></li>
      <li class="nav-item"><a href="appointments.jsp" class="nav-link"><i class="fa-regular fa-calendar"></i> Appointments</a></li>
      <li class="nav-item active"><a href="billing.jsp" class="nav-link"><i class="fa-solid fa-file-invoice-dollar"></i> Billing</a></li>
    </ul>
  </div>
  <div class="user-profile">
    <div class="avatar">${not empty sessionScope.loggedInUser ? sessionScope.loggedInUser.name.substring(0,1) : 'S'}</div>
    <div class="user-info">
      <h4>${not empty sessionScope.loggedInUser ? sessionScope.loggedInUser.name : 'Samir'}</h4>
      <p>${not empty sessionScope.loggedInUser ? sessionScope.loggedInUser.role : 'Super Admin'}</p>
    </div>
  </div>
</aside>

<div class="main-wrapper">
  <header class="topbar">
    <div class="topbar-left">
      Billing <span style="color:#d1d5db;">|</span>
      <span class="date">${not empty currentDate ? currentDate : 'May 1, 2026'}</span>
    </div>

    <form action="globalSearch.jsp" method="GET" class="top-search">
      <i class="fa-solid fa-magnifying-glass"></i>
      <input type="text" name="query" placeholder="Search patients, records, or doctors...">
    </form>

    <div class="topbar-right"><button class="btn-support">Support</button></div>
  </header>

  <main class="content">
    <div class="page-header">
      <div class="page-title">
        <h2>Billing & Revenue</h2>
        <p>Manage and track all financial transactions.</p>
      </div>
    </div>

    <div class="stats-grid">
      <div class="stat-card" style="background: #f0fdfa;">
        <div class="stat-info">
          <h3>TOTAL REVENUE</h3>
          <div class="value">NPR ${not empty totalRevenue ? totalRevenue : '0.00'}</div>
        </div>
      </div>
      <div class="stat-card" style="background: #f0fdf4;">
        <div class="stat-info">
          <h3>PAID INVOICES</h3>
          <div class="value">${not empty paidCount ? paidCount : '0'}</div>
        </div>
      </div>
      <div class="stat-card" style="background: #fffbeb;">
        <div class="stat-info">
          <h3>PENDING PAYMENTS</h3>
          <div class="value">NPR ${not empty pendingAmount ? pendingAmount : '0.00'} <span class="subtext">${not empty pendingCount ? pendingCount : '0'} items</span></div>
        </div>
      </div>
      <div class="stat-card" style="background: #fef2f2;">
        <div class="stat-info">
          <h3>FAILED PAYMENTS</h3>
          <div class="value">${not empty failedCount ? failedCount : '0'}</div>
        </div>
      </div>
    </div>

    <form action="billing.jsp" method="GET" class="search-bar-content">
      <i class="fa-solid fa-magnifying-glass" style="color: var(--text-gray);"></i>
      <input type="text" name="search" placeholder="Search by Patient Name or ID..." value="${param.search}">
    </form>

    <div class="table-container">
      <table class="data-table">
        <thead>
        <tr>
          <th>ID (PIDX)</th>
          <th>PATIENT</th>
          <th>SERVICE/APPT ID</th>
          <th>AMOUNT</th>
          <th>METHOD</th>
          <th>DATE</th>
          <th>STATUS</th>
          <th>ACTIONS</th>
        </tr>
        </thead>
        <tbody>
        <c:choose>
          <c:when test="${empty billingList}">
            <tr>
              <td colspan="8" style="text-align: center; padding: 40px; color: var(--text-gray);">No billing records found.</td>
            </tr>
          </c:when>
          <c:otherwise>
            <c:forEach var="bill" items="${billingList}">
              <tr>
                <td>${bill.pidx}</td>
                <td>${bill.patientName}</td>
                <td>${bill.serviceId}</td>
                <td>NPR <fmt:formatNumber value="${bill.amount}" pattern="#,##0.00" /></td>
                <td>${bill.method}</td>
                <td>${bill.date}</td>
                <td>
                  <c:choose>
                    <c:when test="${bill.status == 'PAID' || bill.status == 'Paid'}">
                      <span class="badge badge-paid">Paid</span>
                    </c:when>
                    <c:when test="${bill.status == 'PENDING' || bill.status == 'Pending'}">
                      <span class="badge badge-pending">Pending</span>
                    </c:when>
                    <c:otherwise>
                      <span class="badge badge-failed">${bill.status}</span>
                    </c:otherwise>
                  </c:choose>
                </td>
                <td>
                  <a href="viewInvoice.jsp?id=${bill.pidx}" class="action-icon" title="View"><i class="fa-solid fa-eye"></i></a>
                  <a href="printInvoice.jsp?id=${bill.pidx}" class="action-icon" title="Print"><i class="fa-solid fa-print"></i></a>
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