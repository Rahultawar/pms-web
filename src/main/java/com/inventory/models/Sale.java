package com.inventory.models;

import javax.persistence.*;

import com.inventory.dao.ProductDAO;

import java.io.Serializable;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "sale", uniqueConstraints = @UniqueConstraint(name = "ux_sale_saleUuid", columnNames = "saleUuid"))
public class Sale implements Serializable {
    private static final long serialVersionUID = 1L;

    public enum SaleStatus {
        pending, completed
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "saleId", nullable = false)
    private Integer saleId;

    @Column(name = "saleUuid", length = 36, nullable = false, unique = true, updatable = false)
    private String saleUuid;

    @Column(name = "productId", nullable = false)
    private Integer productId;

    @Column(name = "distributorId")
    private Integer distributorId;

    @Column(name = "saleDate", nullable = false)
    private LocalDateTime saleDate;

    @Column(name = "quantity", nullable = false)
    private Integer quantity = 1;

    @Column(name = "discountAmount", precision = 10, scale = 2, nullable = false)
    private BigDecimal discountAmount = BigDecimal.ZERO;

    @Column(name = "totalAmount", precision = 12, scale = 2, insertable = false, updatable = false)
    private BigDecimal totalAmount;

    @Column(name = "amountGiven", precision = 12, scale = 2, nullable = false)
    private BigDecimal amountGiven = BigDecimal.ZERO;

    @Column(name = "paymentMethod", length = 50)
    private String paymentMethod;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", length = 16, nullable = false)
    private SaleStatus status = SaleStatus.pending;

    @Column(name = "customerName", length = 255)
    private String customerName;

    @Column(name = "mobileNumber", length = 20)
    private String mobileNumber;

    @Column(name = "deletedFlag", nullable = false)
    private Boolean deletedFlag = false;

    @Column(name = "createdAt", insertable = false, updatable = false)
    private LocalDateTime createdAt;

    public Sale() {
    }

    @PrePersist
    private void prePersist() {
        if (saleUuid == null || saleUuid.isBlank()) {
            saleUuid = UUID.randomUUID().toString();
        }
        if (saleDate == null) {
            saleDate = LocalDateTime.now();
        }
        if (discountAmount == null) {
            discountAmount = BigDecimal.ZERO;
        }
        if (amountGiven == null) {
            amountGiven = BigDecimal.ZERO;
        }
    }

    @Transient
    public BigDecimal computeExpectedTotal() {
        BigDecimal sellingPrice = ProductDAO.getSellingPriceById(productId);
        BigDecimal qty = BigDecimal.valueOf(quantity == null ? 0 : quantity);
        BigDecimal price = sellingPrice == null ? BigDecimal.ZERO : sellingPrice;
        BigDecimal discount = discountAmount == null ? BigDecimal.ZERO : discountAmount;
        BigDecimal calc = price.multiply(qty).subtract(discount);
        if (calc.compareTo(BigDecimal.ZERO) < 0) {
            return BigDecimal.ZERO.setScale(2, RoundingMode.HALF_UP);
        }
        return calc.setScale(2, RoundingMode.HALF_UP);
    }

    // GETTER / SETTER
    public Integer getSaleId() {
        return saleId;
    }

    public void setSaleId(Integer saleId) {
        this.saleId = saleId;
    }

    public String getSaleUuid() {
        return saleUuid;
    }

    public void setSaleUuid(String saleUuid) {
        this.saleUuid = saleUuid;
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

    public LocalDateTime getSaleDate() {
        return saleDate;
    }

    public void setSaleDate(LocalDateTime saleDate) {
        this.saleDate = saleDate;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(BigDecimal discountAmount) {
        this.discountAmount = discountAmount;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public BigDecimal getAmountGiven() {
        return amountGiven;
    }

    public void setAmountGiven(BigDecimal amountGiven) {
        this.amountGiven = amountGiven;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public SaleStatus getStatus() {
        return status;
    }

    public void setStatus(SaleStatus status) {
        this.status = status;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getMobileNumber() {
        return mobileNumber;
    }

    public void setMobileNumber(String mobileNumber) {
        this.mobileNumber = mobileNumber;
    }

    public Boolean getDeletedFlag() {
        return deletedFlag;
    }

    public void setDeletedFlag(Boolean deletedFlag) {
        this.deletedFlag = deletedFlag;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
}
