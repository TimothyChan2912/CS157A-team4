<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    Boolean isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");
    if (isLoggedIn == null || !isLoggedIn) {
        response.sendRedirect("login.jsp");
        return;
    }

    Integer userID = (Integer) session.getAttribute("userID");
    int gymID = Integer.parseInt(request.getParameter("gymID"));
    String gymName = "";

    try {
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/team4", "root", "GymShare");
        PreparedStatement gymNameStmt = con.prepareStatement("SELECT Gym_Name FROM Gyms WHERE Gym_ID = ?");
        gymNameStmt.setInt(1, gymID);
        ResultSet rsGym = gymNameStmt.executeQuery();

        if (rsGym.next()) {
            gymName = rsGym.getString("Gym_Name");
        }

        rsGym.close();
        gymNameStmt.close();
        con.close();
    } catch (Exception e) {
        out.println("Error fetching gym name: " + e.getMessage());
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Reviews - <%= gymName %></title>
    <link rel="stylesheet" href="../static/home.css">
    <link rel="stylesheet" href="../static/navbar.css">
    <link rel="stylesheet" href="../static/my_gyms.css"> <%-- use same style sheet --%>
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom fixed-top">
        <div class="container px-5">
            <a class="navbar-brand" href="../home.jsp">Gym Share</a>
            <div class="collapse navbar-collapse" id="navbarResponsive">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link">Welcome!</a></li>
                    <li class="nav-item"><a class="nav-link" href="login.jsp">Log Out</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="main-content">
        <button class="back-button" onclick="location.href='my_gyms.jsp'">Back to My Gyms</button>

        <div class="header-container">
            <h1>Reviews for <%= gymName %></h1>
        </div>

        <%
            try {
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/team4", "root", "GymShare");
                PreparedStatement stmt = con.prepareStatement(
                    "SELECT R.Review_ID, U.First_Name, U.Last_Name, R.Rating, R.Comment, R.Timestamp " +
                    "FROM Reviews R JOIN Users U ON R.User_ID = U.User_ID " +
                    "WHERE R.Gym_ID = ? ORDER BY R.Timestamp DESC"
                );
                stmt.setInt(1, gymID);
                ResultSet rs = stmt.executeQuery();
                SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy h:mm a");

                boolean hasReviews = false;

                while (rs.next()) {
                    hasReviews = true;
                    int reviewID = rs.getInt("Review_ID");
                    String reviewer = rs.getString("First_Name") + " " + rs.getString("Last_Name");
                    int rating = rs.getInt("Rating");
                    String comment = rs.getString("Comment");
                    String date = sdf.format(rs.getTimestamp("Timestamp"));
        %>
                <div class="gym-container">
                    <div class="gym-header">
                        <h2><%= reviewer %></h2>
                        <form method="get" action="delete_review.jsp">
                            <input type="hidden" name="reviewID" value="<%= reviewID %>">
                            <input type="hidden" name="gymID" value="<%= gymID %>">
                            <button class="delete-button" type="submit">Delete Review</button>
                        </form>
                    </div>

                    <div class="gym-details">
                        <p><strong>Date:</strong> <%= date %></p>
                        <p><strong>Rating:</strong>
                            <% for (int i = 1; i <= 5; i++) { %>
                                <i class="<%= i <= rating ? "fas fa-star" : "far fa-star" %>" style="color: #FFD700;"></i>
                            <% } %>
                        </p>
                        <p><strong>Comment:</strong> <em>"<%= comment %>"</em></p>
                    </div>
                </div>
        <%
                }
                if (!hasReviews) {
        %>
                <p style="text-align: center; color: #888;">No reviews yet for this gym.</p>
        <%
                }

                rs.close();
                stmt.close();
                con.close();
            } catch (Exception e) {
                out.println("<p style='color:red;'>Error loading reviews: " + e.getMessage() + "</p>");
            }
        %>
    </div>
</body>
</html>
