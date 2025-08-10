<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
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
    String userBio = "", profilePicture = "../assets/img/default_profile.jpg";

    try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/team4", "root", "GymShare")) {
        PreparedStatement stmt = con.prepareStatement("SELECT Password, Bio, Date_Created FROM Users WHERE User_ID = ?");
        stmt.setInt(1, userID);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            userBio = rs.getString("Bio") != null ? rs.getString("Bio") : "";
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("MMMM yyyy");
            joinDate = sdf.format(rs.getTimestamp("Date_Created"));
        }
        rs.close(); stmt.close();
    } catch (Exception e) {
        out.println("<p>Error loading user data: " + e.getMessage() + "</p>");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Settings - Gym Share</title>
    <link rel="stylesheet" href="../static/home.css">
    <link rel="stylesheet" href="../static/navbar.css">
    <link rel="stylesheet" href="../static/settings.css">
    <style>
        .settings-layout { display: flex; margin-top: 140px; }
        .settings-sidebar {
            width: 200px;
            padding: 20px;
            background-color: #f4f4f4;
            border-right: 1px solid #ddd;
        }
        .settings-sidebar button {
            display: block;
            width: 100%;
            margin-bottom: 10px;
            padding: 10px;
            font-weight: bold;
            cursor: pointer;
        }
        .settings-content {
            flex: 1;
            padding: 30px;
        }
        .hidden { display: none; }
        .password-field { margin-top: 20px; }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark navbar-custom fixed-top">
        <div class="container px-5">
            <a class="navbar-brand" href="home.jsp">Gym Share</a>
            <div class="navbar-title">
                <h1>Settings</h1>
            </div>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation"><span class="navbar-toggler-icon"></span></button>
            <div class="collapse navbar-collapse" id="navbarResponsive">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link">Welcome <%= firstName %>!</a></li>
                    <li class="nav-item"><a class="nav-link" href="login.jsp">Log Out</a></li>
                </ul>
            </div>
        </div>
    </nav>
<div class="main-content">
    <button class="back-button" onclick="location.href='host_dashboard.jsp'">Back to Dashboard</button>
</div>

<div class="settings-layout">
    <!-- Sidebar -->
    <div class="settings-sidebar">
        <button onclick="showTab('profile')">Profile Info</button>
        <button onclick="showTab('tickets')">My Tickets</button>
    </div>

    <!-- Main Content -->
    <div class="settings-content">
        <!-- Profile Tab -->
        <div id="profile" class="tab-content">
            <h2>Profile</h2>
            <div class="profile-display">
                <form method="post" action="upload_profile_picture.jsp" enctype="multipart/form-data">
                    <label for="profilePictureInput">
                        <img src="<%= profilePicture %>" alt="Profile Picture" style="cursor: pointer;" />
                    </label>
                    <input type="file" name="profilePicture" id="profilePictureInput" accept="image/*" style="display: none;" onchange="this.form.submit()" />
                </form>
                <div class="joined-date">Joined <%= joinDate %></div>
            </div>

            <form class="settings-form" method="post" action="update_host_settings.jsp">
                <label>First Name:</label>
                <input type="text" name="firstName" value="<%= firstName %>" readonly>

                <label>Last Name:</label>
                <input type="text" name="lastName" value="<%= lastName %>" readonly>

                <label>Email:</label>
                <input type="email" name="email" value="<%= email %>" readonly>

                <label>Username:</label>
                <input type="text" name="username" value="<%= username %>" readonly>

                <label>Bio:</label>
                <textarea name="bio" readonly><%= userBio %></textarea>

                <div class="button-row">
                    <button type="button" class="edit-button" onclick="toggleEdit()">Edit</button>
                    <button type="submit" class="save-button">Save Changes</button>
                </div>
            </form>

            <!-- Change Password -->
            <form method="post" action="change_password.jsp" class="password-field">
                <h3>Change Password</h3>
                <label>Current Password:</label>
                <input type="password" name="currentPassword" required>

                <label>New Password:</label>
                <input type="password" name="newPassword" required>

                <button type="submit" class="save-button">Change Password</button>
            </form>

            <!-- Delete Account -->
            <form action="delete_account.jsp" method="post" onsubmit="return confirm('Are you sure? This cannot be undone.');" class="password-field">
                <h3>Delete Account</h3>
                <label>Enter Password to Confirm:</label>
                <input type="password" name="confirmPassword" required>
                <button type="submit" class="delete-account-button">Delete My Account</button>
            </form>
        </div>

        <!-- Tickets Tab -->
        <div id="tickets" class="tab-content hidden">
            <h2>Submitted Tickets</h2>
            <%
                try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/team4", "root", "GymShare")) {
                    String sql = "SELECT T.Ticket_ID, T.Content, T.Time, T.Status FROM Tickets T JOIN Reports R ON T.Ticket_ID = R.Ticket_ID WHERE R.User_ID = ?";
                    PreparedStatement ps = con.prepareStatement(sql);
                    ps.setInt(1, userID);
                    ResultSet rs = ps.executeQuery();

                    SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy h:mm a");

                    while (rs.next()) {
                        int id = rs.getInt("Ticket_ID");
                        String content = rs.getString("Content");
                        String time = sdf.format(rs.getTimestamp("Time"));
                        String status = rs.getString("Status");
            %>
                <div style="border: 1px solid #ccc; padding: 10px; border-radius: 8px; margin-bottom: 15px;">
                    <p><strong>Ticket #<%= id %></strong></p>
                    <p><%= content %></p>
                    <small><%= time %> — Status: <%= status %></small>
                </div>
            <%
                    }
                    rs.close(); ps.close();
                } catch (Exception e) {
                    out.println("<p>Error loading tickets: " + e.getMessage() + "</p>");
                }
            %>
        </div>
    </div>
</div>

<script>
    function toggleEdit() {
        const fields = document.querySelectorAll('.settings-form input, .settings-form textarea');
        fields.forEach(field => {
            field.removeAttribute('readonly');
            field.style.backgroundColor = '#fff';
        });
    }

    function showTab(tab) {
        document.querySelectorAll('.tab-content').forEach(div => div.classList.add('hidden'));
        document.getElementById(tab).classList.remove('hidden');
    }
</script>
</body>
</html>
