package com.inventory.dao;

import com.inventory.models.User;
import com.inventory.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {

    // REGISTER NEW USER
    public boolean registerUser(User user) {
        String query = "INSERT INTO user (userName, password, medicalStoreName, medicalStoreLogo) VALUES (?, ?, ?, ?)";
        
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {
            
            statement.setString(1, user.getUserName());
            statement.setString(2, user.getPassword());
            statement.setString(3, user.getMedicalStoreName());
            statement.setString(4, user.getMedicalStoreLogo());
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            throw new RuntimeException("Error registering user: " + e.getMessage(), e);
        }
    }

    // AUTHENTICATE USER
    public User authenticateUser(String userName, String password) {
        String query = "SELECT * FROM user WHERE userName = ? AND password = ?";
        User user = null;
        
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {
            
            statement.setString(1, userName);
            statement.setString(2, password);
            ResultSet resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                user = new User();
                user.setUserId(resultSet.getInt("userId"));
                user.setUserName(resultSet.getString("userName"));
                user.setPassword(resultSet.getString("password"));
                user.setMedicalStoreName(resultSet.getString("medicalStoreName"));
                user.setMedicalStoreLogo(resultSet.getString("medicalStoreLogo"));
            }
            
        } catch (SQLException e) {
            throw new RuntimeException("Error authenticating user: " + e.getMessage(), e);
        }
        
        return user;
    }

    // GET USER BY USERNAME
    public User getUserByUsername(String userName) {
        String query = "SELECT * FROM user WHERE userName = ?";
        User user = null;
        
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {
            
            statement.setString(1, userName);
            ResultSet resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                user = new User();
                user.setUserId(resultSet.getInt("userId"));
                user.setUserName(resultSet.getString("userName"));
                user.setPassword(resultSet.getString("password"));
                user.setMedicalStoreName(resultSet.getString("medicalStoreName"));
                user.setMedicalStoreLogo(resultSet.getString("medicalStoreLogo"));
            }
            
        } catch (SQLException e) {
            throw new RuntimeException("Error getting user by username: " + e.getMessage(), e);
        }
        
        return user;
    }

    // GET USER BY ID
    public User getUserById(int userId) {
        String query = "SELECT * FROM user WHERE userId = ?";
        User user = null;
        
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {
            
            statement.setInt(1, userId);
            ResultSet resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                user = new User();
                user.setUserId(resultSet.getInt("userId"));
                user.setUserName(resultSet.getString("userName"));
                user.setPassword(resultSet.getString("password"));
                user.setMedicalStoreName(resultSet.getString("medicalStoreName"));
                user.setMedicalStoreLogo(resultSet.getString("medicalStoreLogo"));
            }
            
        } catch (SQLException e) {
            throw new RuntimeException("Error getting user by ID: " + e.getMessage(), e);
        }
        
        return user;
    }

    // CHECK IF USERNAME EXISTS
    public boolean usernameExists(String userName) {
        String query = "SELECT COUNT(*) FROM user WHERE userName = ?";
        
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {
            
            statement.setString(1, userName);
            ResultSet resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                return resultSet.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            throw new RuntimeException("Error checking username existence: " + e.getMessage(), e);
        }
        
        return false;
    }

    public int getUserIdByUserName(String username){
        int userId = 0;
        try(Connection connection = DBConnection.getConnection()){
            PreparedStatement statement = connection.prepareStatement("SELECT userId FROM user WHERE userName = ?");
            statement.setString(1, username);
            ResultSet resultSet = statement.getResultSet();
            userId = resultSet.getInt(1);
        }catch (Exception e){
            
        }
        return (userId != 0) ? userId : 0;
    }
}
