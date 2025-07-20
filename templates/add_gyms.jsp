<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="en">

<%
    Boolean isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");
    if (isLoggedIn == null || !isLoggedIn) {
        response.sendRedirect("login.jsp");
        return;
    }
    Integer userID = (Integer) session.getAttribute("userID");
    String firstName = (String) session.getAttribute("firstName");

    String db = "team4";
    String user = "root"; //assumes database name is the same as username
    String password = "GymShare"; //Replace with your MySQL password
%>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="icon" type="image/x-icon" href="../assets/favicon.ico">
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <link href="https://fonts.googleapis.com/css?family=Catamaran:100,200,300,400,500,600,700,800,900" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css?family=Lato:100,100i,300,300i,400,400i,700,700i,900,900i" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../static/home.css">
    <link rel="stylesheet" type="text/css" href="../static/navbar.css">
    <link rel="stylesheet" type="text/css" href="../static/listings.css">
    <title>Dashboard - Gym Share</title>
</head>

<body>
    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom fixed-top">
        <div class="container px-5">
            <a class="navbar-brand" href="../home.html">Gym Share</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation"><span class="navbar-toggler-icon"></span></button>
            <div class="collapse navbar-collapse" id="navbarResponsive">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link">Welcome <%= firstName %>!</a></li>
                    <li class="nav-item"><a class="nav-link" href="login.jsp">Log Out</a></li>
                </ul>
            </div>
        </div>
    </nav>


    <div style="padding-top: 80px;">
        <div class="header-container">
            <button class="back-button" onclick="window.location.href='host_dashboard.jsp'">Back</button>
            <h1>Add Listing</h1>
        </div>

    
        <form action="add_gyms.jsp" method="post">
            <label for="gymName">Gym Name:</label>
            <input type="text" id="gymName" name="gymName" required>

            <label for="description">Description:</label>
            <textarea id="description" name="description" required></textarea>

            <label for="address">Address:</label>
            <input type="text" id="address" name="address" required>

            <label for="price">Price:</label>
            <input type="number" id="price" name="price" required>

            <input type="hidden" name="userID" value="<%= userID %>">

            <input type="submit" value="Add Listing">
        </form>
    </div>

    <%
        if(request.getMethod().equalsIgnoreCase("POST")) {
            try {
                java.sql.Connection con;
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/team4?autoReconnect=true&useSSL=false", user, password);

                String gymName = request.getParameter("gymName");
                String description = request.getParameter("description");
                String address = request.getParameter("address");
                String price = request.getParameter("price");

                Statement stmt = con.createStatement();
                String insertGym = "INSERT INTO Gyms (Gym_Name, Description, Address, Price) "
                                    + "VALUES ('" + gymName + "', '" + description + "', '" + address + "', '" + price + "')";

                stmt.execute(insertGym);

                String insertOwns = "INSERT INTO Owns (User_ID, Gym_ID) "
                                    + "VALUES (" + userID + ", LAST_INSERT_ID())";

                stmt.execute(insertOwns);

                stmt.close();
                con.close();

                response.sendRedirect("host_dashboard.jsp");
                return;
            }
            catch (SQLException e) {
                out.println("SQLException:" + e.getMessage());
            }
        }
    %>

</body>
</html>
