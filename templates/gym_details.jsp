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
    <%@ page import="java.text.SimpleDateFormat" %>
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

                    <div class="gym-details-wrapper">
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
                                    <strong>Hourly Rate:</strong>
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
                        
    					<div class="gym-container recent-reviews-container">
        					<h2>Recent Reviews</h2>
        					<%
            					try {
            						Class.forName("com.mysql.cj.jdbc.Driver");
                					Connection reviewCon = DriverManager.getConnection("jdbc:mysql://localhost:3306/team4", "root", "GymShare");
                					PreparedStatement reviewStmt = con.prepareStatement(
                    					"SELECT User_ID, R.Stars, R.Description, R.Date_Posted " +
                    					"FROM Reviews R JOIN Receives USING (Review_ID) JOIN Bookings USING (Booking_ID) JOIN Makes USING (Booking_ID) JOIN Guests USING (User_ID) JOIN Has USING (Booking_ID) JOIN Gyms USING (Gym_ID) " +
                    					"WHERE Gym_ID = ? ORDER BY R.Date_Posted DESC LIMIT 5"
                					);
                					reviewStmt.setInt(1, gymID);
                					ResultSet rs = reviewStmt.executeQuery();

               						SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy h:mm a");

                					boolean hasReviews = false;
                					while (rs.next()) {
                    					hasReviews = true;
                    					int rating = rs.getInt("Stars");
                    					String comment = rs.getString("Description");
                    					String date = sdf.format(rs.getTimestamp("Date_Posted"));
                                        int guestUserID = rs.getInt("User_ID");
                                        String name = "";
                                        try (PreparedStatement userStmt = reviewCon.prepareStatement("SELECT First_Name, Last_Name FROM Users WHERE User_ID = ?")) {
                                            userStmt.setInt(1, guestUserID);
                                            ResultSet userRs = userStmt.executeQuery();
                                            if (userRs.next()) {
                                                name = userRs.getString("First_Name") + " " + userRs.getString("Last_Name");
                                            }
                                            userRs.close();
        					%>
            					<div class="gym-container review-box">
    								<div class="review-header">
        							<div class="reviewer-name"><%= name %></div>
        							<div class="review-stars">
            							<% for (int i = 1; i <= 5; i++) { %>
                							<i class="<%= i <= rating ? "fas fa-star" : "far fa-star" %>" style="color: #FFD700;"></i>
            							<% } %>
        							</div>
    							</div>
    							<div class="review-body">
        							<p class="review-comment">"<%= comment %>"</p>
        							<p class="review-date"><%= date %></p>
    							</div>
							</div>

        					<%
                					}
                					if (!hasReviews) {
        					%>
            					<p class="no-reviews-text">No reviews yet for this gym.</p>
        					<%
                					}
                                }

                					rs.close();
                					reviewStmt.close();
                					reviewCon.close();
            					} catch (Exception e) {
                					out.println("<p>Error loading reviews: " + e.getMessage() + "</p>");
            					}
        					%>
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
            window.location.href = 'request_booking.jsp?gymID=' + gymID;
        }
    </script>
</body>
</html>