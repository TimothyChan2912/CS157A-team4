<%@ page import="java.sql.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>

<!DOCTYPE html>
<html lang="en">

<%
    Boolean isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");
    if (isLoggedIn == null || !isLoggedIn) {
        response.sendRedirect("login.jsp");
        return;
    }

    String firstName = (String) session.getAttribute("firstName");
    String lastName = (String) session.getAttribute("lastName");
    String username = (String) session.getAttribute("username");
    String email = (String) session.getAttribute("email");
    Integer userID = (Integer) session.getAttribute("userID");

    String db = "team4";
    String user = "root"; //assumes database name is the same as username
    String password = "GymShare"; //Replace with your MySQL password
%>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <link href="https://fonts.googleapis.com/css?family=Catamaran:100,200,300,400,500,600,700,800,900" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css?family=Lato:100,100i,300,300i,400,400i,700,700i,900,900i" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../static/home.css">
    <link rel="stylesheet" type="text/css" href="../static/navbar.css">
    <link rel="stylesheet" type="text/css" href="../static/host_calendar.css">
    <title>Calendar - Gym Share</title>
</head>

<body>
    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom fixed-top">
        <div class="container px-5">
            <a class="navbar-brand" href="home.jsp">Gym Share</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation"><span class="navbar-toggler-icon"></span></button>
            <div class="navbar-title">
                <h1>Calendar</h1>
            </div>
            <div class="collapse navbar-collapse" id="navbarResponsive">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link">Welcome <%= firstName %>!</a></li>
                    <li class="nav-item"><a class="nav-link" href="login.jsp">Log Out</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <div style="padding-top: 80px;">
        <button class="back-button" onclick="location.href='host_dashboard.jsp'">Back to Dashboard</button>
    </div>
    
    <div class="main-layout">
        <div class="booking-container left-container">
            <h3>Previous Bookings</h3>
            <div id="previousBookings">
                    <%
                        try {
                            java.sql.Connection con;
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/team4?autoReconnect=true&useSSL=false", user, password);

                            String retrievePreviousBookings = "SELECT Booking_Date, Start_Time, End_Time, Status, Gym_Name, Guests.User_ID" +
                                                                " FROM Guests JOIN Makes ON Guests.User_ID = Makes.User_ID JOIN Bookings USING (Booking_ID) JOIN Has USING (Booking_ID) JOIN Gyms USING (Gym_ID) JOIN Owns USING (Gym_ID) JOIN Hosts ON Hosts.User_ID = Owns.User_ID" +
                                                                " WHERE Hosts.User_ID = " + userID + " AND Booking_Date < CURDATE() AND Status = 'Completed'" +
                                                                " ORDER BY Booking_Date DESC, Start_Time";
                            Statement stmtPreviousBookings = con.createStatement();
                            ResultSet rsPreviousBookings = stmtPreviousBookings.executeQuery(retrievePreviousBookings);

                            while (rsPreviousBookings.next()) {
                                Date bookingDate = rsPreviousBookings.getDate("Booking_Date");
                                Time startTime = rsPreviousBookings.getTime("Start_Time");
                                Time endTime = rsPreviousBookings.getTime("End_Time");
                                String status = rsPreviousBookings.getString("Status");
                                Integer guestID = rsPreviousBookings.getInt("User_ID");
                                String gymName = rsPreviousBookings.getString("Gym_Name");

                                SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy");
                                SimpleDateFormat timeFormat = new SimpleDateFormat("h:mm a");

                                String bookingDateStr = dateFormat.format(bookingDate);
                                String startTimeStr = timeFormat.format(startTime);
                                String endTimeStr = timeFormat.format(endTime);

                                String retrieveGuestName = "SELECT First_Name, Last_Name FROM Users WHERE User_ID = " + guestID;
                                Statement stmtGuest = con.createStatement();
                                ResultSet rsGuest = stmtGuest.executeQuery(retrieveGuestName);

                                String guestFirstName = "";
                                String guestLastName = "";

                                if(rsGuest.next()) {
                                    guestFirstName = rsGuest.getString("First_Name");
                                    guestLastName = rsGuest.getString("Last_Name");
                                }

                                String bookingTime = startTimeStr + " - " + endTimeStr;
                                String bookingDetails = "Booking with " + guestFirstName + " " + guestLastName + " at " + gymName;
                                String bookingStatus = status.equals("Completed") ? "Completed" : "Cancelled";
                    %>
                                <div class="booking-item">
                                    <div class="booking-date"><%= bookingDateStr %></div>
                                    <div class="booking-time"><%= bookingTime %></div>
                                    <div class="booking-details"><%= bookingDetails %></div>
                                    <div class="booking-status <%= bookingStatus.toLowerCase() %>"><%= bookingStatus %></div>
                                </div>
                    <%
                            } 
                            if (rsPreviousBookings.isBeforeFirst() == false) {
                                %>
                                <div class="no-bookings">No previous bookings</div>
                                <%
                            }
                            rsPreviousBookings.close();
                            stmtPreviousBookings.close();
                            con.close();
                            } catch (SQLException e) {
                                out.println("SQLException: " + e.getMessage());
                            }
                    %>
            </div>
        </div>

        <div class="calendar-container">
             <%
                String selectedDateForCal = request.getParameter("selectedDate");
                String monthYear;

                if (selectedDateForCal != null && !selectedDateForCal.isEmpty()) {
                    Date d = new SimpleDateFormat("yyyy-MM-dd").parse(selectedDateForCal);
                    monthYear = new SimpleDateFormat("MMMM yyyy").format(d);
                    
                } else {
                    monthYear = new SimpleDateFormat("MMMM yyyy").format(new Date());
                }
            %>
            <div class="nav">
                <button onclick="changeMonth(-1)"> < </button>
                <h2 id="monthYear"></h2>
                <button onclick="changeMonth(1)"> > </button>
            </div>
            <table id="calendar">
                <thead>
                    <tr>
                        <th>Su</th><th>Mo</th><th>Tu</th><th>We</th><th>Th</th><th>Fr</th><th>Sa</th>
                    </tr>
                </thead>
                <tbody id="calendarBody"></tbody>
            </table>
        </div>

        <div class="booking-container right-container">
            <%
                String selectedDate = request.getParameter("selectedDate");
                String selectedDateStr = "Select a Date";
                
                if (selectedDate != null && !selectedDate.isEmpty()) {
                    Date date = new SimpleDateFormat("yyyy-MM-dd").parse(selectedDate);
                    selectedDateStr = new SimpleDateFormat("MMMM dd, yyyy").format(date) + " Bookings";
                }
            %>
            <h3 id="selectedDayTitle"><%= selectedDateStr %></h3>
            <div id="selectedDayBookings">
                <%                
                    if (selectedDate != null && !selectedDate.isEmpty()) {
                        try {
                            java.sql.Connection con;
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/team4?autoReconnect=true&useSSL=false", user, password);

                            String retrieveSelectedBookings = "SELECT Booking_Date, Start_Time, End_Time, Status, Gym_Name, Guests.User_ID" +
                                                                " FROM Guests JOIN Makes ON Guests.User_ID = Makes.User_ID JOIN Bookings USING (Booking_ID) JOIN Has USING (Booking_ID) JOIN Gyms USING (Gym_ID) JOIN Owns USING (Gym_ID) JOIN Hosts ON Hosts.User_ID = Owns.User_ID" +
                                                                " WHERE Hosts.User_ID = " + userID + " AND Status <> 'Cancelled' AND DATE(Booking_Date) = '" + selectedDate + "'" +
                                                                " ORDER BY Start_Time";
                            Statement stmtSelectedBookings = con.createStatement();
                            ResultSet rsSelectedBookings = stmtSelectedBookings.executeQuery(retrieveSelectedBookings);

                            boolean hasBookings = false;

                            while (rsSelectedBookings.next()) {
                                Date bookingDate = rsSelectedBookings.getDate("Booking_Date");
                                Time startTime = rsSelectedBookings.getTime("Start_Time");
                                Time endTime = rsSelectedBookings.getTime("End_Time");
                                String status = rsSelectedBookings.getString("Status");
                                Integer guestID = rsSelectedBookings.getInt("User_ID");
                                String gymName = rsSelectedBookings.getString("Gym_Name");
                                hasBookings = true;

                                SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy");
                                SimpleDateFormat timeFormat = new SimpleDateFormat("h:mm a");

                                String bookingDateStr = dateFormat.format(bookingDate);
                                String startTimeStr = timeFormat.format(startTime);
                                String endTimeStr = timeFormat.format(endTime);

                                String retrieveGuestName = "SELECT First_Name, Last_Name FROM Users WHERE User_ID = " + guestID;
                                Statement stmtGuest = con.createStatement();
                                ResultSet rsGuest = stmtGuest.executeQuery(retrieveGuestName);

                                String guestFirstName = "";
                                String guestLastName = "";

                                if(rsGuest.next()) {
                                    guestFirstName = rsGuest.getString("First_Name");
                                    guestLastName = rsGuest.getString("Last_Name");
                                }

                                String bookingTime = startTimeStr + " - " + endTimeStr;
                                String bookingDetails = "Booking with " + guestFirstName + " " + guestLastName + " at " + gymName;
                                String bookingStatus = status;
                    %>
                                <div class="booking-item">
                                    <div class="booking-date"><%= bookingDateStr %></div>
                                    <div class="booking-time"><%= bookingTime %></div>
                                    <div class="booking-details"><%= bookingDetails %></div>
                                    <div class="booking-status <%= bookingStatus.toLowerCase() %>"><%= bookingStatus %></div>
                                </div>
                    <%
                                rsGuest.close();
                                stmtGuest.close();
                            }
                            
                            if (!hasBookings) {
                                %>
                                <div class="no-bookings">No bookings for this date</div>
                                <%
                            }
                            rsSelectedBookings.close();
                            stmtSelectedBookings.close();
                            con.close();
                            } catch (SQLException e) {
                                out.println("SQLException: " + e.getMessage());
                            } catch (Exception e) {
                                out.println("Error: " + e.getMessage());
                            }
                    } else {
                        %>
                        <div class="no-bookings">Click on a date to view bookings</div>
                        <%
                    }
                %>
            </div>
        </div>
    </div>

    

<script>
    let today = new Date();
    let currentMonth = today.getMonth();
    let currentYear = today.getFullYear();
    
    const urlParams = new URLSearchParams(window.location.search);
    const initSelected = urlParams.get('selectedDate');

    function loadCalendar(month, year) {
        const firstDay = new Date(year, month, 1).getDay();
        const daysInMonth = new Date(year, month + 1, 0).getDate();
        const calendarBody = document.getElementById("calendarBody");
        const monthYear = document.getElementById("monthYear");

        calendarBody.innerHTML = "";
      
        const monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
        monthYear.textContent = monthNames[month] + " " + year;

        let date = 1;
        for (let i = 0; i < 6; i++) {
            let row = document.createElement("tr");

        for (let j = 0; j < 7; j++) {
            let cell = document.createElement("td");
            if (i === 0 && j < firstDay) {
                cell.textContent = "";
            } else if (date > daysInMonth) {
                cell.textContent = "";
            } else {
                let selectedDate = date;
                cell.textContent = selectedDate;
                cell.addEventListener('click', function() {
                    selectDate(selectedDate, month, year);
                });
                cell.style.cursor = 'pointer';
                if (
                    date === today.getDate() &&
                    year === today.getFullYear() &&
                    month === today.getMonth()
                ) {
                    cell.classList.add("today");
                }
                date++;
            }
        row.appendChild(cell);
        }

        calendarBody.appendChild(row);
        if (date > daysInMonth) break;
        }
    }

    function changeMonth(offset) {
        currentMonth += offset;
        if (currentMonth < 0) {
            currentMonth = 11;
            currentYear--;
        } else if (currentMonth > 11) {
            currentMonth = 0;
            currentYear++;
        }
        loadCalendar(currentMonth, currentYear);
    }

    function selectDate(day, month, year) {
        document.querySelectorAll('#calendar td').forEach(cell => {
            cell.classList.remove('selected');
        });
        
        event.target.classList.add('selected');
        
        const monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
        document.getElementById('selectedDayTitle').textContent = monthNames[month] + " " + day + ", " + year + " Bookings";
        
        window.location.href = 'host_calendar.jsp?selectedDate=' + year + '-' + (month + 1).toString().padStart(2, '0') + '-' + day.toString().padStart(2, '0');
    }

    document.addEventListener('DOMContentLoaded', function() {
        const monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
        
        const now = new Date();
        currentMonth = now.getMonth();
        currentYear = now.getFullYear();
        
        loadCalendar(currentMonth, currentYear);
        
        const selectedDate = urlParams.get('selectedDate');
        if (selectedDate) {
            const dateParts = selectedDate.split('-');
            const year = parseInt(dateParts[0]);
            const month = parseInt(dateParts[1]) - 1; 
            const day = parseInt(dateParts[2]);
            
            if (month !== currentMonth || year !== currentYear) {
                currentMonth = month;
                currentYear = year;
                loadCalendar(currentMonth, currentYear);
            }
            
            document.getElementById('selectedDayTitle').textContent = monthNames[month] + " " + day + ", " + year + " Bookings";
            
            setTimeout(() => {
                const cells = document.querySelectorAll('#calendar td');
                cells.forEach(cell => {
                    if (cell.textContent == day) {
                        cell.classList.add('selected');
                    }
                });
            }, 100);
        } else {
            const today = now.getDate();
            document.getElementById('selectedDayTitle').textContent = "Select a Date";
            
            setTimeout(() => {
                const cells = document.querySelectorAll('#calendar td');
                cells.forEach(cell => {
                    if (cell.textContent == today) {
                        cell.classList.add('today');
                    }
                });
            }, 100);
        }
    });
    
</script>