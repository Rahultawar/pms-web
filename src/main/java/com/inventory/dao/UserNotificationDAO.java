package com.inventory.dao;

import com.inventory.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UserNotificationDAO {

    // MARK A NOTIFICATION AS READ (Insert or update)
    public void markAsRead(int userId, int productId, String notificationType) {
        String insertQuery = "INSERT INTO user_notifications (userId, productId, notificationType, isRead) " +
                           "VALUES (?, ?, ?, 1) ON DUPLICATE KEY UPDATE isRead = 1";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(insertQuery)) {

            statement.setInt(1, userId);
            statement.setInt(2, productId);
            statement.setString(3, notificationType);

            statement.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error marking notification as read: " + e.getMessage(), e);
        }
    }

    // MARK ALL NOTIFICATIONS OF A TYPE AS READ FOR A USER
    public void markAllAsRead(int userId, String notificationType) {
        String query = "INSERT INTO user_notifications (userId, productId, notificationType, isRead) " +
                      "SELECT ?, p.productId, ?, 1 FROM product p WHERE p.userId = ? AND " +
                      (notificationType.equals("low_stock") ?
                      "p.quantity <= p.reorderLevel AND p.reorderLevel > 0" :
                      "p.expiryDate IS NOT NULL AND p.expiryDate <= DATE_ADD(CURDATE(), INTERVAL 30 DAY) AND p.expiryDate >= CURDATE()") +
                      " ON DUPLICATE KEY UPDATE isRead = 1";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {

            statement.setInt(1, userId);
            statement.setString(2, notificationType);
            statement.setInt(3, userId);

            statement.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error marking all notifications as read: " + e.getMessage(), e);
        }
    }

    // MARK ALL NOTIFICATIONS AS READ FOR A USER
    public void markAllAsRead(int userId) {
        markAllAsRead(userId, "low_stock");
        markAllAsRead(userId, "expiry");
    }

    // GET ALL READ NOTIFICATION IDs FOR A USER AND TYPE
    public List<Integer> getReadNotificationIds(int userId, String notificationType) {
        List<Integer> readIds = new ArrayList<>();

        String query = "SELECT productId FROM user_notifications WHERE userId = ? AND notificationType = ? AND isRead = 1";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {

            statement.setInt(1, userId);
            statement.setString(2, notificationType);

            ResultSet resultSet = statement.executeQuery();
            while (resultSet.next()) {
                readIds.add(resultSet.getInt("productId"));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching read notification IDs: " + e.getMessage(), e);
        }
        return readIds;
    }

    // CLEAR ALL READ NOTIFICATIONS FOR A USER
    public void clearAllReadNotifications(int userId) {
        String query = "DELETE FROM user_notifications WHERE userId = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {

            statement.setInt(1, userId);
            statement.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error clearing read notifications: " + e.getMessage(), e);
        }
    }

    // GET UNREAD NOTIFICATION COUNT FOR A USER
    public int getUnreadNotificationCount(int userId) {
        try {
            ProductDAO productDAO = new ProductDAO();

            // Get total notification counts
            int totalLowStock = productDAO.getLowStockProducts(userId).size();
            int totalExpiry = productDAO.getExpiringProducts(userId).size();

            // Get read notification counts
            int readLowStockCount = getReadNotificationIds(userId, "low_stock").size();
            int readExpiryCount = getReadNotificationIds(userId, "expiry").size();

            // Unread count = total - read
            int unreadCount = (totalLowStock - readLowStockCount) + (totalExpiry - readExpiryCount);
            return Math.max(0, unreadCount); // Ensure non-negative
        } catch (Exception e) {
            throw new RuntimeException("Error getting unread notification count: " + e.getMessage(), e);
        }
    }
}
