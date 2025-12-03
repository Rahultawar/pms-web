package com.inventory.models;

public class UserNotification {

    // PROPERTIES
    private int notificationId, userId, productId;
    private String notificationType;
    private boolean isRead;
    private java.sql.Timestamp createdAt;

    public UserNotification() {
    }

    // CONSTRUCTOR
    public UserNotification(int notificationId, int userId, int productId, String notificationType, boolean isRead, java.sql.Timestamp createdAt) {
        this.notificationId = notificationId;
        this.userId = userId;
        this.productId = productId;
        this.notificationType = notificationType;
        this.isRead = isRead;
        this.createdAt = createdAt;
    }

    // GETTERS AND SETTERS
    public int getNotificationId() {
        return notificationId;
    }

    public void setNotificationId(int notificationId) {
        this.notificationId = notificationId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getNotificationType() {
        return notificationType;
    }

    public void setNotificationType(String notificationType) {
        this.notificationType = notificationType;
    }

    public boolean isRead() {
        return isRead;
    }

    public void setRead(boolean isRead) {
        this.isRead = isRead;
    }

    public java.sql.Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(java.sql.Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
