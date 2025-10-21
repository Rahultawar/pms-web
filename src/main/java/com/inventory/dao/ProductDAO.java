package com.inventory.dao;

import com.inventory.models.Product;
import com.inventory.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    // GET ALL PRODUCT METHOD
    public List<Product> getAllProduct() {
        List<Product> productList = new ArrayList<>();

        String query = "SELECT * FROM product";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                Product product = new Product();
                product.setProductId(resultSet.getInt("productId"));
                product.setProductName(resultSet.getString("productName"));
                product.setCategory(resultSet.getString("category"));
                product.setManufacturer(resultSet.getString("manufacturer"));
                product.setBatchNumber(resultSet.getString("batchNumber"));
                product.setStrength(resultSet.getString("strength"));
                product.setUnit(resultSet.getString("unit"));
                product.setStripType(resultSet.getString("stripType"));
                product.setUnitsPerStrip(resultSet.getInt("unitsPerStrip"));
                product.setShelfLocation(resultSet.getString("shelfLocation"));
                product.setManufacturingDate(resultSet.getDate("manufacturingDate"));
                product.setExpiryDate(resultSet.getDate("expiryDate"));
                product.setQuantityInStock(resultSet.getInt("quantityInStock"));
                product.setPurchasePrice(resultSet.getBigDecimal("purchasePrice"));
                product.setSellingPrice(resultSet.getBigDecimal("sellingPrice"));
                product.setDistributorId(resultSet.getInt("distributorId"));
                product.setReorderLevel(resultSet.getInt("reorderLevel"));
                product.setCreatedAt(resultSet.getTimestamp("createdAt"));
                product.setUpdatedAt(resultSet.getTimestamp("updatedAt"));
                productList.add(product);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return productList;
    }

    // ADD PRODUCT METHOD
    public void addProduct(Product product) {
        String query = "INSERT INTO product (productName, category, manufacturer, batchNumber, strength, unit, " +
                "stripType, unitsPerStrip, shelfLocation, manufacturingDate, expiryDate, quantityInStock, " +
                "purchasePrice, sellingPrice, distributorId, reorderLevel, createdAt, updatedAt) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {

            Timestamp now = new Timestamp(System.currentTimeMillis());

            statement.setString(1, product.getProductName());
            statement.setString(2, product.getCategory());
            statement.setString(3, product.getManufacturer());
            statement.setString(4, product.getBatchNumber());
            statement.setString(5, product.getStrength());
            statement.setString(6, product.getUnit());
            if (product.getStripType() != null) {
                statement.setString(7, product.getStripType());
            } else {
                statement.setNull(7, Types.VARCHAR);
            }
            if (product.getUnitsPerStrip() > 0) {
                statement.setInt(8, product.getUnitsPerStrip());
            } else {
                statement.setNull(8, Types.INTEGER);
            }
            statement.setString(9, product.getShelfLocation());
            statement.setDate(10, new java.sql.Date(product.getManufacturingDate().getTime()));
            statement.setDate(11, new java.sql.Date(product.getExpiryDate().getTime()));
            statement.setInt(12, product.getQuantityInStock());
            statement.setBigDecimal(13, product.getPurchasePrice());
            statement.setBigDecimal(14, product.getSellingPrice());
            if (product.getDistributorId() > 0) {
                statement.setInt(15, product.getDistributorId());
            } else {
                statement.setNull(15, Types.INTEGER);
            }
            statement.setInt(16, product.getReorderLevel());
            statement.setTimestamp(17, now);
            statement.setTimestamp(18, now);

            statement.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    // DELETE PRODUCT BY ID METHOD
    public int deleteProduct(int productId) {
        String query = "DELETE FROM product WHERE productId = ?";
        int result = 0;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setInt(1, productId);
            result = statement.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return result;
    }

    // UPDATE PRODUCT METHOD
    public int updateProduct(Product product) {
        int result = 0;
        String query = "UPDATE product SET productName = ?, category = ?, manufacturer = ?, batchNumber = ?, " +
                "strength = ?, unit = ?, stripType = ?, unitsPerStrip = ?, shelfLocation = ?, manufacturingDate = ?, expiryDate = ?, quantityInStock = ?, " +
                "purchasePrice = ?, sellingPrice = ?, distributorId = ?, reorderLevel = ?, updatedAt = ? WHERE productId = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {

            Timestamp now = new Timestamp(System.currentTimeMillis());

            statement.setString(1, product.getProductName());
            statement.setString(2, product.getCategory());
            statement.setString(3, product.getManufacturer());
            statement.setString(4, product.getBatchNumber());
            statement.setString(5, product.getStrength());
            statement.setString(6, product.getUnit());
            if (product.getStripType() != null) {
                statement.setString(7, product.getStripType());
            } else {
                statement.setNull(7, Types.VARCHAR);
            }
            if (product.getUnitsPerStrip() > 0) {
                statement.setInt(8, product.getUnitsPerStrip());
            } else {
                statement.setNull(8, Types.INTEGER);
            }
            statement.setString(9, product.getShelfLocation());
            statement.setDate(10, new java.sql.Date(product.getManufacturingDate().getTime()));
            statement.setDate(11, new java.sql.Date(product.getExpiryDate().getTime()));
            statement.setInt(12, product.getQuantityInStock());
            statement.setBigDecimal(13, product.getPurchasePrice());
            statement.setBigDecimal(14, product.getSellingPrice());
            if (product.getDistributorId() > 0) {
                statement.setInt(15, product.getDistributorId());
            } else {
                statement.setNull(15, Types.INTEGER);
            }
            statement.setInt(16, product.getReorderLevel());
            statement.setTimestamp(17, now);
            statement.setInt(18, product.getProductId());

            result = statement.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return result;
    }

    // GET PRODUCT BY ID
    public Product getProductById(int productId) {
        Product product = null;

        String query = "SELECT * FROM product WHERE productId = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {

            statement.setInt(1, productId);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                product = new Product();
                product.setProductId(resultSet.getInt("productId"));
                product.setProductName(resultSet.getString("productName"));
                product.setCategory(resultSet.getString("category"));
                product.setManufacturer(resultSet.getString("manufacturer"));
                product.setBatchNumber(resultSet.getString("batchNumber"));
                product.setStrength(resultSet.getString("strength"));
                product.setUnit(resultSet.getString("unit"));
                product.setShelfLocation(resultSet.getString("shelfLocation"));
                product.setManufacturingDate(resultSet.getDate("manufacturingDate"));
                product.setExpiryDate(resultSet.getDate("expiryDate"));
                product.setQuantityInStock(resultSet.getInt("quantityInStock"));
                product.setPurchasePrice(resultSet.getBigDecimal("purchasePrice"));
                product.setSellingPrice(resultSet.getBigDecimal("sellingPrice"));
                product.setDistributorId(resultSet.getInt("distributorId"));
                product.setReorderLevel(resultSet.getInt("reorderLevel"));
                product.setCreatedAt(resultSet.getTimestamp("createdAt"));
                product.setUpdatedAt(resultSet.getTimestamp("updatedAt"));
                product.setStripType(resultSet.getString("stripType"));
                product.setUnitsPerStrip(resultSet.getInt("unitsPerStrip"));

            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return product;
    }

    //COUNT PRODUCT
    public int countProduct() {
        int records = 0;
        String query = "SELECT COUNT(productId) AS total FROM product";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query);
             ResultSet resultSet = statement.executeQuery()) {
            if (resultSet.next()) {
                records = resultSet.getInt("total");
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return records;
    }

    // Get Products with Pagination
    public List<Product> getProductsPaginated(int offset, int noOfRecords) {
        List<Product> list = new ArrayList<>();
        String query = "SELECT * FROM product LIMIT ? OFFSET ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, noOfRecords);
            ps.setInt(2, offset);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product product = new Product();
                product.setProductId(rs.getInt("productId"));
                product.setProductName(rs.getString("productName"));
                product.setCategory(rs.getString("category"));
                product.setManufacturingDate(rs.getDate("manufacturingDate"));
                product.setExpiryDate(rs.getDate("expiryDate"));
                product.setQuantityInStock(rs.getInt("quantityInStock"));
                product.setSellingPrice(rs.getBigDecimal("sellingPrice"));
                list.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // DEDUCT PRODUCT QUANTITY WHEN SALE IS MADE
    public boolean deductProductQuantity(int productId, int quantityToDeduct) {
        String query = "UPDATE product SET quantityInStock = quantityInStock - ?, updatedAt = ? WHERE productId = ? AND quantityInStock >= ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {
            
            Timestamp now = new Timestamp(System.currentTimeMillis());
            statement.setInt(1, quantityToDeduct);
            statement.setTimestamp(2, now);
            statement.setInt(3, productId);
            statement.setInt(4, quantityToDeduct);
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error deducting product quantity: " + e.getMessage(), e);
        }
    }

    // ADD PRODUCT QUANTITY (FOR RESTOCKING OR SALE REVERSAL)
    public boolean addProductQuantity(int productId, int quantityToAdd) {
        String query = "UPDATE product SET quantityInStock = quantityInStock + ?, updatedAt = ? WHERE productId = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {
            
            Timestamp now = new Timestamp(System.currentTimeMillis());
            statement.setInt(1, quantityToAdd);
            statement.setTimestamp(2, now);
            statement.setInt(3, productId);
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error adding product quantity: " + e.getMessage(), e);
        }
    }
}
