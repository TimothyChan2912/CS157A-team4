<%@ page import="java.sql.*"%>
<html>
<head>
  <title>CS 157A - Team 4</title>
</head>
<body>
<h1>CS 157A - Team 4</h1>

<table border="1">
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
        String password = "*YourPassword*";
        try {
            java.sql.Connection con;
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/team4?autoReconnect=true&useSSL=false",user, password);
            out.println(db + " database successfully opened.<br/><br/>");

            out.println("Initial entries in table \"Users\": <br/>");
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM Users");
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