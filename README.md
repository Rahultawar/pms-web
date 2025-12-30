# Pharmacy Management System (PMS)

A web-based Pharmacy Management System built with Java Servlets, JSP, and MySQL for efficient inventory, sales, and customer management.

[![Java](https://img.shields.io/badge/Java-17-orange.svg)](https://www.oracle.com/java/)
[![Maven](https://img.shields.io/badge/Maven-3.6+-blue.svg)](https://maven.apache.org/)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-blue.svg)](https://www.mysql.com/)


## 📋 Overview

PMS is a full-featured pharmacy management solution that helps pharmacy owners and staff manage their daily operations including inventory tracking, sales processing, customer management, and real-time notifications for low stock and expiring products.

## ✨ Key Features

### 📦 Product Management
- Add, edit, and delete products with detailed information
- Track batch numbers, manufacturing and expiry dates
- Monitor stock levels with automatic low-stock alerts
- Categorize products (Tablet, Capsule, Syrup, Injection, etc.)
- Set reorder levels for automatic inventory alerts
- Location tracking within the pharmacy

### 💰 Sales Management
- Process sales transactions with multiple payment methods (Cash, Card, UPI)
- Apply discounts on sales
- Track pending and completed payments
- Customer-wise sale history
- Real-time stock deduction on sales
- Generate sales receipts

### 👥 Customer Management
- Maintain customer database
- Track customer contact information
- View customer purchase history
- Link sales to specific customers

### 🏢 Distributor Management
- Maintain distributor/supplier information
- Track contact person, email, phone, and address
- Link products to distributors
- Manage distributor relationships

### 📊 Dashboard & Analytics
- Real-time sales overview (Today, Monthly, Yearly)
- Pending payment tracking
- Product count and distributor statistics
- Sales trend analysis (Daily, Monthly, Yearly)
- Product category distribution charts
- Payment method distribution analytics
- Visual charts using Chart.js

### 🔔 Smart Notifications
- Automatic low-stock product alerts
- Expiring product notifications (30 days before expiry)
- Mark notifications as read/unread
- Real-time notification count in sidebar

### 📤 Import/Export Features
- CSV import for bulk product, distributor, and customer data
- CSV export for data backup
- Download CSV templates for easy data entry
- PDF export of dashboard reports with charts

### 👤 User Management
- User registration with pharmacy details
- Secure login with password hashing (BCrypt)
- Profile management with logo upload
- Multi-user support with data isolation

### 🎨 Modern UI
- Responsive Bootstrap-based design
- Clean and intuitive interface
- Custom theme with animations
- FontAwesome icons
- Mobile-friendly layout

## 🛠️ Technology Stack

- **Backend:** Java 17, Servlets, JSP
- **Build Tool:** Maven
- **Database:** MySQL 8.0
- **Server:** Apache Tomcat 8+
- **Frontend:** HTML5, CSS3, JavaScript (Vanilla)
- **UI Framework:** Bootstrap 5
- **Charts:** Chart.js
- **PDF Generation:** iText
- **JSON Processing:** Gson
- **Password Hashing:** BCrypt
- **JSTL:** Apache Taglibs

## 📁 Project Structure

```
PMS/
├── src/main/
│   ├── java/com/inventory/
│   │   ├── dao/              # Data Access Objects
│   │   ├── models/           # Entity Models
│   │   ├── servlet/          # Request Handlers
│   │   └── utils/            # Utility Classes
│   └── webapp/
│       ├── assets/           # CSS, JS, Images
│       ├── WEB-INF/          # Configuration
│       └── *.jsp             # View Pages
├── tables.sql                # Database Schema
└── pom.xml                   # Maven Configuration
```

## 🚀 Getting Started

### Prerequisites

- JDK 17 or higher
- Apache Maven 3.6+
- MySQL 8.0+
- Apache Tomcat 8+

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/Rahultawar/pms-web.git
cd pms-web
```

2. **Create database**
```bash
mysql -u root -p -e "CREATE DATABASE pms_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
mysql -u root -p pms_db < tables.sql
```

3. **Configure database connection**

Edit `src/main/java/com/inventory/utils/DBConnection.java`:
```java
private static final String URL = "jdbc:mysql://localhost:3306/pms_db";
private static final String USER = "root";
private static final String PASSWORD = "your_password";
```

4. **Build the project**
```bash
mvn clean package
```

5. **Deploy to Tomcat**
- Copy `target/PMS-1.0-SNAPSHOT.war` to `TOMCAT_HOME/webapps/`
- Rename to `PMS.war` (optional)
- Start Tomcat

6. **Access the application**
```
http://localhost:8080/PMS/
```

## 📱 Usage

### First Time Setup
1. Register a new account with your pharmacy details
2. Upload your pharmacy logo (optional)
3. Add distributors
4. Add products with batch information
5. Start processing sales

### Daily Operations
- Monitor dashboard for sales and inventory overview
- Check notifications for low stock and expiring products
- Process customer sales
- Update product quantities
- Generate reports

## 🗃️ Database Schema

The system uses 6 main tables:
- `user` - User accounts and pharmacy information
- `product` - Product inventory details
- `distributor` - Supplier information
- `customer` - Customer records
- `sale` - Sales transactions
- `user_notifications` - Notification tracking

## 🔐 Security Features

- Password hashing using BCrypt
- Session-based authentication
- SQL injection prevention using PreparedStatements
- User data isolation (multi-tenant)
- Input validation and sanitization

## 📝 API Endpoints

All servlets are mapped under `/`:
- `/LoginServlet` - User authentication
- `/RegistrationServlet` - User registration
- `/DashboardServlet` - Dashboard data
- `/ProductServlet` - Product CRUD
- `/SaleServlet` - Sales processing
- `/CustomerServlet` - Customer management
- `/DistributorServlet` - Distributor management
- `/NotificationServlet` - Notification management
- `/ImportExportServlet` - Data import/export
- `/ExportDashboardPdfServlet` - PDF reports
- `/ProfileServlet` - User profile management

## 🤝 Contributors

<table>
  <tr>
    <td align="center">
      <a href="https://github.com/Rahultawar">
        <img src="https://github.com/Rahultawar.png" width="100px;" alt="Rahul Tawar"/>
        <br />
        <sub><b>Rahul Tawar</b></sub>
      </a>
      <br />
      <sub>Project Lead & Developer</sub>
    </td>
    <td align="center">
      <a href="https://github.com/bhautik2004">
        <img src="https://github.com/bhautik2004.png" width="100px;" alt="Bhautik Thummar"/>
        <br />
        <sub><b>Bhautik Thummar</b></sub>
      </a>
      <br />
      <sub>Developer</sub>
    </td>
    <td align="center">
      <a href="https://github.com/nileshh0027">
        <img src="https://github.com/nileshh0027.png" width="100px;" alt="Nilesh Bagda"/>
        <br />
        <sub><b>Nilesh Bagda</b></sub>
      </a>
      <br />
      <sub>Developer</sub>
    </td>
  </tr>
</table>

### How to Contribute

We welcome contributions! Here's how you can help:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

Please ensure your code follows the existing code style and includes appropriate tests.

## 📧 Contact

Rahul Tawar - [@Rahultawar](https://github.com/Rahultawar)

Project Link: [https://github.com/Rahultawar/pms-web](https://github.com/Rahultawar/pms-web)

**Note:** Note: This is an educational project for learning Java Servlets and JSP. For production use, consider implementing additional security measures and thorough testing. If you would like me to build the project, please contact me.
