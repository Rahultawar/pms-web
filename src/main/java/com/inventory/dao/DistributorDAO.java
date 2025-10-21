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

    // GET ALL DISTRIBUTOR METHOD
    public List<Distributor> getAllDistributor() {
        List<Distributor> distributorList = new ArrayList<>();
        String query = "SELECT * FROM distributor";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query);
             ResultSet resultSet = statement.executeQuery()
        ) {
            while (resultSet.next()) {
                Distributor distributor = new Distributor();
                distributor.setDistributorId(resultSet.getInt("distributorId"));
                distributor.setDistributorName(resultSet.getString("distributorName"));
                distributor.setAddress(resultSet.getString("address"));
                distributor.setContactPerson(resultSet.getString("contactPerson"));
                distributor.setContactNumber(resultSet.getString("contactNumber"));
                distributor.setEmail(resultSet.getString("email"));
                distributor.setCity(resultSet.getString("city"));
                distributor.setState(resultSet.getString("state"));
                distributor.setPincode(resultSet.getString("pincode"));
                distributor.setCreatedAt(resultSet.getTimestamp("createdAt"));

                distributorList.add(distributor);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return distributorList;
    }

    // ADD DISTRIBUTOR METHOD
    public void addDistributor(Distributor distributor) {
        String query = "INSERT INTO distributor(distributorName, contactPerson, contactNumber, email, address, city, state, " +
                "pincode, createdAt) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)
        ) {
            statement.setString(1, distributor.getDistributorName());
            statement.setString(2, distributor.getContactPerson());
            statement.setString(3, distributor.getContactNumber());
            statement.setString(4, distributor.getEmail());
            statement.setString(5, distributor.getAddress());
            statement.setString(6, distributor.getCity());
            statement.setString(7, distributor.getState());
            statement.setString(8, distributor.getPincode());
            statement.setTimestamp(9, distributor.getCreatedAt());
            statement.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    // GET DISTRIBUTOR BY ID METHOD
    public Distributor getDistributorById(int distributorId) {
        Distributor distributor = null;
        String query = "SELECT * FROM distributor WHERE distributorId = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {

            statement.setInt(1, distributorId);
            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
                distributor = new Distributor();
                distributor.setDistributorId(resultSet.getInt("distributorId"));
                distributor.setDistributorName(resultSet.getString("distributorName"));
                distributor.setAddress(resultSet.getString("address"));
                distributor.setContactPerson(resultSet.getString("contactPerson"));
                distributor.setContactNumber(resultSet.getString("contactNumber"));
                distributor.setEmail(resultSet.getString("email"));
                distributor.setCity(resultSet.getString("city"));
                distributor.setState(resultSet.getString("state"));
                distributor.setPincode(resultSet.getString("pincode"));
                distributor.setCreatedAt(resultSet.getTimestamp("createdAt"));
            }
            resultSet.close();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return distributor;
    }

    // DELETE DISTRIBUTOR BY ID METHOD
    public int deleteDistributor(int distributorId) {
        String query = "DELETE FROM distributor WHERE distributorId = ?";
        int result = 0;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setInt(1, distributorId);
            result = statement.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return result;
    }

    // UPDATE DISTRIBUTOR METHOD
    public int updateDistributor(Distributor distributor) {
        int result = 0;
        String query = "UPDATE distributor SET distributorName = ?, contactPerson = ?, contactNumber = ?, email = ?, " +
                "address = ?, city = ?, state = ?, pincode = ? WHERE distributorId = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)
        ) {
            statement.setString(1, distributor.getDistributorName());
            statement.setString(2, distributor.getContactPerson());
            statement.setString(3, distributor.getContactNumber());
            statement.setString(4, distributor.getEmail());
            statement.setString(5, distributor.getAddress());
            statement.setString(6, distributor.getCity());
            statement.setString(7, distributor.getState());
            statement.setString(8, distributor.getPincode());
            statement.setInt(9, distributor.getDistributorId());

            result = statement.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return result;
    }

    // COUNT DISTRIBUTOR METHOD
    public int countDistributor() {
        int records = 0;
        String query = "SELECT COUNT(distributorId) AS total FROM distributor";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query);
             ResultSet resultSet = statement.executeQuery()) {
            if (resultSet.next()) {
                records = resultSet.getInt("total");
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return records;
    }

    public List<Distributor> getDistributorsPaginated(int offset, int noOfRecords) {
        List<Distributor> distributorList = new ArrayList<>();
        String query = "SELECT * FROM distributor LIMIT ? OFFSET ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setInt(1, noOfRecords);
            statement.setInt(2, offset);
            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                Distributor distributor = new Distributor();
                distributor.setDistributorId(resultSet.getInt("distributorId"));
                distributor.setDistributorName(resultSet.getString("distributorName"));
                distributor.setContactPerson(resultSet.getString("contactPerson"));
                distributor.setContactNumber(resultSet.getString("contactNumber"));
                distributor.setEmail(resultSet.getString("email"));
                distributor.setAddress(resultSet.getString("address"));
                distributor.setCreatedAt(resultSet.getTimestamp("createdAt"));
                distributorList.add(distributor);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return distributorList;
    }
}
