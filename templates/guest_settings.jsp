<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setCharacterEncoding("UTF-8");
    Boolean isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");
    if (isLoggedIn == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String firstName = (String) session.getAttribute("firstName");
    String lastName = (String) session.getAttribute("lastName");
    String username = (String) session.getAttribute("username");
    String email = (String) session.getAttribute("email");
    Integer userID = (Integer) session.getAttribute("userID");

    String joinDate = "";
    String passwordHidden = "";
String userBio = "";
    try {
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/team4?autoReconnect=true&useSSL=false", "root", "GymShare");
        PreparedStatement stmt = con.prepareStatement("SELECT Password, Bio FROM Users WHERE User_ID = ?");
        stmt.setInt(1, userID);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            passwordHidden = rs.getString("Password");
            userBio = rs.getString("Bio") != null ? rs.getString("Bio") : "";
        }
        rs.close();
        stmt.close();
        con.close();
    } catch (Exception e) {
        out.println("<p>Error loading password: " + e.getMessage() + "</p>");
    }
    String profilePicture = "../assets/img/default_profile.jpg";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/team4?autoReconnect=true&useSSL=false", "root", "GymShare");
        PreparedStatement stmt = con.prepareStatement("SELECT Date_Created FROM Users WHERE User_ID = ?");
        stmt.setInt(1, userID);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            java.sql.Timestamp dateCreated = rs.getTimestamp("Date_Created");
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("MMMM yyyy");
            joinDate = sdf.format(dateCreated);
        }
        rs.close();
        stmt.close();
        con.close();
    } catch (Exception e) {
        out.println("<p>Error loading join date: " + e.getMessage() + "</p>");
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Settings - Gym Share</title>
    <link rel="stylesheet" href="../static/home.css">
    <link rel="stylesheet" href="../static/navbar.css">
    <link rel="stylesheet" href="../static/dashboard.css">
    <link rel="stylesheet" href="../static/settings.css">
    <script>
    function toggleEdit() {
    const fields = document.querySelectorAll('.settings-form input, .settings-form textarea');
    fields.forEach(field => {
        field.removeAttribute('readonly');
        field.style.backgroundColor = '#ffffff';
    });
}
    </script>
</head>

<body>
<nav class="navbar navbar-expand-lg navbar-dark navbar-custom fixed-top">
    <div class="container px-5">
        <a class="navbar-brand" href="home.jsp">Gym Share</a>
        <div class="collapse navbar-collapse" id="navbarResponsive">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item"><a class="nav-link" href="guest_dashboard.jsp">Dashboard</a></li>
                <li class="nav-item"><a class="nav-link" href="login.jsp">Log Out</a></li>
            </ul>
        </div>
    </div>
</nav>
<div class="main-content">
    <button class="back-button" onclick="location.href='guest_dashboard.jsp'">Back to Dashboard</button>
</div>
<div class="settings-container">
    <h2>Account Settings</h2>

    <div class="profile-display">
    <form method="post" action="upload_profile_picture.jsp" enctype="multipart/form-data">
	    <label for="profilePictureInput">
	        <img src="<%= profilePicture %>" alt="Profile Picture" style="cursor: pointer;" title="Click to upload a new profile picture" />
	    </label>
	    <input type="file" name="profilePicture" id="profilePictureInput" accept="image/*" style="display: none;" onchange="this.form.submit()" />
	    </form>
	    <div class="joined-date">Joined <%= joinDate %></div>
	</div>

    <form class="settings-form" method="post" action="update_guest_settings.jsp">
        <label for="firstName">First Name:</label>
        <input type="text" name="firstName" id="firstName" value="<%= firstName %>" readonly>

        <label for="lastName">Last Name:</label>
        <input type="text" name="lastName" id="lastName" value="<%= lastName %>" readonly>

        <label for="email">Email:</label>
        <input type="email" name="email" id="email" value="<%= email %>" readonly>

        <label for="username">Username:</label>
        <input type="text" name="username" id="username" value="<%= username %>" readonly>

        <label for="bio">Profile Bio:</label>
        <textarea name="bio" id="bio" readonly placeholder="Write a short bio about yourself..."><%= userBio %></textarea>

        <div class="button-row">
            <button type="button" class="edit-button" onclick="toggleEdit()">Edit</button>
            <button type="submit" class="save-button">Save Changes</button>
        </div>
    </form>
</div>
<div style="text-align: center; margin-top: 30px;">
    <form action="delete_account.jsp" method="post" onsubmit="return confirm('Are you sure you want to permanently delete your account? This cannot be undone.');">
        <button type="submit" class="delete-account-button">Delete My Account</button>
    </form>
</div>
</body>
</html>
