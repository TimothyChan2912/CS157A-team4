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
    String user = "root";
    String password = "GymShare";
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
    <link rel="stylesheet" type="text/css" href="../static/gym_details.css">
    <title>Gym Details - Gym Share</title>
</head>

<body>
    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom fixed-top">
        <div class="container px-5">
            <a class="navbar-brand" href="home.jsp">Gym Share</a>
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
        <button class="back-button" onclick="location.href='view_listings.jsp'">Back to Listings</button>

        <%
            String gymIDParam = request.getParameter("gymID");
            int gymID = 0;
            
            if (gymIDParam == null || gymIDParam.trim().isEmpty()) {
                response.sendRedirect("view_listings.jsp");
                return;
            }
            
            try {
                gymID = Integer.parseInt(gymIDParam.trim());
            } 
            catch (NumberFormatException e) {
                response.sendRedirect("view_listings.jsp");
                return;
            }

            try {
                java.sql.Connection con;
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/team4?autoReconnect=true&useSSL=false", user, password);

                Statement stmt = con.createStatement();
                String retrieveGym = "SELECT Gym_Name, Description, Address, Price FROM Gyms WHERE Gym_ID = " + gymID;
                ResultSet rsGym = stmt.executeQuery(retrieveGym);

                if (rsGym.next()) {
                    String gymName = rsGym.getString("Gym_Name");
                    String description = rsGym.getString("Description");
                    String address = rsGym.getString("Address");
                    Double price = rsGym.getDouble("Price");
        %>
                    <div class="header-container">
                        <h1><%= gymName %></h1>
                    </div>

                    <div class="gyms-container">
                        <div class="gym-container gym-details-container">
                            <div class="gym-details">
                                <div class="detail-section">
                                    <strong>Description:</strong>
                                    <p class="detail-text"><%= description %></p>
                                </div>
                                
                                <div class="detail-section">
                                    <strong>Address:</strong>
                                    <p class="detail-text"><%= address %></p>
                                </div>
                                
                                <div class="detail-section">
                                    <strong>Price for session:</strong>
                                    <p class="price-text">$<%= String.format("%.2f", price) %></p>
                                </div>

                                <div class="detail-section">
                                    <strong>Available Equipment:</strong>
                                    <div class="equipment-container">
                                        <%
                                            String retrieveMachines = "SELECT Type, Status FROM Machines WHERE Gym_ID = " + gymID;
                                            ResultSet rsMachines = stmt.executeQuery(retrieveMachines);
                                            
                                            while(rsMachines.next()) {
                                                String machineType = rsMachines.getString("Type");
                                                String machineStatus = rsMachines.getString("Status");
                                        %>
                                                <div class="equipment-item">
                                                    <span><%= machineType %></span>
                                                    <span class="equipment-status"><%= machineStatus %></span>
                                                </div>
                                        <%
                                            }
                                            rsMachines.close();
                                        %>
                                    </div>
                                </div>

                                <div class="detail-section">
                                    <strong>Available Amenities:</strong>
                                    <div class="amenities-container">
                                        <%
                                            String retrieveFeatures = "SELECT Feature_Name " +
                                                                        "FROM Features JOIN Possesses USING (Feature_ID) " +
                                                                        "WHERE Gym_ID = " + gymID;
                                            ResultSet rsFeatures = stmt.executeQuery(retrieveFeatures);

                                            while(rsFeatures.next()) {
                                                String featureName = rsFeatures.getString("Feature_Name");
                                        %>
                                                <div class="amenity-item">
                                                    <span><%= featureName %></span>
                                                </div>
                                        <%
                                            }
                                            rsFeatures.close();
                                        %>
                                    </div>
                                </div>

                                <div class="booking-section">
                                    <button onclick="requestBooking(<%= gymID %>)" class="booking-button">
                                        Request Booking
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
        <%      
                }
                rsGym.close();
                stmt.close();
                con.close();
            } 
            catch (SQLException e) {
                out.println("SQLException: " + e.getMessage());
            }
        %>
    </div>

    <script>
        function requestBooking(gymID) {
            alert('Booking request for Gym ID: ' + gymID + '\nThis feature will be implemented soon!');
        }
    </script>
</body>
</html>
