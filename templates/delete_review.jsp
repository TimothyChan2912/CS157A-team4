<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    Boolean isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");
    if (isLoggedIn == null || !isLoggedIn) {
        response.sendRedirect("login.jsp");
        return;
    }

    int reviewID = Integer.parseInt(request.getParameter("reviewID"));
    int gymID = Integer.parseInt(request.getParameter("gymID"));

    String gymName = "";
    try {
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/team4", "root", "GymShare");
        PreparedStatement stmt = con.prepareStatement("SELECT Gym_Name FROM Gyms WHERE Gym_ID = ?");
        stmt.setInt(1, gymID);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            gymName = rs.getString("Gym_Name");
        }
        rs.close();
        stmt.close();
        con.close();
    } catch (Exception e) {
        out.println("Error loading gym name: " + e.getMessage());
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Delete Review</title>
    <link rel="stylesheet" href="../static/home.css">
    <link rel="stylesheet" href="../static/navbar.css">
    <link rel="stylesheet" href="../static/my_gyms.css"> <!-- reusing existing styling -->
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom fixed-top">
        <div class="container px-5">
            <a class="navbar-brand" href="../home.jsp">Gym Share</a>
            <div class="collapse navbar-collapse" id="navbarResponsive">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link" href="login.jsp">Log Out</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="main-content">
        <button class="back-button" onclick="history.back()">Back</button>

        <div class="header-container">
            <h1>Delete Review for <%= gymName %></h1>
        </div>

        <form method="post" action="delete_review_submit.jsp">
            <input type="hidden" name="reviewID" value="<%= reviewID %>">
            <input type="hidden" name="gymID" value="<%= gymID %>">

            <label for="reason">Select a reason for deletion:</label>
            <select name="reason" id="reason" required>
                <option value="">-- Choose a reason --</option>
                <option value="Inappropriate language">Inappropriate language</option>
                <option value="Spam or self-promotion">Spam or self-promotion</option>
                <option value="Fake or misleading content">Fake or misleading content</option>
                <option value="Personal attack or harassment">Personal attack or harassment</option>
            </select>

            <label for="comment">Additional comment (optional):</label>
            <textarea name="comment" id="comment" placeholder="Add explanation if needed..."></textarea>

            <button type="submit" class="save-button">Confirm Delete</button>
        </form>
    </div>
</body>
</html>
