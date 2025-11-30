package com.inventory.dao;

import com.inventory.models.Customer;
import com.inventory.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO {

    // GET ALL CUSTOMERS METHOD - Filter by userId
    public List<Customer> getAllCustomers(int userId) {
        List<Customer> customerList = new ArrayList<>();

        String query = "SELECT * FROM customer WHERE userId = ?";
        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(query)) {

            statement.setInt(1, userId);
            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                Customer customer = new Customer();
                customer.setCustomerId(resultSet.getInt("customerId"));
                customer.setCustomerName(resultSet.getString("customerName"));
                customer.setContactNumber(resultSet.getString("contactNumber"));
                customer.setUserId(resultSet.getInt("userId"));
                customer.setCreatedAt(resultSet.getTimestamp("createdAt"));

                // ADD CUSTOMER TO LIST
                customerList.add(customer);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error fetching customers: " + e.getMessage(), e);
        }
        return customerList;
    }

    // ADD CUSTOMER METHOD
    public void addCustomer(Customer customer) {
        String query = "INSERT INTO customer (customerName, contactNumber, userId) VALUES (?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(query)) {

            statement.setString(1, customer.getCustomerName());
            statement.setString(2, customer.getContactNumber());
            statement.setInt(3, customer.getUserId());

            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error adding customer: " + e.getMessage(), e);
        }
    }

    // DELETE CUSTOMER BY ID METHOD - WITH USER VERIFICATION
    public void deleteCustomer(int customerId, int userId) {
        String query = "DELETE FROM customer WHERE customerId = ? AND userId = ?";
        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setInt(1, customerId);
            statement.setInt(2, userId);
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error deleting customer: " + e.getMessage(), e);
        }
    }

    // UPDATE CUSTOMER METHOD - WITH USER VERIFICATION
    public int updateCustomer(Customer customer) {
        int result = 0;
        String query = "UPDATE customer SET customerName = ?, contactNumber = ? WHERE customerId = ? AND userId = ?";

        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(query)) {

            statement.setString(1, customer.getCustomerName());
            statement.setString(2, customer.getContactNumber());
            statement.setInt(3, customer.getCustomerId());
            statement.setInt(4, customer.getUserId()); // Verify ownership

            result = statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error updating customer: " + e.getMessage(), e);
        }
        return result;
    }

    // GET CUSTOMER BY ID - WITH USER VERIFICATION
    public Customer getCustomerById(int customerId, int userId) {
        Customer customer = null;

        String query = "SELECT * FROM customer WHERE customerId = ? AND userId = ?";
        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(query)) {

            statement.setInt(1, customerId);
            statement.setInt(2, userId);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                customer = new Customer();
                customer.setCustomerId(resultSet.getInt("customerId"));
                customer.setCustomerName(resultSet.getString("customerName"));
                customer.setContactNumber(resultSet.getString("contactNumber"));
                customer.setUserId(resultSet.getInt("userId"));
                customer.setCreatedAt(resultSet.getTimestamp("createdAt"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error fetching customer: " + e.getMessage(), e);
        }
        return customer;
    }

    public List<Customer> getCustomersByUserId(int userId) {
    List<Customer> customerList = new ArrayList<>();
    String query = "SELECT * FROM customer WHERE userId = ? ORDER BY customerName ASC";
    
    try (Connection connection = DBConnection.getConnection();
         PreparedStatement statement = connection.prepareStatement(query)) {
        
        statement.setInt(1, userId);
        
        try (ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                Customer customer = new Customer();
                customer.setCustomerId(resultSet.getInt("customerId"));
                customer.setCustomerName(resultSet.getString("customerName"));
                customer.setUserId(resultSet.getInt("userId"));
                customer.setContactNumber(resultSet.getString("contactNumber"));
                customer.setCreatedAt(resultSet.getTimestamp("createdAt"));
                
                customerList.add(customer);
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
        throw new RuntimeException("Error fetching customers by userId: " + e.getMessage(), e);
    }
    
    return customerList;
}

    // COUNT CUSTOMERS
    public int countCustomers(int userId) {
        int records = 0;
        String query = "SELECT COUNT(customerId) AS total FROM customer WHERE userId = ?";
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
    public List<Customer> getCustomersPaginated(int offset, int noOfRecords, int userId) {
        List<Customer> list = new ArrayList<>();
        String query = "SELECT * FROM customer WHERE userId = ? LIMIT ? OFFSET ?";

        try (Connection connection = DBConnection.getConnection();
                PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, userId);
            ps.setInt(2, noOfRecords);
            ps.setInt(3, offset);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Customer customer = new Customer();
                customer.setCustomerId(rs.getInt("customerId"));
                customer.setCustomerName(rs.getString("customerName"));
                customer.setContactNumber(rs.getString("contactNumber"));
                list.add(customer);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
