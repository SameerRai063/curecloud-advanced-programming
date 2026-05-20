<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.List" %>
<%
    String userName    = (session.getAttribute("userName") != null) ? (String) session.getAttribute("userName") : "Admin";
    String userRole    = (session.getAttribute("userRole") != null) ? (String) session.getAttribute("userRole") : "";
    String currentDate = LocalDate.now().format(DateTimeFormatter.ofPattern("MMM d, yyyy"));

    int    totalDoctors       = (request.getAttribute("totalDoctors")       != null) ? (Integer) request.getAttribute("totalDoctors")       : 0;
    int    totalPatients      = (request.getAttribute("totalPatients")      != null) ? (Integer) request.getAttribute("totalPatients")      : 0;
    int    totalReceptionists = (request.getAttribute("totalReceptionists") != null) ? (Integer) request.getAttribute("totalReceptionists") : 0;
    double totalRevenue       = (request.getAttribute("totalRevenue")       != null) ? (Double)  request.getAttribute("totalRevenue")       : 0.0;

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

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Inter', sans-serif; }
        body { background-color: var(--bg-light); color: var(--text-dark); display: flex; height: 100vh; overflow: hidden; }

        /* --- Sidebar Styles --- */
        .sidebar { width: 250px; background-color: var(--primary-blue); color: white; display: flex; flex-direction: column; justify-content: space-between; flex-shrink: 0; }
        .sidebar-top { padding: 24px 16px; }
        .brand h1 { font-size: 22px; font-weight: 700; letter-spacing: 0.5px; margin-bottom: 4px; }
        .brand p { font-size: 12px; color: var(--sidebar-text-muted); margin-bottom: 32px; }
        .nav-menu { list-style: none; }
        .nav-item { margin-bottom: 4px; }
        .nav-link { display: flex; align-items: center; padding: 12px 16px; color: white; text-decoration: none; font-size: 14px; font-weight: 500; border-radius: 8px; transition: all 0.2s; }
        .nav-link i { width: 20px; margin-right: 12px; font-size: 16px; text-align: center; }
        .nav-item.active .nav-link { background-color: white; color: var(--primary-blue); }
        .nav-link:hover:not(.active) { background-color: rgba(255, 255, 255, 0.1); }
        .sidebar-bottom { padding: 20px 16px; }
        .social-links { margin-bottom: 24px; padding: 0 8px; }
        .social-links p { font-size: 11px; color: var(--sidebar-text-muted); margin-bottom: 8px; }
        .social-links i { margin-right: 12px; font-size: 14px; cursor: pointer; color: var(--sidebar-text-muted); }
        .user-profile { display: flex; align-items: center; padding-top: 16px; border-top: 1px solid rgba(255, 255, 255, 0.1); }
        .avatar { width: 36px; height: 36px; background-color: white; color: var(--primary-blue); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 14px; margin-right: 12px; text-transform: uppercase; }
        .user-info h4 { font-size: 13px; font-weight: 600; }
        .user-info p  { font-size: 11px; color: var(--sidebar-text-muted); }

        /* --- Main Content Styles --- */
        .main-wrapper { flex: 1; display: flex; flex-direction: column; overflow: hidden; }
        .topbar { height: 64px; background-color: white; border-bottom: 1px solid var(--border-color); display: flex; align-items: center; justify-content: space-between; padding: 0 32px; flex-shrink: 0; }
        .topbar-left { font-size: 16px; font-weight: 600; color: var(--primary-teal); }
        .topbar-right { display: flex; align-items: center; gap: 20px; }
        .date { font-size: 13px; color: var(--text-gray); }
        .topbar-icons { display: flex; align-items: center; }
        .topbar-icons i { font-size: 18px; color: var(--text-gray); margin-left: 16px; cursor: pointer; }
        .header-actions { display: flex; align-items: center; gap: 14px; }
        .notification-btn { position: relative; width: 44px; height: 44px; border-radius: 50%; background: #f8fafc; color: #64748b; display: inline-flex; align-items: center; justify-content: center; text-decoration: none; }
        .notification-btn i { font-size: 18px; }
        .notification-dot { position: absolute; top: 8px; right: 9px; width: 8px; height: 8px; background: #ef4444; border-radius: 50%; }
        .header-profile { display: flex; align-items: center; gap: 12px; border-left: 1px solid var(--border-color); padding-left: 20px; }
        .header-name { font-size: 14px; font-weight: 700; color: var(--text-dark); }
        .profile-btn { width: 40px; height: 40px; border-radius: 50%; background: #dbeafe; color: var(--primary-blue); display: inline-flex; align-items: center; justify-content: center; text-decoration: none; }
        .profile-btn i { font-size: 22px; }
        .logout-btn { display: inline-flex; align-items: center; gap: 8px; background: #0f172a; color: white; text-decoration: none; border-radius: 999px; padding: 10px 18px; font-size: 14px; font-weight: 700; }
        .logout-btn:hover { background: #334155; }
        .btn-support { background-color: #f0fdf4; color: var(--primary-teal); border: 1px solid #bbf7d0; border-radius: 20px; padding: 6px 16px; font-size: 13px; font-weight: 500; cursor: pointer; margin-left: 16px; }
        .content { padding: 32px; overflow-y: auto; flex: 1; background-color: #fdfdfd; }
        .page-header { margin-bottom: 24px; }
        .page-header h2 { font-size: 26px; font-weight: 700; color: #1a202c; margin-bottom: 4px; }
        .page-header p { font-size: 14px; color: var(--text-gray); }

        .stats-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; margin-bottom: 24px; }
        .stat-card { background-color: white; border: 1px solid var(--border-color); border-radius: 8px; padding: 20px; display: flex; justify-content: space-between; align-items: flex-start; box-shadow: 0 1px 2px rgba(0,0,0,0.02); }
        .stat-info h3 { font-size: 13px; font-weight: 500; color: var(--text-gray); margin-bottom: 8px; }
        .stat-info .value { font-size: 28px; font-weight: 700; color: var(--text-dark); }
        .stat-icon { color: var(--primary-teal); font-size: 22px; }

        .card { background-color: white; border: 1px solid var(--border-color); border-radius: 8px; padding: 24px; margin-bottom: 24px; box-shadow: 0 1px 2px rgba(0,0,0,0.02); }
        .card-title { font-size: 18px; font-weight: 600; margin-bottom: 20px; color: #1a202c; }

        /* --- Quick Actions Buttons --- */
        .quick-actions-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; }
        .btn-quick-action { background-color: var(--quick-action-teal); color: white; border: none; border-radius: 8px; padding: 16px; font-size: 15px; font-weight: 600; cursor: pointer; text-align: center; text-decoration: none; display: block; transition: background-color 0.2s; }
        .btn-quick-action:hover { background-color: #16a086; }

        .recent-activity-container { min-height: 190px; color: var(--text-gray); font-size: 14px; }
        .activity-chart { width: 100%; min-height: 190px; display: flex; align-items: flex-end; gap: 14px; padding-top: 8px; }
        .activity-bar-item { flex: 1; min-width: 0; display: flex; flex-direction: column; align-items: center; gap: 8px; }
        .activity-count { font-size: 12px; font-weight: 700; color: var(--text-dark); line-height: 1; }
        .activity-bar-track { width: 100%; height: 140px; background: #f1f5f9; border: 1px solid #e2e8f0; border-radius: 8px 8px 4px 4px; display: flex; align-items: flex-end; overflow: hidden; }
        .activity-bar { width: 100%; min-height: 4px; background: linear-gradient(180deg, #22c7a8 0%, #0d7f6b 100%); border-radius: 8px 8px 0 0; }
        .activity-label { max-width: 100%; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; font-size: 11px; color: var(--text-gray); }
        .activity-empty { min-height: 150px; display: flex; align-items: center; justify-content: center; }
        .dashboard-charts { display: grid; grid-template-columns: minmax(0, 1fr) minmax(0, 1fr); gap: 28px; }
        .chart-panel-title { font-size: 13px; font-weight: 700; color: var(--text-dark); margin-bottom: 14px; }
        .revenue-chart { position: relative; min-height: 190px; padding: 8px 0 24px; }
        .revenue-svg { width: 100%; height: 166px; display: block; overflow: visible; }
        .revenue-grid-line { stroke: #e5e7eb; stroke-width: 1; }
        .revenue-line { fill: none; stroke: #2554ff; stroke-width: 3; stroke-linecap: round; stroke-linejoin: round; }
        .revenue-area { fill: rgba(37, 84, 255, 0.12); }
        .revenue-point { fill: #ffffff; stroke: #2554ff; stroke-width: 2; }
        .revenue-labels { position: absolute; left: 0; right: 0; bottom: 0; display: grid; grid-template-columns: repeat(7, minmax(0, 1fr)); gap: 6px; }
        .revenue-labels span { overflow: hidden; text-overflow: ellipsis; white-space: nowrap; text-align: center; font-size: 11px; color: var(--text-gray); }
        .revenue-total { font-size: 12px; color: var(--text-gray); font-weight: 500; margin-top: -8px; margin-bottom: 8px; }
        .chart-clickable { cursor: pointer; }
        .activity-bar-item.selected .activity-bar-track { border-color: var(--primary-blue); box-shadow: 0 0 0 3px rgba(37, 84, 255, 0.12); }
        .revenue-point.selected { fill: var(--primary-blue); stroke: #ffffff; }
        .revenue-hit-zone { fill: transparent; cursor: pointer; }
        .chart-details { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 12px; border-top: 1px solid var(--border-color); margin-top: 20px; padding-top: 16px; }
        .chart-detail-item { background: #f8fafc; border: 1px solid #e5e7eb; border-radius: 8px; padding: 12px; }
        .chart-detail-item span { display: block; font-size: 11px; color: var(--text-gray); margin-bottom: 6px; }
        .chart-detail-item strong { display: block; font-size: 16px; color: var(--text-dark); }
        .error-banner { background: #fee2e2; color: #991b1b; border: 1px solid #fca5a5; border-radius: 8px; padding: 12px 20px; margin-bottom: 20px; font-size: 13px; }

        /* ========================================= */
        /* MODAL STYLES ADDED HERE                   */
        /* ========================================= */
        .modal-overlay {
            display: none; /* Hidden by default */
            position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%;
            background-color: rgba(0, 0, 0, 0.5); backdrop-filter: blur(2px);
            align-items: center; justify-content: center;
        }
        .modal-content {
            background-color: white; padding: 24px; border-radius: 8px;
            width: 400px; max-width: 90%; position: relative;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .close-btn {
            position: absolute; top: 16px; right: 16px; font-size: 20px;
            cursor: pointer; color: var(--text-gray); transition: color 0.2s;
        }
        .close-btn:hover { color: var(--text-dark); }
        .modal-content h3 { margin-bottom: 16px; color: var(--text-dark); }
        .form-group { margin-bottom: 16px; }
        .form-group label { display: block; margin-bottom: 6px; font-size: 13px; font-weight: 500; color: var(--text-dark); }
        .form-group input, .form-group select {
            width: 100%; padding: 10px; border: 1px solid var(--border-color);
            border-radius: 6px; font-size: 14px; outline: none;
        }
        .form-group input:focus, .form-group select:focus { border-color: var(--primary-blue); }
        .btn-submit {
            width: 100%; background-color: var(--primary-blue); color: white;
            border: none; padding: 12px; border-radius: 6px; font-size: 14px;
            font-weight: 600; cursor: pointer; transition: background-color 0.2s;
        }
        .btn-submit:hover { background-color: #1a40d6; }
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
            <li class="nav-item active"><a href="<%= request.getContextPath() %>/Receptionist-dashboard" class="nav-link"><i class="fa-solid fa-border-all"></i> Dashboard</a></li>
            <li class="nav-item"><a href="<%= request.getContextPath() %>/receptionists/doctors" class="nav-link"><i class="fa-solid fa-stethoscope"></i> Doctors</a></li>
            <li class="nav-item"><a href="<%= request.getContextPath() %>/receptionists/patients" class="nav-link"><i class="fa-solid fa-users"></i> Patients</a></li>
            <li class="nav-item"><a href="<%= request.getContextPath() %>/receptionists/appointments" class="nav-link"><i class="fa-regular fa-calendar"></i> Appointments</a></li>
            <li class="nav-item"><a href="<%= request.getContextPath() %>/chat" class="nav-link"><i class="fa-regular fa-comments"></i> Chat <span class="chat-unread-badge" style="display:none;margin-left:auto;min-width:20px;border-radius:999px;background:#ef4444;color:white;font-size:11px;font-weight:700;line-height:1;padding:5px 7px;text-align:center;"></span></a></li>

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
        <div class="header-actions">
            <a href="<%= request.getContextPath() %>/notifications.jsp" class="notification-btn" aria-label="Notifications">
                <i class="fa-regular fa-bell"></i>
                <span class="notification-dot"></span>
            </a>
            <div class="header-profile">
                <span class="header-name"><%= userName %></span>
                <a href="#" class="profile-btn" aria-label="Profile">
                    <i class="fa-regular fa-circle-user"></i>
                </a>
            </div>
            <a href="<%= request.getContextPath() %>/logout" class="logout-btn">
                <i class="fa-solid fa-arrow-right-from-bracket"></i>
                Logout
            </a>
        </div>
    </header>

    <main class="content">
        <% if (errorMessage != null) { %>
        <div class="error-banner"><strong>Error:</strong> <%= errorMessage %></div>
        <% } %>

        <div class="page-header">
            <h2>Welcome, <%= userName %>!</h2>
            <p>Clinical Oversight Dashboard</p>
        </div>

        <div class="stats-grid" style="grid-template-columns: repeat(3, 1fr);">
            <div class="stat-card">
                <div class="stat-info"><h3>Total Doctors</h3><div class="value"><%= totalDoctors %></div></div>
                <div class="stat-icon"><i class="fa-solid fa-stethoscope"></i></div>
            </div>
            <div class="stat-card">
                <div class="stat-info"><h3>Total Patients</h3><div class="value"><%= totalPatients %></div></div>
                <div class="stat-icon"><i class="fa-solid fa-user-group"></i></div>
            </div>
            <div class="stat-card">
                <div class="stat-info"><h3>Total Receptionists</h3><div class="value"><%= totalReceptionists %></div></div>
                <div class="stat-icon"><i class="fa-solid fa-user-nurse"></i></div>
            </div>
        </div>

        <div class="card">
            <h3 class="card-title">Quick Actions</h3>
            <div class="quick-actions-grid" style="display: flex; gap: 16px;">
                <button onclick="openModal('doctorModal')"  class="btn-quick-action" style="flex: 1;">Add Doctor</button>
                <button onclick="openModal('patientModal')" class="btn-quick-action" style="flex: 1;">Add Patient</button>
                <a href="<%= request.getContextPath() %>/chat" class="btn-quick-action" style="flex: 1;">Patient Chat</a>
            </div>
        </div>


    </main>
</div>
<div id="doctorModal" class="modal-overlay">
    <div class="modal-content" style="width: 650px;">
        <i class="fa-solid fa-xmark close-btn" onclick="closeModal('doctorModal')"></i>
        <h3>Add New Doctor</h3>

        <form action="<%= request.getContextPath() %>/receptionists/add-doctor" method="POST" enctype="multipart/form-data">
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">

                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text" name="name" required placeholder="Doctor name">
                </div>

                <div class="form-group">
                    <label>Email Address</label>
                    <input type="email" name="email" required placeholder="doctor@example.com">
                </div>

                <div class="form-group">
                    <label>Temporary Password</label>
                    <input type="password" name="password" required placeholder="Initial Password">
                </div>

                <div class="form-group">
                    <label>Phone Number</label>
                    <input type="text" name="phone" required placeholder="+977-XXXXXXXXXX">
                </div>

                <div class="form-group">
                    <label>Gender</label>
                    <select name="gender" required>
                        <option value="Male">Male</option>
                        <option value="Female">Female</option>
                        <option value="Other">Other</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Date of Birth</label>
                    <input type="date" name="dob" required>
                </div>

                <div class="form-group" style="grid-column: span 2;">
                    <label>Home Address</label>
                    <input type="text" name="address" required placeholder="Itahari, Koshi Province">
                </div>

                <div class="form-group">
                    <label>Department</label>
                    <select name="department" required>
                        <option value="Cardiology">Cardiology</option>
                        <option value="Neurology">Neurology</option>
                        <option value="Pediatrics">Pediatrics</option>
                        <option value="General Medicine">General Medicine</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Experience (Years)</label>
                    <input type="number" name="experienceYears" min="0" required placeholder="e.g. 10">
                </div>

                <div class="form-group" style="grid-column: span 2;">
                    <label>Qualifications</label>
                    <input type="text" name="qualifications" required placeholder="MBBS, MD (Neurology)">
                </div>

                <%-- UPDATED STATUS DROPDOWN --%>
                <div class="form-group">
                    <label>Account Status</label>
                    <select name="status" required>
                        <option value="Active">Active</option>
                        <option value="On Leave">On Leave</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Profile Photo</label>
                    <input type="file" name="profileImage" accept="image/*">
                </div>

            </div>

            <button type="submit" class="btn-submit" style="margin-top: 15px;">
                <i class="fa-solid fa-user-plus"></i> Register Doctor
            </button>
        </form>
    </div>
</div>

<div id="patientModal" class="modal-overlay">
    <div class="modal-content" style="width: 650px;">
        <i class="fa-solid fa-xmark close-btn" onclick="closeModal('patientModal')"></i>
        <h3>Add New Patient</h3>

        <form action="<%= request.getContextPath() %>/receptionists/add-patient" method="POST" enctype="multipart/form-data">
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">

                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text" name="name" required placeholder="Jane Doe">
                </div>

                <div class="form-group">
                    <label>Email Address</label>
                    <input type="email" name="email" required placeholder="patient@example.com">
                </div>

                <div class="form-group">
                    <label>Password</label>
                    <input type="password" name="password" required placeholder="Password">
                </div>

                <div class="form-group">
                    <label>Contact Number</label>
                    <input type="text" name="phone" required placeholder="Mobile Number">
                </div>

                <div class="form-group">
                    <label>Gender</label>
                    <select name="gender" required>
                        <option value="Male">Male</option>
                        <option value="Female">Female</option>
                        <option value="Other">Other</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Date of Birth</label>
                    <input type="date" name="dob" required>
                </div>

                <div class="form-group" style="grid-column: span 2;">
                    <label>Address</label>
                    <input type="text" name="address" required placeholder="Full Address">
                </div>

                <div class="form-group">
                    <label>Blood Group</label>
                    <select name="bloodGroup" required>
                        <option value="" disabled selected>Select Blood Group</option>
                        <option value="A+">A+</option><option value="A-">A-</option>
                        <option value="B+">B+</option><option value="B-">B-</option>
                        <option value="O+">O+</option><option value="O-">O-</option>
                        <option value="AB+">AB+</option><option value="AB-">AB-</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Profile Image (Optional)</label>
                    <input type="file" name="profileImage" accept="image/*">
                </div>

            </div>
            <button type="submit" class="btn-submit" style="margin-top: 15px;">Add Patient</button>
        </form>
    </div>
</div>



<script>


    // Open a specific modal
    function openModal(modalId) {
        document.getElementById(modalId).style.display = 'flex';
    }

    // Close a specific modal
    function closeModal(modalId) {
        document.getElementById(modalId).style.display = 'none';
    }

    // Close the modal if the user clicks anywhere outside of the white modal box
    window.onclick = function(event) {
        if (event.target.classList.contains('modal-overlay')) {
            event.target.style.display = 'none';
        }
    }
</script>

<script>
    (function loadChatUnreadCount() {
        const badge = document.querySelector('.chat-unread-badge');
        if (!badge) return;
        fetch('<%= request.getContextPath() %>/chatUnreadCount?_=' + Date.now(), {cache: 'no-store'})
            .then(response => response.ok ? response.text() : '0')
            .then(text => {
                const count = Number.parseInt(text, 10) || 0;
                badge.textContent = count > 99 ? '99+' : String(count);
                badge.style.display = count > 0 ? 'inline-flex' : 'none';
            })
            .catch(() => { badge.style.display = 'none'; });
        setTimeout(loadChatUnreadCount, 5000);
    })();
</script>
</body>
</html>
