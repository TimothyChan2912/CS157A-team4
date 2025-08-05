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
                    <li class="nav-item"> <a class="nav-link" href="guest_settings.jsp"> <i class="fas fa-cog"></i> Settings </a> </li>
                    <li class="nav-item"><a class="nav-link" href="login.jsp">Log Out</a></li>
                </ul>
            </div>
        </div>
    </nav>

     <div class="main-content">
        <button class="back-button" onclick="location.href='guest_dashboard.jsp'">Back to Dashboard</button>
        
        <div class="search-filter-container">
            <div class="search-section">
                <form method="GET" action="view_listings.jsp" class="search-form">
                    <div class="search-input-group">
                        <input type="text" name="search" placeholder="Search gyms by name or location..." 
                               value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>" 
                               class="search-input">
                        <button type="submit" class="search-btn">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                </form>
            </div>
            
            <div class="filter-section">
                <form method="GET" action="view_listings.jsp" class="filter-form">
                    <input type="hidden" name="search" value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
                    
                    <div class="filter-group">
                        <label for="priceRange">Max Price:</label>
                        <select name="priceRange" id="priceRange" onchange="this.form.submit()">
                            <option value="">Any Price</option>
                            <option value="10" <%= "10".equals(request.getParameter("priceRange")) ? "selected" : "" %>>Under $10</option>
                            <option value="25" <%= "25".equals(request.getParameter("priceRange")) ? "selected" : "" %>>Under $25</option>
                            <option value="50" <%= "50".equals(request.getParameter("priceRange")) ? "selected" : "" %>>Under $50</option>
                            <option value="100" <%= "100".equals(request.getParameter("priceRange")) ? "selected" : "" %>>Under $100</option>
                        </select>
                    </div>
                    
                    <div class="filter-group">
                        <label for="rating">Min Rating:</label>
                        <select name="rating" id="rating" onchange="this.form.submit()">
                            <option value="">Any Rating</option>
                            <option value="1" <%= "1".equals(request.getParameter("rating")) ? "selected" : "" %>>1+ Stars</option>
                            <option value="2" <%= "2".equals(request.getParameter("rating")) ? "selected" : "" %>>2+ Stars</option>
                            <option value="3" <%= "3".equals(request.getParameter("rating")) ? "selected" : "" %>>3+ Stars</option>
                            <option value="4" <%= "4".equals(request.getParameter("rating")) ? "selected" : "" %>>4+ Stars</option>
                            <option value="5" <%= "5".equals(request.getParameter("rating")) ? "selected" : "" %>>5 Stars</option>
                        </select>
                    </div>
                    
                    <button type="button" class="clear-filters-btn" onclick="clearFilters()">Clear Filters</button>
                </form>
            </div>
        </div>
        
        <div class="header-container">
        </div>

        <div class="gyms-container">
        <%
            try {
                java.sql.Connection con;
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/team4?autoReconnect=true&useSSL=false", user, password);

                String searchQuery = request.getParameter("search");
                String priceRange = request.getParameter("priceRange");
                String minRating = request.getParameter("rating");

                String filter = "SELECT g.Gym_ID, g.Gym_Name, g.Description, g.Address, g.Price, AVG(rev.Stars) AS Avg_Stars " +
                             "FROM Gyms g LEFT JOIN Has h ON g.Gym_ID = h.Gym_ID LEFT JOIN Bookings b ON h.Booking_ID = b.Booking_ID LEFT JOIN Receives r ON b.Booking_ID = r.Booking_ID LEFT JOIN Reviews rev ON r.Review_ID = rev.Review_ID " +
                             "WHERE (g.Gym_Name LIKE ? OR g.Address LIKE ? OR g.Description LIKE ?) AND g.Price <= ? " +
                             "GROUP BY g.Gym_ID HAVING AVG(rev.Stars) >= ? OR AVG(rev.Stars) IS NULL ";

                PreparedStatement stmt = con.prepareStatement(filter);

                if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                    String searchPattern = "%" + searchQuery.trim() + "%";
                    stmt.setString(1, searchPattern);
                    stmt.setString(2, searchPattern);
                    stmt.setString(3, searchPattern);
                } else {
                    stmt.setString(1, "%");
                    stmt.setString(2, "%");
                    stmt.setString(3, "%");
                }

                if (priceRange != null && !priceRange.isEmpty()) {
                    stmt.setDouble(4, Double.parseDouble(priceRange));
                } else {
                    stmt.setDouble(4, 999999.99);
                }

                if (minRating != null && !minRating.isEmpty()) {
                    stmt.setDouble(5, Double.parseDouble(minRating));
                } else {
                    stmt.setDouble(5, 0);
                }

                ResultSet rs = stmt.executeQuery();

                while (rs.next()) {
                    int gymID = rs.getInt("Gym_ID");
                    String gymName = rs.getString("Gym_Name");
                    String description = rs.getString("Description");
                    String address = rs.getString("Address");
                    Double price = rs.getDouble("Price");
                    
                    PreparedStatement avgStmt = con.prepareStatement("SELECT AVG(Stars) AS Avg_Stars " + 
                                                                    "FROM Reviews JOIN Receives USING (Review_ID) JOIN Bookings USING (Booking_ID) JOIN Has USING (Booking_ID) JOIN Gyms USING (Gym_ID) " +
                                                                    "WHERE Gym_ID = ? ");
                    avgStmt.setInt(1, gymID);
                    ResultSet avgRs = avgStmt.executeQuery();

                    double avgRating = 0.0;
                    boolean hasRating = false;
                    if (avgRs.next() && avgRs.getDouble("Avg_Stars") > 0) {
                        avgRating = avgRs.getDouble("Avg_Stars");
                        hasRating = true;
                    }

                    avgRs.close();
                    avgStmt.close();
        %>
                    <div class="gym-card" onclick="viewGymDetails(<%= gymID %>)">
                        <div class="gym-image-container">
                            <%
                                String photoPath = "gym_photos/img/GymPhotoDefault.png";
                                String retrievePath = "SELECT Photo_Path " +
                                                        "FROM Photos JOIN Displays USING (Photo_ID) " +
                                                        "WHERE Gym_ID = ? AND Priority = 1 LIMIT 1";
                                PreparedStatement stmtPath = con.prepareStatement(retrievePath);
                                stmtPath.setInt(1, gymID);
                                ResultSet rsPath = stmtPath.executeQuery();
                                if (rsPath.next()) {
                                    photoPath = rsPath.getString("Photo_Path");
                                }
                                rsPath.close();
                                stmtPath.close();
                            %>
                            <img src="../<%= photoPath %>" alt="<%= gymName %>" class="gym-image">
                        </div>
                        <div class="gym-content">
                            <div class="gym-header">
                                <h2><%= gymName %></h2>
                                <p class="rating-stars">
                                    <% if (hasRating) { 
        							int fullStars = (int) Math.floor(avgRating);
        							for (int i = 1; i <= 5; i++) {
            							if (i <= fullStars) { %>
                							<i class="fas fa-star star-filled"></i>
            							<% } else { %>
                							<i class="far fa-star star-empty"></i>
            							<% }
        							} 
    							 } else { %>
        							<span class="no-rating-text">
                                        <%
        							for (int i = 1; i <= 5; i++) { %>
                							<i class="far fa-star star-empty"></i>
        							   <% }    
                                        %>
                                    </span>
    							<% } %>
                                </p>
                            </div>

                            <div class="gym-details">
                                <p><strong>Description:</strong> <%= description %></p>
                                <p><strong>Address:</strong> <%= address %></p>
                                <p><strong>Price:</strong> $<%= String.format("%.2f", price) %></p>							
                            </div>
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
        
        function clearFilters() {
            window.location.href = 'view_listings.jsp';
        }
    </script>
</body>