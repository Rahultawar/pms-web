package com.inventory.dao;

import com.inventory.models.User;
import com.inventory.utils.DBConnection;
import org.mindrot.jbcrypt.BCrypt;

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

            // HASH PASSWORD BEFORE STORING
            String hashedPassword = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt(12));

            statement.setString(1, user.getUserName());
            statement.setString(2, hashedPassword);
            statement.setString(3, user.getMedicalStoreName());
            statement.setString(4, user.getMedicalStoreLogo());

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            throw new RuntimeException("Error registering user: " + e.getMessage(), e);
        }
    }

    // AUTHENTICATE USER USING BCRYPT
    public User authenticateUser(String userName, String password) {

        String query = "SELECT * FROM user WHERE userName = ?";
        User user = null;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {

            statement.setString(1, userName);
            ResultSet rs = statement.executeQuery();

            if (rs.next()) {
                String storedHash = rs.getString("password");

                // VALIDATE PASSWORD
                if (BCrypt.checkpw(password, storedHash)) {
                    user = new User();
                    user.setUserId(rs.getInt("userId"));
                    user.setUserName(rs.getString("userName"));
                    user.setPassword(storedHash);
                    user.setMedicalStoreName(rs.getString("medicalStoreName"));
                    user.setMedicalStoreLogo(rs.getString("medicalStoreLogo"));
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error authenticating user: " + e.getMessage(), e);
        }

        return user;
    }

    // CHECK IF USERNAME EXISTS
    public boolean usernameExists(String userName) {

        String query = "SELECT COUNT(*) FROM user WHERE userName = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {

            statement.setString(1, userName);
            ResultSet rs = statement.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error checking username existence: " + e.getMessage(), e);
        }

        return false;
    }

    // GET USER BY USERNAME
    public User getUserByUsername(String userName) {

        String query = "SELECT * FROM user WHERE userName = ?";
        User user = null;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {

            statement.setString(1, userName);
            ResultSet rs = statement.executeQuery();

            if (rs.next()) {
                user = new User();
                user.setUserId(rs.getInt("userId"));
                user.setUserName(rs.getString("userName"));
                user.setPassword(rs.getString("password"));
                user.setMedicalStoreName(rs.getString("medicalStoreName"));
                user.setMedicalStoreLogo(rs.getString("medicalStoreLogo"));
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
            ResultSet rs = statement.executeQuery();

            if (rs.next()) {
                user = new User();
                user.setUserId(rs.getInt("userId"));
                user.setUserName(rs.getString("userName"));
                user.setPassword(rs.getString("password"));
                user.setMedicalStoreName(rs.getString("medicalStoreName"));
                user.setMedicalStoreLogo(rs.getString("medicalStoreLogo"));
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error getting user by ID: " + e.getMessage(), e);
        }

        return user;
    }

    // GET USER ID BY USERNAME
    public int getUserIdByUserName(String username) {

        String query = "SELECT userId FROM user WHERE userName = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {

            statement.setString(1, username);
            ResultSet rs = statement.executeQuery();

            if (rs.next()) {
                return rs.getInt("userId");
            }

        } catch (Exception e) {
            throw new RuntimeException("Error fetching userId: " + e.getMessage(), e);
        }
        return 0;
    }
}
