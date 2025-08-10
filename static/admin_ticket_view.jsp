<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>
<%
    Boolean isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");
    if (isLoggedIn == null) {
        response.sendRedirect("admin_login.jsp");
        return;
    }

    String db = "team4";
    String user = "root";
    String password = "GymShare";

    String ticketParam = request.getParameter("ticketID");
    int ticketID = (ticketParam != null) ? Integer.parseInt(ticketParam) : -1;

    String content = "";
    String fullName = "";
    String status = "";
    String timestamp = "";

    if (ticketID != -1) {
        try {
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/" + db, user, password);

            String query = "SELECT T.Content, T.Time, T.Status, U.First_Name, U.Last_Name " +
                           "FROM Tickets T " +
                           "JOIN Reports R ON T.Ticket_ID = R.Ticket_ID " +
                           "JOIN Users U ON R.User_ID = U.User_ID " +
                           "WHERE T.Ticket_ID = ?";
            PreparedStatement stmt = con.prepareStatement(query);
            stmt.setInt(1, ticketID);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                content = rs.getString("Content");
                fullName = rs.getString("First_Name") + " " + rs.getString("Last_Name");
                status = rs.getString("Status");
                timestamp = new SimpleDateFormat("MMM dd, yyyy h:mm a").format(rs.getTimestamp("Time"));
            }

            rs.close();
            stmt.close();
            con.close();
        } catch (Exception e) {
            out.println("<p>Error loading ticket: " + e.getMessage() + "</p>");
        }
    } else {
        response.sendRedirect("admin_support_tickets.jsp");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Ticket - Admin</title>
    <link rel="stylesheet" href="../static/home.css">
    <link rel="stylesheet" href="../static/navbar.css">
    <link rel="stylesheet" href="../static/ticket.css">
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark navbar-custom fixed-top">
    <div class="container px-5">
        <a class="navbar-brand" href="home.jsp">Gym Share</a>
        <div class="navbar-title">
            <h1>Ticket #<%= ticketID %></h1>
        </div>
        <div class="collapse navbar-collapse">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item"><a class="nav-link" href="admin_dashboard.jsp">Dashboard</a></li>
                <li class="nav-item"><a class="nav-link" href="logout.jsp">Log Out</a></li>
            </ul>
        </div>
    </div>
</nav>

<div class="ticket-container">
    <div class="ticket">
        <h4>From: <%= fullName %></h4>
        <p><strong>Message:</strong> <%= content %></p>
        <small><%= timestamp %> | Status: <%= status %></small><br><br>

        <% if ("Open".equalsIgnoreCase(status)) { %>
            <form method="post" action="close_ticket.jsp">
                <input type="hidden" name="ticketID" value="<%= ticketID %>">
                <button type="submit" class="close-button" onclick="return confirm('Close this ticket?');">Close Ticket</button>
            </form>
        <% } else { %>
            <p style="color: green; font-weight: bold;">This ticket has been closed.</p>
        <% } %>

        <br><button onclick="location.href='admin_support_tickets.jsp'" class="back-button">Back to Tickets</button>
    </div>
</div>
</body>
</html>
