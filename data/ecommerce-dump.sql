-- MySQL dump 10.13  Distrib 5.5.38, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: onlinestore
-- ------------------------------------------------------
-- Server version	5.5.38-0ubuntu0.12.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

USE ecommerce;

--
-- Table structure for table `Category`
--

DROP TABLE IF EXISTS `Category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Category` (
  `idCategory` int(11) NOT NULL,
  `CategoryName` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`idCategory`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Category`
--

LOCK TABLES `Category` WRITE;
/*!40000 ALTER TABLE `Category` DISABLE KEYS */;
INSERT INTO `Category` VALUES (1,'Books'),(2,'Movies'),(3,'Music'),(4,'Games'),(5,'Electronics'),(6,'Computers'),(7,'Home'),(8,'Garden'),(9,'Tools'),(10,'Beauty'),(11,'Health'),(12,'Toys'),(13,'Kids'),(14,'Baby'),(15,'Clothes'),(16,'Shoes'),(17,'Jewelry'),(18,'Sports');
/*!40000 ALTER TABLE `Category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Customer`
--

DROP TABLE IF EXISTS `Customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Customer` (
  `idCustomer` int(11) NOT NULL,
  `FirstName` varchar(45) DEFAULT NULL,
  `LastName` varchar(45) DEFAULT NULL,
  `Location` varchar(45) DEFAULT NULL,
  `Country` varchar(45) DEFAULT NULL,
  `Email` varchar(45) DEFAULT NULL,
  `ActiveForNewsletter` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`idCustomer`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Customer`
--

LOCK TABLES `Customer` WRITE;
/*!40000 ALTER TABLE `Customer` DISABLE KEYS */;
INSERT INTO `Customer` VALUES (1,'John','Adams','Los Angeles','US','john.adams@email.com',1),(2,'Mary','Svensson','Stockholm','Sweden','msvensson@email.com',1),(3,'Patrick','Vilas','San Franciso','US','patrick.vilas@email.com',1),(4,'María','Dominguez','Bogota','Colombia','mdom@email.com',1),(5,'José','Andreo','Madrid','Spain','joseandreo@email.com',1),(6,'Jordi','Vila','Barcelona','Spain','vilavila@email.com',1),(7,'Hans','Willem','Munich','Germany','hwillem@email.com',1),(8,'Lisa','Agnelli','New York','US','lagnelli@email.com',1),(9,'Carmen','Tosas','Guayaquil','Ecuador','ctosas@email.com',1),(10,'Francesca','Torlone','Milan','Italy','ftorlone@email.com',1),(11,'Angeles','Casas','Madrid','Spain','acasas@email.com',0),(12,'Brian','Robinson','Los Angeles','US','brobinson@email.com',0),(13,'William','Williams','Toronto','Canada','wwilliams@email.com',1),(14,'Steve','Gates','New York','US','sgates@email.com',1),(15,'Flavio','Brindisi','Roma','Italia','fbrindisi@email.com',1),(16,'Constanza','Vignemale','Milan','Italia','vigne@email.com',1),(17,'Laura','Dosil','Madrid','Spain','ldosil@email.com',1),(18,'Michelle','Thomas','San Francisco','US','mthomas@email.com',1),(19,'Thomas','Schumacher','Munich','Germany','thomassch@email.com',1),(20,'Sancho','Cervantes','Albacete','Spain','scervantes@email.com',0);
/*!40000 ALTER TABLE `Customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Friend`
--

DROP TABLE IF EXISTS `Friend`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Friend` (
  `idFriend` int(11) NOT NULL,
  `Since` datetime DEFAULT NULL,
  `Active` varchar(45) DEFAULT NULL,
  `CustomerA` int(11) NOT NULL,
  `CustomerB` int(11) NOT NULL,
  PRIMARY KEY (`idFriend`),
  KEY `fk_Friend_Customer1` (`CustomerA`),
  KEY `fk_Friend_Customer2` (`CustomerB`),
  CONSTRAINT `fk_Friend_Customer1` FOREIGN KEY (`CustomerA`) REFERENCES `Customer` (`idCustomer`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Friend_Customer2` FOREIGN KEY (`CustomerB`) REFERENCES `Customer` (`idCustomer`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Friend`
--

LOCK TABLES `Friend` WRITE;
/*!40000 ALTER TABLE `Friend` DISABLE KEYS */;
INSERT INTO `Friend` VALUES (1,'2012-01-22 10:14:44','1',10,16),(2,'2012-04-13 22:11:16','1',7,19),(3,'2013-09-11 17:56:54','1',8,14),(4,'2014-03-05 17:15:55','1',18,19),(5,'2014-04-01 18:14:22','1',19,20);
/*!40000 ALTER TABLE `Friend` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PaymentMethod`
--

DROP TABLE IF EXISTS `PaymentMethod`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PaymentMethod` (
  `idPaymentMethod` int(11) NOT NULL,
  `Type` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`idPaymentMethod`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PaymentMethod`
--

LOCK TABLES `PaymentMethod` WRITE;
/*!40000 ALTER TABLE `PaymentMethod` DISABLE KEYS */;
INSERT INTO `PaymentMethod` VALUES (1,'CreditCard'),(2,'DebitCard'),(3,'BitCoins'),(4,'Cash');
/*!40000 ALTER TABLE `PaymentMethod` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Product`
--

DROP TABLE IF EXISTS `Product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Product` (
  `idProduct` int(11) NOT NULL,
  `ProductName` varchar(45) DEFAULT NULL,
  `CurrentUnitPrice` decimal(10,2) DEFAULT NULL,
  `Supplier` int(11) NOT NULL,
  `Category` int(11) NOT NULL,
  PRIMARY KEY (`idProduct`),
  KEY `fk_Product_Supplier` (`Supplier`),
  KEY `fk_Product_Category1` (`Category`),
  CONSTRAINT `fk_Product_Supplier` FOREIGN KEY (`Supplier`) REFERENCES `Supplier` (`idSupplier`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Product_Category1` FOREIGN KEY (`Category`) REFERENCES `Category` (`idCategory`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Product`
--

LOCK TABLES `Product` WRITE;
/*!40000 ALTER TABLE `Product` DISABLE KEYS */;
INSERT INTO `Product` VALUES (1,'Great Expectations',15.00,1,1),(2,'Alice in wonderland',10.00,1,1),(3,'Don Quijote de la Mancha',15.00,1,1),(4,'Nineteen Eighty-Four',12.50,1,1),(5,'Ulysses',23.00,1,1),(6,'Titanic',17.50,2,2),(7,'All about my mother',15.70,2,2),(8,'Indiana Jones',13.20,2,2),(9,'Forrest Gump',10.30,2,2),(10,'Toy story',12.40,2,2),(11,'Robin Hood',13.10,2,2),(12,'Robinson Crusoe',15.00,2,2),(13,'Mary Poppins',20.00,2,2),(14,'Jurasic park',16.00,2,2),(15,'Torrente 4',11.00,2,2),(16,'Mozart: Chamber Music',20.00,3,3),(17,'Monteverdi: L\'Orfeo',20.00,3,3),(18,'Schubert: The late string quartet',18.00,3,3),(19,'Mendelssohn: A midsummer night\'s dream',19.00,3,3),(20,'Bach: Orchestral suites 1-4',15.00,3,3),(21,'Bartok: Violin & viola concertos',14.00,3,3),(22,'Beethoven: Simphony n 6 Pastoral et.al.',17.00,3,3),(23,'Mozart: Simphonies 41 & 42',23.00,3,3),(24,'Handel: Music for the royal fireworks',25.00,3,3),(25,'Strauss: Waltzes',27.00,3,3),(26,'Bizet: Carmen',20.00,3,3),(27,'Monopoly',32.00,4,4),(28,'Poker cards',8.00,4,4),(29,'4 in a line',15.00,4,4),(30,'Magic games',16.00,4,4),(31,'Mathematic games',12.00,4,4),(32,'Become a good chef',16.00,4,4),(33,'Trivial mundial',28.00,4,4),(34,'Risk',33.00,4,4),(35,'25 online games',22.00,4,4),(36,'Family games',25.00,4,4),(37,'Oriental games',21.00,4,4),(38,'Basic astronomy kit',80.00,4,4),(39,'Basic chemistry kit',50.00,4,4),(40,'Basic electronics kit',30.00,4,4),(41,'Game Boy reedited',65.00,5,5),(42,'Super Nintendo new edition',120.00,5,5),(43,'PlayStation 4',240.00,5,5),(44,'5 elementary Game Boy games',60.00,5,5),(45,'Mario Kart for Super Nintendo',10.00,5,5),(46,'Mario Kart for PlayStation',15.00,5,5),(47,'Football manager',25.00,5,5),(48,'Basket manager',25.00,5,5),(49,'Advanced electronics kit',68.50,5,5),(50,'Build your own computer',200.00,5,5),(51,'Acer Ultrabook 15\'\' 4GB 500HD',500.00,6,6),(52,'Toshiba Laptop 17\'\' 8 GB 1TB',1250.00,6,6),(53,'Sony PC 16 GB 2 TB',1555.00,6,6),(54,'Asus Notebook 11\'\' 2GB 200HD',330.00,6,6),(55,'HP Laptop 15\'\' 8GB 500HD',444.00,6,6),(56,'DELL Ultrabook 14\'\' 6GB 256SSD',700.00,6,6),(57,'MacBook Pro 15\'\' 16GB 500SSD',2200.00,6,6),(58,'MacBook Air 13\'\' 8GB 128SSD',1500.00,6,6),(59,'iMac 10GB 500GB',1200.00,6,6),(60,'iPhone 4',700.00,6,6),(61,'Tennis Racket',40.00,7,18),(62,'Tennis Racket Professional',140.00,7,18),(63,'Tennis Balls',6.00,7,18),(64,'Tennis table kit for beginners',25.00,7,18),(65,'Tennis table professional racket',55.00,7,18),(66,'Leo Messi boots',66.00,7,18),(67,'Cristiano Ronaldo boots',66.00,7,18),(68,'Football ball',50.00,7,18),(69,'Basketball ball',45.00,7,18),(70,'Bicycle for beginners',120.00,7,18),(71,'Bicycle for professionals',330.00,7,18),(72,'Mountain biycle kit',33.00,7,18),(73,'Golf. Introductory video',20.00,7,18),(74,'Indoor football boots',25.00,7,18),(75,'Electronic chess board',35.00,7,18),(76,'Men black shoes',60.00,8,16),(77,'Men white shoes',58.00,8,16),(78,'Women red shoes',55.00,8,16),(79,'Women blue shoes',56.00,8,16),(80,'Women black shoes',54.00,8,16),(81,'Women white shoes',60.00,8,16),(82,'Boy black shoes',40.00,8,16),(83,'Boy green shoes',40.00,8,16),(84,'Girl purple shoes',40.00,8,16),(85,'Girl black shoes',49.00,8,16),(86,'First baby shoes',18.00,8,16),(87,'First baby shoes (white)',18.00,8,16),(88,'Men\'s T-shirt',20.00,9,15),(89,'Men\'s fashion T-shirt',25.00,9,15),(90,'Men\'s fashion T-shirt blue',25.00,9,15),(91,'Men\'s fashion T-shirt green',25.00,9,15),(92,'Women\'s dress',30.00,9,15),(93,'Women\'s dress white',30.00,9,15),(94,'Women\'s dress pink',30.00,9,15),(95,'Skirt',30.00,9,15),(96,'Skirt black',30.00,9,15),(97,'Men jacket',200.00,9,15),(98,'Women jacket',330.00,9,15),(99,'Fashion jeans',33.00,9,15),(100,'Classic jeans',30.00,9,15),(101,'Business tie',12.00,9,15),(102,'Junior T-shirt blue',15.00,9,13),(103,'Junior T-shirt red',15.00,9,13),(104,'Junior T-shirt green',15.00,9,13),(105,'Junior T-shirt yellow',15.00,9,13),(106,'Junior T-shirt black',15.00,9,13),(107,'Junior T-shirt white',15.00,9,13),(108,'Junior jeans',25.00,9,13),(109,'Junior black jeans',25.00,9,13),(110,'Junior green jeans',25.00,9,13),(111,'Baby dress white',18.00,9,14),(112,'Baby dress blue',18.00,9,14),(113,'Baby dress red',18.00,9,14),(114,'Baby dress green',18.00,9,14),(115,'Baby dress yellow',18.00,9,14);
/*!40000 ALTER TABLE `Product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Sale`
--

DROP TABLE IF EXISTS `Sale`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Sale` (
  `idSale` int(11) NOT NULL,
  `TotalAmount` decimal(10,2) DEFAULT NULL,
  `Customer` int(11) NOT NULL,
  `PaymentMethod` int(11) NOT NULL,
  `Timestamp` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`idSale`),
  KEY `fk_Order_Customer1` (`Customer`),
  KEY `fk_Order_PaymentMethod1` (`PaymentMethod`),
  CONSTRAINT `fk_Order_Customer1` FOREIGN KEY (`Customer`) REFERENCES `Customer` (`idCustomer`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Sale`
--

LOCK TABLES `Sale` WRITE;
/*!40000 ALTER TABLE `Sale` DISABLE KEYS */;
INSERT INTO `Sale` VALUES (1,23.00,15,1,'2012-01-01 18:14:44');
/*!40000 ALTER TABLE `Sale` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SaleDetail`
--

DROP TABLE IF EXISTS `SaleDetail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SaleDetail` (
  `idSaleDetail` int(11) NOT NULL,
  `UnitPrice` decimal(10,2) DEFAULT NULL,
  `Quantity` decimal(10,2) DEFAULT NULL,
  `TotalDiscount` decimal(10,2) DEFAULT NULL,
  `Product` int(11) NOT NULL,
  `Sale` int(11) NOT NULL,
  PRIMARY KEY (`idSaleDetail`),
  KEY `fk_OrderDetails_Product1` (`Product`),
  KEY `fk_OrderDetails_Order1` (`Sale`),
  CONSTRAINT `fk_OrderDetails_Order1` FOREIGN KEY (`Sale`) REFERENCES `Sale` (`idSale`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SaleDetail`
--

LOCK TABLES `SaleDetail` WRITE;
/*!40000 ALTER TABLE `SaleDetail` DISABLE KEYS */;
INSERT INTO `SaleDetail` VALUES (1,23.00,1.00,0.00,5,1);
/*!40000 ALTER TABLE `SaleDetail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Supplier`
--

DROP TABLE IF EXISTS `Supplier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Supplier` (
  `idSupplier` int(11) NOT NULL,
  `SupplierName` varchar(45) DEFAULT NULL,
  `Location` varchar(45) DEFAULT NULL,
  `Country` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`idSupplier`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Supplier`
--

LOCK TABLES `Supplier` WRITE;
/*!40000 ALTER TABLE `Supplier` DISABLE KEYS */;
INSERT INTO `Supplier` VALUES (1,'OnlineBooks','San Francisco','US'),(2,'BestMovies','Los Angeles','US'),(3,'ForeverMusic','Munich','Germany'),(4,'GamesForEverybody','Paris','France'),(5,'ElectronicCoUnlimited','Tokyo','Japan'),(6,'CheapComputers','Pekin','China'),(7,'AllSports','Barcelona','Spain'),(8,'AllTimeShoes','Milan','Italy'),(9,'MegaFashionHouse','Madrid','Spain');
/*!40000 ALTER TABLE `Supplier` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-10-20 10:32:12
