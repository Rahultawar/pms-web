package com.inventory.dao;

import com.inventory.models.Sale;
import com.inventory.utils.HibernateUtil;
import org.hibernate.*;

import javax.persistence.EntityNotFoundException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

public class SaleDAO {
    private final SessionFactory sessionFactory;

    public SaleDAO() {
        this.sessionFactory = HibernateUtil.getSessionFactory();
    }

    // ADD SALE METHOD
    public Sale addSale(Sale sale) {
        Transaction transaction = null;
        try (Session session = sessionFactory.openSession()) {
            transaction = session.beginTransaction();

            if (sale.getQuantity() == null || sale.getQuantity() <= 0)
                throw new IllegalArgumentException("Quantity must be >= 1");
//            if (sale.getUnitPrice() == null)
//                throw new IllegalArgumentException("unitPrice required");
            if (sale.getDiscountAmount() == null)
                sale.setDiscountAmount(BigDecimal.ZERO);
            if (sale.getAmountGiven() == null)
                sale.setAmountGiven(BigDecimal.ZERO);

            session.save(sale);
            session.flush();
            session.refresh(sale);

            BigDecimal total = sale.computeExpectedTotal();
            BigDecimal given = sale.getAmountGiven();
            sale.setStatus(total.subtract(given).compareTo(BigDecimal.ZERO) <= 0
                    ? Sale.SaleStatus.completed
                    : Sale.SaleStatus.pending);
            session.flush();

            transaction.commit();
            return sale;
        } catch (RuntimeException ex) {
            if (transaction != null && transaction.isActive())
                transaction.rollback();
            throw ex;
        }
    }
//
//    // UPDATE SALE METHOD
//    public Sale updateSale(Sale sale) {
//        Transaction transaction = null;
//        try (Session session = sessionFactory.openSession()) {
//            transaction = session.beginTransaction();
//
//            Sale updatedSale = session.get(Sale.class, sale.getSaleId(), LockMode.PESSIMISTIC_WRITE);
//            if (updatedSale == null) {
//                throw new EntityNotFoundException("Sale not found: " + sale.getSaleId());
//            }
//
//            if (sale.getQuantity() == null || sale.getQuantity() <= 0)
//                throw new IllegalArgumentException("Quantity must be >= 1");
//            if (sale.getUnitPrice() == null)
//                throw new IllegalArgumentException("UnitPrice required");
//            if (sale.getDiscountAmount() == null)
//                sale.setDiscountAmount(BigDecimal.ZERO);
//            if (sale.getAmountGiven() == null)
//                sale.setAmountGiven(BigDecimal.ZERO);
//
//            updatedSale.setProductId(sale.getProductId());
//            updatedSale.setDistributorId(sale.getDistributorId());
//            updatedSale.setCustomerName(sale.getCustomerName());
//            updatedSale.setMobileNumber(sale.getMobileNumber());
//            updatedSale.setUnitPrice(sale.getUnitPrice());
//            updatedSale.setQuantity(sale.getQuantity());
//            updatedSale.setAmountGiven(sale.getAmountGiven());
//            updatedSale.setDiscountAmount(sale.getDiscountAmount());
//            updatedSale.setPaymentMethod(sale.getPaymentMethod());
//            updatedSale.setUnitsPerStrip(sale.getUnitsPerStrip());
//            updatedSale.setUnit(sale.getUnit());
//            updatedSale.setSaleDate(sale.getSaleDate());
//
//            BigDecimal total = updatedSale.computeExpectedTotal();
//            BigDecimal given = updatedSale.getAmountGiven();
//            updatedSale.setStatus(total.subtract(given).compareTo(BigDecimal.ZERO) <= 0 ? Sale.SaleStatus.completed
//                    : Sale.SaleStatus.pending);
//
//            session.flush();
//            transaction.commit();
//            return updatedSale;
//        } catch (RuntimeException ex) {
//            if (transaction != null && transaction.isActive())
//                transaction.rollback();
//            throw ex;
//        }
//    }
//
//    // DELETE SALE METHOD
//    public boolean deleteSale(Integer saleId) {
//        Transaction transaction = null;
//        try (Session session = sessionFactory.openSession()) {
//            transaction = session.beginTransaction();
//
//            Sale sale = session.get(Sale.class, saleId, LockMode.PESSIMISTIC_WRITE);
//            if (sale == null) {
//                transaction.commit();
//                return false;
//            }
//
//            if (Boolean.TRUE.equals(sale.getDeletedFlag())) {
//                transaction.commit();
//                return true;
//            }
//
//            sale.setDeletedFlag(true);
//            sale.setDeletedAt(LocalDateTime.now());
//            transaction.commit();
//            return true;
//        } catch (RuntimeException ex) {
//            if (transaction != null && transaction.isActive())
//                transaction.rollback();
//            throw ex;
//        }
//    }

    // GET ALL SALE METHOD
    public List<Sale> getAllSale() {
        try (Session session = sessionFactory.openSession()) {
            return session.createQuery("from Sale s where s.deletedFlag = false", Sale.class).getResultList();
        } catch (HibernateException ex) {
            throw new RuntimeException("Failed to get sales", ex);
        }
    }

    // GET SALE BY ID METHOD
    public Sale getSaleById(int saleId) {
        try (Session session = sessionFactory.openSession()) {
            return session.createQuery("from Sale s WHERE s.saleId = :saleId AND s.deletedFlag = false", Sale.class)
                    .setParameter("saleId", saleId)
                    .uniqueResult();
        } catch (HibernateException ex) {
            throw new RuntimeException("Failed to get sale id" + saleId);
        }
    }

    // COUNT SALE METHOD
    public int countSale() {
        try (Session session = sessionFactory.openSession()) {
            BigDecimal record = session
                    .createQuery("select sum(s.amountGiven) from Sale s where s.deletedFlag = false", BigDecimal.class)
                    .getSingleResult();
            System.out.println(record);
            return record == null ? 0 : record.intValue();
        } catch (HibernateException ex) {
            throw new RuntimeException("Failed to count sales", ex);
        }
    }

    // PAGINATION METHOD
    public List<Sale> getSalesPaginated(int offset, int limit) {
        try (Session session = sessionFactory.openSession()) {
            return session.createQuery("from Sale s where s.deletedFlag = false order by s.saleDate desc", Sale.class)
                    .setFirstResult(offset)
                    .setMaxResults(limit)
                    .getResultList();
        } catch (HibernateException ex) {
            throw new RuntimeException("Failed to get sales (paginated)", ex);
        }
    }
}
