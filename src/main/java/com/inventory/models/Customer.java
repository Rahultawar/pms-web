package com.inventory.models;

public class Customer {

    // PROPERTIES
    private int customerId, userId;
    private String customerName, contactNumber;
    private java.sql.Timestamp createdAt;

    public Customer() {
    }

    // CONSTRUCTOR
    public Customer(int customerId, String customerName, String contactNumber, int userId, java.sql.Timestamp createdAt) {
        this.customerId = customerId;
        this.customerName = customerName;
        this.contactNumber = contactNumber;
        this.userId = userId;
        this.createdAt = createdAt;
    }

    // GETTERS AND SETTERS
    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getContactNumber() {
        return contactNumber;
    }

    public void setContactNumber(String contactNumber) {
        this.contactNumber = contactNumber;
    }

    public java.sql.Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(java.sql.Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
