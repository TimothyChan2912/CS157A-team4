-- MySQL dump 10.13  Distrib 8.0.41, for macos15 (arm64)
--
-- Host: 127.0.0.1    Database: team4
-- ------------------------------------------------------
-- Server version	8.0.42

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Answers`
--

DROP TABLE IF EXISTS `Answers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Answers` (
  `User_ID` int NOT NULL,
  `Message_ID` int NOT NULL,
  PRIMARY KEY (`User_ID`,`Message_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Answers`
--

LOCK TABLES `Answers` WRITE;
/*!40000 ALTER TABLE `Answers` DISABLE KEYS */;
INSERT INTO `Answers` VALUES (11,12),(12,13),(13,11),(14,15),(15,16),(16,14),(17,20),(18,17),(19,18),(20,19);
/*!40000 ALTER TABLE `Answers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Asks`
--

DROP TABLE IF EXISTS `Asks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Asks` (
  `User_ID` int NOT NULL,
  `Message_ID` int NOT NULL,
  PRIMARY KEY (`User_ID`,`Message_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Asks`
--

LOCK TABLES `Asks` WRITE;
/*!40000 ALTER TABLE `Asks` DISABLE KEYS */;
INSERT INTO `Asks` VALUES (1,8),(2,2),(3,4),(4,1),(5,3),(6,5),(7,6),(8,7),(9,9),(10,10);
/*!40000 ALTER TABLE `Asks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Bookings`
--

DROP TABLE IF EXISTS `Bookings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Bookings` (
  `Booking_ID` int NOT NULL AUTO_INCREMENT,
  `Status` varchar(20) NOT NULL,
  `Request_Date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Price` decimal(10,2) NOT NULL,
  `Payment_Method` varchar(50) DEFAULT NULL,
  `Booking_Date` datetime NOT NULL,
  `Start_Time` datetime NOT NULL,
  `End_Time` datetime NOT NULL,
  PRIMARY KEY (`Booking_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Bookings`
--

LOCK TABLES `Bookings` WRITE;
/*!40000 ALTER TABLE `Bookings` DISABLE KEYS */;
INSERT INTO `Bookings` VALUES (1,'Completed','2024-09-10 21:30:00',25.00,'Credit Card','2024-09-20 09:00:00','2024-09-20 09:00:00','2024-09-20 11:00:00'),(2,'Completed','2024-03-05 18:11:00',18.50,'PayPal','2024-03-12 18:00:00','2024-03-12 18:00:00','2024-03-12 19:30:00'),(3,'Confirmed','2024-07-21 03:05:15',30.00,'Zelle','2024-08-05 07:00:00','2024-08-05 07:00:00','2024-08-05 08:00:00'),(4,'Cancelled','2024-09-15 20:00:00',22.00,'Credit Card','2024-10-01 15:00:00','2024-10-01 15:00:00','2024-10-01 16:00:00'),(5,'Completed','2024-11-02 18:45:00',45.00,'Credit Card','2024-11-10 10:00:00','2024-11-10 10:00:00','2024-11-10 13:00:00'),(6,'Completed','2025-01-18 16:00:49',20.00,'Apple Pay','2025-01-25 19:00:00','2025-01-25 19:00:00','2025-01-25 20:00:00'),(7,'Confirmed','2025-03-02 00:21:30',25.00,'PayPal','2025-03-25 12:00:00','2025-03-25 12:00:00','2025-03-25 13:00:00'),(8,'Confirmed','2025-04-01 16:00:00',15.00,'Credit Card','2025-04-10 14:00:00','2025-04-10 14:00:00','2025-04-10 15:00:00'),(9,'Completed','2025-06-11 01:10:00',20.00,'Zelle','2025-06-15 06:00:00','2025-06-15 06:00:00','2025-06-15 07:30:00'),(10,'Confirmed','2025-07-28 19:34:56',50.00,'Credit Card','2025-08-05 11:00:00','2025-08-05 11:00:00','2025-08-05 12:00:00');
/*!40000 ALTER TABLE `Bookings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Displays`
--

DROP TABLE IF EXISTS `Displays`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Displays` (
  `Gym_ID` int NOT NULL,
  `Photo_ID` int NOT NULL,
  PRIMARY KEY (`Gym_ID`,`Photo_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Displays`
--

LOCK TABLES `Displays` WRITE;
/*!40000 ALTER TABLE `Displays` DISABLE KEYS */;
INSERT INTO `Displays` VALUES (1,1),(1,10),(2,3),(2,7),(2,8),(3,5),(4,4),(5,9),(7,6),(8,2);
/*!40000 ALTER TABLE `Displays` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Features`
--

DROP TABLE IF EXISTS `Features`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Features` (
  `Feature_ID` int NOT NULL AUTO_INCREMENT,
  `Feature_Name` varchar(100) NOT NULL,
  PRIMARY KEY (`Feature_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Features`
--

LOCK TABLES `Features` WRITE;
/*!40000 ALTER TABLE `Features` DISABLE KEYS */;
INSERT INTO `Features` VALUES (1,'Air Conditioning'),(2,'Speaker'),(3,'Swimming Pool'),(4,'TV'),(5,'Towels'),(6,'Personal Training'),(7,'First Aid Kit'),(8,'Wipes'),(9,'Drinks'),(10,'Driveway Parking');
/*!40000 ALTER TABLE `Features` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Guests`
--

DROP TABLE IF EXISTS `Guests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Guests` (
  `User_ID` int NOT NULL AUTO_INCREMENT,
  `Current_Location` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`User_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Guests`
--

LOCK TABLES `Guests` WRITE;
/*!40000 ALTER TABLE `Guests` DISABLE KEYS */;
INSERT INTO `Guests` VALUES (1,'San Jose, CA'),(2,'San Francisco, CA'),(3,'Miami, FL'),(4,'Seattle, WA'),(5,'Chicago, IL'),(6,'Toronto, Canada'),(7,'Los Angeles, CA'),(8,'Boston, MA'),(9,'Atlanta, GA'),(10,'Cupertino, CA');
/*!40000 ALTER TABLE `Guests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Gyms`
--

DROP TABLE IF EXISTS `Gyms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Gyms` (
  `Gym_ID` int NOT NULL AUTO_INCREMENT,
  `Gym_Name` varchar(100) NOT NULL,
  `Description` text,
  `Address` varchar(255) NOT NULL,
  PRIMARY KEY (`Gym_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Gyms`
--

LOCK TABLES `Gyms` WRITE;
/*!40000 ALTER TABLE `Gyms` DISABLE KEYS */;
INSERT INTO `Gyms` VALUES (1,'Giants Gathering','Old-School Bodybuilding','24 Willie Mays Plaza, San Francisco, CA 94107'),(2,'Dodger District','Luxury Fitness','1000 Vin Scully Avenue, Los Angeles, CA 90012'),(3,'Angel Arms','Specializes in Cross Fit Equipment','2000 Gene Autry Way, Anaheim, CA 92806'),(4,'Rockie Range','Premier Equipment','2001 Blake Street, Denver, CO 80205'),(5,'Padre Porter','Yoga Mats Provided','100 Park Blvd, San Diego, CA 92101'),(6,'Diamondback District','Modern Gym with Exceptional Equipment','401 E. Jefferson St., Phoenix, AZ 85004'),(7,'Marlin Machine','Intended for Heavy Lifters','501 Marlins Way, Miami, FL 33125'),(8,'Yankee Yard','24/7 Gym','161st Street Bronx, NY 10451'),(9,'Mets Meetup','Specializes in Powerlifting','41 Seaver Way, Queens, NY 11368'),(10,'Phillie Porch','Great for all Fitness Levels','One Citizens Bank Way, Philadelphia, PA 19148');
/*!40000 ALTER TABLE `Gyms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Has`
--

DROP TABLE IF EXISTS `Has`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Has` (
  `Booking_ID` int NOT NULL,
  `Gym_ID` int NOT NULL,
  PRIMARY KEY (`Booking_ID`,`Gym_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Has`
--

LOCK TABLES `Has` WRITE;
/*!40000 ALTER TABLE `Has` DISABLE KEYS */;
INSERT INTO `Has` VALUES (1,2),(2,5),(3,3),(4,7),(5,5),(6,9),(7,1),(8,4),(9,3),(10,8);
/*!40000 ALTER TABLE `Has` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Hosts`
--

DROP TABLE IF EXISTS `Hosts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Hosts` (
  `User_ID` int NOT NULL AUTO_INCREMENT,
  `Preferred_Currency` varchar(3) DEFAULT 'USD',
  PRIMARY KEY (`User_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Hosts`
--

LOCK TABLES `Hosts` WRITE;
/*!40000 ALTER TABLE `Hosts` DISABLE KEYS */;
INSERT INTO `Hosts` VALUES (11,'USD'),(12,'USD'),(13,'GBP'),(14,'CAD'),(15,'JPY'),(16,'EUR'),(17,'EUR'),(18,'EUR'),(19,'USD'),(20,'INR');
/*!40000 ALTER TABLE `Hosts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Machines`
--

DROP TABLE IF EXISTS `Machines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Machines` (
  `Gym_ID` int NOT NULL AUTO_INCREMENT,
  `Machine_Number` int NOT NULL,
  `Status` varchar(20) DEFAULT NULL,
  `Type` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`Gym_ID`,`Machine_Number`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Machines`
--

LOCK TABLES `Machines` WRITE;
/*!40000 ALTER TABLE `Machines` DISABLE KEYS */;
INSERT INTO `Machines` VALUES (1,1,'Available','Hammer Strength ISO-Lateral Row'),(1,2,'Shipping','Leg Press'),(2,3,'Available','Treadmill'),(3,4,'Maintenance','Bench Press'),(5,5,'Available','StairMaster'),(7,6,'Maintenance','Smith Machine'),(7,7,'Available','Hack Squat'),(8,8,'Available','Cables'),(9,9,'Available','Lateral Rows'),(10,10,'Available','Lat Pulldown');
/*!40000 ALTER TABLE `Machines` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Makes`
--

DROP TABLE IF EXISTS `Makes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Makes` (
  `User_ID` int NOT NULL,
  `Booking_ID` int NOT NULL,
  PRIMARY KEY (`User_ID`,`Booking_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Makes`
--

LOCK TABLES `Makes` WRITE;
/*!40000 ALTER TABLE `Makes` DISABLE KEYS */;
INSERT INTO `Makes` VALUES (1,7),(2,1),(3,2),(3,5),(4,3),(4,9),(5,4),(6,6),(7,8),(8,10);
/*!40000 ALTER TABLE `Makes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Messages`
--

DROP TABLE IF EXISTS `Messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Messages` (
  `Message_ID` int NOT NULL AUTO_INCREMENT,
  `Content` text NOT NULL,
  PRIMARY KEY (`Message_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Messages`
--

LOCK TABLES `Messages` WRITE;
/*!40000 ALTER TABLE `Messages` DISABLE KEYS */;
INSERT INTO `Messages` VALUES (1,'Hi, do you have deadlifts?'),(2,'Do you have any bike machines?'),(3,'I have allergies. Do you have allergy medicine?'),(4,'Can you lower the price?'),(5,'Is it possible to rent lifting gloves?'),(6,'Can I pay with Apple Pay for a drop-in?'),(7,'Is the 24/7 access via an electronic key?'),(8,'How many adjustable benches are there?'),(9,'Do you have wipes to clean the machines?'),(10,'I forgot my protein shaker, do you sell them there?'),(11,'Yes, the gym have deadlifts.'),(12,'No, I do not have any bike machines.'),(13,'Yes, I have nasal relief medication.'),(14,'No, just because you asked I\'m raising it.'),(15,'We have gardening gloves if that\'s fine. '),(16,'Apple Pay is preferred.'),(17,'You will receive a temporary code for a keypad on the door.'),(18,'I have 1.'),(19,'I have wet wipes.'),(20,'I have protein shakes if you want to buy some.');
/*!40000 ALTER TABLE `Messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Owns`
--

DROP TABLE IF EXISTS `Owns`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Owns` (
  `User_ID` int NOT NULL,
  `Gym_ID` int NOT NULL,
  PRIMARY KEY (`User_ID`,`Gym_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Owns`
--

LOCK TABLES `Owns` WRITE;
/*!40000 ALTER TABLE `Owns` DISABLE KEYS */;
INSERT INTO `Owns` VALUES (11,1),(12,2),(13,3),(14,4),(14,6),(15,8),(16,5),(16,9),(17,10),(18,7);
/*!40000 ALTER TABLE `Owns` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Photos`
--

DROP TABLE IF EXISTS `Photos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Photos` (
  `Photo_ID` int NOT NULL AUTO_INCREMENT,
  `Caption` varchar(255) DEFAULT NULL,
  `Priority` int DEFAULT '0',
  PRIMARY KEY (`Photo_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Photos`
--

LOCK TABLES `Photos` WRITE;
/*!40000 ALTER TABLE `Photos` DISABLE KEYS */;
INSERT INTO `Photos` VALUES (1,'The main lifting area with 4 power racks.',1),(2,'View of the dumbbell rack, goes up to 150lbs.',2),(3,'Various cables and attachments.',1),(4,'Dumbells ranging from 5 lbs to 60 lbs.',1),(5,'Medicine balls and other equipment for stretching.',3),(6,'Yoga mats.',5),(7,'Fridge with offered drinks.',4),(8,'Massage chairs for recovery.',2),(9,'Juice bar near the entrance',4),(10,'Dedlift platforms with a range of plates.',2);
/*!40000 ALTER TABLE `Photos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Possesses`
--

DROP TABLE IF EXISTS `Possesses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Possesses` (
  `Gym_ID` int NOT NULL,
  `Feature_ID` int NOT NULL,
  PRIMARY KEY (`Gym_ID`,`Feature_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Possesses`
--

LOCK TABLES `Possesses` WRITE;
/*!40000 ALTER TABLE `Possesses` DISABLE KEYS */;
INSERT INTO `Possesses` VALUES (1,1),(2,4),(2,6),(2,7),(3,1),(3,7),(5,5),(5,9),(8,10),(10,6);
/*!40000 ALTER TABLE `Possesses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Receives`
--

DROP TABLE IF EXISTS `Receives`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Receives` (
  `Booking_ID` int NOT NULL,
  `Review_ID` int NOT NULL,
  PRIMARY KEY (`Booking_ID`,`Review_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Receives`
--

LOCK TABLES `Receives` WRITE;
/*!40000 ALTER TABLE `Receives` DISABLE KEYS */;
INSERT INTO `Receives` VALUES (1,1),(2,2),(3,3),(4,4),(5,5),(6,6),(7,10),(8,7),(9,9),(10,8);
/*!40000 ALTER TABLE `Receives` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Reviews`
--

DROP TABLE IF EXISTS `Reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Reviews` (
  `Review_ID` int NOT NULL AUTO_INCREMENT,
  `Stars` int NOT NULL,
  `Description` text,
  PRIMARY KEY (`Review_ID`),
  CONSTRAINT `reviews_chk_1` CHECK (((`Stars` >= 1) and (`Stars` <= 5)))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Reviews`
--

LOCK TABLES `Reviews` WRITE;
/*!40000 ALTER TABLE `Reviews` DISABLE KEYS */;
INSERT INTO `Reviews` VALUES (1,5,'Incredible atmosphere. The equipment is top-tier.'),(2,3,'It was fine, but way too compact.'),(3,5,'The best drop-in. I\'ll be back!'),(4,1,'Cancelled my booking but was still charged'),(5,5,'Excellent equipment which was exactly what I needed for a good workout.'),(6,4,'Great gym, awesome vibe. '),(7,5,'I loved the extra amenities.'),(8,4,'Clean, has everything you need. A bit small.'),(9,5,'This place is a powerlifter\'s dream.'),(10,2,'The gym was dirty.');
/*!40000 ALTER TABLE `Reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Users`
--

DROP TABLE IF EXISTS `Users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Users` (
  `User_ID` int NOT NULL AUTO_INCREMENT,
  `First_Name` varchar(50) NOT NULL,
  `Last_Name` varchar(50) NOT NULL,
  `Email` varchar(100) NOT NULL,
  `Username` varchar(50) NOT NULL,
  `Password` varchar(255) NOT NULL,
  `Date_Created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`User_ID`),
  UNIQUE KEY `Email` (`Email`),
  UNIQUE KEY `Username` (`Username`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Users`
--

LOCK TABLES `Users` WRITE;
/*!40000 ALTER TABLE `Users` DISABLE KEYS */;
INSERT INTO `Users` VALUES (1,'Carla','Vega','c.vega@gmail.com','c_vega88','hashpass1','2024-04-05 17:20:00'),(2,'David','Chen','chen.david@gmail.com','davechen','hashpass2','2024-02-15 19:00:00'),(3,'Sofia','Rodriguez','sofiar@yahoo.com','sofia_r','hashpass3','2024-01-26 02:30:00'),(4,'Liam','Patel','liam.patel@outlook.com','liamp','hashpass4','2024-06-11 19:00:00'),(5,'Aisha','Khan','a.khan@icloud.com','aishak','hashpass5','2024-08-01 16:00:00'),(6,'Marco','Rossi','marco.rossi@gmail.com','m_rossi','hashpass6','2024-12-10 22:45:00'),(7,'Chloe','Nguyen','chloe.n@gmail.com','chloe_fit','hashpass7','2025-02-21 00:00:00'),(8,'Wei','Lau','lau.wei@sjsu.edu','lau_wei_fit','hashpass8','2025-05-16 03:10:00'),(9,'Jamal','Williams','jwilliams@sjsu.edu','jamal_w','hashpass9','2025-07-01 17:00:00'),(10,'Olga','Porta','olga.p@gmail.com','olgap','hashpass10','2025-07-20 20:00:00'),(11,'Frank','Miller','frank.miller@gmail.com','fmiller_host','hashpass11','2024-01-15 17:30:00'),(12,'Grace','Lee','grace.lee@gmail.com','gracelee_host','hashpass12','2024-01-20 19:00:00'),(13,'Ben','Carter','b.carter@yahoo.com','bencarter_host','hashpass13','2024-02-01 22:15:00'),(14,'Isabelle','Donky','isabelle.d@yahoo.com','isadonkey_host','hashpass14','2024-02-06 02:00:00'),(15,'Kenji','Tanaka','kenji@outlook.com','kenji_host','hashpass15','2024-03-10 17:45:00'),(16,'Maria','Garcia','maria.g@sjsu.edu','mgarcia_host','hashpass16','2024-04-22 20:00:00'),(17,'Sam','Ortiz','sam.o@sjsu.edu','sam_o_host','hashpass17','2024-05-19 00:30:00'),(18,'Heidi','Schmidt','heidi@gmail.com','heidi_s_host','hashpass18','2024-06-03 15:00:00'),(19,'Alex','Inky','a.inky@gmail.com','inky12','hashpass19','2024-07-12 02:00:00'),(20,'Fatima','Alberts','fatima@gmail.com','fatima_alberts_host','hashpass20','2024-08-30 19:00:00');
/*!40000 ALTER TABLE `Users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-07-09 15:32:54
