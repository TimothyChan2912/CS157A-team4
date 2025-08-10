<%@ page import="java.sql.*, java.util.*, java.text.SimpleDateFormat" %>
<%
    Boolean isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");
    if (isLoggedIn == null || !isLoggedIn) {
        response.sendRedirect("admin_login.jsp");
        return;
    }

    String db = "team4";
    String user = "root";
    String password = "GymShare";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Support Tickets - Admin</title>
    <link rel="stylesheet" href="../static/home.css">
    <link rel="stylesheet" href="../static/navbar.css">
	<link rel="stylesheet" href="../static/ticket.css">
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark navbar-custom fixed-top">
    <div class="container px-5">
        <a class="navbar-brand" href="home.jsp">Gym Share</a>
        <div class="navbar-title">
            <h1>Support Tickets</h1>
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
</div>
<div class="ticket-container">
    <div class="ticket-header">Support Tickets</div>

    <%
        try {
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/" + db, user, password);
            String query = "SELECT T.Ticket_ID, T.Status, T.Content, T.Time, " +
		                    "U.First_Name, U.Last_Name, G.Gym_Name " +
		                    "FROM Tickets T " +
		                    "JOIN Reports R ON T.Ticket_ID = R.Ticket_ID " +
		                    "JOIN Users U ON R.User_ID = U.User_ID " +
		                    "LEFT JOIN Reported RP ON T.Ticket_ID = RP.Ticket_ID " +
		                    "LEFT JOIN Gyms G ON RP.Gym_ID = G.Gym_ID " +
		                    "WHERE T.Status = 'Open' " +
		                    "ORDER BY T.Time DESC";

            PreparedStatement stmt = con.prepareStatement(query);
            ResultSet rs = stmt.executeQuery();

            SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy h:mm a");

            while (rs.next()) {
                int ticketID = rs.getInt("Ticket_ID");
                String fullName = rs.getString("First_Name") + " " + rs.getString("Last_Name");
                String content = rs.getString("Content");
                String timestamp = sdf.format(rs.getTimestamp("Time"));
                String status = rs.getString("Status");
                String gymName = rs.getString("Gym_Name");
    %>
        <div class="ticket <%= "Closed".equals(status) ? "closed" : "" %>">
            <h4>From: <%= fullName %></h4>
            <% if (gymName != null) { %>
	            <p><strong>Related Gym:</strong> <%= gymName %></p>
	        <% } %>
            <p><strong>Message:</strong> <%= content %></p>
            <small><%= timestamp %> | Status: <%= status %></small><br>
            <form method="get" action="admin_ticket_view.jsp" style="display:inline;">
                <input type="hidden" name="ticketID" value="<%= ticketID %>">
                <button type="submit" class="respond-button">View & Respond</button>
            </form>
            <form method="post" action="close_ticket.jsp" style="display:inline;">
                <input type="hidden" name="ticketID" value="<%= ticketID %>">
                <button type="submit" class="close-button" onclick="return confirm('Close this ticket?');">Close</button>
            </form>
        </div>
    <%
            }
            rs.close();
            stmt.close();
            con.close();
        } catch (Exception e) {
            out.println("<p>Error loading tickets: " + e.getMessage() + "</p>");
        }
    %>
</div>
</body>
</html>
