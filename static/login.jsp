<%@ page import="java.sql.*"%>
<%@ page import="java.security.spec.KeySpec" %>
<%@ page import="java.util.Base64" %>
<%@ page import="javax.crypto.SecretKeyFactory" %>
<%@ page import="javax.crypto.spec.PBEKeySpec" %>

<!DOCTYPE html>
<html lang="en">

<%
    String db = "team4";
    String user = "root"; //assumes database name is the same as username
    String password = "GymShare"; //Replace with your MySQL password

    int ITERATIONS = 100000;
    int KEY_LENGTH = 256;
    byte[] salt = "hello".getBytes(); 
%>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="icon" type="image/x-icon" href="../assets/favicon.ico">
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <link href="https://fonts.googleapis.com/css?family=Catamaran:100,200,300,400,500,600,700,800,900" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css?family=Lato:100,100i,300,300i,400,400i,700,700i,900,900i" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../static/home.css">
    <link rel="stylesheet" type="text/css" href="../static/login.css">
    <title>Login</title>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom fixed-top">
        <div class="container px-5">
            <a class="navbar-brand" href="home.jsp">Gym Share</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation"><span class="navbar-toggler-icon"></span></button>
            <div class="collapse navbar-collapse" id="navbarResponsive">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link" href="signup.jsp">Sign Up</a></li>
                    <li class="nav-item"><a class="nav-link" href="login.jsp">Log In</a></li>
                </ul>
            </div>
        </div>
    </nav>
    
    <div style="padding-top: 80px;">
        <div class="header-container">
            <h1>Login</h1>
        </div>
    <form action="login.jsp" method="post">
        <label for="email">Email:</label>
        <input type="email" id="email" name="email" required>


        <label for="password">Password:</label>
        <div style="position: relative; display: inline-block; width: 100%;">
            <input type="password" id="password" name="password" required style="padding-right: 40px; width: 100%;">
            <button type="button" id="togglePassword" style="position: absolute; right: 10px; top: 40%; transform: translateY(-50%); background: none; border: none; cursor: pointer; font-size: 16px;" onclick="togglePasswordVisibility()">
                <i class="fas fa-eye" id="eyeIcon"></i>
            </button>
        </div>

        <input type="submit" value="Login">
    </form>
    </div> 
    
    <%
	if (request.getMethod().equalsIgnoreCase("POST")) {
	    Connection con = null;
	    PreparedStatement userStmt = null;
	    ResultSet rs = null;
	
	    try {
	        Class.forName("com.mysql.cj.jdbc.Driver");
	        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/team4?autoReconnect=true&useSSL=false", user, password);
	
	        String email = request.getParameter("email");
	        String pass = request.getParameter("password");
	
	        KeySpec spec = new PBEKeySpec(pass.toCharArray(), salt, ITERATIONS, KEY_LENGTH);
	        SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
	        byte[] hash = factory.generateSecret(spec).getEncoded();
	        pass = Base64.getEncoder().encodeToString(hash);
	
	        // Check if user exists
	        String getUser = "SELECT User_ID, First_Name, Last_Name, Username, Email FROM Users WHERE Email = ? AND Password = ?";
	        userStmt = con.prepareStatement(getUser);
	        userStmt.setString(1, email);
	        userStmt.setString(2, pass);
	        rs = userStmt.executeQuery();
	
	        if (rs.next()) {
	            int userID = rs.getInt("User_ID");
	
	            session.setAttribute("userID", userID);
	            session.setAttribute("firstName", rs.getString("First_Name"));
	            session.setAttribute("lastName", rs.getString("Last_Name"));
	            session.setAttribute("username", rs.getString("Username"));
	            session.setAttribute("email", rs.getString("Email"));
	            session.setAttribute("isLoggedIn", true);
	
	            rs.close();
	            userStmt.close();
	
	            // Check if admin
	            PreparedStatement adminStmt = con.prepareStatement("SELECT Admin_ID FROM Admin WHERE User_ID = ?");
	            adminStmt.setInt(1, userID);
	            ResultSet adminCheck = adminStmt.executeQuery();
	
	            if (adminCheck.next()) {
	                adminCheck.close();
	                adminStmt.close();
	                con.close();
	                response.sendRedirect("admin_dashboard.jsp");
	                return;
	            }
	            adminCheck.close();
	            adminStmt.close();
	
	            // Check if guest
	            PreparedStatement guestStmt = con.prepareStatement("SELECT User_ID FROM Guests WHERE User_ID = ?");
	            guestStmt.setInt(1, userID);
	            ResultSet guestCheck = guestStmt.executeQuery();
	
	            if (guestCheck.next()) {
	                guestCheck.close();
	                guestStmt.close();
	                con.close();
	                response.sendRedirect("guest_dashboard.jsp");
	                return;
	            }
	            guestCheck.close();
	            guestStmt.close();
	
	            // If not guest, assume host
	            PreparedStatement updateStmt = con.prepareStatement("UPDATE Bookings SET Status = 'Completed' WHERE Booking_Date < CURDATE() AND Status <> 'Cancelled'");
	            updateStmt.executeUpdate();
	            updateStmt.close();
	
	            con.close();
	            response.sendRedirect("host_dashboard.jsp");
	        } else {
	            if (rs != null) rs.close();
	            if (userStmt != null) userStmt.close();
	            if (con != null) con.close();
	            out.println("<script>var loginError = true;</script>");
	        }
	
	    } catch (SQLException e) {
	        out.println("SQLException: " + e.getMessage());
	    } catch (Exception e) {
	        out.println("Exception: " + e.getMessage());
	    }
	}
	%>

    <!-- Bootstrap core JS-->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function togglePasswordVisibility() {
            const passwordField = document.getElementById('password');
            const eyeIcon = document.getElementById('eyeIcon');
            
            if (passwordField.type === 'password') {
                passwordField.type = 'text';
                eyeIcon.className = 'fas fa-eye-slash';
            } else {
                passwordField.type = 'password';
                eyeIcon.className = 'fas fa-eye';
            }
        }
        
        window.onload = function() {
            if (typeof loginError !== 'undefined' && loginError) {
                alert('Login Failed!\n\nIncorrect email or password.\nPlease try again.');
            }
        }

    </script>
</body>
</html>