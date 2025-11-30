package com.inventory.dao;

import com.inventory.models.Product;
import com.inventory.utils.DBConnection;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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
                product.setDistributorId(resultSet.getInt("distributorId"));
                product.setUserId(resultSet.getInt("userId"));
                product.setQuantity(resultSet.getInt("quantity"));
                product.setSubQuantity(resultSet.getInt("subQuantity"));
                product.setUnit(resultSet.getString("unit"));
                product.setLocation(resultSet.getString("location"));
                product.setStrength(resultSet.getString("strength"));
                product.setCategory(resultSet.getString("category"));
                product.setManufacturer(resultSet.getString("manufacturer"));
                product.setManufacturingDate(resultSet.getDate("manufacturingDate"));
                product.setExpiryDate(resultSet.getDate("expiryDate"));
                product.setPurchasingPrice(resultSet.getBigDecimal("purchasingPrice"));
                product.setBatchNumber(resultSet.getString("batchNumber"));
                product.setSellingPrice(resultSet.getBigDecimal("sellingPrice"));
                product.setReorderLevel(resultSet.getInt("reorderLevel"));
                product.setCreatedAt(resultSet.getTimestamp("createdAt"));

                // ADD PRODUCT TO LIST
                productList.add(product);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return productList;
    }

    public List<Product> getProductsByUserId(int userId) {
        List<Product> productList = new ArrayList<>();
        String query = "SELECT * FROM product WHERE userId = ? ORDER BY productName ASC";

        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(query)) {

            statement.setInt(1, userId);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    Product product = new Product();
                    product.setProductId(resultSet.getInt("productId"));
                    product.setProductName(resultSet.getString("productName"));
                    product.setDistributorId(resultSet.getInt("distributorId"));
                    product.setUserId(resultSet.getInt("userId"));
                    product.setQuantity(resultSet.getInt("quantity"));
                    product.setSubQuantity(resultSet.getInt("subQuantity"));
                    product.setUnit(resultSet.getString("unit"));
                    product.setLocation(resultSet.getString("location"));
                    product.setStrength(resultSet.getString("strength"));
                    product.setCategory(resultSet.getString("category"));
                    product.setManufacturer(resultSet.getString("manufacturer"));
                    product.setManufacturingDate(resultSet.getDate("manufacturingDate"));
                    product.setExpiryDate(resultSet.getDate("expiryDate"));
                    product.setPurchasingPrice(resultSet.getBigDecimal("purchasingPrice"));
                    product.setBatchNumber(resultSet.getString("batchNumber"));
                    product.setSellingPrice(resultSet.getBigDecimal("sellingPrice"));
                    product.setReorderLevel(resultSet.getInt("reorderLevel"));
                    product.setCreatedAt(resultSet.getTimestamp("createdAt"));

                    productList.add(product);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error fetching products by userId: " + e.getMessage(), e);
        }

        return productList;
    }

    // GET PRODUCT BY ID AND USER ID (FOR SECURITY)
    public Product getProductByIdAndUserId(int productId, int userId) {
        Product product = null;
        String query = "SELECT * FROM product WHERE productId = ? AND userId = ?";

        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(query)) {

            statement.setInt(1, productId);
            statement.setInt(2, userId);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    product = new Product();
                    product.setProductId(resultSet.getInt("productId"));
                    product.setProductName(resultSet.getString("productName"));
                    product.setDistributorId(resultSet.getInt("distributorId"));
                    product.setUserId(resultSet.getInt("userId"));
                    product.setQuantity(resultSet.getInt("quantity"));
                    product.setSubQuantity(resultSet.getInt("subQuantity"));
                    product.setUnit(resultSet.getString("unit"));
                    product.setLocation(resultSet.getString("location"));
                    product.setStrength(resultSet.getString("strength"));
                    product.setCategory(resultSet.getString("category"));
                    product.setManufacturer(resultSet.getString("manufacturer"));
                    product.setManufacturingDate(resultSet.getDate("manufacturingDate"));
                    product.setExpiryDate(resultSet.getDate("expiryDate"));
                    product.setPurchasingPrice(resultSet.getBigDecimal("purchasingPrice"));
                    product.setBatchNumber(resultSet.getString("batchNumber"));
                    product.setSellingPrice(resultSet.getBigDecimal("sellingPrice"));
                    product.setReorderLevel(resultSet.getInt("reorderLevel"));
                    product.setCreatedAt(resultSet.getTimestamp("createdAt"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error fetching product by ID and userId: " + e.getMessage(), e);
        }

        return product;
    }

    // ADD PRODUCT METHOD
    public void addProduct(Product product) {
        String query = "INSERT INTO product (productName, distributorId, userId, quantity, subQuantity, unit, location, "
                +
                "strength, category, manufacturer, manufacturingDate, expiryDate, purchasingPrice, batchNumber, " +
                "sellingPrice, reorderLevel) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(query)) {

            statement.setString(1, product.getProductName());
            statement.setInt(2, product.getDistributorId());
            if (product.getUserId() > 0) {
                statement.setInt(3, product.getUserId());
            } else {
                statement.setNull(3, java.sql.Types.INTEGER);
            }
            statement.setInt(4, product.getQuantity());
            if (product.getSubQuantity() > 0) {
                statement.setInt(5, product.getSubQuantity());
            } else {
                statement.setNull(5, java.sql.Types.INTEGER);
            }
            statement.setString(6, product.getUnit());
            statement.setString(7, product.getLocation());
            statement.setString(8, product.getStrength());
            statement.setString(9, product.getCategory());
            statement.setString(10, product.getManufacturer());
            statement.setDate(11, new java.sql.Date(product.getManufacturingDate().getTime()));
            statement.setDate(12, new java.sql.Date(product.getExpiryDate().getTime()));
            statement.setBigDecimal(13, product.getPurchasingPrice());
            statement.setString(14, product.getBatchNumber());
            statement.setBigDecimal(15, product.getSellingPrice());
            statement.setInt(16, product.getReorderLevel());

            statement.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    // DELETE PRODUCT BY ID METHOD - WITH USER VERIFICATION
    public void deleteProduct(int productId, int userId) {
        String query = "DELETE FROM product WHERE productId = ? AND userId = ?";
        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setInt(1, productId);
            statement.setInt(2, userId);
            statement.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    // GET SELLING PRICE BY PRODUCT ID
    public static BigDecimal getSellingPriceById(int productId) {
        BigDecimal sellingPrice = null;
        String query = "SELECT sellingPrice FROM product WHERE productId = ?";
        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setInt(1, productId);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                sellingPrice = resultSet.getBigDecimal("sellingPrice");
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return sellingPrice;
    }

    // UPDATE PRODUCT METHOD - WITH USER VERIFICATION
    public int updateProduct(Product product) {
        int result = 0;
        String query = "UPDATE product SET productName = ?, distributorId = ?, userId = ?, quantity = ?, " +
                "subQuantity = ?, unit = ?, location = ?, strength = ?, category = ?, manufacturer = ?, " +
                "manufacturingDate = ?, expiryDate = ?, purchasingPrice = ?, batchNumber = ?, " +
                "sellingPrice = ?, reorderLevel = ? WHERE productId = ? AND userId = ?";

        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(query)) {

            statement.setString(1, product.getProductName());
            statement.setInt(2, product.getDistributorId());
            if (product.getUserId() > 0) {
                statement.setInt(3, product.getUserId());
            } else {
                statement.setNull(3, java.sql.Types.INTEGER);
            }
            statement.setInt(4, product.getQuantity());
            if (product.getSubQuantity() > 0) {
                statement.setInt(5, product.getSubQuantity());
            } else {
                statement.setNull(5, java.sql.Types.INTEGER);
            }
            statement.setString(6, product.getUnit());
            statement.setString(7, product.getLocation());
            statement.setString(8, product.getStrength());
            statement.setString(9, product.getCategory());
            statement.setString(10, product.getManufacturer());
            statement.setDate(11, new java.sql.Date(product.getManufacturingDate().getTime()));
            statement.setDate(12, new java.sql.Date(product.getExpiryDate().getTime()));
            statement.setBigDecimal(13, product.getPurchasingPrice());
            statement.setString(14, product.getBatchNumber());
            statement.setBigDecimal(15, product.getSellingPrice());
            statement.setInt(16, product.getReorderLevel());
            statement.setInt(17, product.getProductId());
            statement.setInt(18, product.getUserId()); // Verify ownership

            result = statement.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return result;
    }

    // COUNT PRODUCT
    public int countProduct(int userId) {
        int records = 0;
        String query = "SELECT COUNT(productId) AS total FROM product WHERE userId = ?";
        try (Connection connection = DBConnection.getConnection();
                PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    records = rs.getInt("total");
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return records;
    }

    // PAGINATION METHOD - Filter by userId
    public List<Product> getProductsPaginated(int offset, int noOfRecords, int userId) {
        List<Product> list = new ArrayList<>();
        String query = "SELECT * FROM product WHERE userId = ? LIMIT ? OFFSET ?";

        try (Connection connection = DBConnection.getConnection();
                PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, userId);
            ps.setInt(2, noOfRecords);
            ps.setInt(3, offset);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product product = new Product();
                product.setProductId(rs.getInt("productId"));
                product.setProductName(rs.getString("productName"));
                product.setCategory(rs.getString("category"));
                product.setManufacturingDate(rs.getDate("manufacturingDate"));
                product.setExpiryDate(rs.getDate("expiryDate"));
                product.setQuantity(rs.getInt("quantity"));
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
        String query = "UPDATE product SET quantity = quantity - ? WHERE productId = ? AND quantity >= ?";
        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(query)) {

            statement.setInt(1, quantityToDeduct);
            statement.setInt(2, productId);
            statement.setInt(3, quantityToDeduct);

            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error deducting product quantity: " + e.getMessage(), e);
        }
    }

    // GET PRODUCTS WITH LOW STOCK (QUANTITY <= REORDER LEVEL) - WITH USER VERIFICATION
    public List<Product> getLowStockProducts(int userId) {
        List<Product> lowStockProducts = new ArrayList<>();

        String query = "SELECT * FROM product WHERE userId = ? AND quantity <= reorderLevel AND reorderLevel > 0";
        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(query)) {

            statement.setInt(1, userId);
            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                Product product = new Product();
                product.setProductId(resultSet.getInt("productId"));
                product.setProductName(resultSet.getString("productName"));
                product.setQuantity(resultSet.getInt("quantity"));
                product.setReorderLevel(resultSet.getInt("reorderLevel"));
                product.setCategory(resultSet.getString("category"));
                product.setBatchNumber(resultSet.getString("batchNumber"));

                lowStockProducts.add(product);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching low stock products: " + e.getMessage(), e);
        }
        return lowStockProducts;
    }

    // GET PRODUCTS WITH EXPIRY DATE NEAR (WITHIN 30 DAYS) - WITH USER VERIFICATION
    public List<Product> getExpiringProducts(int userId) {
        List<Product> expiringProducts = new ArrayList<>();

        String query = "SELECT * FROM product WHERE userId = ? AND expiryDate IS NOT NULL AND expiryDate <= DATE_ADD(CURDATE(), INTERVAL 30 DAY) AND expiryDate >= CURDATE()";
        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(query)) {

            statement.setInt(1, userId);
            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                Product product = new Product();
                product.setProductId(resultSet.getInt("productId"));
                product.setProductName(resultSet.getString("productName"));
                product.setExpiryDate(resultSet.getDate("expiryDate"));
                product.setQuantity(resultSet.getInt("quantity"));
                product.setCategory(resultSet.getString("category"));
                product.setBatchNumber(resultSet.getString("batchNumber"));

                expiringProducts.add(product);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching expiring products: " + e.getMessage(), e);
        }
        return expiringProducts;
    }

    // GET PRODUCT CATEGORY DISTRIBUTION
    public java.util.Map<String, Integer> getProductCategoryDistribution(int userId) {
        java.util.Map<String, Integer> categoryData = new java.util.LinkedHashMap<>();
        String query = "SELECT category, COUNT(*) as count " +
                "FROM product " +
                "WHERE userId = ? " +
                "GROUP BY category " +
                "ORDER BY count DESC " +
                "LIMIT 10";

        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(query)) {

            statement.setInt(1, userId);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    String category = resultSet.getString("category");
                    if (category != null && !category.trim().isEmpty()) {
                        categoryData.put(category, resultSet.getInt("count"));
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return categoryData;
    }
}
