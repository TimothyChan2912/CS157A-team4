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
    <link rel="stylesheet" type="text/css" href="../static/dashboard.css">
    <title>Dashboard - Gym Share</title>
</head>

<body>
    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom fixed-top">
        <div class="container px-5">
            <a class="navbar-brand" href="home.jsp">Gym Share</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation"><span class="navbar-toggler-icon"></span></button>
            <div class="navbar-title">
                <h1>Dashboard</h1>
            </div>
            <div class="collapse navbar-collapse" id="navbarResponsive">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link">Welcome <%= firstName %>!</a></li>
                    <li class="nav-item"><a class="nav-link" href="login.jsp">Log Out</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <div style="padding-top: 80px;">

    <div class="dashboard-layout">
        <div class="sidebar">
            <div class="upcoming-bookings">
                <h2>Upcoming Bookings</h2>
                <div class="bookings-list">
                    <%
                    try {
                        java.sql.Connection con;
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/team4?autoReconnect=true&useSSL=false", user, password);

                        String gymName = "";
                        Integer bookingID = 0;
                        Date bookingDate = null;
                        Time startTime = null;
                        Time endTime = null;
                        String bookingDateStr = "";
                        String startTimeStr = "";
                        String endTimeStr = "";
                        Boolean hasBookings = false;

                        SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy");
                        SimpleDateFormat timeFormat = new SimpleDateFormat("h:mm a");

                        Statement stmtAccepted = con.createStatement();

                        String retrieveAcceptedBookings = "SELECT Gym_Name, Booking_ID,Booking_Date, Start_Time, End_Time" +
                                                            " FROM Bookings JOIN Has USING (Booking_ID) JOIN Gyms USING (Gym_ID) JOIN Owns USING (Gym_ID)" +
                                                            " WHERE User_ID = " + userID + " AND status = 'Confirmed' AND Booking_Date > CURDATE()" +
                                                            "ORDER BY Booking_Date, Start_Time";
                        ResultSet rsAcceptedBookings = stmtAccepted.executeQuery(retrieveAcceptedBookings);

                        while (rsAcceptedBookings.next()) {
                            gymName = rsAcceptedBookings.getString("Gym_Name");
                            bookingID = rsAcceptedBookings.getInt("Booking_ID");
                            bookingDate = rsAcceptedBookings.getDate("Booking_Date");
                            startTime = rsAcceptedBookings.getTime("Start_Time");
                            endTime = rsAcceptedBookings.getTime("End_Time");

                            bookingDateStr = dateFormat.format(bookingDate);
                            startTimeStr = timeFormat.format(startTime);
                            endTimeStr = timeFormat.format(endTime);
                            hasBookings = true;
                    %>
                            <div class="booking-item">
                                <div class="booking-gym"><%= gymName %></div>
                                <div class="booking-date"><%= bookingDateStr %></div>
                                <div class="booking-time"><%= startTimeStr %> - <%= endTimeStr %></div>
                                <div class="booking-actions">
                                    <div class="booking-status confirmed">Confirmed</div>
                                    <div class="cancel-booking">
                                        <form method="post" action="host_dashboard.jsp">
                                            <input type="hidden" name="action" value="cancel">
                                            <input type="hidden" name="bookingID" value="<%= bookingID %>">
                                            <button type="submit" class="cancel-button">Cancel</button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                    <%  
                        }
                        if(hasBookings == false) {
                    %>
                            <div class="booking-item no-bookings">No upcoming bookings</div>
                    <%
                        }
                        rsAcceptedBookings.close();
                        stmtAccepted.close();
                    }
                    catch (SQLException e) {
                        out.println("SQLException: " + e.getMessage());
                    }
                    %>
                </div>
            </div>
        </div>

        <div class="main-content">
            <div class="host-actions-container">
                <h2>Host's Actions</h2>
                <div class="actions-buttons-container vertical">
                    <button class="my-gyms-button" onclick="location.href='my_gyms.jsp'">
                        <i class="fas fa-dumbbell"></i>
                        My Gyms
                    </button>
                    
                    <button class="bookings-button" onclick="location.href='view_requested_bookings.jsp'">
                        <i class="fas fa-calendar-check"></i>
                        View Booking Requests
                    </button>
                    
                    <button class="calendar-button" onclick="location.href='host_calendar.jsp'">
                        <i class="fas fa-calendar-alt"></i>
                        Calendar
                    </button>
                </div>
            </div>
        </div>
        </div>
    </div>
    <%
        try {
            java.sql.Connection con;
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/team4?autoReconnect=true&useSSL=false", user, password);

            if(request.getMethod().equalsIgnoreCase("POST")) {
                String action = request.getParameter("action");
                if ("cancel".equals(action)) {
                    Integer bookingID = Integer.parseInt(request.getParameter("bookingID"));

                    String cancelBooking = "UPDATE Bookings SET Status = 'Cancelled' WHERE Booking_ID = " + bookingID;
                    Statement stmtCancel = con.createStatement();

                    stmtCancel.execute(cancelBooking);
                    stmtCancel.close();

                    out.println("<script>alert('Booking cancelled successfully.'); window.location.href='host_dashboard.jsp';</script>");
                }
            }
        }
        catch (SQLException e) {
            out.println("SQLException: " + e.getMessage());
        }
    %>
    </div>
    </div>

