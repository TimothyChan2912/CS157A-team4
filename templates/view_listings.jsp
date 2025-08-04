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
    <link rel="stylesheet" type="text/css" href="../static/view_listings.css">
    <title>Listings - Gym Share</title>
</head>

<body>
    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom fixed-top">
        <div class="container px-5">
            <a class="navbar-brand" href="home.jsp">Gym Share</a>
            <div class="navbar-title">
                <h1>Available Listings</h1>
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
        <button class="back-button" onclick="location.href='guest_dashboard.jsp'">Back to Dashboard</button>
        <div class="header-container">
        </div>

        <div class="gyms-container">
        <%
            try {
                java.sql.Connection con;
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/team4?autoReconnect=true&useSSL=false", user, password);

                Statement stmt = con.createStatement();
                String retrieveGyms = "SELECT Gym_ID, Gym_Name, Description, Address, Price " +
                                        "FROM Gyms";
                ResultSet rs = stmt.executeQuery(retrieveGyms);

                while (rs.next()) {
                    int gymID = rs.getInt("Gym_ID");
                    String gymName = rs.getString("Gym_Name");
                    String description = rs.getString("Description");
                    String address = rs.getString("Address");
                    Double price = rs.getDouble("Price");
                    
                 	// Fetch average rating
                    PreparedStatement avgStmt = con.prepareStatement("SELECT AVG(Rating) AS avg_rating FROM Reviews WHERE Gym_ID = ?");
                    avgStmt.setInt(1, gymID);
                    ResultSet avgRs = avgStmt.executeQuery();

                    double avgRating = 0.0;
                    boolean hasRating = false;
                    if (avgRs.next() && avgRs.getDouble("avg_rating") > 0) {
                        avgRating = avgRs.getDouble("avg_rating");
                        hasRating = true;
                    }

                    avgRs.close();
                    avgStmt.close();
        %>
                    <div class="gym-container" onclick="viewGymDetails(<%= gymID %>)" style="cursor: pointer; border-color: #FF3C38;">
                        <div class="gym-header">
                            <h2><%= gymName %></h2>
                        </div>

                        <div class="gym-details">
                            <p><strong>Description:</strong> <%= description %></p>
                            <p><strong>Address:</strong> <%= address %></p>
                            <p><strong>Price:</strong> $<%= String.format("%.2f", price) %></p>
                            <p><strong>Rating:</strong>
							<% if (hasRating) { 
    							int fullStars = (int) Math.floor(avgRating);
    							for (int i = 1; i <= 5; i++) {
        							if (i <= fullStars) { %>
            							<i class="fas fa-star" style="color: #FFD700;"></i>
        							<% } else { %>
            							<i class="far fa-star" style="color: #ccc;"></i>
        							<% }
    							} 
							%>
    							(<%= String.format("%.1f ", avgRating) %>/ 5.0)
							<% } else { %>
    							<span style="color: #999; font-style: italic;">No reviews yet</span>
							<% } %>
							</p>
                        </div>
                    </div>
        <%  
            }

            rs.close();
            stmt.close();
            con.close();
        } 
        catch (SQLException e) {
            out.println("SQLException:" + e.getMessage());
        }
        %>
        </div>
    </div>

    <script>
        function viewGymDetails(gymID) {
            window.location.href = 'gym_details.jsp?gymID=' + gymID;
        }
    </script>
</body>
