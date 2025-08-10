<%@ page import="java.sql.*" %>
<%
    request.setCharacterEncoding("UTF-8");
    Boolean isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");
    if (isLoggedIn == null || !isLoggedIn) {
        response.sendRedirect("login.jsp");
        return;
    }

    Integer userID = (Integer) session.getAttribute("userID");
    String currentPasswordInput = request.getParameter("currentPassword");
    String newPassword = request.getParameter("newPassword");

    String db = "team4", user = "root", password = "GymShare";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/" + db, user, password);

        // Verify current password
        String verifyQuery = "SELECT Password FROM Users WHERE User_ID = ?";
        PreparedStatement verifyStmt = con.prepareStatement(verifyQuery);
        verifyStmt.setInt(1, userID);
        ResultSet rs = verifyStmt.executeQuery();

        if (rs.next()) {
            String actualCurrentPassword = rs.getString("Password");

            if (actualCurrentPassword.equals(currentPasswordInput)) {
                // Update to new password
                String updateQuery = "UPDATE Users SET Password = ? WHERE User_ID = ?";
                PreparedStatement updateStmt = con.prepareStatement(updateQuery);
                updateStmt.setString(1, newPassword);
                updateStmt.setInt(2, userID);
                updateStmt.executeUpdate();
                updateStmt.close();

                session.setAttribute("successMessage", "Password changed successfully.");
            } else {
                session.setAttribute("successMessage", "Current password is incorrect.");
            }
        } else {
            session.setAttribute("successMessage", "User not found.");
        }

        rs.close();
        verifyStmt.close();
        con.close();

        response.sendRedirect("guest_settings.jsp");
    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    }
%>
