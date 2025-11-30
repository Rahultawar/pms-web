package com.inventory.dao;

import com.inventory.models.Sale;
import com.inventory.utils.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SaleDAO {

    // ADD SALE METHOD
    public Sale addSale(Sale sale) {
        String insertQuery = "INSERT INTO sale (customerId, userId, productId, distributorId, quantity, subQuantity, " +
                "paymentMethod, saleDate, discount, totalAmount, amountGivenByCustomer, status, createdAt) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(insertQuery,
                        Statement.RETURN_GENERATED_KEYS)) {

            // VALIDATE AND SET DEFAULTS
            if (sale.getQuantity() == null || sale.getQuantity() <= 0) {
                throw new IllegalArgumentException("Quantity must be >= 1");
            }
            if (sale.getDiscount() == null) {
                sale.setDiscount(BigDecimal.ZERO);
            }
            if (sale.getAmountGivenByCustomer() == null) {
                sale.setAmountGivenByCustomer(BigDecimal.ZERO);
            }
            if (sale.getTotalAmount() == null) {
                sale.setTotalAmount(BigDecimal.ZERO);
            }
            if (sale.getSaleDate() == null) {
                sale.setSaleDate(new Timestamp(System.currentTimeMillis()));
            }
            if (sale.getCreatedAt() == null) {
                sale.setCreatedAt(new Timestamp(System.currentTimeMillis()));
            }

            // DETERMINE STATUS BASED ON PAYMENT
            BigDecimal total = sale.getTotalAmount();
            BigDecimal given = sale.getAmountGivenByCustomer();
            sale.setStatus(given.compareTo(total) >= 0 ? Sale.SaleStatus.paid : Sale.SaleStatus.pending);

            // SET PARAMETERS
            statement.setObject(1, sale.getCustomerId());
            statement.setInt(2, sale.getUserId());
            statement.setInt(3, sale.getProductId());
            statement.setInt(4, sale.getDistributorId());
            statement.setInt(5, sale.getQuantity());
            statement.setObject(6, sale.getSubQuantity());
            statement.setString(7, sale.getPaymentMethod().name());
            statement.setTimestamp(8, sale.getSaleDate());
            statement.setBigDecimal(9, sale.getDiscount());
            statement.setBigDecimal(10, sale.getTotalAmount());
            statement.setBigDecimal(11, sale.getAmountGivenByCustomer());
            statement.setString(12, sale.getStatus().name());
            statement.setTimestamp(13, sale.getCreatedAt());

            int affectedRows = statement.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating sale failed, no rows affected.");
            }

            try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    sale.setSaleId(generatedKeys.getInt(1));
                } else {
                    throw new SQLException("Creating sale failed, no ID obtained.");
                }
            }

            return sale;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error adding sale: " + e.getMessage(), e);
        }
    }

    // GET ALL SALE METHOD
    public List<Sale> getAllSale() {
        List<Sale> saleList = new ArrayList<>();
        String query = "SELECT s.*, c.customerName, p.productName, d.distributorName " +
                "FROM sale s " +
                "LEFT JOIN customer c ON s.customerId = c.customerId " +
                "LEFT JOIN product p ON s.productId = p.productId " +
                "LEFT JOIN distributor d ON s.distributorId = d.distributorId " +
                "ORDER BY s.saleDate DESC";

        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(query);
                ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                saleList.add(mapResultSetToSale(resultSet));
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to get sales", e);
        }

        return saleList;
    }

    // GET SALE BY ID METHOD
    public Sale getSaleById(int saleId) {
        String query = "SELECT s.*, c.customerName, p.productName, d.distributorName " +
                "FROM sale s " +
                "LEFT JOIN customer c ON s.customerId = c.customerId " +
                "LEFT JOIN product p ON s.productId = p.productId " +
                "LEFT JOIN distributor d ON s.distributorId = d.distributorId " +
                "WHERE s.saleId = ?";

        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(query)) {

            statement.setInt(1, saleId);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapResultSetToSale(resultSet);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to get sale id: " + saleId, e);
        }

        return null;
    }

    // COUNT SALE METHOD
    public int countSale() {
        String query = "SELECT COUNT(*) FROM sale";

        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(query);
                ResultSet resultSet = statement.executeQuery()) {

            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to count sales", e);
        }

        return 0;
    }

    // SUM TODAY'S SALES AMOUNT BY USER ID
    public double getTodaySalesAmount(int userId) {
        String query = "SELECT COALESCE(SUM(amountGivenByCustomer), 0) " +
                "FROM sale " +
                "WHERE userId = ? " +
                "AND DATE(saleDate) = CURDATE()";

        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(query)) {

            statement.setInt(1, userId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getDouble(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to get today's sales amount", e);
        }

        return 0.0;
    }

    // SUM THIS MONTH'S SALES AMOUNT BY USER ID
    public double getMonthlySalesAmount(int userId) {
        String query = "SELECT COALESCE(SUM(amountGivenByCustomer), 0) " +
                "FROM sale " +
                "WHERE userId = ? " +
                "AND YEAR(saleDate) = YEAR(CURDATE()) " +
                "AND MONTH(saleDate) = MONTH(CURDATE())";

        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(query)) {

            statement.setInt(1, userId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getDouble(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to get monthly sales amount", e);
        }

        return 0.0;
    }

    // PAGINATION METHOD
    public List<Sale> getSalesPaginated(int offset, int limit) {
        List<Sale> saleList = new ArrayList<>();
        String query = "SELECT * FROM sale ORDER BY saleDate DESC LIMIT ? OFFSET ?";

        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(query)) {

            statement.setInt(1, limit);
            statement.setInt(2, offset);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    saleList.add(mapResultSetToSale(resultSet));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to get sales (paginated)", e);
        }

        return saleList;
    }

    // UPDATE SALE METHOD
    public Sale updateSale(Sale sale) {
        String updateQuery = "UPDATE sale SET productId = ?, distributorId = ?, customerId = ?, quantity = ?, " +
                "subQuantity = ?, discount = ?, totalAmount = ?, amountGivenByCustomer = ?, " +
                "paymentMethod = ?, status = ? WHERE saleId = ?";

        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(updateQuery)) {

            statement.setInt(1, sale.getProductId());
            statement.setInt(2, sale.getDistributorId());
            statement.setObject(3, sale.getCustomerId());
            statement.setInt(4, sale.getQuantity());
            statement.setObject(5, sale.getSubQuantity());
            statement.setBigDecimal(6, sale.getDiscount() != null ? sale.getDiscount() : BigDecimal.ZERO);
            statement.setBigDecimal(7, sale.getTotalAmount());
            statement.setBigDecimal(8,
                    sale.getAmountGivenByCustomer() != null ? sale.getAmountGivenByCustomer() : BigDecimal.ZERO);
            statement.setString(9, sale.getPaymentMethod().name());
            statement.setString(10, sale.getStatus().name());
            statement.setInt(11, sale.getSaleId());

            int affectedRows = statement.executeUpdate();
            if (affectedRows == 0) {
                throw new RuntimeException("Sale not found: " + sale.getSaleId());
            }

            return getSaleById(sale.getSaleId());
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error updating sale: " + e.getMessage(), e);
        }
    }

    // DELETE SALE METHOD
    public boolean deleteSale(Integer saleId) {
        String deleteQuery = "DELETE FROM sale WHERE saleId = ?";

        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(deleteQuery)) {

            statement.setInt(1, saleId);
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error deleting sale: " + e.getMessage(), e);
        }
    }

    // GET SALES BY USER ID WITH PAGINATION
    public List<Sale> getSalesByUserId(int userId, int page, int recordsPerPage) {
        List<Sale> saleList = new ArrayList<>();
        int offset = (page - 1) * recordsPerPage;
        String query = "SELECT s.*, c.customerName, p.productName, d.distributorName " +
                "FROM sale s " +
                "LEFT JOIN customer c ON s.customerId = c.customerId " +
                "LEFT JOIN product p ON s.productId = p.productId " +
                "LEFT JOIN distributor d ON s.distributorId = d.distributorId " +
                "WHERE s.userId = ? ORDER BY s.saleId DESC LIMIT ? OFFSET ?";

        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(query)) {

            statement.setInt(1, userId);
            statement.setInt(2, recordsPerPage);
            statement.setInt(3, offset);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    saleList.add(mapResultSetToSale(resultSet));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error fetching sales by userId: " + e.getMessage(), e);
        }

        return saleList;
    }

    // GET TOTAL SALES COUNT BY USER ID
    public int getTotalSalesByUserId(int userId) {
        String query = "SELECT COUNT(*) FROM sale WHERE userId = ?";

        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(query)) {

            statement.setInt(1, userId);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error counting sales: " + e.getMessage(), e);
        }

        return 0;
    }

    // HELPER METHOD - MAP RESULTSET TO SALE OBJECT
    private Sale mapResultSetToSale(ResultSet resultSet) throws SQLException {
        Sale sale = new Sale();
        sale.setSaleId(resultSet.getInt("saleId"));
        sale.setCustomerId(resultSet.getObject("customerId", Integer.class));
        sale.setUserId(resultSet.getInt("userId"));
        sale.setProductId(resultSet.getInt("productId"));
        sale.setDistributorId(resultSet.getInt("distributorId"));
        sale.setQuantity(resultSet.getInt("quantity"));
        sale.setSubQuantity(resultSet.getObject("subQuantity", Integer.class));
        sale.setSaleDate(resultSet.getTimestamp("saleDate"));
        sale.setDiscount(resultSet.getBigDecimal("discount"));
        sale.setTotalAmount(resultSet.getBigDecimal("totalAmount"));
        sale.setAmountGivenByCustomer(resultSet.getBigDecimal("amountGivenByCustomer"));

        // HANDLE PAYMENTMETHOD ENUM (UPPERCASE)
        String paymentMethodStr = resultSet.getString("paymentMethod");
        try {
            sale.setPaymentMethod(Sale.PaymentMethod.valueOf(paymentMethodStr.toUpperCase()));
        } catch (IllegalArgumentException e) {
            sale.setPaymentMethod(Sale.PaymentMethod.CASH); // DEFAULT TO CASH
        }

        // HANDLE SALESTATUS ENUM (LOWERCASE) - SUPPORTS BOTH OLD UPPERCASE AND NEW
        // LOWERCASE DATA
        String statusStr = resultSet.getString("status");
        try {
            sale.setStatus(Sale.SaleStatus.valueOf(statusStr.toLowerCase()));
        } catch (IllegalArgumentException e) {
            sale.setStatus(Sale.SaleStatus.pending); // DEFAULT TO PENDING
        }

        sale.setCreatedAt(resultSet.getTimestamp("createdAt"));

        // SET DISPLAY NAMES (IF AVAILABLE FROM JOINS)
        try {
            sale.setCustomerName(resultSet.getString("customerName"));
        } catch (SQLException e) {
            sale.setCustomerName(null); // COLUMN NOT IN RESULT SET
        }

        try {
            sale.setProductName(resultSet.getString("productName"));
        } catch (SQLException e) {
            sale.setProductName(null);
        }

        try {
            sale.setDistributorName(resultSet.getString("distributorName"));
        } catch (SQLException e) {
            sale.setDistributorName(null);
        }

        return sale;
    }
}