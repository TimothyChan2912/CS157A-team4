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
    <style>
    	.back-button {
    		position: absolute;
    		top: 110px;
    		left: 20px;
    		background: linear-gradient(135deg, #FF3C38 0%, #e74c3c 100%);
    		color: white;
    		border: none;
    		padding: 10px 20px;
    		border-radius: 8px;
    		cursor: pointer;
    		font-weight: 600;
    		font-size: 0.9rem;
    		text-transform: uppercase;
    		letter-spacing: 0.5px;
    		transition: all 0.3s ease;
    		box-shadow: 0 4px 15px rgba(255, 60, 56, 0.3);
    		z-index: 1000;
		}

		.back-button:hover {
    		background: linear-gradient(135deg, #FFD100 0%, #f39c12 100%);
    		color: #2c3e50;
    		transform: translateY(-2px);
    		box-shadow: 0 6px 20px rgba(255, 209, 0, 0.4);
		}
    	
        .settings-container {
            max-width: 600px;
            margin: 100px auto;
            padding: 30px;
            background: linear-gradient(145deg, #ffffff, #f9f9f9);
            border-radius: 16px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.08);
            border: 1px solid rgba(0, 0, 0, 0.05);
        }

        .settings-form input,
        .settings-form textarea {
            width: 100%;
            box-sizing: border-box;
            padding: 12px 16px;
            font-size: 1rem;
            border: 2px solid #e8ecef;
            border-radius: 8px;
            background-color: #f0f0f0;
            color: #2c3e50;
            transition: all 0.3s ease;
        }

        .settings-form textarea {
            min-height: 120px;
            resize: vertical;
        }

        .profile-display {
            text-align: center;
            margin-bottom: 30px;
        }

        .profile-display img {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border-radius: 50%;
            border: 2px solid #ddd;
        }

        .profile-display .joined-date {
            margin-top: 10px;
            font-size: 0.9rem;
            color: #666;
        }

        .button-row {
            display: flex;
            justify-content: space-between;
            gap: 20px;
            margin-top: 20px;
        }

        .edit-button, .save-button {
            background: linear-gradient(135deg, #FF3C38 0%, #e74c3c 100%);
            color: white;
            border: none;
            padding: 12px;
            font-weight: 600;
            font-size: 1rem;
            border-radius: 8px;
            cursor: pointer;
            flex: 1;
            transition: all 0.3s ease;
            text-transform: uppercase;
        }

        .edit-button:hover, .save-button:hover {
            background: linear-gradient(135deg, #FFD100 0%, #f39c12 100%);
            color: #2c3e50;
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(255, 209, 0, 0.4);
        }

        .password-field {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .toggle-password {
            padding: 8px 12px;
            font-size: 0.85rem;
            cursor: pointer;
            border: none;
            background-color: #ccc;
            border-radius: 6px;
            font-weight: 600;
        }
        
        .delete-account-button {
    		background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
    		color: white;
    		border: none;
    		padding: 12px 24px;
    		font-size: 1rem;
    		font-weight: 600;
    		border-radius: 8px;
    		cursor: pointer;
    		text-transform: uppercase;
    		transition: all 0.3s ease;
    		box-shadow: 0 4px 15px rgba(220, 53, 69, 0.3);
		}

		.delete-account-button:hover {
   			background: linear-gradient(135deg, #a71e2a 0%, #941a26 100%);
    		transform: translateY(-2px);
    		box-shadow: 0 6px 20px rgba(167, 30, 42, 0.4);
		}     
    </style>
    <script>
        function toggleEdit() {
    const fields = document.querySelectorAll('.settings-form input, .settings-form textarea');
    fields.forEach(field => {
        field.removeAttribute('readonly');
        field.style.backgroundColor = '#ffffff';
    });
}

        function togglePassword() {
            const pwd = document.getElementById('password');
            pwd.type = pwd.type === 'password' ? 'text' : 'password';
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
        <img src="<%= profilePicture %>" alt="Profile Picture">
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
