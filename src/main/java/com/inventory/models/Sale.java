package com.inventory.models;

import javax.persistence.*;
import java.io.Serializable;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "sale", uniqueConstraints = @UniqueConstraint(name = "ux_sale_saleUuid", columnNames = "saleUuid"))
public class Sale implements Serializable {
    private static final long serialVersionUID = 1L;

    public enum SaleStatus {pending, completed}

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

    @Column(name = "unitsPerStrip")
    private Integer unitsPerStrip;

    @Column(name = "unit", length = 50)
    private String unit;

    @Column(name = "unitPrice", precision = 10, scale = 2, nullable = false)
    private BigDecimal unitPrice;

    @Column(name = "discountAmount", precision = 10, scale = 2, nullable = false)
    private BigDecimal discountAmount = BigDecimal.ZERO;

    // DB-generated stored column — read-only to JPA
    @Column(name = "totalAmount", precision = 12, scale = 2, insertable = false, updatable = false)
    private BigDecimal totalAmount;

    // Amount given by customer (editable)
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

    // soft-delete
    @Column(name = "deletedFlag", nullable = false)
    private Boolean deletedFlag = false;

    @Column(name = "deletedAt")
    private LocalDateTime deletedAt;

    // DB-managed timestamps
    @Column(name = "createdAt", insertable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updatedAt", insertable = false, updatable = false)
    private LocalDateTime updatedAt;

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

    /**
     * Compute expected total same as DB expression: round(quantity * unitPrice - discountAmount, 2)
     * Useful for server-side validation before persist/update.
     */
    @Transient
    public BigDecimal computeExpectedTotal() {
        BigDecimal qty = BigDecimal.valueOf(quantity == null ? 0 : quantity);
        BigDecimal price = unitPrice == null ? BigDecimal.ZERO : unitPrice;
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

    public void setSaleId(Integer saleId){
        this.saleId = saleId;
    }

    public String getSaleUuid() {
        return saleUuid;
    }

    public void setSaleUuid(String saleUuid) {
        this.saleUuid = saleUuid;
    } // avoid changing after persist

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

    public Integer getUnitsPerStrip() {
        return unitsPerStrip;
    }

    public void setUnitsPerStrip(Integer unitsPerStrip) {
        this.unitsPerStrip = unitsPerStrip;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }

    public BigDecimal getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(BigDecimal discountAmount) {
        this.discountAmount = discountAmount;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    } // read-only

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

    public LocalDateTime getDeletedAt() {
        return deletedAt;
    }

    public void setDeletedAt(LocalDateTime deletedAt) {
        this.deletedAt = deletedAt;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }
}
