<%@ page import="java.sql.*" %>
<%
    Integer userID = (Integer) session.getAttribute("userID");
    if (userID == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/team4?autoReconnect=true&useSSL=false", 
            "root", 
            "GymShare"
        );

        // 1. Get all Booking_IDs associated with the user
        PreparedStatement getBookings = con.prepareStatement(
            "SELECT Booking_ID FROM Makes WHERE User_ID = ?"
        );
        getBookings.setInt(1, userID);
        ResultSet rsBookings = getBookings.executeQuery();

        // Store booking IDs for deletion
        java.util.List<Integer> bookingIDs = new java.util.ArrayList<>();
        while (rsBookings.next()) {
            bookingIDs.add(rsBookings.getInt("Booking_ID"));
        }
        rsBookings.close();
        getBookings.close();

        // 2. Delete from Receives for those bookings
        PreparedStatement deleteReceives = con.prepareStatement("DELETE FROM Receives WHERE Booking_ID = ?");
        for (int bookingID : bookingIDs) {
            deleteReceives.setInt(1, bookingID);
            deleteReceives.executeUpdate();
        }
        deleteReceives.close();

        // 3. Delete from Has (related to Bookings)
        PreparedStatement deleteHas = con.prepareStatement("DELETE FROM Has WHERE Booking_ID = ?");
        for (int bookingID : bookingIDs) {
            deleteHas.setInt(1, bookingID);
            deleteHas.executeUpdate();
        }
        deleteHas.close();

        // 4. Delete from Makes
        PreparedStatement deleteMakes = con.prepareStatement("DELETE FROM Makes WHERE Booking_ID = ?");
        for (int bookingID : bookingIDs) {
            deleteMakes.setInt(1, bookingID);
            deleteMakes.executeUpdate();
        }
        deleteMakes.close();

        // 5. Delete from Bookings
        PreparedStatement deleteBookings = con.prepareStatement("DELETE FROM Bookings WHERE Booking_ID = ?");
        for (int bookingID : bookingIDs) {
            deleteBookings.setInt(1, bookingID);
            deleteBookings.executeUpdate();
        }
        deleteBookings.close();

        // 6. Clean orphaned reviews (optional, assuming no longer linked in Receives)
        PreparedStatement deleteOrphanReviews = con.prepareStatement(
            "DELETE FROM Reviews WHERE Review_ID NOT IN (SELECT Review_ID FROM Receives)"
        );
        deleteOrphanReviews.executeUpdate();
        deleteOrphanReviews.close();

        // 7. Delete from Guests
        PreparedStatement deleteGuest = con.prepareStatement("DELETE FROM Guests WHERE User_ID = ?");
        deleteGuest.setInt(1, userID);
        deleteGuest.executeUpdate();
        deleteGuest.close();

        // 8. Delete from Users
        PreparedStatement deleteUser = con.prepareStatement("DELETE FROM Users WHERE User_ID = ?");
        deleteUser.setInt(1, userID);
        deleteUser.executeUpdate();
        deleteUser.close();

        con.close();

        // Invalidate session and redirect
        session.invalidate();
        response.sendRedirect("login.jsp?accountDeleted=true");

    } catch (Exception e) {
        out.println("<p>Error deleting account: " + e.getMessage() + "</p>");
    }
%>
