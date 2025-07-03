<%@ page import="java.sql.*"%>
<html>
<head>
  <title>Gym Share</title>
</head>
<body>
<h1 style="text-align: center; background-color: #f9f9f9;">Gym Share</h1>

<h3 style="text-align: center; color: #333;">Our Goal</h3>
<p style="text-align: center; margin-bottom: 100px; color: #555;">Our goal is to create a system in which people can interact to either rent a home gym or offer their own. We hope that users not only see health benefits but also connection with other members of the fitness community.</p>

<table border="1" style="width: auto; text-align: center;">
  <tr>
    <td>User ID</td>
    <td>First Name</td>
    <td>Last Name</td>
    <td>Email</td>
  </tr>
    <%
     String db = "team4";
        String user; // assumes database name is the same as username
          user = "root";
        String password = "*YourPassword*"; // replace with your actual password
        try {
            java.sql.Connection con;
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/team4?autoReconnect=true&useSSL=false",user, password);

            out.println("Admins: <br/>");
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM Admins");
            while (rs.next()) {
         out.println("<tr>" + "<td>" +  rs.getInt(1) + "</td>"+ "<td>" +    rs.getString(2) + "</td>"+   "<td>" + rs.getString(3) + "</td>" + "<td>" + rs.getString(4) + "</td>"  + "</tr>");
            }
            rs.close();
            stmt.close();
            con.close();
        } catch(SQLException e) {
            out.println("SQLException caught: " + e.getMessage());
        }
    %>
</body>
</html>