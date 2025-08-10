CREATE DATABASE  IF NOT EXISTS `team4` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `team4`;
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
-- Table structure for table `Admin`
--

DROP TABLE IF EXISTS `Admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Admin` (
  `Admin_ID` int NOT NULL AUTO_INCREMENT,
  `User_ID` int NOT NULL,
  PRIMARY KEY (`Admin_ID`),
  CONSTRAINT `fk_admin_user` FOREIGN KEY (`User_ID`) REFERENCES `Users` (`User_ID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Admin`
--

LOCK TABLES `Admin` WRITE;
/*!40000 ALTER TABLE `Admin` DISABLE KEYS */;
INSERT INTO `Admin` (`Admin_ID`, `User_ID`) VALUES (1, 23);
/*!40000 ALTER TABLE `Admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Answers`
--

DROP TABLE IF EXISTS `Answers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Answers` (
  `User_ID` int NOT NULL,
  `Message_ID` int NOT NULL,
  PRIMARY KEY (`User_ID`,`Message_ID`),
  KEY `fk_answers_message` (`Message_ID`),
  CONSTRAINT `fk_answers_message` FOREIGN KEY (`Message_ID`) REFERENCES `Messages` (`Message_ID`) ON DELETE CASCADE,
  CONSTRAINT `fk_answers_user` FOREIGN KEY (`User_ID`) REFERENCES `Users` (`User_ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Answers`
--

LOCK TABLES `Answers` WRITE;
/*!40000 ALTER TABLE `Answers` DISABLE KEYS */;
INSERT INTO `Answers` VALUES (13,1),(11,2),(12,3),(16,4),(14,5),(15,6),(18,7),(19,8),(20,9),(17,10),(4,11),(2,12),(5,13),(3,14),(6,15),(7,16),(8,17),(1,18),(9,19),(10,20);
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
  PRIMARY KEY (`User_ID`,`Message_ID`),
  KEY `fk_asks_message` (`Message_ID`),
  CONSTRAINT `fk_asks_message` FOREIGN KEY (`Message_ID`) REFERENCES `Messages` (`Message_ID`) ON DELETE CASCADE,
  CONSTRAINT `fk_asks_user` FOREIGN KEY (`User_ID`) REFERENCES `Users` (`User_ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Asks`
--

LOCK TABLES `Asks` WRITE;
/*!40000 ALTER TABLE `Asks` DISABLE KEYS */;
INSERT INTO `Asks` VALUES (4,1),(2,2),(5,3),(3,4),(6,5),(7,6),(8,7),(1,8),(9,9),(10,10),(13,11),(11,12),(12,13),(16,14),(14,15),(15,16),(18,17),(19,18),(20,19),(17,20);
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
  `Price_Offered` decimal(10,2) NOT NULL,
  `Payment_Method` varchar(50) DEFAULT NULL,
  `Booking_Date` datetime NOT NULL,
  `Start_Time` datetime NOT NULL,
  `End_Time` datetime NOT NULL,
  PRIMARY KEY (`Booking_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Bookings`
--

LOCK TABLES `Bookings` WRITE;
/*!40000 ALTER TABLE `Bookings` DISABLE KEYS */;
INSERT INTO `Bookings` VALUES (1,'Completed','2024-09-10 21:30:00',25.00,'Credit Card','2024-09-20 09:00:00','2024-09-20 09:00:00','2024-09-20 11:00:00'),(2,'Completed','2024-03-05 18:11:00',18.50,'PayPal','2024-03-12 18:00:00','2024-03-12 18:00:00','2024-03-12 19:30:00'),(3,'Completed','2024-07-21 03:05:15',30.00,'Zelle','2024-08-05 07:00:00','2024-08-05 07:00:00','2024-08-05 08:00:00'),(4,'Cancelled','2024-09-15 20:00:00',22.00,'Credit Card','2024-10-01 15:00:00','2024-10-01 15:00:00','2024-10-01 16:00:00'),(5,'Completed','2024-11-02 18:45:00',45.00,'Credit Card','2024-11-10 10:00:00','2024-11-10 10:00:00','2024-11-10 13:00:00'),(6,'Completed','2025-01-18 16:00:49',20.00,'Apple Pay','2025-01-25 19:00:00','2025-01-25 19:00:00','2025-01-25 20:00:00'),(7,'Completed','2025-03-02 00:21:30',25.00,'PayPal','2025-03-25 12:00:00','2025-03-25 12:00:00','2025-03-25 13:00:00'),(8,'Completed','2025-04-01 16:00:00',15.00,'Credit Card','2025-04-10 14:00:00','2025-04-10 14:00:00','2025-04-10 15:00:00'),(9,'Completed','2025-06-11 01:10:00',20.00,'Zelle','2025-06-15 06:00:00','2025-06-15 06:00:00','2025-06-15 07:30:00'),(10,'Confirmed','2025-07-28 19:34:56',50.00,'Credit Card','2025-08-05 11:00:00','2025-08-05 11:00:00','2025-08-05 12:00:00'),(16,'Completed','2025-08-04 07:00:00',14.57,'Credit Card','2025-08-03 00:00:00','2025-08-10 11:59:00','2025-08-10 12:37:00');
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
  PRIMARY KEY (`Gym_ID`,`Photo_ID`),
  KEY `fk_displays_photo` (`Photo_ID`),
  CONSTRAINT `fk_displays_gym` FOREIGN KEY (`Gym_ID`) REFERENCES `Gyms` (`Gym_ID`) ON DELETE CASCADE,
  CONSTRAINT `fk_displays_photo` FOREIGN KEY (`Photo_ID`) REFERENCES `Photos` (`Photo_ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Displays`
--

LOCK TABLES `Displays` WRITE;
/*!40000 ALTER TABLE `Displays` DISABLE KEYS */;
INSERT INTO `Displays` VALUES (1,1),(8,2),(2,3),(4,4),(3,5),(7,6),(2,7),(2,8),(5,9),(1,10),(6,17),(9,18),(10,19),(16,24);
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
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Features`
--

LOCK TABLES `Features` WRITE;
/*!40000 ALTER TABLE `Features` DISABLE KEYS */;
INSERT INTO `Features` VALUES (1,'Air '),(2,'Air '),(3,'Swimming Pool'),(4,'TV'),(5,'Towels'),(6,'Personal Training'),(7,'First Aid Kit'),(8,'Wipes'),(9,'Drinks'),(10,'Driveway Parking'),(11,'Air '),(12,'Blender'),(13,'Air'),(14,'Air Conditioning'),(15,'Free Snacks');
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
  PRIMARY KEY (`User_ID`),
  CONSTRAINT `fk_guest_user` FOREIGN KEY (`User_ID`) REFERENCES `Users` (`User_ID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
  `Address` varchar(500) NOT NULL,
  `Price` varchar(45) NOT NULL,
  PRIMARY KEY (`Gym_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Gyms`
--

LOCK TABLES `Gyms` WRITE;
/*!40000 ALTER TABLE `Gyms` DISABLE KEYS */;
INSERT INTO `Gyms` VALUES (1,'Giants Gathering','Old-School Bodybuilding','24 Willie Mays Plaza, San Francisco, CA 94107','22.00'),(2,'Dodger District','Luxury Fitness','1000 Vin Scully Avenue, Los Angeles, CA 90012','31.50'),(3,'Angel Arms','Specializes in Cross Fit Equipment','2000 Gene Autry Way, Anaheim, CA 92806','7.99'),(4,'Rockie Range','Premier Equipment','2001 Blake Street, Denver, CO 80205','89.00'),(5,'Padre Porter','Yoga Mats Provided','100 Park Blvd, San Diego, CA 92101','32.00'),(6,'Diamondback District','Modern Gym with Exceptional Equipment','401 E. Jefferson St., Phoenix, AZ 85004','25.00'),(7,'Marlin Machine','Intended for Heavy Lifters','501 Marlins Way, Miami, FL 33125','16.00'),(8,'Yankee Yard','24/7 Gym','161st Street Bronx, NY 10451','11.00'),(9,'Mets Meetup','Specializes in Powerlifting','41 Seaver Way, Queens, NY 11368','19.00'),(10,'Phillie Porch','Great for all Fitness Levels','One Citizens Bank Way, Philadelphia, PA 19148','44.00'),(16,'Great Gym','Has great equipment!!!','2334 City View Dr, Cleveland, OH 44113\n','23.00');
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
  PRIMARY KEY (`Booking_ID`,`Gym_ID`),
  KEY `fk_has_gym` (`Gym_ID`),
  CONSTRAINT `fk_has_booking` FOREIGN KEY (`Booking_ID`) REFERENCES `Bookings` (`Booking_ID`) ON DELETE CASCADE,
  CONSTRAINT `fk_has_gym` FOREIGN KEY (`Gym_ID`) REFERENCES `Gyms` (`Gym_ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Has`
--

LOCK TABLES `Has` WRITE;
/*!40000 ALTER TABLE `Has` DISABLE KEYS */;
INSERT INTO `Has` VALUES (7,1),(1,2),(3,3),(9,3),(8,4),(2,5),(5,5),(4,7),(10,8),(6,9),(16,16);
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
  PRIMARY KEY (`User_ID`),
  CONSTRAINT `fk_host_user` FOREIGN KEY (`User_ID`) REFERENCES `Users` (`User_ID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Hosts`
--

LOCK TABLES `Hosts` WRITE;
/*!40000 ALTER TABLE `Hosts` DISABLE KEYS */;
INSERT INTO `Hosts` VALUES (11,'USD'),(12,'USD'),(13,'GBP'),(14,'CAD'),(15,'JPY'),(16,'EUR'),(17,'EUR'),(18,'EUR'),(19,'USD'),(20,'USD'),(22,'USD');
/*!40000 ALTER TABLE `Hosts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Machines`
--

DROP TABLE IF EXISTS `Machines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Machines` (
  `Gym_ID` int NOT NULL,
  `Machine_Number` int NOT NULL,
  `Status` varchar(20) DEFAULT NULL,
  `Type` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`Gym_ID`,`Machine_Number`),
  CONSTRAINT `fk_machines_gym` FOREIGN KEY (`Gym_ID`) REFERENCES `Gyms` (`Gym_ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Machines`
--

LOCK TABLES `Machines` WRITE;
/*!40000 ALTER TABLE `Machines` DISABLE KEYS */;
INSERT INTO `Machines` VALUES (1,1,'Available','Hammer Strength ISO-Lateral Row'),(1,2,'Maintenance','Leg Press'),(2,1,'Available','Treadmill'),(3,1,'Maintenance','Bench Press'),(5,1,'Available','StairMaster'),(7,1,'Maintenance','Smith Machine'),(7,2,'Available','Hack Squat'),(8,1,'Available','Cables'),(9,1,'Available','Lateral Rows'),(10,1,'Available','Lat Pulldown'),(16,1,'Available','Bench Press'),(16,2,'Available','Lat Pull Down'),(16,3,'Unavailable','Incline Bench');
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
  PRIMARY KEY (`User_ID`,`Booking_ID`),
  CONSTRAINT `fk_makes_user` FOREIGN KEY (`User_ID`) REFERENCES `Users` (`User_ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Makes`
--

LOCK TABLES `Makes` WRITE;
/*!40000 ALTER TABLE `Makes` DISABLE KEYS */;
INSERT INTO `Makes` VALUES (1,7),(1,16),(2,1),(3,2),(3,5),(4,3),(4,9),(5,4),(6,6),(7,8),(8,10);
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
  `Timestamp` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Message_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Messages`
--

LOCK TABLES `Messages` WRITE;
/*!40000 ALTER TABLE `Messages` DISABLE KEYS */;
INSERT INTO `Messages` VALUES (1,'Hi, do you have deadlifts?','2025-08-04 00:53:53'),(2,'Do you have any bike machines?','2025-08-04 00:53:53'),(3,'I have allergies. Do you have allergy medicine?','2025-08-04 00:53:53'),(4,'Can you lower the price?','2025-08-04 00:53:53'),(5,'Is it possible to rent lifting gloves?','2025-08-04 00:53:53'),(6,'Can I pay with Apple Pay for a drop-in?','2025-08-04 00:53:53'),(7,'Is the 24/7 access via an electronic key?','2025-08-04 00:53:53'),(8,'How many adjustable benches are there?','2025-08-04 00:53:53'),(9,'Do you have wipes to clean the machines?','2025-08-04 00:53:53'),(10,'I forgot my protein shaker, do you sell them there?','2025-08-04 00:53:53'),(11,'Yes, the gym have deadlifts.','2025-08-04 00:53:54'),(12,'No, I do not have any bike machines.','2025-08-04 00:53:54'),(13,'Yes, I have nasal relief medication.','2025-08-04 00:53:54'),(14,'No, just because you asked I\'m raising it.','2025-08-04 00:53:54'),(15,'We have gardening gloves if that\'s fine. ','2025-08-04 00:53:54'),(16,'Apple Pay is preferred.','2025-08-04 00:53:54'),(17,'You will receive a temporary code for a keypad on the door.','2025-08-04 00:53:54'),(18,'I have 1.','2025-08-04 00:53:54'),(19,'I have wet wipes.','2025-08-04 00:53:54'),(20,'I have protein shakes if you want to buy some.','2025-08-04 00:53:54');
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
  PRIMARY KEY (`User_ID`,`Gym_ID`),
  KEY `fk_owns_gym` (`Gym_ID`),
  CONSTRAINT `fk_owns_gym` FOREIGN KEY (`Gym_ID`) REFERENCES `Gyms` (`Gym_ID`) ON DELETE CASCADE,
  CONSTRAINT `fk_owns_user` FOREIGN KEY (`User_ID`) REFERENCES `Users` (`User_ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Owns`
--

LOCK TABLES `Owns` WRITE;
/*!40000 ALTER TABLE `Owns` DISABLE KEYS */;
INSERT INTO `Owns` VALUES (11,1),(12,2),(13,3),(14,4),(16,5),(14,6),(18,7),(15,8),(16,9),(17,10),(20,16);
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
  `Priority` int DEFAULT '0',
  `Photo_Path` varchar(500) NOT NULL DEFAULT 'gym_photos/img/GymPhotoDefault.png',
  PRIMARY KEY (`Photo_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Photos`
--

LOCK TABLES `Photos` WRITE;
/*!40000 ALTER TABLE `Photos` DISABLE KEYS */;
INSERT INTO `Photos` VALUES (1,1,'gym_photos/img/Oracle_Park_2021.jpg'),(2,1,'gym_photos/img/960px-Yankee_Stadium_overhead_2010.jpg'),(3,1,'gym_photos/img/dodger_stadium.jpg'),(4,1,'gym_photos/img/coors23main.jpg'),(5,1,'gym_photos/img/angel_stadium.jpg'),(6,1,'gym_photos/img/220303-loanDepot-park-003_6F2033F9-58C2-48EB-928F803A89DEEA73_976248f9-12f7-40de-b88a9ae1ea20b712.jpg'),(7,4,'gym_photos/img/Oracle_Park_2021.jpg'),(8,2,'gym_photos/img/Oracle_Park_2021.jpg'),(9,1,'gym_photos/img/cxokitadxulv7zdq92qf.jpg'),(10,2,'gym_photos/img/Oracle_Park_2021.jpg'),(11,1,'gym_photos/img/gym_11_1754265398797_b99dfab22fa541ac96e1b1196fb89593.jpg'),(15,2,'gym_photos/img/gym_11_1754292792448_25d7cd3d353843d48cc060c455d6722d.png'),(16,3,'gym_photos/img/gym_11_1754292872861_999278a55b5a4a9f989388bfb45ae3c5.png'),(17,1,'gym_photos/img/uhhsnqu1aurjkzokwxze.jpg'),(18,1,'gym_photos/img/CitiField_Populous.jpeg'),(19,1,'gym_photos/img/VH3SR6OFKNERFIZK52BNLRPR6M.jpg'),(24,1,'gym_photos/img/gym_16_1754375620253_dc48a5232d82454d91aa00af3b91ff31.jpg');
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
  PRIMARY KEY (`Gym_ID`,`Feature_ID`),
  KEY `fk_possesses_feature` (`Feature_ID`),
  CONSTRAINT `fk_possesses_feature` FOREIGN KEY (`Feature_ID`) REFERENCES `Features` (`Feature_ID`) ON DELETE CASCADE,
  CONSTRAINT `fk_possesses_gym` FOREIGN KEY (`Gym_ID`) REFERENCES `Gyms` (`Gym_ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Possesses`
--

LOCK TABLES `Possesses` WRITE;
/*!40000 ALTER TABLE `Possesses` DISABLE KEYS */;
INSERT INTO `Possesses` VALUES (1,1),(3,1),(2,4),(5,5),(2,6),(10,6),(2,7),(3,7),(5,9),(8,10),(16,14),(16,15);
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
  PRIMARY KEY (`Booking_ID`,`Review_ID`),
  KEY `fk_receives_review` (`Review_ID`),
  CONSTRAINT `fk_receives_booking` FOREIGN KEY (`Booking_ID`) REFERENCES `Bookings` (`Booking_ID`) ON DELETE CASCADE,
  CONSTRAINT `fk_receives_review` FOREIGN KEY (`Review_ID`) REFERENCES `Reviews` (`Review_ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Receives`
--

LOCK TABLES `Receives` WRITE;
/*!40000 ALTER TABLE `Receives` DISABLE KEYS */;
INSERT INTO `Receives` VALUES (1,1),(2,2),(3,3),(4,4),(5,5),(6,6),(8,7),(10,8),(9,9),(7,10),(16,12);
/*!40000 ALTER TABLE `Receives` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Reports`
--

DROP TABLE IF EXISTS `Reports`;
CREATE TABLE `Reports` (
  `Ticket_ID` INT NOT NULL,
  `User_ID` INT NOT NULL,
  PRIMARY KEY (Ticket_ID),
  CONSTRAINT fk_reports_ticket UNIQUE (Ticket_ID),
  CONSTRAINT fk_reports_ticket_ref FOREIGN KEY (Ticket_ID) REFERENCES Tickets(Ticket_ID) ON DELETE CASCADE,
  CONSTRAINT fk_reports_user FOREIGN KEY (User_ID) REFERENCES Users (User_ID) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Reports`
--

LOCK TABLES `Reports` WRITE;
/*!40000 ALTER TABLE `Reports` DISABLE KEYS */;
INSERT INTO `Reports` VALUES (1,5),(2,1);
/*!40000 ALTER TABLE `Reports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Reported`
--

DROP TABLE IF EXISTS `Reported`;
CREATE TABLE `Reported` (
  `Ticket_ID` INT NOT NULL,
  `Gym_ID` INT NOT NULL,
  PRIMARY KEY (Ticket_ID),
  CONSTRAINT fk_reported_ticket FOREIGN KEY (Ticket_ID) REFERENCES Tickets (Ticket_ID) ON DELETE CASCADE,
  CONSTRAINT fk_reported_gym FOREIGN KEY (Gym_ID) REFERENCES Gyms (Gym_ID) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Reported`
--

LOCK TABLES `Reported` WRITE;
/*!40000 ALTER TABLE `Reported` DISABLE KEYS */;
INSERT INTO `Reported` VALUES (1,7),(2,1);
/*!40000 ALTER TABLE `Reported` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table: Resolved
--

DROP TABLE IF EXISTS Resolved;
CREATE TABLE Resolved (
    `Ticket_ID` INT NOT NULL,
    `Admin_ID` INT NOT NULL,
    PRIMARY KEY (Ticket_ID),
    CONSTRAINT fk_resolved_ticket FOREIGN KEY (Ticket_ID) REFERENCES Tickets (Ticket_ID) ON DELETE CASCADE,
    CONSTRAINT fk_resolved_admin FOREIGN KEY (Admin_ID) REFERENCES Admin (Admin_ID) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Resolved`
--

LOCK TABLES `Resolved` WRITE;
/*!40000 ALTER TABLE `Resolved` DISABLE KEYS */;
INSERT INTO `Resolved` VALUES (1,1),(2,1);
/*!40000 ALTER TABLE `Resolved` ENABLE KEYS */;
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
  `Date_Posted` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Review_ID`),
  CONSTRAINT `reviews_chk_1` CHECK (((`Stars` >= 1) and (`Stars` <= 5)))
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Reviews`
--

LOCK TABLES `Reviews` WRITE;
/*!40000 ALTER TABLE `Reviews` DISABLE KEYS */;
INSERT INTO `Reviews` VALUES (1,5,'Incredible atmosphere. The equipment is top-tier.','2025-08-04 00:53:53'),(2,3,'It was fine, but way too compact.','2025-08-04 00:53:53'),(3,5,'The best drop-in. I\'ll be back!','2025-08-04 00:53:53'),(4,1,'Cancelled my booking but was still charged','2025-08-04 00:53:53'),(5,5,'Excellent equipment which was exactly what I needed for a good workout.','2025-08-04 00:53:53'),(6,4,'Great gym, awesome vibe. ','2025-08-04 00:53:53'),(7,5,'I loved the extra amenities.','2025-08-04 00:53:53'),(8,4,'Clean, has everything you need. A bit small.','2025-08-04 00:53:53'),(9,5,'This place is a powerlifter\'s dream.','2025-08-04 00:53:53'),(10,2,'The gym was dirty.','2025-08-04 00:53:53'),(11,4,'Good','2025-08-04 14:55:59'),(12,5,'Very Good Gym!!!','2025-08-04 23:45:38');
/*!40000 ALTER TABLE `Reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Tickets`
--

DROP TABLE IF EXISTS `Tickets`;
CREATE TABLE `Tickets` (
  `Ticket_ID` INT NOT NULL AUTO_INCREMENT,
  `Status` ENUM('Open', 'Closed') NOT NULL DEFAULT 'Open',
  `Content` TEXT NOT NULL,
  `Time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (Ticket_ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Tickets`
--

LOCK TABLES `Tickets` WRITE;
/*!40000 ALTER TABLE `Tickets` DISABLE KEYS */;
INSERT INTO `Tickets` VALUES (1,'Open','I didn\'t get my money back, can you please help me?','2025-08-04 00:53:53'),(2,'Open','This place was lowkey a hazard. Please investigate.','2025-08-04 00:53:53');
/*!40000 ALTER TABLE `Tickets` ENABLE KEYS */;
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
  `Bio` varchar(45) DEFAULT NULL,
  `Profile_Picture` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`User_ID`),
  UNIQUE KEY `Email` (`Email`),
  UNIQUE KEY `Username` (`Username`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Users`
--

LOCK TABLES `Users` WRITE;
/*!40000 ALTER TABLE `Users` DISABLE KEYS */;
INSERT INTO `Users` VALUES (1,'Carla','Vega','c.vega@gmail.com','c_vega88','oUL+TOWb5bOwADp0Dwf4OycQjFrX4Jb9Wz+X9zxa7Hg=','2024-04-05 17:20:00',NULL,NULL),(2,'David','Chen','chen.david@gmail.com','davechen','cgo6RGtpYLeDwlWfdGoHfcPljdydg7nEkWrmKeGyiY8=','2024-02-15 19:00:00',NULL,NULL),(3,'Sofia','Rodriguez','sofiar@yahoo.com','sofia_r','BQA16d4mN8H1qFFvWz6Cnpq+8axwJdIuUeTf6C+XQdk=','2024-01-26 02:30:00',NULL,NULL),(4,'Liam','Patel','liam.patel@outlook.com','liamp','tbK+BLyeiK83CgKVh0S2YagqQ5jVBqurNWXEP6WbKrw=','2024-06-11 19:00:00',NULL,NULL),(5,'Aisha','Khan','a.khan@icloud.com','aishak','amywoANf74X077Gj/FvC++4UYfNhcgzkICB/J4AN//4=','2024-08-01 16:00:00',NULL,NULL),(6,'Marco','Rossi','marco.rossi@gmail.com','m_rossi','9Bkru/Cogffb0igCZtcqz8pdWWksnPSK9jILdXJ71BQ=','2024-12-10 22:45:00',NULL,NULL),(7,'Chloe','Nguyen','chloe.n@gmail.com','chloe_fit','R1TE5emwwMLvt3YK5ezlUiDbV1XJ9d5ZI3AOdETHkXk=','2025-02-21 00:00:00',NULL,NULL),(8,'Wei','Lau','lau.wei@sjsu.edu','lau_wei_fit','hLldMyXhmRyUK8CmsrqElnOElioav5y5buJzwhVIENs=','2025-05-16 03:10:00',NULL,NULL),(9,'Jamal','Williams','jwilliams@sjsu.edu','jamal_w','+iFiI5A+9WGV/rzeuL3xWAvrtbbShL5ZgZ99gO7jTuI=','2025-07-01 17:00:00',NULL,NULL),(10,'Olga','Porta','olga.p@gmail.com','olgap','xQcuprqe+Qc5GiK4WqEjL2TWuflr6Y0arwc8TTL8wU4=','2025-07-20 20:00:00',NULL,NULL),(11,'Frank','Miller','frank.miller@gmail.com','fmiller_host','yLamzpcC6B98/oAFo21litfRTHcuhUAL9XyKHY0VvIY=','2024-01-15 17:30:00',NULL,NULL),(12,'Grace','Lee','grace.lee@gmail.com','gracelee_host','H+oXwqiokyqvJtnZraNTSw94umAz0QcxhtAU/SqIVWU=','2024-01-20 19:00:00',NULL,NULL),(13,'Ben','Carter','b.carter@yahoo.com','bencarter_host','ZQd4zeWHcLks0YlpCo80nBphQFSmkfkzrbLurZ50mgg=','2024-02-01 22:15:00',NULL,NULL),(14,'Isabelle','Donky','isabelle.d@yahoo.com','isadonkey_host','1jkLCXUcwmU7bPJuIRzVeXxEVFGtiCqzoxMVYzGdVNs=','2024-02-06 02:00:00',NULL,NULL),(15,'Kenji','Tanaka','kenji@outlook.com','kenji_host','iD3uHVpAS0XSli0EI9q6I1RTAbnlWVw1el2j+UX7cBk=','2024-03-10 17:45:00',NULL,NULL),(16,'Maria','Garcia','maria.g@sjsu.edu','mgarcia_host','rl3QbW25+TGF13Yh6Kjm/mkqE36WmfBeawqa5XV/beo=','2024-04-22 20:00:00',NULL,NULL),(17,'Sam','Ortiz','sam.o@sjsu.edu','sam_o_host','FTWQn3rJyc5tWM5nOVoWsQ5VvNmlOb1XzJpdKOKJCRk=','2024-05-19 00:30:00',NULL,NULL),(18,'Heidi','Schmidt','heidi@gmail.com','heidi_s_host','+iERJMVwX13SpE3466HA6ivDIZlUMSOP0KTuuDfUsBc=','2024-06-03 15:00:00',NULL,NULL),(19,'Alex','Inky','a.inky@gmail.com','inky12','5KV5wRb+3q0+jcKkzP05s4p75duM+72DlNXV+o9gA/s=','2024-07-12 02:00:00',NULL,NULL),(20,'Fatima','Alberts','fatima@gmail.com','fatima_alberts_host','8aHpmQp9ZbJ4oE7PypP+6mHlVpwIZcC4cdX1ffEf5C4=','2024-08-30 19:00:00',NULL,NULL),(22,'Timothy','Chan','tc@gmail.com','tc','QofkbvojfmXcLQHg0IYb9V+vd/fOTIoUcWLpitvwEN0=','2025-07-20 07:00:00',NULL,NULL),(23,'Admin','Admin','admin@gmail.com','admin1','ZHD6Ua30bVZhZFVBdKZGPNGuv7xqudFQi6wH0A=','2025-08-09 00:00:00',NULL,NULL);
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

-- Dump completed on 2025-08-05 10:12:49
