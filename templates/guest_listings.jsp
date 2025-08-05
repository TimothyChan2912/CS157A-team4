<%@ page import="java.sql.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>

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
    <link rel="stylesheet" type="text/css" href="../static/guest_listings.css">
    <title>Dashboard - Gym Share</title>
</head>

<body>
    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom fixed-top">
        <div class="container px-5">
            <a class="navbar-brand" href="home.jsp">Gym Share</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation"><span class="navbar-toggler-icon"></span></button>
            <div class="collapse navbar-collapse" id="navbarResponsive">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link">Welcome <%= firstName %>!</a></li>
                    <li class="nav-item"> <a class="nav-link" href="host_settings.jsp"> <i class="fas fa-cog"></i> Settings </a> </li>
                    <li class="nav-item"><a class="nav-link" href="login.jsp">Log Out</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="main-content">
        <button class="back-button" onclick="location.href='guest_dashboard.jsp'">Back to Dashboard</button>
        <div class="header-container">
            <h1>My Listings</h1>
        </div>

        <div class="listings-container">
            <%
                try {
                    java.sql.Connection con;
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/team4?autoReconnect=true&useSSL=false", user, password);

                    String gymName = "";
                    String status = "";
                    double priceOffered = 0.0;
                    String paymentMethod = "";
                    String bookingDateStr = "";
                    String startTimeStr = "";
                    String endTimeStr = "";
                    Date bookingDate = null;
                    Timestamp startTime = null;
                    Timestamp endTime = null;

                    ResultSet rsListings = null;
                    ResultSet rsGym = null;

                    Statement stmtListingID = con.createStatement();

                    String retrieveListingID = "SELECT Booking_ID FROM Makes WHERE User_ID = " + userID;
                    ResultSet rsListingID = stmtListingID.executeQuery(retrieveListingID);

                    while(rsListingID.next()) {
                        int bookingID = rsListingID.getInt("Booking_ID");

                        Statement stmtGym = con.createStatement();
                        Statement stmtListings = con.createStatement();

                        String retrieveGym = "SELECT Gym_Name" +
                                                " FROM Gyms JOIN Has USING (Gym_ID)" +
                                                " WHERE Booking_ID = " + bookingID;
                        rsGym = stmtGym.executeQuery(retrieveGym);

                        if(rsGym.next()) {
                            gymName = rsGym.getString("Gym_Name");
                        }

                        String retrieveListings = "SELECT Status, Price_Offered, Payment_Method, Booking_Date, Start_Time, End_Time" +
                                                    " FROM  Bookings" +
                                                    " WHERE Booking_ID = " + bookingID;
                        rsListings = stmtListings.executeQuery(retrieveListings);

                        if(rsListings.next()) {
                            status = rsListings.getString("Status");
                            priceOffered = rsListings.getDouble("Price_Offered");
                            paymentMethod = rsListings.getString("Payment_Method");
                            bookingDate = rsListings.getDate("Booking_Date");
                            startTime = rsListings.getTimestamp("Start_Time");
                            endTime = rsListings.getTimestamp("End_Time");
                        }

                        SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy");
                        SimpleDateFormat timeFormat = new SimpleDateFormat("h:mm a");

                        bookingDateStr = dateFormat.format(bookingDate);
                        startTimeStr = timeFormat.format(startTime);
                        endTimeStr = timeFormat.format(endTime);

                        if (!status.equals("Cancelled")) {      
                %>
                <div class="listing-container">
                    <div class="listing-header">
                        <h2><%= gymName %></h2>
                    </div>

                    <div class="listing-details">
                        <p><strong>Status:</strong> <%= status %></p>
                        <p><strong>Price Offered:</strong> $<%= String.format("%.2f", priceOffered) %></p>
                        <p><strong>Payment Method:</strong> <%= paymentMethod %></p>
                        <p><strong>Booking Date:</strong> <%= bookingDateStr %></p>
                        <p><strong>Start Time:</strong> <%= startTimeStr %></p>
                        <p><strong>End Time:</strong> <%= endTimeStr %></p>
                    </div>
                </div>
            <%  
                        }
                        rsListings.close();
                        rsGym.close();
                        stmtGym.close();
                        stmtListings.close();
                }
                
                rsListingID.close();
                stmtListingID.close();
                con.close();
            } 
            catch (SQLException e) {
                out.println("SQLException: " + e.getMessage());
            }
            %>

