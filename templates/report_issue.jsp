<%@ page import="java.sql.*" %>
<%
    Boolean isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");
    if (isLoggedIn == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Integer userID = (Integer) session.getAttribute("userID");
    String firstName = (String) session.getAttribute("firstName");
    String db = "team4", user = "root", password = "GymShare";

    String gymIDParam = request.getParameter("gymID");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Report an Issue</title>
    <link rel="stylesheet" href="../static/home.css">
    <link rel="stylesheet" href="../static/navbar.css">
    <link rel="stylesheet" href="../static/report.css">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom fixed-top">
        <div class="container px-5">
            <a class="navbar-brand" href="home.jsp">Gym Share</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation"><span class="navbar-toggler-icon"></span></button>
            <div class="collapse navbar-collapse" id="navbarResponsive">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link">Welcome <%= firstName %>!</a></li>
                    <li class="nav-item"> <a class="nav-link" href="guest_settings.jsp"> <i class="fas fa-cog"></i> Settings </a> </li>
                    <li class="nav-item"><a class="nav-link" href="login.jsp">Log Out</a></li>
                </ul>
            </div>
        </div>
    </nav>
<%
    String backURL = "view_listings.jsp";
    if (gymIDParam != null && !gymIDParam.trim().isEmpty()) {
        backURL = "gym_details.jsp?gymID=" + gymIDParam;
    }
%>
<div class="main-content">
    <button class="back-button" onclick="location.href='<%= backURL %>'">Back to Gym Details</button>
</div>
<div class="report-form-container">
    <h2>Report an Issue</h2>
    <form class="report-form" action="submit_ticket.jsp" method="post">
        <input type="hidden" name="userID" value="<%= userID %>">
        <input type="hidden" name="gymID" value="<%= gymIDParam %>">
        <label for="content">Please describe the issue:</label><br>
        <textarea name="content" required></textarea><br>
        <button type="submit">Submit Ticket</button>
    </form>
</div>
</body>
</html>
