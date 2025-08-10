<%@ page import="java.sql.*" %>
<%
    String db = "team4";
    String user = "root";
    String password = "GymShare";

    int ticketID = -1;
    try {
        ticketID = Integer.parseInt(request.getParameter("ticketID"));
    } catch (NumberFormatException e) {
        out.println("Invalid ticket ID");
        return;
    }

    Connection con = null;
    PreparedStatement stmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/" + db, user, password);

        String updateSQL = "UPDATE Tickets SET Status = 'Closed' WHERE Ticket_ID = ?";
        stmt = con.prepareStatement(updateSQL);
        stmt.setInt(1, ticketID);
        int updated = stmt.executeUpdate();

        if (updated > 0) {
            response.sendRedirect("admin_support_tickets.jsp");
        } else {
            out.println("<p>Failed to close ticket.</p>");
        }

    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    } finally {
        if (stmt != null) stmt.close();
        if (con != null) con.close();
    }
%>
