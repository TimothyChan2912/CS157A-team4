<%@ page import="java.sql.*" %>
<%
    Integer userID = (Integer) session.getAttribute("userID");
    int bookingID = Integer.parseInt(request.getParameter("bookingID"));
    int gymID = Integer.parseInt(request.getParameter("gymID"));
    double rating = Double.parseDouble(request.getParameter("rating"));
    String comment = request.getParameter("comment");

    String db = "team4";
    String user = "root";
    String password = "GymShare";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/" + db + "?autoReconnect=true&useSSL=false", user, password);

        // Insert the new review
        String insertReviewSQL = "INSERT INTO Reviews (User_ID, Gym_ID, Rating, Comment) VALUES (?, ?, ?, ?)";
        PreparedStatement reviewStmt = con.prepareStatement(insertReviewSQL, Statement.RETURN_GENERATED_KEYS);
        reviewStmt.setInt(1, userID);
        reviewStmt.setInt(2, gymID);
        reviewStmt.setDouble(3, rating);
        reviewStmt.setString(4, comment);
        reviewStmt.executeUpdate();

        // Get the generated Review_ID
        ResultSet generatedKeys = reviewStmt.getGeneratedKeys();
        int reviewID = -1;
        if (generatedKeys.next()) {
            reviewID = generatedKeys.getInt(1);
        }

        // Associate this review with the booking
        if (reviewID != -1) {
            String insertReceivesSQL = "INSERT INTO Receives (Booking_ID, Review_ID) VALUES (?, ?)";
            PreparedStatement receivesStmt = con.prepareStatement(insertReceivesSQL);
            receivesStmt.setInt(1, bookingID);
            receivesStmt.setInt(2, reviewID);
            receivesStmt.executeUpdate();
            receivesStmt.close();
        }

        reviewStmt.close();
        con.close();

        response.sendRedirect("guest_listings.jsp");
    } catch (SQLException e) {
        out.println("Database Error: " + e.getMessage());
    } catch (Exception e) {
        out.println("Unexpected Error: " + e.getMessage());
    }
%>
