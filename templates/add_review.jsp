<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    Boolean isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");
    if (isLoggedIn == null || !isLoggedIn) {
        response.sendRedirect("login.jsp");
        return;
    }

    Integer userID = (Integer) session.getAttribute("userID");
    String gymName = request.getParameter("gymName");
    String bookingStr = request.getParameter("bookingID");
    
    int bookingID = -1;
    int gymID = -1;
    boolean alreadyReviewed = false;
    
    if (bookingStr == null || bookingStr.trim().isEmpty()) {
        out.println("Invalid booking ID: not passed.");
        return;
    }

    try {
        bookingID = Integer.parseInt(bookingStr);

        String db = "team4";
        String user = "root";
        String password = "GymShare";

        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/" + db + "?autoReconnect=true&useSSL=false", user, password);

        // Get the Gym_ID associated with this booking
        PreparedStatement gymStmt = con.prepareStatement(
            "SELECT Gym_ID FROM Has WHERE Booking_ID = ?");
        gymStmt.setInt(1, bookingID);
        ResultSet gymRs = gymStmt.executeQuery();
        if (gymRs.next()) {
            gymID = gymRs.getInt("Gym_ID");
        } else {
            out.println("Error: Booking ID " + bookingID + " does not exist in Has table.");
            con.close();
            return;
        }

        // Check if this booking has already received a review
        PreparedStatement reviewCheck = con.prepareStatement(
            "SELECT 1 " +
        	"FROM Receives AS R " +
        	"JOIN Reviews AS V ON R.Review_ID = V.Review_ID " +
        	"WHERE R.Booking_ID = ? AND V.User_ID = ?"
        );
        reviewCheck.setInt(1, bookingID);
        reviewCheck.setInt(2, userID);
        ResultSet rs = reviewCheck.executeQuery();
        alreadyReviewed = rs.next();

        con.close();
    } catch (NumberFormatException e) {
        out.println("Invalid booking ID format.");
        return;
    } catch (Exception e) {
        out.println("Database error: " + e.getMessage());
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Leave Review</title>
    <link rel="stylesheet" href="../static/guest_listings.css">
    <style>
        .rating-container {
    		display: flex;
    		align-items: center;
    		gap: 10px;
    		margin-top: 15px;
    		margin-bottom: 10px;
		}

		.star-rating {
    		display: flex;
    		font-size: 2.5rem;
    		cursor: pointer;
		}

		.star-rating .star {
    		color: #ccc;
    		transition: color 0.2s;
		}
		
		.star-rating .star-hovered,
		.star-rating .star.selected {
			color: #FFD700;
		}
    </style>
	<script>
    	document.addEventListener("DOMContentLoaded", () => {
        	const stars = document.querySelectorAll(".star-rating .star");
        	const ratingInput = document.getElementById("rating");
        	let selectedRating = 0;

        	stars.forEach(star => {
            	const value = parseInt(star.getAttribute("data-value"));

            	star.addEventListener("mouseover", () => {
                	stars.forEach(s => {
                    	const sVal = parseInt(s.getAttribute("data-value"));
                    	s.classList.toggle("hovered", sVal <= value);
                	});
            	});

            	star.addEventListener("mouseout", () => {
                	stars.forEach(s => s.classList.remove("hovered"));
            	});

            	star.addEventListener("click", () => {
                	selectedRating = value;
                	ratingInput.value = value;

                	stars.forEach(s => {
                    	const sVal = parseInt(s.getAttribute("data-value"));
                    	s.classList.toggle("selected", sVal <= selectedRating);
                	});
            	});
        	});
    	});
	</script>
</head>
<body>
    <div class="main-content">
        <button class="back-button" onclick="history.back()">Back</button>
        <div class="header-container">
            <h1>Leave a Review for <%= gymName %></h1>
        </div>
        <% if (alreadyReviewed) { %>
            <p style="text-align: center; color: red;">You have already reviewed this booking.</p>
        <% } else { %>
            <form method="post" action="submit_review.jsp">
                <div class="rating-container">
    				<label for="rating">Rating:</label>
    				<div class="star-rating" id="starContainer">
        				<% for (int i = 1; i <= 5; i++) { %>
            				<span class="star" data-value="<%= i %>">&#9733;</span>
        				<% } %>
    				</div>
				</div>
				<input type="hidden" id="rating" name="rating" required>
			
                <label for="comment">Comment:</label>
                <textarea id="comment" name="comment" required></textarea>

                <input type="hidden" name="bookingID" value="<%= bookingID %>">
                <input type="hidden" name="gymID" value="<%= gymID %>">
                <button type="submit" class="save-button">Submit Review</button>
            </form>
        <% } %>
    </div>
</body>
</html>
