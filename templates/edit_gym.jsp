<%@ page import="java.sql.*"%>

<!DOCTYPE html>
<html lang="en">

<%
    Boolean isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");
    if (isLoggedIn == null || !isLoggedIn) {
        response.sendRedirect("login.jsp");
        return;
    }

    String firstName = (String) session.getAttribute("firstName");
    String lastName = (String) session.getAttribute("lastName");
    String username = (String) session.getAttribute("username");
    String email = (String) session.getAttribute("email");
    Integer userID = (Integer) session.getAttribute("userID");

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
    <link rel="stylesheet" type="text/css" href="../static/edit_gym.css">
    <title>Edit Gym - Gym Share</title>
</head>

<body>
    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom fixed-top">
        <div class="container px-5">
            <a class="navbar-brand" href="../home.jsp">Gym Share</a>
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
        <button class="back-button" onclick="location.href='my_gyms.jsp'">Back</button>
        <div class="header-container">
            <h1>Edit Gym Information</h1>
        </div>

        <%
            String gymName = "";
            String description = "";
            String address = "";
            Double price = 0.0;
            
            String gymIDParam = request.getParameter("gymID");
            int gymID = 0;
            
            if (gymIDParam == null || gymIDParam.trim().isEmpty()) {
                response.sendRedirect("my_gyms.jsp");
                return;
            }
            
            try {
                gymID = Integer.parseInt(gymIDParam.trim());
            } catch (NumberFormatException e) {
                out.println("Error parsing gymID: '" + gymIDParam + "'");
                response.sendRedirect("my_gyms.jsp");
                return;
            }

            try {
                java.sql.Connection con;
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/team4?autoReconnect=true&useSSL=false", user, password);

                Statement stmt = con.createStatement();
                String retrieveGym = "SELECT Gym_Name, Description, Address, Price FROM Gyms WHERE Gym_ID = " + gymID;
                
                ResultSet rs = stmt.executeQuery(retrieveGym);

                if (rs.next()) {
                    gymName = rs.getString("Gym_Name");
                    description = rs.getString("Description");
                    address = rs.getString("Address");
                    price = rs.getDouble("Price");
                }

                rs.close();
                stmt.close();
                con.close();
            } 
            catch (SQLException e) {
                e.printStackTrace();
            }
        %>

        <form action="edit_gym.jsp" method="post">
            <input type="hidden" name="gymID" value="<%= gymID %>">
            <label for="gymName">Gym Name:</label>
            <input type="text" id="gymName" name="gymName" value="<%= gymName %>" required>

            <label for="description">Description:</label>
            <textarea id="description" name="description" required><%= description %></textarea>

            <label for="address">Address:</label>
            <input type="text" id="address" name="address" value="<%= address %>" required>

            <label for="price">Price:</label>
            <input type="number" id="price" name="price" value="<%= String.format("%.2f", price) %>" required>

            <button type="submit" class="save-button">Save</button>
        </form>
    </div>

    <%
        if(request.getMethod().equalsIgnoreCase("POST")) {
            try {
                java.sql.Connection con;
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/team4?autoReconnect=true&useSSL=false", user, password);

                String updatedGymName = request.getParameter("gymName");
                String updatedDescription = request.getParameter("description");
                String updatedAddress = request.getParameter("address");
                String updatedPrice = request.getParameter("price");
                int postGymID = Integer.parseInt(request.getParameter("gymID"));

                Statement stmt = con.createStatement();
                String updateGym = "UPDATE Gyms SET Gym_Name = '" + updatedGymName + "', Description = '" + updatedDescription + "', Address = '" + updatedAddress + "', Price = '" + updatedPrice + "' WHERE Gym_ID = " + postGymID;

                stmt.executeUpdate(updateGym);

                stmt.close();
                con.close();

                response.sendRedirect("my_gyms.jsp");
                return;
            }
            catch (SQLException e) {
                out.println("SQLException:" + e.getMessage());
            }
        }
    %>
</body>