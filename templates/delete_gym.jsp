<%@ page import="java.sql.*" %>

<%
    Boolean isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");
    if (isLoggedIn == null || !isLoggedIn) {
        response.sendRedirect("login.jsp");
        return;
    }

    Integer userID = (Integer) session.getAttribute("userID");
    String firstName = (String) session.getAttribute("firstName");

    String db = "team4";
    String user = "root"; //assumes database name is the same as username
    String password = "GymShare"; //Replace with your MySQL password

    try {
        java.sql.Connection con;
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/team4?autoReconnect=true&useSSL=false", user, password);

        int gymID = Integer.parseInt(request.getParameter("gymID"));

        Statement stmt = con.createStatement();

        String deleteGym = "DELETE FROM Gyms WHERE Gym_ID = " + gymID;
        stmt.execute(deleteGym);

        String deleteOwns = "DELETE FROM Owns WHERE Gym_ID = " + gymID + " AND User_ID = " + userID;
        stmt.execute(deleteOwns);

        String deleteHas = "DELETE FROM Has WHERE Gym_ID = " + gymID;
        stmt.execute(deleteHas);

        stmt.close();
        con.close();

        response.sendRedirect("my_gyms.jsp");
        return;
    }
    catch (SQLException e) {
        out.println("SQLException:" + e.getMessage());
    }
%>

