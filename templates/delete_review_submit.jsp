<%@ page import="java.sql.*" %>
<%
    int reviewID = Integer.parseInt(request.getParameter("reviewID"));
    String reason = request.getParameter("reason");
    String comment = request.getParameter("comment");

    try {
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/team4", "root", "GymShare");

        // Delete the review
        PreparedStatement del = con.prepareStatement("DELETE FROM Reviews WHERE Review_ID = ?");
        del.setInt(1, reviewID);
        del.executeUpdate();

        con.close();
        response.sendRedirect("my_gyms.jsp");
    } catch (SQLException e) {
        out.println("Error: " + e.getMessage());
    }
%>
