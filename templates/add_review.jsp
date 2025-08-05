<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    Boolean isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");
    if (isLoggedIn == null || !isLoggedIn) {
        response.sendRedirect("login.jsp");
        return;
    }

    String firstName = (String) session.getAttribute("firstName");
    Integer userID = (Integer) session.getAttribute("userID");
    
    String gymName = "";
    int bookingID = -1;
    int gymID = -1;
    boolean alreadyReviewed = false;
    String errorMessage = null;

    String db = "team4";
    String user = "root";
    String password = "GymShare";
    Connection con = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/" + db + "?autoReconnect=true&useSSL=false", user, password);

        if ("POST".equalsIgnoreCase(request.getMethod())) {
           

            bookingID = Integer.parseInt(request.getParameter("bookingID"));
            gymID = Integer.parseInt(request.getParameter("gymID"));
            int rating = (int) Double.parseDouble(request.getParameter("rating"));
            String comment = request.getParameter("comment");

            String insertReviewSQL = "INSERT INTO Reviews (Stars, Description, Date_Posted) VALUES (?, ?, NOW())";
            PreparedStatement reviewStmt = con.prepareStatement(insertReviewSQL, Statement.RETURN_GENERATED_KEYS);
            reviewStmt.setInt(1, rating);
            reviewStmt.setString(2, comment);
            reviewStmt.executeUpdate();

            ResultSet generatedKeys = reviewStmt.getGeneratedKeys();
            int reviewID = -1;
            if (generatedKeys.next()) {
                reviewID = generatedKeys.getInt(1);
            }
            generatedKeys.close();
            reviewStmt.close();


            if (reviewID != -1) {
                String insertReceivesSQL = "INSERT INTO Receives (Booking_ID, Review_ID) VALUES (?, ?)";
                PreparedStatement receivesStmt = con.prepareStatement(insertReceivesSQL);
                receivesStmt.setInt(1, bookingID);
                receivesStmt.setInt(2, reviewID);
                receivesStmt.executeUpdate();
                receivesStmt.close();
            }

            response.sendRedirect("guest_bookings.jsp?success=review_submitted");
            return; 

        } else {
            String bookingStr = request.getParameter("bookingID");
            gymName = request.getParameter("gymName");

            if (bookingStr == null || bookingStr.trim().isEmpty()) {
                response.sendRedirect("guest_bookings.jsp?error=no_booking_selected");
                return;
            }

            bookingID = Integer.parseInt(bookingStr);

            PreparedStatement gymStmt = con.prepareStatement("SELECT Gym_ID FROM Has WHERE Booking_ID = ?");
            gymStmt.setInt(1, bookingID);
            ResultSet gymRs = gymStmt.executeQuery();
            if (gymRs.next()) {
                gymID = gymRs.getInt("Gym_ID");
            } else {
                throw new SQLException("Booking ID " + bookingID + " not found.");
            }
            gymRs.close();
            gymStmt.close();


            PreparedStatement checkStmt = con.prepareStatement("SELECT COUNT(*) FROM Receives WHERE Booking_ID = ?");
            checkStmt.setInt(1, bookingID);
            ResultSet checkRs = checkStmt.executeQuery();
            if (checkRs.next() && checkRs.getInt(1) > 0) {
                alreadyReviewed = true;
            }
            checkRs.close();
            checkStmt.close();
        }

    } catch (Exception e) {
        errorMessage = "An error occurred: " + e.getMessage();
        e.printStackTrace();
    } finally {
        if (con != null) {
            try {
                con.close();
            } catch (SQLException e) {
            }
        }
    }

%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Leave Review - Gym Share</title>
    <link rel="icon" type="image/x-icon" href="../assets/favicon.ico">
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <link href="https://fonts.googleapis.com/css?family=Catamaran:100,200,300,400,500,600,700,800,900" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css?family=Lato:100,100i,300,300i,400,400i,700,700i,900,900i" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../static/home.css">
    <link rel="stylesheet" type="text/css" href="../static/navbar.css">
    <link rel="stylesheet" type="text/css" href="../static/view_listings.css">
    <style>
        .main-content { padding-top: 100px; padding-bottom: 40px; min-height: 100vh; background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%); position: relative; }
        .back-button { position: absolute; top: 90px; left: 30px; background: linear-gradient(135deg, #FF3C38 0%, #e74c3c 100%); color: white; border: none; padding: 12px 24px; border-radius: 25px; cursor: pointer; font-size: 0.9rem; font-weight: 600; text-transform: uppercase; letter-spacing: 1px; box-shadow: 0 4px 15px rgba(255, 60, 56, 0.3); transition: all 0.3s ease; z-index: 10; }
        .back-button:hover { background: linear-gradient(135deg, #FFD100 0%, #f39c12 100%); color: #2c3e50; transform: translateY(-2px); box-shadow: 0 6px 20px rgba(255, 209, 0, 0.4); }
        .header-container { text-align: center; margin-bottom: 40px; }
        .header-container h1 { font-size: 2.5rem; color: #2c3e50; margin: 0; font-weight: 700; }
        .review-form-container { max-width: 600px; margin: 0 auto; background: rgba(255, 255, 255, 0.95); border-radius: 20px; padding: 40px; box-shadow: 0 15px 35px rgba(0, 0, 0, 0.08), 0 5px 15px rgba(0, 0, 0, 0.05); backdrop-filter: blur(10px); border: 1px solid rgba(255, 255, 255, 0.2); }
        .error-message { text-align: center; color: #c0392b; font-size: 1.1rem; font-weight: 600; background: rgba(192, 57, 43, 0.1); padding: 20px; border-radius: 10px; border: 1px solid rgba(192, 57, 43, 0.2); margin-bottom: 20px; }
        .already-reviewed { text-align: center; color: #e74c3c; font-size: 1.2rem; font-weight: 600; background: rgba(231, 76, 60, 0.1); padding: 20px; border-radius: 10px; border: 1px solid rgba(231, 76, 60, 0.2); }
        .form-group { margin-bottom: 25px; }
        .form-group label { display: block; margin-bottom: 10px; color: #2c3e50; font-weight: 600; font-size: 1.1rem; }
        .rating-container { display: flex; align-items: center; gap: 15px; margin-top: 10px; }
        .star-rating { display: flex; font-size: 2.5rem; cursor: pointer; gap: 5px; }
        .star-rating .star { color: #ddd; transition: color 0.2s ease; }
        .star-rating .star.hovered, .star-rating .star.selected { color: #FFD700; }
        textarea { width: 100%; min-height: 120px; padding: 15px; border: 2px solid #e9ecef; border-radius: 10px; font-size: 1rem; font-family: 'Lato', sans-serif; resize: vertical; transition: border-color 0.3s ease; }
        textarea:focus { outline: none; border-color: #FF3C38; box-shadow: 0 0 0 3px rgba(255, 60, 56, 0.1); }
        .submit-button { background: linear-gradient(135deg, #FF3C38 0%, #e74c3c 100%); color: white; border: none; padding: 15px 40px; border-radius: 25px; cursor: pointer; font-weight: 700; font-size: 1.1rem; text-transform: uppercase; letter-spacing: 1px; box-shadow: 0 8px 25px rgba(255, 60, 56, 0.3); transition: all 0.3s ease; width: 100%; }
        .submit-button:hover { background: linear-gradient(135deg, #FFD100 0%, #f39c12 100%); color: #2c3e50; transform: translateY(-2px); box-shadow: 0 10px 30px rgba(255, 209, 0, 0.4); }
    </style>
    <script>
        document.addEventListener("DOMContentLoaded", () => {
            const stars = document.querySelectorAll(".star-rating .star");
            const ratingInput = document.getElementById("rating");
            let selectedRating = 0;

            stars.forEach(star => {
                const value = parseInt(star.getAttribute("data-value"));
                star.addEventListener("mouseover", () => { stars.forEach(s => { const sVal = parseInt(s.getAttribute("data-value")); s.classList.toggle("hovered", sVal <= value); }); });
                star.addEventListener("mouseout", () => { stars.forEach(s => s.classList.remove("hovered")); });
                star.addEventListener("click", () => {
                    selectedRating = value;
                    ratingInput.value = value;
                    stars.forEach(s => { const sVal = parseInt(s.getAttribute("data-value")); s.classList.toggle("selected", sVal <= selectedRating); });
                });
            });

            const form = document.querySelector('form');
            if (form) {
                form.addEventListener('submit', (e) => {
                    if (selectedRating === 0) { e.preventDefault(); alert('Please select a rating before submitting.'); return false; }
                    const comment = document.getElementById('comment').value.trim();
                    if (comment === '') { e.preventDefault(); alert('Please enter a comment before submitting.'); return false; }
                });
            }
        });
    </script>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom fixed-top">
        <%-- Your navbar is fine --%>
        <div class="container px-5">
            <a class="navbar-brand" href="home.jsp">Gym Share</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation"><span class="navbar-toggler-icon"></span></button>
            <div class="collapse navbar-collapse" id="navbarResponsive">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link">Welcome <%= firstName %>!</a></li>
                    <li class="nav-item"> <a class="nav-link" href="host_settings.jsp"> <i class="fas fa-cog"></i> Settings </a> </li>
                    <li class="nav-item"><a class="nav-link" href="login.jsp">Log Out</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="main-content">
        <button class="back-button" onclick="history.back()">Back</button>
        <div class="header-container">
            <h1>Leave a Review for <%= (gymName != null ? gymName : "this Gym") %></h1>
        </div>
        
        <div class="review-form-container">
            <% if (errorMessage != null) { %>
                <div class="error-message">
                    <i class="fas fa-times-circle"></i> <%= errorMessage %>
                </div>
            <% } else if (alreadyReviewed) { %>
                <div class="already-reviewed">
                    <i class="fas fa-check-circle"></i>
                    You have already reviewed this booking.
                </div>
            <% } else { %>
                <form method="post" action="add_review.jsp"> <%-- The action points to itself --%>
                    <div class="form-group">
                        <div class="rating-container">
                            <label for="rating">Rating:</label>
                            <div class="star-rating" id="starContainer">
                                <% for (int i = 1; i <= 5; i++) { %>
                                    <span class="star" data-value="<%= i %>">★</span>
                                <% } %>
                            </div>
                        </div>
                        <input type="hidden" id="rating" name="rating" required>
                    </div>
                
                    <div class="form-group">
                        <label for="comment">Comment:</label>
                        <textarea id="comment" name="comment" placeholder="Share your experience with this gym..." required></textarea>
                    </div>

                    <input type="hidden" name="bookingID" value="<%= bookingID %>">
                    <input type="hidden" name="gymID" value="<%= gymID %>">
                    <button type="submit" class="submit-button">
                        <i class="fas fa-paper-plane"></i> Submit Review
                    </button>
                </form>
            <% } %>
        </div>
    </div>
</body>
</html>