<%@ page import="java.sql.*, java.util.*, java.text.SimpleDateFormat" %>
<%
    Boolean isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");
    if (isLoggedIn == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Integer userID = (Integer) session.getAttribute("userID");
    String firstName = (String) session.getAttribute("firstName");
    String db = "team4", user = "root", password = "GymShare";

    String selectedUserParam = request.getParameter("recipientID");
    int selectedUserID = selectedUserParam != null ? Integer.parseInt(selectedUserParam) : -1;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Messages - Gym Share</title>
    <link rel="stylesheet" href="../static/home.css">
    <link rel="stylesheet" href="../static/navbar.css">
    <link rel="stylesheet" type="text/css" href="../static/dashboard.css">
    <link rel="stylesheet" href="../static/messages.css">
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark navbar-custom fixed-top">
    <div class="container px-5">
        <a class="navbar-brand" href="home.jsp">Gym Share</a>
        <div class="navbar-title">
            <h1>Messages</h1>
        </div>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarResponsive">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarResponsive">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item"><a class="nav-link">Welcome <%= firstName %>!</a></li>
                <li class="nav-item"><a class="nav-link" href="guest_settings.jsp"><i class="fas fa-cog"></i> Settings</a></li>
                <li class="nav-item"><a class="nav-link" href="login.jsp">Log Out</a></li>
            </ul>
        </div>
    </div>
</nav>

<div class="main-content">
    <button class="back-button" onclick="location.href='guest_dashboard.jsp'">Back to Dashboard</button>
</div>

<div class="message-wrapper">
    <!-- Sidebar -->
    <div class="sidebar">
        <h3>Conversations</h3>
        <%
            try {
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/" + db, user, password);
                String query = 
                    "SELECT DISTINCT " +
                    "CASE WHEN A.User_ID = ? THEN B.User_ID ELSE A.User_ID END AS Contact_ID, " +
                    "(SELECT Gym_Name FROM Gyms G JOIN Owns O ON G.Gym_ID = O.Gym_ID WHERE O.User_ID = " +
                    " (CASE WHEN A.User_ID = ? THEN B.User_ID ELSE A.User_ID END) LIMIT 1) AS Gym_Name " +
                    "FROM Asks A " +
                    "JOIN Answers B ON A.Message_ID = B.Message_ID " +
                    "WHERE A.User_ID = ? OR B.User_ID = ?";

                PreparedStatement ps = con.prepareStatement(query);
                ps.setInt(1, userID);
                ps.setInt(2, userID);
                ps.setInt(3, userID);
                ps.setInt(4, userID);

                ResultSet rs = ps.executeQuery();
                boolean hasConversations = false;

                while (rs.next()) {
                    hasConversations = true;
                    int contactID = rs.getInt("Contact_ID");
                    String gymName = rs.getString("Gym_Name");
        %>
        <form method="get" action="guest_messages.jsp">
            <input type="hidden" name="recipientID" value="<%= contactID %>">
            <button class="conversation" type="submit"><%= gymName != null ? gymName : "Unknown Gym" %></button>
        </form>
        <%
                }
                if (!hasConversations) {
        %>
        <p style="text-align:center; color: #888;">No conversations yet.</p>
        <%
                }
                rs.close();
                ps.close();
                con.close();
            } catch (Exception e) {
                out.println("Error loading conversations: " + e.getMessage());
            }
        %>
    </div>

    <!-- Message area -->
    <div class="messages">
        <%
            if (selectedUserID != -1) {
                String gymName = "Conversation";
                try {
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/" + db, user, password);
                    String gymQuery = 
                        "SELECT Gym_Name FROM Gyms G " +
                        "JOIN Owns O ON G.Gym_ID = O.Gym_ID " +
                        "WHERE O.User_ID = ?";
                    PreparedStatement gymStmt = con.prepareStatement(gymQuery);
                    gymStmt.setInt(1, selectedUserID);
                    ResultSet gymRs = gymStmt.executeQuery();
                    if (gymRs.next()) {
                        gymName = gymRs.getString("Gym_Name");
                    }
                    gymRs.close();
                    gymStmt.close();
                    con.close();
                } catch (Exception e) {
                    out.println("Error loading gym name: " + e.getMessage());
                }
        %>

        <div class="conversation-header">
            <h3><%= gymName %></h3>
        </div>

        <div class="message-scroll-area">
        <%
            try {
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/" + db, user, password);
                String msgQuery =
                    "SELECT M.Content, M.Message_ID, A.User_ID AS Sender, B.User_ID AS Receiver, M.Timestamp " +
                    "FROM Messages M " +
                    "JOIN Asks A ON M.Message_ID = A.Message_ID " +
                    "JOIN Answers B ON M.Message_ID = B.Message_ID " +
                    "WHERE (A.User_ID = ? AND B.User_ID = ?) OR (A.User_ID = ? AND B.User_ID = ?) " +
                    "ORDER BY M.Timestamp ASC";

                PreparedStatement stmt = con.prepareStatement(msgQuery);
                stmt.setInt(1, userID);
                stmt.setInt(2, selectedUserID);
                stmt.setInt(3, selectedUserID);
                stmt.setInt(4, userID);

                ResultSet rs = stmt.executeQuery();
                boolean hasMessages = false;
                SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy h:mm a");

                while (rs.next()) {
                    hasMessages = true;
                    String content = rs.getString("Content");
                    int senderID = rs.getInt("Sender");
                    String direction = senderID == userID ? "sent" : "received";
                    String timestamp = sdf.format(rs.getTimestamp("Timestamp"));
        %>
            <div class="message <%= direction %>">
                <%= content %>
                <div class="timestamp" style="color: <%= "sent".equals(direction) ? "white" : "#888" %>;">
                    <%= timestamp %>
                </div>
            </div>
        <%
                }

                if (!hasMessages) {
        %>
            <p style="text-align:center; color: #999;">You have not sent or received any messages.</p>
        <%
                }

                rs.close();
                stmt.close();
                con.close();
            } catch (Exception e) {
                out.println("Error loading messages: " + e.getMessage());
            }
        %>
        </div>

        <form class="send-box" method="post" action="guest_send_message.jsp">
            <input type="hidden" name="senderID" value="<%= userID %>">
            <input type="hidden" name="recipientID" value="<%= selectedUserID %>">
            <textarea name="content" placeholder="Write a message..." required></textarea>
            <button type="submit" class="send-button">Send</button>
        </form>

        <% } else { %>
            <p style="margin: auto; text-align: center; color: #777;">You have not selected a conversation.</p>
        <% } %>
    </div>
</div>

<script>
    window.onload = function () {
        const scrollArea = document.querySelector('.message-scroll-area');
        if (scrollArea) scrollArea.scrollTop = scrollArea.scrollHeight;
    }
</script>
</body>
</html>
