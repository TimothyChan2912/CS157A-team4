<%@ page import="java.sql.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.security.spec.KeySpec" %>
<%@ page import="java.util.Base64" %>
<%@ page import="javax.crypto.SecretKeyFactory" %>
<%@ page import="javax.crypto.spec.PBEKeySpec" %>

<!DOCTYPE html>
<html lang="en">

<% 
    String db="team4";
    String user="root"; //assumes database name is the same as username
    String password="GymShare"; //Replace with your MySQL password
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
    <link rel="stylesheet" type="text/css" href="../static/home.css">
    <link rel="stylesheet" type="text/css" href="../static/signup.css">
    <title>Signup - Gym Share</title>
</head>

<body>
    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom fixed-top">
        <div class="container px-5">
            <a class="navbar-brand" href="../home.jsp">Gym Share</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation"><span class="navbar-toggler-icon"></span></button>
            <div class="collapse navbar-collapse" id="navbarResponsive">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link" href="signup.jsp">Sign Up</a></li>
                    <li class="nav-item"><a class="nav-link" href="login.jsp">Log In</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="main-wrapper">
        <div class="title-section">
            <h1>Signup</h1>
        </div>

        <div class="content-layout">
            <form action="signup.jsp" method="post">
                <div class="left-container">
                    <div class="header-container">
                        <h2>Select Your Role</h2>
                    </div>
                    <div class="role-selection">
                        <div class="radio-option">
                                <input type="radio" id="guest" name="role" value="guest" checked>
                                <label for="guest">
                                    <div class="role-title">Guest</div>
                                    <div class="role-description">Pick the best fitting gym to rent</div>
                                </label>
                        </div>
                        <div class="radio-option">
                            <input type="radio" id="host" name="role" value="host">
                                <label for="host">
                                    <div class="role-title">Host</div>
                                    <div class="role-description">Monetize your home gym</div>
                                </label>
                        </div>
                    </div>
                </div>

                <div class="right-container">
                    <label for="firstName">First Name:</label>
                    <input type="text" id="firstName" name="firstName" required>

                    <label for="lastName">Last Name:</label>
                    <input type="text" id="lastName" name="lastName" required>

                    <label for="username">Username:</label>
                    <input type="text" id="username" name="username" required>

                    <label for="email">Email:</label>
                    <input type="email" id="email" name="email" required>

                    <label for="password">Password:</label>
                    <div class="password-wrapper">
                        <input type="password" id="password" name="password" required oninput="checkPasswordStrength()">
                            <button type="button" id="togglePassword" onclick="togglePasswordVisibility()">
                                <i class="fas fa-eye" id="eyeIcon"></i>
                            </button>
                    </div>

                    <div id="passwordRequirements">
                        <div id="lengthReq">At least 8 characters</div>
                        <div id="uppercaseReq">One uppercase letter (A-Z)</div>
                        <div id="lowercaseReq">One lowercase letter (a-z)</div>
                        <div id="numberReq">One number (0-9)</div>
                        <div id="specialReq">One special character (!@#$%^&*)</div>
                    </div>

                    <input type="submit" value="Signup">
            </form>
        </div>
    </div>

    <% 
    if(request.getMethod().equalsIgnoreCase("POST")) { 
        try { 
            java.sql.Connection con;
            Class.forName("com.mysql.cj.jdbc.Driver");
            con=DriverManager.getConnection("jdbc:mysql://localhost:3306/team4?autoReconnect=true&useSSL=false", user, password); 
            
            String firstName=request.getParameter("firstName"); 
            String lastName=request.getParameter("lastName"); 
            String username=request.getParameter("username"); 
            String email=request.getParameter("email"); 
            String pass=request.getParameter("password"); 

            if(pass.length() < 8) { 
                out.println("<script>var passwordLengthError = true;</script>");
                con.close();
                return;
            }

            if(!pass.matches(".*[A-Z].*")) {
                out.println("<script>var passwordUppercaseError = true;</script>");
                con.close();
                return;
            }

            if(!pass.matches(".*[a-z].*")) {
                out.println("<script>var passwordLowercaseError = true;</script>");
                con.close();
                return;
            }

            if(!pass.matches(".*[0-9].*")) {
                out.println("<script>var passwordNumberError = true;</script>");
                con.close();
                return;
            }

            if(!pass.matches(".*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?].*")) {
                out.println("<script>var passwordSpecialError = true;</script>");
                con.close();
                return;
            }

           

            KeySpec spec = new PBEKeySpec(pass.toCharArray(), salt, ITERATIONS, KEY_LENGTH);
            SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
            byte[] hash = factory.generateSecret(spec).getEncoded();
            pass = Base64.getEncoder().encodeToString(hash);
            
            java.util.Date now = new java.util.Date();
            java.sql.Date sqlDate = new java.sql.Date(now.getTime());

            Statement stmt = con.createStatement();
            String insertUser = "INSERT INTO Users (First_Name, Last_Name, Email, Username, Password, Date_Created) "
                                + "VALUES ('" + firstName + "', '" + lastName + "', '" + email + "', '" + username + "', '" + pass + "', '" + sqlDate + "')";
            stmt.execute(insertUser);

            String getUserID = "SELECT LAST_INSERT_ID() AS User_ID";
            ResultSet rs = stmt.executeQuery(getUserID);
            int newUserID = 0;
            if(rs.next()) {
                newUserID = rs.getInt("User_ID");
            }
            rs.close();

            if (request.getParameter("role").equals("host")) {
                String insertHost = "INSERT INTO Hosts (User_ID) "
                                    + "VALUES (" + newUserID + ")";
                stmt.execute(insertHost);
            }
                                
            if (request.getParameter("role").equals("guest")) {
                String insertGuest = "INSERT INTO Guests (User_ID) "
                                    + "VALUES (" + newUserID + ")";
                stmt.execute(insertGuest);
            }

            session.setAttribute("userID", newUserID);
            session.setAttribute("firstName", firstName);
            session.setAttribute("lastName", lastName);
            session.setAttribute("username", username);
            session.setAttribute("email", email);
            session.setAttribute("isLoggedIn", true);

            stmt.close();
            con.close();

            if(request.getParameter("role").equals("host")) {
                response.sendRedirect("host_dashboard.jsp");
            } 
            else {
                response.sendRedirect("guest_dashboard.jsp");
            }
            return;
        } 
        catch (SQLException e) {
            out.println("SQLException:" + e.getMessage());
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

    function checkPasswordStrength() {
        const password = document.getElementById('password').value;
        const lengthReq = document.getElementById('lengthReq');
        
        if (password.length >= 8) {
            lengthReq.style.color = '#28a745';
        } 
        else {
            lengthReq.style.color = '#dc3545';
        }

        const uppercaseReq = document.getElementById('uppercaseReq');
        if (/[A-Z]/.test(password)) {
            uppercaseReq.style.color = '#28a745';
        } 
        else {
            uppercaseReq.style.color = '#dc3545';
        }

        const lowercaseReq = document.getElementById('lowercaseReq');
        if (/[a-z]/.test(password)) {
            lowercaseReq.style.color = '#28a745';
        } 
        else {
            lowercaseReq.style.color = '#dc3545';
        }

        const numberReq = document.getElementById('numberReq');
        if (/[0-9]/.test(password)) {
            numberReq.style.color = '#28a745';
        } 
        else {
            numberReq.style.color = '#dc3545';
        }

        const specialReq = document.getElementById('specialReq');
        if (/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(password)) {
            specialReq.style.color = '#28a745';
        } 
        else {
            specialReq.style.color = '#dc3545';
        }
    }

    window.onload = function () {
        if (typeof passwordLengthError !== 'undefined' && passwordLengthError) {
            alert('Password Invalid!\n\nPassword must be at least 8 characters long.\nPlease try again.');
        }
        else if (typeof passwordUppercaseError !== 'undefined' && passwordUppercaseError) {
            alert('Password Invalid!\n\nPassword must contain at least one uppercase letter (A-Z).\nPlease try again.');
        }
        else if (typeof passwordLowercaseError !== 'undefined' && passwordLowercaseError) {
            alert('Password Invalid!\n\nPassword must contain at least one lowercase letter (a-z).\nPlease try again.');
        }
        else if (typeof passwordNumberError !== 'undefined' && passwordNumberError) {
            alert('Password Invalid!\n\nPassword must contain at least one number (0-9).\nPlease try again.');
        }
        else if (typeof passwordSpecialError !== 'undefined' && passwordSpecialError) {
            alert('Password Invalid!\n\nPassword must contain at least one special character\n(!@#$%^&*()_+-=[]{};\':"|,.<>/?)\nPlease try again.');
        }
    }
</script>
</body>
</html>