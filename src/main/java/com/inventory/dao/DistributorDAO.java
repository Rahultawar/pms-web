package com.inventory.dao;

import com.inventory.models.Distributor;
import com.inventory.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DistributorDAO {

    // GET ALL DISTRIBUTORS BY USER ID
    public List<Distributor> getAllDistributor(int userId) {
        List<Distributor> distributorList = new ArrayList<>();
        String query = "SELECT * FROM distributor WHERE userId = ? ORDER BY distributorName ASC";
        
        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(query)) {
            
            statement.setInt(1, userId);
            
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    Distributor distributor = new Distributor();
                    distributor.setDistributorId(resultSet.getInt("distributorId"));
                    distributor.setDistributorName(resultSet.getString("distributorName"));
                    distributor.setContactPerson(resultSet.getString("contactPerson"));
                    distributor.setEmail(resultSet.getString("email"));
                    distributor.setPhone(resultSet.getString("phone"));
                    distributor.setAddress(resultSet.getString("address"));
                    distributor.setCity(resultSet.getString("city"));
                    distributor.setState(resultSet.getString("state"));
                    distributor.setPinCode(resultSet.getString("pinCode"));
                    distributor.setUserId(resultSet.getInt("userId"));
                    distributor.setCreatedAt(resultSet.getTimestamp("createdAt"));

                    distributorList.add(distributor);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error fetching distributors: " + e.getMessage(), e);
        }
        
        return distributorList;
    }

    // ADD DISTRIBUTOR METHOD
    public void addDistributor(Distributor distributor) {
        String query = "INSERT INTO distributor(distributorName, contactPerson, email, phone, address, city, state, pinCode, userId) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setString(1, distributor.getDistributorName());
            statement.setString(2, distributor.getContactPerson());
            statement.setString(3, distributor.getEmail());
            statement.setString(4, distributor.getPhone());
            statement.setString(5, distributor.getAddress());
            statement.setString(6, distributor.getCity());
            statement.setString(7, distributor.getState());
            statement.setString(8, distributor.getPinCode());
            statement.setInt(9, distributor.getUserId());
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error adding distributor: " + e.getMessage(), e);
        }
    }

    // GET DISTRIBUTOR BY ID METHOD - WITH USER VERIFICATION
    public Distributor getDistributorById(int distributorId, int userId) {
        Distributor distributor = null;
        String query = "SELECT * FROM distributor WHERE distributorId = ? AND userId = ?";

        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(query)) {

            statement.setInt(1, distributorId);
            statement.setInt(2, userId);
            
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    distributor = new Distributor();
                    distributor.setDistributorId(resultSet.getInt("distributorId"));
                    distributor.setUserId(resultSet.getInt("userId"));
                    distributor.setDistributorName(resultSet.getString("distributorName"));
                    distributor.setContactPerson(resultSet.getString("contactPerson"));
                    distributor.setEmail(resultSet.getString("email"));
                    distributor.setPhone(resultSet.getString("phone"));
                    distributor.setAddress(resultSet.getString("address"));
                    distributor.setCity(resultSet.getString("city"));
                    distributor.setState(resultSet.getString("state"));
                    distributor.setPinCode(resultSet.getString("pinCode"));
                    distributor.setCreatedAt(resultSet.getTimestamp("createdAt"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error fetching distributor: " + e.getMessage(), e);
        }
        return distributor;
    }

    // DELETE DISTRIBUTOR BY ID METHOD - WITH USER VERIFICATION
    public void deleteDistributor(int distributorId, int userId) {
        String query = "DELETE FROM distributor WHERE distributorId = ? AND userId = ?";
        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setInt(1, distributorId);
            statement.setInt(2, userId);
            statement.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    // UPDATE DISTRIBUTOR METHOD - WITH USER VERIFICATION
    public int updateDistributor(Distributor distributor) {
        int result = 0;
        String query = "UPDATE distributor SET distributorName = ?, contactPerson = ?, email = ?, phone = ?, address = ?, city = ?, state = ?, pinCode = ?, userId = ? WHERE distributorId = ? AND userId = ?";

        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setString(1, distributor.getDistributorName());
            statement.setString(2, distributor.getContactPerson());
            statement.setString(3, distributor.getEmail());
            statement.setString(4, distributor.getPhone());
            statement.setString(5, distributor.getAddress());
            statement.setString(6, distributor.getCity());
            statement.setString(7, distributor.getState());
            statement.setString(8, distributor.getPinCode());
            statement.setInt(9, distributor.getUserId());
            statement.setInt(10, distributor.getDistributorId());
            statement.setInt(11, distributor.getUserId()); // Verify ownership

            result = statement.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return result;
    }

    // COUNT DISTRIBUTOR METHOD
    public int countDistributor(int userId) {
        int records = 0;
        String query = "SELECT COUNT(distributorId) AS total FROM distributor WHERE userId = ?";
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

    // PAGINATION METHOD
    public List<Distributor> getDistributorsPaginated(int offset, int noOfRecords, int userId) {
        List<Distributor> distributorList = new ArrayList<>();
        String query = "SELECT * FROM distributor WHERE userId = ? LIMIT ? OFFSET ?";

        try (Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setInt(1, userId);
            statement.setInt(2, noOfRecords);
            statement.setInt(3, offset);
            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                Distributor distributor = new Distributor();
                distributor.setDistributorId(resultSet.getInt("distributorId"));
                distributor.setUserId(resultSet.getInt("userId"));
                distributor.setDistributorName(resultSet.getString("distributorName"));
                distributor.setContactPerson(resultSet.getString("contactPerson"));
                distributor.setEmail(resultSet.getString("email"));
                distributor.setPhone(resultSet.getString("phone"));
                distributor.setAddress(resultSet.getString("address"));
                distributor.setCity(resultSet.getString("city"));
                distributor.setState(resultSet.getString("state"));
                distributor.setPinCode(resultSet.getString("pinCode"));
                distributor.setCreatedAt(resultSet.getTimestamp("createdAt"));
                distributorList.add(distributor);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return distributorList;
    }
}
