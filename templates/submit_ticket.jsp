<%@ page import="java.sql.*, java.util.*" %>
<%
    String content = request.getParameter("content");
    int userID = Integer.parseInt(request.getParameter("userID"));
    int gymID = Integer.parseInt(request.getParameter("gymID"));

    Connection con = null;
    PreparedStatement stmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/team4", "root", "GymShare");

        stmt = con.prepareStatement("INSERT INTO Tickets (Content, Status, Time) VALUES (?, 'Open', NOW())", Statement.RETURN_GENERATED_KEYS);
        stmt.setString(1, content);
        stmt.executeUpdate();

        ResultSet keys = stmt.getGeneratedKeys();
        int ticketID = -1;
        if (keys.next()) {
            ticketID = keys.getInt(1);
        }
        keys.close();
        stmt.close();

        stmt = con.prepareStatement("INSERT INTO Reports (Ticket_ID, User_ID) VALUES (?, ?)");
        stmt.setInt(1, ticketID);
        stmt.setInt(2, userID);
        stmt.executeUpdate();
        stmt.close();
        
        stmt = con.prepareStatement("INSERT INTO Reported (Ticket_ID, Gym_ID) VALUES (?, ?)");
        stmt.setInt(1, ticketID);
        stmt.setInt(2, gymID);
        stmt.executeUpdate();
        stmt.close();
        
        con.close();

        session.setAttribute("successMessage", "Ticket submitted successfully");
        response.sendRedirect("guest_dashboard.jsp");
    } catch (Exception e) {
        out.println("Error submitting ticket: " + e.getMessage());
    }
%>
