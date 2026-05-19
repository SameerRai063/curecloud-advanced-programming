<%@ page pageEncoding="UTF-8" %>
<%@ page import="Notification.Model.Notification" %>
<%@ page import="Notification.Model.dao.NotificationDAO" %>
<%@ page import="java.util.List" %>
<%
    String userName = (session.getAttribute("userName") != null) ? (String) session.getAttribute("userName") : "User";
    String userRole = (session.getAttribute("userRole") != null) ? (String) session.getAttribute("userRole") : "user";
    Integer userId = (session.getAttribute("userId") instanceof Integer) ? (Integer) session.getAttribute("userId") : null;

    String dashboardUrl = request.getContextPath() + "/";
    if ("admin".equalsIgnoreCase(userRole)) {
        dashboardUrl = request.getContextPath() + "/Admin-dashboard";
    } else if ("doctor".equalsIgnoreCase(userRole)) {
        dashboardUrl = request.getContextPath() + "/doctorDashboard";
    } else if ("receptionist".equalsIgnoreCase(userRole)) {
        dashboardUrl = request.getContextPath() + "/Receptionist-dashboard";
    } else if ("patient".equalsIgnoreCase(userRole)) {
        dashboardUrl = request.getContextPath() + "/patient/dashboard.jsp";
    }

    List<Notification> notifications = java.util.Collections.emptyList();
    int unreadCount = 0;
    if (userId != null) {
        try {
            NotificationDAO notificationDAO = new NotificationDAO();
            notifications = notificationDAO.getNotificationsForUser(userId);
            unreadCount = notificationDAO.countUnreadForUser(userId);
        } catch (Exception e) {
            throw new RuntimeException("Unable to load notifications", e);
        }
    }

    java.util.function.Function<String, String> esc = value -> {
        if (value == null) return "";
        return value.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    };
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Notifications - Upachaar</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
</head>
<body class="min-h-screen bg-slate-50 font-[Inter] text-slate-900">
<header class="h-16 bg-white border-b border-slate-100 flex items-center justify-between px-10">
    <div>
        <h1 class="text-xl font-bold">Notifications</h1>
        <p class="text-sm text-slate-500"><%= userRole %> updates and system notices</p>
    </div>
    <div class="flex items-center gap-3">
        <a href="<%= dashboardUrl %>"
           class="rounded-full bg-slate-100 px-4 py-2 text-sm font-semibold text-slate-700 hover:bg-slate-200">
            Dashboard
        </a>
        <div class="flex items-center gap-3 border-l border-slate-200 pl-5">
            <span class="text-sm font-bold"><%= userName %></span>
            <span class="inline-flex size-10 items-center justify-center rounded-full bg-blue-100 text-[#0052FF]">
                <span class="material-symbols-outlined text-3xl">account_circle</span>
            </span>
        </div>
        <a href="<%= request.getContextPath() %>/logout"
           class="inline-flex items-center gap-2 rounded-full bg-slate-900 px-4 py-2 text-sm font-semibold text-white hover:bg-slate-700">
            <span class="material-symbols-outlined text-[20px]">logout</span>
            Logout
        </a>
    </div>
</header>

<main class="p-10">
    <section class="rounded-2xl border border-slate-100 bg-white p-8 shadow-sm">
        <div class="mb-6 flex items-center justify-between">
            <div>
                <h2 class="text-lg font-bold">Recent Notifications</h2>
                <p class="text-sm text-slate-500"><%= unreadCount %> unread notification<%= unreadCount == 1 ? "" : "s" %></p>
            </div>
            <form action="<%= request.getContextPath() %>/markAllNotificationsRead" method="post">
                <button type="submit"
                        class="inline-flex items-center gap-2 rounded-full bg-[#0052FF] px-4 py-2 text-sm font-semibold text-white hover:bg-blue-700 transition-colors"
                        <%= notifications.isEmpty() ? "disabled" : "" %>>
                    <span class="material-symbols-outlined text-[18px]">done_all</span>
                    Mark all as read
                </button>
            </form>
        </div>

        <% if (notifications.isEmpty()) { %>
            <div class="flex items-center gap-4 rounded-xl bg-blue-50 p-5 text-[#0052FF]">
                <span class="material-symbols-outlined text-3xl">notifications</span>
                <div>
                    <h2 class="font-semibold text-slate-900">No new notifications</h2>
                    <p class="text-sm text-slate-500">Updates and notices will appear here.</p>
                </div>
            </div>
        <% } else { %>
            <div class="space-y-3">
                <% for (Notification notification : notifications) { %>
                    <article class="rounded-xl border <%= notification.isRead() ? "border-slate-100 bg-white" : "border-blue-100 bg-blue-50" %> p-5">
                        <div class="flex items-start justify-between gap-4">
                            <div>
                                <h3 class="font-bold text-slate-900"><%= esc.apply(notification.getTitle()) %></h3>
                                <p class="mt-1 text-sm text-slate-600"><%= esc.apply(notification.getMessage()) %></p>
                            </div>
                            <span class="whitespace-nowrap text-xs font-semibold text-slate-400"><%= notification.getFormattedDate() %></span>
                        </div>
                    </article>
                <% } %>
            </div>
        <% } %>
    </section>
</main>
</body>
</html>
