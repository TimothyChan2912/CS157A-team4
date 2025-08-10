<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>
<%
    Boolean isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");
    if (isLoggedIn == null || !isLoggedIn) {
        response.sendRedirect("login.jsp");
        return;
    }

    String firstName = (String) session.getAttribute("firstName");
    Integer userID = (Integer) session.getAttribute("userID");

    String db = "team4";
    String user = "root";
    String password = "GymShare";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Booking Log - Gym Share</title>
    <link rel="stylesheet" href="../static/home.css">
    <link rel="stylesheet" href="../static/navbar.css">
    <link rel="stylesheet" href="../static/admin_booking.css">
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark navbar-custom fixed-top">
    <div class="container px-5">
        <a class="navbar-brand" href="home.jsp">Gym Share</a>
        <div class="navbar-title">
            <h1>Booking Log</h1>
        </div>
        <div class="collapse navbar-collapse">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item"><a class="nav-link" href="admin_dashboard.jsp">Dashboard</a></li>
                <li class="nav-item"><a class="nav-link" href="logout.jsp">Log Out</a></li>
            </ul>
        </div>
    </div>
</nav>
<div class="main-content">
    <button class="back-button" onclick="location.href='admin_dashboard.jsp'">Back to Dashboard</button>
    <h2 style="text-align:center; margin-bottom: 30px;">Booking Log</h2>

<%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/" + db, user, password);

        String query =
            "SELECT B.Booking_ID, G.Gym_ID, B.Status, B.Request_Date, B.Payment_Method, " +
            "B.Booking_Date, B.Start_Time, B.End_Time, M.User_ID AS Guest_ID, O.User_ID AS Host_ID, G.Gym_Name " +
            "FROM Bookings B " +
            "JOIN Makes M ON B.Booking_ID = M.Booking_ID " +
            "JOIN Has H ON B.Booking_ID = H.Booking_ID " +
            "JOIN Gyms G ON H.Gym_ID = G.Gym_ID " +
            "JOIN Owns O ON G.Gym_ID = O.Gym_ID " +
            "ORDER BY B.Request_Date DESC";

        PreparedStatement stmt = con.prepareStatement(query);
        ResultSet rs = stmt.executeQuery();

        SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy");
        SimpleDateFormat timeFormat = new SimpleDateFormat("h:mm a");

        while (rs.next()) {
            int bookingID = rs.getInt("Booking_ID");
            int gymID = rs.getInt("Gym_ID");
            String status = rs.getString("Status");
            Timestamp requestDate = rs.getTimestamp("Request_Date");
            String payment = rs.getString("Payment_Method");
            Date bookingDate = rs.getDate("Booking_Date");
            Time startTime = rs.getTime("Start_Time");
            Time endTime = rs.getTime("End_Time");
            int guestID = rs.getInt("Guest_ID");
            int hostID = rs.getInt("Host_ID");
            String gymName = rs.getString("Gym_Name");

            String requestStr = dateFormat.format(requestDate);
            String bookingStr = dateFormat.format(bookingDate);
            String startStr = timeFormat.format(startTime);
            String endStr = timeFormat.format(endTime);
%>
        <div class="booking-card">
            <h3>Booking ID: <%= bookingID %></h3>
            <div class="booking-details">
                <p><strong>Gym:</strong> <%= gymName %> (ID: <%= gymID %>)</p>
                <p><strong>Status:</strong> <%= status %></p>
                <p><strong>Guest User ID:</strong> <%= guestID %></p>
                <p><strong>Host User ID:</strong> <%= hostID %></p>
                <p><strong>Requested On:</strong> <%= requestStr %></p>
                <p><strong>Booking Date:</strong> <%= bookingStr %></p>
                <p><strong>Time:</strong> <%= startStr %> - <%= endStr %></p>
                <p><strong>Payment Method:</strong> <%= payment %></p>
            </div>
        </div>
<%
        }

        rs.close();
        stmt.close();
        con.close();
    } catch (Exception e) {
        out.println("<p style='color:red; text-align:center;'>Error loading booking log: " + e.getMessage() + "</p>");
    }
%>
</div>
</body>
</html>
