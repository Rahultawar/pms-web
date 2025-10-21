package com.inventory.models;

import java.math.BigDecimal;

public class Product {
    private int productId, quantityInStock, distributorId, reorderLevel, unitsPerStrip;
    private String productName, category, manufacturer, batchNumber, strength, unit, shelfLocation, stripType;
    private java.sql.Date manufacturingDate, expiryDate;
    private BigDecimal purchasePrice, sellingPrice;
    private java.sql.Timestamp createdAt, updatedAt;

    public Product() {
    }

    public Product(int productId, String productName, String category, String manufacturer, String batchNumber,
                   String strength, String unit, String shelfLocation,
                   java.sql.Date manufacturingDate, java.sql.Date expiryDate,
                   int quantityInStock, int reorderLevel,
                   BigDecimal purchasePrice, BigDecimal sellingPrice,
                   int distributorId,
                   java.sql.Timestamp createdAt, java.sql.Timestamp updatedAt) {

        this.productId = productId;
        this.productName = productName;
        this.category = category;
        this.manufacturer = manufacturer;
        this.batchNumber = batchNumber;
        this.strength = strength;
        this.unit = unit;
        this.shelfLocation = shelfLocation;
        this.manufacturingDate = manufacturingDate;
        this.expiryDate = expiryDate;
        this.quantityInStock = quantityInStock;
        this.reorderLevel = reorderLevel;
        this.purchasePrice = purchasePrice;
        this.sellingPrice = sellingPrice;
        this.distributorId = distributorId;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public String getStripType() {
        return stripType;
    }

    public void setStripType(String stripType) {
        this.stripType = stripType;
    }

    public int getUnitsPerStrip() {
        return unitsPerStrip;
    }

    public void setUnitsPerStrip(int unitsPerStrip) {
        this.unitsPerStrip = unitsPerStrip;
    }

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

    public String getShelfLocation() {
        return shelfLocation;
    }

    public void setShelfLocation(String shelfLocation) {
        this.shelfLocation = shelfLocation;
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

    public int getQuantityInStock() {
        return quantityInStock;
    }

    public void setQuantityInStock(int quantityInStock) {
        this.quantityInStock = quantityInStock;
    }

    public int getReorderLevel() {
        return reorderLevel;
    }

    public void setReorderLevel(int reorderLevel) {
        this.reorderLevel = reorderLevel;
    }

    public BigDecimal getPurchasePrice() {
        return purchasePrice;
    }

    public void setPurchasePrice(BigDecimal purchasePrice) {
        this.purchasePrice = purchasePrice;
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

    public java.sql.Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(java.sql.Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
}
