<%@ page import="java.sql.*"%>
<%@ page import="java.util.Date" %>

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
    <link rel="stylesheet" type="text/css" href="../static/view_requested_bookings.css">
    <title>Requested Bookings - Gym Share</title>
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
        <button class="back-button" onclick="location.href='host_dashboard.jsp?gymID=<%= request.getParameter("gymID") %>'">Back to Dashboard</button>
        <div class="header-container">
            <h1>Requested Bookings</h1>
            <p>Click <i class="fas fa-check"></i> to accept. Click <i class="fas fa-times"></i> to decline.</p>
        </div>

        <%
            try {
                java.sql.Connection con;
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/team4?autoReconnect=true&useSSL=false", user, password);

                String retrieveRequestedBookings = "SELECT Guests.User_ID, Booking_ID, Price_Offered, Payment_Method, Status, Booking_Date, Start_Time, End_Time, Gym_Name" +
                                                " FROM Guests JOIN Makes ON Guests.User_ID = Makes.User_ID JOIN Bookings USING (Booking_ID) JOIN Has USING (Booking_ID) JOIN Gyms USING (Gym_ID) JOIN Owns USING (Gym_ID) JOIN Hosts ON Owns.User_ID = Hosts.User_ID" +
                                                " WHERE Hosts.User_ID = " + userID;
                Statement stmtRequestedBookings = con.createStatement();
                ResultSet rsRequestedBookings = stmtRequestedBookings.executeQuery(retrieveRequestedBookings);

                while(rsRequestedBookings.next()) {
                    Integer guestID = Integer.parseInt(rsRequestedBookings.getString("User_ID"));
                    Integer bookingID = Integer.parseInt(rsRequestedBookings.getString("Booking_ID"));
                    String gymName = rsRequestedBookings.getString("Gym_Name");
                    double priceOffered = rsRequestedBookings.getDouble("Price_Offered");
                    String paymentMethod = rsRequestedBookings.getString("Payment_Method");
                    String status = rsRequestedBookings.getString("Status");
                    Date bookingDate = rsRequestedBookings.getDate("Booking_Date");
                    Time startTime = rsRequestedBookings.getTime("Start_Time");
                    Time endTime = rsRequestedBookings.getTime("End_Time");

                    String retrieveGuestName = "SELECT First_Name, Last_Name FROM Users WHERE User_ID = " + guestID;
                    Statement stmtGuest = con.createStatement();
                    ResultSet rsGuest = stmtGuest.executeQuery(retrieveGuestName);

                    String guestFirstName = "";
                    String guestLastName = "";

                    if(rsGuest.next()) {
                        guestFirstName = rsGuest.getString("First_Name");
                        guestLastName = rsGuest.getString("Last_Name");
                    }

                    rsGuest.close();
                    stmtGuest.close();

                    if(status.equals("Pending")) {
            %>
                    <div class="booking-container">
                        <div class="booking-header">
                            <h2><%= gymName %></h2>
                            <div class="action-buttons">
                                <form method="post" action="view_requested_bookings.jsp">
                                    <input type="hidden" name="action" value="accept">
                                    <input type="hidden" name="bookingID" value="<%= bookingID %>">
                                    <button type="submit" class="accept-button"><i class="fas fa-check"></i></button>
                                </form>

                                <form method="post" action="view_requested_bookings.jsp">
                                    <input type="hidden" name="action" value="decline">
                                    <input type="hidden" name="bookingID" value="<%= bookingID %>">
                                    <button type="submit" class="decline-button"><i class="fas fa-times"></i></button>
                                </form>
                            </div>
                        </div>

                        <div class="booking-details">
                            <p><strong>Requested by:</strong> <%= guestFirstName %> <%= guestLastName %></p>
                            <p><strong>Price Offered:</strong> $<%= String.format("%.2f", priceOffered) %></p>
                            <p><strong>Payment Method:</strong> <%= paymentMethod %></p>
                            <p><strong>Booking Date:</strong> <%= String.format("%1$tB %1$td, %1$tY", bookingDate) %></p>
                            <p><strong>Start Time:</strong> <%= String.format("%1$tI:%1$tM %1$Tp", startTime) %></p>
                            <p><strong>End Time:</strong> <%= String.format("%1$tI:%1$tM %1$Tp", endTime) %></p>
                        </div>
                </div>
            <%
                    }
                }
                rsRequestedBookings.close();
                stmtRequestedBookings.close();
                con.close();
            }
            catch (SQLException e) {
                out.println("SQLException: " + e.getMessage());
            }
        %>
    </div>

    <%
        if (request.getMethod().equalsIgnoreCase("POST")) {
            try {
                java.sql.Connection con;
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/team4?autoReconnect=true&useSSL=false", user, password);

                if (request.getParameter("action").equals("accept")) {
                    String acceptBooking = "UPDATE Bookings SET Status = 'Confirmed' WHERE Booking_ID = " + request.getParameter("bookingID");
                    Statement stmtAccept = con.createStatement();
                    stmtAccept.executeUpdate(acceptBooking);

                    stmtAccept.close();
                    con.close();
                }
                else if (request.getParameter("action").equals("decline")) {
                    String declineBooking = "UPDATE Bookings SET Status = 'Rejected' WHERE Booking_ID = " + request.getParameter("bookingID");
                    Statement stmtDecline = con.createStatement();
                    stmtDecline.executeUpdate(declineBooking);

                    stmtDecline.close();
                    con.close();
                }
            }
            catch (SQLException e) {
                out.println("SQLException: " + e.getMessage());
            }

            if (request.getParameter("action").equals("accept")) {
                out.println("<script>alert('Booking accepted successfully!'); window.location.href='host_dashboard.jsp';</script>");
            }
            else if (request.getParameter("action").equals("decline")) {
                out.println("<script>alert('Booking declined successfully!'); window.location.href='host_dashboard.jsp';</script>");
            }
        }
    %>
</body>
</html>
