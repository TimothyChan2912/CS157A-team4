<%@ page import="java.sql.*" %>
<%
    Boolean isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");
    if (isLoggedIn == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String firstName = (String) session.getAttribute("firstName");
    Integer userID = (Integer) session.getAttribute("userID");

    String db = "team4", user = "root", password = "GymShare";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - Gym Share</title>
    <link rel="stylesheet" href="../static/home.css">
    <link rel="stylesheet" href="../static/navbar.css">
    <link rel="stylesheet" href="../static/dashboard.css">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v6.3.0/css/all.css" crossorigin="anonymous">
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark navbar-custom fixed-top">
    <div class="container px-5">
        <a class="navbar-brand" href="home.jsp">Gym Share</a>
        <div class="navbar-title"><h1>Admin Dashboard</h1></div>
        <div class="collapse navbar-collapse" id="navbarResponsive">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item"><a class="nav-link" href="login.jsp">Log Out</a></li>
            </ul>
        </div>
    </div>
</nav>

<div style="padding-top: 100px;">
    <div class="dashboard-layout">
        <div class="main-content">
            <div class="host-actions-container">
                <h2>Admin Actions</h2>
                <div class="actions-buttons-container vertical">
                    <button class="my-gyms-button" onclick="location.href='admin_view_listings.jsp'">
                        <i class="fas fa-search"></i> View Listings
                    </button>

                    <button class="bookings-button" onclick="location.href='admin_booking_log.jsp'">
                        <i class="fas fa-file-alt"></i> Booking Log
                    </button>

                    <button class="calendar-button" onclick="location.href='admin_support_tickets.jsp'">
                        <i class="fas fa-headset"></i> Support Tickets
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
