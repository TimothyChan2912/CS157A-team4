<%@ page import="java.sql.*" %>
<%
    Boolean isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");
    if (isLoggedIn == null) {
        response.sendRedirect("admin_login.jsp");
        return;
    }

    int reviewID = Integer.parseInt(request.getParameter("reviewID"));
    int gymID = Integer.parseInt(request.getParameter("gymID"));

    Connection con = null;
    PreparedStatement ps = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/team4?autoReconnect=true&useSSL=false", "root", "GymShare");

        // Delete from Receives (FK constraint)
        ps = con.prepareStatement("DELETE FROM Receives WHERE Review_ID = ?");
        ps.setInt(1, reviewID);
        ps.executeUpdate();
        ps.close();

        // Then delete the actual review
        ps = con.prepareStatement("DELETE FROM Reviews WHERE Review_ID = ?");
        ps.setInt(1, reviewID);
        ps.executeUpdate();

        response.sendRedirect("admin_gym_details.jsp?gymID=" + gymID);
    } catch (Exception e) {
        out.println("Error deleting review: " + e.getMessage());
    } finally {
        if (ps != null) ps.close();
        if (con != null) con.close();
    }
%>
