<%@ page import="java.sql.*"%>

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
    <link rel="icon" type="image/x-icon" href="../assets/favicon.ico">
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <link href="https://fonts.googleapis.com/css?family=Catamaran:100,200,300,400,500,600,700,800,900" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css?family=Lato:100,100i,300,300i,400,400i,700,700i,900,900i" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../static/home.css">
    <link rel="stylesheet" type="text/css" href="../static/navbar.css">
    <link rel="stylesheet" type="text/css" href="../static/dashboard.css">
    <title>Calendar - Gym Share</title>
</head>

<body>
    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom fixed-top">
        <div class="container px-5">
            <a class="navbar-brand" href="../home.jsp">Gym Share</a>
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

    <div class="top-section">
                <div class="calendar-container">
                    <h2>Calendar</h2>
                    <div class="calendar-content">
                        <h3 id="month-name"></h3>
                        <table id="calendar">
                            <thead>
                                <tr>
                                    <th>Sun</th><th>Mon</th><th>Tue</th><th>Wed</th>
                                    <th>Thu</th><th>Fri</th><th>Sat</th>
                                </tr>
                            </thead>
                            <tbody id="calendar-body"></tbody>
                        </table>
                    </div>
                </div>
            </div>

<script>
        function createCalendar(month, year) {
            const calendarBody = document.getElementById("calendar-body");
            const monthNameElement = document.getElementById("month-name");
            const months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

            const monthText = `${months[month]} ${year}`;
            console.log("Setting month text:", monthText);
            
            if (monthNameElement) {
                monthNameElement.innerText = monthText;
                monthNameElement.textContent = monthText;
                console.log("Month element found and text set");
            } else {
                console.error("Month name element not found!");
            }
            
            calendarBody.innerHTML = "";

            const firstDay = new Date(year, month).getDay();
            const daysInMonth = new Date(year, month + 1, 0).getDate();
            const today = new Date();
            const isCurrentMonth = (today.getMonth() === month && today.getFullYear() === year);
            const todayDate = today.getDate();

            let date = 1;
            for (let i = 0; i < 6; i++) {
                const row = document.createElement("tr");
                for (let j = 0; j < 7; j++) {
                    const cell = document.createElement("td");
                    if (i === 0 && j < firstDay) {
                        cell.innerText = "";
                    } else if (date > daysInMonth) {
                        break;
                    } else {
                        cell.innerText = date;
                        
                        if (isCurrentMonth && date === todayDate) {
                            cell.classList.add('today');
                        }
                        
                        cell.addEventListener('click', function() {
                            if (this.innerText) {
                                document.querySelectorAll('#calendar td.selected').forEach(td => {
                                    td.classList.remove('selected');
                                });
                                this.classList.add('selected');
                            }
                        });
                        
                        date++;
                    }
                    row.appendChild(cell);
                }
                calendarBody.appendChild(row);
            }
        }

        window.onload = () => {
            const today = new Date();
            console.log("Page loaded, creating calendar for:", today.getMonth(), today.getFullYear());
            createCalendar(today.getMonth(), today.getFullYear());
        };
    </script>