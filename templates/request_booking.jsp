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
    <link rel="stylesheet" type="text/css" href="../static/request_booking.css">
    <title>Booking Request - Gym Share</title>
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
        <button class="back-button" onclick="location.href='gym_details.jsp?gymID=<%= request.getParameter("gymID") %>'">Back to Gym Details</button>
        <div class="header-container">
            <h1>Request Booking</h1>
        </div>

        <%
            String gymIDParam = request.getParameter("gymID");
            String gymName = "";
            int gymID = 0;
            double price = 0.0;
            
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

                String retrieveGymName = "SELECT Gym_Name, Price FROM Gyms WHERE Gym_ID = " + gymID;
                Statement stmt = con.createStatement();
                ResultSet rs = stmt.executeQuery(retrieveGymName);

                if (rs.next()) {
                    gymName = rs.getString("Gym_Name");
                    price = rs.getDouble("Price");
                }

                stmt.close();
                rs.close();
                con.close();
            }
            catch (SQLException e) {
                out.println("SQLException:" + e.getMessage());
            }      
        %>

        <div class="form-container">
            <form action="request_booking.jsp" method="post" data-hourly-price="<%= price %>">
                <div class="gym-name-header">
                    <h3><%= gymName %> - $<%= String.format("%.2f", price) %> per hour</h3>
                </div>
                
                <input type="hidden" name="gymID" value="<%= request.getParameter("gymID") %>">

                <label for="paymentMethod">Payment Method:</label>
                <select id="paymentMethod" name="paymentMethod" required>
                    <option value="Credit Card">Credit Card</option>
                    <option value="PayPal">PayPal</option>
                    <option value="Zelle">Zelle</option>
                    <option value="Apple Pay">Apple Pay</option>
                </select>

                <label for="bookingDate">Booking Date:</label>
                <input type="date" id="bookingDate" name="bookingDate" required>

                <label for="startTime">Start Time:</label>
                <input type="time" id="startTime" name="startTime" required>

                <label for="endTime">End Time:</label>
                <input type="time" id="endTime" name="endTime" required>

                <div class="price-display">
                    <label>Total Price:</label>
                    <span id="totalPrice">$0.00</span>
                </div>

                <input type="submit" value="Request Booking">
            </form>
        </div>
    </div>

    <% 
        if (request.getMethod().equalsIgnoreCase("POST")) {
            try {
                java.sql.Connection con;
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/team4?autoReconnect=true&useSSL=false", user, password);

                String paymentMethod = request.getParameter("paymentMethod");
                String bookingDateStr = request.getParameter("bookingDate");
                String startTimeStr = request.getParameter("startTime");
                String endTimeStr = request.getParameter("endTime");
                
                java.sql.Date bookingDate = java.sql.Date.valueOf(bookingDateStr);
                
                java.sql.Timestamp startTime = java.sql.Timestamp.valueOf(bookingDateStr + " " + startTimeStr + ":00");
                java.sql.Timestamp endTime = java.sql.Timestamp.valueOf(bookingDateStr + " " + endTimeStr + ":00");

                java.util.Date now = new java.util.Date();
                java.sql.Date requestDate = new java.sql.Date(now.getTime());

                long diffMs = endTime.getTime() - startTime.getTime();
                double sessionHours = diffMs / (1000.0 * 60 * 60);

                double priceOffered = sessionHours * price;
            
                Statement stmt = con.createStatement();
                String insertBooking = "INSERT INTO Bookings (Status, Request_Date, Price_Offered, Payment_Method, Booking_Date, Start_Time, End_Time) "
                                        + "VALUES ('Pending', '" + requestDate + "', " + priceOffered + ", '" + paymentMethod + "', '" + bookingDate + "', '" + startTime + "', '" + endTime + "')";
                stmt.execute(insertBooking);

                String insertMakes = "INSERT INTO Makes (User_ID, Booking_ID) "
                                        + "VALUES (" + userID + ", LAST_INSERT_ID())";
                stmt.execute(insertMakes);

                String insertHas = "INSERT INTO Has (Gym_ID, Booking_ID) "
                                        + "VALUES (" + gymID + ", LAST_INSERT_ID())";
                stmt.execute(insertHas);

                stmt.close();
                con.close();

                out.println("<script>alert('Booking request submitted successfully!'); window.location.href='guest_dashboard.jsp';</script>");
            }
            catch (SQLException e) {
                out.println("SQLException: " + e.getMessage());
            }
        }
    %>

    <script>
        function calculatePrice() {
            const form = document.querySelector('form');
            const hourlyPrice = parseFloat(form.getAttribute('data-hourly-price'));
            const startTime = document.getElementById('startTime').value;
            const endTime = document.getElementById('endTime').value;
            const totalPriceElement = document.getElementById('totalPrice');
            
            if (startTime && endTime) {
                const start = new Date('2000-01-01 ' + startTime);
                const end = new Date('2000-01-01 ' + endTime);
                
                const diffMs = end - start;
                const diffHours = diffMs / (1000 * 60 * 60);
                
                if (diffHours > 0) {
                    const totalPrice = diffHours * hourlyPrice;
                    totalPriceElement.textContent = '$' + totalPrice.toFixed(2);
                    totalPriceElement.style.color = '#2c3e50';
                } else {
                    totalPriceElement.textContent = 'Invalid time range';
                    totalPriceElement.style.color = '#e74c3c';
                }
            } else {
                totalPriceElement.textContent = '$0.00';
                totalPriceElement.style.color = '#2c3e50';
            }
        }
        
        document.addEventListener('DOMContentLoaded', function() {
            document.getElementById('startTime').addEventListener('change', calculatePrice);
            document.getElementById('endTime').addEventListener('change', calculatePrice);
        });
    </script>
</body>
</html>
