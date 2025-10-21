package com.inventory.models;

import java.math.BigDecimal;

public class Product {

    // PROPERTIES
    private int productId, quantity, subQuantity, distributorId, userId, reorderLevel;
    private String productName, category, manufacturer, batchNumber, strength, unit, location;
    private java.sql.Date manufacturingDate, expiryDate;
    private BigDecimal purchasingPrice, sellingPrice;
    private java.sql.Timestamp createdAt;

    public Product() {
    }

    // CONSTRUCTOR
    public Product(int productId, String productName, int distributorId, Integer userId, int quantity, Integer subQuantity,
            String unit, String location, String strength, String category, String manufacturer,
            java.sql.Date manufacturingDate, java.sql.Date expiryDate, BigDecimal purchasingPrice,
            String batchNumber, BigDecimal sellingPrice, Integer reorderLevel, java.sql.Timestamp createdAt) {

        this.productId = productId;
        this.productName = productName;
        this.distributorId = distributorId;
        this.userId = userId != null ? userId : 0;
        this.quantity = quantity;
        this.subQuantity = subQuantity != null ? subQuantity : 0;
        this.unit = unit;
        this.location = location;
        this.strength = strength;
        this.category = category;
        this.manufacturer = manufacturer;
        this.manufacturingDate = manufacturingDate;
        this.expiryDate = expiryDate;
        this.purchasingPrice = purchasingPrice;
        this.batchNumber = batchNumber;
        this.sellingPrice = sellingPrice;
        this.reorderLevel = reorderLevel != null ? reorderLevel : 0;
        this.createdAt = createdAt;
    }

    // GETTERS AND SETTERS
    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getManufacturer() {
        return manufacturer;
    }

    public void setManufacturer(String manufacturer) {
        this.manufacturer = manufacturer;
    }

    public String getBatchNumber() {
        return batchNumber;
    }

    public void setBatchNumber(String batchNumber) {
        this.batchNumber = batchNumber;
    }

    public String getStrength() {
        return strength;
    }

    public void setStrength(String strength) {
        this.strength = strength;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public java.sql.Date getManufacturingDate() {
        return manufacturingDate;
    }

    public void setManufacturingDate(java.sql.Date manufacturingDate) {
        this.manufacturingDate = manufacturingDate;
    }

    public java.sql.Date getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(java.sql.Date expiryDate) {
        this.expiryDate = expiryDate;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public int getSubQuantity() {
        return subQuantity;
    }

    public void setSubQuantity(int subQuantity) {
        this.subQuantity = subQuantity;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getReorderLevel() {
        return reorderLevel;
    }

    public void setReorderLevel(int reorderLevel) {
        this.reorderLevel = reorderLevel;
    }

    public BigDecimal getPurchasingPrice() {
        return purchasingPrice;
    }

    public void setPurchasingPrice(BigDecimal purchasingPrice) {
        this.purchasingPrice = purchasingPrice;
    }

    public BigDecimal getSellingPrice() {
        return sellingPrice;
    }

    public void setSellingPrice(BigDecimal sellingPrice) {
        this.sellingPrice = sellingPrice;
    }

    public int getDistributorId() {
        return distributorId;
    }

    public void setDistributorId(int distributorId) {
        this.distributorId = distributorId;
    }

    public java.sql.Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(java.sql.Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
