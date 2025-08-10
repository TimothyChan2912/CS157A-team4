<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setCharacterEncoding("UTF-8");
    Boolean isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");
    if (isLoggedIn == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Integer userID = (Integer) session.getAttribute("userID");
    String newFirstName = request.getParameter("firstName");
    String newLastName = request.getParameter("lastName");
    String newEmail = request.getParameter("email");
    String newUsername = request.getParameter("username");
    String newBio = request.getParameter("bio");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/team4?autoReconnect=true&useSSL=false", "root", "GymShare");

        String sql = "UPDATE Users SET First_Name=?, Last_Name=?, Email=?, Username=?, Bio=? WHERE User_ID=?";

        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, newFirstName);
        ps.setString(2, newLastName);
        ps.setString(3, newEmail);
        ps.setString(4, newUsername);
        ps.setString(5, newBio);
        ps.setInt(6, userID);

        ps.executeUpdate();

        session.setAttribute("firstName", newFirstName);
        session.setAttribute("lastName", newLastName);
        session.setAttribute("email", newEmail);
        session.setAttribute("username", newUsername);

        response.sendRedirect("guest_settings.jsp");
        ps.close();
        con.close();
    } catch (Exception e) {
        out.println("<p>Error updating settings: " + e.getMessage() + "</p>");
    }
%>

<style>
.settings-container {
  max-width: 600px;
  margin: 100px auto;
  padding: 30px;
  background: linear-gradient(145deg, #ffffff, #f9f9f9);
  border-radius: 16px;
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.08);
  border: 1px solid rgba(0, 0, 0, 0.05);
}

.settings-form input,
.settings-form textarea {
  width: 100%;
  box-sizing: border-box;
  resize: vertical;
  min-height: 120px;
  padding: 12px 16px;
  font-size: 1rem;
  border: 2px solid #e8ecef;
  border-radius: 8px;
  background-color: #fff;
  color: #2c3e50;
  transition: all 0.3s ease;
}
</style>
