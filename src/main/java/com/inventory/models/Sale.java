package com.inventory.models;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;

public class Sale implements Serializable {
    private static final long serialVersionUID = 1L;

    public enum PaymentMethod {
        CASH, UPI, CARD, NETBANKING, OTHER
    }

    public enum SaleStatus {
        pending, paid
    }

    private Integer saleId;
    private Integer customerId;
    private Integer userId;
    private Integer productId;
    private Integer distributorId;
    private Integer quantity = 1;
    private Integer subQuantity;
    private Timestamp saleDate;
    private BigDecimal discount = BigDecimal.ZERO;
    private BigDecimal totalAmount;
    private BigDecimal amountGivenByCustomer = BigDecimal.ZERO;
    private PaymentMethod paymentMethod;
    private SaleStatus status = SaleStatus.pending;
    private Timestamp createdAt;
    
    // DISPLAY FIELDS (NOT IN DATABASE, POPULATED VIA JOINS)
    private String customerName;
    private String productName;
    private String distributorName;

    public Sale() {
    }

    // GETTERS AND SETTERS
    public Integer getSaleId() {
        return saleId;
    }

    public void setSaleId(Integer saleId) {
        this.saleId = saleId;
    }

    public Integer getCustomerId() {
        return customerId;
    }

    public void setCustomerId(Integer customerId) {
        this.customerId = customerId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Integer getProductId() {
        return productId;
    }

    public void setProductId(Integer productId) {
        this.productId = productId;
    }

    public Integer getDistributorId() {
        return distributorId;
    }

    public void setDistributorId(Integer distributorId) {
        this.distributorId = distributorId;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public Integer getSubQuantity() {
        return subQuantity;
    }

    public void setSubQuantity(Integer subQuantity) {
        this.subQuantity = subQuantity;
    }

    public Timestamp getSaleDate() {
        return saleDate;
    }

    public void setSaleDate(Timestamp saleDate) {
        this.saleDate = saleDate;
    }

    public BigDecimal getDiscount() {
        return discount;
    }

    public void setDiscount(BigDecimal discount) {
        this.discount = discount;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public BigDecimal getAmountGivenByCustomer() {
        return amountGivenByCustomer;
    }

    public void setAmountGivenByCustomer(BigDecimal amountGivenByCustomer) {
        this.amountGivenByCustomer = amountGivenByCustomer;
    }

    public PaymentMethod getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(PaymentMethod paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public SaleStatus getStatus() {
        return status;
    }

    public void setStatus(SaleStatus status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getDistributorName() {
        return distributorName;
    }

    public void setDistributorName(String distributorName) {
        this.distributorName = distributorName;
    }
}